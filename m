Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793084717;
	b=5We0BbrFNfNKC/1QP1Jqtj1cToOSIf0W9wti3gWA4WR5KRXNwa4o4pvTymqbp2Bc6i+O
	 LYJgxs0iB2c7vEYHF+SBGrYYfUB7qf/et6Byph0nFLgIx4Sappszdcf8VpDINafPrjiQo
	 X8IVBbDI5e5RbRvf1FUaDoAWS3g0etCXmY5/LK/AXAkHwHGNunOoVzdg6cI+YYs9f8P/0
	 5JBOGS8sqv1PrYj5LWFWp5zYvHrckCK2xFvd0+QdlAcVdPEF7kanVm/UrbdWidMwKdQT0
	 2kCh1PlyJG/FhTvEEQsKKsBpXE5OJIuLIE0OWaMEh4dFdkDlmNIlIh6KApOW2a9r3Rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793084717;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=k/iG2Njovslzk6sLhMe6mp/Pxr9zN55o1ecOgC2jtVfbBI19y2QUj1takt4ubTY1cByh
	 VzDHNCxT0xnGB4exqM5VhkqGLiE6THp8nLPVjPx7XI4bfc6UsSnTBqXm4xyp2l0KspTKQ
	 um0cA64lzYXLSZW9/DUS6B+gFZNi3/Z+Wvzdx/m1ixbwj4XnfaT2kFX4inhvljcJveoKV
	 0crbYRukdnU1HAZC+zaJIDicsetVxFeF062VlI8HdBtsKUYpH5dFkezXPlLMuX/spium/
	 FOMCyN6e23TJ08q50YE6g/dztY1fxI9EH7P6Ge56nvOVKLY1xRCbv+9TAmKRq7ZL7+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="J1Epo/16";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=F9IJiTd3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A089606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A089606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=J1Epo/16;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=F9IJiTd3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793084717; x=1824620717;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=J1Epo/16Fl5FIblHN9StZZ7fF3H7YjwjM5zzPLOtTBP+X0BVUv5I32PG
   yYf/FziwBJ8wdL16RYyV70zlySn+KZHaDnbz3d2vM7A7fpMkV+x8MYyR5
   opWKF+Z6ZeARRO2xhLWi1KcGda3mbbGta4Zj9jvfOnnEFz9hltTATWNOt
   /rGETolaD47d362vVRYtOegLRSGvpLnCA3LmEZXUcevx6DDsPvzv5/LlM
   p8qypAClr8+QI041WWxCrPefDEMeEhoM+ujqpV79rRbGqk0io11SkK+Fw
   L8paG4CeYtkXXlROytHnQRw8m9SZIGsMwS93rh8MCFboobgTAfcH8m3On
   Q==;
X-CSE-ConnectionGUID: 9AmsbN0LSX2r3DSwIlerzg==
X-CSE-MsgGUID: KgtqvSCzSjWClpG3LZ5uLQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159091153"
Received: from mail-westusazon11010003.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:05:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WzwmTaR0Uip9NDr2qF5dXQyNrWwMgjpg3MfdS9/p6UyCJom/+OaWFMo/FtwHedh6Vv03mU9MnZCZZVZB3pcLEzQ1kEaloUpVzOL8KKgvYflc72e6llR3P84GB2GxymuKR52DyctNZ0qgzxcol5/QH3fBF1HEaEhiA3T8vIIekPNnbxww8wZ3mKjmj3szDIPs8KGdwbTH+Zr1LckZv/Qql5ohh17IWtJGJkqztZEqpRPlISa7dfZidhxc7RSptNtIVW0cXmYa0Bycy5sSwxe75M1UolC7CJD8PNItapg9HtADDDQ430lB5BTL11GiaFleIoc0BEBYQCK0LGMRmHBluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=BI94UXikR9pZ8m30SRutVmuzswM9khcJAx3qqjqpuXU1nyBoa+DlwzgqxMQV3n2nJYzjxuUTGn/lSESOAYarzQcS3vHi/zhmVYWFFZqOkkt8sxxggfScrb9S7bm3zfK6ZxHkymsP3kkTye0G/Tz/zdfPB5mNIufAyTFCzVF5AT6NFBjzYYoFPmbRb3bF0x0Y2CICuJuu19pdBavP2zvPomU144uc8y2VW38ioKyU5aS2fnpKDTVozUgR8Mk0yx1JvNKIkDjugs2op9s4hz4qYV/2jUs3F5X5DFTaF+istJVprET5W5HqKeNjG9fjbv0E/KQjBGTJmcQ75P6u6M5A1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=F9IJiTd3hgi4053O3Y0UTGUUoj0SwJI9rSSbwGaGO/BeH8FvgIvTt6n/grL8aXAx95BvzkGHRfXRBCLeS9jDd+83z4k5L5tmYA9DN/r0p380gBsCbOeFTnYl0dSyFbLyD9t2RnuNs04l1ls5KCG8kTPEDOx+1zH5FC/gmZhNgb4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7867.namprd04.prod.outlook.com (2603:10b6:510:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:05:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:05:15 +0000
Message-ID: <df9c40e3-2653-476c-9f12-49c702e99641@wdc.com>
Date: Tue, 27 Oct 2026 08:05:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zlib: use memcpy_from_folio() in
 copy_data_into_buffer()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <546ae2935e37e248c86616aa0cb6a00d4a1547cd.1793036271.git.fdmanana@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <546ae2935e37e248c86616aa0cb6a00d4a1547cd.1793036271.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a6cbcc4-70d7-4a61-cb4e-08df33f8a67f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|1800799024|376014|23010399003|366016|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	X6d6MsdzOjIhDonkMr4gWppwZaQsoeWNXJjAfZg9ye/xWE8fv3EOrlhWJ4NznQ1KFcQdHNs5XT9S/U+8uNRh6Px2lcFNxFiwJLPakKxIbVfmPw2P92t7WHXnu4hp77fChJizKF5zfzdvM0H0Og2ofnipQRGDb400CHNIbN0P0G1T0vO5kR2Pdpdt2l4U+60v+opIW6UpaG+Ewp9L5+FsgUSP9OCZ5D72SZGLjDKmzfc/0gBYj2R6SketFFEdKPb04k4LDQ5I3Kgxvk2VVpDf+eHSM62gbChEQne4xaeAMyw4tQcHsoKj5qutgY57Y0zHDFxU3Oxdxq6NJkw8MAl/06/ld2fTGd9qMq7MdlnFEqHdtf9k0SXdBKZtKhDW6C8VXr9UJXi9F1ofFnhfsOCysI4yJ1Hwi9mLj3VNgEgyBJt9xlMRfVWnZC/1qjZag4dlN5PeV40dn9fVLy9UBNOHz/FEn/GOMAN6y7J1XRYm64DJlOIQ2Zm6AEc0U+QuEAcHguiG5JxNbCBlHwzWOcxQL67CLqLV08q3c6Z/VyIavBtCNLQ2zyXifLV9kbavEKcLjjA6mcqHR7M5sZD11ULgWYjnGmfwk6tgYRSNtHhqXTi1/f0af3O2BAK7nH5Tq7njI6V5Zdsov5Tn4J3DiqL7gJCrr4giV18dfFcFiCcZXR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(1800799024)(376014)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1Z0MDRFWHRObk9EQTUwbGV0TUJScVRSUmhBUnUxWU9JQ0FQM2NnTkFIaHNh?=
 =?utf-8?B?WUhNR1VyR2R5VDZ4b1ZJZGt0OXYwY2lRMTZMWUZldWV0eEI4bllDR25ZWGcy?=
 =?utf-8?B?c2xHaVdRUk85RmV4ckNaaHBaS2xENHBRc2VjWitXSGE0L3kyUE9ReEFpMHVR?=
 =?utf-8?B?YUFDdENxc29mSExrQUlZenVVUFlVSEZIY3ZkVGl2UjFXZmJId1B4SnZ1dlBF?=
 =?utf-8?B?NGt2cWNpK0tiWVdRN3hpWVRPQlYvS2F0RUpaek5DSHhXTzhaczQzU2RBNFJF?=
 =?utf-8?B?VS9TdG5zVzFWRkxCVUs0QVR4ZDlMcDVmYkFqVTcyczFHWTQ3dTZWZyszbHZD?=
 =?utf-8?B?QTNNRHIzOUkrVTlCbll3Wjh5bSt4S05tazB6cm1VMnpBR3ZIWlRCTVAzdG5u?=
 =?utf-8?B?UFFRdXA5eGFTWm9TOGVUVWtYTG1EZTViOHU3U0E2d0g5d0ZjdG5rT3dYVlY3?=
 =?utf-8?B?RTNPODY2UmxUZEVjMjY2QUQxc2lFRnE4S0lMeDVIZVlYazlTTGJ0SWlWNHJ5?=
 =?utf-8?B?VW13cGlhWVM2QTFTVHVNTGRTYWsvTHdVQ01sK2FMZm9ZNzB0b0lKVkdxM0c1?=
 =?utf-8?B?NEVJcVFZYTdsRmo5YWkyUzcycGVGMHM5OFRyQVZmckFwQXBIdzRCOFVIOW5I?=
 =?utf-8?B?T3FJaU1ncFIrdzNxVFlJQ2p3bytEWnlqdjVoc3o5eHlrNGxQNyt1ZTdtWEor?=
 =?utf-8?B?WE5kcVdGdG54TldYcFdkQUVUbXBOL2Vka25NbEpoOTFjQnhlWkpTa2prQUtK?=
 =?utf-8?B?QVpLeTBEZDZQM3owWk9COXpJTWhLOFloQStWV0ZaMG1EbGoyeGxEVEdoR1M5?=
 =?utf-8?B?WXh1Q1NOcWFIaEcxZStCOFE4aHg3VTV2VldHWk9nWWNWSnExd2NsNVhUY3R1?=
 =?utf-8?B?bTdsbW9IeUNLeGVZSjhLbXFSWkdLMnU4ZWszL3dqbTU4djdjLzRNN3QzZ1hE?=
 =?utf-8?B?S0NlU0FrSk1jcXdpRlZOaHNwQTZHSWdTMmJJU0FQQThSTWlmTEhMMTdUT3p4?=
 =?utf-8?B?NVN1elNLdjFuUzI5YS9YY3pxOU5xekZwLzdEV1p5MUo1WUpZS3BXSjNSWUww?=
 =?utf-8?B?bTRtNnhpSGluMTVSYmhPSkRlRmZaWm0yM0ZDRUZFN01UbXFvQlk5clNhbWJ5?=
 =?utf-8?B?NWd0L1lLT2hHTkpwNTZEaHVKMDl6S2tqRHZNU01RNEFkQStBcmJKZTBxelho?=
 =?utf-8?B?OHhsQnRSQ2ZKM256MUFGRUEwcHdWQXJXU0crV1pQY2NmZ1ZuSThEMW02U2Qx?=
 =?utf-8?B?cDV4OENVKzdLUG5JRXZVQ3hPNERvZWR2Y0lCWUhabW42ZXdVcllhMjU3cmRt?=
 =?utf-8?B?UG9xT1NwQ3RFUkw3K0FiQkZvSElhbld1ZFd5aDlFWHFYUlFQbmRUM1Z5dGc0?=
 =?utf-8?B?TU93RE45MnViN0k0TzhOMTZqNVNmUlQxRjdMYmxIcTRnZWRrM2RyV2Z2Uk1L?=
 =?utf-8?B?OXpMMDdDY2FyaXc0VjViUVhHb1MwcTNNaU5ENStQaU5FMWtGN0psdUdpREd4?=
 =?utf-8?B?V0Z3SFQ4RndYSkIwckk2SnROeTMzdlh3UjVGK0lMOHY3RGRVUnNDb0tocWtv?=
 =?utf-8?B?TzNWMzlyV2VwTUliTG95V2Nvcyt0bTVTQUkvZEZCdUlmY1haNFNienFFSFkv?=
 =?utf-8?B?akFQalI3VDU5YzJ1VXBuSmlTNkVNNm9XTHZEK3pkNXQxTVhBU3kwT0d6aCtK?=
 =?utf-8?B?OUJOZ2ZoeTA2R0kyUzNJOS9mbjBhTm45K0QxLytlTFZ1VVRKNmRsTmE3RmlC?=
 =?utf-8?B?ZzZreHZWb3oxMFV4bVE2VzlOWEMrWktaSnpGWWIvbngwNGFpb2hhbnYrQkhk?=
 =?utf-8?B?VWQyRVVaY3lQN0FxeWlRMkRyMzRTbWNVVUM4dTFHZzJsTG5ZbWsxZFRudUI5?=
 =?utf-8?B?Y2xseTUreVF0RklRSlNib1pHZlh0aFRsb2xkY0pDbExnMytYYXpTODZFcUJq?=
 =?utf-8?B?eTg0UC9YSlM5bU80c2YvYWRQVmhlU1loMGM5Zm9tdldlTDVjTGw0Z3ljRXFF?=
 =?utf-8?B?YnNucjlBczU3NHhLb1NtYWFjbDdlbDZzWmZvRmswdll6V1JldWpyK0kveVZI?=
 =?utf-8?B?a0p6T2IrVW5nWUh4c04xYXdiNFdUWHdTRC9mU1RmNk9CT1hGZnJUTndZcEtN?=
 =?utf-8?B?YUNVNjYwVCtHSU1Wd1lucU0raDh2cVdSdkNHYUMxWjcxSHF5R3dkOWNLRzdj?=
 =?utf-8?B?Zm0xaElGMThVSHZzbXpwTGd1eWcremVpOFgvVGZ5QndMcjZVTTZzeFhrTG94?=
 =?utf-8?B?S21wM2ZLblJSZjkrTDhBWXF3UXI5SHlGRUZzZG8vZEFNazJQdGJMUnZJbjVt?=
 =?utf-8?B?czhpK1pqNG9TcnpQbzRxSVJoc3lGeUdqYkdudDFZdDNSRmNCMkc1c2RUZlBK?=
 =?utf-8?Q?l1eZ1mwTQS6TKdvBD83oZV/nA67vbP1BE27ed3JciWBpk?=
X-MS-Exchange-AntiSpam-MessageData-1: KHq+1NfXtUfTtg==
X-Exchange-RoutingPolicyChecked:
	Wc3hDdvg0b5VF3qt9fDrXTky+o4a0786c6cFn4C8hvvTGCrEOxINZVB1jPDVphVnUMSmlyFZdMEoR4fq2I0EIuFAM1IAshEWBJLPxpUC+Qbgoa5E7vF/HQml6wahHPzp+65nq64EZ0qwjOt4dRvh9alOGTjgjROGDc2ZK0Ce80h6sN+P6Bl3zBtuexX9KxwMgrhC293BzY84SYDvM+6kAIkKT9IlW1uhrNtJMgjv/FZbkMC0Q6fM1aZZshOzux6HjZYnnFYXFRHbUQ+wpVLH3Ed5JzByE9OAtpL74H1eFSLpOpF7Ls2Z2zt47+c9m0QjPki6TiuD0eaxbtGmn0I5YA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z6EGnkEzEz9NSs7pfgkzprwXOOGWFCLVJxTXb1OHUf0gmzKp94F3D6NBvP6rdAKqwWuQOidmlSBPJ5KJ4egCa7xNCZWxBS7X7x7gkvSAK++xFL6Q63MnIs3uIHTnpIYFb5kwM16FLf9q1e7FD1ISZE2rGuPgYzhL2YU1c8hC/Q+zeZrxqKUosT6xuIySBfmpkduDlga1DvQRZnZK1a1PXLO6f+YaH5srTnIDhmmiw9BhoQSj87V7iM+xWTeMx4YJD3UW3jJSpTZuIoBa3zxMx0v7L2xK/nBAKbZxHYsUosp2Esp6V95xL/1LHvqf6K+03XeShAFJMLuzV2rSQR0YLoy9ZfU2EHnRdqHdwqzzWD+OIilCGmyn44of0UJWz1RHYIJ8tySA6a7phV9VGOKtIgIC+Yy5axMm8wreOHepcYjqIriR5nf+Sh23CwPdPndoF9IHB/79EIMLv/+4RUrGgXnEaNVbZ67ftpnpnjZhUODVP5JEfkfSdlNn7Q3Y/V+iLHRiuoDCRIkmFBQOFHcCDfMnME+NFNjJaxMxuW1iLK7GxvudbFtAcYznYrdkEnh9RuJec6ndvOcZy0KSzH4v30LUhJ8YCLv3W5++ztdxYhbiG+HaM5smCzEbAFWUbxD4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6cbcc4-70d7-4a61-cb4e-08df33f8a67f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:05:15.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4XVEGIOGOyhKSTwthFBRBLNOsVVj1niRd0wuYiB15WMBqEgL0azixe7yqeLkdK7FofkOwWrkvPhY5g0sRBX0ydZMqTEPzeWX2VLhIV7/bA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7867

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
