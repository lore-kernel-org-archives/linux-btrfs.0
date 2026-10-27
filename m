Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085778;
	b=wTSiN3mMiIogJxdryjALLUHVzSfHdqdzmDha0Ccg7zzv3r7bdGbGdI/uhfMZdI2Smt8Z
	 O8bkJnLFhNzhFN2IBcP2nYjrIu//X/Vp+7zcRqTbnshfgSVptcqksCMtzxjNvxTc0lx2j
	 tprD/guvV8Lc2xvZ5CXxOp+xXtoZ/H2CbkvSN95mal0uLauJZtIZKR8gV2F/BRHmnUpck
	 oUkFp7+ViNQ+nZP3v52Flmzx6iiOQ0UK+NPkun2zgrZPg9s3vccYP3caRoOF/QcWKaaem
	 FYlOtlmv90u/6vPAMzAfOXmMNPvz5dVNKlnreu1rP3CsiPewIyhlDK5ohQjCeqKxs5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085778;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
	b=1Ling425MAh+3Sw9Aoe0dTH2fe4NoD0ye4Gs+PNSGcA0bG9a/kDaPmZfmT/k/LLkH7zW
	 FP8Pz/iUaSGWioQROTafYwn3iER+EJRYdSXSfwsnyPwwe819+3Jqxis3fgx279Z8ZN+zA
	 ULG63WeY+6EryuLBT8cR+OpyiEQMESPn4BpcABnVFlq5kYRAmwehDF76sdtUm9qGT36mr
	 6Ujg9bfkZn/cxSSD2wpsYQMW/OTTQS33kMptUvj+54ZC+9Q2+iFSY2LDX7n3LadyWNDVP
	 nWl8EbQVUds9b8GWSD0rvvwpF1xPj/hE3PkCPFRvIG8t1Ab1l6/1oqdg+xFjDGR0f/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qrU5vF8I;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=pGIbgU3f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC7606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:22:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84DC7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qrU5vF8I;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=pGIbgU3f
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085777; x=1824621777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n7Z3S3UVq77GFxPux0/6hqx9Zoiz0xtpnnqUlX9oMUo=;
  b=qrU5vF8IDSvOz0R5ibQxTroGqjVqd+4Rg4hYj70wpUFuzXTMDQAuN5vb
   qel3KcKrc5y7LVd/2QdoZq9nUDbMt+0giZwANgh8+LJmExAVpwibqK9oq
   j6Mw28Y4WIar/e7VHkD9LEnfInMbVKMz1brXCMtWkFMF+DutDheq+NmGd
   StnkNQS/jwJINM69A+LL/vZKKTJi2/+VtwXVSa0T0fREEuTYS7HPVfdDM
   lVA1YBIQn9SVC+GgyU64DQW/1YiI+SpCbthL7IcmlpUcX7n3yMNHFjY2m
   63XBNTSf1BSgyyEypUmJCDd1ybmYPSX8OKSXZXREc9ZITGwjYHwboYifg
   g==;
X-CSE-ConnectionGUID: 1dBtIqhqTo6H6I1X5ILUuA==
X-CSE-MsgGUID: fqBi8sTuQMu59kCdvI+kLQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863255"
Received: from mail-westus3azon11011018.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:22:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvMT3mcd9oPNrdGe5e4P0VcVN57TaIZx6snlTo16PqOACSeGJ2SDYUrtPLckrTkSj52HgL91wWxdoruulf3oAO1AhioI7G7igNccyQdd6o0+ME3h1yiVmj0RkBu5TsFhFpgf7mm+dRuGtoDqn4P+pX6Kn2778Tp1kia8P6zUh4OyyNLy9RE1PbSOUNwopVdameN4FiytsYH/MpdYyn6QC+/NtNQy/alXWZo6vEF2RrdN16fWR9nO9Dm8FO5g/iiPI3n7HkFaNH/KQxPACddtAYCIAWjUe5rlZyPYnujWvl8cOJKiOqbR1OnQT840yIbhSUVRiw43hjFE7RHmkDwaDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=WB2bJHcj938Sh4aKZl3PDGWqp1WNN6pUKcVXNHS7AQbUYVMsjiCX4c9Q5ATLSIqt35OG95QoqL4ROijwUJFfkM1jJqLXxwjEPkyD0n45mIy6isyvnJn2vvAk2svyMCDjTrwIUw8cHu387kyQJHwgII7hKnSytFMJ3QFxko+y789TZ530eTPYpuG8NRGmJ2zzMHjlXQDnNShQegtsUzaRKj7kRza0FEvnS/trpZ2aEqOWGgeJnWliIyUttSjGkzP2NPMsmZ7d9VTTOpRpsssTXtbVzLnxGSGZB08C4xOggKJEq3ntR0tTKYxjVv0/BI0vZquZdMwN6lTLRnECN+1cPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=pGIbgU3frKpIB9i9gGDr58GPiUrzms8GQIuMhwLXS7CZg3oKfTTzvM9bNWrKS53SjzT3rGmBwzLk9qNHjKsUP/QCQQOVVXlKQhdJMByqIOUkiF6DQXpPNyX7ODZy3ebu8oBuLtEsrUQTl2apy1CSL5Epk/rT/kKrzI3QHivdFeQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 08/25] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Tue, 27 Oct 2026 08:22:14 +0100
Message-ID: <20261027072232.419318-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: df83f279-26b3-4946-1217-08df33fb1ed2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	CRB0MpxVgal2vIdYmTEOhgNP3NvKywtLra9p7VziRXg0jwHUpSttclzz+2eaT4FzqwALMsGUZ/48ZnqLA57AP8kTYo+XK8MSnfUO60VtHTDnmO9gxGhyIyPDY7aHEuNcHS9nNeEH6tyq/cCXY3hhXVZo1UquMLr1yJ5J684u0BTOWY7tXz/8InPPri7hYnqY5pKUmik/9RdFnKshOlBpfb9iazK+0LSesJf2WtKAmOefYtUMYCT5KUdmMT7T81mb+rLtCaO3A71SMVQDJICSE5wZRw8GBp2xEB7O0UqOg0iqBU2SsIP7W5TfPdDHMGLqqDjymVGx2E3wOzNfVvKHai6v/a+D2zBSXZ/NFPIY0phW44tG9QiRtfxeFpOQEWKh/gThypTrg2d4dcjYVR2EfSvrNLOxoACr1qNzbpDXcDbfy7hsB1XEzWcNFIxkD4y5iGERTukAnYum1Avb9TKM1MOWCSZQaBb7ooN52MiWzXzZq4hKfIGNspQpsOuugWEV4Iadd0h/LNJHF+Jkl2+MKYbvb34ohtLERMTV+EOCv+BBdSw63pTGdAP3lYdl9xxUR8n7Ty5MzSJRIQ72i71PuxSrITgu5fqg8q3d28Fahzgoiyd5/iha10VbR+d/tWBEbpNqKYR40bxAV/H0V3aSd1e4t5HRuUcNLmjLgpwQLk8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G3y9tiUDjYdMDir7pj8PgQ69iKuNhxFZXz3S5riuYxTnpP6X3Dzg6F5Ax/vi?=
 =?us-ascii?Q?oRo3GVKw5uQPd0mkGAfD260WppHl2wU9pUX4j6qqRz8bR5QujI4QnAvVPeIo?=
 =?us-ascii?Q?xjmeOyZaH/OIxuSrsmnxnqt5+a54/Or5eNCgxDsFVovIc5bnxaAJ7MFUv7pa?=
 =?us-ascii?Q?M+CRQzcOtOD7O7N9mTTOm+mVB7YfyLj6zrCD6xmQw1SKucuKKZYUVHm5d3Lq?=
 =?us-ascii?Q?0Ou0NiI+/RoV3TvGUaxNisvLp7e03OV/5Ico1ywm+ZwAB//CrROR1VxuQ4re?=
 =?us-ascii?Q?f27d/mjBt7Y0dZQ4WipF+D5+7v7AOVqh+HFrl8uTlI7iWYEdE7g4/vnnQ5/F?=
 =?us-ascii?Q?3SczuvDAy/zldevuZZPd1VVtvTjIF/sVC2d5de/QQ3FJIIGzBX0P7VgiD3H8?=
 =?us-ascii?Q?/DrFRNaL6/6D+jWPCatsvKdEwPj4/Db20ePBuh3mJxaoMrSmfRqNW9y+Z6Fu?=
 =?us-ascii?Q?eQXn2bT7eWno+vZAfq4/AB61TvccJnufop9ewZlJHu+XNKxTgjxwXWpsqAyk?=
 =?us-ascii?Q?4ZSDn6mXzD181xWRe1yFO1DOJ75OkRLG4VEqYrFrUl5MXjzMVaaZFC+meeBW?=
 =?us-ascii?Q?/JIymawqxkuYG3Hat2Lz7DeCWwK4dwUDKjfTMhXuds2D4tuFcj4ppvDhcLdA?=
 =?us-ascii?Q?ZasKftor4LWzROT8nJ5oFHqRxQFxcvfJJh5Eur5lqz6ZRZBI4Npc5EYghSGJ?=
 =?us-ascii?Q?vhXs0JF88FMoYTxji3ImNMs3/sRl8Vh75w2FxK+YNSl20S4smNou179nESp3?=
 =?us-ascii?Q?taQrmXlNNsMAwHjxJ5+3u8h7GWBem5xKEvSC0lHKfCJPhNz3CWfuZIdcL2Y1?=
 =?us-ascii?Q?T9Rnj3nUloARNbzDI39FWDdC4/iU7dhqQ7ME1ajGyp9jLrxqt3TNep95egAh?=
 =?us-ascii?Q?Xkxl+r7dW7fxbFG3I9pLvftq9EVLeEzknKQew+1r9gJFEGNz5y4SV0bxlama?=
 =?us-ascii?Q?27xgHniUju9wEhZGsLtAfK9F6Riik9vMPUyJsggYBkg+WpX0FzaGudf2kIB2?=
 =?us-ascii?Q?5/5zqX3m1AQn9YBrLOEqZPauWmFzM1tZtvxPvPAhzyRhUc9Mdr9pnst3uVKJ?=
 =?us-ascii?Q?Hf7sC7MswEePW06U3+2+EYYhNskMubmep1HRVQbWEd9Qk0ar8Z2K/DxfSVlZ?=
 =?us-ascii?Q?SUv6V4HgvBaok/gh5WxkhgVvMTLFB/cH59OrkUYlTZ2QjBFf8mJuWnrq7h+P?=
 =?us-ascii?Q?/yGIL6dgH8iv8bj+aRL1OJZimS3TZmRr5y/EG9OSDnbc6Un1eqCiXhvO3EU1?=
 =?us-ascii?Q?mGswyHI7uecG442ab2YA+Vuql2YmNd/fQN/8MpVsZXCvfBSXBuyvo7F8n1gn?=
 =?us-ascii?Q?tARwhTM3wuPQzbN9zUcKH/PhkkF/cy2Fwx9qaSywluVQc0vPoQETzpyI60xp?=
 =?us-ascii?Q?seZuHqCTLLIF7IcJkS08xGxazN6/PFcjAIjm+Xi+IzpzJbS2NQdzSMwcTS7s?=
 =?us-ascii?Q?qk0COjqZAst9d6lQBkm8E3B4SBMlqxwK2Irg5iARrP+0TQLEsObXd6YwCUmb?=
 =?us-ascii?Q?3ykrxMQ8urojRdwNZUJRqlFjBrnT6j6sObq3Dp09Qj/FgtLa8N1XjHLQRhFz?=
 =?us-ascii?Q?7p0x8NgzCcNpj16w3HV0CfyXKvzX9UlWElOrmz2Hpu4F4iV/QVr6ukgiNKyA?=
 =?us-ascii?Q?i38eFg8Uv28G9rB2ne1CH8HY/rd4idJ/DWOAfItrForJK9WSNz/teXHcWfp3?=
 =?us-ascii?Q?cdqbJnuzIb2ABoLeu4RxN8OO5+tiqr+8Zgkx1SfH06NoURsEfSBHQ5+ILfny?=
 =?us-ascii?Q?mh49+eTkPRJlghSE4X9biGzmit5BFiJjUUvO933uyLQfiFXLhsKpC0B5jhoG?=
X-MS-Exchange-AntiSpam-MessageData-1: zu+cqx8PgYhbzemmKkYDFTM7w3uxWUqRXJs=
X-Exchange-RoutingPolicyChecked:
	CDCf5w+t69RHDOjBl84Ts52pqP9+++t+G+eQz6+IixFRv7cttudTFmD5Ce5/TRqBu2ui7+FdKTnSFHj7msCiiP7VHaogaTmFPvBgB8ntLG+ed3x2B46iOKTfwOdk5Wg/w2A+Sor3/T9xpZ5pOjp0T4gZQXj4zyRy4OpQbmoYWxnN8aSA811gmciuPSagw2pZk3OtSdmGKvUR5iHRX8x2HCNhkzRI6TKxxBzcMxcSJTJvij70Wd4lxUGzrEQDJrnSalDKlUi8Ce9fR2TjqYhAnUF62h8DoyMn9jrsmG6mZIXfXIxRw8bbYWmce8pb3Alg7vXeXkOvBNe6adtsmefGlQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4lCEHv1qISeXY9KIvTKLC0Y9M8arq5ih4xSgiR0+HDKXZMwlJ+d9BmkqLV66cg2UbLTeEDTGZiswkA1kcRMqEDStgPhtvyfqyJMOl6osY2OiRp/3HWO85/JpHZf7s+neam7D/Bt6VJHADUBwLnvgWoKXjnp8AiM725WixVIFlBt40Q6bBI5u3OWgEyUhXSwactFIXNC2zFu/XAY94krJ9xfI0Gg0jOwgK8xeZr+3ttrdkBy67mNL2ERMn2Bk5nxIpA/LWS3Io97MNZTFuu+CaUkrOLfKC21h6HJQ2jlkLYVILm45nyvGAqYVUkLJ1P+liYeHWshEweunSziYAD5ucTvF8Sasv3lqx6mClVriiptd3ScICR5PkjQnh04EDBMdKdaV65yyjWAUpjlEuQAyM/YKv09f+/PLlOPuJb8L+KAa/S1iFXDifVAtaGMrW7RvGe6h5nwzpqSQkYcExaDDzg9NWcM0IT7pzfzagd4xl3CdC9lVDMOmmDFu0t+CFH2Y5R3cqfqCh1pI4oN8laHE16wBd3TfRO7nuAmld0kEFNYc1VOHOf+O8fMszWXmX9/hFXfBnJIxyzkqr+vnznt3wQBOPHA1bDE2OghiHnzfIBsI79Hgnnez+NJF26Z9UIQ+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df83f279-26b3-4946-1217-08df33fb1ed2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:55.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ryh+MuLCxDXOI/c/pZ/x5kn6ATMzjHOEL+7yzD7hPkgNpRzDjT9pME1OYZxXyr+LC7taLBEn+wurmQnO4l7y6Twr+GH55DZx59wAxO4p2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

On a zoned filesystem metadata and system chunks are allocated from
both conventional and sequential zones. Metadata landing on a
sequential zone has to be written append only, in strict order and with
a queue depth of one, and freed tree blocks cannot be reused until the
whole block group is reclaimed.

Try to place metadata and system chunks on conventional zones instead.
The device extent search is first run with the conventional-only
restriction. If that does not yield enough devices for the requested
allocation profile, the search is repeated over all zones, keeping the
previous behaviour as the fallback.

Skip the restricted pass if none of the allocatable devices has any
conventional zones, e.g. on ZNS SSDs, so the device extent search is not
done twice for every metadata chunk.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h   | 20 ++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1fa4ee803251..76bd54af8720 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
+						const struct alloc_chunk_ctl *ctl)
+{
+	enum btrfs_zone_filter filter;
+	struct btrfs_device *device;
+
+	if (fs_devices->chunk_alloc_policy != BTRFS_CHUNK_ALLOC_ZONED)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	filter = BTRFS_ZONE_FILTER_CONV;
+
+	/* Avoid a pointless first pass if no device has such zones at all. */
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (btrfs_dev_has_zone_type(device, filter))
+			return filter;
+	}
+
+	return BTRFS_ZONE_FILTER_NONE;
+}
+
 static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			      struct alloc_chunk_ctl *ctl,
 			      struct btrfs_device_info *devices_info)
@@ -5905,11 +5928,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
+	enum btrfs_zone_filter filter = chunk_zone_filter(fs_devices, ctl);
 	int ret;
-	int ndevs = 0;
+	int ndevs;
 	u64 max_avail;
 	u64 dev_offset;
 
+again:
+	ndevs = 0;
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
@@ -5936,7 +5962,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5963,6 +5989,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 		devices_info[ndevs].dev = device;
 		++ndevs;
 	}
+
+	/*
+	 * Not enough free zones of the preferred type to satisfy the allocation
+	 * profile, fall back to searching all zones.
+	 */
+	if (filter != BTRFS_ZONE_FILTER_NONE &&
+	    rounddown(ndevs, ctl->devs_increment) < ctl->devs_min) {
+		filter = BTRFS_ZONE_FILTER_NONE;
+		goto again;
+	}
+
 	ctl->ndevs = ndevs;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 5f21a360f23f..e99786b29587 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -332,6 +332,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
 	return test_bit(pos >> zone_info->zone_size_shift, zone_info->seq_zones);
 }
 
+static inline bool btrfs_dev_has_zone_type(const struct btrfs_device *device,
+					   enum btrfs_zone_filter filter)
+{
+	const struct btrfs_zoned_device_info *zone_info = device->zone_info;
+
+	if (!zone_info)
+		return false;
+
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return !bitmap_full(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return !bitmap_empty(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
-- 
2.56.0

