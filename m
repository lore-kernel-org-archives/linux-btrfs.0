Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941989;
	b=IjSnBjxEQGE3BgHBHoa3UNXw4Kv4XWocd6moGQW0+Y3QqaHmBWnvB3iZQUfOJA8PoBSL
	 0rPRGh8baHU4Wu//LBxwh3r4pn7nN9VHqG2/PST9JeWak/J6J3LoyVmQ1KmZX0uIaIJ4b
	 dRmlZezrtdecu7YD5+OnCMeuNZJznj6AL8I8MXnIBGXC2RCjmoDZQ0e+OXnjLa7s4oJS4
	 2WQ1kpRCDvPA4baC1cftzE6wlYl7NN9sVwERMrKwWTYJr5basQTJEFJt5oIoHlWzA62dB
	 RAm7m6Z4TpXWjRRnUmd9rjEKUNPv0ni5wmFobq0DaIVjGmCIFI+tOEmOt9MBXd4eMGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941989;
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
	bh=kf3i382IWQbBEXAOIyRUQl88Z+K/3wmRsv0vHupG6lg=;
	b=VHfmDpMeRh8AoQ+mN0Fh92Gkhr3HaGVvFY46SoewUoGBko36ngffi/OZ3/kEPxg8tGbx
	 8/75qH3OSwKT5SlcyR/XniM6XS2CpoNaEthHCv6MRhnjrnkNOqn9d/KukcIGbquahh0rP
	 kHr82AY4dC81SDqseT7EVZAsmis9YN4Y8tlf6Hx0Qdm3PF8uNoGvO3orC6A1BoJeANLiE
	 TM4Dt6a7EQABPSeRkBr5mio0483vC23WShtCXy20nBRBZ0nzIgvjtNpT92F1TWk7ksq72
	 4Rxp53z+3RsiQPv3yzmq5LFgm+DASae79URQHEkOJQpb5Ox2l/OcSuhovFu0/BTf6rQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gY4x+tCA;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ojdjfCZ0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF8606A332
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBAF8606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=gY4x+tCA;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ojdjfCZ0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941996; x=1826477996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ThGnyObFtXW8TaouFMjJ9nbwc2Kb9RclqIMUN7YLzc4=;
  b=gY4x+tCAUnEZEYyZTqdmUKofFvDKk2G6/GOajFquCpKfN1yqe85M2j3G
   X9T7+73OsZ8pdiIa4JMvtcFznbF8B/Z2ApeOwJQVxkGLeyKbqC1DLsOdC
   ghvib0ex2JDvkdgeIl4tQdlWxrk/oNGQZEbqrOukG3R5tM7Nx9XPr1A2L
   0JQKmHWLsp0sr+apkaqlfPNeyC0MwQBfz/8edM6atzCWKnpkecIVNKexk
   pN6NmStZcbOdM7v6qB8QRPSBm5ekiPTAO9qhf/RAdM/r6gSzwvBUQzRkQ
   GStTbS95gs+o3Dj/IkEO9bHQvaL/+SRg1nzaXYAOavZmpWL0yPmMKm+//
   w==;
X-CSE-ConnectionGUID: GZTadsmHR/yGARgAPPatlQ==
X-CSE-MsgGUID: 2mH4Yi1sQr62dJcl5hM/mQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162096908"
Received: from mail-northcentralusazon11012027.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4yMJ37Eifehq/AnONbyZCzUBB12uE9ccJiZgNkk/LnH3igZFeSKSdKkwdko+QMFfj2trbKIw7iX123HB1phc28iLA3vcOycDgFjAbMuSB3IMfth1YZodgL1ApUQbcY0FZ44taCCivDgBF66km4K+6Cbp2AJmTey7615g16jjT+vuh9f7OBEImKl163VahLuLlr1PcEGZPgnnYlDBvvWXphiXXldr1EMYUJ8gObZwbppv+f3lUi2JADdFcoHcBOdSYU2v6kLb5TT7VhWAAt03AUXG47OyReiDnExmaq9ULH+bLkwkY+4yjsUGKuA55hwplZ17KG/efB3N0+8ynaksQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf3i382IWQbBEXAOIyRUQl88Z+K/3wmRsv0vHupG6lg=;
 b=qW9RxhimMRQc20bxBSI8JzVE+pktbAtxvIm3Oc93P7TCstsTv/nXEcFSIxN4m/GFtLAnPFp2BjQNPTkqMFDHKAEOdvGSZhiqpsQB5+QtImxKupiLcLwgIUVxwwglIGHLovO14ZJ54KniiVtM+XaYQAmNc50fNzM3Gw4qoD8okSh2UFgAW6i8oKxvHI2wvJp594e8GIZ1zW1MhvM0Xz+o9MogmKvxGt1Nwdw5MPrmIcbKXxQY4ZH2r27Q/Sy4dZiZkp1GRIFs9YqwFr8avpq30BUkfrZzuRgB8tJ40cqHnlyZnlRCOAFzUBQ5qjxQEehFRGZ7G7QIKT7vC2XXWSvmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf3i382IWQbBEXAOIyRUQl88Z+K/3wmRsv0vHupG6lg=;
 b=ojdjfCZ07ZmODApo5LyuUNAxyKjycHnfduwNQX1l6G7d9dL3TXpuWtyTgmFkutFQo8IF87wPDnoW88usCkQNFGksepugTFLaBJpycn/JtX9rVajdFCM7f/SD/oiSYC0ih1Qo0f5zhpd6arwyGsATIrN/Lss6BU8Yw0UV4Qrh/Q8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH6PR04MB993818.namprd04.prod.outlook.com (2603:10b6:610:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v7 03/27] btrfs: zoned: fix possible race for reserved_active_zones
Date: Tue, 17 Nov 2026 19:58:26 +0100
Message-ID: <20261117185850.4128157-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH6PR04MB993818:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a4a50c-03bc-427f-8311-08df44dce062
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JU94EfFm96Oa3tjrn0nxdyjY773WuunY6OrzjEGuaX8mIhjfGAjBvaXwwJfrtxwo4maa+XtPV595y3mFrOFdIW/3uL3GcjSAMB+z7lceGr/qGdDF+QObhoDG5MxIl5xV5qnV0qaJRyhRhG5uI3JWPj03H+XSzuxtv+4YXGyQlSCh9uMv7ar21y1TPESv81Z2nUxeBo97t1lI4fHsA0DDUX2r7N42Wgl/xkc61EzsoSHOnQjHWAEMqDUpwrKStqtl1C+esEY7HmXYdBgnYnCijjF0yJ0W/gLqQs8zM4X9V0ual6Ip0WUD9lN20ZtxdO2H/vgT3QuX2hnBSPtg+es3phBHzt+ir0ZslxhEH0oCTjpWhtX0VNeKpndsYGq/NR4dsAaOKynKCFHsCYfyuw09o/OpQ7iTMfi2ea392egFm4IxAfmy/lJ7l7M09zHeOKTIdudbfZJLq2AiLcgTZob4RdYpjDOCYm4gukjoiCiGDDt0bfCJr6X9NO/iR/dy4OtbTjxA4OmAwekre/7jSQm7BH4YSde8Copy7OPa48nHgXPpZFPFYP8dJq1uP9zuxLuAsLm4+PvValJDtPPjmIdSbj5JEzbG18aRlG83LSfpFhX0SJyEo1jQBPFguH7kVJhVIN10BOML0G9mtH/boHi3cLBX6qWmZzH+egNXdzrVn3Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KZmnTOyqH9QcQ3PUTDqS0eJHkIb4CUvm0SFl/32NCxUFHRzY2CByzri8FIK8?=
 =?us-ascii?Q?X8O232CVP7qmUTLPoV/Z6RaicKr4CWrb6SeYm8CvPO5k70nn4dS90GbFe+bE?=
 =?us-ascii?Q?8KO/AC1HCzHDEYP3Q4e2s92umQdauu3mn4G0ZUKvLeFYZ5/SBAjciB/nKMR5?=
 =?us-ascii?Q?4URP/QVPe6ry3t0yhrS580zOKnP/CG0vYsbR4aprtgAU/8GjJSAdM8YFJlV/?=
 =?us-ascii?Q?PkzVfBoby1xvDEBBiDTE0QSnUuxPkPdpusFw6uNey4Nzci/Sivj5DM8TNn8k?=
 =?us-ascii?Q?YsaQHJreJjET6fvxcJHaURqp2Wz4s9VdO8UiZBaY60rkUqkk0ApWMcRriWd+?=
 =?us-ascii?Q?N1Hq9QSfYfMpyDtgeNHrISbcBCzIWuFWzzwaDaaGSNOS8+Nn0gwSBZnei5gp?=
 =?us-ascii?Q?teEmwG6Cv4EeU82cidtK9GQ+tCtxdtAH2dcBJKaRAxRaoocMYrBE2wMYoRYv?=
 =?us-ascii?Q?OI+cqdxzm2jSF4vqBQEY0TluYMuHql9ykNzCUN5MK168pJbHKFxNRlC1hpzG?=
 =?us-ascii?Q?mxTqwj29aj29O2sP43gdR06asFagFA2rdMsRsG3MfGstODosu1FcBlZrNucy?=
 =?us-ascii?Q?jBG9lB0F7Isncw5SprVdb17e6xTAhrE9QE2P4tbLJqPE1TsF7mjg3gD++kz8?=
 =?us-ascii?Q?oT3AiFrjkissqd5N7/eDXtrPl9VqpzGfrnOggRhgR/iiTzbcuRyCQ0fL8DEl?=
 =?us-ascii?Q?KF0qjwrGc4l+ltz1nCgCsRCIJpP5ImVFO/Ua+ffNhxv4I6eSlLllW9L4K/Bu?=
 =?us-ascii?Q?O6khzs9HUs5eBAiOGQfCRURzdmV0qapp35Xy1jy9MjMVF3HSPxnpfym3WME1?=
 =?us-ascii?Q?dHk8mNSBC6u77/lld/EKXu7KfX7/zxayWpk7oinGK7XMONIBS4e1iDFJwhcn?=
 =?us-ascii?Q?MoW0il35eN+5GZvt4A/6cKQmD0ceiceKK5uzw/n8K9zGz9Q7yD22u36VdlID?=
 =?us-ascii?Q?F5rn524ZsQHfwKKcE+EuAWigSE+fr6Cq7G3jSUk2aM+K2mmE4TQS+yHWttPZ?=
 =?us-ascii?Q?GkQYQMYO+wKvjMRjQf409IYUT0WqPiRUjMCmznIqOBaCTRMW0eHD5u6tPu1P?=
 =?us-ascii?Q?IiI3q58TZn2YO76Ne+YS7MX9QN+kWDGWb73/dRzdYKPl7XY1Odbij7mggtRR?=
 =?us-ascii?Q?zQ3MnEiTUb2EBOgYoCgBM1DbIbHUY8u20x8mCYsetOCjWOf50YzDMqoPqxan?=
 =?us-ascii?Q?xQJ4j5AW8s4qX6kOBT6Rfh+5dILI78M6kl7onQ/T8fMuog47QWnXl6LHkEQJ?=
 =?us-ascii?Q?R4tFVlKrXmVzyGf+5tzD81lA4mXa4VvKmbO4QGSVmACWbuEecsLMSPayGmIv?=
 =?us-ascii?Q?T6fT2Bgpyeq7HF+RhEBwg2nPJOwWCbKpyyY/mXV4TClWiuFA3oJ0+xYVpBLG?=
 =?us-ascii?Q?4pLM9AHLQLTFcuBdeOpxzC0uXyz7COrUN22MTAs1QAXegw5Ytqr46fot8Nrz?=
 =?us-ascii?Q?68NT/APG+WOGr1Yc5NsDYoWQ1bFac9zrnS1iOnHciV8acUPKF5Ucznd5J44F?=
 =?us-ascii?Q?qeggoqkgBlwyRIKOT5QgdXI5N9CQb1CyE02aVP702giBi4nvu62XGPmK2kaA?=
 =?us-ascii?Q?FdW8eifF2eeIr4DRPrJDKfsKLaMKGjuMAb1V+/JmV/cks5WbvYVtf8Qha5lG?=
 =?us-ascii?Q?DkGW3T9vLEqUMlUbZOZNyTGzYWDv4mYipqrPC4m3CGZvucgJ9e38tg9AcB9X?=
 =?us-ascii?Q?zNOAHbL5vdL1MjgJxb1DlRJgf99WOA6/2gx48aHFjtmvx9BwvEisZsUsroNo?=
 =?us-ascii?Q?adoM72PPdNnGwumGeLrp59Yh/h7x7SyDEgkKsa8MZH9mcW+nMlMBoBT6ythi?=
X-MS-Exchange-AntiSpam-MessageData-1: glLywqRegUZFPpOr44VHcwyyxkus3gceVOE=
X-Exchange-RoutingPolicyChecked:
	haPaQEcpi9duAVTiAJhc8W/ifevZ9UIPCj4UDf5XhfELlG3MLYMr+5RY9Oop/wJ0X3gOXBpYa0Ri731zek0TSZ5LSw1kL+oWhoKW4logjg9eyHa/nU5X/6EfI5XmpOKJAECJnf6benikc4+mepjJc0IgpCbSmcGD5gu385F5ATEm2FlCanTSnJYCmrfV3hVpP2Xl+NA3+YM8WMlObQAX3ONSC7XU1eHeCSHVVwVs7lSkX7SeZvtq6rzvVaBJkIeay+cHanXAQGlYgvR4LG9kwH9zQbYhJCYDA+kVy7mjr+ffXDWnPYt46NHC1qy2DiWqpDjEEMGbv20orX5yeFUjwQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jXUdIEAZK4gRP3w6RcQHk1x/+15fqbpebmDOaD87P/QUtq7q/otrwvaJO13MikP4UGZaAADSVwmuNzLqbvjoZhB4zRGEu1Oe0NVyVdgIISs7a6bhBV1J6mnnTdNVzbwgUofU4s0MCNBlSpopT0Hra702DSuZ8RxmAPgizaLuRa5eKQ/kUTLkx+JM8A7Nb+sQCHtHVfxoZI2GIRb+P8/dnqiHBanmddGZnkc/GTZMN9qAQdBN30OgUUygDM3wYrdEQuCpwcdLAsKe4rsyOUfzgoV9UVRghVYWKLLWgTMweXXAOrdOYeMPr3nc1wbgfMzuvsfvqqMaiR8Yvu9HhWtRbGh/wW88yyc11sgSiMyBRXsVRFk/XGsZliBnhbTSXhqUd7ZhMQStQtsLRvY3DVyAYfX3yBBD39M+q0307HlUbgUc5yU9Q5KKyI02Afq2Zhe20LsYyasRpIgQp43qhKVlbtw5ryey6LbkGadWJ3tBLZfdv1JcLpgBpdu6dW1Jrs4U+/YXlRyB9vw/XN9WHe4LlGWBk+vbQiZm/YJIeEhQiVxjM2T+g4Eij75B/PbOnt3NREZqHgi54keLzgqoRsXXz1uK8qtv3CoydwdvkGpJ07+g2I66D7Otsozf6KzDB9UA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a4a50c-03bc-427f-8311-08df44dce062
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:15.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WGfteGub/Ivs1j4KWC5VRZm8l3SYv3iLCZBHrlwrhoYj3Cn43XA/SS2SmbIRZXnnhKXjQMHuHyGEhByxcWkWcT8iYHEuZMmGisnSvW3TxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH6PR04MB993818

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
index ca0aedb916bf..4b0a596c0c0b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2534,6 +2534,7 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 static int call_zone_finish(struct btrfs_block_group *block_group,
 			    struct btrfs_io_stripe *stripe)
 {
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
@@ -2559,9 +2560,11 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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
2.56.1

