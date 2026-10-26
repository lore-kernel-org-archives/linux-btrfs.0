Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031004;
	b=YV0jZSC4EF4mKHG4pFJj0mlDDubRaow00uOY6VNRsEafrWCYcGzxlMwEtWfICfjpnyfv
	 T6eFCMBRWGGhq0BJMPepS6REvnCfAsXh6xH7DVL/NHAP8mBansxyg5DnFi2FRpjky7YeN
	 FNrh2RHz9mdkGm7fMSgQ79EAnChhcSagZ3KLgCOpMs/evn35VvRzMC3+Dzf+QO9xJbCNM
	 CryttYcn9/qD8x3cwv+mXIolI2rS0NcAavPCOdd0V2m65BkNchoiY/M89SGPgl3+ksikP
	 EyxMxehU0cFykrVAyiZR3YygS/iiXrU1do1m9bARu4vX77B+/595P9e5sivzz4ukOWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031004;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=wKjkCe2bQd3FkNimEY+fbMdxuaftGVuu6QxzZ2OHJWM=;
	b=G4VuczjkJeqhlFcveHcXSZnoh4EI2PdrxnyDWhc7BNX8axiaqPlPCodx63NUQQ2HBuJZ
	 HbysskO1dPnE+P6LMEK2qn19RYBSr4b6UVGITyGxk/WQh6EBtoSINyifRGjvHzzLNTop3
	 h4kAFqsVRHFMOWuRuGVoCtJ6+nntGLd6yJuQgnsXg0fcjBsCd/hkEIlqpkg8jtGxizmes
	 d305e3NC6Cjk1RfYlMShm6BoRLH547J2MQRyV1tyzkqK6uujcvfuNR544xbsq9/z43Nnq
	 VRhUFp1f0J4zzbXvuGsYb3k4ctQWiJCP/vnME/oifrG1St7bsZnsv0EIQ1pgatVRVwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rhCjIBYX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GKgXEuLM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90183606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90183606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rhCjIBYX;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GKgXEuLM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031003; x=1824567003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HD2feFq/CT6OeFxzbDIQMswS+yu9j+LXJqyiGYVDaU0=;
  b=rhCjIBYXyaeYfZJHVg+xE/XeqTrpJR/1MyhDJKCDjQSCCjChvrqmMbOJ
   9nDUugQGkd1zW2pAMm5dHpfcr9TZhyHeP/nSDiT8LvfYKew8LjMZwPZWp
   DOcekEZACP4D5uATY0n8Qyzxg1MmV8R4EPCAlbyUUHKFCoalyoH05awAu
   xrrW0G5SbeCcb/juAUfWhr3ALLBh4ysg80QqC8CZ0KVGIQ1HOUIPiTPSI
   bBP/Vh1yP/JMadIJdzaqjZ8DUXp87C65+bNLzW921Ff5naqd1/LRvkIMi
   RPS7WAuSqggaKB2sTlkLdHvn/j3t1gGeRQdKTuob9X4VK0xjMKoSX4rFp
   w==;
X-CSE-ConnectionGUID: cNTnMBHsRVKAQCEkwIGM9g==
X-CSE-MsgGUID: WX/10GxtTdiAZVONCvFxyg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068806"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j79jfnZFLTm35mcADNrhZIvl7Ec47h5QT6rj24Ul1iQfuz88DaO80kAFphhzTO3XKgwl54W2I9Ft3dbdqJyNIBMBcsZ/Vlbs9prEb/F63iwZs/0z4tI5T6TCYHsKClBU0/8Nhz12uh+gGQtCrPsyUUaKNas6AfFeq6yehpNdgSPpxOoLIG+FbtwHltjMpEFW5A99P+8jTFQV8Z9IQb7Un/C6ANl5RNxwkyz3ugHk36cppSOrVMJEgXc4RMXE3Goa8FFRarbpG2xeNMZ2qtf78Rk3s5lKYIECs28otPb4iFJBcepoxaDcfy4YTUxdciYDyQFhl/LNfQrCqPCM7zxIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKjkCe2bQd3FkNimEY+fbMdxuaftGVuu6QxzZ2OHJWM=;
 b=fU320aiATwj9+nT7ksx1v00XnaFl2KgXnyptLhH6qN+xPhGcz5Jv2hXOmD88vqSaVTdxZjOXJpZnIyaURkHydpkvDrOKDfXohSejUGLIQsVK1vHAkVhHPcXbChxxSgBQvtNBldgQGFbjW/HFiSe44QgYFRJHKMEkoQADsLDjsdIt/bQp1E8mmKq7YzAf7kLhVZPELpZP7vVmGw+CPrYCBHPWms2/dNj2DncPWfnj9qE9za9o5JjxLi9OMP/i8OX43uGCN4z02EmTByRrFziJImaxLwuZfHIh6un8bGGVX0Sl7O3zDsJixSxSsaO5BZQOrp5cRSZ4hPHHt5WUf4SEWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKjkCe2bQd3FkNimEY+fbMdxuaftGVuu6QxzZ2OHJWM=;
 b=GKgXEuLM/A9tk6M8jFG1zBw4oFvtQvfbuObEmxABhqsRAfbfXcU9sezOjR7be8mr7Bt92bfIDpP+odozIgex4aaqzzRUk3IJ11Vp0ZRCbfodz14Kqiym+HjdeYNuk2gTg0MoB4gpruF4pkVAxfswkPHtTqsdOaxuq+5yfM94UOM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:30 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 01/25] btrfs: zoned: fix possible race for reserved_active_zones
Date: Mon, 26 Oct 2026 17:08:49 +0100
Message-ID: <20261026160913.207909-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ad45e09-8e0b-4939-3b42-08df337b83e0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|261026140227099003|11063799006|56012099006|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zAxiWx1eiUeUjiEtsVo9WnG5DnLkLpTMv8rP9zUtISHNdjV24vTezoEAKcA07Fz0SsADzm+KC7iEA2eicHJ8o+l8kfDc1rbLGzYZ2ZNaVSMg6ViUj0TxPCknyAayYTmeJCCIYu/s4Xl/iv2BExa7+4UUoXFbxBEv1bRQ1fwgZfTXuFV6luzZzeCpcndw5XhdS/eN3WeNEG7ZOxpCRjqSimiMAKU1ctMJbEtr3ciAmUWnhM69sWtKgE2eHnniJXopNV0b6oXVQNt1jtD1i9N+L7GzTA2O4t0WG/4ksFSERj8ty06WAP7T5u8oTBxhc2fk3awcT3mZ/Hf9cRClNRC4JQ950ONcJaKYpL4i1+TfmLEgWTfZTPerKcbkZo+YpixI7NRjBw9Q7l121CeojpesBsq8ARYAiD8CSASDThOkVSjrSUXU+kn5y+g2TmwoCUbbObp6HIIKiP7xvwPQEStyXkFUcm2v0oyRBcz/9nQji0IVhiIW5kuqUGi2wiJckD0JsNv7fCYZdscP8hkDiYgeRSny8EkCAeQLpKd94wCxhlY+mslr7+bTNh/v0kIiGLl6R3lQnEXdZuhzTro7BgIMzHbNtzRhQ6E4lXGhP95qD1k7NSY4yE8vtVwMgbjgSmZlaS+6eys4pUZuwqXlcm53k1lT2gPonUMtJVIBmLJKOG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K/Au7tRkIKZiIOh1wk8DtTm0OuveUNOY+Nqfk+xB1Evzx5G0Cng1yKli9PLf?=
 =?us-ascii?Q?bQLJdMfVmXSt7rbe9ZSO0uA1n4Q8Z7XvEWbJKBicJ0IhSIxms6lyxMzOEhYK?=
 =?us-ascii?Q?nv3EQCiECkaQSH7l4D2cg0MbsRjOwij2aao8JUE3nr8FwtolqceoRtSO9Zqx?=
 =?us-ascii?Q?kLvBYXR5tqSUAdhcr+cKv2kTWC3X8WEXC74yVuYn14WrL/A2902hMcQBEH8e?=
 =?us-ascii?Q?6/x986MPOJEu/6JoJLgF736Xb32EovxRiOhtdcdAC/+buDEIfJgvUQLi+8o4?=
 =?us-ascii?Q?zrXiTXynW7MuguDVQjZ6FAhlcrQLImbSRX3Tzc2ruOyWaSudlVLEFF0CCzJm?=
 =?us-ascii?Q?jP/4jQlkqOTVNUEGQFL5z+3QQE2mXZtLC1QGjG8BIR7pyOyMIf6Q9RHny0Qr?=
 =?us-ascii?Q?4fmNLiXlsXQ+uJeOpITejd+eXCzmxRzHZxV/DsqAPcH5rq8+bwYkl+pwFuaZ?=
 =?us-ascii?Q?5JZGMn/HEaay6O4RBYbzFZxiTlwVT4GV6V/KQ9oKwerdAoBaMPrib00qsNhb?=
 =?us-ascii?Q?yjmmoivghfu4pG1h7xXZzXxYjAwR80RfIS+Lo9/FU+x8qRSYK1Jo+ScgEbXs?=
 =?us-ascii?Q?ehXwR5lN7unS059e8/7W9X4ymgTjpsIiV9e2jimnINdr7oJhWdsdPLCDLnUK?=
 =?us-ascii?Q?n5MHr7RMmMeLC4yw1TzS/kN4d1sA4spvX9OlIe7s1iRMwHsS7B+Jd4DxKMuN?=
 =?us-ascii?Q?BlYI65iOYLP18i8qNRG3gww8stia7kdkj0aVmBwfF39PdAwhWdPeAOeB6psW?=
 =?us-ascii?Q?idi+ww4iwkj/6vnKqfyDLiW5afAOSrWswl6cO6n1OB2VuEPFMDtpweo51x1B?=
 =?us-ascii?Q?R56Wc9tfDbbvhUYfbGwuCFqezG4iTvePU705Zgjmh5m+CN44UmAXkzz8fXfn?=
 =?us-ascii?Q?xyLCHJkJj/fHLZa3NlPSq3DV1FJDHbJmiroEvScH/i6SJtYXTeD2R9Im5bJV?=
 =?us-ascii?Q?fCslCeLTEO1TJH7HCbdnA2Z5Hko1ItJybKfKrsYUBIKHJeLxe65JP3w39Vk8?=
 =?us-ascii?Q?4efieCK4c4QVqEQcHC/1yC+JWx6Piaxfcn8V/KGyRneixvICqzu1PPSU8gi2?=
 =?us-ascii?Q?ClMkYe8UgSqv72/1cy0n9JaBAKcaQ3B/MYms0o3drU+gXu4Qe4VodJZ37PPm?=
 =?us-ascii?Q?xxVXWnnMKeuMVQLYSttLeEKM4hTeoBRInDHG9ZzsjdbeOfqzeMXCmSTZpwHo?=
 =?us-ascii?Q?sZMV354LNZucGRGX9k2irmR+0JwW3jLKAXEfyiInAWnZWJvcPugVplWrsxQp?=
 =?us-ascii?Q?B5/2psLRQUqI8dOrQveHvEPAalSZv3M96jl9dA3xb0zLytaD+l/bae8ee4Y6?=
 =?us-ascii?Q?Ltl0snK1V7kLt5sRueqNNH8NfnCMMZsXdMUFHGPixlMhfDgTO/hZF8Q9UUZy?=
 =?us-ascii?Q?e4mUjVxdncKgZ0XwlBr5iWNKeG39CEnuQc1kvWwhGmQ+j0plwVHWjRrv5M2W?=
 =?us-ascii?Q?9ttzu1bbJ4xxD24A9PjzxrOsbQ0BpPLIQ0b5d2VlB3E+Szot6qcy5vdayFK9?=
 =?us-ascii?Q?JPH6EU4JKrRpiPhCpfm3ZOau9uSAwIC9+njg2BT/MXSJdARaHlt+lAN/FLVp?=
 =?us-ascii?Q?gCAqPl//ZA9MIDLJVJ6eL7HYFMGr0Zqnt0+8cBMt756WTWzbICspUfOj1WVd?=
 =?us-ascii?Q?JkD08AyNiTVEX6p6Q/qZAnxx5olr0uOfBsBdr/a+mA/PVY7aS8D5CjhC5aqB?=
 =?us-ascii?Q?F59/qINuCJPiyxZddRxe63c8ulVjVPpuSbHYa4ddyUWcOIi3NVe+fAwS/aiY?=
 =?us-ascii?Q?KmCXtxswpXCDl65PHvb1wlk3jQ2mmGQ+wmkhnNl/DeJGpd386o5OhaJSDYO5?=
X-MS-Exchange-AntiSpam-MessageData-1: qNsmvVshkI2h8w==
X-Exchange-RoutingPolicyChecked:
	44pvHqNUE2GlqgkmdyBYsvoUmoi1PL7L7u0PADZ0xU11HKL45czMBuTXhF0qOw4HxVZbUQEM3QK8YfCqcdE2BLmUflfDlN2iWyi/nzeZdS7gvufwbnD63FKMQ5Qp475KEaD2gN3ux5gZgEzi8hMvAHF/Qa7zR7avNfT7uXTASachfwBtqfh1EVDUb2pcn1VWxplcVBQ6hP/R6BSZex4HbssR8mxz60fzt+1jiJaSy4NH12ksxVWxFH7QHB81y1f+Ca0OyZ+jLMDsCLh0sMzHkiyiy2OUc9+O5OakHCS3H8s/g7aRa/SLxZEN9jbV89/AFFzkivOcjGzIwD1bwZ6Jjw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FE5A/5otvHdIatNu4iWE15mtWg4gZ4dKy1MXpqsqdZmlomcTac3uOghNb34jY3vw0rSX13dZjgbHmyDq/m7yM0HG7CR63qHJrGhkuv2Cwpa7BCAcJKCyNrrIMOCzaAFWIFPTsdicoOI2iOKqW03gLr4n9lHbnKvuYh4sX0QUpRmd5RtJbNklnstQHqBjV6IFsQlQydqfWbKzi/1DPWrtxkC9T26Bs0qigzjxHaF0UIQ3SmAXQoRbVGtNIzCpjt38fOzHWcg34r926T+wI2J0qA24GILQnCkGJK8wgPZgWTxqK7E4BYkG+Y5EEfmV+BF6AXQT+Lua4be6kObzzydr3Yu1VMWajw84iarBGU4LLdqlYgAtcRLFzvgxnNEwh6ujXaFyLtnOl081C3R+XNGsuGhFgB4RGF3TkYjWyir2HCpZeZNN/xyL/AXn+Mgva3FRsou0ktV9F/xexeT156uUbIynRxkMSOoHjc0TCZs5sq1cg7+AFD6Ph73Or0lgPpmgF6A9+6KxpHpcS7+oIZFH5kBoQPMi5qYVS3r9Ju5wrlssWaaZkBUH3jXHWneakyuNQ8mZMrL/oceVvOlEFnZnm/VXCs6DVDWXFgDsTD5lFH5NezDoBKWKhLU8TG3fLSsh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad45e09-8e0b-4939-3b42-08df337b83e0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:29.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlkukIexX+TvPcpoFDbQ9B4Q1Cr6kTy/bXfiNTK6jIQjcL/EL4k2EfysRKwMmaFc4udpLuFS9SX2U+QK1lVDnRTECUg7Sk2K0+YexS01JxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f5b7b3334f06..ffa85cff8b71 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2529,6 +2529,7 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 static int call_zone_finish(struct btrfs_block_group *block_group,
 			    struct btrfs_io_stripe *stripe)
 {
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
@@ -2554,9 +2555,11 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
+	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
 		zinfo->reserved_active_zones++;
+	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
 }
-- 
2.56.0

