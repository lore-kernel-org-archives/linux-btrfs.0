Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794896473;
	b=pSi5wtVldPjFo8SCpHXyPJn4lufTdJe3rPFwG0+7QDYds9T38MynHiYeafnJ1Sonhje9
	 oLrQhdpcOhqwpAffMu5bC+ct0UhK3fwWDdKfiqywUn3kcI0jlkEDJriHa8eCThbbzXW3p
	 TdKKl4Uv+oFrAx7G6787GyEKkJMyOtXAvNJSb1JHbpflgqenpmzFQFUVYqAgMUuTjzAh/
	 xJpk9xVEhIzgJZ05awNuJJDlsxIXu6ndSLKHf/kyuqS0vuqnYCSNY7mVhKmvAMw19vXoB
	 11zi8vHrC1FmkvpjZxE1toAaB+jMi0MR4b51GmCu6X1Ac11+7V/qj41YsN/8wuq3bdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896473;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:
	 From:To:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:
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
	bh=3K3DcYu71inAa9vpzguJ6Z3bbfBYiyYlrxKOGnoHwy4=;
	b=N3MRtZXB0TPGxjrcG8UvIgQt89WSSVuLf2a9fvLJA4dz9V2gdjWukWu/B+wosA4WQuP6
	 ZSiE+gCibbiDLjjKcxaaR06W4VTXcZ3YZGFjqHbWsMl7/ElijfXU27Zu/aFA3NEpOi+Tv
	 zzRvpTUnypf8k6KljzJ0YNuYrumLxdJyF982n+RM0TMB39k77xDSWE/uFehigyUKJkILK
	 7Ujo+0aEyk+ymYuTGa28KrOgT74EyuvDwSZeSGN8jXQrFkLv3DGWYsM3lWvFO/vHOkbRl
	 pbpkeOa3TBz5DixlZbVioOFJu65yWSooIMSQXx1pYQv3HF0uh6XFkN6T+4O5oa2ALpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rnIVZQ00;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=D5UlgICF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0EC606A329
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 06:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0EC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rnIVZQ00;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=D5UlgICF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794896479; x=1826432479;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=3K3DcYu71inAa9vpzguJ6Z3bbfBYiyYlrxKOGnoHwy4=;
  b=rnIVZQ00RxhtQMigobx1UYvBMVYpFlSbE2GT/0Vzncs600H2e7a9ZjBT
   S/0aqMpvuX7FqoGoUK1RrIjZZ6ffigyXGysgAaQphTnx9JbfzVcm4gN2W
   6h1RAddOkmYLnDLfo/FM0sezB2SS7/ySHy96ptEOLg0DSQbrRMYv8QpzN
   93LSV+wsMRF4zQRPqQZyc3zrHEJ45RUFTtjmAzE34MvwpeTkMLbd8cHkN
   3Ipr29oJmpwpUiMxkUUEbAAYdmcv3lFrk1sh9VTtcoBaEctvmUNn1qA7K
   4CrBY7MfA2o3hpPmYrz9LSw1/jPmrL98LMSaL9j83zeQhKpwWlPXFM4iD
   g==;
X-CSE-ConnectionGUID: 3folD/HxR3SC2k2r6MgNiQ==
X-CSE-MsgGUID: c5Lh1NxZR6edxsCvxsinvA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162045254"
Received: from mail-centralusazon11011035.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 14:21:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CKKQT3Uj0CWl+lGC0tJGlboyJW/tubzpEtsl1NDrDHPfi8goD1pMRafxWKgHczKLHKtvrHRIvvdD4uq6vOkA3nqHEgi+oiONieIY84Soz/V0FqirktjYRufKGto275CqXYmugMkW8G7L12rDCY24gSXIeFje1s1jz179a15Af1v5AHlskMs+TRR7G+MSJxP19p0gEcnK9G6OjwFSfjI1m9DclED3qSqYMaV/x3e2DVq/pR2AU0pA3bF0VfCXYKseEQzJqQztpnD8Ra9hstwScsgAxFk1gqnaqdDxQHc+stnygf5FWWq9n8TjM51bMIKOnkMq8zE/48K4BWGAIjDPGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3K3DcYu71inAa9vpzguJ6Z3bbfBYiyYlrxKOGnoHwy4=;
 b=rMitMlVzOAAYHB+VdipiFSrWe8RMMcA5ChayO2C4e4xMEMFcewOKCd+Zi2SFsdp5rGYopuZr8FRO5r7lKDTYLb8sZRd8etBxiXQFXeVWW+5hcC/a2nZZccM7GPWCYclSf90qS9vdp/u2c/dzR+xmJIFO1dwc4XRgl10Dz8BmhiETPYQBSSG+Hi49Ko7SwMiYy8/ZDLqfQ9LtQL3I0H8piRzwXDOH6wfsGIa0P5KaZaGC1HDzpZOAN87YM5/Q+/GYlHIzmTmF6l9ZlVE024HdXU+JV7QEMvhOUqtbYo+4eHgqLAkU97IktkfMfQpAUmSQpzYrReKJTmvyipzUj2lAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K3DcYu71inAa9vpzguJ6Z3bbfBYiyYlrxKOGnoHwy4=;
 b=D5UlgICFtOXdY+pwfpFSseVhczvEcsYcTS+ItNJxfon3uJi5MdX78Q4rsq61yM1go5mWiRp7vlvWXLFuvCV8xutpj8VKPr/n1MxcsOAp0x14loPm7jD7dpJUWqpocz+aoYfOp7qOZm53UvcJNfYqiDeZ0mByvCaAbgT9WTwDl+8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by MN6PR04MB9407.namprd04.prod.outlook.com (2603:10b6:208:4ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 06:20:52 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 06:20:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Nov 2026 15:20:48 +0900
Message-Id: <DMX9OT084S52.2QI3ED9OLFGJV@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: don't fail start_transaction() after a
 forced commit
Cc: "Naohiro Aota" <naohiro.aota@wdc.com>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261110074523.1199319-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261110074523.1199319-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TY6P301CA0012.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3be::13) To LV3PR04MB9258.namprd04.prod.outlook.com
 (2603:10b6:408:26a::17)
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
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|MN6PR04MB9407:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e5522b-2b60-4c58-0e32-08df4472edf3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10070799003|19092799006|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	TxUDxnIQzEfnDDzQ9f+EWRTdR1eC14OEDx4mgBAKIPyLTVMe3huXRDQgKmp80mvCY7+/1VK6f2yn54KRYZtIpzMEhjeq4LqtnBgHHUpTcn/1oo/9jOb724ug6v1aCOhWpcC2ZoBktuSyw7Mk0kpbW59baPTdFj+SvhL6dM+YZRbp75U7xcRF9OAupGX6YY2mdzJk7YJ3EvfJ3ID+bwMsase8B8NwRfXLPfmAdNvC+XiaG52wsAMhTKDT56fflpIM8m1vBpKjB5Av34dt6xjkp7yqhpiitqtJAJyVtqm0WC5AFNydLKWRjI2j1JbKvntBXfoPu2Zw24BAnKuJ1871MB4/d5GIaomIX3yZ0sYZCEsivFvOUjC3KA4kgiab19sq/nR/3YEfBSsVROrsGTAavPatOLYBfY59eDv9o52YOPJo73abZREPlZkXvc+4yB3ztc958rlFE71EnV6g6wVH4Po//t88RPDI92/mdIwxWA30stDFlPY9W/HpdgHcaPe62L6Mtx+Lsj1j8qaiMaG0xgfxM4hHG7RxEzAt0cX+E3KQxSgrswN87PTbxPKPh48CcBiiZ1cMOnuF6aj8CmZEv6I8PFlGOSNzInVhuwL6teIkbg43IUnec1szJTzOUfXRTQZEpSLlz3/xVAiuOLMbU4iGvXLe2jF2fiSfxSpvsoM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10070799003)(19092799006)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjZ6aTkrWHJhWGJ0SWlYYmNSYm1wZXNKUktwUFd3czFqeWVRMm4ybEdiVDha?=
 =?utf-8?B?SHUwcGdremFLNFEzVFF1N1RZOFpMT0poYkkvTXJwZ28wYm4xUXFLcWZuMkpa?=
 =?utf-8?B?eW1JVTZ6MkxrSTQ1MjJvOFJlY05uUTZjWlo3UE5QMm11K0x0b1VSd2tCVmVL?=
 =?utf-8?B?MVRQNEJuZEZsb0xCMzlKckloaklwVEI4OXRlZmNIYXloWTd0RTUwSkc2d05s?=
 =?utf-8?B?UnJiN3BhWkI3NU91OExyTjZweHZjb0J5NTk5dkNrZTF1MVh4dXdXMzZJNkNI?=
 =?utf-8?B?bkRWclNxekhyYkhZTnlGZ2MyM09LUmF6ZmV0UTRPWGZhek5UbDhSaUFEbWda?=
 =?utf-8?B?RCtjZmtpMG1zQk5Cd3poQ2NlTExUNzJReWhzN25vcVZKTU5tb0N1RVlSV3JY?=
 =?utf-8?B?UHJRTVJrazNpK0VWaWt0TlBuVG5nRmVYbGpRRkhGa0RaQUJnazhEVWtXak56?=
 =?utf-8?B?cHUwSVNNNkxFRjZ3SDBKbUg4ekJNdGcrZ09kbFpGRXdqbG1tazZUVVVqdnIr?=
 =?utf-8?B?NjVOYU8wbW5OcEdHSkFPV253elNpZzRMRHg3SVhLdnNwUTJ3dHJkRXR4NjNP?=
 =?utf-8?B?T3Bja3oydllIa3Y3bkFvL2llRUtCK3F4R3E1OHlPbzJtSlFkTy9SbG9tTVJx?=
 =?utf-8?B?NXdGYTRDVS9mcEM5ZEhVRmpmR0lrOFJNQ2s3dmhDTEhadWhvZlZUUHJxejRq?=
 =?utf-8?B?enpDcnRHTEMvOUpKeHAzZE9VSldKYTREUVlVbmszVERrTWV1TkZDRnR3Uko3?=
 =?utf-8?B?bWEzYmg2KzdsdlpnWjRtUmtxWXhFVFNXejVmMXRWWmQ5SWEzVTd6Um1MQlJN?=
 =?utf-8?B?OGUwZ2ljYjFDZkdhMFNnb0kzUmxLekdHL3U1aUlLdUxOZGI2TERBYWZyT1pj?=
 =?utf-8?B?SjJ2OGcreEczRWY1WkJDQ1ptTkJramFOY21SL1JNQzNTWWdyOWNveitURkpF?=
 =?utf-8?B?UFBVS2tRUkJLbDN5ckxBaWo2ZFJSaHNITmZ5MVJYYnRoNEwwZFNjNzZIWVkx?=
 =?utf-8?B?TWdQQzJBZm1JTmF1bVhORWJVYS83eDE1LzFSWWkxU1MySEtmUEpFczVJeUM4?=
 =?utf-8?B?NHZNRE1jNXE3VHhMZURNamZYMGlETmN0QklHQytKVWVHaTE3Tjl4dWNuajgx?=
 =?utf-8?B?VnRLVUJ6VGpMeHdsbEFHbVZvWnZBenJycW1kV1hlbHJyM3dGcFhickVvSVhH?=
 =?utf-8?B?K0RXdVJiUk41RFBMTy84Q25Fd2J6MGkxQVNCN1J2Z3o5NC9NTzN5aTE0OW13?=
 =?utf-8?B?MEtiSExNb2hVUnNsZGoranVaYjgyUEZZL1NjMXdoR0pYRlhDb21GWTFYTzdL?=
 =?utf-8?B?TDVsOTg5Q1pSZWM0R0xQU2Y2QkVqSkhycndNb3IrRnQwUzA2Ym0waThtYzE3?=
 =?utf-8?B?VVozRGNmWElPT0xSSXRweHNuOU9nQUtmS0ZsYllKZFprWUR5OGZ0RENYcWQw?=
 =?utf-8?B?V054b055OXFIQzduWmZOVkJ4aTlaODRCNmg1MXBvWHpCR2VUbnJ3L3ZvM1ZT?=
 =?utf-8?B?cEZ6bkVvM3l2bng0anFEKzZ4YkV6b0pLTzF1VWRpZTVzTEhJeGR1RDdJMDBI?=
 =?utf-8?B?UUpNOXZEcU0wRGFDMmV6WEdJNzFQS1h5UVc4RTNXMkRmQUMxVk1iTUlLQTBD?=
 =?utf-8?B?aGMwa3dxdUlSVjNWTEVxMjJtc2hvaGZ3OXlRMFZUOXYvTkIveUNIdlMxTXcr?=
 =?utf-8?B?enB2QnU3ZFJyNGFDd1FpU3NvVHVXSE56cnNXUldZRE9ab3d0SklRM0hseWUx?=
 =?utf-8?B?S1dTS1dSVExnYTZSNVJDSFBxU25tZEdyUVdhUG8rZGNTUjlvWXl3eGVhcmJM?=
 =?utf-8?B?REpock40Qk5FQ1RoTlRESFRlWUQzQ3RjOHZMRHZoQXdqbFRTRE9Ua3hHTWJT?=
 =?utf-8?B?TlVGQlZzQTNaVC83RkNzTk5HRlAxWUlTc1MvU01jaEw2K08zWEQ2SzZUSm9P?=
 =?utf-8?B?KzVGbkpqdEhkbVR4VEd5d2hLT0ppUGdoNndPaUJKZEtMTldOQWNZRzM0WHIw?=
 =?utf-8?B?M2IrVitHbUQ5bjhEZXVPWmxjeG5oKzBNNTNIVVVxNUxwRVdSOGVnRnRjamlZ?=
 =?utf-8?B?a3V3RDR4MHlDeGtoejByZnlaNlh4NzRiNmtaaXk5RjMwMjJEU3BKUHB5dzU4?=
 =?utf-8?B?V1ZNenlNaXlrR2J6eit3VmtLcXJaREJlZG9VNXY5ZGlTcFVNcENacU1WNncr?=
 =?utf-8?B?d0lSaHozTFE3SWV4Y25GejRtRHplYmh2Q3QwckdBSjI3bjRRWHVCUlpTdFVG?=
 =?utf-8?B?dmpIUUkwNitXQmJKWmhTMjlQR1FZY1l5V2lEMS81WkNjMTIwVU4wYytxMWJ2?=
 =?utf-8?B?OHM2eGpudGxTODZzV1ZGczhMQjUrT1hWLzh3TDd2blBKSDg0Um5RZ1BTeFcz?=
 =?utf-8?Q?SqwdmaSxicsQ+4sfPkzSHs0MHHTxWq7VlTewtBUcIcjqj?=
X-MS-Exchange-AntiSpam-MessageData-1: sMf4NfnnMjWTeg==
X-Exchange-RoutingPolicyChecked:
	Oimx1NuaqCvxm9L9xL+nXve/4gtH2cHiLWpIb89YTvSsyX7kenTNIT4Ig9uZMjTntMaEkQjthx2nduw2Tze/u3qShpgl+cJsIffBRNmf0tyNdtbqPQKLGpW1B8AdqanDr9dhVq4k1lJSyVwZiQ+fjuvv2+KKy46k5SkcsirerOlCAqVVO69HK8UuxW58o9JBJaIV5xmPLrqt35iCS10H8oe4vNp1u5awhKjg9LNEXUbM9LTzvzWpfQ+sSP7GzOdq2dwzdQ9oSolcQIs3HNoa76xzx2HLUs5FKMD5KWkRMLFQrdDF2jgDfeEKLx7OJDhEDSGMS+Z+6290HeZanSXKBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6oSiA5cdM7yRQqe39HtZaXivxzNCGC8IVfQ26xT08rE1xO4rc4TJXF7l1YyV2fAy0f1i22Ni3qLT1r7Ldtb4YESXe6tY05GkhlbiypI8rJuwaYF+obz3DqKQ8lCCZKHMk8GOzir5YnfLIKceu9uhCYaPlK/akeS9Tw2k0lG/u7i01rFuvZoBCjtoIqhxd/MUk7EFaBOh5rQffzHQ3bFUlCuasYR0k8IdgHXlKOPsXDHjPaxfRXakfzzbMdGqsTnmHn6knwH0ZGf2raFgzBO8ZqwiyPtxC10GuCYiiHHqhc/BlcvaixToIbbExC4oaxjHaGXtjg8PT7itCxhPbLVXr9utw+RpB8Mvs2ae9N/kKDZg/ojXgCtxdYUMLkjVhvLbOBwu2uzPv9bT4yV5Qv5UwP5n6i22oqEysTwM5QssfuhNm7Liltyeoox8UOEwWInUq60lVPQBNbCFAH5WGV5c9jFiVctHe+yDmkjKgfd6DiPn3RaijXNwZXfUPZ6umdaVBN7cvH59Qdp9B70Dyw66vnJCtGgO3yRgz7Kx6UT08cqS0IX3f/UJFIQHmle6VgpW2Fd0zq0Zmat2GatpH5dOTF3Ii9DkJf6+tt7DXE0SD7R5+TJkWmn6ZlfmnPG1Jzjg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e5522b-2b60-4c58-0e32-08df4472edf3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 06:20:52.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RxCPs2ScwbNz07Ggqm3ZrUyIP3xC98SvOqGZzQ9gGSoZ+Dpmg4XtM0N1dSbnEHkj5AXqye9sAEx5jB6o7VFJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9407

On Tue Nov 10, 2026 at 4:45 PM JST, Johannes Thumshirn wrote:
> On zoned filesystems btrfs_delayed_refs_rsv_refill() returns -EAGAIN if
> the delayed refs reserve exceeds half of the usable metadata space.
> start_transaction() then commits the current transaction and refills
> again. With concurrent writers, or once most of the metadata space-info
> is zone_unusable, the second refill can still exceed the cap and the
> -EAGAIN is returned from btrfs_start_transaction(). fsync(2) passes it on
> to user space.
>
> The cap is only meant to trigger a commit instead of overcommitting
> metadata. After the commit has run, continue without refilling the
> delayed refs reserve instead of failing the transaction start.
>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation=
 to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good to me.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
