Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793168358;
	b=JCthbDPn4d3lu6q+qi0ZtnJKHX9W+aFrg1j5cjKQew++fDHn594z6oZHr3EvkSrTywVF
	 MH+Dc9h3TRh/F0PlgiDnH0nShYsEeLwCotfQyY+ywHmuXNqQZAcfuzWH99LVEQfTurUjt
	 EBcTo3GZNkFmnMwdLunfldiF8Sd3MVB6S19alS9Z0JcazOObqeshLHuRP7z+EDQkwQepI
	 2EintWafq/NBoURGesIT8jxmLp0pKlv6ZGFa5BghKMHLwBi/U9tjIO8lm1tyXmKoHMMeh
	 CaAofqWj3F+CLC5SGfbHVMU/ASyZ7dx/vkHEoXByq+GP1InvcRgG478fci4cL3mIQWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168358;
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
	bh=1IhqI2jRg+rWhFc54/WuJ0aJSk4kV72nnNwCL0rM9SI=;
	b=bDCclb52oyWjcNugSwmvyI3zQQMB2iOHO1s1/37Ub8R9EnJW+QObYcqVBDfhE5iD0uUi
	 4fmMuh2+n9P28TqOEAAmt+/Jjl06UyMKXXLnl0fXftS4+0B34tmUDeEMNM3pTcfta3TvE
	 yTGCvZr1lfuOZvTA1Y42cjQrxcqzmfYWsIhudKLBGD1xryReuW3XliNCwT6iRDYBhjl85
	 hi9aIZbinqASFMCCyuevvXU1usVHEckCEMMZQwa7D0PbYGaYi0rDQ+1gPAefPbOuQATvq
	 ESwm+/nv2v6VHZoZqsP9rz5rO3dwhsNXoJxtWtP6TLQ4WPifpmO9jF5h6Nw9321t/fQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QgH+VpUz;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YeNYFeva;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C935606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C935606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QgH+VpUz;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YeNYFeva
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793168357; x=1824704357;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wkoWsS1i3B9ha1YQENHDOjeFAXJb44+dPgA8kGWR3Ew=;
  b=QgH+VpUzGH4LMsOXDcf//MSGQ4A6bk0T539NWrI8C0uP3OjBLi7oSrwM
   IKRq/TCV9GL7N9KX5SnSHCmcwsE4CwO2dznqTNjydVNJrwosZPoGd1bpm
   B4eqKlEAUkSuDEEC+hzW/ReMjqVSxzaDleHLcwQVNE2KYSF8ph1UGWtsg
   o+sno8hYryo0mO+utJlJjwyMCym6GCVtSsaPqaVqPXt0yc042nYfiMqIr
   hlpVYRBfNe0DlLmBFXXnlSnZt9AwCK+Q16gN0dj6HyGOy3hH7NXtEy0zQ
   Ib1qwp5/TyspKfRxJw++aj38h+HI02KtBoJ6J/xwxVNsoRQnedgzMucTH
   g==;
X-CSE-ConnectionGUID: rGwFxnFKR2ObYa3aI94zUA==
X-CSE-MsgGUID: gGZXmQXFT62d6Y7WSx+9JQ==
X-IronPort-AV: E=Sophos;i="6.27,182,1786982400"; 
   d="scan'208";a="159084137"
Received: from mail-southcentralusazon11011015.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2026 14:19:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhrFrw/xul2IbMMUa6UT8MmSOMWp+X3HGTSAd7ecGHgkPbK9TTeck9tWtxZB/cRVUWLT97yVCwViOpvXgPmehBwhSrgCRdQTDAiyzelrA2yQGAtJDLRUGCQCyh3meBgwMTBqLhbN6b0irzf0nkPgMtMI3PoZNGn2NAKHab7UEp8N2YcnSm0X7rIMHY/cz8ZjDWH9lH8xpm7W0+9oTxp/H/+KbLLui47XjtqnSPZ9uIKKZUeBZuweAKz5emRw3Au01jhawPYaEuSskqjimL7LAbp1KzGQjQFvCQiNUdb7xalFqNSVoPCnSzIP1dRvDl+pA8TZH8XFQSXH4TdLKsuD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IhqI2jRg+rWhFc54/WuJ0aJSk4kV72nnNwCL0rM9SI=;
 b=mIfelYczz5FDfGrFNlb1fHDRgbZXpbxpIEWwDvgfEV0X8K1qhUup+6DbCiKITSb6WGDyE5qAu91+iUQCnKAlnScetaNvSsPvW41ZvDZcSus0cDXUqZ01G3sMFZFbh7Hw9lV3huYoD+vnUuRKuJ6KrFBYRWWrHQcPePBLFwDHLqsnhQS5OeG0UPRTRMsphXCHV/q0VUem5BRQ17N5ZEUleY7TtPL1LHVHWxKmmggwL0cf3KGDuWYkISYrgEqdpQofPgsrUkTfi846Y6HEpOMxQj8LFE0XB64f8vqhUQohc6APAKXEU44pSOgN7deHudmlDdri/gxpLRcCFDEWzJ15Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IhqI2jRg+rWhFc54/WuJ0aJSk4kV72nnNwCL0rM9SI=;
 b=YeNYFevaFw9DoFLua6FbnMlo2laNu+GF4VYUI7pPbZ7sYYvc6wzC8OD3lRfh4/MN/qHC8blCnjaSa6eMInkcSv4ABrGQgO5uJJ7Ymr7pJ6c/EcdFW4e6tqMks8dAfx0XFMbPyLAKzBK6hHAGxTgp4y0IOzeOowb4IvGEYWektWc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8979.namprd04.prod.outlook.com (2603:10b6:806:394::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 06:19:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 06:19:07 +0000
Message-ID: <01a40d42-2a12-4b48-a845-b14c4d7aca0b@wdc.com>
Date: Wed, 28 Oct 2026 07:18:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: zoned: don't wait for ordered extents in
 do_zone_finish()
To: Naohiro Aota <Naohiro.Aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <20261027143305.4001082-1-johannes.thumshirn@wdc.com>
 <DMFPZCZUIEYW.H4NR8AY3DXO2@wdc.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <DMFPZCZUIEYW.H4NR8AY3DXO2@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: f93a83a5-5423-400a-c8c4-08df34bb5f7e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|366016|1800799024|376014|19092799006|261022105027099003|261009223027099003|261021121427099003|261021123027099003|10067099003|56012099006|261026140227099003|22082099003|18002099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	v/9HOZmySJvgxsn71XaAvIZmv1J4amkCggZWv6Gj1lOU2BEbqxKQf2AQ3rea8v9izY3Rbkvb4laeMQe7vUvbbkPTbARhK7UIwufJC+UJvFjfX2o+i3YklhXQRrA99aXXFH7j19pOgsDkAWn9+q9ubZGH2O7nS8ZYWIbeasMiXhaajnF1TFCa7soMo9BnxceV68ONxlpS1u3hIabEKLcIroZCONvcwzW4eBLuIpCQGhauHQWsko74s92KzPgKlNv333rgLGnrtgyRSMdG07T9LeUFNAqUwWsLHLX8jefywyNeBzIJ+b6nt1FBAnlH4UEWZg2SKpEprgTxXzCJvwxWurSObMM//VPdMgvMe6x6jXfnlU6LBUOtv2MugEiTvYIB7KFib5UTMXyGHw4X0pXFPsXGwoVFdT7NCs1EmNfK//Ni3xlioNhp5K4VB/CYn638EGy3uvEAxluDtvK/+W2q0J54vZTkCGfR21eLOaHDSaySozUFKW+csfngMAmcYj1+rumdipuhUNJd3f2Za5+ABIckO+64A95guwL/k6H3CCopzxWSMJJWKkQWkK75mKYRs0oQY49A2ZXa0tDQgKjcfc4zRIa622ROgXV+uq+tPLjr/HGzsjdi3NZQlEYdl/SaNwDZ6ISxN+hkoKSszqsaWTFdcLyBCmDGEltDGCOgUV4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(1800799024)(376014)(19092799006)(261022105027099003)(261009223027099003)(261021121427099003)(261021123027099003)(10067099003)(56012099006)(261026140227099003)(22082099003)(18002099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3gxK3ppY3V5UFNHemhjQm9NK0JJWWliSlN5Vmwva1EwVTNtYlp0ckxPUFl4?=
 =?utf-8?B?enZ4bFA0SjRyaXpBcHFSL0dNK2VZRUl0OXUwWlFoNU4rZjEwSFNaQXBCYkEw?=
 =?utf-8?B?bUJjckplOE1wV3V0d1VlSlYvQk84YXhRRmF3Uy9YSGNicmp0MjJxTXpLL0Rl?=
 =?utf-8?B?N1J0cGFDbEUrNDJ1SWZsVFVYRE5tS2srMFhJQUdoSXZFRHppMFNWWnRyeVNq?=
 =?utf-8?B?a0w5TkhxektiT2h5dlBrQnRGNTVUampLc0tkak9HejBQRGRkQytPbllmbXpK?=
 =?utf-8?B?SjhlSHl2UU8yM0FvMlZoTVNucUdISDBvT3ZzZDVjMjVjUSs5bEtMdWsyb29y?=
 =?utf-8?B?OSsvNlB6YTZTOCt5RG8rZFJSeWNFcVJNOCt3Vmk4K2NwNGMyVUZUdzFXRHNs?=
 =?utf-8?B?WjE2Unp3REJOVGIvQXVQQWVyUGFQQi9VVHd3ZVBmRVNWZDM5SFM0QTVDcmNy?=
 =?utf-8?B?aFN1czRON2JOTjFaWU5PSzJkdEt0eE9FMHIvOGZsTkpCeS9Ba3BwZSt4eGhz?=
 =?utf-8?B?a3h0bWdJemV0QWthNlI1SzNWUUhTUS9DUVRON1lHNW90MHViSFhOUFJXM0FX?=
 =?utf-8?B?VlpCY3hQK01lVkV2UG1WcjhhR3ZtN0tOajBMZE5rL2lLV0xkYkc5WFI2d1Jr?=
 =?utf-8?B?aVRDbWlnVnNTOWFaQURJS1hHVFh6VXBJMDNkd2JEQmFBSVlIQlFCQk5leGl5?=
 =?utf-8?B?S3J0dVdvOUJjUm9NUVZDNHpxb1YyaEs0MU9UY0JVejBkU2NRRnlVWDVWbjRC?=
 =?utf-8?B?Ym5Bd2VpOVo4R0FSQlg3S3VyY1VLWUppRnJLb2lvWHZLeHRBSVdYMnVRYzF4?=
 =?utf-8?B?d01xWVJ2TzMzSThveTNRUHNtYm1lYlY5R2lHTlJVN0FKN0dxaEVCZVp3Z3Zp?=
 =?utf-8?B?dmNhZGtZK2hBZmRRV1dPSWtTS0tFUGNRQ2JPWEJVNWp5Y3NuZjlHbkVuZWFI?=
 =?utf-8?B?RGdEdTlTaUpVUG9Ja1RqL1pFVGxqNUN0eU5wUGhGbFQxQmhJU1Z4WkRnNnVq?=
 =?utf-8?B?NTh5RWl5Vm0wVFhVV3h1T2xpem9JYXZvMURqZDFoSmx6QVcvRi9VTXcvVHJl?=
 =?utf-8?B?RllBcU1xVzAzeFRBQmZHRmVFTms1YUFQYmkzZnN3L0VXYUgzdllBeGRxa0lo?=
 =?utf-8?B?UEZ6QVhMd0ZLL2VZZWUyT1RUcWpaSndFTlFMc3ZHWHRYUmdncjhtQVl2U25m?=
 =?utf-8?B?WVRiVTh6SURLQ2xRalQxQjNTWklWMjZBWjBNeUpVbWxTSTJmZDY3cE1vMEx6?=
 =?utf-8?B?UFlScFErcnZNMnZUOHZZUDBUdms3dnRYTlpHWXUzWWFRbHNTbmZ1TUdhMW1N?=
 =?utf-8?B?Z09OQkVwbndySXhzbEZkZmRYMkFBSVhKNnF5YlQrTTByZzVHME9zZ0kxL013?=
 =?utf-8?B?TGhMaEFnUG5GQ0VHejQ5Y3FaK0RFdGY0TFhzdHFURmZERzVKMm4wZ1BPWlla?=
 =?utf-8?B?Nk5NeC9uWkNVTmoxMTlMaDZwOHZLT1VmK0QzNGljN2xYOHN1Tnd1MlhKT2RB?=
 =?utf-8?B?K1hIQTdLZWM2MGpJakRVWjNReGZqZmxubkVSWkp1QXU1TTQyak04QnFoRUdX?=
 =?utf-8?B?VHR5M2JVb0YzUTRNK1NqL0QvWlErdU5rT1k4Z1JTWkhpT1VPVDUwVFBuRGlv?=
 =?utf-8?B?Z2txOXYxSHNpRzBPUW42UUdVN3drcHBmNHRjbm8zNU83ZTdBTWV4L3Nxc1Bs?=
 =?utf-8?B?OTFJWW4xdEZ5WGhHN05TV3JzcjYzZXk1QkxRbTdKdkhHd0ZJVG1hYzdZTDNX?=
 =?utf-8?B?WStXQTVQVG1TZXZxQ1Q1ek5TTmM4MlpSNUk1Wm5HcG1CWWthM0d4U2lLWUFy?=
 =?utf-8?B?OXBtcWFpNlZxU3JIbURqNGNvb3dzZW8xQk95dFd3c281QlErU2ZSSnFYUjV3?=
 =?utf-8?B?SnpWNzh0NWl3MzVVZnBlaEgxWDdadEJxR1VYeCtjc2NJOU51NTltQlhuWTlo?=
 =?utf-8?B?RGRaMm0wdEIwZjNNNDVHZ0RyZzhFQTB0MSszNUt5cVl0cHdZMUVLVEV0ZzBK?=
 =?utf-8?B?Nm1mVnZMT21YcUMzaVE1Nm5YQUQ1L3ZqbWpXelBZa2I2ZW5wSFdVTm9kRFJI?=
 =?utf-8?B?UkhRelQ0SmJtOGJBcnNLMUdEek4wRUl0VEtiSjJOaldDdjdrK0lvTnl3eFJa?=
 =?utf-8?B?MzhXN2J2MVpBNjV0WkdlRTZUZ3d0QnZiQ0kxN3R4bE1rK3hQaSsxbnBuQVUv?=
 =?utf-8?B?aSsrQlhNaGhlVGp1WWdPRWkwck1xdEZuMUhHODh4V1k2ZUdxbjlYajVLdUVZ?=
 =?utf-8?B?Ky8wVzVkS3Q4R1BNRGVOa21qcStHNHhmK0JKaW45aGFJUG5oZk9PbG5ZSlpL?=
 =?utf-8?B?SDdTYU4wQ1NJT2xvajFJRjR0ZEtlRzFHUW1Qd2pBOHdCRE9kK2VVUWhJaWpn?=
 =?utf-8?Q?Mj+lJwsmbBFMsrfNYJkMbDPpf9ahF2GZVrSh4J2/TsIQa?=
X-MS-Exchange-AntiSpam-MessageData-1: 7Otek+tHZWPe53RGnUzxc4iRgxUvHtIyaZE=
X-Exchange-RoutingPolicyChecked:
	zhDaBHQuVsZEwUGFeUBmrcWnENsPAuEYTSIbR2tQ6ZqhvJ0I0dBXzefM1oA3kppSYmXKSP50xc4oq2sy52kKYr1YuY9eYcXpEsCuM4TAV4K98lwi0atpsQYd85+xykqrhdCwAcBcVovRclY6uMUtjuwwBJzgm5Th8lNkMpVif3bUHafnvDVR3ChBjPQU5lJaufsraZmNxVtuI0J/aEG6nrCCwlWNehkQusGVmhndsy1VN+y1k1q31AXcxfV+/HoSsMDlAMWMx+t8tSg6SQgAzgxuucY3ELJIbeYGLE6PxOMPPK/g/QqkHgmVNrvzUMva1c+QptpjIaq8krMN01aZ+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dp9NCppECLwtrhqDd7q14UCcmLbs65cJ/N6RvDvkn3M04XJXFAyM64px2ZAQhLQDMEl5iRTTqzYpGOzxo/5K6njsWJ/tdQpV9axW13PMFL8BvmBIs1N/+l2nRcRd+Zu7oLtvGwe1/8B4gGrR0qpcrI3Tm/2KNtO+XYxMLt0Q8ZRPH0OktfflK6Es0BwvC1qN1qBncaMlSFZ5BqGwzLKkiy2VtEHphlnzzSmdZ8AcxmpAdOtdEYDyY1eu6FUKruRbMsynM+i1ecfdQLNUaXxFN078fE3p2G8ZRHIQeiaUVglnGaiR34JuwTbGU3GoNjp0vqglIh8YpUmCXEWTV0167TI4rrthuAtkW9tkL0Dn6L/JKX5aJiHlkg9b5OqJ0Me1+QNvnigIsPi3pl1PJBsNYn2S5EPTS0vhJQiwLZM+eWefMGJsmdwWEVkyMzjZ2AUDrVZB8zfELRcRIwVnMe7zZvgKI2yrORXDRHM+QgGBqqlU6cbgwb93cLMFYm9mQdAl1kK5S5OQeM9jZEebLMtUW9iVL9qy9A0n3SavM4wnLpQ06NRfR+r370C5YsOsEqqCsIC0gDeTs8xuxLBoLrJL9xYcwnCMXzXVJtbrPyGGuWei+f67Oddu9ZyoQBc8EVZi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93a83a5-5423-400a-c8c4-08df34bb5f7e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 06:19:07.7688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qkmNH7culio1Wb9eCGGYbgUNK6k5Ag8zm4+7Val8MY1euV4fgn3d0W/gDfptf3mT0nxgDXT8nEqKdlWWUYQh9Oy8uE4WCimtyrrruXIC2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8979

On 10/27/26 4:18 PM, Naohiro Aota wrote:
> On Tue Oct 27, 2026 at 11:33 PM JST, Johannes Thumshirn wrote:
>> In general, we want to ensure all writes in the block group to
>> complete before finishing the zone, as relocation does. However, the
>> current callers do not need the wait (or cannot wait) in do_zone_finish():
>>
>> - Relocation already waits for reservations and ordered extents itself
>>    before calling btrfs_zone_finish().
>> - btrfs_delete_unused_bgs() checks that ->reserved is zero and sets the
>>    block group read-only while holding groups_sem, so there can be no
>>    in-flight data write.
>> - btrfs_zone_finish_one_bg() is called from the allocation path and
>>    cannot wait.
>>
>> Dropping the wait is still safe. Once the block group is read-only,
>> ->reserved can only drop, and for data it only drops after the ordered
>> extent's I/O has completed. So if ->reserved is zero, no data write is
>> left in flight. If it is non-zero, do_zone_finish() returns -EAGAIN,
>> which all callers handle.
>>
>> This makes btrfs_zone_finish_one_bg() fail with -EAGAIN when it races
>> with an allocation in the selected block group.
> Oops, I meant to keep the pragraph mentioning the deadlock and the call
> chain. I think we can get that part back on the commit.


OK will do that when committing.

>
> Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Thanks
