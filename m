Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031008;
	b=FuuH7vZY5bd8dKbYStPP49RCYzXF3iOwZ0/osngHAAZB5E4CuzFfUXzUt2xN0/RNr6zo
	 k4mMPvZXERyNXy7LXCND1QXwik5O3bX8e+abx7T/XbB9F77Z9HH4734qosmxm9U8Li6qf
	 aqkyBvG6P5xygtl+GeXmb1RJoA9zY4CF50Vz+BVQuI0wmCTCFmBftOyxo9bnemeAtKGxo
	 ZwTmnFoznJJnip966OI5VjZOM3Q2fU0kp0mzqXoEG8LpKJRCyKPFGavqGMmnSdeamIpUn
	 DaLn93/R/f+teAIT8IMQAmkMYr0TaMm6Ts2PqpSJWSoP6kMYF7pcrGD5Tz8FX+yYTTA==
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
	bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
	b=unyDk3tgnTNvIVUbyrNThOqmdpxUzgP/uwoDDXRgls4b73BBUb2x/CyouQ3YZ09YELyB
	 Inp5WA28zKlrkPTn+AQbIu4T/3IQme13N/HZNEIp2YCkJbxd4WQQDlXgDe3JmOgHImEm6
	 xyqREORbzckftCjgBip66jjPGtsfOpoROYAJlH0ew1zuUQfnqwclGyKh152Xcm+zBRJpi
	 TWtkAe0Nn1w7moDIqxa/HHKxyjf4V4HwQYiDe6+9X3avMdgeOrY2A1f4Af1D8GV78f/8J
	 fYGgY7CUry176xvJL6LQYuUAz/kzo2ELVPFjW1Y5EFzqNenHah6Slbh2g9TFudrPmXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cgUzRt1+;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=dauKxja0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EC4606A33E
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45EC4606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cgUzRt1+;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=dauKxja0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031008; x=1824567008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=a0YEd4SKYZthD1yNhxElOX0DmWsNADaD+vKd3MNZKvY=;
  b=cgUzRt1+2PTAqvUYYWiKPD//rLwHo4DH4GRS/KUsDbZpmAIp2M01zDF6
   smqO+NhD02/lZTX1HrUiljXXUo+KuIMEkVFjMTjxAp2Ckek4SiM7np9ea
   iPinefaMg+gICZPUlsD2CrgtHCTixWnekORNKc8pQOthB+7s3+2Pbjw1z
   FQ7uRDjbrKkZmWQwRbWYq07GYT1m+JN9qx4kt9eUu3otCiDjtIEo3DIqS
   PDvBiQcKyS6RrYge5LCUTuuTGcmO8gW/yP36D1V114hUp6j5Yz96b9a8P
   rMeBkHUPZXAqqAxPWOccCSibmid4BG69GbXXSQFadHjn/GQ8sDN4KJsDm
   Q==;
X-CSE-ConnectionGUID: 7yGrW+AaRJeUWcX/VLVUNw==
X-CSE-MsgGUID: lg1PHzw1R+O70jXP2hMEBg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033905"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DO6lbfWVEdA8fHIaZ3qeUAjRaiXsmTLAmowwxnXisCOhVMkwy9ypf1KFeQ6CUoqb6JcAYK7j1c+/1HmO+4Gs9f+DVDgQWRP+6Y+qbb6ePBPAaAwrOVygTY1YMtpxaVvMzQ62yOQccTpil+nn7/Gx+4NfHziuWfA3/nCHPiFTWQStIqaAaP+N5UxiCSwDhB8IlvrGh+E3MlDVTTWU4JCqAGjKLDd4STbVe/Z43BNl5HsWWT6kc+tHP5fq/bfkbrIwUkFk8PEgks6RPcvLn+z2Pkplp1rrTDetcIbbdtfUfm1yjTozE6p6KZBmxn2+hpd3S3WY9q8MclfQoULk/B/aMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
 b=xTxlkPCIK4tP6OVoTJ6XEvNcYf9xE7+A0yKXDeKQ1l/rmG1NQWpgSjPBFEhTYHakXOgyer69VD8vyzui6mWx27XRyHKNhvzcQ7cGZjYResj9EM+D042fms6cU33aKxIPdUleyqc0+NdH6PG3E0YX3g07OUBbjU49zoweNBwxpq9EzHRi3ErmqCIskO0q+aAQRAj0xmSKtGm0YOepuFbi7e54CAAi+D0M4aANTBxu31y5iKgHgH8h61oGQjPWYN/stvmMk2O3N+fHqFhiusnz2FyStQ3Q41l/Zd2dudZCoWzuVq2lXfy3YFJ74hxdQ2zje99LGaCMZ6EFdXaRsg/jOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE6hskYX00fE+5qBm5/4BEsshXyrNJRddMgcxP91c9w=;
 b=dauKxja0CDwhDaXDB/myKLmKqh1biug+f93ZhNMakfvweaHVdPMQ/t6e9mE5gLP7YAr3COnqR+NVHSQXKZZJN8GiEjkXL5fmGOsrpEWjhp2xaIWUWbn1gWZBKl0zTNzMReY4eSOa9wTB3HHXRGcxG1Fs1WkHzacsgGrmkBxF4no=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:47 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:47 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 13/25] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Mon, 26 Oct 2026 17:09:01 +0100
Message-ID: <20261026160913.207909-14-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: d22c0024-25dd-4589-a467-08df337b8e06
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AMEX/2tLEFP8WXoTrvtT2XHtxkQdCjY8SUCGymAD5xLbApOnrGktnxkFepL4bgakR7UMLho8xF1naIa+VcqwhicHE3P+nwSowDg2Sd4Tq6jWndMAVKDfUkwVnmejDatA08MfKaHsOm9y/ERpyEoZ+L1yULNV2iZaM3sQCjkqwjbO8qWHBND8QTBE8gPRg5JFldpPnsQ8y4lRsM8EWQUdOGWNZcWCderu/lPhBVP3J2TMeuxEXa1fQYqHCS3U2uAfmMJ0XKNRvWhzWX7msmQFbMhiLAPdiYczl9eBuCzp2rv9d9zxH0mfDkCBba8W83u4qlUbq/d12+c/gGNm8YHyLkeEb0o0TF4UAP9FGnO3Ln2Yf5olMwT/l9haMtUGZIYSWo99yq9n0ch+JT2tQ4ZMwLD2jH5UTWUhKS05JmazrTXsc+akMUCSRYtFHH/rXWFJeDCZ2Yz77khafT4Xou35s+0yKhb8YJhtrI5JxaUJqYFzpWSxYTfXWo+Bw6J53mG322RAp9cZkT5uEmF4PDhEORr+IgEYKXLH/ZscUzOfKtuvCIU4ejyggjLs2tqUIHMSowbBRTfv4d/Th34nS88TOKpnK3NVSnQZ+iavcAd1rvpeLbMoGNee723cTLoI0FKMTYRz43eLU87CGqQgiSTnDUhIwRAxncMr9QZYDE3LBE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+mIJ9ivUDESKw2pfNo448L8Fhg7i5W/m6adhkWLjixOrMUjBjmWLmMKtNN9U?=
 =?us-ascii?Q?bpFYrhoGtzNIasWau2wAYPiegyk25l3OGWhYB6CDhjEI0R7tP2aYdmp8yfRt?=
 =?us-ascii?Q?VDv/GP7WqvLXLu/tEICC8/tkUup2OkLdZj45HlXxy4iYeeUtb7AeBwDydvdm?=
 =?us-ascii?Q?+2qNFkKTdV/nbO9fKvEwSWPZM8f5e9VkyMeMr1hEzmEWshnTc0g2deNS+Q/+?=
 =?us-ascii?Q?mZnf0VRKapp1psR5aptfq/+g1HOHRol1WCRY7YcNEvrBaj2hloFYyPKT45Az?=
 =?us-ascii?Q?WyRMHFalre2nMyk9JwT7KBAZdcscQz0cVDurECzqYNqdp91XUOe68GoGQ3BF?=
 =?us-ascii?Q?V/n6ds/vOgmyt6LP2HbUrBr59b5fsQ7ckpuVyKbHAtStwi0/3qZunYeEVpGu?=
 =?us-ascii?Q?Am0lI/YpqHDUjCQ1Tm2Oe1zH0iZXIma/KfuRBajlgjZcLvBEXjAQhazLP6ik?=
 =?us-ascii?Q?n51B/PeFS+XCnk64BDzdzyLseS+Uo69w6hnOn7OUa64PcFSM+wCO4G86Eqhi?=
 =?us-ascii?Q?7MIhEJVuJg33SS8Wh0eFpiQiVVOIc396rz5+ARKFeC6AlbeZYP+dXngpJr1L?=
 =?us-ascii?Q?atQxhLxynOmnBa6yGs246lzL27q9qFYADaaWSvWtBOfT7gvt3zUyaV4ekOAg?=
 =?us-ascii?Q?DCcLgi5eILL8C7f2qH+E37LUcJm2OAeAZYgafYPbpo4nAA/a1ij3lTPU4mMG?=
 =?us-ascii?Q?o3YK52X5NZtHlO5Q0B2dlgFqHQ+UEp3vVZVV59GvJYWPZli2n0xDIMC/vAAH?=
 =?us-ascii?Q?VzTqRM3OYZA8VzhYjwDcxmBO9Ev0WXzGLVfm+zOnJGDW6Voj6mNIiuf3UIMp?=
 =?us-ascii?Q?h5N80QfrtTYXawYJmsfnimNwJtyG8F3aqSUca07dztUQFqYua1Ow5VTHkvo7?=
 =?us-ascii?Q?eEuwC32F0kzXHn9RzroTLdWn6ljBPqDKRQ+M7MDxe6iMmBoxBaIu0DzZHA3H?=
 =?us-ascii?Q?5M69VUYbcO82RgsvXDHKCnpSVPOxmCblsg2sKqwOxzXMtDy3bGXZfbm7aoSR?=
 =?us-ascii?Q?Pea5EQ71IB0/BNExMny7uIJCmmC9GzlEypGrGCXVWNLeiuHSvptU1YJ87Ji9?=
 =?us-ascii?Q?htszNpPJ+Ej3TWQGyD7FfMr3iD6/2UaoHTgVJT+MurUk1PGLghWHElXgif1b?=
 =?us-ascii?Q?61xGq054HIqmkSDtqxery++HEFrv//HDza2/Zn51AQT5lHFaQq5bmlkL/Zb8?=
 =?us-ascii?Q?WYr3E0g2P3Kmbv4iVwR1yKWUD8hqjuDT3Ikd3qecPo6v3jiCA6c0gB6TifVe?=
 =?us-ascii?Q?Qh8vtKhG8q7rEsR3M5X40Yb72ural94k9Qr81MfAfJ1A+Ge0R3KCZbSjrOi8?=
 =?us-ascii?Q?r+Eye+kpWcSewq0LC877mLwx2cR0u5ObsX6CEcFUssuMNmYrZYuSx9Q25bsU?=
 =?us-ascii?Q?smdYA3peFE9biTXxqJ1JQigoP0oc28MDRQR4jAUgyqIwoJTVIhlZsZ423Hd4?=
 =?us-ascii?Q?Tg1ty3UrMntcBOXvSAKDofXI0j1Qe1uRnZs88bSZpuGZ2KjPWfkiOVBm2yDr?=
 =?us-ascii?Q?OZANDlo8qNorEUfJAtek0JxP0WRArqBrr4DXwuwjGJaHo6fGw0Ota3hzUCWk?=
 =?us-ascii?Q?edGAzUGU7yL/0pxqwwcKQezhAzH8Dv9MrjwaNrJhoCRsreQ2qwKVC2l9wQoR?=
 =?us-ascii?Q?ZzqW6bN+VFr8Csr+8k/KBJy3ZQAWYDabkY8e/voKII4jYeWdMMpLBWi4gzLn?=
 =?us-ascii?Q?02zDuVNAsRPxWzZj2DNEh2enaWp5pEzBAlbipTW+XpIk0PYIZ2vn/Zxg3sTs?=
 =?us-ascii?Q?awrlWX+a2grEhyBQ5shjbkv9yfMFGUuNdAXsusY2XTfVtHjEdPkS96046cxo?=
X-MS-Exchange-AntiSpam-MessageData-1: F2W9e6rQkP2rjw==
X-Exchange-RoutingPolicyChecked:
	cIb761LfJ6ZQUsqYt5eE716dDUcVut+BOG0IopmRSKtws8FToV15T+x39iFIjlH6YNGh4BKz2bIzjdJKVkRgsvKB1e1ZOsVQesaoO8F36Uh4/CZwFyXY87/RNa00LOU/sGpd+VqpFyNgJYq/xZZXxQhel9XaLBRxh2HCqFs/gSMUW3NJSu8/BilIMWYyKq0lO9DJcyJndwfcq0SlIkHcTvjO/JrKrsLzp0nVkLcFXcJxmdI6HTO/uZrurXkLscvFvV9d2a2d6kmVcQw5RYnzqb6BRBB2TbAasulR0KHRAGf3YR2gj7wVE5yy3GUvlzwteEwX+CNB0GDv88hnpU7XmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l6ZIsr9pU01XeI4Dn01AUqTQbz0TSDM+dhTajKSkbH6e4QcSI6IjEsx+eOldTYjqoAshnKeIQ6Z2m5pkrMUScrunenj7xDdA5bYJwUfnuAfuEEOcsh+vB4isoRTbxvr9F/uUS44J6ucZdph6taWhuZYud0Qz0CLF8CDLOSjlzScfoMK6aXqdnlTMqD396+/VqMeIQMEdTBmRnNyVeCSjcjedWJVYaRLq+T2EApLnmXx8ZnH6fSdi/twbo86D26CuuDvBDxuQR6mI5XlG00PoCiP/BXXVqJzs3yMKCxKB63z6lW6+f2onITyjEQsAqHh3xkRX6Os7i00yFQuq5xTuQZPJV14SYH2CeYKRNsAE7WhaTZUs8ernhXZeffMF1HuQjRlG+m2ZXlustd1xUnNcsSSK+RjSRIQP4XJros+2HuAi71yoyUa+wcPa2gXtHL7DFXaTSPugDvvRZaYOejTQn/fGXP3Vag7Ckn0sk8Nn6gzpxGnG7RbsJc1Lf5DJYFFXbiNB+b00aRPBs8VGZpgLuZvJMDbPxisj4oSNuABJfvwQ7yKJSTmelJ/YWPz6ag8koinah4AAeR/AkBTaiBdBi6oXIDsDNtbA4WjjxYkl2yYWspnEvmXRISZVxW0BhEuV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22c0024-25dd-4589-a467-08df337b8e06
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:46.9632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ts3jc7lBh6DgclGrHzqiDvgVabvVFDIQx3qu0RcNM1Ux1UXCbMGPjFiCmvqKcCYQ/lbkkVssvibzeqPB9ftDZ68Y5YP9IvletCkqiMkBlog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 82d4ac418a2d..77a133ea6d5a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -916,6 +916,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.0

