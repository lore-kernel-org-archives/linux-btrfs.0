Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35331B828
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690566; cv=fail; b=KKTRQ3EDn1Bu6UghcQTFy3E8EN+tElxu3UDMZu7JZS4QjcM1dkkA4QnBlQ++VOd1bcBS2eMKBfVARe7HkRwrvQlsTB0BRXnBKlEV+MxZSqupoBu8hBgeg7mZONoM6ovoyDBGQBh/MoOP6AUURQC+9vg3Ca0gtFIOhk/Xp6kQgGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690566; c=relaxed/simple;
	bh=SYVjY2SaEbpMBcnVo2xgmHYVdEk4uu2qP8aj+7ELDqM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gLoCsB+yV+IceW+IVAMyBrwmApd+ZackDGDGNSFhWgnJhGn6vDeQ2c1yEwTJkoZcLU7z/kmjI81mHYS8jzOwPk9SJBiRCwLYMBL2aRCt+eapK5JBHDfi+VTjDy0I3DmB8FmnzgWOVuBlg8GuxDC6sPWySU0b40sd9liJeKEd3r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MEevZRLc; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=H6k2cG6+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MEevZRLc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H6k2cG6+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790690564; x=1822226564;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=SYVjY2SaEbpMBcnVo2xgmHYVdEk4uu2qP8aj+7ELDqM=;
  b=MEevZRLc18euSnEnEYxQH9wncgM2pkqCSyIuqeap1fjzFuQw4DfWyMJe
   rM9b4ACPvCnD521HKtsXnbcpP0um9X05hGQzK20pWqCovoVVT5Kozd4ze
   qZag1WdiXdqiaTnzMJzV2PzltWOj7iKUU5ndmxpQ3Jle6ZSGFnIOl0uuz
   De13UHFfn7Fc2gKOBNdhvn1cshZSkDrG6Pl77f8nLE0JqWhM0W5P5x0E9
   pXKr9qZRT5b79ZT9wd2O3ru8a3BM3W+KDWQIdqtbYsTF1wYBKp+EHlJjZ
   hznyggCBoEUOAKcoBglNtlJ33Oo87oIgnJi2ixTaoOZ5NHUXS4Sh0wskg
   Q==;
X-CSE-ConnectionGUID: fZGcluG3QySSLh3Ii/eEpg==
X-CSE-MsgGUID: bpLyvPkKTSKhN5gbZf9AuA==
X-IronPort-AV: E=Sophos;i="6.27,130,1786982400"; 
   d="scan'208";a="156697208"
Received: from mail-westus3azon11012064.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Sep 2026 22:02:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6p7oZrEzAM8KFmCTnHxQ7vfr+oDUjUC+udzUCWnCeE+I2YVZXggUM3EakyvKCyd6aCOXacujvjojmLyTC39QFTm0OEV+eUoHFJ+5S+WOuduAGasZxCQm8g2M++1B1t/xPFwJHULI01tCkVEr4myhUYnvj1mrTUBTzMpQ8+rAsERd309i/Iw9OqHskuxzl1OMATVZT9/UbWmU13miPauUUrJfk2oF9+FbPJ6eVEIVlYjQndJcu2EPJv969IGV9S0PbIPVsRgsLSb4qAMDzEAzAPZsVw3OWe9WHcyN/zRgKU9RM1c5zzWjTCG64HWndIBDyr9TrdpO0PW9jS4RrzQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbbC83ZR0vQidvm2hY6eNO/DFUH7yUkln6iCzjoCKeo=;
 b=XXeH7PRUBmZZefyncZSANGSR8F6jhxv5QeakPR+2bbtkY5/lFWcFyvDSL1rqmzmMbKB6iOrGJI7SvvaEpDWr9U4HJwelc4OpwqI5cBnUmfD03OyTNdHxKnXJr+fyk2A+i9jTARNW6z6ZFZ2eRZ/SpZYB7PZaEfy0saJF958oYmM0R1EESM8UD1NTJADIoMTKgUsL4EEUzALkwNe9ulv6dSohiJtjr8FH2OKhRiFZU3s6mK24sK1k3VUNem9Ul/JXBEmrAHSktIjkROOjC3imt5Utg2KwwamzPlWNc1a+v/tbnlIxZhONLSIkNySJOcRfH94iMMSnhvlcHB2K6tzHuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbbC83ZR0vQidvm2hY6eNO/DFUH7yUkln6iCzjoCKeo=;
 b=H6k2cG6+gMJ1BxLpG4CbPbvlRPQow3IJbPE9NZ3iSUDaWn8IEjpUNU/KcqqXY7XxaAEqriZVSvO96ErpRdmweK0oEQerVf6BUr5rhtbo5fDjz0b+VWzHFFwzQbxsenCEUNC2EM0LCjbfInUbz0BBczMUewrglsjjAZX3WVlMuLw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB7002.namprd04.prod.outlook.com (2603:10b6:5:241::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 29 Sep
 2026 14:02:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 14:02:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Tue, 29 Sep 2026 16:02:19 +0200
Message-ID: <20260929140219.3412519-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: d2edd15b-bb7f-4b8a-ac6c-08df1e325059
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|366016|1800799024|19092799006|376014|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	V/V556Gk5eH4jpoeesmQJU2/A2NGqIfm36Rk56rZZ+WVEFcUx2f0Gg+/Sh+AV/QlXiwu6+uojeD3QqO/JStxwtC3F/3h8bR5B+oFOyxCzJ7yDCxjlqWx+6KpKG0cz8wegH5BV/HR1OTpJBQGZEQlliadWMy/ExoCe8v0AYSHqg+SLwz5ghcvSFOFX8zjHXxudmCthO75Wsa+33RL77wjUs1Lem/w1OnlxumGD/vHKAMEHrwanqOEzElxSTt3ZyEv/4uqqsHFJ8kuI6+lGDC+TdY+cE7fGIXJ8nA89vlw5MLU97UIywRMk2xzVYzb4PEKiFZQwW/FbFJMleKwS69xLXFMMOk2pibY7CPsWxHDWdmqkU9aWFsXz1D69iiB2DsW95TPdpoWncAjGYXcqZVXcqWCqD97TepiV3I96sHwPaEDgoSTuRafs3P7arf1E6JHXRVgnMoL2HjDWZqQaFh0vBkzE9hZBLMDaOVJI6jl0dZGJpmyeVCheDyIZzCTLz+mxbWvqX6QoqAHWmpDnzD+UZNJ9KXVgJJzCunz+1/XAqnCgU45iu+y/EIiK9JdOTNhZamxgiOp36TihnTdyQLyfAzETEM1yx76gVDLy56a6vj0Ca18xEMY7x1cYgl1jm2yxc7uD7j2bI2+fwMth9H0mLm8PH7zhfx8/OFTNuH81V4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(1800799024)(19092799006)(376014)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hddzQBdga+8RoGdHf3tnstiYJamhD3AVLDG+5Jz8mBWv2WJeANSyXtSYSIHJ?=
 =?us-ascii?Q?b4WlcS4IVzVFdhDQnkEUBBaFWxlX9dpD/WnB5A1I7s6oXhdAsoeSISwLvqO0?=
 =?us-ascii?Q?sxDGMiKr4Mbp69IvlXZ/ugMPhoK9sGIAZuj1Q1W0cYuPJLJm18qBayNvDnaS?=
 =?us-ascii?Q?ZX8GoBrMqu19n9pBmqX8ka4nSlql+FCUSBxy3fSqcdMwYML+cUpUydipUtl4?=
 =?us-ascii?Q?2jujnvW7S8NoJcHxFyyR4Kiqw59B+jY1YkR1t0kKgOD6QsIHRo4P/s1BoL7D?=
 =?us-ascii?Q?p/LAlqASEs0vovBhfPfP9+5TcaIPCnVC27Z886ivwNqMGmEwmEC6Z498qPOV?=
 =?us-ascii?Q?ssRoFsegF9SJ+UcI1yIF+ivd8F5KLbA7oUE+WTkZwWW0IzZ+sGhEfWt3mkG9?=
 =?us-ascii?Q?nbz30doQotu/ibSfW93YKzYZILQqRjOuPtdjcRSoCNq1/v8FTQKsICsbgl2m?=
 =?us-ascii?Q?JZqkKDoAbTNZTqBC37JNT2lu3sDH3+JBHhH7Xd80ptfoaHZsK96X9vIaA+wk?=
 =?us-ascii?Q?PpO75j4zWCnLNDzXjckFVq1BZFgTPfnBosDvLMIrDf26RuHG0q32HZZSTZ1O?=
 =?us-ascii?Q?Wp1891Zj0zsCGjL+fPTb5RsAjblvGfyVtuxoLArzs1tooXsVLYNRTbIWZ0kg?=
 =?us-ascii?Q?T+j+k+H9ub7vkBI3ntnYzTCZf1383Pkk701re28wct1a7NnJ+aYxoTrXxp8f?=
 =?us-ascii?Q?uvx5SZkqsX3wSn9qxe3vVHLL83AvKrW0dI83A261yC9JyL7TN4ZWJiF9YDni?=
 =?us-ascii?Q?bQ3c7S+Xe0eobVGEhddg2iHQxdiuO4K14W+qV2OY83dEY/CQnejU3LIw+Aec?=
 =?us-ascii?Q?b8QjHQSr2z2ldugKwfEh1+5/lmKzZFSutz3NemCkRwPtIzFloXDpFnXcj/0V?=
 =?us-ascii?Q?xqk0qqe4yWSpd6wvmRkvduSug4tovyeMMUqq/rYlJil2GmoSrxa1OLtvF46n?=
 =?us-ascii?Q?GcejvUMqO7D7QMpbC7HmCsW/1uWO8ZKpTBu5YLqDyCD3thpw1WF/f3XQcIW1?=
 =?us-ascii?Q?MFYiLkFoqIlJ9VYCwyHyxyVR3e3emm820dpsrCdHXwiFHCAlXU5sQiydREIR?=
 =?us-ascii?Q?YXaCeImY50NSEM1ZdVKpuRiUknX/25/dLeUcRb/WtvD9mKPDlMXKGKhjBNKW?=
 =?us-ascii?Q?YinaY5J4sIhj0zVVCpnqJqTJZQHb1QvfCXM1kWhVHYiicge2SLcog9JImSD7?=
 =?us-ascii?Q?vtwiyfPcBeei9vz+YnSU8eWWzlt75FN+U/Uc/5wqblyYHTR2MpBSTm1mxmuh?=
 =?us-ascii?Q?QR8ehQCdROxVLiyQ5kPZtZNcZ+mB107yoiEkRHghw+jdKfEgAXthX2Kwa/vF?=
 =?us-ascii?Q?1M/7fwm40jbPWej0LPgFZEysmICZQXvX9Q9okzMs75n52hilXwPKAQENY3Bd?=
 =?us-ascii?Q?XAM77NJjgkLqSsxKlaLCkAnvi2Ruk3djFrt2ttbE0gVJVj/qP5eoN7McIy/W?=
 =?us-ascii?Q?tP3mxOFQPZ3XEF980EdB9tUz7nW3sJomn0xE6ui/G81Jkol6iQ4P0ER+xiA5?=
 =?us-ascii?Q?oqA9k+4tuEJ+uRh9DT9A3kH5nXHvrnfBxjK7kja6jdwVoUWJqEow/Zi2EdGD?=
 =?us-ascii?Q?qFLLKE1an67ANMbkpwvI75+Zu1IyC3qnsgjBcH3fi+Ik3N25iUKR0+ejS0V0?=
 =?us-ascii?Q?o34345zTI+f0166JMAz8ZpOvwGnWrBYRjUfXbucP3OhdwXFOz7LaJj7kyJqT?=
 =?us-ascii?Q?KEwCtMMxqjhyl7U4LUrlG5qqQdr5gEYPiBuNUx0TzHu0R3iC9O4bL6PotXju?=
 =?us-ascii?Q?3JCO0wCIG1oQpFDZY/E0+Io1VRKRSaZWZiWR4Bk1QQVpp1jwqXLsyc/XOQwU?=
X-MS-Exchange-AntiSpam-MessageData-1: UKB5pFsVCksL3ANKmmSr37F03elLcicM658=
X-Exchange-RoutingPolicyChecked:
	QqX1Dc/VKKbFE/OeH77O3BIu6Qd0doa//XJaj2R+00nf8Nc9kYBzffmyNHYrrh+BP/yJvbOeKcmiRSWd43mpk/KqU0g4m88boOq8OJzQsboe2dcnMdElU9ZVgUQGxA4ZX9z6ufZ0LOWwuzN01h1Fjm2LWLYEG3SZz+FQheTuLqbxNOB58mBKGhfEVZXyFa3JtnZiEp1SY+OSdT32c7bBkRZPPJ9nfHiHt9AoD6/VrTOLA65LCQTMcYUQ7js1+KzblgsjFHJkx5wl/xi0e6m6MAGw1wbpSA/3smNf/xMP0cQt7AKpRGXv+5fZb4B2lUX5U3bLgNMPzYGKUzRBTvnWOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QUDtTAMgUoIQOme6qZlNau+YIoIhFQin6suwpLHZ22wgHYavusQ08fLM2kpygnkbwLgJ+nueN95ydVAir3OOxjJxJSSXQngxTadDnIG2IFH2aECAIDnrm9Vt23CnFDjS5ro70mVUn2Gqa1QWjkZ/mj6D0d/WT0UENWv9xXXjKjJSB3zXK+fDwwBmw6sw/yesq5zb1+mAnp2wr7h1Cnx75gQpIVyT7byv1ZDeHaGv1/rpH751cCUsmAtUu7yZ4M97W2szmDoMGLRUmqjwwZfu8h1duXNG/tTiE/67iWMQiQouGsfHt1GNgQlycGP5tdyDrBFE0GyXPyO3WDj5sM8vjZfBWLuGlJ5p95aLXgjG6I7A0oq7FiI8dLGF3uSobRvzdT4rc7zAzc7uXs//qzZ4tRZ+m3Om0itpU68lS0tPhmIN05nn/TDVXNhxxRAcq6p3S5Tl7jLtIT9HZ5HMqoeIcdInO10G6b/zzM6DA3RhgJCvjbJcQB2+Hx0z7ACn+zU3cF3D9wo+HCVYeDncd6HvXUIP4DE5003EtoP/zfFQnsws5MRVWpzBCiryR7aImUK0jpBqEJHufqMV4REcQDYRoWY4tX77fQoZQtwXCIKZOIPojOBSUQF9gDx6F1t18mV6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2edd15b-bb7f-4b8a-ac6c-08df1e325059
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 14:02:35.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmNC7x8Xqpt95ATy8bCAnqTFonQHS8G09k8wKH76wejftTJNLSMUxO875xkzkUcXQyJNWPX4XPKZgMkA9qTayGklBHyfxN+18bj/AUqUXck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7002

For DUP and RAID profiles with zones in a mismatching active state, i.e.
due to one of the zones of the block-group being on a conventional
zone, btrfs_zone_activate() has already put the block group on the list.

This leads to a double list add and refcounting problems.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index eefc283dfed0..dbb3ce626dba 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2024,10 +2024,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
-			btrfs_get_block_group(cache);
 			spin_lock(&fs_info->zone_active_bgs_lock);
-			list_add_tail(&cache->active_bg_list,
-				      &fs_info->zone_active_bgs);
+			if (list_empty(&cache->active_bg_list)) {
+				btrfs_get_block_group(cache);
+				list_add_tail(&cache->active_bg_list,
+					      &fs_info->zone_active_bgs);
+			}
 			spin_unlock(&fs_info->zone_active_bgs_lock);
 		}
 	} else {
-- 
2.55.0

