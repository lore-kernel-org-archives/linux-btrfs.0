Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E27C496D3F
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634101; cv=fail; b=s6embGEsTg6Tu8LRGCNDSUwwZJkg4PUanALwid/KNKE9yuI5Gzj9YXjo+iVKaRU4ncmkekJEqbPI8tNHhogZKb0jmrdw5C8/muuSoXfdXi3+RqSg4quLo5MQ/XPDQ7wYA46yT0WDYhdpRalfZJZAXGIBOAUG3YoD3AkMo2/GmLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634101; c=relaxed/simple;
	bh=kAKi0O1UXzOrz7QxohgVvt8w1FzRlcNUQ/hgTfy3HyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FYd29kvYtVmDJzFTP7wDSjyZtN2ii/jDgizxhUdH50xImVGOXjaH+O2xRWoqz8IICU6oGwCuxQmPN93GCpUb/RJHMMPBQBYvnbMq1fWmjKbFFrZUysxbxk44tVv+ZAgyNfWPWM5mqw4CXfIVs9X2nI6RGcUWTzGntFNqixokOLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YY23Zryh; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q3yweIeZ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YY23Zryh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q3yweIeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634100; x=1823170100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=kAKi0O1UXzOrz7QxohgVvt8w1FzRlcNUQ/hgTfy3HyU=;
  b=YY23Zryh9kQ8c74C4xBeO9IzAHNuomLb99u2IhzG1PLzCotLpJ0KHM6z
   xPFzrjimnEJnJomEqjadbTfRCskgx9bpfk9TQsD9KlbVQAMBGwdhTIhAk
   +gTbehEiIFCnYr1zSLiIHGZyCtYD7lv3zLE2ZV3CL2FvuiE1QJ7eTi2w/
   u/VL569Q/KELw111kmwsTZzvfAjq1yelMJxJfpnzYZZah0yv5loeZFyQm
   HpZtx9vRHMlQS/ib20rIOFinSTR0+PR65koddKpn6P5xmQLnSZYwfRmN+
   xEk+9pMn/h0qcXPGf07GlRWWci1eth9VT3GtFVwWIggBt7aJ9Nhc0Kh5Z
   A==;
X-CSE-ConnectionGUID: qj7pqbGBRh2mOxErK+UVNg==
X-CSE-MsgGUID: zdhVkIvQQWOY2J+czYPr1A==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785436"
Received: from mail-eastus2azon11011020.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cloMhXZ52AmWwdHv6yySkuqIhrN4euKufLVAxtd21GjhnBLHC5RC6pP6hR+3VlBfMv+iOHqdMmKuDaQkNsG0X4MqEQGG3vNTMpEMAjnhNuF6RPomIp/zkDv9sJ4wkS2bJjw/qvZHV4HbeNdRuaVluL2IKIC9hoG1NBDf9wbv2xWuEMEj6RidcVvuJrMREpPlWdHzUJNY0Yn6MLgMmGWihZCI4qs6DUmpAWY1sg/G6I4QfeMOzSCEyjWulCS7mg+tuY7nJRphfF/uf0R390BJq6lJwlnYp8AaCYk9jP/Nj6JguMymkNL8ed5TOEVrcyS3N5wxb7ED86ygjEWndJ9WVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=He2yV46yqcjLJU8+/6Cg1n/q90KjOpBD35Y+qUYKU94=;
 b=EMMVBfEOXygRyA5aDtKqLG91cBBQcsO2GOp63e2WQqRpEuXaf2pJ2zqAaUInujYPzv0AfK68KO/c1J4PHOYF4gMRTr4ZOEE0KcWqfpanO8hF88e4VYu6oxTP2+qXIP1tLNMv4liiVgEK4hxbjwPirps3PJa+WEHRvEPhtVFZq6TYKBbAoGtocf9gwjTH6jB+z4IHhi1liBt72MzeBJ8ACG0GGkSD9bxeQP4fbZ4TZ5SQbbiQAbwZvJoFyeoWvP/9KWFLpaGc5LSXV8sogqnxObYzVPRv3j9Qib1gv+h6wzxoPVu5iaRvLLoYvnZBpoZHyKFC7YKt+DKZSUviO7utsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=He2yV46yqcjLJU8+/6Cg1n/q90KjOpBD35Y+qUYKU94=;
 b=q3yweIeZAmA4EIeT1X78155/TprSjjftg9cCsuBHJ8L4p1R/rCJqN2fjyFpCvs4FbmO2q5eEPpE0rRaHjOY6g46wG9bMTtTEEOGfpWH4Djk6SSNKOj6K8Aq94BEHLrWzn4J0U6OKGoVPFJRGC7bRSm/KgXOlNG+a6rkF+HSx17c=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:08 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/12] btrfs: zoned: do not account active zones for conventional block groups
Date: Sat, 10 Oct 2026 14:06:12 +0200
Message-ID: <20261010120622.3781326-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 13b5a292-1ee3-47fb-176e-08df26c7023e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	05639kbM0emVYqWq+tugfgWguqra36kApOKKPp50cN6oPfCA2CkRyWRfjuStGi3BA9cCaHcxqyz/qUy0VvE+ktZmitE7iEOUkli4BTw56zbVNcVM/GZXFrT3c0RgOuCeP6Adwx+runvmAP9zTaJEogl4KiqSgVXMeB4T3LUqFOUKgNcgIA6K9pPWqDnHrYznlpYmQWC3LpOT+/K+nZUVLUWRqHXUmmsz80kiJkgUL7mhe2aCb+j9GPrZnKk/E76T/iq//ykx8HBh4WOf/lKm5aCaP+B6Aee1CajaH93PFg//ui5kut8ucA1QZN4fucUp2GOOVOlkM1z/1f2mus/z0JTj//WxGuK7RQjnq8yokQbFFeLwaXAnPweBdPt/irosvMfof+gL7xkn2kZlWFlxqMU2hxgT3mgxA9olkB/Vzo+TGXI7Pk0nHyPSo8v0vxQTaaHD8QH8OoBmYh/trPto9jHsu02215GC9x8+jNHxRulOpV3nM6DgN6VUWFalMw9kULwZQPEZc32wu1Ly6AGJy9QA1O2XigzUazL4Ut2WJmRNpPbCgGwVS/mgLqZh/B1JC05yAKIduGf9kVxZj7TL0dG7KRI9OVLJnTeQ/XUbMA3ZwWDNDbrDawCGJsE5+cH64PSx5MIWdHolM3VGgNGbYvJ9dkEMJEkTc3IP5BTMXCg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rahPNzm2S9yBm37lWS2MqeTsk3Dwass9vN3M6F0wnDj3nv6aUswHBPmOdKgH?=
 =?us-ascii?Q?C5pdFv6id+glQ/zDJu1XQ08UuVp7YifUL7tH+izsHXs9rlhJpLmf7iPWMQhU?=
 =?us-ascii?Q?WywdvGcRt5KysPmXuQrq5GIE5CVsmjwbA0w1VzbttYioNRA5xTedlMDhDZyH?=
 =?us-ascii?Q?XLoT3Ul4XPzGNsyD4u7JCHE79ED6+5ytu6eICB2nV8m5i33Jsehg9J9jyblE?=
 =?us-ascii?Q?vWClEd2Lw0EEzKaxr4sPRlh00h/sB7WVNUSRJbX8w3FH2XgGXmzhKP1Df3Zz?=
 =?us-ascii?Q?1wj/XickFkp8uwLKQfVjzd3zwil/2CZkF8A5YJuBxSkdT7NqUTdfvpzKOSSU?=
 =?us-ascii?Q?vEcYoSLg/XYaVhNiwqUqMSjE8LeIVOFF9k46mEF83+pLRM+ssg/yM2mgfjlC?=
 =?us-ascii?Q?yvtgF0xZVba9UX4N9Dsn7dvZApxAo+KhTgWlXMYfMatLobOsZ/a/SfGECZSv?=
 =?us-ascii?Q?8YhvtCB7xG4z2FLqjYPu0pp7DdZqLD2/2l87iIvt0SH56GnA/ohDa4/zr3ag?=
 =?us-ascii?Q?ruFxIHNsBKF+kOWvf/A0twvEjnvgq3sh3TJBJ9AHouHHSoW6p0VQ5KqVpQ1B?=
 =?us-ascii?Q?OwSh0jnY9R91VfWJzE/Q6q3sk68C7Ly7hRg6mafJK8J7u2bC/fTxwDs2wHr3?=
 =?us-ascii?Q?UlbKnyXA2IbV8JWTXrn6wZbT7Z6rJ1iyVHI4HRlkErg+nZGtZZl+Q6q8YTDK?=
 =?us-ascii?Q?YQT9bggN3tw7pA02vq+/P8QqkkSSXYrqqErc1ACjM9bKU917DYMJrrEbnity?=
 =?us-ascii?Q?p/upu9EAJVuuZaXmirAywFHxGNmd+hJfauzjBLsCcirBxxRW+nOrC2LJbTIw?=
 =?us-ascii?Q?9v7qD3pfgtVUg9xyxFKC0a7/GKZLALr6JRJn5zA8eHA1A78kNB87HksNN6p7?=
 =?us-ascii?Q?3dxotm+7kCmgBrJT9CZrC0UsMqx5xssWhORc8YP/FCQCArqgfyMN2/bph6C3?=
 =?us-ascii?Q?YcYxfUMvEbnadTiEckyy4AD7DHy29BNnYpQwJE5PILWNkc4izOmMx0jatSxd?=
 =?us-ascii?Q?lze9PgYt/Bc4QMmV/iPp4zsTqdRIcu8d+2OhCT0Tyrv1rXWJ7i6LRls1rfMH?=
 =?us-ascii?Q?B4JIHbjK8seVmq4nT3FbgNwVyAsXcszRfio9cNKtfSG6nH3bawZMuMqtISj/?=
 =?us-ascii?Q?ByExj3tEQEju01lc7Cup4G7+zHq4fENlAglSmev+x7DGeNjY0OMjAKbWheVZ?=
 =?us-ascii?Q?Fhh+5RUs+9hAgVxqvivF9KrV+Lw8Iu56qUT/L8kbtMWdIiBD0OGwZ8Jt3t+e?=
 =?us-ascii?Q?g1OBZZoICZuADb5hfxQ/3zLEBPgvErPmz4Haw/iOmHyOdyA/GF7I+6H8sJyy?=
 =?us-ascii?Q?B5dbymzYyTL1xz68nRoCupez0wPVVKDj62nvUJEzoxZXzN4cszWbz1ysRuEj?=
 =?us-ascii?Q?N5vs4wFi5HdibXcQbrTVE7uBVBMhDLGM7+MvxvtGuy47H+TRZgc3WTHlTE8I?=
 =?us-ascii?Q?QoWtgL4OjswjxKv/2Cpi0Rb3SnYFOkhuO+4qGoTRGihuyL2WE2VQoU+UTFlI?=
 =?us-ascii?Q?i7FbgwFG/M2C8AjjGf/kMNMft7xYU8mDYaS9nnn35+uW1eVa0SuF4k3A8YB+?=
 =?us-ascii?Q?m+9L0VxXgpf48N87udmNgU7etpg3Szv1lBGb5kkCX86Xx6ymHPomKAupWRGu?=
 =?us-ascii?Q?B0qcZYMUw02cuXhowNvRJ+ks8IaG/Y6JRPcrVv6P4RJrdmzRjwCzQ0AcXdL6?=
 =?us-ascii?Q?MZH59N9FBAVVXZvIX36U42ritgerAMgG2YAFVD8u/kpNK8pbpGulloWz6Moh?=
 =?us-ascii?Q?Wi/weDOM4DAMjnqLLsVB8ST7qpIxWIR+9xzR7+plCxv6LPDyTkG6HMkcxhXK?=
X-MS-Exchange-AntiSpam-MessageData-1: RzOxuox+C1BsLZWjnp47xnTX9OjzMiWM03w=
X-Exchange-RoutingPolicyChecked:
	PBIu+imYcFr5p0BsWrtT5L5DYDaQQIueN8vGWNOBWWPuqyk4irvk47yOeLC620EIV2lX0AuMbJWT7iMkpEwqfbpVTdKhIF2Gdot0Y1VwY5SSdLePDwl9kdKlF3QfX7Hi+gfbL0wqPs4k4CDImPSAGXC5CVSRpHzeWmfjlpJ3uNZk9jh14+nWDAAfzYX5PW37VjNvmEcwZnborhi3rRWP3bSSnljayBjgIYlRaG4BzlcQnEQ695Y7AKM4kCCvFNGMjsBC8pH9Sx2zyfg6kxsYkdKS3kVUFA4D9nBEnTGl3MPSgfcDfYDJ8LOuyKHSonxEUo6DdOanrYIrzUZz2D7tYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	29tonppgxYhYunuiwRdkKr72MnL781IicXEVuJvPnJyHNhfbnqBPMi0i9RfRBt9ttL2t9uG9LOcvqba9VqM8+jBv1qVoo+xduulTuAoEV/Ia9CYl/JE4BkvOltyXbLfFR5fzVRTabpLmuiydw49AUNgr93HO1RljMD28GyTWJ4D1rKmlHsJDQ30Gyuivx35CLcLMYAtXu0XdubxI2U2E/4GOFA1jUKecXGmWtg5hpOBfCVyqePzSFTYDRDvcp3VW1UeGj1BG84xzU+tDtx2XSb6AQkPCWzgw52mDxJecpBbGvvo8ukf+dkzvgkIChQJD/+7ZAc7AphnrDcmLhKZAVdDiQ11MrojMgCZNtdkOeD9zLKvEG/pwL08B9/3HADIcINcjXjMthE2+2lRJCspJruOhBAgJsQaNxWqauQIaOLb5I3XXqWkHm2wd2pdYxan6JWOW9OSgVRWX0RPJU1rCIagOk2JCrDbq5YLG2yJ7pGI2HHLd+iOeP1x9pgCE7Fg4+kOcW2gEZ5LVQBRa1ModQMU19+p6qSl3XGV4pG9DJGjq26ZLgv7W8ACwX9vUu5t0fVWqy5nTC5LNyAkyUk0NTxGeLaBGwjpFQ/1OOyYtoMitK7dIiXdfano3tqsHj1vq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b5a292-1ee3-47fb-176e-08df26c7023e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:08.8738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7qLHoVJ/IPgiKu4SuHtbWkMNz136SnXzkACoIppSTjTmW9NI+EdjBEg5f3DHEWTOO2Cv9qh6PAaazaP6WlamAJ5ZN38p9/N6YUloTwpAc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

A block group backed by conventional zones only gets
BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE set directly in
btrfs_load_block_group_zone_info() and is put on
fs_info::zone_active_bgs, but it never goes through
btrfs_zone_activate() and does not consume an active zone on the device.

The active zone reservation accounting does not treat such block groups
consistently:

 - btrfs_check_active_zone_reservation() consumes a reservation at mount
   time for every metadata and system block group on zone_active_bgs,
   including conventional ones.

 - do_zone_finish() walks the stripes and lets call_zone_finish()
   increment btrfs_zoned_device_info::reserved_active_zones for metadata
   block groups.

Block groups read at mount are therefore balanced, but conventional
metadata block groups created at runtime give back a reservation they
never took, inflating reserved_active_zones on devices that report an
active zone limit and starving data block group activation.

Leave conventional block groups out of the reservation accounting on
both sides: skip them in btrfs_check_active_zone_reservation() and skip
the per stripe zone finishing for them in do_zone_finish(). Add
btrfs_zoned_bg_is_conventional() to test for them.

Fixes: f0ba0e7172a2 ("btrfs: zoned: skip ZONE FINISH of conventional zones")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 18 +++++++++++-------
 fs/btrfs/zoned.h |  5 +++++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e184d851240e..f69c03a3b42b 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2642,14 +2642,16 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	btrfs_clear_data_reloc_bg(block_group);
 	spin_unlock(&block_group->lock);
 
-	down_read(&dev_replace->rwsem);
-	map = block_group->physical_map;
-	for (i = 0; i < map->num_stripes; i++) {
-		ret = call_zone_finish(block_group, &map->stripes[i]);
-		if (ret)
-			break;
+	if (!btrfs_zoned_bg_is_conventional(block_group)) {
+		down_read(&dev_replace->rwsem);
+		map = block_group->physical_map;
+		for (i = 0; i < map->num_stripes; i++) {
+			ret = call_zone_finish(block_group, &map->stripes[i]);
+			if (ret)
+				break;
+		}
+		up_read(&dev_replace->rwsem);
 	}
-	up_read(&dev_replace->rwsem);
 
 	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
@@ -3109,6 +3111,8 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		if (!(block_group->flags &
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
+		if (btrfs_zoned_bg_is_conventional(block_group))
+			continue;
 
 		for (int i = 0; i < map->num_stripes; i++)
 			map->stripes[i].dev->zone_info->reserved_active_zones--;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..8d3c32f29e65 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -432,4 +432,9 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+static inline bool btrfs_zoned_bg_is_conventional(const struct btrfs_block_group *bg)
+{
+	return !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
 #endif
-- 
2.55.0

