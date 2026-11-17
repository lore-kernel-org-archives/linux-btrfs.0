Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794891662;
	b=Frou1XepAQE6WvKloJq6DCNflr3PYwlnN+qY3wc1q3LTpLwWqSl1TCCji62B/8mI7oX9
	 uBsAPJEkYHkUrRnwLlv2RZK3MpwIy24ycj2znyAtazeuR278z5l1/TwVLVtqYdyMeYtdg
	 SmuVINBvGB8eURIBx2LgJztn4dDkIkujH0S0sk9fLkfT4XM1OqTkOT2SQf5Vv34PMqytL
	 zm03t2bEssYlXbn6BI1Nk3/OScp3785PMTLJsuoS0ouW5PmtwIV+moJm7XLuQmgAvCvyy
	 LF/LMUk/1ZD3N+xdp8fjWdp/P9FrXHztT3KHg2gsn40jUyDk3DJw60p0ubiUZlxx6lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891662;
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
	bh=XBanaIFXiBrPcENLExqfb+dIwUik/UY7b/Lf/zIgV2o=;
	b=hYjJwi4CmhjVtMbhtYWqV07c1Ry8tZDXGWWZUIM10LoznQvAfV4zviKPYCPchpJJjAyg
	 GKjAC4dMXl06aA15nGRqK4iRzCLSptvHQ8RZYABpu+06nvwypFTrVzP50LZgZSZkdarVa
	 wDE34VeGXq2df8CqC93+b9kWKjFFyG45N1GHJrol8nNXN3l0STBET9zgC7vMottyb9XlU
	 waQ/ZlhCMEW7Rma6KSjfb8PGqvwvd408loTFNJPrrjaf/tlLuuNQmFMvJkOWNCN76Wr6m
	 VqMWLeZRCGcMlqMcKmLewg2rSgUm2G3Y7bjnLJDFtto7WzgF7t787R9zeR3BfP7h8EA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KOtWhj8M;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aFLLRlWn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F4E606A32A;
	Tue, 17 Nov 2026 05:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81F4E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KOtWhj8M;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=aFLLRlWn
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794891661; x=1826427661;
  h=content-transfer-encoding:date:message-id:subject:cc:
   from:to:references:in-reply-to:mime-version;
  bh=XBanaIFXiBrPcENLExqfb+dIwUik/UY7b/Lf/zIgV2o=;
  b=KOtWhj8MOMHC1j2N7cZ/QNEqNRQmb/EVWDhjXKNJKueYbsqvNmDIuGlg
   XELdK2tB7uf3efTpjMMHoZMtTNE2UzkYl1AkM5a88Dx9ChjNlfvDmgT0W
   sfpow2gqrYKyvY1t/OvnT7bmqd0MOUuMXtMWhk7PQkYTr56kKf36pUreH
   XFzbohYzh7Mz3lea+KoKFzmIUHeTMg/43dHyxn1hjvyFPwT/XsmWaUfp9
   tiKcQxhqmpTDqrGmTiZLja4C0ayI1JnoUzpsSdBJqGp0Eo4LqpczuCRPQ
   j8oo6zREiB9eveUdl50MBteunUrTZ7HUJQeCSbgczj/DkmJSIjaz/9vYv
   g==;
X-CSE-ConnectionGUID: UyF7QXu3SJ+6DGZKPZMu1g==
X-CSE-MsgGUID: 0iK660oTSvCGFQjaZkguTQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="159447335"
Received: from mail-westus2azon11010033.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 13:00:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CWTqlRgRGN+fHfnxiVZhy9T919tsu9Igh40GiE3PZ+B4E+X8pMW22G8LpRl60njDicVUr2TpaLndaMf0m/x5oPtZ6DLu6g7JFt6ppCRmUY0orGi+7g7xI+LZgwZTlinrVQM9fYZ1VnHB7axhjVud74aybQvUsArZG2OKVI0zUJapZGVUNZU4zHwK1Lx8CIdiW/2pSevqMo2Vm5NcuBOmwFotnOr7LsQkHIcqoxHQzzpSic+RNb/wrnM4SyeKxttFV+e71CJO4SP1XaicuOha5lWKWtHXUAM9mRcSvZCDl8heAlm2g1w3c2gNM7vFAKdk7ETKmuKu1ZsPGAlq4yl39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBanaIFXiBrPcENLExqfb+dIwUik/UY7b/Lf/zIgV2o=;
 b=RuipGlbkvqXhg5z3ELDDCYFO2f1oqxQUVkDNUE8gSNe3dhR26srugOP6mnVaDEuzD3svyeBmonkg/fVRP+7N6fXHXgti93PQ4XQRjL/rBa0thvvnIX5qE9/r6tRsAynC8g+/jPn3Z5qslR5/IA62TjFxautQOeajFcx3Z0v/Toh6XfDwfVtV3YSep35xA2kC5kRpwQZ4FH10eI4RlRqJH7+VhcaxW25IfKC7MIdOXbajrrsIG0ibyIeJmD9bL2xZo1uIe1AXlmE2dcD3RvFLu+xEHcxwpcfDHlBQj8nVjORK7V4Yz4I3crXwrWm5/cQfpZihzgXEyXBoWxi3/Wt9zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBanaIFXiBrPcENLExqfb+dIwUik/UY7b/Lf/zIgV2o=;
 b=aFLLRlWnWad+2pRCsyaXGZ9yXLhSptw0n+KFXOItVgeavJUhABl555JKhfUcm3kZDJ9HEa8eU4kGRhP/rpz+oJrUB7FBC0DTOSm5SWxjKE7iG1p40dCdzR+/5drsRHTUMvk/2FaVPl5B0n3ZTdjelfdS8ORiawSkAcXo5oVQPds=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV3PR04MB9258.namprd04.prod.outlook.com (2603:10b6:408:26a::17)
 by LV1PR04MB993643.namprd04.prod.outlook.com (2603:10b6:408:3f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 05:00:51 +0000
Received: from LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2]) by LV3PR04MB9258.namprd04.prod.outlook.com
 ([fe80::1d27:4d42:3be8:77f2%4]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 05:00:44 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Nov 2026 14:00:40 +0900
Message-Id: <DMX7ZGF2CIPU.LLR0XYTGV2Q0@wdc.com>
Subject: Re: [PATCH] btrfs: tests: zoned: fix NULL check of the active
 bitmap
Cc: "Chris Mason" <mason@kernel.org>, "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
 <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Naohiro Aota" <Naohiro.Aota@wdc.com>
To: "Yifan Feng" <evanfengff@gmail.com>, "David Sterba" <dsterba@suse.com>
X-Mailer: aerc 0.21.0
References: <20261117035155.86323-1-evanfengff@gmail.com>
In-Reply-To: <20261117035155.86323-1-evanfengff@gmail.com>
X-ClientProxiedBy: TY4P286CA0049.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:36e::6) To LV3PR04MB9258.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV3PR04MB9258:EE_|LV1PR04MB993643:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fee1241-1fba-43df-8e36-08df4467bca8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003|5023799004|56012099006|11063799006|10067099003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	n2ErdF86BCHTVmLH6jnGLSmK+PeTJGwIG9BCzNwC6w6+i8Jkv2Fxh7gBGUaCkbP4+pK65Pf1gAnU7fxuyFtTJJgsnDjLlVbVPwSTN3IhQTPrDZ5/4hieF1g04qj2+mAdKMrPyqmJ5uac/yMB8nmHd0HzjjQE0wu+mY2a4O/msUVeAsa9J5ljZhl3cUy+3pvungBGlLp5Y+m8zCD3BwDzrUaoiZYbFDTL/UxJHCufm9o5tTpm26zckaHAxBogob5gHI2J0VeOsf4X+X8MYGwT3Z16Tst4PKlK13NiVcuMKW9QcFYIs20BiFEeWaA5oFgO6rZQs0orGpi1UbPj9SGDwf4A8Vn0cdKDayhyDZgpfRSAtXRSkI425O00LHkt9/MPgdfG5dBFEdITg1rYz/84jkbk9/W5Y3CQvh4whiZEBaL7rByaIWSHU4UZdDGXjnAlG/oEaoP/HdzfWn/i7atuZ3vJYZEq1R4DQu7MM7YHdG8ahQL+CBrLVdJx+FXx8UUe0Af9SW3sclSKaHf9NxHmq04/G3V3aqy6LUJOzLdIR5rDZ9gEKSzeNo6Au+cOogH1dn6V5QIK4yJcXVTARIE/w2iQq8XMuVQTcOVNITThiXs3/oycBbp61i7i+MNzsdr0uBfnXeEs9reQqEpPa92Mzm1nRB2Y5/X+VWcy/y+FLR0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9258.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003)(5023799004)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2YrVS9xT1h1ZW1MNXFvZ092bVMyNjZFd0RuWGovVUp2dzBhRDFxS29PR1E0?=
 =?utf-8?B?TWFjVExDVlZhZFpwejBzTGg1WTFhSDJFVm15aWpoMjlZcURmQjlFNjNJdy9X?=
 =?utf-8?B?aWE1T3V6NWJUNkFUbVNCcXIwSkJVcGF1cW5ZbFR6NEZEUDNqZEdhV3hpcXho?=
 =?utf-8?B?S00xTFQ2ajBkOGJ4WHlVTS9ZRTBWNHdiYmRISGJDdHk3OHdVcmJsenJKbXVG?=
 =?utf-8?B?NnE4ZnFkcEV3QjZIU0swVWI2L3dKUTNKeng3akN0UVpMUkNjZFprUzNWeitK?=
 =?utf-8?B?NFhMdVdoYUNQZldMYWhFdU5WL2g4a2ozMHZUNmNaZC84RzUvenJMc1lObU1R?=
 =?utf-8?B?NVRDMTZUVTFEelZMa08rWlVrSUE0anNrYmU2c0svY3B5TjkyL1pNUlptVWJR?=
 =?utf-8?B?RmlWNmlrRGxIU1g5ZHhTeXZqM2tiUHJ0Sk9sOXFYRjRyQUZKTmFneGVObXBI?=
 =?utf-8?B?SmxxaGJnOFlPM3lCSm4xNDJ0Wk1LNUpMa0IzanBrM1Vvbys2eHNKSTlycUZ3?=
 =?utf-8?B?eTNxV0x1RmhYRDZmalJrTXdLMlZONXk4MncwdloyeDhyZjk2OU1CN2ltS25X?=
 =?utf-8?B?QVNUMERXNDN0R1hxQUpnV3lKL1FNL2Z0YmgwTWY4NDJRQ1BVZ2F0WXpzWGc1?=
 =?utf-8?B?WTNSaU9uMG5Xa0VkVkFVT3ZJWlJ5d0lrWTd4NFg5SksrdFptK3A3MHUvV1N6?=
 =?utf-8?B?cUhMamZOOTBQOG4yemhnNFM2VzNzb3NUL2VBRXVuYjZNWHRsRjlERlNBVGhr?=
 =?utf-8?B?NU9LTjh2ajJDMzNXTGpjVXZ4Ni9NT2VmZlZJa3Fra2ZXekhUcnRTYkRnM0RH?=
 =?utf-8?B?UzBFSmxBdjRGRlN5Y2s1Yi9jQTJFWFExWC8zSGdXVFZzeXEzMUJDbnRiWnNJ?=
 =?utf-8?B?NEt3MkF2bkJYTENMdHZKdmpLTTBhSzB2V2FpLy9WWk1IWXQ5YTlLanl1RzJs?=
 =?utf-8?B?ZWN6ZkRhL0VkNnM1RzRySi9xeE85S3pkdm5iWHk1Z1h5b05MbGkxSjFla1FT?=
 =?utf-8?B?WC8xemNpMnh6NWJTR0FsZ1VUWW5STGw4dnBIdlhQek1ZcTNBcnJtdzhnYkI5?=
 =?utf-8?B?RU5GTTl6aXZHNWF1LzYrUTFLSWMwWkpQQkorTUJZNmNiWkdRUDZwSTRRM3I5?=
 =?utf-8?B?VTBvRkIxZ1JFRlFXcU5vd2NCeWYxd3FiSGVZaityZEhMNlZXVUtGM3IxYXZV?=
 =?utf-8?B?bStlUFUzMjlZaFdncUZjQzhOS29KYlJhM0QzSVZ6QURkdnVHM1hGdWIvZk9O?=
 =?utf-8?B?NXBWanVhTWpCYkRYRjBqbis1VTcreU5FY05rYnN0MktKRzIwVVJSQ3E3cjZj?=
 =?utf-8?B?T3hxMHI5Y05iOUpTTkQxY3ZRK2tkcytjZWNqc1JuR1lIVDQ0dVNJRmhCQzNN?=
 =?utf-8?B?Ymx3NUM4QWw4Y0dCbGhyTUt2L3kyNzlNZytsRzdrK1luUXFxMHNEQmlQczY5?=
 =?utf-8?B?UGdqYmNZWnJ3Rm1OWHVRczZVK1h2V0VSVlJDeGFsRlBzNU5mcDFsK2tUblFz?=
 =?utf-8?B?Vm42TlB4YTdWdjEvL3FmYlZmRjg5SzA0amliYWZkMVJpaExFR0VFem8zKzZO?=
 =?utf-8?B?MnpDVEdqbHEwdjROaFZkaEJ5TDlENkNJdjRUY2w2MFhRRGh6RnRLaXBVT0Mw?=
 =?utf-8?B?TkRYeUVEQ0tsZ1lvb0UrbDJLdHFWaWIxOURHYVVLN0FxcGsxd0JRSVU1MlFx?=
 =?utf-8?B?a21FWmpjVjI3eEl1NFhac00yTUE2UnorbjdHQ3hWK1J6ci9RK29OejRETktS?=
 =?utf-8?B?NGFvdU00Z0wrY2ZwVUEzc1R0bVZXZ1hlUjBrWFhDaU5KSWJJL1FudDNnRFoy?=
 =?utf-8?B?K1BNSDEvalp5NkhKUmdlTkJpTDdId2ZMNmM4WTVpdHpkRm5Lc3l4b1hMSThK?=
 =?utf-8?B?RGNwQ0ErNEYwUVNZMkVydjI0WHdYTk4wYit4RVB0UmpUUlZNbUljMmtMOGFV?=
 =?utf-8?B?M3ZBdEMzVjRaMnZ2L20wbGtVbTN1ZTJ1ZXFGN1ZIaHlaM0tqb2FyNzBLcytG?=
 =?utf-8?B?bXJ5U2x6ZXZyM1l3OE13WlV0Q0tSY09YL0ZFY0JnOVlhT0phK0YycVVFOWtx?=
 =?utf-8?B?aktYZy9lVGh0dUlYazlnM251bVQ0aEMrVlVXZ3l1Q1RrSTFRQ2RuT2hEdk14?=
 =?utf-8?B?MGt3eWpVSk9XQVhHUVlvSXIwQytHUURqbzF3T25QZHRxNkE5ZE5RSzBrOWN3?=
 =?utf-8?B?cjRhOWpocHZrZlFGcStiSit6QSt3RldRaUd0bENBOG00a1NhRzhLQ290TjJj?=
 =?utf-8?B?dmxtY0xFYlBsT2x2d3dFWnVZNFMyTGNNT05FSzBKL0dIbDRpanhkOXdDN1RI?=
 =?utf-8?B?MnpTYVZxYjhKck8zT2o3aWppdlNvSE9yL1JGelhMdVFGQlhGMnltUHNjbEJi?=
 =?utf-8?Q?swQsMKXFMRrOUSwb9I5Z2w5SExSFM+6DAgsKSp3vQDWwB?=
X-MS-Exchange-AntiSpam-MessageData-1: rQkas81OdS2xFg==
X-Exchange-RoutingPolicyChecked:
	cN4xMwSxe0FNQInYO8lrfa8sup2C2DrXJCQwrbrPBHwwa0BNVZtIa7NPDxi1yUhzG7GlSXMhZUmwXlPEqeRTGIAzkgqDMjDT0BrQ38QCu/xAqsBZQXscgkjb/18Sm/yVA8jeHae3wt68wJgkvf32nWFSM6mr6c7nwDYXcXpte0SPW8T3mg9cFntqT1th2wGom6QNXBzE9B6ICNQfyC1GSIms4nsnHsWW9+Aqit99/YcVlRKyJBnaC+t4iGeb7JBlr0I6IWJ+AV2350PItHpr6k3rO0i4Uw1hfCJ+9LDF02z0X8n1C+hlV/B8FmLsbuM8/b6QJkdpabMFaXD0zu6iKQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eYxFambtJnRaZ0/FkCi/j9X3Accru9ssHv9n+hH3yASXij+OpoLLzxEsk/f+ArYNylhMFWfFah7+MHn0VsKHVYKRolNvmzTJ+bZlJMetRd8Rk88yN5JEQd1eYhJlvqE7wxYWbknQiLpPXZRnp+3y+vq/PpgEQoHEI8HVNCHX0M8WTwGuG5w9OoujcXsn9pqAf0ttOczmnru4kOU4oP7GeuLvoUbrKiJQA9ioThbMcabeAhqJPz5sc4YXPb1tOc4y1/ZamMjF6upoepIFU9sHiJQMxzxwKsHElzzxFRWTNCR4hhFLc+3cAPVK9mxOsCAFN74VtnCwJQdwM59o2esLGwVPdiA0dbaFwvmJdb0va+Wwj619H+cUuR65qv7T1pYBRNXrgkLs+6cLSDaKThu8FCYjdk4F/RPRdtRMzso0yAkRjCoiPI4apmdNnojdtiRV9BebaO7spcmNOBDJZ92QGRnwAem2xjlaiwlu6T9KRqqN7PD/gdqYTuHgaCxb1gpKmJo4aPkNfn2N/Bu9v5rj6anfx1IAa+3ni55TzbsVG954TakrCsclElnwSGCh+5n+iRw9bMkJjSA2jSx2U+Ank1Ljt/VOMlVlx/pfGiGcdCrDV5oGqF01NatF14gmlUF/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fee1241-1fba-43df-8e36-08df4467bca8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9258.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 05:00:44.8804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRcJLYNqKOc2ctDwF9Ho9ts6XYUgfScRiTFKq44MsPJYF9bKky87aHghQp5jUiGteDJt4IsQrHhZ+lFEy/ZTKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR04MB993643

On Tue Nov 17, 2026 at 12:51 PM JST, Yifan Feng wrote:
> test_load_zone_info() allocates the active bitmap with bitmap_zalloc()
> but then tests zone_info, which was already checked a few lines above.
> A failed allocation is not detected, and the NULL bitmap is then used
> by __set_bit() and by btrfs_load_block_group_by_raid_type().
>
> Check the active bitmap instead.
>
> Tested in QEMU with the bitmap size temporarily changed to UINT_MAX so
> that the allocation fails. Without this patch the kernel oopses in
> btrfs_test_zoned() with a NULL pointer dereference. With it the test
> prints "cannot allocate active bitmap" and fails cleanly.
>
> Found by searching for a NULL check that tests a different pointer than
> the one just allocated, with the help of an AI coding assistant
> (Claude).
>
> Fixes: 1ba19a6ea9f2 ("btrfs: tests: zoned: add tests cases for zoned code=
")
> Signed-off-by: Yifan Feng <evanfengff@gmail.com>

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
