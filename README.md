领域输入—》科学家论文图谱任务拆解：

1. 在5090上部署同义的dr模型 ✅

2. 配置并验证 DR 的联网搜索工具：实现dr的联网搜索：要配置 .env 文件里的 SERPER_KEY_ID, JINA_API_KEYS, 可能还有网页解析 / summarization服务 / sandbox／工具接口等 ；

3. 输入DR的领域目标→专家+论文元数据 Prompt：prompt即dr-agent的nl-query，实现特定内容的查找：科学家和相关的工作、履历、学历、所在机构等，还要有对应的论文工作。高质量的Markdown结果可以直接解析，不需要再 LLM 二次抽取；

4. 实现 Markdown → 结构化 JSON 的解析器：kg图数据库的schema应该与dr-agent的nl-query（from prompt）对齐，方便从信息的markdown/text到kg图数据库的schema，实现从markdown到json，markdown是dr-agent的output，json是图数据库的schema，必要可以调用llm进行提取；

5. Neo4j 写入：用定义好的节点和关系，填充json实例内容，构建知识图谱。