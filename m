Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793113577;
	b=tlPDprd9SAeRZzHERT2f+E1PZfElfQePZ0+RkWdFCfdc8u3w/qvTCYX+XYU513hewXQu
	 jIUnxfHWBW28H5xSkUVe6zLqIoSD6LcWHwkk77eOSEdBTWCFk4CBoDnoFp29bjv3bWEcI
	 xtRgG1WHc16oUkNUgnNpjHUlTq2OOzo5P68ovenduj8y2VvDoWXBuDjH0Fyo1Od9zeQHp
	 wXe6m5uwbp42EwQiT5j1BBSdPpoz/9O6A6WQzDLCplqib2VI53eZAPex+9qBUk4WGpgv8
	 xgdqWXhgHQtep6E1gNuXy9bOzTLwcJpiyDao6gr0IQczAsgxbRbuzpjI219o3QT/ydQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113577;
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
	bh=hBtNHxrWWtsc/tl+NuoMI20S+j74pXgDoW7f9+ibuPc=;
	b=AQUIn/h1lG1imc/z55tktyLCGrdqfR8NsY8Y9YUeHxWu2hvgwtPVHrQF3eVuTjoPWwVN
	 KBZntJrKmJfIYi2pXbwWActcCAbJHzjyjuWKh8QSF5MRd/Mzg+A8img7js3UF8PPG2wJD
	 zZdc49kSaFMrUhuZjtwt526KtQGiXcT0hIin7y2ZTlOyyXGtxRx3JFlf62aruvUmUUbnU
	 qpznQ8tJFtPQrL7/WLn+o9BKQolCRJGlrtISWaMfo3ZGb7HaupN/ixjoEisGryhn9JFP3
	 9gNtvmcrqoZ9t+I47UgLQgSBZgIjIfJjOwC+Ufx2R57pMX3T7kSTXNaYiDcVZ4NpCGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="CEt5H/Cn";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="SuzGx1/7";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77E606A31A;
	Tue, 27 Oct 2026 15:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D77E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=CEt5H/Cn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=SuzGx1/7
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793113583; x=1824649583;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NaPhE3f01GfxszoVOLKw1fFh4a9ILNFtwCznrFXP8BE=;
  b=CEt5H/CnU4FngNwYmdl3ZDwH1GmIc0JNYNWYUBDybNvqaqJSFIWNDfEK
   iUCE4Lg1LnmKXFIpqM3L4QqBZj8TACINAru3u+PdxjN4AIDNVrEY3k+b9
   STYG7clnRg/I7nk93zMh9CdT3DXRRIDd49EH8htJjRoAVARsxNhJNVePa
   T6KSnuX7Ldq9KFbcBr/dmpm3f8cCzLHNMXYpGiXQL8lqHSe5qEsi3NkBs
   Pis1q2Pa9Dmo+63MOnAx8Ex1CPi29V4zrCI/33lu85LFULVUUMzf74p48
   xAt1lRd3C8qBg7ic441SQ4yyqNAXn3FfrU+li+DFEYHZTX/qqvh0wuHDb
   g==;
X-CSE-ConnectionGUID: VxfCvTpZS7G/WdwMMEsFgg==
X-CSE-MsgGUID: AE3MwD5FSZiTM5lpb3I2ew==
X-IronPort-AV: E=Sophos;i="6.27,181,1786982400"; 
   d="scan'208";a="154893300"
Received: from mail-eastusazon11012068.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 23:06:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSK1NQaVFmu03F/Y0XtQFIucg3RNdfZEh45a1bcBes3cA3PoQHC5oRFWv00nV08o33bq0bNGQqR7E+t+37b3e6KAtIGAzv7QIaQKGSJ5InA7+Nh//OI8dEsaUVrj4MLFHNqren5LANbZnvE5aWhlPThUbwT8qIsHnv0HJe62w190tbGCDo/aVHwsKtXCmrzaq6hBzl0kFS4dqkiCSeEdVW4AzZb+kOMvrhCYOK7T3UT6r5aBcFkmYJxYi4cNB5aeRkUq1ObST7YWJblyUjoa+E63nfLrPzV2l1tDX8Zsd4xrPWd135AVxQhLg1z4m5kFVfBdZ33LLBKLwCM1iYDOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBtNHxrWWtsc/tl+NuoMI20S+j74pXgDoW7f9+ibuPc=;
 b=y8Dp2E/tKS5MWt122I+pOr/M40tdVG+/OuFuNjtu92LG3VSJW1p3OISENOTpCGoxJvgTLRFZoH4DbGXY/6K86U/aALA3S3u8n411wchfqjYQXf1cCwKewhQpGKzlEPwdraI5dOJHAqHzFzcqcf+viCk/8OoJzW54uXxj7pZsZf3sqNDLTxmlzYNoa2rzSc4c1kELQhcJ1sHnj9seQb6kUp3S1NQvKtygh9Dt86o2nBVDXNiKoRTzjPNtWiwoa9nPSNoh6FJyIz5oC835qQ2d12/YKUCMu1eTxVlw9ABM+MYcH9Ygf1W+dHhumZaKC+qZFAssWCdcxs4bOCYoZhnvnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBtNHxrWWtsc/tl+NuoMI20S+j74pXgDoW7f9+ibuPc=;
 b=SuzGx1/7dhMuK9mQFmIvvncAROXrViscqnVJ4ryigl6SJ6eAlXfZNagNYtLpvZz4tFUM37duUGNkvPJ+W9iAPuvYZiBjOhBZ97AEjeV9qZcydB39RdZMzOy2VpBHPTnO/LK+dOZCCvkC03q7SjTIR6f/xGcYg0+dC3PEPA6YS2g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6757.namprd04.prod.outlook.com (2603:10b6:610:98::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 15:06:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:06:02 +0000
Message-ID: <ba9e4a81-6959-4ed2-aed3-123aee594dff@wdc.com>
Date: Tue, 27 Oct 2026 16:05:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] btrfs: zoned: reset stale zones in unallocated device space
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAEmTpZGu5x9PS7vFwgc_dFH80rL3cFD4-geuuL_w8i=vFDo8AA@mail.gmail.com>
 <52925d79-4dce-4621-b9e1-fd062b47e35d@wdc.com>
 <CAEmTpZGifFxr+yaKddZcG8UxhntYvZROygi6s-8goAoxuUzqHQ@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAEmTpZGifFxr+yaKddZcG8UxhntYvZROygi6s-8goAoxuUzqHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0290.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b560054-edd0-4899-05a5-08df343bd0b9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|23010399003|366016|19092799006|1800799024|261026140227099003|11063799006|4143699003|5023799004|56012099006|261026121527099003|261021121427099003|261022075727099003|261009223027099003|261022105027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ibJmSIDg6HwY1h8H0STSdgkUyYpFI0ZZIsF1bzpSJQsdOunqvsgBL1f84THwxhH657qEr1ogNx4J/hrCJJMOKqEZVRtaqJdT6gF6gj9fWFXZtl0sATvyF9IjzPGWUfRd7oIVMudmovE9wvS7cEDsP9d+XoLMylEOMIkIOR/pdU1LG9Hmgz+s7mg/DWff5n9zJPhTWi/vW/sU/YvnYbHJXZZI9H7JEAVicE4ciiMT8OberiQGcBAVDV56xhIJSB9oRE3rxJiwlIg6lL1FUL/ZEA2BEDSqbam8iNc94hQiFOc7Pnr/fjhH77zJymXQ431s3gBCBnKDJfASeKW4pLNYt5WTnGcLXkr/bUsOYjd9l0fPLg/n1UzN8/ZjIm6MuPcktwZjT+GpxXiGSxrVw3gV4OmEOOy/oWHKAoLMisd6Z7duvlQH0RiP1s1PlbBS0hnj/nL8AvnZUuMtv5o71nXLkyPDB2RoCO7joaO2Z5YCOTH01zMHCd4PmGEafjNEGfUv0s4/RBGiaHMVM1Fpe5u695z8jJ4NU6RKpu93/u+QJIca5gx9lQwU3qwRKX1qrTyKyhfQxFHAMnlU+XpE6sgsiLoLPXrb/dJgkcZTpUyljkjbHtswBtaNW4uG2S6wCBxYZLFZX3W1fpqXZywMUcTk0nK97ehlrKQCRlRDButNUgA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(23010399003)(366016)(19092799006)(1800799024)(261026140227099003)(11063799006)(4143699003)(5023799004)(56012099006)(261026121527099003)(261021121427099003)(261022075727099003)(261009223027099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDdzaWsyV1ZMbmxBYVZPU2FqaWxTelZxZVhmcDNGbGlVRUZQL2RjQ01sZlI1?=
 =?utf-8?B?aHloTjBwdXJ6VU9TSGpPNGxKSndneTQzNlVRdzBxOTZUbG9RdmpEYlREYXJz?=
 =?utf-8?B?a2Y5UEdicnhVbjd6dXpNSjRyTkhpT0NGYVJHOEZhMTgyTFNDQnV5NDQ3QUVX?=
 =?utf-8?B?WkNkYVdPemF0TUo3UVVZNldlWGlLV28zOVNTczM2d1J2MENlVGtGUTNEUklO?=
 =?utf-8?B?K3hPMDNwd0FyaWl6REs1YVlXcC9lMlhQK1BuUWdOWHpFTjk1TkFBcXlJc2N0?=
 =?utf-8?B?eURseUF4Z05xbWlEblJlYjBuMHhGcGhGUUpKTjRTNVFUVmZoblpyNjQ0UGtW?=
 =?utf-8?B?RThpKzBRT3lwbzFuRHVVdVpiUTdTSkQ3dUM2S0FLeW5BQWQrRW9nM1piSHFQ?=
 =?utf-8?B?R3MxZkNFSDdXVStDUWFOb1ZZd2xlb1NiWEJ3S1pFdFRUQXFZWWVGbDhJY1hM?=
 =?utf-8?B?YUhqTUNPakZJbHIrS3FkZXRlV2l2WnBRRWVFRnVJTGdEWXppZzBKNGFoRGV6?=
 =?utf-8?B?Vkw5d3VMQVc1SDY3TzF0TDV4UFdyUUdMRGRjUTJHd095NDBDZ3BvbmltWFlN?=
 =?utf-8?B?QXAwL3ZXOTlZQ1dRVlJkMDRjUVN1SnRhQk4zdy9QMkF1TU1UL0ZEU3NTek83?=
 =?utf-8?B?NTdKeUdSVnVJSWdZclkydFN6YzVtQy8vRmJDOWRjcERER1RMZnVKUVdCVlgr?=
 =?utf-8?B?QTYzcjV4dmlRRUZNeGZpTUVxYndVTzAyVERkcUZyUzZFL0xxam1QZXBlVFdv?=
 =?utf-8?B?RWJIZjE1ZEtsTXhWV2s5TktCSVU0WHArS2VuSmNSVzVvU1FGWkJWNEZRbmht?=
 =?utf-8?B?UXN2d0cvSUV5a1R2Z3Y0aDd3d3U5eUtIbXZ4VUZ3dUtRZlcrZUc5TlhCTUxo?=
 =?utf-8?B?UVlBNVpDZEtjSStMR2ljMkZmQ3Q3bU9CUUowZ2FPK1prNkYzNklTYmVpWk1F?=
 =?utf-8?B?azFDQm4wemdvUFJXTU5rT1oyVzNVa0V3aUVBTVlOdWxTR05CU045VHlTVXhY?=
 =?utf-8?B?UnNGV1B5UEZMVnUvVjJkZEN1OE1qbGpFeElCZDZVTjY1dUhLTjhKN0QrWStD?=
 =?utf-8?B?c0xSOTVIMHhXNFdVVjNPLzFWSWt5cnJKNXBzUzFubmI0TFRzaHFhU2lEYVRp?=
 =?utf-8?B?WG1FcmZDM0NWUkRVS2J6cGljdnRoMGEvU09MTzdJZXB1S0dPbHBMMmRRb1hY?=
 =?utf-8?B?YmtuRHlYZDBzNC9ya0xOL1ZsaXA5TVplbnVPUDNjbzc2RnJxeU9RTjhBK25U?=
 =?utf-8?B?VW1LVWxYd1NaV3pZbWRVWkxzNldpSCsveEpleHBWNUJaS3JzU3JtMGlEVlR6?=
 =?utf-8?B?SHNaTVh2dlhzUlJ2WFoxczc3eEFoQjJGR2lQd0R6bW1ZWmhrZFRFbFgwSzNI?=
 =?utf-8?B?cWd2SXdkdDVPL2x1MGU2Y0kvSGEvZTFucWppdG5Nd3RmQ2FlSG4xaVRuQ0xw?=
 =?utf-8?B?OGxwM1B2U3hWSGc4L0x2blBYRGNOeUszdnBDc3VTMllDeW5Gc3RwOVpOdHkx?=
 =?utf-8?B?c0NHTTFCQlJ3TUhET2xENTM4b0JSYXQyZUJWNFhuQ2VZajAvdm9FNjdqK3Fq?=
 =?utf-8?B?bWhGZ1p2OXNwTnIxWmIvc21FK2ZKRzhZT2YzOUZmWVVzVlF5OVBwUTJFSDR3?=
 =?utf-8?B?RkF1OFhRb1dRQW5DU3dLKzZGVHNEd1ExWFlnOE9jUUxVcXdDa2JxY2RNc2I2?=
 =?utf-8?B?dUVoNFhzazQ4RWl2TmFaL3graEJobDFWMENwVjJvRG1GRmgyNHl5cEx3eG11?=
 =?utf-8?B?a1FQeXpaTWlvT0RDdVVLN2JLejV0WXozemRZY2FRaXE1eHNRUDlhanI1STRG?=
 =?utf-8?B?STkwNzBWb1pIa0dFQXdydGtJUmVIbnp2K3I2Q0Npc1BENFRuUmlHQVJSN1VD?=
 =?utf-8?B?eEw4aGZBbXpuQy9XMncyeThzODJCb01KaHFJSm9zT1BJWkd1WkFyeE5aL0NT?=
 =?utf-8?B?VmttWjRXZ3hGbk80YVlMRVJjRGx2MlA4UlJSWDE2ckRpb1AxK3lKT1FsN2or?=
 =?utf-8?B?QmgweXBvbXdlL0h2V2hEZ2pmUkFCTFc4L1lLazhYZDRqdi9rUDZDSEdTdytu?=
 =?utf-8?B?aUwwOGtVZ1ZSMTh3eGljVHhwV3VMd2hhcDl3QlNQMkp6U3RxSkRVQ2RtWnNT?=
 =?utf-8?B?U3NDNWZ2M09tY2lEamRRdm9NZ3pVVG1CelhyQytoT1lIVThESVRERFlLTjdt?=
 =?utf-8?B?ejQwSXdqRzVWdlpFSHBaSXBjSUVTRG80aUIvMUJHOHNjR1k3VU5iWXN6b1Ry?=
 =?utf-8?B?L3dMOE1GeTJjLzV1d3lBQkQ0R3NqUCtQalJhTkhOVXZCU3RKL1VGWkZLRlh3?=
 =?utf-8?B?NHFuNllNQklETG05S0NMZ1EzUVpLYUZNTTl4dmFmTFNPOUorTmFsNU5RNm9n?=
 =?utf-8?Q?0KCH+VpeES+mbggAM28O/uQpU2dmBHTkGsqnSmWJvTzsQ?=
X-MS-Exchange-AntiSpam-MessageData-1: Wxfp49FhbGBCLlrIYQhMDpK/T1z1qzlGyOo=
X-Exchange-RoutingPolicyChecked:
	pnbPSxtIawsXyKcZjTMOT8UYRjiTt0abXUVf6ohGGoKyox8p9bEn/jWBCLHdkYtiDcRR4hVSsiom+1ICC5hrsWtOyTRoLt1U2uwtNphxvGQoi515+BmhPUOhgK2XOmO3PDjdHEKmXJEorFgH+/UvR8Wo9GW67mZw1wnl+6HN0Z2e+nCyLBEy9F7AipzeaN7r2X9CSYMRsml6sbo3ML5wUlqzYPK7KjeoootqJ5S0Qd23DvPgbSpLkQivM6upFJou/WIH+ef/0PlrpqXx/UN/GtgzqdjlsRT4OVJkdQ4AFMbPm0+v84xpK3zFmHFXZ6VYnxXP9u3GP+jRdS38Dk3OHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bamJ+rrxrbYOrBhGOkIdEuJQEEQakViFd3iZpDYrb1xugLkdscpAQJVyLpgLrxFb7+JftsG5q0P27h6aGARBXLMDs/DO2y5R+k7Y5mNeMW9BO48sTrRXUAsqFb9+sYRGCrOl4qPBxKjSFKLm3EjthtZXH0/xpeQskF4HCERZoz8MMRTQDWesphPi0jFnqyGxT0qh0sLqC6KwuC4gwf7uYPyIR2749MLRy/f4joox5KO6Kj/brr+Woff3lgWp5m9Z3PQVUnTo7z0kiWax06s8JsADt4WCTPeJC/D47DOwwygs1xYa09NrVubDkRdVF1hUpu1vT5+odIgKWJTiLEGR4fMW2CYwRRhH8FcEmeQQKtUQgWTiK9mFQtWrzfKykL8FsfAPxYs6wF87zkcvRsDbGxwqqn76pxQzbqXUy4/mYnFLqXrjhDEokwWo3sf0hav1+216U9vRXMhx8wUIYqEMZr5Awmlj0DEEPfoYJjG1GRjfJ4i0kOdlKaC+DMf6Jzq0JRkT3g5xO5ENXs36KO0qYET1wRg02FZtlHIphRrGdM0Ui/NG4uRdJsVNz8UsU4CU84l6aWV8YMkZ+xBXmYVlI4VJMmDZNGoSutzYoOtKLXOjloCpZxScazaW3x+dzB/1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b560054-edd0-4899-05a5-08df343bd0b9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:06:02.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LAJsBs/Id9aFSM7JjAhzPTJXvDfywAzId3BqLSN5QO9IH3rwMtFAyXJZ/KdrGcwI6AZAbQA+zufkGc/qbERkO1D+dZ7thAhei1jBnsd5K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6757

On 10/27/26 3:48 PM, Марк Коренберг wrote:
> Hi Johannes,
>
> I rebased your patch onto current master and found a few problems in
> review, so I reworked it. v2 is attached. Main issues:
>
> 1) Data loss during device replace: the replace target has no chunk
>     stripes until the replace finishes, so all data already copied to
>     it was reset, and the resumed replace never copies it again.
>     Trigger: start a replace, umount or remount,ro, then mount rw.
>     v2 skips the pass while a replace is ongoing.
>
> 2) Races: chunks can be allocated (data reloc bg, transaction kthread)
>     and removed (relocating repair after a read error) while the pass
>     runs, and the removal is not committed yet. v2 takes
>     reclaim_bgs_lock, commits, and holds chunk_mutex.
>
> 3) Used zones: v1 marked only the zone where each stripe starts. Today
>     stripes are exactly one zone long, but mount does not enforce that,
>     so a longer stripe would get its other zones reset. v2 checks
>     device->alloc_state instead, the allocator's own record of which
>     ranges belong to chunks, over the full stripe length. This also
>     drops the bitmap allocation that could fail the mount.
>
> 4) Zones that must not be reset: zones beyond total_bytes, read-only
>     devices, offline and read-only zones. v2 skips them.
>
> 5) v2 resets adjacent zones in one call and logs each reset range.
>
> The commit message also now says why the existing code does not help:
> btrfs_find_allocatable_zones() skips non-empty zones, so leaked zones
> are never reused. And the typo in your Signed-off-by is fixed.
>
> I used an AI assistant (Claude) for the review and for v2. v2 is build
> tested and checkpatch clean, not runtime tested yet.
>
> Please check that it still covers the case you hit, and tell me if you
> prefer to fold it into your patch or keep it as a fix on top.
Feel free to take over the patch, I have enough patches in flight atm 
that I need to get in, so one less on the plate is fine for me.
