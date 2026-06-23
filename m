Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1C3D5666
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216793; cv=fail; b=R9go57wIM+WMVoLXTslHdczxv+Rtq42eCQMGbjfz2MPl8iz7ziW10Fq9/oCenR4sgeJKwNPR+85FhOdYAXS1WImq8LdlF3okZmtKNF8QyR1ywh8CMJs8Oqbq0WRI2HT9u5LA5ea+JSd6ZQPN6gNN/R7H8jwsUsxHXLKwrA50UX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216793; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=setlH1vPnkqn8LigHs3QHtAt5LfsKwuV6s8S+AFQ3UKGfcSzd/vLjKZHy3Yy7HLziRuIT0uA9n9fln14DMokoJ9jpliIixfRwIhU2N++EputClkEQdjnjsm1wxVYtlFKtVBwYAUWCVCm75Y7S2QIlx+/BqGS7IPLfBYYFYvM5L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CgRQx9el; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f7/a3Lk0; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CgRQx9el";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f7/a3Lk0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782216792; x=1813752792;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=CgRQx9elfJiz79rOvjl7kajRRf74T9EmBKvXP1ISeV2Nhi2I45UuiCUm
   jk4RNgvdNbR6fx0BdPT46KDd7/Q5GuGFYpWpW3cs2mTUiNWuN/lurPWmg
   bw14TrlCjLaqj4WNQRe/cMvKij+JqY6ECin06hQpMpxUx1LeznluX2kUP
   5pXgbwr+2u4ScupLemMkT7zb2z9HLfhVxYkD7mISywc+0ZY9vHUaG6q8s
   BubxBDTiwmzh5WUKLys76ly6bSPlevyjoLx0OOLwNRDxUJZXZh493mUAG
   MJ0Y+aB9CBXewedq1nwwOvCGy1SqSkbMvj/CwKDgB5TaXWtjLZdQSBvwU
   A==;
X-CSE-ConnectionGUID: WcRPB47sSnyBFfx/NElmTQ==
X-CSE-MsgGUID: D2QVsdXyTSW3v8DGaHIf6A==
X-IronPort-AV: E=Sophos;i="6.24,220,1774281600"; 
   d="scan'208";a="149670109"
Received: from mail-centralusazon11010045.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jun 2026 20:13:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuaUc+hgzTJrmNaSMXCicSOuxnkFDyM2CCYqpFF6CseF8J4hYxACsgfM+QMF2e3YhzmmkiWbj/tBUdAiiP/hzUqlUIbRNC3T4KfuBgE4/GY1nVLVocP4yShfkGZSygGP9GFom80LJqUG7JBwRpt/SBfhzVKXQCn0cmExMYKRBSlsg1RZ2xN9EhJ1YvPSvil6VO2YJNcU60e7TWvHW6hP1lok3CHDP0iMD/s18JRK5xSpCJbbRaKPDGj8Hgf+fiLqv5QD7HEcz8QR7G4yYlOT02wLdx9ircTzrJJmcD8Q1ZXHcTE98/zctbk2v1usvUxezShk4j7z+ZbO4lzwP7kcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=T4YSp1dr8pCvKlGwQ7Tng76n0l/VQSA/+y/MprECJuIuT2LQKaOgF2Txi3crEVOfAtBVzgcrwEsmhM5ZnfFiC9FsjFP7U2rQjJXBwhTv4nMRYEjvzLF9MMYnbHj4ADAeQKSQ8WDv8GfJcRXqXly0v4ngpiEBtRFI8BlLRWCDqn7X15s+YLf5YoN6vVv86hpzMjGhAg4/ZZPKxbPxzeBejKxldrYCef71oKKw1xLxaDb/iMhvSAbl0XwTqHwKYg2H28xP42n/V7qRI9oywU2hR+1FzNxYpiwYe2auIrdJ7ReNnNGWLLxbv8D6IdDy8vzzkaDeBX+60ffR5hwPivJL+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=f7/a3Lk0F9t3H8PPkx/cEsqE0bXN/vM4wBGGWDJo0bb97QXqx5kX+JfHe7pYMmICIl2moV0PqaasYtNlQmM1TPkV0UCDLznYk+XIozzAeMzUVithwP6uT91BPdgbkIaUt1rQVNV0vK0RK867Uq/wDADJ2QiL12MGCBKG2Y0pLcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6383.namprd04.prod.outlook.com (2603:10b6:208:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 12:13:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 12:13:09 +0000
Message-ID: <32479541-fab3-4b7d-b18f-28fad042610c@wdc.com>
Date: Tue, 23 Jun 2026 14:13:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: send: fix comment for
 SEND_MAX_DIR_UTIMES_CACHE_SIZE
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <6b47f0a447d1997cea8ef6e5dd6009a3df99fd33.1781541886.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <6b47f0a447d1997cea8ef6e5dd6009a3df99fd33.1781541886.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 07d73b66-2307-4ac2-9aa4-08ded120c9e2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	NjCw/mavO0Is1YvRWGXSZN8PILopCgZq6jX5u6wAeqLTARjjuZoq9lMs0T7VBmAAMl1UmXpoM0b40SOq8//EcsGW3m+O3O+UKnGQItgXu0idDjU4mz8LPsGLTipF3fQ+KrKVmWF9tfsmz/HOe5GGxHu2vM+U1sBMRnOo4vrVwmUl6ijpKH0kDvxxssJHpZEVwsxR9RTQ03qcUPoowGWpqq/j35m00K7Ne4/CAO4LqQh0RzZW5TKpqWJUiyjtjt829Tnw9y+xCdN1tmzph+ir/gE71uUo9gJpVTeeyotJjlOq3eDDhtey9zmqOk+2CWOwDmRx3VIvFWqN7djnvnTHvFIJ02RDAowFxoWBzH46nlAzh12CXxGiLZCe5CdGIP1wc0j7I4wgHX6+eBKvFJscOaI4mfxJNI4Y53LYPwVvFy2wcH1JpL7kzPaB8ssHR+2ehBQaPi8+85lhGGSsXHFjP5ykUrZZc5Vhn3RTM+INp7TFbi2CR5sifFFXoSEwSNeCPpkM9lJ/TybKHBHLyOLno+ep7qtOgXyZvC6wq55AYUKHqjqwTl5ZDXioJpjveGR289taTXwnktk01RLlISkt83VlO59dWHL5eMjksxENfN/vU4P7TS4qQWTWo3+RTn8C+sDFsVYbDP/WZwhh0R1chgjpjZhA6RQStHLFnDE1qW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2tiSzVjdW5OS0R0TkJJWEVieDQzdU1PU3FkU25nRXp5bEJLWGtLYldjU21X?=
 =?utf-8?B?RHJRaE1WVWt3NVVjTDZBUWtqWm9qbjAwdjUxSm1rRUFwUlc2VWpwQVFNSERT?=
 =?utf-8?B?Mm9NaG5YbkNSSkR3SEtuUDZLd3J3TnByTEtiWHFBVjFHUFY2WDFhMTJUYndN?=
 =?utf-8?B?VnVsRk5wWjVyTXBVMWlGZDl0ZG1GamRGK2FaTEQ3bGtmR3JubVRsMGZLUWpC?=
 =?utf-8?B?cTdncVJncHN3dEtlUjNPRHZwWDhxUlNGSlQvbWt0U2FYdFhEUDJkQ0VSV3VP?=
 =?utf-8?B?L1B5WGlkczZuM05xOGtXdGREaW5lOE5iaW1KVWdiUGhsNEJDNzNxRXh1Zzhu?=
 =?utf-8?B?YnZDZCtocWhQNE5nSnp6UGNJdHZUaytwTTJmWnFlNTZNM2VzWDEvU2NXNkxw?=
 =?utf-8?B?Q2pMZHFrYitKVVpscnFOL0ZxRjU1ckhXNFBuc1R6dm9McjIxdk5yWTNmeEM0?=
 =?utf-8?B?b2U0VHdGby95cjdmQ09QV1llaFlCQksvL25laDRLaHhBYjkrZXhscHRGN1JI?=
 =?utf-8?B?elExS29xNnlQL2Z0QS84UE1wRk1HM0laT2FyNmNkV3NPb1FSNURlYitPdzlZ?=
 =?utf-8?B?NGlySlhYaE54VU9ud2VFRzluU3ZTaGhBeXMybThEdmcwRVpLYkJxY2tSTXVD?=
 =?utf-8?B?VjFHdzNkbzk2cFZSOWpJUXpyQ1BaY1RHMStsaE4zdUR2VkFTTTdUejEveTFQ?=
 =?utf-8?B?SFpvR3M1WENlMUh5SnN1Ulg0Q205K0xqaDhaRU9oTzZ1VWY4cUw1cFhxNThD?=
 =?utf-8?B?UU5PUTJ4dWJwVVhxeVpGblpDZFUyQ3pRSEsxWWlrSVNRQ2xXUGZKc01MTExx?=
 =?utf-8?B?MmFKdytLTHRrRlE5YVlrc3VYVzU0cTBOVGNiNjdLR1B1Y1U1L0Mzb0FXQzNX?=
 =?utf-8?B?UE43MHN3Qy9ObDlybFpVcnVQOFhoZzNvVWV1ckRDMlAzUFBlNlA4d2NMRkFx?=
 =?utf-8?B?YnlzUTlTdEhzbmxpVkw0VWZZT09LYUlpSmZrUWZDS0oyaTI0QVIvNG44M3Nr?=
 =?utf-8?B?ZGZUcnA3eUtVMjBhZHU2K2dhWDlSL09zWVRUKy92WUczVStiNDMwNVFvZEhw?=
 =?utf-8?B?T3lrc3ZublczQ2thUWRPQ054VHQzRDFKMjI0UU9jWjFpc0IzTi9hMHhVZmxB?=
 =?utf-8?B?ak9ZMkdobFQycVI4dXlIT3RYUUMxaVIzMTNKV0JjUEVlQUJFU1pyWStienBJ?=
 =?utf-8?B?YWZNdEZISkR5ZU5PT2dSVjhIVlk3YnBsN2J1VlVISnpFM2FKeEhhb3pvL3dk?=
 =?utf-8?B?THVMMFA3Qy9JSG9nOE5LcEFtSjZ6cTJ3eHBBajRNYVIxY1NMbklxaVlvd2dT?=
 =?utf-8?B?N3N6dHAwb3haU2Raa0JMZTFadGtOZk5ZNm54SlBJUG8yS1pnWEpUaTQ3N1JY?=
 =?utf-8?B?aEt2WUkrU25yVjluNzhsU1NkRmxvcWJHVjAvckpqRVdGTDI3L1RUcVYzVFF4?=
 =?utf-8?B?SkwwMDNuVTZ3ZUtSQWZLbE05WDlST0pYdjZFaldKckljSDQ1NkJJeDRsbTY3?=
 =?utf-8?B?YUdOK0hKQ2xCMjhMWWYvYWpVQjFSNzFYcmpKQTRiaXpMWjBXeWMrYU1MTVlE?=
 =?utf-8?B?TDVpblpNWGhVVi9iR2NjR0k3blgrZmt6NXFmZGFxMDBPZ1AwTU84dHlyT1BF?=
 =?utf-8?B?OWtYdFZtaXRJQnE4YlpNM0hRd1ZodW0vL09JS1VOaVptdzFtbHhmWnVsOVBG?=
 =?utf-8?B?anJyY3dGZS9JVEd3ZlQvelQ0TUlZMEFoejAyVTN4TG9SZEJUQjdoMGJxclY4?=
 =?utf-8?B?RlVSTEhKdzVHYlRMcSs4WUlOSk0xL2p6Q3FURC9ISy9SRm9JdFM1aytrUHlT?=
 =?utf-8?B?TUo1RURwRk0zMFBJVGQraytHWS9BWHdJbVV6Z3lZMUI2NFRDQ0c5WnpqSGJu?=
 =?utf-8?B?TW9KNEtSTnVkTklUUU1vM2xUcVdLcFpzd21aNmIzT0Zndmw3MDZpVnFMcjQ2?=
 =?utf-8?B?T1JkOGZBQXdNT1FJMXRKdkhsdlpWdW43SEpqcnlyckJodmY3YUxVa2lsNElV?=
 =?utf-8?B?N2JWanAvSDMzNXpiVWx2Q2hKdnJsK1NtaE9yNUVkVjdkR0g5SHEyQlY0UVAw?=
 =?utf-8?B?eGEwb05icVBHZHNRd0tDQ3F4UHNtdE5DMVBjVTA4UVNrT29qMjZHcWN4TVdJ?=
 =?utf-8?B?QlJPWFR0VXJ2V0t6M1VZM3ZEdVNyQlViL1ZKZDVTVzZjSXpNSXFBMWd4aTlI?=
 =?utf-8?B?NTB5THlhUjBreWMzT0Q4ZnBlT1YrTFpKMVF0TW5wTlJjOVRDZlRYT1FVV0tZ?=
 =?utf-8?B?TXBZWE14MkN0Vi9lRDFlKzJualdSN3Q5OFAxR1NLeXZIR08yUDlMbStWZndl?=
 =?utf-8?B?b21FNXAwVXVxZVI5Q2RMeTZSNkRXbmFYcElSdDdwZ2diSW15Q1Vwd1E4d1Ru?=
 =?utf-8?Q?g0d0s93fefskMNZYmie0c9DCfs4luu9fgdMfvFlpwDeo4?=
X-MS-Exchange-AntiSpam-MessageData-1: hqNhPR3UMF8/fQ==
X-Exchange-RoutingPolicyChecked:
	fgset4No4X+9wVSRbkL4Z4vaevPzIED6EiqAeS7wtNYoZfJJxxqnuiYmGxLNX4WEw3B+chHAWENevCXhlzK++Od3QqbuY+lySrRviRHogM3PeVzzKXrTU5WJtsNEDb5/0/SiRltI/mXX5Dtw0L5jMwTywieLM5WhVO4eYT7L0To6RtG5xCQPiAYqwWXyK7fXQPjPHVbY0538JuwBjNABG+AlY8wPqwSsyTZgHiTGRz6025izLspfbXCf6PZ/E3VjwmmR0KvteAhQE9K4LAyk5aoUVr3IVSwMgda5InX2lj5SajbENYlUFAwGl5j4tbXrES6m9Ft5TKSiceHnDx/UWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xFYQx1j+KcrTnRLZ2RQos+w0mlEeiLhD1aE9EJkdcjWsYxEnbhThc5DNLtRg0MY1q03f2HAeeYOK4uK0jR9nZfbMjlmWGihENIaHTF4tpclqsX9ndszXl+dcrzShoC4Q4eekZN1negDAfm/9zXg+7Gxp9aq+7XjUy5MhMGrIG1byzJpsj3NiGD46BbJTx8LF2YoYUVYWIKYbcst4v7aKai+UAGzrp1qPBObxy6+PswidmzBO0CdYRzJzw8lWVZMHQ8G5dEMMk7tqfou+5N/6ADbw9MyL/w1UqdS8lqILuVb2a4BTak9NgFYwZoNY4thZTbkbnaYST/PpkUT4zruUtHsIaonM4/6KX9iXC3Kz4Qw3iJ5BX1R3UlV0WH1uSz0AUqdqbj/uuYNrTRZxUrX536mtpNi7yt7ZbB8YvfG++9reyt4lI4joUBMfVN1ou+fX1ps26TcaxfdlqiwZM+MPSTgrgSQgxP1j3UMoOwGbZBtVLxuwy/gf99jOQrTzUbV/rWA36JBv6KIxZEuNYRAvIRnCo2MSWC1mP6cUF+oELNf2IzWEbaWbOw862u/WwE4smkrC+KGYs4n1JIXCqL3oWVI5xTiq9igKv7zKdjZ7/Z19ojMvF+RevxcW5oR3ju9J
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d73b66-2307-4ac2-9aa4-08ded120c9e2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 12:13:09.1906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta+sK0mSnPwUvGZibCyHG1FmU1z1UVWifgwjnXoSLB9M0MVV3EMqYBGcHORTTpNl0hNIpgPcmmhgx3+Ts1WltQEAcXP5xQqB0JJtjXO0+gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6383

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

