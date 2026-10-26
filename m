Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031008;
	b=cjEJ7ARl3Q4HZ49408yAc4297Bs5EIo8lzaKkTCD9qOnz67zVnRlk/fjGe6kl/3zTcBi
	 D4n5IAmxt5A3JtrisdZBGR4nsmOFi8rzjPng28QBBrqvu4O5/CDXBrHDNby26Bi3oZkLG
	 cQyhpgmCuyphv9krw2OQFq2TlYGM5PWuymEroAeN2rGxfCP7BSb40aOJDgMvvTfg+wxhp
	 JDNY+qcmU9VwOYc+K31HEprWmG8NbTcH3zhrafbzVAnR5CiQYjn3mKrfmu7WUueVbaoZ5
	 +B4C/Ayhc3/4HrWXQFEoLby/PcogaznZ3gZQyD/mVGlxlMwUlzptthdgn6lCFr1FtOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031008;
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
	bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
	b=Wru1fTWNoLRkQbVShCF6XjDRZoeB5Bzfv72blJ5PnsrbxsqpuV0BVuzutc7BfMXGr/KH
	 VbrvWE/uCLnFa9kRCQj+JeYcir8MgEA3GdZB4qTTA2PlGkWLzHPv+17FHx+nQdj51z6lH
	 Cu07/JdALj3KNSSKHXsZoO1CD0Yde0JS6Nyn9Ct7gqrAc+mbjhMIGe1aqwyfoe32tqS23
	 /hHq4ZrzH3VKBYxMJwnaRQJd+PtaXO/dBGAZe3MQ1GCamUOKbgRolhJISk8JbIXLQWczJ
	 s530r4rwMTwTtCQDRLMuHawHUnqY7sQglCjQY78pC9LSj3hY28v4tLp1Hu5LYyqETdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TzkxBVFk;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XvX41+Ds;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A986D606A32E
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A986D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TzkxBVFk;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XvX41+Ds
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031007; x=1824567007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LkOlxFVHdjuFt0PO30HbLL7YaxB2wpwsnjRSclCD4Ug=;
  b=TzkxBVFkIBqS0QEgeeoLi7IlfsFLPdUeaAMYIAYgsDRfvukoBNe4Mq6X
   A6FGerKtEp3oXKEKXBNE7pGRDnNtBpbvJ21y6PMru8mtcsz1Cg9fE8hbO
   Y4Nz3gHwAih6wayhTycjflF5vCv305I0WgTUNx1/VoqHckchOjtfjbt3A
   ubnU/6ci8kGhDmM/kguJHIgX9XmasMQ7XueE1auRO2krbGx+sVnGr0Lii
   CYj6Jc73/2MN5JyBvCoTDZIfLaOTVPUu03uDegOW/H7j4KsW751Og6LRZ
   wTwq5lLPhYywQ0O94JqVYHRDiYAzslgpe0zvoRl2bi32rOWaeEP6hhhyB
   Q==;
X-CSE-ConnectionGUID: qpRrmJvURRyt0VCbSmTJ4A==
X-CSE-MsgGUID: MV90SolfTPqvHElJmjppTg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033902"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poMJhcoyvSCKtuLcVonWjB4Hs2o4A/xHnsT2sc9Ef3rlfCKu3aFXkOEJFEsqhF4zub+t3pOXN5g5CfOqi2V6nA+hP3X3gfRM5Ii9MERTY6NGSQItv+K9VyUQ+Ey3xNqzg6WCAezhKDM/S0yN+heKcBtvj5THRy0L6zaUEY1T4U6CtKvcSMPrThOmtUqgwisrnIZeoIxZxIIRjH9jHHU4FPg9RYnV1A9xgGNlD+48q5GkHgwth9kTOrR/bUxTc5qZMNMrrHwmDpo/T79/0LGhR8oioPBFKaM8oq8fUrAqXkB4nQj9Y7yyqgexaf08BcomGUqnSI1f6cr7rZnARj+4Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=bSURh6q/nXU+1wVAO+WcvRLyWdLe3LdDuRVr3JG9REjwgEcaArnaW1BAA4dJC5qw3YkoWCNLJ2obCgQ1dDAVseQ1c6CIwjrpYeePH1nkvJiO1hRqSPSoUzPB1j6LNVbwL8ghrDQW+R9Fyz3MRSY0dT2K53JcTdGuIbAIIJrQqVD6QHjc6rT7+ox+MMFEzPf+0Vr54EHR5I3JOpIkfyaZHJFO1yCOJoGYNwFJX55PZ8llmqveQPAFNjWHKs77TaE7YNs15HBzt++JQhFiPe01GnfZC64AJQMXO4Ivnoe6bmXK6mjbKgx1o+n2dd6+ynw57mWW4TO3vM9iS6Ugb4vGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=XvX41+Ds33z4I3ReXQ8wa50FKk/O8+Ym7RO2Vb9JhNDQa4A4zw8VrCS8K+j22w5Ed6je4jaa389uDJfluQR+ctrps3jZ5F59Yk1l7s2+pWT6uUmUWM5KdGcsjsBVDoqUD+zrsLg2puwW+C514qWbX+C1VHmIABymXRL9U+fV5io=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:44 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 11/25] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Mon, 26 Oct 2026 17:08:59 +0100
Message-ID: <20261026160913.207909-12-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: c4547f88-6889-4de3-c013-08df337b8c6f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|11063799006|56012099006|261021123027099003|261021121427099003|261009223027099003|260925022911599003|260925021911599003|260925021311599003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qbAfrW6JXAIFe06OstB3Y7gXDH25p1HNlkx2r/Ovajn83ydxA6Zz9s1wAofvpzkXVvj4Ibe1oxL/fkaGFT54CqQ2SgSE4Boy/x5FBVcZmUbZLOzbIvegIwHBOjdjZVea14TEowlGFNJY8txDiOjzo5ZqS0rEBQ4Bq+y91VZSwd+DSwwOZsnUADWnD0yksMbcO/OVQX4sztwnXWtdKJGirF8uD79UuTPivTJzl3l7xPtbzQhj3lG8S1ArHNUVIrWV6ZY8mvLI4uMgXS2KPAYu3qvuLCMwX00YClWT1xxh3YMeA9aQerY1hHHK+jmf1cpZfp6+O40aMxe4w6e2MroqznGvE0txIlym51qOrKDz6LcUrS8j3CG1rEAJYXysidlgQq+FBMV8wN8vBoIMVkHg0csxYT01Yd0Xyc8zouKut6UeFwpzlQJjHhmymc2OM9LrRg3uNT6iUN3sgNyr4JHY8UluTQgNquFErgRc5t8xgySrJH77RtfU8o5M0adamzleHKF6jCSirEapveAgPT/UiMySd4S2/eOzxKopDfbc/29VYzv127I+bNNgxJfvy2NwJI2Dc+U9G3D+rXgBTJ97i/yS5RJiEdLF3bqWJUqi4Yruor2Qkrv2qjMuAtYzkdPz0Nky9g18b66H2r0FzROEoeinKJ9o1U8PUhbFhdnGvko=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hCnQXTxjvcKr6Ym++RVFEnaYlDp+uZb+p8X5VLEDHIishAxZokM7wz6qmAs1?=
 =?us-ascii?Q?fOW46E9I3Zp7PzxcedCiV5lgzgzHjdSvfhAvxoifkuFKx3nHjsy3/6d45PZ3?=
 =?us-ascii?Q?vB9aNm1e6rULMfsKlbwNlkZLXGu0l388zyKmNPkA4dICgxD7AbBPz9teAyo3?=
 =?us-ascii?Q?5VTipXf+L8qCIqjfRYwgBwE9TV7z9MANZW9ggb1i3N79mMFGl+FtU+h1GeWu?=
 =?us-ascii?Q?d38NG/sD/xjBH79bNWCH44wGyUxWbJ0Xfjd09Znt3x2soVLu98fzsobmE0qX?=
 =?us-ascii?Q?gqcq8Y+g/nUzqvdT97KLTgq6lAFjGhpjuRzeWeWIGtpTEjhiscdFVwOy4U3b?=
 =?us-ascii?Q?5F2WmaS8G8ISd9RtwQh3Ocl3rqmyWezL5JrrJ/p5X7R77rJE6jLhv+GykWzq?=
 =?us-ascii?Q?49xTHV0ux1up9Rl03ZOx3oABJ4/KHAmX3FI8O4NoXNKEFSs+ZldFVb3DRRhk?=
 =?us-ascii?Q?SJ+vP/il2qykz490QmZRRPrENzCofqsGF4FDomHvgN+o5BmG0H7bVPzm9GNg?=
 =?us-ascii?Q?hqGnjTlFoUQytMxuuZdqzMqvq5OL9byQPf+UY8BiUE+u8QMK9d4uOX7JNeYc?=
 =?us-ascii?Q?H0mtJ2dhDl4FYR7XXUYfa0anEpUIYQdhVKxk4LINS/PlStUHXXaMrdba8B9R?=
 =?us-ascii?Q?En2NpXW/RN7MNYfN6sC2TzHuyTkjPOtlrd9zX1Vheq2N1AVVcpkEfeBa8en9?=
 =?us-ascii?Q?cOmWYfT7Sq9W/ZYjHusgUE/fZ5oNmU8w9as69lWpU9Ip7CZC3kQC62AujoMn?=
 =?us-ascii?Q?1Ie6MzztLMArOhplxRj54H8XqLCAB08k34YthEHn23GHwf22t1MpFGuoMfLd?=
 =?us-ascii?Q?sSxC+YebTgt+E8ZABXYah0m347JXe7JWK5IT5vLY5Am/MXSXbVIK/ONAMCs1?=
 =?us-ascii?Q?6gvV5mCdB9m/CdPnTGFHi8MOE2NzUHcT1oNw7E4rFvVPs91pTc4uRvhubEdT?=
 =?us-ascii?Q?GRJPXV1iE2GbPhXgIalyIusvVGHpamRudUlf/bQijcEfC+CnXa6dlvo2zVak?=
 =?us-ascii?Q?70zmBGJ5aaLAd7c7SS6R8kBOqNvPNTiRo10TsXkLajFYLz1MW2TqnLOxSTp5?=
 =?us-ascii?Q?JUe6PptLoGAllhK4cW7osDXnAQvaJVh7G9minjq1pba91tzErGE3BZjEe432?=
 =?us-ascii?Q?L3FFoRfKmYTaTTa+r5LJE7Yc0ncvIQtS40tjx0kpCTToBG257tBTuK63hMdO?=
 =?us-ascii?Q?zuSKR+KZxLJLCr2le1pstKeBQSynr+iUhaME7Hl2YFNCweuSNRl2Tr0wbWUo?=
 =?us-ascii?Q?hQg2KFzNK0S3MHknj/BlWPxK/UVP6rk6aqmxw1U6fFADsWOnwmqO3VIhi9s/?=
 =?us-ascii?Q?8SxxZ3ghiueh9apldu/WOSAdXUrzIZPakW2A4t5e57HWkutCQcMfDjZwqBN3?=
 =?us-ascii?Q?5qBqFUxSdVZyG7eWh09fvifIyvd2fp8EVpp/bnuD/I6N5ovs300d6iCmsmY3?=
 =?us-ascii?Q?9S5bURq6p/tdH5hqBCBlrDBe4xzienKMlCmazDcpUMEw9TUh1ksp1iarPuYv?=
 =?us-ascii?Q?1Ck4KD3B+pWmDTdJDgKvYDd4cte+ab/sALq/mM4rz4odnvlLFriNlvQ2i5eZ?=
 =?us-ascii?Q?OWpH83aE/G9iiDfwGAD6Awjgi5wo3G5mm0pVmyOige8cix99CgI5nbvigYov?=
 =?us-ascii?Q?eNfCcqp+0nTrgzPdSKCML/cl7XmM/8rt03fhLvxYk9mLF5ySeYrOPmvq/Q4v?=
 =?us-ascii?Q?+f2UzA71lzz0obXBQFgfoKNB5vbo+ZslsfE3ShdZH4DgIRk3xNSg9cH7dvjL?=
 =?us-ascii?Q?+gNw4Of/FXvRFI/ZX6/h9spWkkQaQvTNGQoUb6Oz97Tt6zTTmHeT5RCOtjay?=
X-MS-Exchange-AntiSpam-MessageData-1: mCaylHUdJtJArg==
X-Exchange-RoutingPolicyChecked:
	I8PD6qRMowOuAbLMMlllOVofx/Lke8ATz8CDAq1HBFU4bPF3JOrUWwQh2x3+OzL7uBA4e97yCEhlpdseYQZAgg8Alkyf+MVh5t0Me0Ry/y5ih64ErSE4U30tR4xeMPWrdw3cfuAW6cXzzKWMnRz6K3pfjBv8TyJh2X5Rdo5FwvjJlpV2wvdkCWjQaI9QPz+DyQRX+riFQjszp5f1YcxU0AcmCgueBwSaKvSCfBFEO19vTop+Z/gsokPsK++Rq6AMJkHX3hIXgQgL/SDGMgAEkYQyZfRBIbMz+s4PcFjvwskLgBLYNtDF/pkLCekUvG+iZKmr7Wu1+MUJRg5AsGT3fg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q7YbZuc16Q5ciYmKUiqn4oUVXQ71eUf7vRXwB5LmOCgUKolHpG9XxDTfJQgfFFyyKqywXx2lFExuL4MtHDwrN2K7oj80pgJjCfSxawu5U8oWsojW9tKLAz+k8wtU6VKwUH+VjcM2JABTwqzPPoXh8UssbK0/cWLxtG0Z/fNbeebhz0nSKTLF0j9zSB2dMnS4frS2DhTuvqDbavxG9eNZjGmk5CBjW5zvKrWRPArVGzZB7kD0Z32ph/39aSGNO61rC0C+8PJ8eupSQg842+VM16mc2ixryYT7s1KwI1V3groE/nhiuEktqt/a/I2R4YOQhaulQKnhg0VUV+QechIIZftaesuIUT3IqTtUMAJGzLhYPoVwiDJhXSzLSMSQDBCT4JeAuaX810YEPzokdqxoGcWiFngPtFec4KlmFTbittL31eg/Ok+lvTblz2/Gou96bsWYLOBwnRxyeSLFEAAI9XnsV8ibc3yD+T29OT85kDHzJHhU74HG+lRfEYevBxlMTYGA91cNWEP0oPQqNMCLSnC56adNTcT6ghqMnxtevgE+JyArgv80hRrkV9HJ9hRP4UNQpBqa6PRK+bkcxwekXVLewGUFkaZMJF09LrVif4UJL8diruSD781+b52taB36
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4547f88-6889-4de3-c013-08df337b8c6f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:44.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HyRVpQEvOCQ2fJgYx6BHsu0+dsha1Wq5n1V75Ie5hpb2ODHvVp7fBNFYdvk2z95JNa5/tTKwyJeQZSv+2VNVSm8ixcqzH1zKTSHrGxpKh6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index e99786b29587..0e4657347928 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -431,20 +431,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.56.0

