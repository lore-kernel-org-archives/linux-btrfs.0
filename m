Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792490473;
	b=gqh5I5aUfim1wNxTC9j+YGf0NW0UX5klIGOSVaqT7YbjxCTTgavlSH2zONh2KgYPgn2m
	 BC9lcDlLXv7csjWeHTaOZl/SVHoso/3XrVilaVaG6dtVNrw9O5qybrkPcUshPO7fB5it3
	 QLeaAV/o3KRBIWjUGwmJK0/DTo8sB4IAc8mTJJG4swbnnMh3ni4ZjVwOfMseEF+7D3YrM
	 Nw00aM2eCmoHUQ7Fr95cu6WX0V03EnJpYwKh1errZ0y/rLRpU5fILl+8rftGy+qRtNfNP
	 CGqVLhLuY2f76goxgyJwrqhc1i3WviQ5NdoMllz288TmfutgClaoy1zRc/ri0WMtyXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490473;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=xolsgonwDrikRkLOwoqZoeMdMjcdmJs2pCyonNzABddIIRWu0nQRS3R1NF49XzdSIt2H
	 Oz2E6UPb/gmoIpGo2at2hRYUxtBi+13auhDJ/gv6K680fp5LNYrnUcB1oAj7Nw18rOs2u
	 CBeiVpeP6RWVOC4CWIKsJJEzx/hhAqAh8P8lcXSSq2TMOEJ4GEaPW37Fs+UtB5YC2F2pJ
	 80zt33nUXbQL6BNhnXMihpWLWLXS56rszUUJ1FLgQ+x806FsoDKJo9+4MvmB4LGjCzbX0
	 649JgDJG4VuceLAP88wHygE6P7BXiw8nIhJw8SxBXSsP5EBcqVCmTyrLbGfpgNGbANQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=NlSCBmtL;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Pe6jRrpu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473D606A319
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 10:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4473D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=NlSCBmtL;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Pe6jRrpu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792490473; x=1824026473;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=NlSCBmtLySCpPx37XwLOwYXKhE0ovRJD3xtYY9cCCOEpuo/FH7D0FNwV
   rDOJGYA0FLnMClhhrAoN4T20zUim39rm6E6otzGo2dF8uMI9cmTPiaa+a
   c2Zifm5sYjpLZTCKC7TxDIejz6YXIlOeZGd7MLdGsFxOUykkLfQFYb856
   2SZLvsVNJHcdMLE4FEpV3WsZ/sZWGUF6p3WfM15GBaeycc1uUYLU+LPjH
   p4zg2mTKWH/0XiYj8ppqbfFE8jW5ZsZPQBmbA3idLV2c8GNjo/eprItLO
   wsvhlF+ei38I3CvaMzBMP8mdNuLtZ7a99ZWKHQr9aK59BJgfXwKiFkT6T
   g==;
X-CSE-ConnectionGUID: AbctyZHdSKKBlf1KmPfr7g==
X-CSE-MsgGUID: cfwv/GSoQLeKJ6yqWGesuA==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="157578665"
Received: from mail-westus3azon11012050.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 18:01:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uStXZqDSPlfsV8nFQ40iluToxDyOU6biq2R/znR/eFH8fScoWGTO/jrWo6c5v6E1DpULwt4+kEcYXDGqXAWCCt6BkNyEuaxkxzvYFt+ltIpB2Ihxb8zPRdlC5VRpWnEfg0h9P9iJzjiqkDemyGUZt2sEKFv3eX+UEsm5OUDQnd6hGxQ51WDCJbkqylTjga+533+cBq5LaAgpyNFdI49jrVtDBjTZVnl/oDQk1LMtK8u92lUSyCONJ09rEtMO4IZb+5cpz1a8rXZy6BfcI2adItqFMZ/NNH7pRfFcxTqXke1mOiAlr6y0XgON3eiPfbk3EVqCcrmwfUOiFhEQ6yH+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=wGXcFUrQoFLgCXFRaOY/T/d9jIThmmPDhft/8CLLJCTACYf87/zu6EMyjSViunOS8VCeMg+GEZPUiUO/3QKk1QSoj/55eQDGLnzF8DF8b0+dM/srEqzwU3mNZTMdGH8HL6NADD2ATgYPoOOlGlqeEv9HcCgwMLzt4l9maZf66QS8v5UqieDCEo2qrv5nzumKEd3DcmYXWq5QGWkJ17GHnJFAAYAb/4YfPhrfnNI74rf8LJgjZmiWvHCGoAQrTCZgr0/n08AobvLew8n2Hd4bniAphGDnYf7pWpPUGq4WQttwvAekwdiwop2vKvgFWD4blOMbfrvh+Erpw/kQ6nRCWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Pe6jRrpuqoneZSf44vxWEVqxh8OpLVk46lZIcTpD8f2rMXtL3lociqkclRLu+FKsUBS5u5LIGeQsFAr/dtaWp8Dy94yyj5aGbJkNjyZ42ENeqCOA8da9jsyn4DrABZcQOGzKtbWWjT7fB/hZciokN6zB7givMfQ2eHuttbqvgQE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10219.namprd04.prod.outlook.com (2603:10b6:510:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 10:01:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 10:01:08 +0000
Message-ID: <33d7f66b-9c72-4754-91ea-7e8206f0d778@wdc.com>
Date: Tue, 20 Oct 2026 12:01:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] btrfs: load the on-disk btrfs_chunk::stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <fd4c34a411dd1951e0a39453994d9719ee7b834a.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <fd4c34a411dd1951e0a39453994d9719ee7b834a.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0355.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::8) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10219:EE_
X-MS-Office365-Filtering-Correlation-Id: ea4d4d4b-3bdc-4622-45cd-08df2e910fef
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|19092799006|23010399003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 G9aa/JHyERZ1jOQphuZVf0zj7gzMNpmM+Gt07srtImT2QH6dO0oVvhpGHu9sgATo++aVMMTgXTTSOXhDLsodjolvCKaAm2bCuPWHA4RDPXPuqiRJx/kocd6lssiCaNO1thOFvntB0dxTi5uiPxpP6HW6LCmr/ucMsXzkN8f4lQLo4Cap/PSWKU2Gy1Fn8QPdCjGs4HEXS5P4th2jHlHjQ6P+3qL8RGCxE8z9LoZgm++LjsqvbTgsY5INOVhnuc7/Zy8T2dTNNGfu8shhacDJF0kQKxugrziWhRNkO3Wi2+S2Ru8JejyII21Z1lExPGHxYa21vM0kChGStaMkhZL70GMdPhqQJjnLsOrk38otOfNNQI8zGfBRJua5AyIZ3U3y/oNVOsFHgfUxkLf2+XOQQSb96SNKrIlQql2VOQfeM7mAXAnXBt1KKoKEFAVUWFiBQaAKcso+CR+vjymOr6Hp3+xO/36cb5F4Czb2Zr//duwMhycjeDsZFvq/trsI+wkeyN86cNsCajxH/3AmvwgSWJDkGkvP29KX9XuQpuDOgxQhm1Icg3fuoQd8+CSNGp/lLBK+c7inQ1gChSUEl/UFJ1ohJ7FOMmCU117aeOQ3+R38V8IY5f4vtV7iO5dm41OuoSRZ2NFMhcV5EvTFXqaedB25UdWzfWeSVR8TuA5nMRc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(19092799006)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?djNQQStnR3haaWtBM0MyM093VmhxU1V1cXl2WGJ6ZnpEUFZiaDBlSmk1MUhT?=
 =?utf-8?B?UlVzUU1HRys0UTVwWGxmSjJyUXQ3TGo0ZE5FSEwyaU9zTUtoSDN4NVFQQnd1?=
 =?utf-8?B?WkdDTUZWbFlkVDhIMjhiSlhleXY5VStjZ3d6Q05mdmZDclF6dW1pZWdvaHo1?=
 =?utf-8?B?eFU3L0JaaytzeU1tcDB0VUlkcURpRENsSU5XRnQ3WkZ5aXY0bEJxUmYxT0FY?=
 =?utf-8?B?M2FkSmp2RENtN1hweUtsZU1VbHQ2NjVSNzMwakFsSmhkS2RSOVgzS3VDNXVr?=
 =?utf-8?B?amVMUjFvaWcyUDZzK3JQUVlkVldzeXdJZWQ4amtjUmxQWXdubXhubk42OVph?=
 =?utf-8?B?WVhDRllNVUlpbCsyVEVEL0hoNjQ5cndEam1MYzd0SjFYbUhqejd3aDVvcDh3?=
 =?utf-8?B?WXdxVHlrRDgwN0N1Nmd5VUlzR2R0REhNU252SDhaVGRiYnYwVmZhMUtRemhj?=
 =?utf-8?B?RnVmTmU1M3ZRRy9vUEJwKzcwWEU1UlMxSC9NMSsyWGtEdndEOGdmbUxxNXp1?=
 =?utf-8?B?a1cyRmNubVRLTE44YU5wZFp1TW5hZFVKR0N2YVpaZFFHNzZ6WS8rM3N4L3B1?=
 =?utf-8?B?dmErSU04TUJ2cGljbk5WTHpEeUpzY0NyNnRXRlMvemJFRTBrTTVkdDFKVkJD?=
 =?utf-8?B?NVlOUzFOeGwwVFFYQ01OeGtBUlZ6cjdDeTFKV0luQ1JDMDhuc0dWRTFLcTFM?=
 =?utf-8?B?NGYrSHNUV1FNM2d1WEtvNWtOY1F2b0QzNEs4QnhSNTkyamNMR2Mxd01JMEM0?=
 =?utf-8?B?VVhiTU10OG03YVVFTGNYbk1XaXdVRi9SVWIyOGVzZ3hmTnNmNHBYVG44YnRk?=
 =?utf-8?B?M1JROFFIYWJVY1VIeS9QTG8vZW9WbzdjWm9GdnFDQ014b2RPeUlaREdPd2JG?=
 =?utf-8?B?WDRpRFlXb1p3dml5eHNiRGNsekowbnpITU1rQ25yeXlBRHBYQ3p5cVUyTUwy?=
 =?utf-8?B?TnFmazl4SjZ2U0xmY2x4bGNQTFh1M3RuclI3UzhQREFOY1RyekJ1RVdUenBH?=
 =?utf-8?B?Q1B0MHNrYk14Z01ydmFieDQ0U0xtcnRNV1BDallNbkUyYmRMcHpXSndWd1Ny?=
 =?utf-8?B?T2FWSXJ3N1B4c1lvS0pJTjlSQWxWSGxCZVhTOUJFeTVtaENFTkpqTit0ZjBX?=
 =?utf-8?B?WityeXpwaTJDU291NzVOaU9RQ1ZNdHVaWDBDK0ZTdFg5b0FMcHZOV1QrcjlE?=
 =?utf-8?B?NEMyUjljLzdKajBIV2xRV3NmNTRxN2hDSmV5YUUyL3AxSFBUbjlUaXhyaXd1?=
 =?utf-8?B?WG90cjl2TmZ5ZjlOVTNhdTYzY3hMNkRrcnJIejAybEZXQ1hyYnZGNjdZYXBN?=
 =?utf-8?B?eHBvV1hKaDBvNFdsa1J6cXloZVQrd2ZJOVR1bHE5OGY5RDRNVXpKVVFGMytQ?=
 =?utf-8?B?czd4M3NLTWJrSVNwOXBqMHJhOWdOdXdxS0NKZXJSbzlIQXo5NnQvdnBHYk5G?=
 =?utf-8?B?UEh5VEQrM241MTJWbjR0NmtkVEFETEdSMkNyUEZxVzdMU0pZTk9ZdWhuMnI5?=
 =?utf-8?B?ZW5kYkpJU0lGK2VUV3AwR3BuNkhDK1lpd0VUdCtXelV5MG9pbWdKc3RvT0lx?=
 =?utf-8?B?TUIvYkg1VmNjV2xnaHRMTEN4ZUhtWkJTVkVxcXo0eHR6NEc3QVQyTy9OTElk?=
 =?utf-8?B?K05TdjVLTndBVUFyQmxBUjRqYjFESGRjTUlKa2k3eEpEbDZCOVEvRUR4QXh1?=
 =?utf-8?B?NzFiTEs3T25rMnNPcmhEd25XUFcvd2ZocGpzejVJUVRxMlBFRys2d3FoUmda?=
 =?utf-8?B?ODFVYkxZbWx2OGRDc2h4dXRNN3NFbnRndWlTazhGTzhLVmFHWTNmNlFFa2hU?=
 =?utf-8?B?VDZlVDlFaEhua1Nzd3JrQnNzN3FUZml3UW1Ob0dRdmJUNXdyb1VuTnBNODFr?=
 =?utf-8?B?bzF5Z0hwcUhtSzhOdXMyVVdCMFBqTG5CTnhMM2NNenNTT2VoZDcyYlYvL05W?=
 =?utf-8?B?ZjY5RzhNcmxQNERXNHFPUzM2T2dhYWhUL0xKQ1BZSHRHSkFEVkxTVE5PWjhq?=
 =?utf-8?B?MmZPTnY5T1NaV1owNXdKNU1hWWhZYmxrWjZOejJNaWt4d1ZSUTI3UjFtTkZm?=
 =?utf-8?B?Szl0TmFoWkxMcHlUazFhbE9Tcyt2ZkZZWDhhL1hRR0RxTkQ2S3U1WkhUSEVq?=
 =?utf-8?B?dVJ1ZjBQaTBHd1V4TEtTVGxOTXpkWEIyZ2J6UFluVkNMeVJ3TzVIcWpFQUtP?=
 =?utf-8?B?V2pQR004UjVsNHpLWFcvZHB0MHh0eVNBZFJ6TDBvalpReVgvV0l2eUYzNjc2?=
 =?utf-8?B?bWNhM0UzdXRCVVV3cDFjZDNNVno2S01tbVBkRjY1SjBLUnJxUjR5azBTbFRC?=
 =?utf-8?B?SHdOb2xUa1F4aGZjeEZkSU13ZHJSY3Z0VHNpdytKc1NIVGdyMzBuTHJJY3RB?=
 =?utf-8?Q?LA59yZsjL4ZAJgSOAQl3BkA3x7gRFZJ1bCGS+uksMMzba?=
X-MS-Exchange-AntiSpam-MessageData-1: 22GNISj37Vo/3dOWq51BbEym5YaEUdZOFwc=
X-Exchange-RoutingPolicyChecked:
	CWEp02AIuOJOaK+1BbQCVKitbGMAs2KS1RRVMDxueVkstEOpcYkd0VRCltSgnfcfZpAfXQkLwYOcS4yaCGXdIB+nTJZiHxQMtbrZbysnzigL6Yhmpxkxl719Ax6O12E0ghOX4B/oEwXDwPcjEIQ8qlUO7PrxUF3F3nmH3dcZ68h/p5ZQI+zz1k7MyigTB0EAJQKv4PGybiW+ynwZdTmJWXYkXZ/hG78Dp6fe6gpiKqMveBSr6SWZQHqMfyreWA4N1kvxuo0oS23Ve76d/oNgf2TTJ9mC6iHCwn2p96ZAjMlfRlkIDaRsDlewWnjhV8uHajDHoWuspjF3Xf8oSUAvwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7arUNahaL7hD75zOl/bnepQGZpqV+ysL1zgXzDuq3qeERC8Eg6Woy4+vXlSOwlLUPuHDsA2xvgGKj1DtT1mffbPrrSbMNKDc7WoquBLyjwosXV/bWvIMQCZTk/DA5atxt5B86X13bK3hMtJ1ftDUCXMGTiwv3pRe+9C5f5IZX0HMGKWaVzF6xq6p8GXx5TRKYupfP6A4k7YrG4VRH86CJ1NuKmjXcmLMZFNTBzc/spnj+NhjxNnNHpH+/H+FegkXJRqPIGN6ZyBEX4zXh/6LSeyMA9/l0q2LjxxNIrUnYlxcLcGiOYy06Cz/KwBF1iJHXGdVffhdyUz7qKbVG9CVtfaIiQejLL9wPXfB+BqEH+nnyvMuxnw9/rFArYp0fDMllbtLiNlpMN3eL/0J9qXgzqxDti2dWDZ9BZ1TWNDaqz5WRSh2bqGH6fv6HIRySHQzeBEvSv+5fEsJ9w80KohnPHeyr5pNFlSgBXQ37cZuHwJ9KPXKZ8waGec7n747Jjxj50YtrbRmkzJdidZcmcI5yx79tDPfNdwIhRIITOtqX+PT87n3Nnqy4zXlVWfHenPstSD1uyBxzm6xuyGJllPIGI2yg4J/naFpnJaIOZqnBqCtD1+/JqtRLIYbcgHnZcPV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4d4d4b-3bdc-4622-45cd-08df2e910fef
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 10:01:08.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFRVeU/NBHEG+FoZciVUkdI4oXh1TqmL4sPQVwBhh5mTyuJm7ZhfclW4YdJ+L2pigSIl7U2mjNDj4sRG0v8O1aXaxMj5zzDQA3Gf9U1RDIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10219

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
