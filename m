Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794292914;
	b=XDg5DtBL5a3FpIVGwj1HPkJL5hmxjMUW3bOkepykTpAoKTL0okn+0f43po5hpbnUgQCN
	 AlV+pnYTjVFgMoQd9pfGoiFzKcSMMs69055nLi/oU/mgjuMSVIpRG6IO40nGW3i5zzRvK
	 eG7ly6NlIm8xxiMNbNEL63424m2GN+vheWeQz6MnT2BbaMO0FsbirurInTF3shq2AoaBa
	 SLUFYyDScjiqchdalFqqbBpm5QVxnolocdDCCLQVLgsK9AO6h+TGFR6uH0MduT2V91KSI
	 2vonMO49WVV6DlVpcKDlHVqXCRdqhdQm9M+3h1cROycp9E6KMaUy8w3U/YNjJV95qcw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292914;
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
	bh=+5OcAOJGUjW6e/azifjx3FhvJUhdgEpkJyHLYNIPAPk=;
	b=O9Npz2sF2MACz3ycy5Fa8x8SV6baK4LpLnbRH4MkN2ywuHzrm0tIeeeOSHIJ2w1tRgLQ
	 U8RE0akTOrZvK8ZxZ3bumU9XiQq/9gmXKpY1lt2AcQ59MF+fAu5pS30uFzRQhmN+lnlAB
	 B3oy5+P0CUX1oEv6ugqJBrFIWc+KsEsmB49qo6zMtui373CqODM6IH57lE57OFOYSlmtG
	 P/hZQj/ehA0KtOImJRKTDpqmJYm/7E6sI+v1lahL4dra2BmHcmpS0JBwWKmDgBM8eM7nW
	 qQujHfrc7UVcihIeaXiynULohU8FrTAbqKixZTy61/vEN0OTYDVCqjDnqffCV9EwCVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UqRSbesO;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k3MGBi5Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7206D606D5E5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7206D606D5E5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=UqRSbesO;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k3MGBi5Y
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794292913; x=1825828913;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8+1IBN6RpvKyI5xyVgOJbQ24qsk96BVS5OVQznT6npM=;
  b=UqRSbesOOtWYjz5TaXX1zimWhprduXAD33dzMZmLRp5bVDol7xjkCgsN
   qLPZ+lTicE7cjYkLdKOC3H4Mu1ls5HtXUtv+yylmPy9MRrbbvJZtQGEh6
   5aSmxIXQTU8clzTphM8tb8Ws6pLZXXaxyJBGTqzBtAJn9hCLXt1bFFKey
   5DdwQ7bJUxoQxphHxe+75AP9XSWjB9ryUSvscu9Oc0CbU00MNIeHV2/x3
   d76gFTF+fSk+nqkvKMIiW1W2ZTTrpX9AZqB2Qart2YjrfKZkxmLDmeZ0g
   0yzSzzzU2b6EBGEwhrIAGGCcjTIdGkwnHQsSYGJa2sy9/5hhNXkALQBAu
   Q==;
X-CSE-ConnectionGUID: k3Ae5NigQOGXNC5dFxpvKA==
X-CSE-MsgGUID: exbR1w+XSAS+0X3oF+U2Hw==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158876908"
Received: from mail-eastus2azon11010047.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 14:41:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrOnQ39f6C+1uwkJzhnSryx8Asvhb0WYGyCW/I+cv8mAVxVK4YY0gAHN+WRNQceGJ5UmvQgS9QS1Qeecbe4aBZiVgqD8BH3V0MbmWLqFlu7sIyzQ5Fb5WLCUAHwIDs0wD+3mr8DUJ3Nr8TPnibKD+4oqOXZxryYHttfB3aqBAbZ1YK8YqMjYSBpwB0Qf6QsJzUVsauJXxlVUU+wPimvrG7pXdu5vyhVOp1UPZ9JuMzdO4JTSwYwlCxhRuKNwGoFuoqn0ul9uXvV/VAvOGJ2/b8A8Jssg4V3LE6RkYKw7+jSH6tvx/heSvm9hB6+MaSbALlQ8HVg62QEsRnTEQdyOsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5OcAOJGUjW6e/azifjx3FhvJUhdgEpkJyHLYNIPAPk=;
 b=zOz4eU3PVM4IF4mE6rDGS+u4fizkye/48BqQJLcaHezMW++U5WWFhqypbIOScAeK4mHT9LZiXdK6h9kaqlerDsz8/iAQczU/tCy+/q50fehb7fHvknGGeURzjQ4GLJSSzaoIJrJM+VXZ0Vr/Ms1fpR0tcYiGziFJbmnbV5FKo92kh85ECdaALRNQVGt5OymZBJcKSbS/462f8IETuKpZG1O+bmFw2qJpSO0TrZgXZaTbXzW6Tx5NcpR5JtlIpTAeMbsnw8tsl4FDffhyEnVXhKA92nYm1s1Og3wlDL7m7NxNaBEFPUCWVVtadUllGVQsPqA+T0kqQYJM/txcOf6t7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5OcAOJGUjW6e/azifjx3FhvJUhdgEpkJyHLYNIPAPk=;
 b=k3MGBi5Y9MsK/DlVwYEzYSUk9ZiDviY/hPRO7yOmzdqazkwtJaOjVIw41V9Azirxv79Gk3lwclnrPOHREHZbgM22E+INEdRjk2UAvVxMT5Ih72nCDvHvS0k8p1k7lC5lbS2Ar2kJbf0mwoTAoOMt2xs3LUXGdEoy4lzofzKHyWw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PHXPR04MB10046.namprd04.prod.outlook.com (2603:10b6:510:3cd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 06:41:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 06:41:44 +0000
Message-ID: <1af82287-6d75-4d9c-9ce6-6802673993a3@wdc.com>
Date: Tue, 10 Nov 2026 07:41:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/25] btrfs: zoned: use the regular allocator for
 conventional metadata block groups
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-6-johannes.thumshirn@wdc.com>
 <20261106200156.GD401465@zen.localdomain>
 <20261109210229.GA2405023@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261109210229.GA2405023@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0450.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::11) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PHXPR04MB10046:EE_
X-MS-Office365-Filtering-Correlation-Id: bb804037-5874-4e79-03fc-08df3ef5af80
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|23010399003|366016|10070799003|22082099003|18002099003|10067099003|5023799004|4143699003|11063799006|261028144727099003|261102123227099003|261026121527099003|261022115727099003|261022075727099003|261022105027099003|56012099006|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	qFNlEVqmvPWtSDsOsgiL+VfwG5ahjP/lSB8PIexepSlF8ugnV63inMMzARZnKLwNMbtJfcLFkS0ebsFrQQxWmMv5w6/xM4ZrhZB+SlXRQRRkavaDFbFIc80yddOWyq8lA6JLxjL7Cp2mhTHBWs5tYqOkpqsosCuvVF2hJXgfq4Q5R8ZrVwvgiH6Gxh09HrHEI6FI7hx6JQCJtWMsK2vVlB5pguflQseMxdxwGk0uVnSGmH1FzCeDbu8hqHFyGqQu/kKMM8rWlsMI11GGVTxwWNUgDnGTvWuSonxvhEXmRqEumS7pmO6B6UAXPaAcWMIDkivNCkL7StKrHZGnBOz6J1rsABWYN79K9rphbikkXUT/AveyLEmW9X7Lp0lYKKQ0hObcaz9ClEoW0j5BwKMPIyIYcFeJ/gSUTe3el7LLl4BH8Wxlx0f8VyNXWXfKKVg92bTsbqMnDQhBfJfOpeFvyc1zzypkrPwb1HAMsLR0NexYWLBuL6pChdczpBW6JpgL0FEmWf5ndmNke9gR2GCZ0so7q9BDpKLw4YdvmGOs3nfom08NPkTtrX20Z9lCvWIT6pn1rwhpgkAE4H1uPMgu4G4w38rntNGBKHn+CzMRlW1MIht3dtDCeMLhfbnfmZI/hX/RgyiIRrdIzP+Tko7LVanWVTUskYVZI8tdpS+xbLg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(23010399003)(366016)(10070799003)(22082099003)(18002099003)(10067099003)(5023799004)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261026121527099003)(261022115727099003)(261022075727099003)(261022105027099003)(56012099006)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVFUV2NZZkVJUEprcTlSQnRBbU5DdENVQmZBSWNJYjRqRTV3Q0ZiV2tZbmJ0?=
 =?utf-8?B?ZGZNWm9rY1RsbnM3L3Zyb003WjNIcFY3Q25aS0lGTTBmRVp0MmoxZlhGVExS?=
 =?utf-8?B?WmVpT2JreFFlWnF3SEJUTGhjSVkwb1dUYkVLTDJ5WmtPQWZacnlQbDJKNDdP?=
 =?utf-8?B?ckt3aEdUNlp6MkovMEN1SE4zWURKSk81N2J3YktxQWcyeE1nMDRhVm9Vbktl?=
 =?utf-8?B?Ylo3RVk0dnlBRE9Id0RhSnFiK3BHSmM1bitNUVJlVytDcExzY1pCSG1TNFRa?=
 =?utf-8?B?c3Y1VE50b1dQekhPS213QUhIWTJsRDlxUldmTk5MTjJVUjVHaHpKQ2dGbjJs?=
 =?utf-8?B?NmY0Q3RzbExoUmlYd1NpVE1wVEV6alZ0RkhRcHdNVHJpQVlhb1pkZHBVTFF5?=
 =?utf-8?B?VjhuOG5KUHI2dWtxd2ZER3ExWlR3dFJKMFRnTkFydmZRN0prZ1N2LzdsL0pN?=
 =?utf-8?B?TFNLVWhTenZ3R0d0eGcvV0J5RkFnNmUxM0hGUXp6RWlNMitPaFJnYlA2b3VZ?=
 =?utf-8?B?Y3RuK21BUVAyODFKS1lOV2FpQ2lweHQ1N0VIZmh2S2dNUCtKNDIzNUJPclJl?=
 =?utf-8?B?S3pLL1FqRy9XaCs5NTVOOFcrbG1PQlgwaDVrWGxZNjZoblhHRTZ6U2RuSFhL?=
 =?utf-8?B?d1ZqMDI3YlZMUldWVUR2dnkzUW9VR3pLd2FWME1UUDlLZTlVdkdUTkpQVCtS?=
 =?utf-8?B?VWo1aG45YlN1WVBwUTRFRjl6OGlhaDF0SldmdU56bTgrVTlGKzg1cW8rSXFj?=
 =?utf-8?B?djNpa3RGYU5acUlGT0plL0tLRm1sejhocmxoQTdMb2xrLzd0N01TR2xMZEFF?=
 =?utf-8?B?V05oR3poRTE5TXQrYlN5OFl2aVk0TFZBUUQzZmloYWV6c1V3WGNyNDd5RGk3?=
 =?utf-8?B?Tk43alM1VkRsNDA2Y2s3RkVadjdaeE90cHpGT1hzUGRZcEFRKzQ3ZHhPeHBi?=
 =?utf-8?B?Yjltc2pxOFlaNlE0ckErVE5xcHZzUlZjdWRNamN3YjNHMThnOE5qdkVCRGp6?=
 =?utf-8?B?WVZQcDlmazJHZFhPKzc2amxvZ0pxaGxZWHZJOFFCVkdJREJQZ0E4OG5EVFgv?=
 =?utf-8?B?aGVUYjB3WTF2U0VDa0NBeitER2dnYVgySDlwVFpVR3NjWU9PZFlGcEs4QWs0?=
 =?utf-8?B?MUQ3dzZyczJicUNsTHA5R0RiemdjcGFQU3h5VXYvcSttMFlOak9ncUE3ZS83?=
 =?utf-8?B?c08xcWVVcytiSVhOd09MM0RabGZSRWhFMDB6Qzd6RnFQWEdDQk1lb2xhUGFM?=
 =?utf-8?B?Ynp5R2hEUW1RQkJCd3hnV2ZIc1kveDlkV0FFMTV2cXNPMjhKUWpycDN4SVVl?=
 =?utf-8?B?NTRidTVhZ0dhNzBhTTdsT1hqSVhmOFd6dlVmREhIVHBuUUhXMmxiRFRSUHM1?=
 =?utf-8?B?eURyQ2pEVlQ1UmJzNGpJUngxbFVEcGxNdGFYTWVWM0dWd0N3SmduRmsrVlJs?=
 =?utf-8?B?c3VZWDZCajdpa2U4UkNEajR6N0xOekpGTlp4SlNXR3ZWNkhra2xVNGIyN2lX?=
 =?utf-8?B?TThSQU9lWXZUUkJpVW5mZys2VVVITkpjNTQwZmFCeUVYeDVYVWlpeGxUWTkv?=
 =?utf-8?B?OE5jS3IyVmdOZjlSb0tZb1pEeitoYlQxeTRGUllvT2N4N3RJTGxuQWFwd1Jj?=
 =?utf-8?B?TzdBUmdTYSsvQmF2eFozMDJ6UVgzQzhsYkRNTUhmTnQrbGhCc2pOeW5rLzZC?=
 =?utf-8?B?b1MrRXpNRzVQOGtlZmxleVFwdlJDWlIycWxSUGNUWW84UC9NVWRTbGU5YVBq?=
 =?utf-8?B?dkNPSy9DVHVZWEF3cUlzZEM2ZGpNbktXakkwTktUTXhmOU13VVNuL1cvbW5x?=
 =?utf-8?B?NHRsWU9FOWlEYm9ibEU0d01JeEEvb0dkR3ZtT3hKdDZRaE03OHNSMUxMWHJJ?=
 =?utf-8?B?RlpoSkhKZHBmRGo5V1Y2cGRQY3pYVzNxMzVQZ09XcWhpbGluTXA3YXJPTjRs?=
 =?utf-8?B?MEhyUnhweGc0aXVyNkVGdmZMcHVvb1VZQXZYSytieGR6U1B4Qjg1dHFjRCtK?=
 =?utf-8?B?VFljbnJwdUQ5aWxpZnYzOGZSVGV5VmU2RlY2R0JjWjNwLzk5NVY2WHplbzNU?=
 =?utf-8?B?bGYvbGtpcnMwdm5aZ21vV3NXbm1IdEo0QWNMVVRQTXZnZVJKZHdvU1ZBRXV2?=
 =?utf-8?B?MW5PTmo5ZTJ1czE3OG5NVDZIT0NHcGNOR2hGcUJ0Nk1DZWhCNlMrMkFIM2lN?=
 =?utf-8?B?WEpIZ2FKcGpaUEE4TFMzUGxMQlpwdDRKVG0rMXNIczgvWkZHTXdDVk1JbjIv?=
 =?utf-8?B?TlRMci81YVNISUdlUi9acXFQL1pNL21uU0lGeTNxQVV6MUhBV1d1UXdrNy9B?=
 =?utf-8?B?TkVZeVNHeG5CTm9tQWRxMmU4OTYvd2szd3ROMXEySUhUMXdadUdZQlBQcHkr?=
 =?utf-8?Q?UkkrX+WpWtC/kuvliFAsfAivgJcYv95ZhjRNLMSEoC00o?=
X-MS-Exchange-AntiSpam-MessageData-1: D6dkX3fyLU4JkVZcouvYAbjzUBpW6dXKO0Y=
X-Exchange-RoutingPolicyChecked:
	0BeyiT5cFRUdZHLBgiXd0Q1wvbU6Gv018svKbyx3EJNA4qK27MEe4kLaO9fEoaCQfpH13Jh9UiearD5+D5NPkD5QI4XweWYn6EL62jnFDCsszSzZEiv48KqeKdSuKMo1E7dGF4k4MCwyXxO0q45Yf9bvjGDIiaiP9K5nZRfkn9hdjCP2GSbi5Dq+0kpTXJEJz1C5nFJ0Bkq92W8u+hEtl5txwkymKCaygGZ5ij3OvD2KoaqT4qrKvtSc+YQsm4yy/7slmIw2ffL/w1jKiDWTCTaYiaBcFZeJI3vJbiLX0dcL/le033hs3ms4zR0Ofcx0fpew00kxs3zoSrkZPIw9PA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6Y+eBEywipGBi+LijGGVEWlHXBFwLQ10fwKs/rOV9L3bnuWOJ1ZtexiH9dxis7T3XsnbvPv1oxlGXPJiy4YDTC76We7Ig1Ycxd75Pf3YKb5OOEgycpylIWW5e7+wBTa0ci6KFqN4by9R8ds6A6DSJxlqDB7oiEAIzGe+gFG7E4sFZYPLFJ3X4qypgnHdZFiWGmPdoAS2aoeGA6nN/UTZN4v/PZLL82o5WFsZ06wvpDWnPWDUNCIc+t8TUf4hXwrcQ7rWvf4wktpyUo16NjAcCaqSPvrLSUC5p1UoNBKwEaQKuNDNAuTdDfue+GBchJkXBZshW0jwc1z3ZkfKhGQRbWOnAqI04iXdy+ucD3CBVDl3Cy2mJKuZ9sumX3id+AaOE9iZLDFRd/kKzzDRy2NkUH1FkZWIxw+b9prmqMQSS28Y8sZbnWaZop8GYgmugU6Qa/xNMFAbThnxZ1psMTxsLTYwc6D+LVinmxcZL16I3FgvfK2HlOotE2+2BGSESyB7UTBerIND82E4ACSMaXITgBorKPzhKj15BWgjb8jG61BpMWg50jvo4E7NYvMko/InYj+qqLEm3gipyjoFt3cEMWm8FwzO01B4Js3RQAxdVmIUTGLeUk22XD1k7KxC8Vb9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb804037-5874-4e79-03fc-08df3ef5af80
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 06:41:44.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPups0x+gU/FRNBcyY7ixUHdPlLAs5+V1QtpFM2MGHUxoobhoPGdtCKtPZh2UXDseYoBzUoauYFUXlb9murn1BOwM7R8BmSKmK6kh50cxFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR04MB10046

On 11/9/26 10:02 PM, Boris Burkov wrote:
> On Fri, Nov 06, 2026 at 12:01:56PM -0800, Boris Burkov wrote:
>> On Wed, Oct 28, 2026 at 07:20:51PM +0100, Johannes Thumshirn wrote:
>>> The zoned allocator hands out space strictly sequentially from
>>> block_group::alloc_offset and accounts everything freed below it as
>>> zone_unusable, so freed tree blocks can only be reclaimed by relocating
>>> the whole block group.
>>>
>>> A metadata or system block group backed by conventional zones only can
>>> be overwritten in place, so it can use the regular free space cache and
>>> the free space cache based (unclustered) allocator instead, and freed
>>> tree blocks become immediately reusable.
>>>
>>> Pick the allocation scheme per block group rather than per filesystem,
>>> replace the filesystem wide zoned tests in the free space tracking, the
>>> space accounting and the extent allocator with a check if the
>>> block-group is append only.
>>>
>>> Such block groups no longer need an allocation pointer either, so skip
>>> calculate_alloc_pointer() for them when loading the zone info. As a
>>> consequence they are no longer marked active and put on
>>> fs_info::zone_active_bgs.
>> I guess my million dollar question on this patch (and I suppose the
>> previous one..) is what happens if you are in a raid profile and add
>> a sequential device to the fs? Or some similar operation like that
>> which could theoretically change the zoned-only state of a bg live.
>> Is this possible at all? I was tracing the device add code and don't
>> really see it, so I am leaning no.
> I followed up on this question with an AI a bit and I believe that dev
> replace is currently dangerous (with or without your patch set) w.r.t
> BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE. You can create a block group on a dev
> with conventional zones then do a replace to a device with sequential
> zones and not update the field. In my AI-made reproducer this hanged the
> system. In your patch set I imagine it could also lead to illegal
> allocations.
>
> So I don't think it's a problem with your patches per-se, but probably
> something worth hardening / addressing as well.

Oh now I get it. But with that patch set that shouldn't happen anymore 
or at least be way less likely. I agree we need to do something against 
it though. I guess we can make a fstest to catch it: fill the metadata 
by creating a ton of inline extents until we have used up all 
conventional zones and, more to have sth on a sequential zone and then 
do a dev-replace.

I'll try to  cook up something.

