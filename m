Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6164DD3B7
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979468; cv=fail; b=lOwViGJEmbhgoz9hmUYj7IKfLu5iD30bTcCrWOCL4td+u5bYwcIWcOK4edPdVa9hHHkKbbQ/NT+3NwZfsRNw7s4XcjZmwTaoDf9Ky3qiUd3r282trYwrcUtllmoj+1hVL2rGIHQMVvj8BlpTgpss8qzJl9omPIYATKpqdgEROpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979468; c=relaxed/simple;
	bh=eQ9ONb2u2KAEtLATIGRFtuekdQXksAUihmYcZtLsZ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YGSwXD/ZEjTerqruEVwH0cvtrQwUV73CTDqvifAFSa3IxiZYE+wpMil+mcj31NJX87QASQxo1AB0FcHHNTEeWaLVvC57hrWiqnXRNzDid/U+AKs2SyKk8HszY2FgngYwr2jMa4v9k7L6XNfD8duV0EowhT3Mrp3FRSi8KILAx+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eHJuY3BB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Mbx9L+1Q; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eHJuY3BB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Mbx9L+1Q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979467; x=1823515467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=eQ9ONb2u2KAEtLATIGRFtuekdQXksAUihmYcZtLsZ48=;
  b=eHJuY3BBjVn9jeaecol3gg8gSl1a+HRVrxCbBqZf9SWmbFLc6nPWjo0F
   jk+HJ2ZjtAFQdhpuKVzwVfTXsb6KaK4mUcDkuFsEXxtzvrZv7OmxqZuxe
   Nx793gefXvu/x8HvNEV/mQBvSK6oymS0W8ag7U5YordRfSbWRTK6Fd+8a
   AtNkpAa7UZItpy5JuGzGgPmF7siTBDZN9ey/tFo04g9bXZ+LGUzinPZni
   EaoDPxIj1RTb7wdPaaSrzXx1CHvl1wHK2cMzMZA40/jlbP4RPZQywEFYh
   6cUza5/cEt3ASMIaZxyjgxcjS6T0jnIyYldxOgy+xKk45Breh79bj1bOe
   w==;
X-CSE-ConnectionGUID: 2QJogpNdQOKNkHydJe407g==
X-CSE-MsgGUID: zf0OXE5bSFac00Jf5uwRiw==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077287"
Received: from mail-northcentralusazon11013004.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnlNp+yTUOdIHL8l6k2xsdGWerIoIvj4B3vHccJnXwEU8l7BDdt6Znv+TQAHk7Y/Qct/dLr1Rx6JaMkbFIUOcQ9lmzXHPSA9GNxYwwp24k8GGT8Wt3W/Bu7IhAUfblkKyqhs170rIJ+nE3TrrqydCQWQf+ttQ+GQLWso4Z4Olol3Hbyfgy7FNNSOR5XAN0kqCPVgsjipbiVMsXIOPNr/yUu5bq4YJn/n6D1pdLtmzJ7BFZf+KDv5e0icaDdM0aTilG7A63d3H4J94QqDiL5OaZKUlAkUYchd09Yd1OyKx6jleAD95RA35AX7uN0zjaAZxUpbVtHYPdAb/R+fdaBYXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwbrmX1PHhY7iWHQcORFukgua4zXanGJOeIjEL6699A=;
 b=Vh65CBiZ9PYoNkNDU6NlLkQGqgZ8ZCvg1MeyZGPBy4GZ5nsR5tYZl7xtHh6B9S4Ok3FIMCJE4Hqg4lJmL/2v+n3dmvHMwRzcj1JIVlXr7V7RTdu9sS4u3sBDeP1RGzS0RYsrNUCwyhA/Ur7KpQNOtTEm5lf8vGtAdnxWhwrj0fAiSR70de9T6X/aUQVxKdlA47V4D6vfQooteLn1Its6uvOs7gg+113e2dl/MRhRUnC0E4/vFfxtfezmPySS3Q7AFclOgjWMnWnr9lLice9ZdkEdqRAJADiyuQD7WMcoqrkL4Fk6kPAfQx7NgJ1IE/0vQ9YAT6rfhqrrHuD5vE3cUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwbrmX1PHhY7iWHQcORFukgua4zXanGJOeIjEL6699A=;
 b=Mbx9L+1QE4MwbZKxgEIvSn/pe7HgK0yJV2MzQUEpL8z5hV+VWc691MxQPPD74akuTgDEfg78xUGQlTlMwaBFDNoOlFbg5uSRi89LZHnUMyZzM1Jjt8wThxGakER/qp8tCGuidRF7O80K6cpdMFuouauqzsbeybGj8ARfgg+1Pvw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 11/13] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Wed, 14 Oct 2026 14:03:50 +0200
Message-ID: <20261014120353.757931-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d932cd-83de-41e0-b986-08df29eb4a1e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	NAvJGaD+iTlLidKlirXhs47+REdy7wos4Lmu1ZYbEAecIl+RowG4x5Aw65ZpZC5Fd8zW3N44/VyCVUwQYWRtVIv5B3aSTbslwfp0xpwUPLx10QTmxourNDpxggt61CCymb9X+qXG1M9yBbfM1W4C2bpNznpYHzv5nEVzZhQxGQRwVi0jkt/HWJYMuLW0mccWrlI9z0GejKsdWLLAd5obiQ51Y7/YVl3GLpvXk3puCs3x0mdP6QvHp8X0G3iBkMOUY9Gh1NxA7e8A1Yr91Ls2ZNIB60WQAbgo9DTPT87VmGvN8tJNZyawmlDVbqzz51kojbvGDHQVA1c5UDwgWkIwuOojmHW1TY53Bb2XDsddSu5/pTrZ+O/ORhbCZp9NQKHRF6BJtddNXBuWF0aLN8w5PmsjucOgAyGg1+jmgTD/5oqwd1j3V9W6nkln1KF8i4ayGwMgCzgf3bZS0dnISR/ZBsIDCqOHOTahYPWV6G7nbCOZ9Grg2Bz4buk44Ff/OtziGQsqkUgyTsw52PwLr+Iw6C8LLvUwE5pNjBunajhOnj0XI5KKsoLGOXcwNU2yiDcz+I+20kCXxq43baYyXKGLv5AHq2lSgJiOFLL6n3gYeLiSZGP3tHgxMTG8Hr+/WGt4nPp28XLRGg7mZKn4cRPZ+GSY493Q8PQUSfNwdiKzXQE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qw5a+FazN5y+Ok9ztg4CRc2JMw/E+GAvNfKQLl+mjs06J7ktkmIcmkuzDl30?=
 =?us-ascii?Q?G1yKajUVh3TBCkBw7a5jsRRvjyYUyIC0JkBY+ueVKkgmlcRw4QlgLJpFmbIB?=
 =?us-ascii?Q?afpPJCpQfFOOa3/K7ucCkbY61MLAKU21fj5JYlbMLIELcCvSa7ntItNpWhXv?=
 =?us-ascii?Q?MlJoCiPI/zESmxjqdNjKFRAIbIXLqve6xuMhUVrsqUzGh08+r40neX+aIkYx?=
 =?us-ascii?Q?7rSD6deOH2KNsysOG0mws8X3m1WvHk7OGq27XfhUJupbPdPG8s05I5Q1L4XR?=
 =?us-ascii?Q?hASM3n1hLxTj72mEMh90AkI6CUxmaxAkhDetoEiPWlDx/aRdVCYn/fvd+FTT?=
 =?us-ascii?Q?26F25hTMJzdrPHp5td8jWvZUTwQt7ArqFIVI1E6vVeiLWLsS9C1nFlqvT5J5?=
 =?us-ascii?Q?a0IP3ZNy5XbD5Qs1cnZUV4/Yr7z1X79mKZJU5nYJEiG6+rtJKf0nk5x48IFC?=
 =?us-ascii?Q?ujk78PFd/FmZqLL06zHNiGDvscu8uIcSrPOjRPMTjjlprxNPskg/NloqJPOm?=
 =?us-ascii?Q?hNrhBVP98lZd5Xf2mFGRXltz/GPctXu4+w54BzNTNHdpxXkjGFeNrFHjmPwr?=
 =?us-ascii?Q?u1pvRUHUYP0i2aj4XwyGg20gisdVXglGzP/jthHFHJBCQgWPSGyFkqSCgA64?=
 =?us-ascii?Q?5CfV4icboT5Pu+7mn//U8saacysrocDH+vtO13jZ37Vq6OVmqUPzllcDzBo8?=
 =?us-ascii?Q?FjifNdpRZmJ+yFiJ4t5+ldRoNTck6y5xxy4VLdymvl4gc4diMaJ9ZV3cd0u2?=
 =?us-ascii?Q?QjCBeAgYviIeKwDTnA4c++WneQQRHsdnHPaRwNgH3vaeSsgCCHAamg1B0xsd?=
 =?us-ascii?Q?m5fVOFMQ4DPRhvKxknr/CQikzmDEIljfET/ghjwariI750NGDxYo1zOPGjcu?=
 =?us-ascii?Q?EM8RMLY7DXKAIKFfq616JZX/2NMVL+4oJmKF7zgeCQ47/GLtR68J1WectqZw?=
 =?us-ascii?Q?xHdvVGMqKeflFCmIMU1kfY+Um99X3S5o37uKwFzSwQouDvOOZGuAxoLit3AG?=
 =?us-ascii?Q?cq3l0+heCqmudjckld3QujuIayLvHwCGyVpuNitsq08ruTRmeAzkff8/VmVC?=
 =?us-ascii?Q?XsQuCHQqYoLccBqOUk5v/tByLFYNPV+YqO+9Khco3m41uKZPFbb8qhzh4PhM?=
 =?us-ascii?Q?F0zoTpz3zDpwAFjzIui0S61Axfss8tQ2eiD3RpUwrNChD92qykg3CkEXu6rB?=
 =?us-ascii?Q?5amksZdHvjg7IVBb8OU8AJunT4hJ8uhU6V4oW4tsze9LdxLLG8vOAiQJBv3l?=
 =?us-ascii?Q?BpL7QuLPizMnAWPN+7B+n+sBilpDOiive8obTir72xDN2nEBc1P7Wz+DaB7e?=
 =?us-ascii?Q?TjWdn9RgcWfeohvdw8pioYsvP894/CUzul2/rFHifmWBPb9gpeiADtHfPicy?=
 =?us-ascii?Q?h4oEC3u7aJ16QL716kOR6KeBqQvNwMxQwUbCQadbaYlaXPadgyL/NwAYgcwI?=
 =?us-ascii?Q?c57i29209YAph1GQM1aiyeLc6RQkJr2oNX3uSyyiXBdRDMfbBLYNvFQL/UVJ?=
 =?us-ascii?Q?iCAqD/eWNEaIV2gTourN08QsFRNSKvg4Fw5WqDVDMdoCvchHIGCUnFu1VI2i?=
 =?us-ascii?Q?DbKQPbfTRhLDMghnpOl33AEmXkbW7qQ8ZkGdkYgyhFU7QF5Q64SeoToi+TGk?=
 =?us-ascii?Q?Q8utGMqbQpHcE/IXF/oigUqAtbUAFPPzYb9U/+alnMgQ3IRWdOGNo0Xa0nx0?=
 =?us-ascii?Q?TjCD1BeUJMOCpQGZLFSVs6QLzsKndou0VCeYaq0uJt/4W3YgY7pH/PmyeMFB?=
 =?us-ascii?Q?uPVKeDC3OtstADEcdtRWfe3AeEc7lIkkAPWUXKuGLRztwyEWOGs/gmKQGmHj?=
X-MS-Exchange-AntiSpam-MessageData-1: cSsdCTbobQXEbM00fz+veaxjLxRt+tS4jhk=
X-Exchange-RoutingPolicyChecked:
	gOoVqTuOPagBZXGX5O4lRuFe6+E5Su8FuD2zjIfC9EZZD+gKl4SWr1kMEX1VjtbB5sU126Bip3tDaweLlgiMFi8u/ZFMYwwPFkKpiBfUjqYBzboLavLSZawi8mlfZlEdM7QfuGEQvunHXlGSKBYlku7LCYgZglbJ2Toylnj+4G7yDvvLOEmzMiPYAZSrzO7g+Xzl13rY/P3n7dkkR/AROAjElQLmOXwzCCiuHbp6YXP4bMCs+OE17pkaG3WXjjPaHtNvmr68rmF6l0dDQIecvOdH8fLdcge49zwNeHwXdGjviH6IivH3rZJlu2M2Rg7/RKQ/Y0zX/1QH3Xn2gRzmug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fymWK9wlo2mpNyhn1UvyFHWZlbJJmT9pmHLa/ksjuDOg4gQB1Kuc5yZhoq72b0lreJrnMo/p7AIopj8sLmkPU2ESW/Oc2l87nEtLUOluyBTHsFmnCxvtZa7vCkoRX0FCnoTVjDss0P5RVu+VXECwkCChpyN51CtwFZLI8/y/FrvBZdncoObQeVrlLyQDS4lC/qdvkStLISXQax1YB8EfkxrobjvMf5uRYIetZwm0m6C1eX8wPU+vX2e79N9M/HuXHGqkJ3Oxm3QW6uIaPC4YOZO+iuyPzDPM5aIK+ued0h3rZ7rIbtP+LwhF9yJDyfX/kH7QWQNwaTTW0IL/5u7GSTlNXnTwpT1efg5LgxvLVZ9knOW4+7jQEtAjHXpMq74HF486L9niUmkn98Mt4q1Lc9Nb9wNft4gOTqhsBwQHQBEZBV/+TnL5yKJb/cRmwo1ZbLZVr/KseZyC//Q2w4Oeiy7HAv5nPu/JXCgQXJZac5NAtZgXQQpOr9hZXTaIaG8oO/IjYQT+ERatmmD21T+8JGQgTJCoWXWFFk/XEIoMXVHVeOsh3clSl06jFxmjJk7vbQ3Ggpr+JKGYGiuGWvZJLTddELT7t/UGO8p9HIx07uizdG6cOnB8YfmAtRD2CEYy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d932cd-83de-41e0-b986-08df29eb4a1e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:24.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJ4mbuEsoyp2SkDGt5xK6/laW5MYxEsYxdGJBTQbl3NptM0PrvTLCpL6oDFN1ro+C3RVM2Ma4i6H+bre9W5IVPWtQDDI6aDYX3cgMi69giw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ede22d2eeaf7..acd91bc07f44 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4503,7 +4503,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 181e96f9f0e9..9e857af69e76 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3621,3 +3621,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const u64 chunk_bytes = fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, flags);
+	struct btrfs_device *device;
+	u64 avail = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = btrfs_device_get_bytes_used(device);
+		if (total > used)
+			avail += btrfs_zoned_dev_avail_bytes(device, total - used);
+	}
+
+	return avail >= 2 * chunk_bytes;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index fb87f0ad32e4..022f78b6991e 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -335,6 +336,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.55.0

