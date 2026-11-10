Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794296741;
	b=AdoOxnE2/n3zWdPc6GVUWP7Hqm798fi9fIFLNHY31SC4uev1USXifwmKjBsDYOWQFqFB
	 CIp8k9qigsJSXzDsU14B93YAvJqg5TeIWcEiY9s1ljgHiGpqZR0a5rxyHpV3Leiy9P7zp
	 Ci93tB/b4L8cwHy2aRJ+WqEI3AS/7K/D3XSsjgQHt4mIIoy626LtPX8zkRAamFGPeIpmb
	 9zgFg3f6zUKJGeJf217N+mWEhR+HfllEsxGhWE/pVZDojAClk99+nd/RK5etFKUasNVis
	 UVyoKb0bSmMJvsav+8kYBhEm3JczPIv7yIrReNgK8Lf/VdCKhPf7fARE+7xnQsRDFVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794296741;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=1A+3iM6l+8LZ5PUOBI+irSFkvyt75rXGFx3tBFYFjXM=;
	b=d7OcbCT21OKlslyF7lj/mGxOXW/c1KbhxYCMlQ28hbnQpE6rC8UuzmcakBVC51VUtCTD
	 HItWKJj6uTFhtUHsnp9HBmDO4cfSxEGyV1pfFnfGnQqt3SyUgIMb5nFC6GYa4PFhdsT8p
	 g8PmC/bCDWgDikDW9VfJIORnrMhvTd8T+RRXp7u53WvQUWfaWX2kuheEiWffVBnUYSCZQ
	 bOIgP4tF4JVAyFmEEOv1qxrZzBocJ7GD4TJBnI3DR+5TnkDDY3bWJp2jcDewYPz4Z4Nd7
	 fw2pTs+su7zHecJDaEWBySBGaY8KBKep+a15ijVc0M5ilETPK+E1rdUXMKTLNhAKX4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XXYAvD24;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Rw0XsVss;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24261606A563
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 07:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24261606A563
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XXYAvD24;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Rw0XsVss
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794296741; x=1825832741;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=9XoI4ou5nBbM/Y3AQRHIU/EAT7NyhDe8r0X5RZzpBPs=;
  b=XXYAvD24yOOT7HoYFAOo+XcdI4dyQ/cav4qoNOIEx+UIU3vWpETZkUsW
   i0DllwWzLfr8EZLtTt2C8dXvQnVMcQn/G/flXqha84ev6JGjBHkGzUqXu
   8s/bPwUMq24VIt7YetoV7J09OSXFpGYoZyBoQnuDspv0KIRMlD5Kf26s5
   POxdLxNmma+FkjsII2JyM2rIM1h574B8kOcsBbOsn3G7C4PUbKKOeFXLm
   mAcyIMNSSF0zSrwO2nnxu1cjL2snZr1du1cTpXttlLudVZWP7OqTWrYAb
   NPkAvRP2Ap5Ydoa3Uc1vCgn0f5Q6u0yYNc9fbLwEJ8mQqQYS2H2fqWitT
   g==;
X-CSE-ConnectionGUID: UTX72YjGR7KxHdaFQC2Fsw==
X-CSE-MsgGUID: ZhEi4B7sTGCmfr8NB7/03Q==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="160491929"
Received: from mail-westusazon11010024.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 15:45:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thR/MjkAvzoFowEl9VAYHZiu/N/zX56MPEUTSqVTGE/z3bT47H0C7y2YlKHF7oW5wVhmJf4gAjcsDOh3Sd9QyGO0fpZSeJFuI12UfMouLBmSqC80iBdPRQH/WHUZRBqIQC2N+dIkMd0LSRorlCsIQlVjk1rYo20H67kEM4dhOwA4UiXL4vr+X+nl0kanzVEI5Q9uqnm2v8ZQzkQSzP/r8O7iuRe0nkBVrJb/evJw+Vgw+NpebMAEichfSXOvq+PhynGQGB6OPZDnbYx9JlHttdl4Rv78+1iSO/vvkRndariap67IxgirEY7JfKN45x12OGrhSeDFAfbp0CS0XpbwqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1A+3iM6l+8LZ5PUOBI+irSFkvyt75rXGFx3tBFYFjXM=;
 b=TCyVPqRNYOyqGygocHqErVffq1M1wEoVARPehfPEUcj0bQlNetqqVQAU6+6UEt7fq+jpxrvHJFPqz1/ES+dSmJiUE4z8DIgjhy/98KIuC7cWWcwYSJ5enYmoIsMZYo963EXIaUTjRHXvlu1s8ET+bncQS5dP8oaZy4GWaJ5LEbTKBb26fEUACjuhDF42O4Gx5awmlxbhyDQA2jBIj5nKqBtNyOXl8io8iusjs6QKd2bwdAtXydauNq2FnDRTL0x9l1wsTT0xA/YJu+/K0t/pzwfFTEMW/HSAnXbC/UybXtP6H7cTOZ1V5LzhC4uSZQTFilwVnswEu7naFzG2CWo82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1A+3iM6l+8LZ5PUOBI+irSFkvyt75rXGFx3tBFYFjXM=;
 b=Rw0XsVss0/9Np1l6vn8aXcBIU2s/nLz29Ghh8+DtN1vMEv5ewIV9h2L5KZCLP2zUvecOkePZqE1XYpekuTQo9TXea13zBO0ipYcOwfuTABriKyLwhTWQzNTRrJXqfeAjnpUo6fyaeb+UnlAhki55w99CFMHtkwgT5Iet3adO6Iw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV4PPF1D7C24056.namprd04.prod.outlook.com (2603:10b6:40f:fc02::907) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 10 Nov
 2026 07:45:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 07:45:39 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: don't fail start_transaction() after a forced commit
Date: Tue, 10 Nov 2026 08:45:23 +0100
Message-ID: <20261110074523.1199319-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV4PPF1D7C24056:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2eb126-6852-4763-1e0d-08df3efe9d19
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|10070799003|1800799024|366016|23010399003|10067099003|18002099003|6133799003|261102123227099003|56012099006|261028144727099003|11063799006|261009223027099003|261026140227099003|261022105027099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	i2qc/TTTip1IXV4xDH4tBbyNAUBqLl26KOHIXxZUxkgd1FXzjyZv4Z7o5HFgZNgyNO/pDE/QYmJt5gn4kvWtVu1tHv0vErBvvqrGCGnnAv+84UXhweHhFPwlM7fl2mQvXQ5IJCc7BLslpAAYfEFPFEQHKfi5eBhpMatxzY/7/yZ2bdbLuYBxbfgLkfrN54K702yOqzSpSE38OFFnJzQDAjuO3/q89esp1620hOjhONH7IcgXuwQl2eLikK/4QwFw05sa95fHRFIjWgeIzGDoZqJPaVqfO8U1cKT64rBM4rDvCkfqbagR2nJ77/WP/SxnkJ4vK6cwSMjr1X2LPsBc3bVGkd6xSL2j+YlO9p4crSYpcyyyih2X5QFuDbyUJWgGnBeU2dNqtMDoPsq7ZBIPN94K1tsF/ird/VxMwA12kvfivaAJBikXGeBLG4VOuF+/ErtMLvjvtCKkEhEAvAbUScGmIV1GTQ2bMpewcl+BJiipsNTRxAkLR1+cxpK1AHMJ55ZGSoUOJtAGMLL23GKju/qDKC0Q/Ty2j5JC1NJ/kpTHvldpwGOwc/dPYn6+EuKdBB9/a6QDDKv+YP2mS2sl3BbpVdF1brtyfHNu3PybVCzyOrnTY70MDQvFWPJwkcD5jmIhOfjH50xID7oHnFuT7mQpcbpcbVHKsP5psD7REfg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(10070799003)(1800799024)(366016)(23010399003)(10067099003)(18002099003)(6133799003)(261102123227099003)(56012099006)(261028144727099003)(11063799006)(261009223027099003)(261026140227099003)(261022105027099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vh6zVufAdqOUi+1ErxFfmmSQ2gqHfSaOMhWjW1WBBEdd3PGjZ8o1TcHg9rFm?=
 =?us-ascii?Q?Glwx3qUiFQia/gXLrH2nIVdF4lBh/TZAn2gSVz8dUccxATtzg/NceJ0Ic3do?=
 =?us-ascii?Q?LKmG7BBAIFDmiLOnyGZoTDIriwR9TEXIjFF4U83alYwhJA84X31viSGV+cV0?=
 =?us-ascii?Q?ipNdqQQOUmZXw5DfYlmyVNgucbqP6qDhhb0dvmzwhQxbFljjhOCqQlQqKOnk?=
 =?us-ascii?Q?XKilqufFZfOlZtBzUuCnoiuiIiGXCdwJ8OcqRQUL9nDuJlz74Bcl0M+52ONg?=
 =?us-ascii?Q?XSG/M8kCcKonhQq1ay2SuQCVXTkQGypX5gcsOJAAD1wVavczkfG2y4uLIodb?=
 =?us-ascii?Q?Ke351gAqfAtN0Cs+t7TAvB7Q236fepzydAELaVs60/PzuWfd1eRGmBhqcC+X?=
 =?us-ascii?Q?uXEGtJGPVOp/UMghFJfA0FTZdgg0u20r5gFnARRmDeTWXAGUeHP4AQ4rat0s?=
 =?us-ascii?Q?Iavbef+BldoP2iRgfgMSwIFNcjIVYDcnRJc2xpU5MhdyF+f9r1xXtiHDSHCs?=
 =?us-ascii?Q?BGscfAYoN9TUDNd/ZLKqUe5cov0CRQ+JP94mV3ceCkaBjP6DvaaLzM3Srfet?=
 =?us-ascii?Q?gm32zOpJzbedU1pazaBayiZzdxi7RZ8SikrjqA6qJX4URtdK2w/krKtwmVu+?=
 =?us-ascii?Q?tAs2TwIyFt5kuAz5D3msxr8xhAY9Xp0MQ0eKZrQ8cGaD/8p3LXklHz4O7jBg?=
 =?us-ascii?Q?5agmxrXlzObUOGOCrl2M2Am0WfJs/xItZTrhbmkPNS2SEMlvh7fDvhY+rwXi?=
 =?us-ascii?Q?EJr+/TDfpTxsbkI9H9njTq9bxevH+7UCHjEbG7cMrjV5mh+/zLtOGnJtKbsU?=
 =?us-ascii?Q?6tNZPVkPbX7PIuSvajJ32R+kukLWdIOd0JpdZRoaU4ZRuh9SfUnuANOz3Ano?=
 =?us-ascii?Q?WRILvX52/kxVv2g9l2MftVl3BQN7SvJCgYZVMxCWrUXX86hZGAQk/TvI85zB?=
 =?us-ascii?Q?Dfc8P61Bb+os79/XKxqUwFM9zLv0QAPhnaIph4ZyJ6d6ovzb8Ck9mOt5Yrbh?=
 =?us-ascii?Q?i7BQuUE/14ZMizHf4am6J4KFTyy2frvG5Wgq6hnCYJr9V/wvzo1ZsTME4SGv?=
 =?us-ascii?Q?iOCgpPbildMDdCOeGAvbsnAqZgWtcgStR9FqsNdG6MiV//hgU7FlnusOsXfS?=
 =?us-ascii?Q?6ODS/N485s0lo9bm47220gW0g7gDyI8ca8IkNN49eNV+NWg+tJPIWBb45DCd?=
 =?us-ascii?Q?4JvkoAHMpPFqdk+LM2ry1u5buNt9fuJA1laXmLGGSAT4f826IezfNN11K4u6?=
 =?us-ascii?Q?ZT880k6o05nlt+cAbkziiFd8IILCKzp8Me2/rmx7dX7UBaMpIbgPC8WmUSbM?=
 =?us-ascii?Q?OqCFDZjjNZifXF4Hh5L2MLFXYhSVpHYvGWPY+VllQl6r+nOOMRbqi48qqlkL?=
 =?us-ascii?Q?Yrry4Dm1/n20wZkYd+96n7dwaFWkgTvZ3ljx8oVq/tDmkePqvK/25ZH/YMmb?=
 =?us-ascii?Q?rN+uRrojhUI4Ef49sm6hSnE9xWzeh+MDuvfBOsCpV0NqvUC2bNFPPBiyyp4K?=
 =?us-ascii?Q?+FBguy6DiPnB2XD23TS9b5cs5zcPIvSAjZqX86zxyjMxTzoVgDtGo+LnaONo?=
 =?us-ascii?Q?x1jQR8BBZtuxblYE/jn1ezYYtL+FwUmcl77DcxF2MA3iedpls+pCgfojG1TS?=
 =?us-ascii?Q?F2SPAsx2Cg/udxEYwRvW4a+aSV4CrR5XwGtpsPByve9dr1fvdFmZ20TgHr0s?=
 =?us-ascii?Q?O6PAY1lOYSbOTYeY6LBh35gvmLidYKmona+M7JIdgwoEEa9CwnpaBEPiWCPF?=
 =?us-ascii?Q?PwDrty2X3QJ01FUd0hJiY65+L418xCquMgDY2QTcH5skF2xhscT4Zvs9LziJ?=
X-MS-Exchange-AntiSpam-MessageData-1: UATGiVvft+d/G893ZqTGWQAGKrVwqks5MYw=
X-Exchange-RoutingPolicyChecked:
	4mLB9jZQ1jbFx7Rey12HcYsv5Jn+JxF7aDLGMSWNC0geZTaAwiFtoUEh/T54Y9YGzxZZXTQL8kK/yJBuynYg2Gdvy8HABfcedaGT2itR4U3jhUo9xwlJg/1l4Vs9Jof/HXgYEq8uuymmumZVbRDeqrmreA6KINDI7smkUNHBEPVFRvDrOFd0y3XdjpoggPm6UCuK5+mdYcwpK08PZi856pzThlmZrBzZ5W/YZFJLbKkf6bcyyDaRILAIRHZL4RRhNaQfTSnGbeFigCRVES6ZCesi/SJQIH9PVJ8Oekb09fm9YC+2sLpCsW+pIDM0GUOGChwR+Bhfi1xWGDzR6vFrvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YS5iAEqG3js2OePii7sqR40vYBmbxKY82FBPlJ820Cvy8zzI5kxmx8PYuXyMMR64o8VkZ64WoYacC0r9zWYRJoSYazGwX4wKysGHZb1ZMgicbaSedjoRKWG4irWpHe7VkwipuVVomaxsu1wO5rZ8PdNr0sKfL7LlR4dgFuKuG5/8rxQPdRducL6BzDUOpsP4adQ5Z5lENU9E0TSHY9JXvpQRBhvuWikdA66+BTep0GZpUggmlbzXVmrgkLpQsTTzMxEBkRRsuU3QPsQj7YqJs01wNP+/tDWbkaeyLlwf0UtFMtviyUwcuWtuEvolXPdK2sqdl0VegV5wwuVi5nf0qXDeH3p8JXWoVVv9Rws59PBz2wKHTyf4FF7/fhYwP6g2yx5QLR0LcMnZ2Ucap+NAf4phm3uq+ckQblgrnlCvSUUhtxGwhRnlsZwwAsdE+Z8AHzoG7jUPnRcvGUfp3A95Mhj62FRyEcCsYITHZmhyBuo8BoqdhmXauhGvGVtUHUpxmi5k0I805r3SMEQYEWoWs35uIlUCVEe4417+Jptpw1rv7rUgZaRyl8pthY77jksJfLINdXJGTc5sqGySBkHIGH1h52/28ZTK2PgITXxk44MXNodl0BMsx9juqrRtQP/J
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2eb126-6852-4763-1e0d-08df3efe9d19
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 07:45:39.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: of0uTgwWFt4PvkhEd/IArtZ7JbscaXcqiKmpd/mtobJz+f/7TprU9SyD6u0XwpzfiZyh7amclQWtRkLb3vwxrqZjaaAdod3CW7Fo1LAG1Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PPF1D7C24056

On zoned filesystems btrfs_delayed_refs_rsv_refill() returns -EAGAIN if
the delayed refs reserve exceeds half of the usable metadata space.
start_transaction() then commits the current transaction and refills
again. With concurrent writers, or once most of the metadata space-info
is zone_unusable, the second refill can still exceed the cap and the
-EAGAIN is returned from btrfs_start_transaction(). fsync(2) passes it on
to user space.

The cap is only meant to trigger a commit instead of overcommitting
metadata. After the commit has run, continue without refilling the
delayed refs reserve instead of failing the transaction start.

Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cd7dff5ba59b..d2da7de4b905 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -725,6 +725,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 			if (ret)
 				goto reserve_fail;
 			ret = btrfs_delayed_refs_rsv_refill(fs_info, flush);
+			if (ret == -EAGAIN)
+				ret = 0;
 		}
 
 		if (ret)
-- 
2.56.0

