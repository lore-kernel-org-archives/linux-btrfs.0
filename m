Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795502277;
	b=mEAQcIfKJaOFTCknurbENZy4TIcxB0Q+sq1DWCtTjDivp9Dp5V1HbiXRzX70tPcqxSGt
	 weix55sOXPtP2nrjYeA+Y8hDOdYplrkJB8AXqdfUq7CDBgeWypRgtfK158iErtoJGERBX
	 4/X77kB1m956MqbB0m3tYirVqEgQuSk3bIrgZEfVPY65BydCMVK4U0lXBv7MHl28lVxt9
	 k1tULHjNr6ePDyQYZukcHuaPFXdWmzKQ076CUrnZkADgmjWmsydBnH8kXQZoNK0hZknO6
	 eToGYEifTE5WZFRWzV2HC2pMXw6V0Z/eA+2AL9TDQPZ1jF6q3wXmJD6MW838iR/J4+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502277;
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
	bh=KrfNSKSJuLxObr4FmEgNO4GeLvl2ff6Bh8nZanafuKM=;
	b=LvoBAZPTykZrOoH2AuOH+u/yjig0OB8w5jAcBW2lv44jMmW9Mv71NFigPqgzTZirrW2d
	 mjJiG24aLNROnL9uF8i3fHksZ+oRuR1CSieVGT5TUkAsZx3/YD9G8WGmHadHGX9scZXXz
	 pAtxAXTxFRQ1/NS2kB7AYGshD4n65HPfuRAac0c7LmXhVAxQ66NU5N4D0u8DfNKb4q67z
	 Zi4flP5PAvtjqDAhke26yRJhWpvgqPlzpKat6zX277gW2CsXH7OzYr8yxt72dxtCwZJfr
	 Ml9Zd9Gzn7SyeyEoDxwZjsq2W/6rokguFUZQu+Hkd6MQNPV3Gf5Sjq2QaCc6HTlwObw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=US+6GBEC;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wElXpGJw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F270C606A31E;
	Tue, 24 Nov 2026 06:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F270C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=US+6GBEC;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wElXpGJw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795502276; x=1827038276;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T7Bbwj8AiKlWgOFgC7VxYPrQkWby7D8c2xo6YT5T3PA=;
  b=US+6GBECnS7byE0TLbs0fXDyyrrn7I973WwHWJZFTPC5gzkhYngvQPhS
   YMxRCiVKU2zQXUOFTxSi1mFlCR8bZD7FaMpBLeQ5322ptiG3Og0BtWhV5
   4Pzm3zXOSFZfwUYDHtnUoBRSUdibu0axdmBObb6hCMZAvZGb5RecBXzFW
   Icm5QZioCBdN9eZtj4vSHmebFtAzTci+4OskKZRrTP6Hy2iKIHLHK/DR3
   uszbu87aRewhOlFNF0FKDUduj4hqyFa4k/eLC6B7xiXMeIRx3cizyCjh2
   iRUMSgSHqsqJuzVFIm9hy27zAvwG4Fz5fCi73ZXqtSQ3wkac7jCRvQATc
   Q==;
X-CSE-ConnectionGUID: voXG0OfGSkWbbinEhuXt+A==
X-CSE-MsgGUID: sNooR3GRQ1mCi/P0E6oFQw==
X-IronPort-AV: E=Sophos;i="6.27,230,1786982400"; 
   d="scan'208";a="160653736"
Received: from mail-eastusazon11012059.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2026 14:37:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLTjM3qJibp374TpDC1830UvKp4PBMecZ+xI4BlQ2+9cjL31n9SJ22gliSKHIqlLC5v9Qj9U5+9s9uFUbSw2RCS/DKLS7LYQ2tVKal0tG1zztY5qtbKq4kWJT5zV/UcNbgMY24ltoZA5kpUFEe7r5hanU2HvqkDBMU1jy/WRHS9DWhqKiiRDR4FAoT/RGsvtEVr0Sf9q8tVrAiYqsXDpao9r74+Qx0fYxGNc0CuDY7g3jDH7H8V5lWDasfOjnnCKZKqRERzaxMWBDh4pxfynbWsjrbD7LZICm1yxU21vWFLFR5oZCD/5PCbXcsyKCCrX6tSZ8ogvg+6tbzPYBYJOjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrfNSKSJuLxObr4FmEgNO4GeLvl2ff6Bh8nZanafuKM=;
 b=I24jEBlM1TE2lcX/nCeA2X5qZpAdscQqr/sycSzfiNzI/SjaAtkxvyNIysRNpcXWV3Jrui2wsB5lMYSrkx6wgny66HHEXbdMfmtf+8eS4HkNQTlQWrXXQip5KHeQ1Uwycg7nZnmTtx2sj+sF9xDaw/Cl6PTBTLDs2ocWGt4k3WmPlVFApvcznItN5pjIbPLsdh2ZBt4iNiMrQDAdYSEl938pkIJmqW/TLmP7V9iYM6/plb82saK4ZHeLPQlOCcwfxhEmmPR+injd+ShMT2PjvKuwLx/Ar0yyKzRd9UPDr0VAs+ZuXpUb8TEE5vM7lYxbXxHPWihaZ+9YpbVmbu7dnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrfNSKSJuLxObr4FmEgNO4GeLvl2ff6Bh8nZanafuKM=;
 b=wElXpGJwuVQW2PNQWtYOYXx0j07iTANICatE9H1Id0mHjR7ILGJ9g6CxyhFza4ZCAxm4WSngbhYfVdyYVCRF74ar/8zmC+jVcDFSgutis7zorMbPzbrMcnesY1wszrVAEOaTKw3IuLxbA3JKmVZH1N9KxsEVbTNz4NA6NZEsW1M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9297.namprd04.prod.outlook.com (2603:10b6:806:41a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 06:37:52 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 06:37:52 +0000
Message-ID: <596650a4-62c3-4668-855c-3b503912e74a@wdc.com>
Date: Tue, 24 Nov 2026 07:37:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix NULL end_io call when submitting a repair read
 fails
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
References: <20261123175633.2058431-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261123175633.2058431-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0364.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::12) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c3b6b7-e1d2-4b31-864e-08df49f576c5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|18002099003|22082099003|11063799006|261102123227099003|56012099006|261022075727099003|261021121427099003|261022105027099003|261026140227099003|10067099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	C47qVFztDusdWBBaLmNZbmXPcQbQ0aIgRGaGbq6m4CXksHksZEDO3a0i5tSlHvCVlId2yJibA5t0VJaMazcCv6PXY6Tz6fRJRbLU8GLIbMSV/OBPGmIanSnKpNDwJG3aEC1+Diry0oomg6tDDItRN5hE/ubEqTH5YyDc4Ro36vSwPILyKBLw+MTiT9+gCjZPtua/XVXCdFDyfHShf5KWTF7AwaCCoP6tTUv0Ci5wHUJ+lGtse/MyrcyFpR8C//lb1vssW0V3X2knefrsV5NsgHMMjrQ5I92yjqgezyjlivtP2XyldPDN3R5FbAUtGFpjDhickKKSzCfiVuA/LwVY3gmwkoio14S/21PlqDqhGTsabrY6N4DqhN8RdKGYh6bbb869jQRQWto+C13KFJ9x3mX48wUioRW/jLUSu/+dUviCN2qOUAYGriTv3p6DlD009JobzYC2/Wa7TSPxJ26CzOREZxmTRJBLEEtrdCJitmsOn1w3/M/6sw+YOekVAHnu4yJezIAZJzrrV+Vnuw5yYtlNERL+MGBlzbrU13k1sW33SM7GK4mFzKrHCPTBUxO3llct7EPKhxRsSFzuwMYFPHcg5D/7XvHfO7eyGhEdSYtxk64kk8+zaa6eHHo3axqQksBNMH3qld0Lk1TaerpNhXKBrPIbU3GFcwYtQdV148o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(18002099003)(22082099003)(11063799006)(261102123227099003)(56012099006)(261022075727099003)(261021121427099003)(261022105027099003)(261026140227099003)(10067099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkZPMDhmZS8xMm91QXdkeGV1M3pMSkF0ZWk3WlY5UmMvS01YVEg1VGMzSUlN?=
 =?utf-8?B?TlJrN01KV0FIaXorTUxRS3RUMGZrUWNEdTRGMklZNjNDVjIvdi9mMUQrbVpR?=
 =?utf-8?B?NTljZnZrQWhmbnh1WVpuTm00NmZsa3pjc3RvYjNueGJRUStJcU9IemF2WUhs?=
 =?utf-8?B?QVIycnNWbHZJR2diMlp0ZzVjMnVSSG1MMEV5L0ZjbVFCRkw3dHQxcWpUZi93?=
 =?utf-8?B?Tk1reS8rczc4SWd3Tkd5MVQ5R09TQW51Yk5qTTVrb290YmVvdGtXVkRnTS9O?=
 =?utf-8?B?Q3dINXFOUGJ6cmhHRHN2VjhSUTRjWFcxTW96VC9HTDlVdCt1cDlVcFVoOStC?=
 =?utf-8?B?UVZqd2p5eGJNdExDM0lRNCt6Q1lpQ0hoZTJZbTFqS3JBSXZIRm9CTklMeUd2?=
 =?utf-8?B?OVdNb05FUDhTeEd1dkI5V09jWjUzY0kzWk14WWZmaDlyeUhneWNkMlpOWU1B?=
 =?utf-8?B?NFNMdGZTWWM2SlNlVUtVMGlqWUVzRHo1WHRLMGxnNUFjUDJwYjFBRjQwQlQw?=
 =?utf-8?B?WkZiYkJOV0pWQzMyNTBVODMvRE84YjRFMVlUdmVSNDlYZFpLZFVUZk8xaFpk?=
 =?utf-8?B?TEoweStmVjgxcFJkK2tvajFUSmJqTWdtYzFYZzlYd2trT25DbXZwOXczL3RV?=
 =?utf-8?B?YWYrTW50LzR4RFlseWJ2K0NxMWFaRDluSStnM3RMVGl1bUZicFdsb0VhR1FB?=
 =?utf-8?B?aHgyczJERHQxaGd5bWZSUHlpWVNIYWdKNHNWUllyY3psKzRjSTFuR2k4MDd3?=
 =?utf-8?B?SVpJV2dZUVNPVmNKMTRTMHV3Y2ErZGpsNWx1SWp6Q292UjlyZkVoazE0YUQw?=
 =?utf-8?B?cGZIclFQcXFpYStnYUl4cE9uUEgwanNRb0lmK3dpSStDbjUvaDExdWZtNXo2?=
 =?utf-8?B?ZXlkaU1JQTdld0hXV3FLbWtzV0tscHlzL3lTWFdINStkcnRyN1NCbzl0anFT?=
 =?utf-8?B?bUpoU21jWUN2UGhlMU5ieTMxWlpJb08xQW1Janc1ZWhPcURnRGJhRnVwYUhy?=
 =?utf-8?B?NEVJdXlQRUFFeDEySWdiYVFwMi9HSVY3cHhPa21VbjFoVUhGM0tZalhWMFFS?=
 =?utf-8?B?SnQvbDZkSE5QQUc1WEozdm1WWUhaQ3lDaDZEclFXc3ZqaWRrMkVvUHd4UjBJ?=
 =?utf-8?B?OGRyTlRSUHJoZHp0VGloK2M2RGZQQWR2YVp3eHdpdnpJeVNpaXhMemZpdnla?=
 =?utf-8?B?WmpQcGd4V0poMExBREx6eWJEbmVjOTJ2NHRtdXhVQ05VSU1RR1gvZHRaTUtU?=
 =?utf-8?B?RVRaRGhYRnNiWEdNcWpSUGFzSDJXbTUxNjZzVHdpSXFuV0ZKRzNuQlduSXpm?=
 =?utf-8?B?R1hNVFJyNWh2MGhPbDVIV1d0cDZ3NGVSMU5YWGxiSUdyWldUbTBabW9seGZl?=
 =?utf-8?B?azRGbWpEaUhpR3hnbFd5MHFsMlc4dUZ0THAzYTRtRUg4bzBYakRPNUJiQ3JQ?=
 =?utf-8?B?RXVIUG1jWXpIaXM1V1RKempXalhnTDYzUGZHbmRSZHVDaFpWTy9najdndWgy?=
 =?utf-8?B?REY1MTUxd0lBNlQzV3VMbDcwQ2xhWnpYU1ZuWVBHUDQzU2JubEY2eFlvSCtL?=
 =?utf-8?B?VjFtMTZXU01HK292WXBkU3R5aVFtV294SG5HMVJDeGt0NytLM3pnVkIwYXJk?=
 =?utf-8?B?bVZIUWNBQThmQTBKVklJb2pDT1FNbGFyc0w3YnlXcWdZL0RNY1d1ZXhUMWVz?=
 =?utf-8?B?UUdsMWF2V1ZLZDBPRTVoNVNWNjFKUjlGYytkRGhYTzk0cnNOS0xtYnVnMjV1?=
 =?utf-8?B?TTAvbGs5R3ZJRjJ2Q0o2WkZaaW8wWEp2RjE1UUlsQlY2MkcwWmdZQkgxZUV5?=
 =?utf-8?B?NXlkYThGaFVsNldORGNrM0xJQkhPUDN6YjFmZEtyMnNwZ09JQ2hlNnUwQUdv?=
 =?utf-8?B?blQvWkR3Qk4wSW5MZFBRUWpPUk5DbjFNQi9UdlFTQUxzeXhXUmh2R1NJWlBP?=
 =?utf-8?B?d0NFKzkwc1JlYVhHUkFKcEIrOFJjcnlOWXdQbFB0MlVYMzJiNDBOU3F4UmFY?=
 =?utf-8?B?dzVSaWdLcndtT3dVc2hMOUpqK0Q2d210N1VBZDRZMlhBZkdIa09jYk11QnlY?=
 =?utf-8?B?S3l6aExSWm9LN2lUZjMzMmRmTjZ2NFBOSGR1VmNWTkZHa1J4OUtpTVFjQ3o1?=
 =?utf-8?B?eUpEdTBwMzg4TTBFLzJTcEl3UHpXU0tPd0pjeldWb3BYcXp5bzlDL0o5dmg1?=
 =?utf-8?B?L0lKTjYzTU1rUStQbjVhc0NZV0o3ODROTjlUL2szQ0NEajg0SmtzZEQ0Qjlp?=
 =?utf-8?B?aEJ0aEhLcmY0UGdBRlpYcFA1alBoNTFmYVlWMFdmZGlEc3B4QkdSV0p5WDZk?=
 =?utf-8?B?RzNZc3BoVE4zaCt6QmxCdW45OUhuRmJmTVJZZERnWTNrNit6OXljZkxjMk1m?=
 =?utf-8?Q?msOCYW4B3N9iRAaj+n9gUklq83qfHIJgU2a4tNpPI3GTy?=
X-MS-Exchange-AntiSpam-MessageData-1: CQbXyHven43dWT34k2iR8EDRRtsMjKRhZBs=
X-Exchange-RoutingPolicyChecked:
	QrIrNZU7AsLAyiTvJcncR1xzofLoAGLcrmr0c0RtLP0RcAV2LYz2xnbCQvwjZkTp3mjzUJE8aVUM32jq7EwxJNvhBb+RS4DiXDk10T+AHVf/2nnPUDrqPLM2UQCSO7/4VbXlS+fVY1ywzEc7JgnbLb1ay3s44NF7ALK42xpp9ViQ4uFlKdF5bk9EnSKrw5UT8JQk8c1mIEza6kvPgEEU/w8lrXmOqZVpiXH7rHulnzEni7JOd71L0rniZksXtzGTrziBgj35Z7Gsi/gEDLpt25i5F8sjKF3VGHozFbIsZmY+t0LeARix6p1NSS6ANSEXXPiCUjg4Wd0oPw9xi4x2BA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/ZHv0IP3+E7ZEEYFhDtdojkKuSNeVdl+sN/BTgOiLw8YkEHdel2bTJvpJSDxeawSvAdWIHAgR5daYKEJoQ9/7Lu8EZWZ3AaAT7AUS6u391YvrpLFKWUHKUwQ4m09VNPFNhSxjOy22JDK1IYotF59peDFn2lvE40uO14G9tjPC7QNlc5FUthvGMkPGyfQH35gnjVmYeJq7yv4MxjgfdDN6wg2uXAb4pZd/Dmb1MGA4e73HKeDzA8C7lirxuL8Cfi8SikAG3+cH24xsKXYyurpPct4XP8xgCVlXUQ6iyOE80tWih7xPFIn2cc+/6RosVNP8PdbAkM6TYYCurG3qWVZdVfRz0zuf9qsZFd0QcQlqBmWVZIbD4XHCtCrua+8aFSDMec2EPQIvinHXvAdJXwd5JpzxUU14ZNdslGZZc7gN1CHRSsJatJeOiZjVOmsLWEalAgnOlzBChQFcYZHPLwBXNd/JJONd5OO1pVAFVxZgt9lQmbcWaF/LtYbTral5c8qIrVcq6rBAfIflEztrw2yM7vEARfwH9fLJwEHG7Yb/ogvrPLJBZ0jQELdWORuRtQKSN5tu6FDfZ6XaiNOrADPSWTCf8337MqRQpqDH6f/RdtvdSvQitjgwMCNUVE5oW9R
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c3b6b7-e1d2-4b31-864e-08df49f576c5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 06:37:52.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hhf3yJJnc5Bfz2XUqd/Bqpjju66RI/Itmo3+YoF2QpqmCS1V9h52y1/itQ1SBPopeCR1EdJ68cVe/Rd+kUYBW5jm5fUuw0vX3t5VhjFtVwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9297

On 11/23/26 6:56 PM, Miroslav Cimerman wrote:
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index efbce4d549ff..46df424e9667 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -840,6 +840,19 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>   		btrfs_bio_end_io(remaining, status);
>   	}
>   end_bbio:
> +	/*
> +	 * A repair bio has no end_io callback. Complete it like a failed read
> +	 * of its mirror, from the end I/O workqueue. The repair code then tries
> +	 * the next mirror. A direct call would nest once per mirror.
> +	 */
> +	if (bbio->bio.bi_pool == &btrfs_repair_bioset) {
> +		bbio->mirror_num = mirror_num;
> +		bbio->saved_iter = bbio->bio.bi_iter;
> +		bbio->bio.bi_status = status;
> +		INIT_WORK(&bbio->end_io_work, simple_end_io_work);
> +		queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
> +		return true;
> +	}

Maybe I'm missing something (sorry wall of text in the commit message 
and 7am here), but isn't it enough to set a dummy endio (like Qu also 
suggested) and then bio_io_error() out?

