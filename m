Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AD043C7BF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926653; cv=fail; b=F+PcD4dPFXOPXOUBNU1xfax6Jlmxa/Zyeg4NMgbf+UBQCsLDiC48si5BcimIoM9IjsYbmEe9avYGkI3oiEwTPNBVqp/s3uZtKOygu48OPMxpXgkqGeXvnVD6hxTeoKCO65SDqWXGYBEqwp+aLm65XZiFaCR+vfU4y6wp4I3SGwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926653; c=relaxed/simple;
	bh=EzYi4VUmqqiu4OzazoUToXy/DoTHlSLYS9STxJz9jQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H6DXat13z35PUX/qhjkgr0u/KnWLu3mU9DRiWhmZSS2FydwHjQBQBmVuvvvnI80YH0pliz8bT1qw+Pb7aa9v7gLbvQOlHS77jNS6OXuArBWGE1ugF/bZEMh7ZJQbmM5ohPEryrI6NNy0aCpaSm4ZHqRSBHmAayCX00pk9u1eQH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=J7P3CrGC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hoQruAxS; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="J7P3CrGC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hoQruAxS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926652; x=1822462652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EzYi4VUmqqiu4OzazoUToXy/DoTHlSLYS9STxJz9jQY=;
  b=J7P3CrGCH+NT1ds2aIlitmWyo7i1Al8v2Vr/sb5nDSlVZInjn7iv0PA1
   FmbBBN1ZSfeF7DzwVN2nUqK7SDfPcwmmLvmWMjQf9xFQK6Xqr79guumHc
   MeYeTDEYeJJsiz0l//Uhytp5KRFubF4VLg29tNqsDUviY7fek8D1ygUuq
   R0T0SNK7obaDF0vWbO9F6vX4lHs+neQDSiLLRiMJioCOmQZUxm2qGHt8x
   wvWkyCfjaXfMX2jPjnza8lz5jA18sfwx2rIau2Jkt43u6PtIfp8DDvWZQ
   vLECOILXfuHQ7qrfn9vEIAreC2gxgUZSTDo9cyUoH8iM8CuD1I7L4diWv
   g==;
X-CSE-ConnectionGUID: x/vKiGG0QlueZMPHafAazg==
X-CSE-MsgGUID: ReCkUq+DT6my1lKai4Thbg==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="157114521"
Received: from mail-eastusazon11012020.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:37:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcZkF7I+5rpJo1pY2JnqMMiqmTeYTqDGG8zn1MwuG+8dl9tsWQJWvDF8kcHCJ7+Is3jlC9hZpBbHKSKW5ApVK+S5k9IOUa7gdyvlk2WS9ntlsTP9PbormCYUojjzf1q0n4NA3ymE8uGEjPzr+vsX9CPyF/M/v6C49H8KKwgtjbIzb0M71luqia8v+SYtQa4Xmpr3ZZQ0gIuTZuLROA26UglYJM97xtCZAQK/DpQ3xNbrfU94KEJWTvOBZZ3GV5efquxXuLJ+VUAlUCaHpVyUVNpfveNTHwlDjG7vgsibpwMpH7OKWNBu6JpnZpKuwuy6GVnTAt8eXNmmzqx6GWav7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnnnoMcyb1aDUQkrEWyHXGGpCDW2xq2pVdqc8iNZEEE=;
 b=u8xSgxcJEdp+eFY2NCvdyuUlEbqadl64OLHsNL4MYuhalLQJQxBvSgpzmzlyQPN9H3rfdzUXNmpRCXr0P7Ffbkx6Cx9C58HNtsK8CGhC4AXPTUkMl9UAFdy2NVZJlK4eto8OtqOm5XweM3pxXACHCU79szm06beqooqNGA45vLE5oXYq+BWMsi116kKbQEVEe4Z2JT2cVdQmBvVKkqPFyFpVHzSjQCrD6p8Sf4KUDxKUhq02xqnV6ym6eiYnZEQ98Ufj4z1huoeUIL0b3hRiID6YbgAloDvkbgTDthLOs/bKW/4eII7o6sWmNCg/CWuVvxNms2UIsyYkcegV9y4tOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnnnoMcyb1aDUQkrEWyHXGGpCDW2xq2pVdqc8iNZEEE=;
 b=hoQruAxSBLIxA2vdcYKm+MUvunqz+NXDIeQkWyNyogwVUT/PvI9IxgAO2YZleyxJcfOXcJMQCFZITi1hMdCU130Wa18IGjk8ix3leYsvYWzXG/WUZioY8zwpomTyWCqvuYqI1BFiTeHiJediaKp+0jlfX5YwjBydKBa6jCGOCXs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:37:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:37:29 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/4] btrfs: zoned: avoid underflow of bytes_zone_unusable
Date: Fri,  2 Oct 2026 09:37:15 +0200
Message-ID: <20261002073715.2191177-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: d2acf7ae-72b6-4c70-67a4-08df205802f9
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	c39Bo3nztJJN1hqFE1IWll1zUar6QLfJlVAJLUk14mNWA9SHXWLtLO3RKgW9AnHlyNJVEnZ3oxC6K+XB5CYiznBixgtIIr0NNRCPrbU5r/FSiAkabTLqgrBcYA3/DZOy9f+wlpxPX7L35aDMyIl11snIwPpiRrvi9W9N6T+7X4ttj4YWtvgH3IR55iS7vPvG2MYQjGIz24ciZNkVXnPpa5V41MacfB/4u66ZBKNpxpo+j3aM3XEcAZcXdj3IpS/WWsYMwQ0CRRNhaVp092fqdYDMyGxiSu9oMxu6QB7OsgGXp/7tCBennDocKUHXUx+v5DkdWPqTdw8/zBFas6r8LUj4LrYhLCgQqOkiwhH6+5Ilca+sEPI9+d5GPov1my7LmdoAuJ7GgU8WlrYTamLg3AnyN3bvfy6fKOgkDhzqiWRQ2DqRqTSa8sJXnpArbGzhgZNYZCXsaSR6O0s7e/4+5Wvunb3C9/SNB2ZuDIn1mKV7nxSCkzyOx0Y6ViK0wlrWMshA97f1GFAMdRjOa58rqkbQc27ssmTh+usEmKi7/3aLjoQ/XftWgiQC2r0FwsipGDx6MkQc4l7wXa6ZSNRap0HFm+lqeZxfuC1V3Z5CW5HIct8l+N7PeoYcLMbls8V4/E/3wUWuzDizBFmRYkgmSeUb6wqA970w6ysjuZR1V90=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U0Ea/VNiYkEK9cg7i/pY8MovDT81GIZnfJIPfSdroaC+pir+HCmnLuQCnj4p?=
 =?us-ascii?Q?ou080LuMtyLcxr3qMG5kuRnVQ8PvpCYmrAyvWiDgKk5vZTe3pUyf69XunbOV?=
 =?us-ascii?Q?tPXWClioH78meiHfhrAV9GrIj4333iumuZ3Q4NDfQpSUhCr1ZViefAaBzlmH?=
 =?us-ascii?Q?y6kCdwanhsa8iX3luKxGdAgwogHCyAh/SOgGFkCQ2eVuZR3hVobI10YIBKoP?=
 =?us-ascii?Q?dOlVWaHt8PqlJV98gASy6JqrAgyP2v1DQaJL9945OzBE98CeakOZ59VZowqH?=
 =?us-ascii?Q?bsnY3GDtNTm+uR3+UL276IyY0XqDMRXI4ixlA0D+G9RCJeze/0gxnohS9mzS?=
 =?us-ascii?Q?MC6gv5DtPd1fqG7lwZ3ew5P+WYIpAEHWSEVW/Ba30hV4jx6ZQK4HTrFmAxXl?=
 =?us-ascii?Q?uIfV9m0HxiRBeFkbyR9EfAmWb4ZRsWQBuomiyixXi3pnARVI9bHyUY6HUg9c?=
 =?us-ascii?Q?o2ql65NOQwNdiT4wMt4nfK7vDf/fMZszkocr854yNiNnc4aR8GWfgAtctMqd?=
 =?us-ascii?Q?3tBphP6UeaTkdV5mFtvzjtm0KPulzqNJ2dzU9fuBh+K8wND7U21+wSAT/OK4?=
 =?us-ascii?Q?KC6FyBPG3+I09PhAja4J7kSUQzctlutgbzlivXMzmgarshCKQ2PMJZcGoVVi?=
 =?us-ascii?Q?tPIapFZqcXemJyzpmgNhJV3YBdp2bU7QsPDO49nWWa7ewNbwODtGoPmuwtJW?=
 =?us-ascii?Q?ogBEbuudfo1mOgS9BCoH5D7JD/sCAKaWkTTurRL3wxb19TrSKcKJM/HaSNSR?=
 =?us-ascii?Q?bXz6IQV2nW2yevP1gHOza4vzhQRf63kL0NoQpkad/EbMwPg8bxNOIM8HzekN?=
 =?us-ascii?Q?vJn7/hXI9pHJLoV6FhNVlmYevgSCQ1z4jjLJJUgscJxa1b0f96IFjozaj6P2?=
 =?us-ascii?Q?Yyh1Pgh4oLh+GOYbf3LOfcUWx9VWdKaWlwZ2gvmSbfad8saq6sgf9f9lI/R3?=
 =?us-ascii?Q?yQV7eFGoDdIvtwkyX8mrWK9BPU+JzlDHXEmXC/kaYuSrajtY2BEKvEhuDA8O?=
 =?us-ascii?Q?TuN4HvjFr1jOnrV39/NlrgJ2tmjeGvwnmjGSnliGsX1D3q4iFm6S2JhwkrXW?=
 =?us-ascii?Q?JuFHM3fuYFlJMjb4o7aiR45ln6QslEahhz8iUWz8Qou9RxRYAZbppLKM8nhw?=
 =?us-ascii?Q?Izbwkkjw72rC3fJKbDLs9kD5D9HeBe8JezN/qdW4WHvkDjNTHtoSQjx8zEeJ?=
 =?us-ascii?Q?nVhUA7r32snOCwHS2Hlj1f612AiXmQ7VJYnhJcOLa6GVktHxcST4paXnEVvC?=
 =?us-ascii?Q?Kx7/960++j6Pz+C4F8VGjgeuDhhikmpha+8Vs6Rrik5r7lLDeh/bWPHpp/Ih?=
 =?us-ascii?Q?ijB7h2xGLIDrdSE6i36KqfLKlv8ZK8kuLxKCAVZQPURpv05pzPPyjFMUyUot?=
 =?us-ascii?Q?/YDTiAAB8RaHRBRRveNjgzAWg+aTWhccMb2CRoczAOYfeDzf4iGk4rNXP0MI?=
 =?us-ascii?Q?R6roBlsLOnJa7TpCBajyOd2x7uaZXwwxCsyJKWENULYg1ubqNmDh+j+YLFFn?=
 =?us-ascii?Q?AABveo8rSm9gRXfDBQiD9at2AJ+1UwGoENQVC+Sx8VBEFwBPxPeOt/k/5bEF?=
 =?us-ascii?Q?/09E2FzjxJtCt+J8Y+ZOA+mSpWKwAbn1VEfy7CD/WCVsD5eerlB7jkoOp4Qa?=
 =?us-ascii?Q?obBLSVKhFhl9YRElTu3yyzgehUOVpK0POiKgKwAYJNYVqLt+wny7bGB6dHq9?=
 =?us-ascii?Q?mO8eqTcl8uocB49+XRhkMpXwUCacLrXMOinjISaAHgakieQcbdiMzvF4Xjg0?=
 =?us-ascii?Q?ZJGeA286vLCUrld/hrYCryLJfhuGgEvypOhYT/AWp/z2HpO0vdqJgS0LdWSn?=
X-MS-Exchange-AntiSpam-MessageData-1: zwfrPPUZQ8/QLVsqRLqdRuyneP7c6FcEE6k=
X-Exchange-RoutingPolicyChecked:
	SCFrMSuMPkktk4pj3YVhKCpFim65tWHstiO2RDHOH2EUnlIGPVfs9Qa19NoN5hc8lPN11nLAmRZJiCPTVUyjKF0XWrxWBA4cPQdcAGodU50T03GTQ7hDyIJ4ILFUdtp/mnfBo33hiicuDZprIknx3RcPlEyZF6NjecK7oqTchCHPqEL5wTOGAD7BFjqN7Ar1N0Ol0eTa07+1gfAQtkXCxYycvkqbYw6YcaJpBs/5To3mSQRiMv7gNeKM+x9eT4wtQpcOyGlt1A71HBTlwzdInlTejM4O0Q7NLIWrbvQq8OTOSUa+qvGNLxM+Je17CoXDqUku0S5Y0EZ5+cX5FVN0ZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NzneYO5YIZqOcRL4uMgwNpgyu8knW5bo9bSoKI7fgDn16RzLDPhOAkYQjK5f/6RdYvhRRWfUHoI1VwcodWiHqOsz6vpVBSb8W7cOJ/0FgYmKfoVMt32hBCc+zVIN+K05EbCh/f7f8X18slOd7oejZ71yCX1jjpT575/W7EKaY+WerVUcQJ5lcqfVc1VmGJmjwdyDz/rx/C2IABPiPsNd06iy23CzJA9cbKBOvkzZRO7hRG+OkvHcExugeGzPWVJB7hpewaibWD7XqgwECcBk23XxvqyS5JnqObCtYdu64QhIAHYw80JoXJaR/NIvdDutIPNmQPxYP6Zvtbc/5VHnph+3OAs4ens6wm7BRbMZQ5ViDzkafexyR0biCYyZp9plAT3F1L3Y7+7drl+guYc8xBN6i1xhIw6qkGJCgBECwfSPjONcQsgCDw2i3BmgXEfP7heitCubAv10Z1NEiFlHesGLKYN+tIYoaSaYmkdRQHJuHGfaakq5QLcGSmm3028Hf9HfUx9oeTDNt9HlEeQkes5FWCNVIed4CyQNnWJOXHJ+EE2Ji1G7bh5cXs5DMrmAzEWHdDCwkG0HS/aXkzDGnw+HDvHU5T0QCGwzD7UHwqexrU8ZZTWI6PsaiOPy4qVE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2acf7ae-72b6-4c70-67a4-08df205802f9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:37:28.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbRRp6uiKViWKdc2xJy1CPB4FxHM/dSWq8bseHv+GmoiO3P4DPFL7ixXpJENy7Z3LSi7jvkakbKfueQoanDANQefSm+k7Rp+/0iPvaHnONQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

The two functions btrfs_free_reserved_bytes() and
btrfs_reset_unused_block_groups() both manipulate
space_info->bytes_zone_unusable without using the accessor function
btrfs_space_info_update_bytes_zone_unusable() potentially risking an
underflow (in case of btrfs_reset_unused_block_groups()).

Use btrfs_space_info_update_bytes_zone_unusable() in both function, in
the case of btrfs_free_reserved_bytes() it is mostly for documenting
purposes.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 2 +-
 fs/btrfs/zoned.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c148b9d6e597..74a61db93250 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4114,7 +4114,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
 	else if (btrfs_is_zoned(cache->fs_info))
-		space_info->bytes_zone_unusable += num_bytes;
+		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 96d3957db87f..89286a92a13f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3241,7 +3241,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		ASSERT(reclaimed == bg->zone_capacity,
 		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
 		bg->free_space_ctl->free_space += reclaimed;
-		space_info->bytes_zone_unusable -= reclaimed;
+		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
 		spin_unlock(&bg->lock);
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
-- 
2.55.0

