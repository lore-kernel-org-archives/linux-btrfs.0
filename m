Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941976;
	b=DNCu/kXPwcRwdn5Glquj7PvFM4Q90xjZ8c6rw6lFCmaAYzYWjfhtahevG82GWujZ9ANd
	 L2/sh1ANtVZhpunR6pW46d9Iqpuk5X+T7yd/8i3cFCeGkO7AftpIkFbBW2lnDc1/9wFav
	 ZLnQMno29/WB7D1DPmNZwCdew+Z4aeEfXbxkyzL2+8EuYQhAaqqb0+5/FBsLe3/Ywuce6
	 dF9UH4VOhMvM3qUWc/GMir5FSo7aMSXQ44j0/MEZzg1OrIY+XkPEZrJ8Q7R/TBLlOR6Ei
	 l0wkv1TZG3CS+rvGX8oao55kQi48rc5EALCH/UFkPS3YoFSWuK6H+hnaptwvOu5cNXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941976;
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
	bh=NPLxox679F7vFRkeEPIQ064egU6Rm2q37aVq5QPYAeY=;
	b=JDsFcQMX/PBpWS94ezJKOOOwjlky+tM0/ohI8H/oqytoTu0lAFWlaLC3ymxrdkpi5Yj0
	 b8xtHvtkZSl6L7PDhTmGvo7OQVNsP/5cC4wkmv02q+4g3SSmoClFH/NeRPedwAT1tkSzU
	 2XUw4zJTdEEzJef5rA//YdYe7MeU4N2w2qmqAkPxx025sdzGaHtCl8dbPfSBNKA1IYZpK
	 TZ8hFteshsErpoG7Ku7UmwkxxNYLJN7724eajNTuWsJN8riYicrBu3Bvp2I83K5/tDwsX
	 VTYRzc1+XhzZg6aavrgYc29QUHUFh3El2kZpfs/a6G/b+NpP6jNUYpTM6O1md/NGPVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=D8KUUwCU;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OVuSjbac;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ED2606A33B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6ED2606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=D8KUUwCU;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OVuSjbac
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941976; x=1826477976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xj8aGC3U+rXgijTKFerKByJ6GEo4hEyQjPvM0L5mZCk=;
  b=D8KUUwCUW8XT0NB0wKc676JuK51nry27GWENy/EC3Axg2hw1OQ2//EGk
   6A4kbIVcSbtSScc9jXrEn6kOSwgbgwOYRpmyU0R0pECg942uxFkK1g7Tq
   FtsQnYfs2cHWlJGiWAnwbzebrPMIcCRTZx5esMt4vupKZvl7XbEYZeFMq
   qyNmrxoeFq9u3xAoVv0HZX0i4S5pg8CA3/2JraA4H6M5pji8zSPX3ks5f
   PlGOkeL0lMbZXUqOhCIOi7+hzBB9NNRWN/2Lc5EtlUK5euXVkH+XGVQ3L
   Fq8uK+kFVkip5Emjq21jLS/pg6lm835OkYxtF8x/vjZkUhVSd33zO4qc+
   A==;
X-CSE-ConnectionGUID: pFsC2qgVQkK7Y1rriv4XYw==
X-CSE-MsgGUID: RyciUutMTfy127qGxyYRsQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880131"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoZCX6bVza2sEGuiOqh1+UPjkw6r05tW4tFw9+2KvrlMdDsTefr9/YMoM9PVuXwEATb2D2k/0HY8FVkuJYC0N/eU3B2DPGH66VnDzpiSHTqwhl+YuVA9KzzHlNaH1MY3pnxtFKz48Lj7I3AnyUhN8bm0TIzouCDM6qQNHFyCOWPRN93jqKrevqqHu4kHkGQTLG4FMXw8MlpAqEe3sRp+foyF2BYAOwCeTFMJi1doI6siEQ7Z3fRsJq7kbLfVDIjftRi6VckVbLlE1KNQHaceBdn+TY3uXthaDTSJXe62xZh+d3uQM/C2S1VHI+vMkOtvwREvV+nmlGPem2NW9s/PEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPLxox679F7vFRkeEPIQ064egU6Rm2q37aVq5QPYAeY=;
 b=hDiFlMI3kj3nOz8CMHXtQikuqmWBhKNfwYWYrcQeXffiniISCyBLkZfQs6C7BJ7ovzcv2Q7K8ovDsmWSHjPOhvHA4bFfywqn7PuQ5/iEs276xhY4l18cN2YiizuEDSot5V02NOV+uiuQkA8wul7E8VBku/V4Mcjr6sPkv1L0+I2VKbA4BOr4qnXcPC51U5TR83x45D1GEVLMTRz5DmhSQwZCVxM1PJp+hHEOt1flme4NujUoigQMe8Z0oL0nz2tWkA7sr0l0X/ejUFmjOphBR1lb7bRgQaFj6zCysux92DRqv3I65TdhzfkkTQ2J1N7LaH066O6gcP7qsVxaw7GWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPLxox679F7vFRkeEPIQ064egU6Rm2q37aVq5QPYAeY=;
 b=OVuSjbacE3B1qrUEtveaUcYpCCtcWfnFfYe3Tmlzihm48Nsp911YGdaZYa+F9CEh+q4eR2zmHcLmKH2Cnjba9IiIlwJNgTTGk1aAKNPgiWO1Bct4JYTDMueluH2Kg4G4LB4lDUSu7zQueOdy31hQGcuCJglVKXWaWnYCUMPTkwA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 09/27] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Tue, 17 Nov 2026 19:58:32 +0100
Message-ID: <20261117185850.4128157-10-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 1624ba05-5507-4a4a-36de-08df44dce858
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|3023799007|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	2u7QDJE0FM2IcdKzWEYlig38kap/s9SGkVc6Cf//JYEV5xBzpHILs3qZ6Z+5imXbruWFyYp5fgpNwg5IBiliaLyzw8Wpv+0lWdSeHrIPL7k/2utuRTNDBtpzL3wlvGR80PAAXE/x3mhfYEBkzd6gNTrtugCMRNXDYPCXDoZzyarJPOrPfnC0PFix1w278SWsLaxjvZfhpQv559Qaigr+tDT2WgxPXQmzyUPvg2jVQgCIDSxcOvbzdtJ+9okD0lNKm99BZyl0rY89BTMCEN7471uiMgleu/gOTxWClTSbLabchnqtZFQzvm2FCG27KuA6Ox1z6t76RFSOVYsGJYqzAvUjlaZ5gnHqgx2aZWxrniEsei1iLMbUq4UK2+fQwB9UAfYURhQXGA2jpHxkq8CEVVfavsYZ0WwCIoQn05YJ9LjXoRaGPs7T95LKGmctCJPOb33z0mY9WUvwklEWOyOd/ck1miec/AIgPUOtpEs2NKskEik5Kqd/B9kJeUf9vVETQ3BU2LipJpUrvryM9cwF2OzxKcfgfmId2dLRmNCU73TjJ7rLuPJ2S6ykvsuIewyEk22yxjuLOd66T27/Z8eYSj2s3srKcdexgQSQlrId8QYmyEheM8KiMaAXcY7ZydiqcIoCZjZr+onI9ua/YwmmIqQxcs2y9sqWr4U05wwF2YA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sXET3xgEG5hYuY4o3n2RVIrzU/mo1hYzCoa8REsBmr093mr/eqbtlc08HvNk?=
 =?us-ascii?Q?IKQm4gBLOuJNIuXjIUmgLEkvt8dFepUHqde/rkEF1MNMkNKC11e6M3KBPJ1b?=
 =?us-ascii?Q?y9C8O11r6zfEO9kTZYRRPZ4vy6LnsfMbVP9+b7bOMlyTGbYQuRmy102YcwJb?=
 =?us-ascii?Q?EaIXBTj5+tQ8BKeNfFVgmS/K3ZAbQw6U5UzTEo1BP2BRA/MRn9agtOcALdjB?=
 =?us-ascii?Q?jGaVqK0S6lCV0DGmgUEmg+oXplLpJtSdMoH2cxUKuta9pVZX0hTA3GV5YSfB?=
 =?us-ascii?Q?8ywFRDqf7Bj+MM3o0cBYnkVqIGKGOqeZG9Ep8IYr9IZlmOVUdbW4+bhX/Qyx?=
 =?us-ascii?Q?BTRywtANmgGMhbtgQZtAcRP0eFnyS9vUKehqTq3L9Ac7NJ2OsmNOUUSt3jEL?=
 =?us-ascii?Q?HQLqcbZXIEdJKVm28Sm8AO9fbNT+zDWnpjJEcJz4x49wX70SnuOkcBBJKQ9D?=
 =?us-ascii?Q?qd/qO8d6LcI3qRIRFahOsXorTAYrg3HyZTbxYNHq1fcMnaHjYGKumA3XL2/n?=
 =?us-ascii?Q?vlBIrZruQpy11VySYts5gX0AuH/LwvMxkRZ6L1efoG1eIGiyUQJ+HaXKGanj?=
 =?us-ascii?Q?1vfatzK9iyJcPDuAAUbPEoJ9lOaEKUYOpTbPMTTT0ol96aWY9XWUwNdlsu58?=
 =?us-ascii?Q?/r9pXVqgRrZXhJenscQZOy5XauY51NIMKNJV3CfVdtq6ovYRH7rLjNX+OFQp?=
 =?us-ascii?Q?Th+zfKyPLum9EpDmF0qXqpCIQ1TJ9ZwS7RAs0pu01P1GHU/AutRd7RVAWNOg?=
 =?us-ascii?Q?UHWkgmc4xNkFIR7n6rrqjLTydE7nPrCjjK7RQGKY7aze6O6pTykJjPtamdvm?=
 =?us-ascii?Q?6WzXn/S0CxbFKLdiItEhwIICW5SYrqPi0XCqyTcB/jS60hUJCkyi/8Jeh4/i?=
 =?us-ascii?Q?aeYlzdiFNe+XTpuzkuI97NjBdMS+Lkc9TmiLDCrs1lVZIYflb1lAf6lBPmhx?=
 =?us-ascii?Q?XlhEW04htGDwhytB22Fh0yYBEG7CyQpvNcgAgn3RlA5+TRB5sLNMQJEpfVAD?=
 =?us-ascii?Q?0SGWr9iOg51zn55I98NdaoO8aaCuAwwbIFp3jril+Hd2warOhLQHP+sDW9cR?=
 =?us-ascii?Q?wRWcSJMUtjds2AEnyji4lGdinqUmq5zDcmUyU60cCWUorcQmSA8xoxwH6ceW?=
 =?us-ascii?Q?zY+iHcbcFwx/xuYz8pQ9l3qvvrMN5HQOihZaSbeaLLby0gorJVjkS5ljGzry?=
 =?us-ascii?Q?yym+mcSXL6xr4FrR+ykbM4AksBOzefciTokOfVB8QmvSAx5KT7HhANlDT/Ep?=
 =?us-ascii?Q?ehO3N6o/1hKTimve44FdUXVYSSXE/sDlHJiRjHO6jasNxAZk09ZsHIkjqc/N?=
 =?us-ascii?Q?t5G0rII4zB++g3q/j8xjQS56eqI6eljn18nxoPphMxLS4ITktwCdna+XqV6M?=
 =?us-ascii?Q?MhHZjs/Giyc2tKwYsPLeRrvlBVnulwleb9o38L2LK01Eu4Emws5pqwN4aN6t?=
 =?us-ascii?Q?Vu1IVwOH+XhdD1l6HuwGzjWi6RxsWO4NOqSa8bHwzTVe3u7KgZjJ9qBoZvpJ?=
 =?us-ascii?Q?3QeW1ovwA/jOn38OINuRn9Ov2bBjrbqul7u3zljvBmNjO0nocvC5OL0xu4S7?=
 =?us-ascii?Q?LXlUppo+4wfhaev1ZW2ZMUUfnhYgWGKguPjked3f2dwJdRQ6/vFRZ4iEIiKz?=
 =?us-ascii?Q?tiRoOug0Dx3hZ4VByU/lhg9tRtj7YRX+5DoT7vWBgvMutF2bwITJAAgYncY2?=
 =?us-ascii?Q?byBp2/x8uEJc35EG7+dU/w0/YSbfbwj6sAIWLhePq8xoIYM5bGgUkKn8iItQ?=
 =?us-ascii?Q?7m4w2vAc67a1LYsvZySvIY0WTDAy5BsUFAn0SiBMnLkJE90cGBzUPNroyROV?=
X-MS-Exchange-AntiSpam-MessageData-1: ehJ0qqodogD1KXV0bB9ZS7W83/zlr9+iNHs=
X-Exchange-RoutingPolicyChecked:
	XcBq+Sz3E7ircmChp9xoIoC83ENzoiOyvf3ciyQJYJc7puQcOOUm+IX3iuhHNjx8H3UtP5Ir8Kb3WSix5IyF4zT4sXPWFFzmfULVySMLjUqjy2r433pXL7vAdylVPmnIhMRFc8GWlnwk6NydkYFV642hpTH0UUjlBE+zf2zosypuMzZGw5d+eRAEFCtOOVBBzB2ikXHdjsINF7UhzYTa415IGvs2UYvaFGGTtziqaUEbJpxrQyfHmivJ+0Sci+WFHPkLchQnwfkg7K3Jxz/rgGo0V86hKi1hPs72/HTOp4sqqpSbyuoDy7/k3zyBgIOIQY9ydQqjVmOtnq8oi17f3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	686opdO+/22R+P5D1MdrqLeVdRtNqsoC9xGkka9wAl1khKknseAcVwSSplVYsVtrgVbMckQb9hdZ41ztZwEP4RsZhI6clbHmMvCJvJZe/ePf97w6gjp8JwRQiEMYBexcbPASf88qQeD8bWsL2YkS+DB5HiSPB1FVBPxyjTFy7DalXZ06HHm9IEHzbmgXG8nRMTs4l830gkFCWdHSjF36VQASBR2uFmAE+V9DGxqSsLk+FxWrszHRucXsevOEkF0NSPRU1RRtk1PWkZ3Ct/8YWIkn2vLhm50GOXRgj+fMxxOHGE1QzDjsEX0qP5K8Lw6/G5pLwzop/OG+StJGip4slioocReEu5hQGT1wgSFTOTh7jakUUkaAhAIImgOucBKA7LefWANsQ9NLDcDGxUTz103KDCPuHMpDCKLX6B7w8Ru6tn0F6JZAmksmxzeMm1rsHRn7PO3uwlvqRl/l7/rQXRqoPUXug8ro/Eiteqs/xXrIIPLDb8UeiqstpH+nQabbWBFTYRFg4eXpfBc4mRlH7L+PfE//qZGwmxqQFFiSlJbTD5jTTTT02oI4BNdrCGwLmv0htTbl+OnAtVyWpSsYnbwsRFbb8cKH8hT7AuU/+cebf9N9KBa/7L0J9gaxMxOU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1624ba05-5507-4a4a-36de-08df44dce858
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:29.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sqQ0ByINoiPz69KNPOKdFvuxZRIZLmi2EIJ1dxAnepr+i2IlgN+kLlxuU3qjKQEgTKxLDN8X/zkPoYmDZSDXq5ylhX9PucPybcNTOAz1gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Add a zone type filter argument to btrfs_find_allocatable_zones() and
plumb it through the device extent hole search. When set, only regions
consisting purely of conventional or purely of sequential zones are
considered.

A caller expresses a preference for one zone type by first searching
with the corresponding filter and retrying with BTRFS_ZONE_FILTER_NONE
if that does not yield enough space.

No functional change, all callers pass BTRFS_ZONE_FILTER_NONE for now.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++--------
 fs/btrfs/zoned.c   | 25 ++++++++++++++++++++++++-
 fs/btrfs/zoned.h   | 17 +++++++++++++++--
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 08a579e142ae..4b6bafd144b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,7 +1704,8 @@ static u64 dev_extent_search_start(struct btrfs_device *device)
 
 static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 					u64 *hole_start, u64 *hole_size,
-					u64 num_bytes)
+					u64 num_bytes,
+					enum btrfs_zone_filter filter)
 {
 	u64 zone_size = device->zone_info->zone_size;
 	u64 pos;
@@ -1717,7 +1718,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 	while (*hole_size > 0) {
 		pos = btrfs_find_allocatable_zones(device, *hole_start,
 						   *hole_start + *hole_size,
-						   num_bytes);
+						   num_bytes, filter);
 		if (pos != *hole_start) {
 			*hole_size = *hole_start + *hole_size - pos;
 			*hole_start = pos;
@@ -1754,6 +1755,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * @hole_start:  input/output pointer for the hole start position
  * @hole_size:   input/output pointer for the hole size
  * @num_bytes:   minimum allocation size required
+ * @filter:      on a zoned filesystem, restrict to a given zone type
  *
  * Check if the specified hole is suitable for allocation and adjust it if
  * necessary. The hole may be modified to skip over pending chunk allocations
@@ -1772,7 +1774,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * and *hole_size is set to 0.
  */
 static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
-				  u64 *hole_size, u64 num_bytes)
+				  u64 *hole_size, u64 num_bytes,
+				  enum btrfs_zone_filter filter)
 {
 	bool found = false;
 	const u64 hole_end = *hole_start + *hole_size - 1;
@@ -1793,7 +1796,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
 	case BTRFS_CHUNK_ALLOC_REGULAR:
 		return found;
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		if (dev_extent_hole_check_zoned(device, hole_start, hole_size, num_bytes))
+		if (dev_extent_hole_check_zoned(device, hole_start, hole_size,
+						num_bytes, filter))
 			goto again;
 		break;
 	}
@@ -1810,6 +1814,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
+ * @filter:	  on a zoned filesystem, restrict the search to a given
+ *		  zone type
  *
  * This does a pretty simple search, the expectation is that it is called very
  * infrequently and that a given device has a small number of extents.
@@ -1829,7 +1835,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * is not reported as available.
  */
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start, u64 *len)
+				u64 *start, u64 *len,
+				enum btrfs_zone_filter filter)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
@@ -1905,7 +1912,7 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
-					      num_bytes);
+					      num_bytes, filter);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1944,7 +1951,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
-		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes,
+				      filter);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -5941,7 +5949,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b1a364030fe6..8794c3c74c49 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1050,6 +1050,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	return ret;
 }
 
+static bool zone_filter_match(const struct btrfs_zoned_device_info *zinfo,
+			      unsigned long begin, unsigned long nzones,
+			      enum btrfs_zone_filter filter)
+{
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return bitmap_test_range_all_zero(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return bitmap_test_range_all_set(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 /*
  * Find allocatable zones within a given region.
  *
@@ -1057,12 +1073,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
  * @hole_start: the position of the hole to allocate the region
  * @num_bytes:	size of wanted region
  * @hole_end:	the end of the hole
+ * @filter:	restrict the search to a given zone type
  * @return:	position of allocatable zones
  *
  * Allocatable region should not contain any superblock locations.
  */
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes)
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	const u8 shift = zinfo->zone_size_shift;
@@ -1084,6 +1102,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 		if (end > zinfo->nr_zones)
 			return hole_end;
 
+		if (!zone_filter_match(zinfo, begin, nzones, filter)) {
+			pos += zinfo->zone_size;
+			continue;
+		}
+
 		/* Check if zones in the region are all empty */
 		if (btrfs_dev_is_sequential(device, pos) &&
 		    !bitmap_test_range_all_set(zinfo->empty_zones, begin, nzones)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 5195d3d6f541..174528e2c312 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,17 @@ struct btrfs_fs_devices;
 
 #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
+/*
+ * Zone type restriction for the device extent search. A caller expresses a
+ * preference by first searching with a restriction and retrying with
+ * BTRFS_ZONE_FILTER_NONE if that does not yield enough space.
+ */
+enum btrfs_zone_filter {
+	BTRFS_ZONE_FILTER_NONE,
+	BTRFS_ZONE_FILTER_CONV,
+	BTRFS_ZONE_FILTER_SEQ,
+};
+
 struct btrfs_zoned_device_info {
 	/*
 	 * Number of zones, zone size and types of zones if bdev is a
@@ -71,7 +82,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -182,7 +194,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.56.1

