Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793356815;
	b=Ka2OYihkqc8O0uFCkqbY7aKvydRxKnztYlCl5KgXBRUz4aJ4l0h89uiwgjf7iPzXBI6N
	 +OA/R8gbh8XjPXn2yYKYOSr8mym2DZ3Apwess2C5a+ujejjn91ZV1D4DWjcxGkoKaspqO
	 Z3986UfcxJnRiR3VJT9PLprNdOSytX0aleBoe9Wh7uTN4fKY3UIxFyM9mPD9VJA+Dk7KJ
	 jMwpvTN5qlJAQ5k6aVL7ZCNc/N/8zO0TtRGKGIUKxeAH6EzQPHm6oI25UbEgRxCIAJsVo
	 Q51TgCh5Z3HaX80SalW+EYUNVfIYx3EGrN5EIuLp37u7jo+tzjpAsA21oEg7XqdhlJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793356815;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=S/Idx9nPCv6NRuNcpqFrrNPQI/sPX8vWCrOexs7mTb4=;
	b=vwduGgTsNhV6CN7+zE6Xhv/f49mZ+8VXLEkVepmQ5xtXPRAwIfai/fB3SCNSy2rZdYu7
	 3O90itoGb6XLX2M8k1XDBbzAsKTyIaqHb33+RUL9W15VSf1w6T5LQrzlBHxLDHE3noZSQ
	 oaytKkb5QCHEiMue27+bpBLG0fhrCCLtV7UooEVnkpRiDRcum3ji+yAVdyWDfhYnuhThS
	 lc4w1BjMAs4dVRq2yoFaCOfbv/ZJOvyUepJ2oGVVp1rNKh+azVBJem8aDXLqGffAdoKxv
	 uatjS2G2QnPlpG0DPZDqPWMUyZvaP67QHh3WRM8+sHiQktVw06NtaLay9K6Q7uvB+Ng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=a6YVJDZu;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IXyRoH+W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A8606A31A;
	Fri, 30 Oct 2026 10:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D0A8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=a6YVJDZu;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IXyRoH+W
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793356822; x=1824892822;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oYdW/Zr/6jzvg7ku2hgucyvWlbePkoBrfk9x7y8qhOM=;
  b=a6YVJDZuju200XT5NIApZ1Z1OS8tz3hLYejoFhRn2p9uICY8MdOzMloS
   /BUc/q/2uGCZCUmin3XsN6ADT989RIwcONZzaCrHRavPdT7Bl5GCf342X
   nSRpc3X94whuq4RMz1Jv+bwiEoYHhcAFUBc9mbinbwROgxUn+uDqRX0+F
   bvU9ByCG4odEP30RQ8A9F1MAgOlmDchFZSCBDe3SEO+XCn+YTOuBlk0Ed
   Ganr9kyGVogtWcB9WMzbA6Be69DSIOJOUUSOz03qbA8T+oncUQfYRPCXB
   mcrRXYQgQu7oTfvaZTX3cTvuHqukrc+GAlJWKacHBevXX94fFK4QZMWDg
   Q==;
X-CSE-ConnectionGUID: PJ993PfKQiOu+UVS8fp+/A==
X-CSE-MsgGUID: fX7I1n3HRdesU9O1caBRGw==
X-IronPort-AV: E=Sophos;i="6.27,186,1786982400"; 
   d="scan'208";a="160372071"
Received: from mail-westus2azon11010026.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Oct 2026 18:40:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrNYqYreyC3OVDdmLq65SZ8duZanKcfAPZPZ2GwKESlvMZAUiGX4KlDu1s/uKdwhy1gzFdkUtwCmcpX8um8rWSRKtlCrsjHpnK838R4+L62D//MJMGeKEaCNTAqDe1yZaLNdIUvjZW0/f4XIr2hDQAdKvncFpvK2e7AtNU8rmWeFIyCbuPoncqk+qeIwgddsUvbGRwYIi7Wzi1xXtc/TBvsK5LBPb3rUNHpfxEJu0dQUm60KQdlpz5SsXgVWnfDxC9SATX4QxzOtt2VBBXhSb9x3Z8eOjZ0wTMDOkpYIFOaYDavarganE9ui1o/yZ4D83/ygZysEFuPCPkhn37vBYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/Idx9nPCv6NRuNcpqFrrNPQI/sPX8vWCrOexs7mTb4=;
 b=nJxolVDSeI0vu+khCdFMTLnTlxO4EzbdN8qnYytMx3UCoqYoRrfePfh5zFFgAe+tB5G3eJgqFkdW3gKbeOt8R4Xf03cV2ecvzep33b+k7hgezw0C/PkMPvIZrDR/xeb51gdcdz2HZZ/QBvZYQ4Kkx7iLUD0ePQEcUZadFh/+ZHx0X4ajBNtYx8WQ0oSQ45mHzsXFCGKP3ht+mLS7e3gMobYimFMKHSe2yP98nbB68eiFVQLSQbPeYOsW9BG6NVkMYiUyOsc8wlvvckPnuLYGO0dKqV3b/RM3Z7ELNKjVeTdRVeVV3Z798CzavEuJlYjADhP98SltD0uUK9m5YqF5Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/Idx9nPCv6NRuNcpqFrrNPQI/sPX8vWCrOexs7mTb4=;
 b=IXyRoH+WZBp1+QW6Ij4HAgP0zHId2O09UXfWMdJFNRA36j+J6957cJmsX5ESiGG+kGhMlVZ50i6Rpsbc/VJy7nGoOOJPLwj5w4UOp7gP+GinDJbEB8zxfTJCZXr9LTsre8pcRfPkbY8M6UjtosGu32EKUFcDiYBuBcRBYPXjluA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7610.namprd04.prod.outlook.com (2603:10b6:806:135::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 10:40:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Fri, 30 Oct 2026
 10:40:11 +0000
Message-ID: <0feb0d5f-cb66-414d-8405-c3e57da41395@wdc.com>
Date: Fri, 30 Oct 2026 11:40:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: zoned: fix silent data loss from leaked active
 zone reservation
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
 <CAEmTpZHvmyPWMFztcG4MT4jszwjXYuwogJKrJgvx2vxESjhnKg@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAEmTpZHvmyPWMFztcG4MT4jszwjXYuwogJKrJgvx2vxESjhnKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: e4966cf0-8438-4728-c17b-08df36722c8a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|376014|366016|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|261026121527099003|261026140227099003|261028144727099003|10067099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	Qhfupn3ryH7uJF4EG+fVgmXUnvthY0lqpGSQ3p+Gxpo9tSF/2Jr7q+dL2GJVr5vP6XP3Z/7QK8NgsomT7bSp4tADLS28rPy/kAcfxNoC0zJGzHQs1sZ95U+xE6DiZ36OoMyYVznfFsNljJ/uzG9p1WtTAYdFdzaB0AFzWvCX5J3yfJPpf0FiJerRbDVSahhQASxIweGoMQzuCwXCaJfQJIpLvxGUM2ofpylbtB2uMiQMVZ1yDLbC5f8gAPyJ7xQPc16KAeWK1Zr6YihOz/uS3dXOatGO+ph6+Fn6nxC1WK4pzfrTAK0M3EZ+ZxrdtEKX1u1TbEu0iichhJWywAcfGo4lbxytLaB6TK2R2FwGT97moJOiwDtyem511amVdww1dLYyjuN/aJ8DkW8H7Xo+xBsoB5GoVkp0zvVq9epCLKWVxxtx4OJ3XUeZhYbdSKludhJb7wpETH4RsYEq0+E+9GhrnLX0VtuqbvMj6C/KfAF+ZIs28VGIgCYKtucNaVZm/2y0JmyJ+KWEzkIuQFxVfBXLX2Z1Kda+WJ7nLCFQ9rrSDJb2q19MFyUA6CuaJRtxcDsT1g97v0ie0bIh6jKu285iCKKoo9PaRsZcfGDzag1EKgY1/Vp8x4e9wNI6l9gyZFPH5VfIEi5TDTibIjrOaLDGmbsfqNp6xV1Xf4ghuTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261026140227099003)(261028144727099003)(10067099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVBPNUplSXljZzVOZFlwc1ozTTFack9FbkFOM3Y4dWpKVndaSjBnTW1jdlNa?=
 =?utf-8?B?YWFBWUdCNmUxNHA1VTJjMWNIMmJWbUZZaGxDb3ZkWTcySTV4ZCsvOGY5OFpv?=
 =?utf-8?B?eVNsZmYyM283R2hwS2JlbFVnYVBnVTBoQ0VEWXRXM0ZIVW1IMWhMSW9aV2M2?=
 =?utf-8?B?WVpnWm5wRHQwWkdLYk1wVUF5aUszMHJVNHhMU0N3SU5Xam9Dd3ZQMXhWeXN2?=
 =?utf-8?B?NGlER2l6SGY0QW1kajRPci94czlWeEtDZFdKaDMvcjlzd2RDNkhTRWtzd0ZZ?=
 =?utf-8?B?dDRoSW1veWMrdEc5S3RGckpJc1ZEVDJBOWRkWml3MnJnMTZaWTVMNmdUaUxB?=
 =?utf-8?B?Qjd5RFFjRTZtMnZpYmJwclkrdXNnV0NyS01mdmZWRms5dkRLU2hsQVpTYVJR?=
 =?utf-8?B?RjhqZ3RUWnErbitKZHBjT0RjVzZsT05qVndJei80ZFFoSGkxNENHajJiOVBt?=
 =?utf-8?B?Nmg3Y3ZiM2ZYNFhvZ2pSUmMzTEk0T1RWc3BBUExwV2pvbytuME5Kb2lLV0Mr?=
 =?utf-8?B?Tll2L1NXTlNjcGxRT2FMZVBvdHNKRHFWVjBMUm9tUXdMWVk4UVJ6SDVLZWFs?=
 =?utf-8?B?NlZVOEZlZVdwL0NrenpLWmtjUndyZU1RZVlsRU94aXI0Zlo1eitaK3ptM1hP?=
 =?utf-8?B?ZjhDL0pCcWFHVUJaV2lLeVh1R3poejVmYlVVRDFxMW5JVGlOUFY5V2ZnNVhn?=
 =?utf-8?B?M3lYY0xVMmRHVld5bC9MZUhyUlU4Q1pnOGdoN3B1NjBYaGtCVnZibktRUXdW?=
 =?utf-8?B?ZzAycTRoM1ZlTnFqSmJSTktoSzZsTHAxcXRZVEVhQ3VNKzJzTzBSVmw4Y1FH?=
 =?utf-8?B?N1YzdGdZZ1UvdW8rRzlxczZhOGdiYi9ram1WL21ML3FDN2lOZ1Q0OGNqWjFQ?=
 =?utf-8?B?N2RLSERWZ1JVT2x6VGM4N3VZSVlENks1T2RzSkdSL1lxUEs5Tko4cjhwMmNs?=
 =?utf-8?B?QzFyR2ZZQ1NKVTF0LzVYSms5N2QvL0pWYnRTRkV4TnlFa0NzeGRaR1F0VnBE?=
 =?utf-8?B?eTdvckgwK0RTZGFNTU5JUnhQci9GMUMzVUxRU094UEZ2Yi82SGpiWSt0cVdD?=
 =?utf-8?B?S3JjQkcvaktXVThldG1lMGh1dGY0L3UrbXFpVlcveHZlUjJaTDBVR0g1MmR5?=
 =?utf-8?B?TWkyK0tnS1JKR1BpZ2s3NUpNYm9uSDd6ZlUvU3dybUFLTER1MTVqNG9QMkZU?=
 =?utf-8?B?b2kzRmZWZkxzYWZFeXlOS0V1R1Rra01BZ0dWeDJwbkM1dFhpNjNKSzUyM3Jy?=
 =?utf-8?B?MEVIRzFzZUJHQ3BqakFWUVppYlRPU2pTSytta0VzcHhTejZpWTlXVVRUYkFy?=
 =?utf-8?B?MU5EOENqOVRxcys5MUdTR2l5enhOdlBJL1FGM1lrSzQ0Uld6cllWazZLMFQ0?=
 =?utf-8?B?Y21UZUh0SWYyVUFzWVR2c3UzNGpXOHozTkhDUE5XTDIwZFFjQWluQlcyUTJq?=
 =?utf-8?B?TzA4U3NCbEtud3NkMFFKT29sdzFTejVYazFuR083aEFwaEZWdldwdFZlMXdP?=
 =?utf-8?B?ZkVCamlmdlNvWDhocmRmSDJRbVZPUGcrWTlHQzZjbExkOFpLZU9OU1NYM2RH?=
 =?utf-8?B?TTQvWHBqWW4xM29sYzBxL3Vxek0rVG1xdldsLzdOOGhvbmd3Z29pUTg1SmRa?=
 =?utf-8?B?ckNnY3QvVllRZ3dqWCsvbXozREYyS3ZDcy81c0VOV1dLYjhnQ24yM3d2dmFn?=
 =?utf-8?B?WmJ1RlRhRzlUZWliVGI3dm81aE9sOElGYUlKcmRtTFlLMmY0YUtmVDJzM3pv?=
 =?utf-8?B?VGNKdkFrakdvMVl3SUtoMHN5blNIbWRzdlZqK2VtaS9MR0RJM0hHdFFCWUlS?=
 =?utf-8?B?S2J6azlZVnR0Q1p6Wk9idkRWZFEwNjB3c0VUZVFhNHZOdC84UDlwQWU5ZkRp?=
 =?utf-8?B?SE9tMWtoeUh3c3lyc3FoTVhhOUMxT0NXSlJHTmR5NnZFR0lwU0JFU1JDa3ZJ?=
 =?utf-8?B?bDNRbGtzcU5PWGJVSVAzbmlDbUd0L2o5R2ZZRjd6UWlJL1ZIRllKUWdUMG5F?=
 =?utf-8?B?b3VJSHNuTXlUSE02TStVLzAxK3ZFM3ZiRHU0bVVyQzRBbkdZcTBwT2x4TmVB?=
 =?utf-8?B?NzZQY0ZKeHFoVitpSzh3M3NkRGd3SnRVTCtQcHhVUGJYMnBMVWM0WnRtdjBz?=
 =?utf-8?B?Qy9FOEhqaEoyMHluejlzcXJSVGdrN2ZkN1VWYmxXak5iWDZzcEdzcUN6bkNQ?=
 =?utf-8?B?V1lUd080TU1BbWU3VnVKQWkvQm1kSk5qeDhpak5NbEo1RUZsMWZubDRTaUVY?=
 =?utf-8?B?bWtlcGtQV3AvOXMvdzZtS3ZERW9RV0JZVFJZRlFMaW1rRGFnU0ZjdmxuV004?=
 =?utf-8?B?VGQ0dmM1cmNiOWFCL0RLVEFVbkdwYndKcU5FTjJJMUZNRUJjM3JYSnFyZ2Zn?=
 =?utf-8?Q?usOTl2YJiwIirH3WBLWFC+a3viQzn+7KVrZzm0TMRaXUc?=
X-MS-Exchange-AntiSpam-MessageData-1: Pp3Argr+q2u7gB5+qGO/BoPiXdsI6geSLBI=
X-Exchange-RoutingPolicyChecked:
	0JVM0tBlSxO5RPGaP53U0aeukWcV9bYFfQuxtw61f7D5qtBhIMFegIGSWfJSbdhVKvvqLBXBp8RJxk8QDnjn7QLwfmEal3UgaKxPEE3dknSlenb24iUevC57vLEBdDlF2/INV1CQkWJwu+F6IXJ/p8QK/trzjaCuETHS/RLRDMUjjlDryG8ptM6v9Q9xAfSlKIxE5/rIuc5t060wiXzcC+vdl5uExUSmu5necaeY3jNcVifJmFwIf7q8/oMFiqyA5FePrGsh2sPoMSaP3k46U0BrgLDr8O3Gvh+hlcdI0is2wu6QWYB/nK+1cowwlvlkJ7AQq9/zaMrkpQTahi2IRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mQD660OIJShtXamMxUmMtB2C2ZXIQGYPANqoxGczlD6GWKO9tB17bConCYmjHFUgfdJhN09Cg0MTRw/OVgyWb9YJ1v0kO3yGZzjJIkC7T6+5BARkpxFJl7fNtExXoExNf6m8oL5cVlUsblra4WzrdinxZYotm4nvkqj7BvZH3fAkpUAdackYZdPqNvJPuTX6mLhQw+WNXbnc8oAJNrLuSOYN74UXZB792dGgP/Jd93i8AIhV8n3RmSwMMY1xkw/8xL3scyLfYm7gi8UbTxpeF/lquoU4jR6RmSovezpVUM7R6RM6YIbQ5vabE4GA2TQirs0/Dy1v018+mx9MR3aG5MyEM8h1JxRAjq2A+bhueUjwco73jHU34nPPUdU0z6TAl9X9fzlGOL1btd0dnvQb8IWLxNmMs4N5Xm6lZZcjWhEuSrHrT1chNutHFtW1FzJP952TvUN8t5p7EcRsKpvEbiKIbS8kPcuVQ5wYPBwLK7g7JYIqAccsXkX8FfYLIX3OAAvoFV4Zs8PyHFGm4mYUF/oJOp1ZmtNdx5cOCjkbAdDL4iV1IIg5xTHmKE9jdB8aYOLtUUpFWaMqaT9i4+Gi1CSOQVgePoI6u18QnSLgacjwzuhl/weypbGSZcOeVyMY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4966cf0-8438-4728-c17b-08df36722c8a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 10:40:11.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzOTDy4C5PruL8aTCxeulQikcW+/5LbhLE3TH1HDZOpEPd0vRQK4aTn2Q0UqNLZz8kqKnpIV7Gb19rohrel+2xBx/rGn2pLAZnT8cd0ujAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7610

On 10/29/26 11:00 AM, Марк Коренберг wrote:
> Adding Johannes, as this overlaps with his recent zoned work.
Thanks, I won't be able to review these patches today and I'm off next 
week. So please be patient, they're still on my todo list.
> A few notes on how this series relates to what is in btrfs for-next and
> on the list:
>
> - The series is based on master, but it applies cleanly to btrfs
>    for-next as of today (c393445c12fc), only with line offsets.
>
> - 0be761ecf1a9 ("btrfs: zoned: only change active zone counter on
>    successful (de)activation") in for-next does not cover the leak fixed
>    by patch 1: the block group removed by relocation gets its active bit
>    cleared by the zone reset in btrfs_relocate_chunk_finish(), but
>    reserved_active_zones is only given back in call_zone_finish(), which
>    never runs for it.
>
> - Patch 2 makes btrfs_zone_finish_one_bg() the normal path again when
>    buffered writeback runs out of active zones with a negative
>    reservation (cow_file_range() -> btrfs_reserve_extent() ->
>    find_free_extent() -> btrfs_zone_finish_one_bg()). That is the path
>    of the deadlock fixed by "btrfs: zoned: don't wait for ordered extents
>    in do_zone_finish()" (30c6d31da683 in for-next), so for stable patch 2
>    should go together with that one.
>
> - Patch 1 and "[PATCH v6 21/25] btrfs: zoned: reuse block groups emptied
>    by reclaim as relocation target" both change
>    btrfs_relocate_chunk_finish(). The conflict is trivial, and the two
>    fit together: btrfs_zoned_can_reuse_bg() requires the block group not
>    to be active, which patch 1 makes sure of, so the
>    btrfs_zone_finish_relocated() call has to stay before the reuse check.
>
> I can resend the series on top of for-next, or on top of the generic/747
> series, if that makes it easier to take.


I think it'll take a bit longer to get the generic/747 series reviewed, 
it's pretty huge and zoned mode isn't the highest review priority.

Thanks for helping to improve zoned :)

