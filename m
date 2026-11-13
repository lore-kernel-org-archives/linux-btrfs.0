Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580976;
	b=VbrPyA4CfLnudjAZUyPpxAfDIKwaSE0e3Ir+7c1ACzV0w+YeBdqLe7Lwjrc9s8s7u/+s
	 dmjiOOg/Xd/phq7EYsUlFbOy+hDxDRI+MWyNo62AgwNKCru8PS1I33tDsriTZrrGKgxOe
	 KnvL/qLJsYCyns9If3g8WhT+AJyxkynhx/urSwr5P+jQd4rOf25XUgIO0+drLlFj8b6NF
	 7k2H8YSS8uwYUMu/dbnUuf4oguAxW5Kj4UzbgMUTSpI0SzcYF+LHH0TZwKW4HhTjPWiOl
	 m+7pONBoSXV5cR/rsQ8aIW2IByoHA8gxR+S1mVJk8q0AWZ3xwmfWXeJmlnJlqIXPYYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580976;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=JMMwh3CcOKJyuxNwjOT37k0VAF8vOytEjKVlS3rPSvI=;
	b=Yh6td+zULSTK3/vLqCVs4hrP7tyZMCO795I5bFGoX1bonJc2kav6u8VzU3cTAlQ7Eul1
	 QrCPsIsJYI9uGI6gK7tNWFvJ5NdGPfRLqYIrWRX9pj0e+jY9NGMWz8OKd8yrUD4DtLIKI
	 m6jQzvN5BiaAnuw4KdfIJIgZTowd88RZEJbgqht884l+btBotv0vG6QO+uQbZXnJeVt55
	 5tLGV/xA56LDghrXkEdopR9u7sNjU8ovbGULlnK/6gb41Oh51Wc+xbUC2kg0AHLNImKrr
	 whNEs1EC95G4SE77bb4X146YfI/xU/qNa6aHbCOtqBhxQIG6G0xWHb58AZhDvSkVD5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=MocZZt+K;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=F9BeBgHJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78521606A327;
	Fri, 13 Nov 2026 14:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78521606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=MocZZt+K;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=F9BeBgHJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794580976; x=1826116976;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JMMwh3CcOKJyuxNwjOT37k0VAF8vOytEjKVlS3rPSvI=;
  b=MocZZt+KxemHOcX46WLiLLlxkCixPehigUBc9b++NHDtEECBgO3WKH3z
   5U+lXrVqrZEthQ33J7KLon5rNLdAfYOTjwJLNWfIaOBypeWVA1NQM3NRE
   rPFWETt1kssKptcHaaVV1WqIR4sCcoapr6EdA81YrnJ50rzbooV9+HYTM
   f58lZdiXxQI96qWOkUWXo3tXU51fO0f9mk0CR2IM8/fOho/JDz2DkRv+g
   n2/btpLBPgS6hh+aTRCIAQ/XB5c3sw5OCo0M4/Pzv7qy3pfmCmJ8uQn0H
   IGIn9tOSeAYJcTllV92JO2mMPv/3iDrTSep+S+4JmBfMJLJRqqTJ0sGm/
   A==;
X-CSE-ConnectionGUID: XIksEgs6Q3SkQwW5B1MnNw==
X-CSE-MsgGUID: jt//x0u+RCuKAm543L2XrQ==
X-IronPort-AV: E=Sophos;i="6.27,211,1786982400"; 
   d="scan'208";a="160741992"
Received: from mail-westus2azon11012067.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2026 22:42:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIYXpCDQR4CXJSZO0qXh2yISocl/34RRO+DTG0/lYch1BsG7ksbOHcHNqlTyFsy7HaIt4hWi26Z9Z9u9DnWjgzNaP+Sstib+tSlHkJQaPGY/9YRYlaY7FlAF0eSPA2pNqt0EMSo330CkTTEL9gD75pFukaYqoqzaCIz4G7b0T2FjI7Is7E15g7NIr7zZh10ACTrFkS1JBRWze2w+jVmeowT//RAjBEftjJgoYxUXBFtVZFU4/ZKGlemR5zs5Anj9ib3jt99Ye8Va1V1gqkcSSS8UUAY5htgAI9f763RxNvf5x1i98Lf6Ox0xEww/hCvH9FgNhxbFj9OKFWdQ23O3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMMwh3CcOKJyuxNwjOT37k0VAF8vOytEjKVlS3rPSvI=;
 b=vTrSta2cUFHCWqFNva5PRMEJteUOL6eFt4jXtdiDnplqrxb5A4CxVgClH6cFiIbScDPuIs3zdS8yME3ak13BD94XkHF0n1rQzzL8jdAfWkBNr+LKAli2NInTL/iOZMXJfxl6Ax2tRvWttVpzLdMleJi5xNOF9MR4Ql/8yEcviGaZUho5AfgQrBpYv77m9e5qXaK7ylx2ma8YnvtpSLA6Jhkp5WAHJetyn3UlQw5MZQwsv+eZrCQQgU4Id3eAj1DlYLi3LC+sMHuYTfSZeAiRilBVXTry5BDj+/avJxLznEs+AjN1dvsngIqfYVmwXxsWytcw9q65u8FcI1GjLd47SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMMwh3CcOKJyuxNwjOT37k0VAF8vOytEjKVlS3rPSvI=;
 b=F9BeBgHJ3O7uP1N2qXlrpTTwpIxyAXLNpEupov/idncfmPkN6zso7vZg0mpB7Zq1Q5a35faDBQ7KO+BBb0xUcq1NdE/Y2mPX6rccxY6y2P1BaFCuobSZx6/rUe9Qk417yVGKgoIVAycaefzP8+9DD75//QbPrGbWhUxzJ0ADesA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:42:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 14:42:48 +0000
Message-ID: <38adc364-249b-4f66-a051-61624e477560@wdc.com>
Date: Fri, 13 Nov 2026 15:42:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test that fsync on zoned doesn't fail with -EAGAIN
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>
 <avSK9s4cGKqqLpDA@infradead.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <avSK9s4cGKqqLpDA@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: bfe89ff8-4eec-4dbf-5555-08df4194630b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|376014|366016|1800799024|11063799006|4143699003|56012099006|261026140227099003|261022075727099003|261021123027099003|261028144727099003|261022105027099003|261022113327099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	U9GfzY9mQlFJdL4RleVEZTjrio7H06IhQcLCK67P+l76drAR8547IKM9c7pFYpAVuwigz5bLciLZPBLgYx84Lh2Sj1FWgwEMUcNsEQ6fYMURJjW1z5Rw3J3A2Ghx/8xSCUTU8y5wkXksJVPlipLT/Yh+zAX4gRf3GiKTVNtb5daFJgPJIRIYb/vVGcVK0/dKQ0Jif251Er5lW40/UVvr1TQmx10kJkZDdPhlEaj+9s/rsND9fZCacHEW8PcHHNoCt1A6b7CaRUVnBRINjD9DbgiIyoH+scDjqUbTFoqfpsCCAQF7CQnMaNvkRzGb1MEK4FnYd7qhCXnZZkFFqJESH6YqgBr8fLvRTjByuAGsvvg3PZcvbIbEBlOE6QOGUmaSLF459SU4SE75HCJnMFFm+IvSxc8Mwg+frdF8aUC6WkDLi+kJT8z1N9x+NTLk5cfa3gRGCGYv81wbhY9OBzmfZVBWHaMrXg9Fwp8tGrepDR6LbkSZg9Hr27TGT+5USWrReTAQsrNhFtitwEVtC21qnKLUQPjkRqLwE7U3D5anN4qU8zbJ/yE5cJpus+T8GduHzkiQPZLLamu5CVFIBH23gPSG7ybpxwlfkGijQLdyCmvYZ82ZR5JwEeBnlcxZeM80BCtgHZjvzMNzDZeoUCxHoYOp8WlImwoZUljhR2RT7yg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(376014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261026140227099003)(261022075727099003)(261021123027099003)(261028144727099003)(261022105027099003)(261022113327099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE5rYWxrdVlJcFFMTDUzQnhaOWx0d0JCeUo0N09wSUs5ZzFYR1VRU2lMc3E1?=
 =?utf-8?B?QU1NOFhuNDdESE9zaUJHWTQzejlsdUpxZk9iMFdqOUt1OEJ1WExFZUh5WFJl?=
 =?utf-8?B?T2pqeVlFY0svb25UTEFMU1RBMEc5WU5uelhqbzNnRnppd25PSmhoa3dYenlE?=
 =?utf-8?B?QXU2aFhZOXo3bXdQVFBBOUQxajZJcEVnUjk5S0x4WXRqRUJYN0J6U29BNXl1?=
 =?utf-8?B?Skh0bnV6bVl4Kzl3OFVObVdnYnhUbmtydWNXeTVEZkJxeU5MSmhaU3RqaVZw?=
 =?utf-8?B?WnhOS3J1ZmdpUHE2RTR0ZXAvd0tNenp4Qnh2ZXpSQkZSZXk0NUdwb2YvRmgr?=
 =?utf-8?B?SG1xaTlrZi9LNnVlZnBNZHBwb0VwYVR4Q0xOdGVVWVJUQmZzMk5RU1F3NUxu?=
 =?utf-8?B?RmR1aDFvamgrbndnM2FDbnhSR0JhVnJQdXRHZVpoMnpwWDNFc0JrYkxXeVVi?=
 =?utf-8?B?QkZvSk5VNVdPVkRwaHZvYjBLMXovajBnYUxuMUNLekYzUGVmTmtFK2dwN1lr?=
 =?utf-8?B?d0RwV25Fdk9GbWxNSk45aDhmUVk3b0tCQjRCTzVWN01KUGQ2RU5Nb05MTTQy?=
 =?utf-8?B?NTFtcmE5Z1dCV0ZDdmRKbE5tb1A5azlqcmpvZDlpYVBSdGcvZkwvVit3d21E?=
 =?utf-8?B?d0hVQlJWSVpaWXFNU09wQ1lNVE93Vmk3dmlaRVBCZzJUMU9FVDA5RWVWdGkz?=
 =?utf-8?B?b3lVcG1QeExuYkZMdlB3UkdCSlJlSGgwY0Y2MGFYQVV4QURGdW5nSUt5bkw4?=
 =?utf-8?B?TlovaXBIdGVEWms5WWpwZkZvbUNnMGc3RzIzYzhnb2w2RUR4TkpOMUVzekNU?=
 =?utf-8?B?YlFoRlRsOFEwYjRTaEU3NysxTHJ2TzVBcFVqMHd1alBvenZtMVRwekVLYlZZ?=
 =?utf-8?B?R3N5RFVzYStwQ2tENFgyQU9XSHhjWG8xM05GMHJGaXBhQlhhWWFaNmJjR0Z6?=
 =?utf-8?B?anQ0MVNvMFpVaEJ3RW4zMkFmU2htdU9NazlxQU9TVG1aV21TaC9tVFA4SGNw?=
 =?utf-8?B?bjg1Y1BuOThOcDh3ME9oZ1dSbmFSN0J4TDVYTDJvcXdmcHpwZTFQVnBZS0ho?=
 =?utf-8?B?NU94Qm1YMmM2ZUV6NjNQVTB5TkV5V01EalVhWEozdU5aSjVCWVJHSStWQkIv?=
 =?utf-8?B?c1hEc3h4aUp4SytEaXg4a2tqTWZHUHVEcG9UVjdiOVJmVERYYXErbFJBaFEr?=
 =?utf-8?B?M1hwaFJld2pPVzFLMFduaVcweGg5dTc3aUNTQ010RnV5TnhiU1FoZWxCZkJO?=
 =?utf-8?B?SjZZVm12aUtham9OZnN0UjN3TklzQ2sxckhiTEFLV0hKSDgxbDFYYk5qYU8z?=
 =?utf-8?B?cTFJdCs4Wmh0OWpsVysxTUVjc0srSmhhUlBEOUVUSlgrKzdmakNMQ2JuZ3Na?=
 =?utf-8?B?Z2NxLzAvTEpFa1NKTVp4VDBTMXJKZTczWWJGbmFSOFFuM3Y3b2M4ZnduZGVJ?=
 =?utf-8?B?VEFwTlRiR0NIeFpBME54bE0rZ2k0UlROR2tUYjdBVjg1aTRTS25NeFNNRnlS?=
 =?utf-8?B?TmlRdXlDMUwzcFNwWDAxbm95OVpUTU16N1N4ZWc4SS85MUxlWWkxOGc4M0Na?=
 =?utf-8?B?cEhiZTBXWm5pYWtoOHdJZFBZZkswbDlTeFJyMkJxT21jVm9sTVpHOUlPN05K?=
 =?utf-8?B?VnZrZ0ltNm5iOHRpRGo5Uk1SakliRTdneGJhYjE4N3lsQjBlR1BXNWxLTlZr?=
 =?utf-8?B?TUh5UXhuSDBvTVMyK25KVU1wZFd4ejNLdVc2WngvVmlhOGxTcTJSMUpZdk5D?=
 =?utf-8?B?QlFpQ3pFeWR4dkZzbytCUURiVFlIOTZJVmk2QWxzQkYwU2lMZEI1VzFobEZm?=
 =?utf-8?B?eDB5VzI1WGhianJYbFQ4cWRPTEdLQmFxQzRhcWYwdEhSaWszQXZ6Nnhwbmp5?=
 =?utf-8?B?TEZ6UWNYbE9DQlVCRVdtRExDTjRZOFh4K3YzWXBycThiamROUmZCVTYvR2tO?=
 =?utf-8?B?YXNXcituRU9XYXJoY0l4WDZtclVLV3ZTZEpGcHBiMUcvN2llenZHdFFqeHFP?=
 =?utf-8?B?UFZyR0ZyMitaZTNteTNzWU5nNEk0aUEydnV0WUtWUDY3ZldBNjRYT1JnYmg4?=
 =?utf-8?B?c1EzQnNGNGV5V1ZydUZKTHJUK0s3VTdSTTdid0hXS0lTTndQTCszUkZnUVQw?=
 =?utf-8?B?L1NWUVJzb0NvWGtic0JjSkhrWE9mZWt1V25oMThPajcxQ1dEMG96RlRERlpm?=
 =?utf-8?B?SjJpQXFKOXVZUFRpNmFyaVg1Z3FsWkUwbDRrYVpNUHZaL2FEb0lOenkrN0kx?=
 =?utf-8?B?enQrUFd1Tm8yTmNBNWxaQlR5bmhVVkhPSUxQbTdsZUhxMVN1OVNNRWhNUC91?=
 =?utf-8?B?bG9LcS8rR1UxRkM1endyMWljQWoyaTVlNEM4bXNvOTM5TVFaWDJqcFVUWmQw?=
 =?utf-8?Q?gAHBWk0ZirEEdQaxKiW/e5sU2swJFFumcwbofmbguCZ71?=
X-MS-Exchange-AntiSpam-MessageData-1: QDypf05xhRlYM5QHTpoQCjdZZtbDTNo2Jo0=
X-Exchange-RoutingPolicyChecked:
	lq9323yX1cexl7DOeJFzSzROLRWLr9TA7CKvHFK+4ihp47K+C2rBj4gUaFBkFcT1LjhuQuLRg8HTUW3sVMTQaULXheSXR9yRYbJ+TU1OUCZrFbAyh3+ibkJxg16s6xQQgUNCuShllyca6X0WKBIMl7x3Ma1EqLGgD7v8enqzQWDMnZX9OebHia0fKdTt5NVZPKA1vy2CdpIDWtnRh52bXHh/rEu1148OgNq+OnwpXKa0Yh/navHfrpUlatUaMbQFe600fQGb3ozEzCC9CbgjXqreSOPnClZPBNuferPbe8IfIhCxK4sBbpnGP/rBhA2ZN8j+TANOyzFznRaVOjdukg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1a3X/d6pzF+B+7ZIbzJmm9MowSjS1Cqf5svEI3skqNK2M/OSlJS5xOMpG2FK0TAkyJGPjSZGwxcn2xi4easdDmFZ3xqWmuMzsLuXksl9AIv09pbAFlNF5Uek5dZKQVOpJ0s/oAwtLiIMEwsxe3dgF/mURcYBZwz6T2FNq8YbXd6jh3L/sEtws5w+6yvYcH4o1a8i4C6dxaqCNUlxOrSG9UswDaQwHAwwunboDW4wct5pesa+Y/fC8oH5Z7HekhTZj938VqgWl2AR7tB/QX2u7SIkvhvVXQ8eofaBKo7YV9mE0vOlv58GOna/2ZoslJiqk1KMzxK4RTPLuGyome5n30m2WGNXYp/uFQtBeY03OAqLcccFLC452tPftpu0M4G/NosZP69jSptkM00K9WnfDkszwC7oMWJLKnSmsKwx9DfrdbvbFsPTT5SHM4O8bDXuTytDNdKCCUVM6y+ffe7E6PHzuNT5HxkZ28kF3z3+hNOPaed2wGdMGmO2mwRXwDARXMCr7OG4rrGUe/DvxC8XO7zVAu8FD7v+9suM006NFfZdVA7Mfl4Dr6m8b/LRZjFHz8RwSXBaiezzkRWrVI6dmR6lOtbvzWRPrRBDk6Y4UOFq6z7frG/B8FoyfT53TvKq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe89ff8-4eec-4dbf-5555-08df4194630b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:42:48.4942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlsV9urfef8FgzUbzPr+xW3V/ZZgnRXWU5dGc64xAgu7yeFXsKW6Y5yljjbE29Kycqdw/VDUcumYKIlHpxH9cobbTlO3623fqy1Ak4+l1kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779

On 11/11/26 4:34 PM, Christoph Hellwig wrote:
> On Tue, Nov 10, 2026 at 10:59:11AM +0100, Johannes Thumshirn wrote:
>> On a zoned filesystem, btrfs_start_transaction() forces a transaction
>> commit when the delayed refs reservation exceeds its zoned cap. If the
>> cap is still exceeded after the commit, it returned -EAGAIN, which
>> fsync passed on to user space.
>>
>> Run parallel writers creating, overwriting and deleting small files with
>> an fsync after every write on a zoned device with a limited number of
>> active zones, and check that no fsync fails.
> Should this be a generic test?

Sure I can make it a generic test.

