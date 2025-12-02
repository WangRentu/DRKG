#!/bin/bash
# ============================================================
# run_react_infer.sh （外部 vLLM 模式）
# ============================================================

# 1️⃣ 载入环境变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
# 工具模块禁用
DISABLE_TOOLS=true

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    echo "Please copy .env.example to .env and configure your settings"
    exit 1
fi

echo "Loading environment variables from .env..."
set -a
source "$ENV_FILE"
set +a

# 2️⃣ 基本校验
if [ -z "$API_BASE" ] || [ -z "$SUMMARY_MODEL_NAME" ]; then
    echo "Error: Missing API_BASE or SUMMARY_MODEL_NAME in .env"
    exit 1
fi

# 3️⃣ 健康检查
echo "Checking connection to vLLM at $API_BASE ..."
if curl -s -f "$API_BASE/models" \
     -H "Authorization: Bearer ${API_KEY}" \
     -H "Content-Type: application/json" \
     > /dev/null 2>&1; then
    echo "✅ Connection successful: vLLM API is reachable!"
else
    echo "❌ Failed to reach vLLM API at $API_BASE"
    echo "Please ensure vLLM is running on the target server/port."
    exit 1
fi

# 4️⃣ 启动推理
echo "==== Starting DeepResearch workflow (external vLLM mode) ===="
cd "$SCRIPT_DIR"

python -u run_multi_react.py \
  --dataset "$DATASET" \
  --output "$OUTPUT_PATH" \
  --max_workers "$MAX_WORKERS" \
  --model "$SUMMARY_MODEL_NAME" \
  --temperature "$TEMPERATURE" \
  --presence_penalty "$PRESENCE_PENALTY" \
  --total_splits "${WORLD_SIZE:-1}" \
  --worker_split $((${RANK:-0} + 1)) \
  --roll_out_count "$ROLLOUT_COUNT"

echo "✅ Inference complete."

