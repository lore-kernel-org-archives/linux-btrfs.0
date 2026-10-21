Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792562312;
	b=fmo4XPwvqeALUm6MvrEX9sLq9pld52PjGY2ylw8IMw+tDKbtxrwjspIYKTjTDI5nY4dB
	 vmCQcNcTnuEPgJLsFy3tWmqxtC2NXQXxnCyqgcpwHusgw+yovt3LNuHFmuy8ydTwurP5j
	 tl5IAp5K73jUOYlbx+ERWK02O4SIavjeXi5IvRLASoN7SVpCS8DrTkC6/iZ2A9rBTkcdk
	 LhRCdcfY602REnpZ0YKvQ8hrwwv9DmCEz0LIHxFlbtVTgP+ucctGTzJMaiPcposPZ6/X3
	 2en2as1fdQABynJ69X/AkBtVkqWs+uNbaRgSftlmeETIuFoOso+Xaxl9l92tCLTaqJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562312;
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
	b=oall+KefpON4w03bsFXgw6jR96W/7jHCWmqLqYlA/HNGPa75empTQnDnS9BmRDW21DcD
	 fjKOCf9qNUTwljGUbhM0DVk0ZIxEvKMPQrNsuPa2ccgZoNYOK90Mh/wdXWUD3JevKyzLj
	 smH6SoTl28q+52joNLr4/DHblYVAnBu21ldEJ39yyU5JbzBOGZqAM+IKmi1zHYdBhVda3
	 zXKlW1n5wAkAu3Dcj84a4HATNfUWrt1BJhcc1oA9B1EQ09m2e+ZCnwEajXBOkfCWi5eZB
	 eSV983NjKE/gmaAtQITtPe+ojO9OFhrTFvyNDhPxGfafG6MNBp47FL6evM4zfXb2n+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E+BkUErn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Xn9R3Vu3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32735606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 05:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32735606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E+BkUErn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Xn9R3Vu3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792562312; x=1824098312;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=E+BkUErnEW8tvgPKJQcqbqw2QcPG/5tEDg8LTYniVTqpL9ReZ4R20/Dx
   Tmzgq1KslufSS7CwXulAmKZmPDhs7se0CcbEjsvAEf1x1cRfvX0xdIKnk
   WjMz35n27p+cVa4TXZ49gvByfWYoOfVcyyq604CfQp0wh3/CmhGcjY2bT
   5cHBo//hbUMRfr6sUiRItXsWyGf1A05YT0iOTXHWpYyxy4VgoXou2JSPI
   MTpG8JBvaMTkiIsYos7ZW4XPdjEnpwAyrNzsSyd3M9ZKg7IBTYxaD66kD
   MdVL8+POlddbEkY68inuGGYPpaX5vcCiX/oK5P9tjYzcq5IOUk0uIpe+R
   A==;
X-CSE-ConnectionGUID: bFFJcBEmRgeKLoem75vHWQ==
X-CSE-MsgGUID: 081S0rDvT6eiMWXj3t+0Dg==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="158513247"
Received: from mail-eastus2azon11011001.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 13:58:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uslPtZ2npaAtRSulBzr8wZvHF0HcA0+SyzefDfHjJjwE6LfIv+u7H7DWQzJSislzmBLrVbXNvZvcT5YVLeNEau8g8jrR2j4MtsI2vTV2t4fs3A1DQ2aGJJG8wAhtX9XuicL/uCs10aoKsrZ+HV/ad06C0yqeKziVAD51cIcpTy1HNiMosAB2XAlF9YLELGJXv3f5EcbnQB4aRN2M1vq/R6miSoKhx99h6W66rD/4KYNC0qDSnBgIBFdnPkCEIsRab4cSEDPist8UB7BV2kx+H86TDrX2mrvHuAxmUwGomRlNAArXkDDtwqp7vbYyvP3fk+8rav2pGMDme8pxGD5nzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Jci3/joVKA0U/dJKw97TOzBXJqKvBzUwAb3+m2XD/Vl8ZDOrcxW04ZQ0x2FP2OfuKKgEHIVVAW2yF6/kXGZfMrkpF6qJbwTVcOq0cMcShfHCkJVCIqsV1m0xHZlAcMC8tw/94UurziUjsAkxJKv4+f9VjiswcjtTpHeehRjILOymrS+R2BQpKfN4q8AkFDCCBJLYxsqWcjpteN8zEwVChBOqg2YbGkAxe93l8YVvEk5Tv5+l2vquMTvhgr1iHlzyYFRuzMFLj4bFJq+xuhghFVp6GVQGMKu0YpVI7DhDzR+FDs10HkUz7kEoyaXvpt0jVjX9ciNDiAzQ9cFHf4Q+qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Xn9R3Vu3XvO8VzQAUzCds1/vhq/2hADgWkdErC0rvsmXbunz6bayRGwrOYO0ee286dC4vNXGrgehQ+x0z8YXIpS6X+f+F/2lGccGeS5jPWFNx3XFXZhg/DYqSvajNeSH3u+2pKpMPnTDaw6o8Isp8d+08ILYZzwporZ78AP+1s8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9485.namprd04.prod.outlook.com (2603:10b6:8:1fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 05:58:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 05:58:29 +0000
Message-ID: <3b5ae8d4-9203-409b-aa66-667384351e59@wdc.com>
Date: Wed, 21 Oct 2026 07:58:25 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] btrfs: change scrub to use stripe_len
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792553748.git.wqu@suse.com>
 <9b53b66f9954c7d68ce6ae549f392d25fc7f792b.1792553748.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <9b53b66f9954c7d68ce6ae549f392d25fc7f792b.1792553748.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0370.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9485:EE_
X-MS-Office365-Filtering-Correlation-Id: 70fb28f8-98a4-487b-5993-08df2f385462
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 NlJ5pmeYS/I3MjgCBqHLgQWHiWokKLmCeXU0tUIoiNmwGLtAbWl5d+EpSHvJl5xY2mCeFvwZBJ+TFskdaN/169THJm2nWs+RM30qJtXvdfWfnBLEEJhIBnvAawc7RWwUO1CmSV6qxlCBqdgnnXUH8Bo21NqbfPOExkVroBix87UYlknMZqoLlfkJ2PqfllSsWwfXX+1ZNKJ3PfNTHsiwEbRIxDqXdJj+5PHUDldtP0jlgq49F5RSQrPxHtfJkbSFZYhlQO8USeoQN2yFHHTyNb8nDy+uuUjEqje2iKh8aalEo6YPMgqjWzrvTSvveQNL3q8/bkJvJiOrp9Rt9RLvaEWQ1+rWv2uxGqpGDVOFkzBx9m3uP3Eg81V2lhqfHKdDFy4GJLeleiQMdSxv/rtxfrKijb+tCI7EkgCqwpcrWogeAIZ0lkw/LnnWYz0EBqIFXNMXFo/UmKb+ScuKU/1E++2zJSPgkF/cZPz/970yKsCByVfQihG28D8XJ2a5ThpOZEV3FnBr6Rt3DWK+9aaHv0ElQYPksNIv4s1KdtpjXwhjoD5hZRaowtpXZmQDVDESD/M06cSVl1ejVN8KiOUnCVxMRt7/x3uncu9W3k+WkS46vrcAaMgfkpR/YUrZg3bfajACH/NKIFctkP1THexFcLC7hSZrhneod+IiO4ElPSo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SGtxcFMwTEZYc0ExaFpUektXWHlFNHducXFsZzlDbVM2ODVyemFwbzcva3pz?=
 =?utf-8?B?YUpNQ2Q2c1dYeVZsSU9lOURaQ0E4K1pQS0hKU3ZJWWVnc2sydHVwQXVmSk0w?=
 =?utf-8?B?SUhTODg4bnptQ1JwdTJSQkJzNXIweDZmdi9FRTFLdlo5U2lOKzlYbFptdGd0?=
 =?utf-8?B?NE5LeFdySWlWYmZTOTk2bjVZMUo5YWVCcXljRUpoMUtCbGZ5akcyZGJBaldD?=
 =?utf-8?B?cUl5TGVMRDZNSUt6Q0MvczF0dmRqWEVZdVJmNVlEOW0wSTZlczgwYk9ScFAv?=
 =?utf-8?B?eG0vMzZIUFdiM1MwQUMvQjErU2x1QVZHcCt6eVQ1aWtoSXkwd0lWL3RUVVhz?=
 =?utf-8?B?K3FVcDJsMWREY1phZWFqaUkydWVKRUhxaFUxV21BQStRaXhUdDZWbWc2RTVt?=
 =?utf-8?B?RUl3eDZ4dWUwa0FZcVNXZW9icTg1Ym4wVEh0a0xxVHR0NDNvV0d0dDRjMnlo?=
 =?utf-8?B?Z0grekR4bXlkeUI1NG9JRXhYVU9qS1Q0RU5IaGNabXp3MnUrVWZZMkpHMXFi?=
 =?utf-8?B?Mm9Ea2dqSXdmc1Fvd1JRdkxEOEtxbjVwaW1ZemkrSWVkNjc3L2ZPQy8xTlhm?=
 =?utf-8?B?VW5wZytHcVFLam41U1gra3N3VHNMUjNlL0ZTZ29DSjh6VUFzOFYwWVZGOVdF?=
 =?utf-8?B?ZHpBRnBzZVhMV3huT1pFS21pUXZLSkQvRlVIUzdpZkt1U2lrNlRCcUpNMVJY?=
 =?utf-8?B?QmthTEhrc0RKK0F0NGJuSzhTdlVhQlJlamtEd0lEc3pYb3Zrc2Q0R2hVTnhH?=
 =?utf-8?B?NFYyRUxLdmV4OVhHVlF2My9VQTloNUxDVGFEdHMwcXU4ckdNaXcvZGkyMmxz?=
 =?utf-8?B?Y2d6MHhGWERVWitLUHg1QXNldDg3Nk9qNzRkcUlrT043MmRSUDM1b2twL3VX?=
 =?utf-8?B?djJndWQzWjZ0OXprTDVyZUtkTUhieDAvSUIxSk02TDIzalJyd0k1ZGxIQ2Rl?=
 =?utf-8?B?bjlhSzRmUnpCK3pYaE5DR01pakNuK1EwNVk1emNZQmEvci9Ec0RnN1pkV3J6?=
 =?utf-8?B?cFJiOW54eHljek5BWVY0dnRmMmY1N2JSaDJlSC9pZ2xyRk9PYS96WGsxTERF?=
 =?utf-8?B?aGt0Ri85aDlQRXR4a3FzbllPN2xtUW1aUW1URkVGL210TEdtTlBLV3pGOHI3?=
 =?utf-8?B?dmxXa2RQN2JxRUt2aHNTdThVK1BBYUtja0s1OCtnZDZnV0xXUzdYK2tuckR3?=
 =?utf-8?B?U3BKTkNXWGM2elJKVFpoaWNPNzZPSjd4cCt4d2Z4UUFoWU9sVk5sOThUTnVj?=
 =?utf-8?B?RFRJNVllN2dBcWZXK1ZvOVpRcHQ5S3ljTGozbnd4ZUNnSjJPWmVlYUE3bHpu?=
 =?utf-8?B?TXZ0bks0MHUvN1B6RkN2d3N5TjhwdUplemxGNFFQOHVsTjVqd0tCOWpGUTZF?=
 =?utf-8?B?Q3ZRSVBvN3JYT3JxTWl0Y0pIRkEyMm4wdXV1MGlKUFhEeXpSK2FUYnN6bzlT?=
 =?utf-8?B?bVozWnA5elpPR09SS0ZEVnpOeS9Oa2k3OFU0cVhldWRFRmNBa1V5djlibmJx?=
 =?utf-8?B?cnhoNi9PcFZjaTI3cVZ4MnhQaWQ3SE9Pa0tSYXlGb0VtRjlaNkVDU1RXaGdQ?=
 =?utf-8?B?NHE0WXJmaFZZYU50bXJ6ZzhuYkxQYnVkMVRaYll3ZTlsUWtkWHBlWHBMUzFG?=
 =?utf-8?B?QWxZM29LaFI3dUFCQXh5N0xYcVZlQVdjZksxZHREejYrSHQwakxRWTlteGd5?=
 =?utf-8?B?MDRhY0ZITU1Td1lqY3dLOStuNnlBRU13Tkl5WmlpeEEraUo4ZHpuaWZqTjhm?=
 =?utf-8?B?bjJHVVIxVzExRmtoTlhzSHBLVkFWUE9vUFRSTkdVVS95LzZTUGtjMEVoZE9C?=
 =?utf-8?B?Mmd5UVlldStGTHFEeVk5NG1tSUdQU2J0czdQZGVRczhmVWxxWWdOTUVTYnJR?=
 =?utf-8?B?ZWcvVm1GMzNHNzhiLzFoZEZocnZJbG1VMkR4YWI5VmhyMDBKWUlyT2RSdkQy?=
 =?utf-8?B?MlY0V3gxWVBDeGpUaHJWWk9QK2hQdThpd25UVzNhb3VscThuNDFBQ204Vmp0?=
 =?utf-8?B?NzRObHQzQ1dmNkoyY3o1Vm1SbFJQVHNJOENvUVdkd2YxSjNXK0tkbk9Xb3Bm?=
 =?utf-8?B?eHFXNzc4Y3FYSlVsUEZXdVdnSzFPUE1pTVpSQ05hV0IrV1h4QW5BVjVHUXE4?=
 =?utf-8?B?MWlGcWIxcVFIRHY5cXBSbWc1aStMaFk4NGFYTWp4T2FrcFNMRWxiZ3lRaGFP?=
 =?utf-8?B?cTNrYWVwU3R2Uzg5L2o2WmVUczRLQjA4UEl0WjZ3eDRMTTdKN1JmT2pyYUdC?=
 =?utf-8?B?aTNFdUlMc1dQWmo5b3VpclVSMEJ4U1pONzFuUEJyaWxHU3gzdTFsQVhiV3hs?=
 =?utf-8?B?K1I2MTB3WnQ5aTBjRjkxSElmcXlWdTErejdReTJvYWhpOEI3V0J0VEs4ME12?=
 =?utf-8?Q?2q9gwtlRCk4M68Wi6P/sfLigemT9R3Pe+nJOFi7MDz+f1?=
X-MS-Exchange-AntiSpam-MessageData-1: 56DlpnDGGEkT1V5M1Vc6QnmNLCsunuWaYI0=
X-Exchange-RoutingPolicyChecked:
	hDRJ3mfcIPmV35sTPXfWF+M3KkaKFpKsk7tEdJAXpW7v+xtLjOKmSQu8b2L5ahW91KIRqeXYktxrITkaN1KeXpWvB/BdIQI6gSV5TCheq3lZWxjDLdiPVQgBKZ5rdx6QAsdwuofQYClTahIwlAMuYaGjkKemRdlpG2XlqkCrJ5dIdYRDeFx2eJ2M4SkYg9GBvQt1Zf9WSwqb1BT3sRw8uzBWhgDoAmvgO22HESCVrD8GfCosuxSwe9ULpwFQ1qUFmkbAtpqxr/QjYNhD0c0zRt/mi1GAyjsoNLf/YHahJrfcbGMz2jmCIgxdRn4poRQ3h28XFZUdKkATVD23voZ/wA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QMDl7qnGC2m92/Rsgu1P0dv6I21StYZmmW2Hh+iMekOxlUTmiHESGohgb0J8PeQf4Wkr+q5fKP/EDlJvR7W3kRH9pUxT63dKvs2G0XDTnhVqMJyyn3sn2isijN0lN5sVfLH5B9PnCJIpNkmPhcJKGgsV1KWRtyszSz3B7WaQrBWRea6b8bEGH4T0cKvsGiEMf+IBx6mcq0dIjv+jUQ7HCrAFxdywOhiUHTw7rb3hjED4QHJ3VC/ViVQqHRAufE71B811KzCRSQVwKHbBki3rXjWesRLvI3yzDNFsCkIbV7BfZakwYqadZ3ZwOluITyBZnAhBsGsLmk5dmOPCi/laQ7Wpipc5dPzWRg57l7o5Dhn/0B9V8UU6b1Lg1vmNnWcoBG0u83OLkyN5UL+kji7xoA39wfwxFlC8I+4hubemWuTNCZ2xqLtoPEZNtsVyd6mC6GGPRePwvYGRpoPnHVteavzWU7aSTl6j8U7+Lpe9D2weajadhe40JIJCFpuSD4cgMrJ1TSPGz5iJ0s/XUCqBVxfZqirJDZwds8HJPqhNmMEU/8QIryAmW2EXHLYb49CE+M72K0YBmArZ9TkwLlSqMLZjfJFK1ZQz2KP8OeXIRBAMCDmBflqRDJ2XwLRghAIO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fb28f8-98a4-487b-5993-08df2f385462
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 05:58:29.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPehaGkFlXmSMeHQzBUotIh4e8/3VHyxzc13Pr7htokins9HxMco1kVjazRzCGqrtDOA9UIeocvdRtczVKw7HQKjiuwnR2Ua+Sw4PjTKNl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9485

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
