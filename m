Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211719;
	b=pmChAgdyoX7FM4VKthPnteA7oQUQTsrT41JOH0Uwx9o99rT5a6dz1t5x96Im+vkCTtq1
	 0g9/dWeXywW91niD46w/Uvgk6ofmDMtit/517gQS02/8lOk+yzfokj9puBK1zitPB1KuJ
	 zm0uUtXqikzHukyRSwJJNiRcJrQp2OZYyB8elOtyrv8HYvazIk0o2UAIArbPaj3KybRSL
	 OIqV3dBaAPZwYM5fYP2S+kUNjDf3qbpZtHZ0UIGakAH/Mf0IQxrCeahjSKkgCULL4THR8
	 HN2l1d5N27aYruhcZDKHrTS3ZHlSHNWk5P2dbQh2ct7pyuIxsJL87ZvvyBZZsSr0oag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211719;
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
	bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
	b=Ze2hR/uxfRX/Awwyoynuevss2YE3mt8nqNabhOAUgbMjtU10aEMFKY258vNkwth2YXcA
	 p0exE/1MNlX2nE9zuP3BUGo/LN2ns0++7mVwlooxbJVu/2gl9CmfcvlHQwa1d3wZDtUBj
	 DgqA6R9BBclOeX+Xlpxvev0ewfbKQCdqo/mkNI7k0B+OMMviXVS0hU2epbZ6FSSCg2I97
	 AQ/pJOBiF4pE3xsauJXE5x/FfdcYdyjh7kDu+exDwfidDuQASRIa+w75JYNk+YSwM4/+X
	 5FfGYWOzFYQM2Z2nJzvbgAB9EQ6CzrYnIbkxAIvyxL47eh6QdCZWszxHcJZF9BbzVnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="iePX/bNz";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Gjl8cAs6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFA60A3822
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48BFA60A3822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=iePX/bNz;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Gjl8cAs6
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211719; x=1824747719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wbw7DS6pxoc3sA2jc2RCA/+zAMEhTIuxK5pcieUieaI=;
  b=iePX/bNz4qKbIQxTzPb6Y5WI1r4YV0wsqeaayvAP/XpLcSLgKItRmnV7
   91mhfpO0mBrZqhhdjyICnmPRnphpJhSVDtzEQ0VljCpzEUa9WypY3Lr1F
   Xbg8LqChe+KKbu8WXZFY8zT5py4URSQF80tKMGlSBQExJHaAJPXZl7TSm
   gYI02DHaQu4CE2VzhOrBM3YE5eQBQr9cbBMFjyZu/kh6GHWXG/zDnp6Sh
   74dYmBTM9Kwq0SzNlXSnO3j+4eKyuMkaqSKzrl8rt1XxLr+fyNMoBIKIt
   ekznRGuAL2NkiI9ioa4nRgyb14+rQHS4X/zIi14lCcaberKXmjxXTcIqs
   Q==;
X-CSE-ConnectionGUID: j/gMDvb+SIKYedyBTZFfPA==
X-CSE-MsgGUID: GAB9KL3FTaGrPyZk6I3xww==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159135295"
Received: from mail-eastus2azon11010040.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opTlBWuR17frIAE6t/SyRhSqnvk2sftW70Uk3BSLdJuOOKf1fxT/W1rcum8y6XB05I21plkcGdj2ff44ar8q9mNSe30GfzfENgj4gpN1CO/eHRLvj2GhEM26fnJGDRCQnos5VM9hzfIY1aZe74g8ADEcbC3HRZTujUwwUQy99zqD9ZAl+eD1KZnLb5cmwRypKFXCMd8uGDcT+K2K8wHXtPA9jTbxu78pxpp7iYCbXGsenWwuAYvPNWuTTKYp/XMLtGB7yqrsVdT44V6hkQdepS9MGCUBqkT/Bz9vAxddhvlNpsYQP1zGutiOlMasQLhbWgRtUr3hPDobVURcYjDe+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=ayAaJyVe/l0HPL8fDt9evwyI9bIKf1oFGi+VXV2hHRGWAds+q8ZLV+Vo6FPzs5P+CLqgyPHa0RnAiPsR1l08KWseIlqWQqgqaIDtlVFO/kHHWbn+0Gr3yLFEjk5JO0MFmWIpeusFZroduaopeKk/4QF4WE4J9vmEbq7IGxwPzgx4hvUT71zJ4u4G5XwKZbzYVCtQEODyjkLDeeVBp0clCzUbOHiXycWsOfoGqO4Ci+batqcjuveplO/mbHGSuHoXZwa7vlp16JvfXo7/ObUPVGrZGLXdL/7sLatBD9uoDUGu1R3ucILw36YQlYroYT5BYjXyDnmvR76qnnTluJ267Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=Gjl8cAs6GwxqGjGY1fVOiYirK6PiM3uEnl7H8EEzjey5CTeijr5ovasU0Hn+N3mngDLCRQ+htaZL8c0iuAzQYIpH653G0Wb1F84BdqJRDkvBemNAhSIvRQXPXVHWZyQdMg9aZohgUZYkw9YlOrN6xHWhtJ6KYQ4jRHmCvd+rW20=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:56 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 24/25] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Wed, 28 Oct 2026 19:21:10 +0100
Message-ID: <20261028182111.160492-25-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 425bb149-b680-4081-469b-08df35205960
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jZMr+ITCOEW1S0SbdlrCq2A/25Lr7gj1+mqmnS2TLxzgF4lAJLf1bbdZq4xv4heAP+sG8ElTEeaKI6ifiwSUvmMlUyBad1M7hNa3CRUIj6uySPE9NLj6hLGOQKcyB5UOt1N7OtDkhvwVDJpTijihDNkzFFaSvDyRsI95jSIaoNVZfzDGB7YyR0y6VqI8qVejzUB6UMdN+rGJ/qOagnGesBF4tal/YvRhPhaZN0maQD//VGIMs9D5IeSQvpkdIwPFM09xWibfihop7XyMOaYDciN8P2HJazcbHcMLMnET65z1z8cFqnMlsl157zM/R79SDrsV+j7yLPANQvxXg+JbD6cTjBLwFgDhBEngJ2KCv5KCTcRnVLQV5bVRPOhOgVOJSN72EzH96BpsMyTbuU4Y1peJrKzchIJOi25CP2zOuldMcFejaR5H7baItcD8wUdNa07u0m4S0YSDv3a5xRoDvBhts34FzC4U2V5JNvYiwe86IHbKvRTeExlwC3r9R46rGUDwwXid3dV2gTYdKeHipULd66qmO8DJLZ1eOJMr5m8jfhSXWJU+4bgom+uhnNZCnaBG1fgONBDQu+1kg88HJzd4OxV1Bpnh5XjJPD9Gz421ULyeLyKl6dPqq57lYCrGNU/OXUuu4FSJ8YzB4d2Y6kODma3XF2zNC7JJb/CDR7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzZPDkDmW/BlAHiQqb+O0HggyYq16dc1jJqSG66sO0kLe2DXljIh4DgqUoT+?=
 =?us-ascii?Q?r35fwf6mCfDjW2UXR9NEUdQZCcJJ0rPmQroXAyRQ9U7i72/9TusRQMoYlrqV?=
 =?us-ascii?Q?fcECLZFN92UVp0i/SG10lw4KXsNHUIh2AajTUMn+sZouU1Kx26wV036SYWE2?=
 =?us-ascii?Q?VmyWifY7+zFIpdZ7ZFoMiJQE+HipL2LQD5NRjhv/lspIv7zHlgIS3QNnrQ+q?=
 =?us-ascii?Q?eWdiMMfyM+VEKsipAEzFgkxu8wVE4Cu/WDtuJzvsUCtnZLVE15iHdWT0cWoO?=
 =?us-ascii?Q?WuEskuh+rk3vZhj5T43GdDTofT34FnDsRSD6HdYauNtS2onUyAv4N+iY7LmU?=
 =?us-ascii?Q?0hW16HcppobLWfDsbbNazDrNW6YKEZlisJxcKO1ti7VIlYwJFEb64sP8vh1G?=
 =?us-ascii?Q?kOXQhTBjglLXqo2HloZFXATDmXWNgHVdMwivYZl/isVlpx3xPqDgMxTz5MoM?=
 =?us-ascii?Q?C71OvjCX4B/p+HpfoYFMDsKTyV156Q6GSAwYOfZ3P2AYPhZAWJDlIDwo63rX?=
 =?us-ascii?Q?4srlhUnLDn66qXjInodMP7T/ssZEeM+9dWOLbuS/oFZVXweHaeI9nHEoUw2n?=
 =?us-ascii?Q?r/qe5puG2R+ORg0nkiAPMOVPfpvhlRb0MZ/fNAbjViY9gUweGIsdA9xX221n?=
 =?us-ascii?Q?cYwya2NMwoNC+Qx3OtIaVT6O1NW0zqni0KrxaOGze0FCqqx5E27eIOudaDGA?=
 =?us-ascii?Q?0Bq+WUxkdxC0xCEEFWwXeFtfaoJuCSiZ11tQKV0POIiv7KGc7g9K8AvDJ9nz?=
 =?us-ascii?Q?eRFB9jk21t25YS7QsUAX5rfEy55gI3LrXcox06hzici/qki+OYzEdsOLct4z?=
 =?us-ascii?Q?IAYufL1AhgJnzNo0Hot4lvtZUAPhlRtAOwh14pgUZal+nel8WjFdj5qv7CI+?=
 =?us-ascii?Q?IhWVZ8lV7oa0Ns1QY+vmMuJl7ARwjhmwdwmeUhmUeNbVGoIB7nwTtLd+cSL+?=
 =?us-ascii?Q?xuGMaNmhOh/JoDtiUGhxr3QcIYUTb4CqAbkh9orMpsU21tpDO5mXEQhP3u/4?=
 =?us-ascii?Q?jj0QTP4Lefx45TjLBWSKlsN3M2ARR228gRDFcbDw/h1EmJGg57CVHeTYbhBx?=
 =?us-ascii?Q?HZ0FYoLrp4IS1w5qTDhFnCbSYfsHgJOm0q/K9JVO0lQwwoRxj616wJJpy68F?=
 =?us-ascii?Q?PDtVryFD3nJU1sTCAkmTHhX1HQcJ3YPmBv6MiXynDxFVS09BOVOnjNPHsS2+?=
 =?us-ascii?Q?BVP1eALfWpoPrNuzsYD95i1DRXuTHqPy6OTym8qjEXmfvl4HS9z8iQTuaJbV?=
 =?us-ascii?Q?5Qp+6uQ/ij9yyOo1o4UNFGOLYcTpLvlgRX+9ctjlw0lD92KBtNQuRuVIE5EI?=
 =?us-ascii?Q?tQ9Cyqi43xBCa3OJA3YoRlgyHXJ4PYWrG8j+IurpXZJq5x4t6uBEI1Jo49YJ?=
 =?us-ascii?Q?k+9UzOznEO13fnT4//PcV0PJpUIKdJUdcZ/IuyHaSQ6mxY+sljSdY8/l3qet?=
 =?us-ascii?Q?nI/RkPQtHYLYpnzvqr44l0OC0dgKx9Hrner/a5gBm43j+ZYndBZEXMdSg+Kt?=
 =?us-ascii?Q?twdSZVeotgeHlpckXx9g6rg06luCMVOm9mZ6Zh4uvfLyrjWdLYs55x552WkG?=
 =?us-ascii?Q?Vg0oxTIAeJUIv0XfewnGyEim9zrWvL87OKr+6xpBxE9Rh6b2aPI6fqBl5WTT?=
 =?us-ascii?Q?OjQ64huOUnP7X9aVVSeu5y9pY+TgcZeEWwKDEeigiqQOlROj4b1ouQPCKEir?=
 =?us-ascii?Q?6pFWFYcNkHNsPnwRSYYL7lyKXNMsjD59JQfrFSv2aFEbQHKaiJbrVeCVJ4kT?=
 =?us-ascii?Q?hiDgVCD+AknD/JoOyycEgNn5XD5KakB3pnuEAYxpYPHqhYM1eScaDbE2Mu8X?=
X-MS-Exchange-AntiSpam-MessageData-1: R0p0uhALhfk3+EzNqMNr/qf8a2YyHUH8wKI=
X-Exchange-RoutingPolicyChecked:
	LL2BrUoJGX8JY0MBc6/O1vqCWeTxNzktCeqwJ5TmdP1uNidRYp6hA6qXEDWbu7EjpAvQMGdGZvMWSHp9FLSqPECSRLzHNtV4iYgcHy/dPprv79/wfsunINKfKurm4jhTMkmJSE6aPa2qsD5UZ7YGixnmDkr0X0gr88DfkAPPoBB4zDFPeTfLXeUVdgmigKKbK4NWMagL/KUP/15D6KYPPolzKRsKDy+qq+gyCi2w2YfhHipL2BIpyEpHYuW5ZNvXEkGccRNZthpTTI2hUvFE1y1cotmwfHql9ytFxVhD90+8lg4dOmaUjxt+TYmYIz4EaOtJ43JVE7sYGcWpElJ8+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k1vgEzNoAFBTgYgj9WDVw//VZqFHRPwROuC1rshN4LXPcUvrkNya3daiat7c2QoGQYd64HzcczohkkYt0B27XCO3vQ/O5nKWsCVcIPY3QAmNk6d8vfvPbR6OXrvj9dF8O7vrfTQp4obEu7VfAW1mF7zz5Qat/x93yGFegCm2uETGotH61WkrYLKSA2Wuvb0Mm7I9NrnVSkf47V0HAQlzK6uzqD12XBKLCKmuVPs+XsM0ORugzHMs0NDIbbbKuv+qfyFA7csQtZ/SdARjKPxV4o7rMqQ/qaY/be+YmJgcpMms3VJ3Y1h0ZbUXNGKM42f09KHW1k6hjJJPbplPFvLFwxzKrvFgr3s8romgVWtI6AdSAX/x8H5ltFVoEnyzQjLWXiT+PjYk5JqfJAjcbYssKR2raeCHbLIt8HFqpYHFj7uFXxum6wsnBm2fJP6ytzf9PH6iez2CmmshOF95KjyDlJC5I6fJa6zcnuU/1O80Mfx9LlUaKYn/9QIdYLS4NcuONf5VkvdiU3+3vHrC7np91MtgY+lmFu0JWs4FnxbjWsds6f0mgWrMHlyfgctGb0CXBMFGpPc47HcOjYHDdAniDsu2N3ggbSvgU0kEEbAdbhkvBE+fZbhhLY41khdad0ud
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425bb149-b680-4081-469b-08df35205960
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:56.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lcZsZGdRfaGXDLD2y+g5K9uS7P7CZnGuw/mCdMKNRMMV8M8Zs/x6lUgqeR/o+/eOXuvPiwmS6x8SQdIqqIZSlHMrIB9aN/Y9yIZBvC3b8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0c8b8e392c84..16d4bd5c2d9d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1731,6 +1731,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1790,6 +1791,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.56.0

