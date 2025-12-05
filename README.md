# Foundry ERC20 介绍

本项目基于 Foundry 开发框架实现 ERC20 代币合约，包含合约开发、部署、测试全流程示例，适用于学习 Foundry 工具链的使用及 ERC20 标准合约的实践开发。

# 快速上手

## 环境要求

- [Git](https://git-scm.com/book/zh/v2/起步-安装-Git)验证安装成功：运行 `git --version`，若输出类似 `git version x.x.x` 的内容则说明安装完成。

- [Foundry](https://getfoundry.sh/)验证安装成功：运行 `forge --version`，若输出类似 `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)` 的内容则说明安装完成。

## 快速启动

```bash

git clone https://github.com/MiracleCS/foundry-ERC20
cd foundry-ERC20
forge install 
forge build
```



# 使用指南

## OpenZeppelin 相关

[OpenZeppelin 合约文档](https://docs.openzeppelin.com/contracts/4.x/)

[OpenZeppelin GitHub 仓库](https://github.com/OpenZeppelin/openzeppelin-contracts)

### 安装 OpenZeppelin 合约包

```bash
forge install OpenZeppelin/openzeppelin-contracts
```

## 启动本地节点
```bash
make anvil
```

## 部署合约

默认部署到本地节点，需提前在另一个终端中启动本地节点（执行上述 `make anvil` 命令）。

```bash

make deploy
```

## 部署到其他网络

详见下文「[部署到测试网/主网](https://www.doubao.cn)」章节。

## 测试合约


```bash

forge test
```

或执行分叉测试（需配置 SEPOLIA_RPC_URL 环境变量）：

```bash

forge test --fork-url $SEPOLIA_RPC_URL
```

### 测试覆盖率

```bash

forge coverage
```

# 部署到测试网/主网

1. 配置环境变量
        需设置 `SEPOLIA_RPC_URL` 和 `PRIVATE_KEY` 环境变量，可将其添加到 `.env` 文件中（参考 `.env.example` 示例文件）。`PRIVATE_KEY`：你的钱包账户私钥（如从 [MetaMask](https://metamask.io/) 中导出）。**注意：开发环境下，请使用无真实资产的测试账户私钥！**导出教程：[如何导出账户私钥](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key)

2. `SEPOLIA_RPC_URL`：Sepolia 测试网节点 URL，可从 [Alchemy](https://alchemy.com/?a=673c802981) 免费获取。

3. 获取测试网 ETH
        访问 [faucets.chain.link](https://faucets.chain.link/) 获取 Sepolia 测试网 ETH，成功后可在 MetaMask 中查看。

4. 部署合约
        `make deploy-sepolia`

## 执行脚本

合约部署到测试网或本地节点后，可执行相关脚本。示例如下：

本地环境使用 cast 发送交易（示例）：

```bash
cast send <ERC20合约地址> "transfer()"  --value 0.1ether --private-key <你的私钥> --rpc-url $SEPOLIA_RPC_URL
```

创建 ChainlinkVRF 订阅（示例）：

```bash

make createSubscription ARGS="--network sepolia"
```

## 估算 Gas 费用

可通过以下命令估算合约执行的 Gas 成本：

```bash

forge snapshot
```

执行完成后会生成 `.gas-snapshot` 文件，包含详细的 Gas 消耗数据。

# 代码格式化

执行以下命令格式化代码（遵循 Solidity 代码规范）：

```bash

forge fmt
```

# 致谢
感谢 Cyfrin 团队及 PatrickAlphaC 提供的优质课程资源，本项目基于课程内容整理实现，仅供学习参考。