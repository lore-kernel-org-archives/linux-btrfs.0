Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63513D810D
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649049; cv=fail; b=FkYYIIZkwaY48sLYtqefKNOAgzI+0r6OWawXAcpFOn9a25QiyYGDDTXksJ0UxJixVOoYGHdZJe0MMCzBYSDW49XVCF9kV3wFbLUW5muoGVpSpcG6zJcq1W6gQprvmqUPh1mFPYliV9QoXqaKVqzWHX1YPZlvCGKQ/XdzMBeUOQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649049; c=relaxed/simple;
	bh=0iSFjB8Azuo/Bb7pp5uBoKhMw9AzCJBNtWfA2F5LY9g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bnxp2iJYOCf87JQuZwWdl7OcrKcQTx5n8uQ3ewS/TUoeIBudeswf5bhEM5EYSwVEv7tT5+olmmESoYTWZwK7d7ex427dNBeCZEieWDeLhHtEB4IgYn9b2XfpENlY3q7NY3PhhSvEdLZp5P5lxZ4uGDNCNLKSKQJccYhODarHwlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JvvenxPn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=iPIO4lmC; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JvvenxPn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iPIO4lmC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787649047; x=1819185047;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0iSFjB8Azuo/Bb7pp5uBoKhMw9AzCJBNtWfA2F5LY9g=;
  b=JvvenxPngI3WVJxj7zffOgmNHkhSzs1jYkgaWoek01il0yyjBculjaER
   eFgpD6dNYduwFo3oi9vNMtcHFMOkq11NYRN3zP/gaOuHV6GV7krLaYclH
   QSsp1pcrhSaZL1sydoCzsPGgthz89P7P4UHDC9ietSij+mdzYGqd6Oaaw
   1I5Ezp+ZnBzJt67tPHi/COiYizi1tFL2unQ2wKnDzj6r1jib0r0NngmYK
   QgqKUXa1JlLzjldIILtOzRkeSEHXuU5qV+ZbFfYFtmF0sDiyo0Mfwh12Z
   MFhyEeMh8H9Je4eIaHt7M823yk7MRLZXmuVCe3f6WI5LLF2OzICQn1hr/
   A==;
X-CSE-ConnectionGUID: qymhKnN5R+6T7l/S4+E/JA==
X-CSE-MsgGUID: dWyCYGggScqsffFxZ8kDUQ==
X-IronPort-AV: E=Sophos;i="6.25,242,1779120000"; 
   d="scan'208";a="153988928"
Received: from mail-westusazon11010052.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 17:10:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8RIVTgO0+h2R1DsizLSBgCUfEHW+gUOg9ls2NfyMow5RrCWemsA9v0UxbJpVsktayFxk4iUk/EBvDju16jD1Zjrh5rBaRmN1vLYoquQJzjVPpKajkHM5Z7ZE6xK96oTGyM82AEVsOIE6WRaZxSyECEylCmXsO1CYFZpz5fH/InBP//cz3mBZuVw3PC0/Ydr2DEcPc5xgq/5n1sosvRMmMdVL9wZlCEsF52ftJ4Hl6xmn16zRF40dZd8kfOCAVKwUW9oM+4eOG/ZzVkV0tz+3iHpaTHXZlCFIIfSExEjq9NyhC2YI3i0ke6Bfa5MlCyu4NPK1YwbsLbo7PW5IyxrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8Kwke/zWzsrsNqM+MC6YseGW1NbJo7W3wjoSuGRSJo=;
 b=trgCIHNcIxbVq8Y2w2nN0DA917D8FicIRQj5Bjtsu6dgWPQxF0FUmQ/NMBTPXniBdd81LEgbh3ZAprCl/3wqFo8AkwG5uXRL0t9F7owL/26iAXFy5gCOoc06ZAHegPwopFk7RFP1wx1X69MvxklQo5xnlc4L887HND61MdDIj1vLvhfqnh+pKKT4bSQYpL0n6b/Vd8s0kUU/pqEoTQj7eBESPsTQUgkbQDwlhIB/fMvMtbYYkX3VtZPpPRZYFEqq4GR4I9Ek1gt7BWU3qxsLHbR3Dad7/H+y5PxWHxTXeNcheZAH5EcnOCUn3NgxMJdqGzP2FsesvpJqPJAfgyAIVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8Kwke/zWzsrsNqM+MC6YseGW1NbJo7W3wjoSuGRSJo=;
 b=iPIO4lmCmFhOcJh3T8J0n2/0nLgdKdAVBob3KG/VFPQKdXxELnmLAPBlpD07qNpKWlBccX8YqFQb3sJzJMg73pfu1T4HGc353ytUA/4qMWwGS1SCKPeJWA1+KRcOWAC3c8zna1slJBJiEtY6iL5q1HqtrYnSGWt28Q0YEXQWmjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6740.namprd04.prod.outlook.com (2603:10b6:a03:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 09:10:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 09:10:39 +0000
Message-ID: <8a708d2f-a835-45ce-bbde-b5b99852c179@wdc.com>
Date: Tue, 25 Aug 2026 11:10:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs: zoned: track only sequential zones as active
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com,
 Dongjiang Zhu <zhudongjiang@fygo.io>
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io>
 <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
 <32245f5e-59f1-4e9f-bd24-d55f2a17f158@gmx.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <32245f5e-59f1-4e9f-bd24-d55f2a17f158@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0380.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: 849e82e4-0c9a-410f-9655-08df0288bb20
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|23010399003|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zYyEZVnxV8ZmpO+Icjv+rtTDYzwqkfeahdfpnNeMbxv2oR+x3E6BV2eV1k/hs3LktVP9aOLfP12BVCJ/OjjcGdtSzfuFQO/9VA+G4z2tZ4iaNr52oy9KkPsv04LByB7Lk1zHz4EVjjdG1X5A0DTJSd+n9w5CmdlR7zJNH+6x01PhXd5sOR5EsrK6faNf6d8nj7pgY7J8l/QzEeg7gNnkN0HgIsQDJtuEmNE1ROTloSVOvgs2VQ1ly0lwP8SZUBiIP9qRivF9f6smXSAkoHR4dJU8WBNwEOgfu6ccjY6uVtUMc2jf2Mesurxm8Y4jxHx0O4cdlW99IZZJ5bzyZhijmhYd4RlQTNuLZVR83513aUPJVpX7D93Qlaezof7GFrUs36FJCaqNtahaELVTC2Qs32UCFVul4IoNBUDUS08k5OVcz298RBRHa4vXpIJI4eNXfJba/jHcj663WhiMrajt6R9LvEL+X6UuV3PUJ1XDy0x+Dm9azh7Plq6LRNBYb/D7ezWHORbD3hgMsQ9CaaQgRq7CrOM23KrbURRlHx2gNbPYww/5y41LFdCRkZjwVzDHHVgb1DU3h2PO3feTchl2bWJ+4x0K5OvheThaUVw7nboolFoeXvTDbqf/IUvHQMTiDG+mRAL9qitP53j2XYmuNhIOYacDx+dPIpvSdCWAeaE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTdXdE1Yd2hUUGROeGlQbmdqcGJRRmszYmQxb3gyN0FTaUNVNVEyRTF3NFhI?=
 =?utf-8?B?bS82QThHL05sVFBSUlNnRUJ0K3ExQ1kzbkd0ZGtqcGRZc2pPa1l3TkdqRVo5?=
 =?utf-8?B?RE5SMDFHSndqdnVodWV1cXNpUEdxazhRSTQ2eTl5d2lkR09uVStacDdHc2pi?=
 =?utf-8?B?dVRSNGFQaXFOUU5JNFdpWkdad01IcnE4cDAyUmJTVDZwT3B1Y0xadVZTUzdj?=
 =?utf-8?B?aFNLdlFZYlpZUHdTSkR1Q1pqQ1BISlgrL0JodFNJWTBWSHc5ZDFvZHB3MFl6?=
 =?utf-8?B?NWROdlRNMW52K0ZBL1FtK2c0NzBkU2FrQzdvVE0rQ213LzkzZkREWnVXaU5M?=
 =?utf-8?B?SW9wdGNOSmN2NjBUZUtBNjRwSnROM21SWWlGK25kN3RTOXBOREV6YjJaN2Fz?=
 =?utf-8?B?KzB6M2JYdC9GSzQvdGhmMjBHT0J2VjB2U3RjMEtTcXFtTGtrQXQvV1ZJemVo?=
 =?utf-8?B?MkQzY0lzMUtURU9ZTGYwelNHQjNBaDVhc2NpMUhsWjZvNWszTnlBckc1d0RD?=
 =?utf-8?B?OUJYZFJzNXRlTXVEdU9NVDBVY011bUlMSEtkUzlOVlJyYXJadnRvR1NWQy9M?=
 =?utf-8?B?My9HNVY1VmQ1V0N1a2tVOVJIcDlPRDhBYWd2dkg5ejN0S1JZeFFrQno0aXky?=
 =?utf-8?B?YjVqOENTdGZQdUxzQ2Zzb3RDTVpZUGpwbGNUOXpDVmdBYUR4Z1hzamd5U1N0?=
 =?utf-8?B?TDZOdy95d1hrazh3Uy9RZzhlWlRHVG9BeHRuNmRBZmZwU1RFL3VWUTZ5RzR3?=
 =?utf-8?B?V1hDU0lyU2UybUlrVHlYUGYvVUlYcVRTWjU1Y3VmSnZDaDFMNjIvSEV6aXVN?=
 =?utf-8?B?S2FnSiswUGhUVmYvYVlwTVdsNEpZTDc1SGxIT3R6R0EyWXAwTWszQ2c2ZU1Z?=
 =?utf-8?B?QXNzeUtSZXIxbXpGU2pSTXR4ZDBtbDRuR0w5YmdRZjVhN1ZhcVQ2bkZuVytx?=
 =?utf-8?B?V0lxUUNCaDU2cEs1Mi83QjF3U3psczV6ekEzZ3ZFSGp6UlBSa0xVZTNVNFNR?=
 =?utf-8?B?NWhJd0c3RllTZlMzTUhmVGNCbHNLamRyWXJBa1FkMzdPa0NreU9TSVhYNmYy?=
 =?utf-8?B?OTZWRlNia3d1blkzc2g0WDRMTDNMOWgzMEdLOE01TEwxTUQ3aHgvZTY4alVD?=
 =?utf-8?B?TWpqUnQ0YmhCOFF3bGVUQkFqMVlkc0hGaS9GaHg4UmordmN1VWNiWlF4T0FP?=
 =?utf-8?B?M3pMUFQvQ2xhb2xCSmVISFhPMmluUmd1M2xEM2VWYUdRa1NlWTMwUW04Q00z?=
 =?utf-8?B?NGhtVHpzamh6WGJvSEVJb1M4RlRLeEhKTjM2Zy8yaEZzTXVuamZQMDUyOUEv?=
 =?utf-8?B?aFppUXJmVndnRU1rdGlyZWErOUNKK1pnenZISzQ5SmFBMDFEUFF1Y1VxNXI0?=
 =?utf-8?B?ZE9SQ0hvVUNnTFlOV0kvbEZFUFF3cCt3bUJMRTlMek5pOW16WVp0NUlhY0lL?=
 =?utf-8?B?Y1BIV3ZQZm03UkZrWER4ekxoVnd6S2I0OGw1U0NHT2preE1WdlNQSU13TlR3?=
 =?utf-8?B?TndYVHpsS0dsOGpwaENFWG5RSDVCSUlmRjdGcVZXcGtobDljVGtvSUQySTBp?=
 =?utf-8?B?cGNNdmZ5OTZRNTZjUGl3MXVzb1V1K3RTcGRwUFl1ZTlBN2d3bTlPWGdxTVJk?=
 =?utf-8?B?dnM1ZVBJT2t1MTFCN0NiL09BMGJLazh2T08zcG1rbWNqV0pqcGVnU2dSQmVL?=
 =?utf-8?B?WmtsQWZ5S1BrQU1mVGNFeVBPeUozejNPbTVUaWxSTzBJUjZPYUw4cFV2RzNh?=
 =?utf-8?B?cExBaEMwc3BjZE5FdWtXcm1qdmhtcERvclpubDBGVWlGcC92U0J4MWVVaGpy?=
 =?utf-8?B?bWtVSmhZN3pWRWsvQUpiSGp4ZE5tWVcrU2RzdWs2UkJqaHE4UHJLNHFxcGt4?=
 =?utf-8?B?WEpmNW02MzY1QVk5M2tlWHF4d2tIWVM5MDRyR3JrZ0x0VkRkWUs3UHZBaU00?=
 =?utf-8?B?bnp6NFZXQVNWODQ2QVZoYUhCWTdzL1V3bnB4Q2R2UVM4bTRvUFF6T2ozMGdz?=
 =?utf-8?B?cDdMeDFDRG5oNFJ4QXpKeDBma29Rc0twajczVFdoWGNxWlBEdXZuVjBMaTE0?=
 =?utf-8?B?aHBCMW8wRjgwdStZK2pBMGJ4RXlwR2lnc3pMVG9jWU0wVnVmWEM3ampVeEJC?=
 =?utf-8?B?M1lzZitqVDgzU3h1VEpSNnhDa2g4QW1hejNmMXBsdFJTaWx3dUhoQVpTdWho?=
 =?utf-8?B?QzVjeUhNQ0dCV0E1MWd1VmdBbTNRcjB4b1F6emUrWVVVWFhiMHd0NWVXU1ZP?=
 =?utf-8?B?MWNnS09DazBTZWl3cDNFbkJ1cVBjSnVnYzg5K2h2b0hhMFFZdGQwUTdDWmZV?=
 =?utf-8?B?UkUycmpaUjhxNm1uODdCbkNKK3c3QWd6RnhianVINzFpN04wYitMY2JCaTEx?=
 =?utf-8?Q?/p8d/grgBT9dLpDM=3D?=
X-Exchange-RoutingPolicyChecked:
	tQkJEYf/os/CyG5bxUY/uaPqTyx210IUiaKDAqbBNZ06cwAq5dSmfrJVCwXoAfTMSlBosJxpbINj9o7ZGKGemQzc/Ay8/nx7ORbnPKcK70or3hdXvXYYgJnoL5rcE+wiQj6tUESZbXt9q2q0h85NlE05RuyzT8Bq7aeKWRJyOkE402hA+xFNMYeCC7OpknFVtVEv77CHmRhe9RRy89Vy4wXlM1xy9lfmTL4ZjvET/kVDBrwJ8WwqGe49oNFUZ3+W372X2OxMotzqb1vwID2HPfmdQ8ysg2RdZq36KCfm4Sw+N2/bV1loFHh/S3V1hRjBcvZSYFtiRVU4XtNgf6+HFQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ws0nYmdkjbNnZeWvGTVr836eVdLR/UBrEYYADt8fSZoAovYH0Fj5C7mm4qy4w56VRjjo7zC4V8068mm6p1Nj8+nhCEax/Epxl2U5S58slp8P4LppsOBHdmWjXuvvAfsHUKK1/qTqrzI8bhq+s/jOns/HgRembJA40Cn/QoauLmMOjQNkOugqBvXZAbdIe49Z5tDvZX9gpdcvL+E8GfBF6uf414BmSPHXpdLwALCQF9eMPJJkLKWWbQU6Hupdy+NyMFcixCXwvV4ATSM44Ki9TV2stsszVdp4stu4CdoldodDSyzawevp7RlcEAUc6Ed3slsWqiC/vn9HsS+hJPh0GLk3rbKPgXLgqEegeVItgsrkb+JOILOl3BoqokNi4mzckgCSVgqwdnhk05BdECd8yNzUEpbR9hBgGdRqZiYyCLM3dUmPUUJ7rckFhETWyJOeDHMlO11uT8dIIhPutMDzFIVFRxh0bZaKrSwj8+YKxiI+sVgshSFiqToZoIyTloDyGP7gNbnWk4n53dgkRQGocanwo7fYEl9uz20uEpP+RC76otYn8Jqgn1G9jOnxw7D7jRF2orwKA1IIo/YqZyZG+nr4Qiy2IeQ1AgmeBrMyePgag2FKCYbtfkv4UmHWcLNk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849e82e4-0c9a-410f-9655-08df0288bb20
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 09:10:38.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YKcItW9SpH8UtvY7qtIgoQdOo2dHpSzcrx5+0Lkgh5ZSXTjDeryPwOPkMSWtaDES9K9k9Guoi1g6Orxn1ToMszV8sVErdFShd2cLLicENM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6740

On 8/25/26 12:40 AM, Qu Wenruo wrote:
>> Looks good, two small nits though in case you need to resend the series:
>> 1) Please don't do the [CAUSE], [BUG], [FIX] thingy, I know Qu does 
>> it but
>> noone else does that.
>
> Sorry, I thought that was a good way to explain a bug, but this 
> doesn't look like so for everyone else.
>
> I'll also change the future style. 

Nah it's kind of your signature, like me writing Byte instead of Bye.

