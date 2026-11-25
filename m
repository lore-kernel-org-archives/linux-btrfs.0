Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602660;
	b=0tOsTz43zfTeTqXZjp1zH8nzfWgAAt43Yhvx3b09SqzIcT7QSTH9HsrjhKuwm7RcPss1
	 3Pm2v2mpBwCoixQ0nBvPBhGW9YALvCH204OmoFGlmDMwWOy/Bk68wM82tz4eDpu5ZAsGh
	 sb4CrcivTfzh7qyDKwoLYxQ0UrZvdDBW1hRMDNn/eH2r1XT4VVFXnsREWRls61H7wIeW4
	 YC33K0gCclwVRXkkBjf/jUSsRZaVKWdD3pnr0WybYpdCyLysHt3fszvzCY3e3wiPhkdUZ
	 BGwnmle8prDk9yv3BbGRu9H/faQjUbcqoVm7V//LG4nd2XhwxO2ixm+smZyjUohlheg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602660;
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
	bh=KAVaHaas0oWP6M5b8XhLJftEdE5/AwEu0A4baBdc+AA=;
	b=Ju9aMPgzQta6+HXhksVk1layz46OqOnsCIGO+SGsUdsUVvW6a3j/TWMMr8w+v5Uqr7vj
	 Sd8uMf2DJt46mKKrbEAslHcAvqys4Kg9ruyu/0fvm6MuvgArej/mF63dWiesMCS2dHuYb
	 XI72qQSFHZ2K1/YUg9O/xQ3OHHPyj2xhXWLnsCmmpBmXdHooVYyLCxKqCEjxNnLaCS9Cc
	 3dSozXlnVqXUY8XuLA0kXs3pL1yW7RXgLyTZk34VrvoqiLXiLBblvGpmMFo0DRrQhtnOb
	 YlT3L1AEXbJlM725X8xEGqstRIP6yzkVQkBWjJ3sf6vOwsBbx3PhctyEI3AdgnhpJCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=FNf7vNe0;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kVa1fOSd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9E606A329
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFA9E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=FNf7vNe0;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=kVa1fOSd
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602660; x=1827138660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=MxVaxVHWg3KQ8kae3OqprCTf9xi+ef7++449jcsvm9s=;
  b=FNf7vNe06ZfM+R5LgyhZU7rIQcReHiIYKUhZTI11dDPaFR+fn5PYvkC2
   BgqgA+auwxoqQBqOvvV1mYqIjaMc4lN9zIw0DOPpaSQhRcdx6K7Y554tQ
   qgvOBolUT6a8Zs8ylq8IY7L8w05o5E78jaDAaqyKek+Lcd6OB8rSTLV8U
   lKS13kXMJIGepL1enxKkDHdu/uGdGHccrkzzHWXvq6v4styZtepUCjMxq
   mqP+374Z5LwB4rewpItR2b/JGxmBifHQIxtL2/44jlQZpR6TOGvJzkHe5
   WpSRPVp0/fts+2NR5hodufTuQwxN2cie7C87kWuxBtVTjlVsUsJB/SP7k
   g==;
X-CSE-ConnectionGUID: dsznRfEXT52dn3cJWISUxg==
X-CSE-MsgGUID: uu4JHGZQT+mm6uqC23qdhg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492439"
Received: from mail-southcentralusazon11013019.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hq2jP1oYg12Ur1nB5i5FZKu2j0tIWwdo5kPIwR9WPfrfJJIez5qCPD5XOXXYPo/EZF3j+4o6wUtEavmGpWaRsAy8RnIABDuHW0/BGDfl3IiWEIrHaLMps1Fum39hfwHQ4CYIa5JPUgLBVXg8olnycqKaI2zR4ShnFidMilVcArJVVScWnqquDR2aOFh8dXb5zYppfqwyBDbeaRmqrT8jR2UFR0zq/dtg3WOBRiEqbP69P4zuOJhI+41mo8IhJzpVx65kmHO99VlyJv+P4O+DObfEZSMi9k1lfjahnLK9smVIrd8Q01Mr6Ad7aGVrCEYdgyoEtQ+Evn4FPK/nC5jvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAVaHaas0oWP6M5b8XhLJftEdE5/AwEu0A4baBdc+AA=;
 b=XPn+xT0Bzn1eYWJczOblQN935gL5GtwdxZz0KvF7s2haY7PCC0mvOjmOzUS9jJ6xyInnUuBvguQ2JoSBSzIoR1NPX7XUdcCz/dgB+5chiWvHPYhpe1PIreGl0lWUSa+1pzYQcn2gpJrAMyCh12jeJYNz10ne1xXhZF99RGVCCpUF9I6ehEPkW8+u298JH/9QYi5woMxkyLKOA8KvNwY9nLWFgl2nlx0yOUVQjo1sRZI8FhrCnwHwjPlGOV6GhBYASLSywuzfyhUoJTs7vgcEAWnXWXJBd4dvoPKrQ21Oi4yg38uyOVit1OWC+lWKLr1GHVIpE/qiHlNHHxLtCg3VQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAVaHaas0oWP6M5b8XhLJftEdE5/AwEu0A4baBdc+AA=;
 b=kVa1fOSd7YvsHJ5fqrgRldD1kV534XzAr+E68pHUd5aqtPLwVoJZH/2QS16mgUKgLkz0ldkjKSlXj+PdAQQ2o/4jrEs4Pwk/lAkwKsCJQh5lOs9pDRNEE9rKT2ZmZHfGP14z/MtFEviAtGvWtzt1trj66OwqZvbWcgHRpR2jWGU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:30:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:57 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 19/27] btrfs: zoned: factor out resetting a block group in place
Date: Wed, 25 Nov 2026 11:29:48 +0100
Message-ID: <20261125102956.266389-20-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2b4d2e-70e1-4bd1-366b-08df4adf3158
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DUgSHw44ppuvyNdidYHHbbDt9v6Ur2qFOgLnUk63OtLymHE3z7UuiFu8AklCATnq7feDJKxmYHSjH6noSJ1JdqNlZkvVG8LY5zc1hTytuSqAPpl1hO9ZWaOKCRwjzi08Kkiac90op2Sv3vyzXXYQr517PI7raLyz3PNCmxhliJ4mRsKqCIuJad0bUUFAEdsApXAjbaDP0cmlxgiQwBo/fCd33LJ4tIX+VlP2d00EO4K8oHl3mHL8xlmc9kJvsRjCF5ijgDLt9tGeFLq0w31ZdtbbYA6GGyP6HM4I0YLg2ILJU5ZDI6xIDsmdoCxkRMLvq6HTz81lUdRUl3/aaytGDKL7pMoI/rAR2IqfSLSz2f9fkp+U3Hz56c+J2FTg6FCRyA0on4NXQE7sSMz6i6OC/fNM4XLDO5GmbjHkWFx0wTaaCRjXqMb2i2fIv5RmIPZvM8uGbthdJAsAkyVz7+uTAsOGVS5tt/pAGzpD7ywOe1+Aq4A6brNRILOLPC1oMZMbl1weCBx+D06dfssUL4QoYPAkvDxv6RKFErXN0maCp9pFipLa7miNCn93EQWcreRQHZx4kj2TKlzakXorGajlBUGPN0lpg2knB2jujfkSGznSp2A5/vBvlhu2JYAJZ2LW71KT3kTTBRzVZy4Js/uq1mshVhKwGNJf1BtvYeCV9r8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hJ27kW1PoCl5DMyKvmZGFfpjFagV5bk9OKiXjC85uLWH5KyHD2HZmLQMrgBO?=
 =?us-ascii?Q?Cce6gWV2SEywQKxtfyslqiBVLmLCLgg5d8YO938fcJwkXPP/4Kl+W9RKDJUT?=
 =?us-ascii?Q?drSzG2Nv3RiCp1Hq5ngz0OPj0oj4/I81qrCyK9EOljlrhSk1ZC/5lEK4v2ZI?=
 =?us-ascii?Q?9UcOrInZ4TVuLVEMEGeTFVwrWcDmslyIf4BaHVMZU/dcKJqztSFtDHRb8ozU?=
 =?us-ascii?Q?59BA63ZdaJGdUf8lGJrZ7wpHMYgflN4dlA3gJbFlCU2RFY6uTj7NkqFpBqYo?=
 =?us-ascii?Q?3g3QOZeAZkEFJ1qrrZabxdmY3MTEamIsfA2R2FW1CEu51u1JXTGRj6w6uAzu?=
 =?us-ascii?Q?OVlCJYKyrvdAV1h1ZXJrnwyfHuC1pD+x98W1WhirMuEGYQwd+/egZ4V7Jp0s?=
 =?us-ascii?Q?4YpRmjkcrOEaBdSg4Ve8iJumttlInUsT9noUfLOtXvl/EdUp7wiJBzo6XghX?=
 =?us-ascii?Q?uCI2ijhe4/ttLmlgLwv/F35JMViNTE48rIZ3lWuopEo5SgA9GJnmKM/YlWF0?=
 =?us-ascii?Q?d1FSPgTiD1BkaIknJL1PiDqiG7N53wJqhVmYUZgS9UYpbmZiJv7FeZVEhNpf?=
 =?us-ascii?Q?7bPftEPEUcOYMsTpzeDuvSEOUB0V58PkgUebhLwmfuiSi0UzwY9QKdbcVIT2?=
 =?us-ascii?Q?gHznuZjY6thc9dbxp0Ne37G/wIhmYO06EE8NvQeyEN7Bx0HhAa4jp7Z5J+R/?=
 =?us-ascii?Q?d5F9HmJweMweXqFfzIk9PpBhhRh9HJFbQL8rpGxPM64W8OJ2YZN+bJWtCbh2?=
 =?us-ascii?Q?feXaG79xwqEn9LII0kZOk+1+1DUfx5mth2n7t4yhIgwoe4AexlJCvHmKPcpu?=
 =?us-ascii?Q?9qST+/tzan1PxxRYlo3m47lV0lQUmvzi4XItc4ZVMc6mwT/d0v2zQVLMSN7/?=
 =?us-ascii?Q?Zl34/v7ba0bdbZ79C6VXfu79fRv8bP3bi8V98H9Y4UXk6k+sb/ESABzIKQ74?=
 =?us-ascii?Q?vBoqguem4fEd3y7EH4QHcK8flUySnggd0mQa3N2eJWPuS9iSDEG/kU1yCWjX?=
 =?us-ascii?Q?mfoPiN5lxD0PVD0p9m+Ja2dbrVgOnb8CcoO3MsSXZ0NZBkB65t7pZqXh4l6j?=
 =?us-ascii?Q?zsdn6ZFSS91cTHvXuTr5eOBFTP1fWh4Me/KiL8xfPrQupVaM3F6E7QcJ//Wz?=
 =?us-ascii?Q?cWorYkfFzAUYdLrOSNRgXmpoCKuh/rzyK+cJJb3QsRu/tTgFLJTNJVEZxBOn?=
 =?us-ascii?Q?QuTxlRnz8MwxH9mqSkRd0bcgWdmaRZlUVNl1ciVM3h9+np4ZHfYkP4DHhFx5?=
 =?us-ascii?Q?ksQraRDUxX5AE9I4+8T02OaXLbvAg6S1LnCykZqb8w8YoFsNeG76j7oOBIdF?=
 =?us-ascii?Q?NJRd/XfEWmr6Hz3AXIOoDNMjaLrfRJTNcfWimHZSIoJtJUgzKI18nQUdkeX6?=
 =?us-ascii?Q?kNTm+rM66SktbicdrXHjgxQeniVfwAmLoX60dmroN9f7pBRl7s4Nze7cGPf6?=
 =?us-ascii?Q?MFbr72ElIlI1tXwDaqvSNK3xbccV+DSwra06ZDnkZyM2DzQ1PZdGnT4ZOeUF?=
 =?us-ascii?Q?f5dLc0/KIm1pNV7zYnufpuUmrQk/y7koHpW1ZnxckwwLLfvBERLAO6L50ZLQ?=
 =?us-ascii?Q?s6sRChHwzkzwRnbcSqlhcpMdMWDacKpyLjrMvArafciqlK90hCuIcPJM7H2i?=
 =?us-ascii?Q?c0oCKmlKtHjtnzybXqzfNAvwS3AXN+nHOiGmXVjbRDw8Qz1oQh42vIVmDMjn?=
 =?us-ascii?Q?YLRr5Bpili90R9cI2zBnlzOZCrJ09vv/N/4EUDnarNxKCQ/k/Bb8G8A0DCJV?=
 =?us-ascii?Q?WGwOLvSU//g54+WH8mTcpdXgDVMdr1MOoyE0M77T1+B7scsGjrQ01v8V0sb0?=
X-MS-Exchange-AntiSpam-MessageData-1: ncL1GS6RokTuwKdpiIOrAkrOZUtRznQSjV4=
X-Exchange-RoutingPolicyChecked:
	J9UFbePumw50bqWGrmqLtmWilmjZ0V33Nitmfbw+JhlSPxYwlOPiie3LuMH/b5Wa9V3OE3gOlGyODct9alEhAEKg1f2/90PvAzhGSYnp7IOIehIosZ/tVdjIREx267Q4Ck4c4J0EtNlcU78JJcr5+IQEatlNj+kJ8Ts3vfztAa+5V87MJxJmKG2qBZfqEoKVPXdu7UL8/4Vu+deGvoJWgsj55Cu/xfKnl0ERULYRgOIfRrB2gusPS+EgfNRvp74FhxbrhKrmIn4BzdB6iqkPqVNRHFFoReD1b16HZSa/b5NDzzCtZOxTyEN8Zv8XkPEt192OzCvp/yZqaI8Gy+58sw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KuIyBUbr67wJ+JkDW0U6JPDOjAgL0UmWlzPOIB4RBrrKQaok8qxeuve0jek6ggFX3hrFfq6bsbXJehxsp4xxS6E7+mEFTUUZXXdpdATCw/JheqZM7GV7hRQ1/ssmepb2PvA3JreffuSN5Fae7Nx8kjqcQA2poktwZWQj4hbvSz9str/A/bqvpsM33ZinMhl6Ux6QhLljR7UoaNUR2YVZqHLZv1YMabasv6ckmu2c546Xt4SnKqZID+jfAMXsV1sFor1VAHTh4/cS0kg3Pdbc99RYxZo+/0Xe1hReyDg3xeyAOcbHq9xCAjgiex9vHEEwVnEC9h2baGZu8Nje8ArWfy/+e7ODTLe+N3VTvLsYiZNTQ8R22CRgjuxUZydSPNXfbwnrRnhJKhPuikAGtRyIoq2ynld+ShIvaJmvw/XZK8qXvFMhn3w7FCH1We54z/D7mIEPWKqG9ZPm0wVlOeJUSMxS2GM7qXDzM6ZccSgGB3sTkfVY2boCnQqjyNlWcbRJxVz/xuWGxH4SLYKfudU9ilVLrvdE+yZNfQH1xbcHzRZJOtxpJdXiEkMPwhG+wpaNdQTqj8poC8R4ok4vpZHrL/FfcwoUAEMIgk70tljbQyPiUh7KNXWSG/7ac9FSlCOj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2b4d2e-70e1-4bd1-366b-08df4adf3158
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:57.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oaYPHZ6E1IAYV58/fgTgJSJ4X/GbftRap42ShEvK+OBhkF1gQ+hfa27r3BtL0p6J/tS9PW8aJS/XM2qhSxKm1lGlPPNwxqhpDn+tJx/D9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 131 +++++++++++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 7a70cb30b358..2a25e483e3bd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2997,6 +2997,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3339,7 +3405,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3347,7 +3412,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3365,6 +3429,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 			if ((bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) != space_info->flags)
 				continue;
 
+			if (bg->space_info != space_info)
+				continue;
+
 			/*
 			 * Use trylock to avoid locking order violation. In
 			 * btrfs_reclaim_bgs_work(), the lock order is
@@ -3389,65 +3456,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.1

