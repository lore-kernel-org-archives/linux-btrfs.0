Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF872D5408
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979455; cv=fail; b=a5insT12tYNGMqK6xWW7NyTHvV1Yi1sKkNYOyqQTV5EpkhmrDkpy/xmByVJ++S5npEu3NjSHp4ik3a04CC5EzwTctONMN/3TRv2agYvDLSDYSfZEg+MrIJ5TbB6sfUC+RxH2eNCZiuBhL5tLy0TJb5YD5JrPXubuwMlJyhgz5cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979455; c=relaxed/simple;
	bh=5RwxW3HecmOsmRGyULQY0lNXvxLn6K8EoKQFohZ5A/E=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TnHlCeezh+atC1AFLlR1fxlejVvAk3Ksw+ue6w1UuJM+Qtu11rZt0IGxcUWuK858reZwtvwcWP2DBj9wj83IspMWp2Nk4QX1wARkMTeFgdoNsj0FgjteGgc7jiee/TLQnx+iIZh3McQBOF9mzQOMNVWPyRXiAUokJ8ijVheiLhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UoH9Fepg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=N0tYKBu8; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UoH9Fepg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N0tYKBu8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979455; x=1823515455;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=5RwxW3HecmOsmRGyULQY0lNXvxLn6K8EoKQFohZ5A/E=;
  b=UoH9FepguiIGWb1JJilaaApSvOa277ngbZKidpuUBKnKaOWBOVvX9o6I
   Z0FV4yiawv4n28HewlJKKLFlx95W9zFD5VNUD+FVDvAu6a7HQNi2sFfXy
   JbaY5TZgPpqyBmunPnHhhSIbfDJoUWobBqBxbxkIUBjV0ymDr/8wts2lI
   FY+Qe1aQzkg7jpGTR4e4bF2Q4gL8qJgg/+VQlHcaFgDzkH01/lYi1/aDD
   o8G7Y7zPwmuSshfXXZmrJxg2dpswJul4a9/JHw+5gGNcrhHWdS2GXpnJd
   /nqTdEIxjQjgoxg8CkcMCvbaVZlClobgbSBspdm8Fl640P2tJ6Z421KgY
   Q==;
X-CSE-ConnectionGUID: wg2qAf+xTH2DD0jTar4Gkw==
X-CSE-MsgGUID: VGnenkXVS/C38rZmNIuObQ==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077238"
Received: from mail-northcentralusazon11012065.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eOZfaS30ArBxIzDiAJ5augxQ2I2A88BBXQ7ZvXpxWyriyBrsyT5kAC72+T89mbhpD3tcBZVj0syKtRPNomxmH6imwkfhLUph4XrBa9IiCrgQUc9J+G6LbQKdNl9f0RQO/D5eY8VpOe/4yI963COq3JVY/o76vvXRN9CbgUhP0BNRrFj+7+u6yWlcGaEs47kd7XwJQU6eVmH+7aQFMSqD0KgEmB/Z6jV/RI9XrjTscuBmmfO4DZ/d8mjug20d3I99OTWTgZsXXjdoBNCbjHIfvq8skR+AiDnSyn3pWSBBsawACNRTsbKhykqueq2G70aqVaB+l+gkjoTt7maqsC5jOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAHeXDR2b2tq7jo2qh7Hcq6OrN7Dcd+g4t3D0pEvKnQ=;
 b=dBq7CBmNf/wHP+enAA3ZzEqG7J30exZQENVrjovEgjyFtkJxIAEHJyuKk8QCSBoJXhMAE0lNO4vWM5WOhbICLs2x0DxEkNiG8MI53ShLOE1xp192KbqTGgx1aL8gXZhkVcDaJiFcnjpY+ZpvSwFEN+MTHc/QGc92jB619Gj6WUMZxbHs/7AL0kCUfpMSg8ZtHo16MOl66eSn09h3f0Si5+2wp4uqfj/bj6pjkjiggkelUUbKTSR/9E5fxNFf1hQ0nNXKGay1x1atL+HeWgRuZ0ewxqPozDIip9U8f6N8Vndj9rfZDeGB828aCs8m3H23J4Dcdiwb7phaf0Uw3P7RSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAHeXDR2b2tq7jo2qh7Hcq6OrN7Dcd+g4t3D0pEvKnQ=;
 b=N0tYKBu8IfA6JBDyHZ6xqRy5zTrWaAN7Yb8aNXcWfVq9Mwms/Gv7zkdBb0GcxKEp24LGg3BeZ6eU3JNqfjnDqKQIhFTZmyl9SwLKCm6rTLMgVxX+P+CtL3Q0iOO84TkP7n5rKsdjqxfVJuQJwVZM0V0YaaMUVXQStTGCeDENt4A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 00/13] btrfs: zoned: rework zoned garbage collection
Date: Wed, 14 Oct 2026 14:03:39 +0200
Message-ID: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
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
X-MS-Office365-Filtering-Correlation-Id: a4c5f8cd-09ba-4b80-14d3-08df29eb40d6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|6133799003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uoxjtkRIgTU0ZUj5grfJsfFImI4/pOyILRPK1DW2dTIyAS2/kcioLdcUm53PDSOjIQ2b/M9yZxLvYqpLZAs/Sea2abslCi3+Ei71hoxnUgNnKHoyK+uUNy7cou2OiAHNyhvXz3ycOEC2j5RpB+zLqWkXplB9n5m9Wkh9BBcNq80X1L0BYB5B/GVbJXfdFse8HEF4znaBMJGSpWs6CqgD3ivmu4GFd8h/a3U35kMrhi7GR0hIalEyE7d+m8ZvfFtVB8Yen1N+F3aYjkq56fvt8KEU+4MSzKo6qKfZX2t1heVf/ohPU62nXToAiAvsnQWnD79jw8f9qkWXkBvevaI7O5fNkOcRIobwETZiyjmUBPzZvMp2t3QiBIYxkBL7FVr16JCIqpg12ydPJqsjvuw3kTkUWvOnqBY+paNrkmGOmnhe/qy3Vc5xrTnMMnHvXRaFt1BY4PrCAWFUoZweY4dl6HX5OwO9xFKC9zub5YN5T3FmQJ6bzNcGurCO6eG2xQaUMEu4BtlBfzwWtCwbdo3Snr+9FqbWpO3f5MvqKTn25GOgvQRhUTBCFABs0JOVvj2s/G7Le6qd0ZX0Zr5W0zXO97U98T0PoQ+TvvxllnFUxIbrq+WUHPZ9jCpszfQUEoRZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(6133799003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6r1tz2tjbRsRWaAc6QgBI4Vv0+eep77upa1apqZfPnUdQ2Ifl+Q4VsD13omz?=
 =?us-ascii?Q?6nCRaxLutNC3fcV4iHMPDX0Z6kIkIHvT8QC27SzsNjU1k35d4DqDkVquT2Yd?=
 =?us-ascii?Q?3YhZCbwODiwJ2oQ6CWZZ2ZkBiC8NjfJoIrCJfJRXhQCpmirDCBX79adggMpN?=
 =?us-ascii?Q?/lAUymgQpIBRFt+1/d+gweFJlqZYgM67jqY/m2ZuMcpPgsdOzAh7aWZ9TcqP?=
 =?us-ascii?Q?X2XwBdXAK8kbDRJAtDAXYudk3i01OKn2y3g6fdZcifmrn+Z6cL+2eoKvMKLr?=
 =?us-ascii?Q?7nJ0Y8v5TTSPQ4OxbjpxNSrmH6H0PngYk1CQCg738qEpuAjFRnzMlkTKkNb0?=
 =?us-ascii?Q?zFYFh3tWnMzllx5u5uZc5V8tunzg1GYcnToGGUyyd2RETV4YIGL2X5fi73YB?=
 =?us-ascii?Q?7XsCKc/aHHh1qmsxcsyrNb9/ww+P4WxPsPwWYZIprgdpXJf1+bbl7n5B/CnK?=
 =?us-ascii?Q?45eJVgBtVw/CPTJdwYu34+Er205yPVJhSFoDhhFd8GvAUvOfkSPHZ77v6meZ?=
 =?us-ascii?Q?0CSl1F1eHzlp2skDiq89du58n8T9fwb4DXS89sF2aUiMmhkLEAa4sSvgz3iV?=
 =?us-ascii?Q?Y/7iZnHNpfk1RBz9GsgpFAv1IRbcCIpvQWY5JiPwgJV80GCyg8hlNlOtwBEe?=
 =?us-ascii?Q?jnVT5mnEoiWoCO+BZbzL+HeeSMqWMoD8z3UMK/BT9DY2FHzN65GToCwS2soS?=
 =?us-ascii?Q?GAtDIxAlyo7GTNHbmIK4ZFhdvOc2rndbXC9udQhhjRVcWR/DbDSOEkbgLFl8?=
 =?us-ascii?Q?NbzHrgR88xDMaxA8Ycfhs60cmw/eOs7Bztq9U5yI9XkIpmO0SZq47HCjKkKS?=
 =?us-ascii?Q?iZ7NFAZTBsRDjbb0pY+D42hcP0O1ZmKaUZZm1gCF738AuWnxe8zjdz/zXTrc?=
 =?us-ascii?Q?y0tBBwCioi5lkR3pOq7r+5VolKRpRdNharma0TPnBWNKqyvehXDGtKaGEEej?=
 =?us-ascii?Q?kdBXl6ETLU8Yq0aTd1gq6zNWnkLw0pv3Pf1HVO9ZSjfxSMFo97Fq4LuQkHHl?=
 =?us-ascii?Q?RQaz32BMl9qaM76J3nnMB3/ffOaWgIReYWDaUq/9iWrbuNieKZGZrRW8oewe?=
 =?us-ascii?Q?lutdfc5nnUO7AdahBwp2pFpzFgaEMAVrSKfCxIv47Zbmd2cviAqpG1hD07jY?=
 =?us-ascii?Q?R2hVhzmMHCApmwr+GF+T3RVhuMlc6NbVdJ62WUHUCsHQcLg4PxmyvZRoi2cb?=
 =?us-ascii?Q?WbZ5yUvM71akyzQsmwNcl1ivYdWFPPUb3EaJ4tWYN0VQ+1zaxtcZt8sBWysY?=
 =?us-ascii?Q?oSEdWw+dfn29g8GYzfop1VGZ97uLHWJqbnRn0lGZ0Jr8YOCuT+P7t+C9Gpte?=
 =?us-ascii?Q?Bsz4uTXtQ/3hAsZOJcdlVrtAsJKBDhKVdf7fdPLu1dpLZ2R6lrusWq355mpq?=
 =?us-ascii?Q?2FuoPYruvd1eqtcVB8gIdMtCLRF/pwAjPVmDtHl9wSNLxEzMjh/mWmAgvslB?=
 =?us-ascii?Q?2zEuhTq6bOZF/wL3iL9/pZFDYH3R0mk2Uu20br2obPtVtiguP2sdnXPEFyum?=
 =?us-ascii?Q?kmqEF4pxmend5lXlqgVc0kc/O+z04t1XhFvXfOLRChD1hWdnKwL1rnxKP194?=
 =?us-ascii?Q?xpdlvGNffxCcW3pURtuNN+7NuO6ICKJxIKAOweMQp87Y7OogZN99+VUtI7WC?=
 =?us-ascii?Q?e1pC3l2IuOxx1HnJto70o+4rVnwFkpHChZ7VddwxlHFklY0fZNvpgm2ruOx6?=
 =?us-ascii?Q?ptMGMyYtvIXJ6x+Ef2ICDeRNkzpA/cdGOTerLMKQxxwtGOBqEkWKxtDPSZqF?=
 =?us-ascii?Q?uVxBtGkNrgnZ/7Fk1X6Tmq8zJCn720O6GgiPcoKbtwqzHW5eUp3BO2pTq5oQ?=
X-MS-Exchange-AntiSpam-MessageData-1: 7nYSb7AEjRhsh6hVX77QEVnwdpYuSwcUeGI=
X-Exchange-RoutingPolicyChecked:
	r64NsyH6kXYK+54HH9n3owY/Fa7KWBpTCCODRyQ/FEUYb874tNRP6DdyZP3Gkzk/XZWA8Fth8p89aaMqq7R0pT+Ed083QcdFNjNyEdKgj+dmXj89LdLvK/pvPb9Sp3VN1XRntTNVtt6jGCEhlPJq15Wd8QwCYusgMCG0Gt4NaPxJG9dmNDMoMZ67nT1ar11kt7VqSYfXvyGjeatCq3oriRm2fwPCRKO5TantmkkPI977P4zfmIucrmw5luNH4oY1dv4lbIEPxo5TVHe/LpTLBRdjCK/aD80HzOOP1uJOkAGT9pywj1RxpX5QW+1qqFOKcMMDhUT477edSZ+BBDzZSA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ugXaYWxyOL4wei7NaTO/goByakEUQ0bqW+x+WEQtNV8t2a+62enhBhQwm+COGDx5HbyVOWpe11OpN3EWtGrNV3MvmtE1OTTI8elxdRR4s0kUUqTaxoKc7MdqYpwwqMMtjvFVvNFlHHb6lf2F3ZFmC35KEQFb5/75YICVMApkwDG/V4VX++MGATB9GVEgsTXGc9FEWp+6pS7ibiIRzSQEa7voWATCiUzujYpseSxF6xkzRjiOsAJyeHfWUSxSZ0WITWn9grDTqU3DRHma7VKRbBEpBHtB50uxjsUxQUC5AZNr5zySH07pXDD7j2M3RvkizsqSI+ZMVVOSu0j38j6Gm8Xb1EcCCiAmLZ34RukaphXR/wKmZ7JCMmoD8AV9XmDpuIH9YHuLz42ka1qlECIEPU3tC/izgFqaNkSPeC+TblTliE563CgYG2ELMfmFWDx6yynRvXD/MOLmUkTaulHlN66A19HTMOWACNsxmQpTkDdBGCPCRqcR4WDBiqGbdx6GK9wO1nBGy40m/BlkJb+MnP2FAf4UhGs1vP5WsUykt855iAUukoc8q6zBUy92a7cby2w7w5RYMfWK5+Yd+qiZfQJovVnQ14PRg8MkopYu9+VBkUy50/6sUcrMyvmPEtrQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c5f8cd-09ba-4b80-14d3-08df29eb40d6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:09.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvDdP5NQmWH7YM4xhHs1XtvnRH7FtiaEecQvL5LzK212XTWyuhvB7s27nB7ukUVkKLSlcV6ym2vdeoiQarXgcIfUzxbGf6nFsZLLcmT4ZPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

Zoned fileystems currently (still) suffer from premature ENOSPC issues.
One of the sources is accounted for with
https://lore.kernel.org/linux-btrfs/20261013072941.424029-1-johannes.thumshirn@wdc.com/.
The second source of problems is wrong accounting and relocation still
being triggered not timely enough to evacuate the space the user write
needs.

This series attacks the (hopefully!!) last two remaining issues. It
passed a 100 times (of 100 runs) of fstests generic/747 which has never
passed unchanged before on zoned BTRFS in my test setup (256MB zone
size, 64 zones, 4 conventional zones).

Johannes Thumshirn (13):
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of zoned
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

 fs/btrfs/block-group.c |  22 +-
 fs/btrfs/block-group.h |   1 +
 fs/btrfs/space-info.c  |   3 +-
 fs/btrfs/super.c       |  32 ++-
 fs/btrfs/volumes.c     |  35 ++-
 fs/btrfs/volumes.h     |   1 +
 fs/btrfs/zoned.c       | 583 ++++++++++++++++++++++++++++++++++-------
 fs/btrfs/zoned.h       |  25 ++
 8 files changed, 593 insertions(+), 109 deletions(-)

-- 
2.55.0

