Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211694;
	b=0mIu9YeTPa7GNgsQDo/8LkMwc2QD/RiH4osbIj9tWMMqSayL1CkMr9CdYzgxX296vqfl
	 HTXD9aIcu5fqHxGADQ4bM2DC+bPl8N7449ReG+xcn62MLFbwhuKOBqP2iwD1TzUC2OA9f
	 fy9daf2iqcylaDwGmIsHlYqSwI4TC5gd10jTibfhS+zP7E2EejdAUcqweYi2SNzM6Buyj
	 JSKhMFPHIZVQE2dn3nTTBY0lpgBP4uNAwEIOyAoxKkiIz/neQnlaFpOA4N9nsoWSv+mwa
	 ArdRq/mpUEFBWDjwKTl47aS3fhhSWVwEQqnX/pH7+mSKYjhZVGnWbmyc6PGj3i7FK9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211694;
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
	bh=FXj2BNYdkexhtM8n8X+fE21SoAyj6yINaBp7iaTi9r8=;
	b=LR9sSTZroNdoxGxUhE06b4nsBrmJ2dIov+JzHRV/Myta9pUxCx8+A1wSPsHOvD+ImLUr
	 vkMa64Bpd/xFrcBCemVXm4sL7vXxD8Qp9O0puVe4/ly+tgLmTb3bBgggI44imQQlUvz8D
	 /dYeRdknrd0VvtleiLJcZsW2VQbdC27v8iupCX06HQFyQdbfwVQFNTOHVvkvmW0BzL5MB
	 IaIRXm1e0AQy//eNOtoS+jGnl7dh6yNX1GnsC38I2pKWKOT5KGRi4dKwKAvkpqmE7Gfg4
	 1Wfzvw7Erkl9oDw3M0PqLDyxmoGPGDNU22I2rQK4kG3MfNS2vu6G0B7cg4yxqsSRwIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=OPjgrNOX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ZF6qHxt9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893A606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4893A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=OPjgrNOX;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ZF6qHxt9
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211695; x=1824747695;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=d5oYwR2BFejW7JInHsvZUQJizRVN9UkXdavvKNMQHpg=;
  b=OPjgrNOXBct53qfX7+helyFsvcaqiaPS4jz1h2hugdzieOWVEJazn4Xc
   t0rN5lgYBPOqa6amRMpvAMIwRRaPRUPUghkDcyugrA3QuciIeGxd9uiXf
   VjHAGk4itG9xzoNPuTklqeN6Ur5fP+7wzV33AqDB2cD7ygR5kNTNIiYBC
   9gY3RC820AT9EfYfXbRu0TFs9XJfGxzN5NQfXPihY0wWme15TZpcpyrC/
   2dKJdHUepj8TZuJfvKv121ZFkMnf6OweM9VlqT/Qu0iOHjXqOga0Chl19
   ToDJcz35Pi/sqnam7e5l5qG3qXZ6tyNVH/ZpYQm0Y4aBvdfKcKkSCe+SV
   w==;
X-CSE-ConnectionGUID: wgsLkui3Qw6hP5zuSPsNvA==
X-CSE-MsgGUID: YJGzP5kEStiS7qZ6BWNcxg==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159234660"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7o9GU8nvgxzlSdx9upEkw6KOmxpNAvOr/ZpCD7OFYBpWXd91BVlBAhWRsaAisvKzaonoCkYkE5+CZlaIuiZ7HUE/H9aN9wxp2rG08vfLZpGzMFdbwRSFfPigu+9ej7ags8xo8k0OnMT3F48QZzxSBGCTnGoeESbntA2Ra0+GsFGCn0INZQooIyVkgwd8Scy4k+SPp6cTIKdTvlD3+SlOfC0vtgga805ETO7zvsJVvn2nRFCdbXhsIeuLtIAsYH0uQidpIHVBhc/XCKzyizAhjkVbQ0hfwQYCnMS0LKyhJnM6GpYs6WqnbdSRVJhtbWCVkxP6JC7BVbMROt3hAJVrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXj2BNYdkexhtM8n8X+fE21SoAyj6yINaBp7iaTi9r8=;
 b=Sls1YWaAlxtfXXI3OMKkNPpaYPW/4uggf+8Auq/bV5txANy4LeaKM5GuGSyiMM8lj6NvbVMMbkqTptZzIzGV3Yn+wX3XpwyBu6j5pKcbJJXU+worTxNok1ZY83by8qAS/eMBQfEBjkWtyaVVowq8ped8lpj4GoZYy1GTy3ZH0VoYzYz66h9wXdfTJgCrBnAhrpxEaWIBwfpJzp19lExP6sj0zfh9s0A1cNJQr7NE3+bu1YMwbiMF97DoMObLqIOfeK2WEnUOxixRTeew27hQo1ILGTZ1noFQ76xowkXd9RUmzODQ6lztrDGP07Ez+i8GyYeh1hkxh2iuBmKQrI3/jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXj2BNYdkexhtM8n8X+fE21SoAyj6yINaBp7iaTi9r8=;
 b=ZF6qHxt9Y8Bvq4a2L9B1x/hKz5DCHArRG65qpKABPkUf1jseCIlhWOgZlX6FZeknvbigK30a/NwK4psU89NrvFkQFzbWHogvzObl8TYOaifDVlQOMbUFlMXW2c4M/9X9CknWOdL7UZd2U2J5Zhu46yBkJDE9qi85/5Ygm5p+kSU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8753.namprd04.prod.outlook.com (2603:10b6:510:234::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:28 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 00/25] btrfs: zoned: fixes for generic/747
Date: Wed, 28 Oct 2026 19:20:46 +0100
Message-ID: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 27756760-6352-488f-53ed-08df352048d4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|376014|19092799006|261028144727099003|11063799006|56012099006|261009223027099003|261026140227099003|261021121427099003|261026121527099003|261021123027099003|261022075727099003|10067099003|261022105027099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	YSoOZupSoBedtSDn03RF7FBtaPrbdvTYDRxnnVfvR8AIQVqxz4buRuGPtMmwf99pux1vauwEjjt0WlMQyXedk7q9rcQgYi1SP10qeXjZAC5OOOFLNdEvKMwGrvR+Sys3LsbHOG1iVJDTxbCCRBvPUiK7Bq2uMr7iT2Azhe7NvjVtc7WgD7WRptcjD7zqf0Fa9NZy9xLROOq2bdc6LJoE8RozXGc82lwUsR6ZQ0X0+JvBm9wFvjF6hTzWP+4AQR7mpWg7HTtG660XpThOVNjW1ukWb7awLyoBPnCnhnyHP8ylIhc+B7nxtqgE6kxR5FBZxsPixSlHMNPoKZyWKSWEXsnw8dSmb/7cq+db8f360c+zCEUP4RuKfUqHP78YJD/3JFtz2qyO/KQsxM6gqDe+IZtk4Q2yswzMYOKCB/Nwj1mNGA5lt53rjXeRZkZEslFuKwYUYrLd2nAisxmspMtLeqW/ziaw48D0HKzZfWVS25MJxKBAKdh8eOcSSg1qnmIHRnG+ctAoJEQa3J8p0KW3/kQ2RIp7vPC8CfhgZyVmmDD2Xyt1eLEVEEJv/w+5h1MoGBewwljlo0c3EMHC1FAUPr0+r8l2CZeJC+UC8E6P8IAMRcCXtg7Q8zlMVBg7cZZp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(376014)(19092799006)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261021123027099003)(261022075727099003)(10067099003)(261022105027099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Edh0FaA0+1kp0+nzINo9Hxv/icUHJDVJiFjO+H0jVqyFxtwF4M+RsuxjZOlj?=
 =?us-ascii?Q?FnqsK2Q80IsF3WZcR6Q4vG4xgHC7MdHs+1MFZzrndo3SVlHv2Oi4mEjWsr/W?=
 =?us-ascii?Q?To7gmeQK66TSFandQbX6TstxR/zrCMHhBT6/qfrx35WstL/LMHwE6KEMLNGf?=
 =?us-ascii?Q?cu9Yt4tNVeZEBho5Q2ILXMM0xjYhBWuAZUoKWFHPQ3o1ja34Mgvez5qnKQOr?=
 =?us-ascii?Q?JEcmkT+KiJDKl+n5WnWmAD4szSRvniopAtGG3u9snOg3VZ+k9Tpm3o7BSBKN?=
 =?us-ascii?Q?RnNlPKJ9ScmMLsMfxKJ8muMSYFMpR03GcrkxGQS8xIO9StCKmqV0z183Kt2M?=
 =?us-ascii?Q?5nD6qGSao0bvQFgFiJgVUCcfH9/CQE50WcLW4PYLGcl40YQdMozYz06sc9K+?=
 =?us-ascii?Q?+JMchYg1z6rSSGqvvt1mKqi5xQ8PU8vQ4GPNFE3D4SRCETob0WcsJx/rw9nb?=
 =?us-ascii?Q?4m2qyksIoiT/bgfXjGqWAvdmKA0Gkntelx34cBJ0lkgk3NdjwOuo6OknUrII?=
 =?us-ascii?Q?SdDvCT2MGPAf72rfDJ7MNjlj9XC13e7D1QApPqGNMoiWGvpCNwQGAIVt/URM?=
 =?us-ascii?Q?PUB3yYWLZcgKlvQheqLmCsPwLvLH1mIcb9g5eHgvEHjrrz/0jwjt0v5RRc3s?=
 =?us-ascii?Q?sbQwBRITfpytCQPZaojl+wxQ4Vo30X6TK1hwi5UCvR6Y5EZoJmSPrp72cY1Y?=
 =?us-ascii?Q?syeCoppGBq74l0pUQTS2dNLKNIZ+ujv33ea0olKkyAbWl8mMmrvFrhUD2iES?=
 =?us-ascii?Q?GXxM42PYOR/1NMQiCNNGkFtk716vPrH2Mg9d+KlbTgMdM83wyvsfjEikS96o?=
 =?us-ascii?Q?1p2mo+EcK+dd2bZ/he4+zplNEuoYrN/xc8CqoKugSCHOCyzwE5FbDKLb9Sd3?=
 =?us-ascii?Q?owIbO4rsPp1squPWqOtBvqIfN1NS9ep6e4TYNIAVwSThQ+cYsyAT6nh1sWov?=
 =?us-ascii?Q?MkoEo6to19kIbVsov2y81gAKlWomybrzXGmwz8ghK9HJLAR7YJNF2ILoGi5r?=
 =?us-ascii?Q?qjSv2yXscBQ8dkMdO0FxJURC4DDymkhXf3m8e6F5OTAXBeRkLjWIxfc+FwfX?=
 =?us-ascii?Q?lWzu1lcm+Slu1NOYMym7//16Os/BXMFAlFfWxxJU7ASHWK9zlvJKxs9k2CMM?=
 =?us-ascii?Q?xWm9+rpI26U4TYcKgR81HtkT1TZuRY920EKpxPetQG0JqvmIWcZLbekQW3P+?=
 =?us-ascii?Q?qKMXWbjK1WfUrCkUKpShULlq2gaoL1LNKl2Jz43xyVZ3+vslEM58VELXCtVG?=
 =?us-ascii?Q?CUAQl+N5jdN4wO1Kic4XSjqNcjvaQqM8cxlHNRcF7wdPKYB73UY4Hs/H+g6S?=
 =?us-ascii?Q?dyadiRohQNE7YyCLJfDtWaWT923nB77+8vl/iQMcDXeG4+NeMM5OTqjV0QQJ?=
 =?us-ascii?Q?TVafc3zMUyAD0AfbOFHQs/Vwpm74pRlYCMt5UXidE/d81bO70HYG5f3PRSIE?=
 =?us-ascii?Q?p0G7ASNh/ZkTreL8T0SBMRXY9DTFgsS/cVoFdQW5bFBtSsGQJi2CPg6NFrLM?=
 =?us-ascii?Q?oUMNJZFPF3d2RnOvwgvi6A5TznmEk66Z6q2RQDrY6TTg3DQOE1woVa0tCB4N?=
 =?us-ascii?Q?X25UooSG9xS9psUc11ktkAoAKbaoKbIIwaszSKJaiBuVE82DHCWluNJ6YPEZ?=
 =?us-ascii?Q?Y7yFcZWgbfkpY4o+nHux6M5KEdinYyzkiLucvey3LqDvJk8Xz/Wnk9LYIs+U?=
 =?us-ascii?Q?xb+HcYxzxoGZE8BdepV5DaguBrdVGQ8jT685LzyEIHnJbaVYO5EIq9kRARbr?=
 =?us-ascii?Q?XO2VzA0qhD2Sg0pSh88Ru6xEEWALW/MtheMcI6yuRbRKf3G5TKI/ydaNiaVv?=
X-MS-Exchange-AntiSpam-MessageData-1: umEiWhgd8z9uwo066P0Sln/EGioO/XlyCks=
X-Exchange-RoutingPolicyChecked:
	GbXuqx7U7BbdNLRP3o3+vcqD6ZuRcEt/QCA/ot5ZAYYVirYvjxkaYsvnFujleCEWR0CrINWfAM+HqjflPxjXgTtW3OWSHtQQwCFvojBY1oYul/B1rAej5u7lJEFscxuM8OsIFEmpMi34RVHuhrBFl/MzftbUo4ut0cxT6fSRJk9kus17hwSNH7gWVqKkmNF8LQ7Q7K+s+lliVmsJZfSJXWywfVUTyDlMz5pqNCbFVOODAWHdtVa7UHEu7XLFCc0Vxtm4Ewajx230WPGsQ7LlpqqVOR0E3MrWQvDRx7UAFmtXkOZ2IV69atWakszWZ6CxuWfmaanzq4bP3AQ2n0jRaQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mqoa9zb9HnioZmyXERDV+sH7Ym+F2K9xbkaKmPj4/CxDFb7B7MOFfRfvpwSUqc16zG0eezvE991AV6nD0WoDS8bKwYY1mwuRHhVXt9QRyduudKGAvyMP3k0HuHMGwSdcKkZKM15ziNg1DS23yAP3iLrBBEESRmwXkHRPlvS+1j23+DWJDyNUKWhAwXEY0DmQxYA5jfHzdwlU6Yz/lxSVcJMiYk1s+P//yg08nNlP63qmjvlY8zjnfaSL6fMuW/Lv5u41MwvRnkLvQcl2hauumVSNI8779L+LyQ65xHhuJf4FdzPzKzNvdCOII0q3z/oePKQ2sANtBBEsRcpUy1uatLUjYMYoCQBYAdGpD4Uf3dbnRB/R+RtzV9vSf36/K+qwZPCxHWqd57CvFyikIrbhCNInBZB8j3/q29ZnIdwx798Rg6ep5p4B/wkCq9cfjFWRLWSDqLsi8j0hyMQgTDtYDPFkcm4LwZsU25opyZJrYb9a+yL1PJYgIflmUAZnvooTQhT9sAklosT3q78cUUH3lhWv3gqz4wixA+AWfrc1uxzX25gtAKgcPdIIvErS7O4CTbI7dTOyQWbICpJqydnERhcBhm8hbo++mpft6xoIBKBYwMhqz726PyNLeWWNLFt7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27756760-6352-488f-53ed-08df352048d4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:28.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xadiVDTgYD5Tz1DAvTmRn/qlGyieaCGsJ58kFhnZrIIwKzyP0iCuVb/AqP+l7p4hfEHS4tSi+4cMIw4WGoi72N0MzRtmlgtMDUTvJxWvQFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8753

At the moment, zoned btrfs places doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by a tackling the remaining accounting problems and
relocation still being triggered not timely enough to evacuate the space
the user write needs.

NOTE: this is a combination of
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
and
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/

Because it makes more sense to see both patchset as a single feature.

Changes to v5:
- Don't overwrite ffe_ctl->policy, pick the allocator per block-group
- Retry without empty_size in LOOP_NO_EMPTY_SIZE on zoned as well, so non
  append only block-groups don't hit a premature ENOSPC
- Perform space_info migration only on ro block-groups
- Only set data_reloc_bg under relocation_bg_lock if it isn't set yet and
  undo the space_info migration otherwise
- Skip a block-group in do_allocation_zoned() instead of ASSERT()ing when
  data_reloc_bg points to a different block-group, and only clear
  data_reloc_bg if it points to the current block-group
- Don't account bytes_super twice when moving a block-group between
  space_infos
- Return the free space of a reset block-group to its current space_info
  if promoting it to the relocation target fails
- Reword commit messages of "use the regular allocator for conventional
  metadata block groups" and "return finished relocation block groups to
  the data space_info"

Changes to v4:
- Fixup broken rebase

Changes to v3:
- Fix the active-zone reservation race
- defer RAID activity publication until all stripe write pointers and
  capacities have been validated.

Johannes Thumshirn (25):
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c       |  56 ++-
 fs/btrfs/block-group.h       |   2 +
 fs/btrfs/extent-tree.c       |  50 +-
 fs/btrfs/extent_io.c         |  84 ++--
 fs/btrfs/extent_io.h         |   2 +
 fs/btrfs/free-space-cache.c  |  23 +-
 fs/btrfs/fs.h                |   2 +
 fs/btrfs/space-info.c        |   3 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/tests/zoned-tests.c |  16 +
 fs/btrfs/volumes.c           | 107 ++++-
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 893 ++++++++++++++++++++++++++++-------
 fs/btrfs/zoned.h             | 118 ++++-
 14 files changed, 1115 insertions(+), 272 deletions(-)

-- 
2.56.0

