Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CD646F481
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719843; cv=fail; b=QCYZ3ev4Jz9hX9JV3a3Pi/tDhAnsCn6vg93rbXKa4ERr9gDlUAN/T05jDLYfrGA/pfJVzUK9akV1C2m2XDQoWW4CPkZLUfa1iXqRnaV3Sb1Ss6Q5fyhpreMdRGPSWq0ya/6g3INbjJZT19L1k9VYqJNb6PAP/KMkM/4qqQ+j7cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719843; c=relaxed/simple;
	bh=vp4DLB3lvfz9OtXhx5nHSF1aQSJhJjYsMaUw5rtC/3c=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s4/Yr8FB/IheCsc/NXAa3pQ8JfAjZKZWpcyIfcXy4xftVEGUNy03If19Sof2qkFluuzSntl7GDFp9bgZ211JQo+b3VUndpmEfvsgYFBNW+BiELk0IqV1lqJJp7flFsZJOJqxRS4DrPAsbhlpxtZ4TLo71cY/5upsbzZuMD+XPrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BGgdm1uK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TPJSxXx8; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BGgdm1uK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TPJSxXx8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784719841; x=1816255841;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=vp4DLB3lvfz9OtXhx5nHSF1aQSJhJjYsMaUw5rtC/3c=;
  b=BGgdm1uKdfUkYLAjBlhw4MDyS+W3wYaUBqQCD854TmyFWP4CpfS99/ox
   9PhBBS5Mmc/VtXR2Yu84JPqrj9tj+NiztpGeqOweEiGlGiqof9c1sSNie
   7S632Ny5fSs4DCUU5L/8wWepZ8SvL0ypuYZPOC7ZaL0bs7xFNISPeeR0B
   wdrnyGpOpFzo/Ty3TBlGsy9yYkewe2ZOb0HtIqXK4FrUet/e9GojXWgxG
   fqtaG2d6P/Us3H09xVVuH87MllhEgfi/oPY4fmDDBr1nzq4ZSaixb3cK7
   ee8QRVcATxHloFgShN2u8e9eu1L1+suOwP0gnm+7DpSyyhDFNpQxn8ybx
   Q==;
X-CSE-ConnectionGUID: tloxivOmQp6+IJ4fdS9tKQ==
X-CSE-MsgGUID: l1ANVOlnRPyWQtEVjdxPoA==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="151556160"
Received: from mail-westus3azon11012047.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:30:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjalcuzM73UMbfMk64iKy0/mmngwMRkjJMdwWNMHUkoeM0QnuAk5dOy9bGEI7MHqx1cKiEeMYiXfvKQOtpASXqLmZGDHj+LPDhDsldgbvAOPXK+R3gxh1M/JeNUWIp2kcxW/6VyYFM4dm1BDCnh8wgFRyFtWQhAMIXDucXRI8tSA1V+V5IPFavjpA0PhIMkWqj7hEKCd0FcuajIHwFg4wTGDjSN9mTwzLijIOV/HLUK7Uf9EfT9lLdZksrGQMXulHfOug+j4PZo6e5YcBQBDGQKnwKV+rP1d2bCecZc4B2hwMWEM6Gr0MI9f4+0RzzaWRhTps0zu8weJk3bWGpo5aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7pJPN48q9CkD3yW4moxXRtS480EBWv+Aju1ocpL3LQ=;
 b=E4ZSwuR79kTpZKipidKwQZ6UepQOsvVrEJqGaWqrDBE2SgfQ8k7Jli2cy9RRnP030+MqHJPn5PTxGSHBam5Cd7g/Jprg09UbSLBo+/u7bJ5B1dvLl+4C2huRYoZNRRYR9oFG5RD4+c5c8xNVvKSGZ51P0/kyfkqWuHK9rNb/e5UhtomwyeKFLB7DYv+eQzZ/hq0z/ysRh7C0AW0dDHDKU98Dw0P4FGBTMI/4B3BS9419Et2//z02Fy+ag2hsyV45oR1DHpYIoFuBZszNxVZibp9jFB+p96twwR++7pL/NHi/IbuRMp9u8OY7z3kp3Kcdqg4cAzhhT6tnRXtZP5AZ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7pJPN48q9CkD3yW4moxXRtS480EBWv+Aju1ocpL3LQ=;
 b=TPJSxXx8Rkg2OTpbyqE52QFo0LI2jU0OcfszNqIF5ZKpUYF5gLA6HHwsq9cpMONqnV/+cP3PqX3nVvXJ0y4Q7QD5Ul26xdpqM1YDjvOj8ZDNmeKgEiqNp6g0BnLyKj1YikxHfqSkD0ajOb35xSa1MEw8Z/AtWjpF/OnKUXN8R2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:30:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:30:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/4] btrfs: zoned: btree inode writeback fixes
Date: Wed, 22 Jul 2026 13:30:12 +0200
Message-ID: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b83c79-91ff-4dad-6b73-08dee7e4a376
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|19092799006|376014|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 3jkNzc5X2qNzSu12pZwac9sX2LQVN3qDnb9WaJC5THniZOQVWO2UA8V8L1ONpSus8BnwR2IxtaEb0VYNNM153L08lokHs5an15/vD8DzR12mB5Lqhht+RD27k4AS96V3Vqh9f6efLN9On4R9yOoAvrsNn7rK8h5PVPJk5o9wyrTlzwmNMcpQya9Nczb3RT/9N+8xVHTj93OtGri3F1rsMQ9z73sEpAy+vAUUNES+V2trLh+ACYIK2LQp+2VeNseMd7Jq/v6A9JgA6k/dbHPPxBeMvaivtW5AII7Tp76V/kkRCcdhFkocxvrgdmYyfppuJ90626et1sbUK8oDFbZbCjN3JVViP9ClUz+5iOlMaQABYdOjek4oY55G4faODCspjC9z+/6pf/6fcZ6SYHminTUrZ/uvKVnM/M8YXUUCJma3a0RcmwrIg2PXWJCWDOTUaiYadXNo+mOY1uB+hnJzvJfjvrVV+IQBdTmO3MP31tUUwhYJSltES9Cu6ces9KQXiMponxi1dmz1trbFEyBTelSsjXbd366Bii9K3BHSI9seWnl0yfHhye4affJ7AGOxZuIyWm0w+vsESr4PFyFKaOVNj7tLO8MCd9yOkkYZJC8ltUKtdkDPaT3ZyonqEwXHF4NcDSvv58XvYErE+ky7imnWojtmvDB2t3ItY0fKwDo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(19092799006)(376014)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?rlPO3UGwIS6yvp/ejZ8nT96VvqLVGDp1RxF7w7ir1BnaSQUeB5fARiWh8YQA?=
 =?us-ascii?Q?CZRrQZXtBMMbi966AcrE2zgTFJuNYC1ZMlWgFiyd5yfhhQgDculJun9rRA8v?=
 =?us-ascii?Q?tPXFfXru3/bwkq0bfmqnEZ5IzpPPvC+tN6yu5M6NWJYaSYVHgZJODkalvz/6?=
 =?us-ascii?Q?ejWRNMmh1gutXr17XpyVANn5sIRnoq0r3SPrgMZfx0h4aleVBoED83vNb03b?=
 =?us-ascii?Q?S359X02b+VJx1x29eZCBDaykLIyO9Ki84S/ff6KHJRdgScKcBbNId3WuHfmx?=
 =?us-ascii?Q?1b3vZVE0DnKaNyozt5jOC4F9QgZ3vYQ7Hbkfrup7CrR6qztuE+Tk9dLCoEzE?=
 =?us-ascii?Q?jkDSWpr3TgsHXZP2rLVDZGrdMG8V4ma/5Mw0remK80Ohij348eZsQOZEjcnA?=
 =?us-ascii?Q?WTsHjIeiGBAFchYtHFfvFAAgf8xK7qONjfKo5c3AzXMo5sFQNKxkRLffEg4b?=
 =?us-ascii?Q?TlvwmlSzcmGFC167jzA+ROhrM9xq3qRvUnkzDFx/4/qnfr+LpdaJB4Whdkom?=
 =?us-ascii?Q?bFT/kcLZ8WdxLK8RqeWnkpcv859QMSdybaS9H6KaEjlz/xMYgZ3aMjb7didR?=
 =?us-ascii?Q?vKMQdvsJG+XqlgmjgQ0dKpBMD2absIoMJ4Dk49wJi2ELuf9LnkBQwNCoideF?=
 =?us-ascii?Q?VVYzvg09zLd6F+SqmEXTAdaS/PW6AsQpbQdMU/+GfDNPC8QB54iwc9mmtu4N?=
 =?us-ascii?Q?07PM0GMIKyb1oRGcdjvpHhut0DcHXsSjdP4uzKbAb6TI1O0DDCM4oQi3SH7l?=
 =?us-ascii?Q?A82HpZYan5NdLvGrE/+MmoSCIzfCbjetjk1BaHIRy3a8W8d9K16Ya2qQ71bK?=
 =?us-ascii?Q?0hVdff7TMqe63oTCU1KmMiBYkVTNwvwq9TSxWn/k/PF3pGDiPb0Q8/fTln84?=
 =?us-ascii?Q?dvTdimqlXwbsXcdXD7ZJpGNRh+Pl+h7UkDEGtk2qdXGVEI4j03MroHVokR/c?=
 =?us-ascii?Q?M5S5xCb4xPtuURbgvo6TkIDSWNMvm02bfr8DVVQKLX1JPT7oNJA6S3XvDqnv?=
 =?us-ascii?Q?Fnu+5MMe4DU8YTV5l28QF0CYnFy+/AgsrhNOttsII3Jw3/L+rSjWqDOEKO32?=
 =?us-ascii?Q?3JqIdbGQlwFf+yB6gJALBZSgd4GQ7LJJ6OBsDkUAROlaD7fwovJiHVoJZrJE?=
 =?us-ascii?Q?M+ZT1yhxj3Og4dOBlCsDhPfoDwzGoUN02J7MF7D7L2uuse1Xq8KUvOzP+P2z?=
 =?us-ascii?Q?YZ6XCCfmSMsSFcpC9gDJsoOoH9Nac/TN+iduoUILlLLhqkSqZOFRTqXHHaij?=
 =?us-ascii?Q?NjTwPBDy9G1cqhW1rPhKhU/YUypcQTYC0GWwNFMeS1UCr2sZcGGDY5X5S0xM?=
 =?us-ascii?Q?wzDzsflIJW5jYYxpMYGboWeDaYtJOSkGzAF5sGZFd3IEuRXNaUOQlVCuyqUa?=
 =?us-ascii?Q?6Ql2gR9Z1mU8C/SGwvGRb/EJ+Cs3NyRGiMCYj00F4q25Eud/cPcxvxO8Xdx5?=
 =?us-ascii?Q?xR8ae4o7swv9xDS13Pu+zIMkMWA33M95zbO0YFrcVY9vrjqJwxsdZzynhgEl?=
 =?us-ascii?Q?vRLqrWoBh00q0gsmw8Sdlw/ax30gIJ6hcLGhho18bLDL2N1+31Hluc4w3p6T?=
 =?us-ascii?Q?XOkB/HPqeT18BnQQV1oEYi7l3U43yR2gqu54cwo9O8Gt0pcvdfClYXLHn6v7?=
 =?us-ascii?Q?OeetJhJFuQp/iATFosfxo5ZZTALbljQ0DMBzpuPjj/E3yMmIF5j3mBmuU5AU?=
 =?us-ascii?Q?iNrBc93s+BcjjpGW/pbOMiQrCQ2VH9LoH7MnRRr/oD9sTY2xjmjcOTB6pdYt?=
 =?us-ascii?Q?P+Jn+iCwLSVH0e4EjIwpStN3G9yCsh+yEralTNOnfUeTKAbyOccJ+9+k5Z6J?=
X-MS-Exchange-AntiSpam-MessageData-1: ksTeA18IxCd9eA==
X-Exchange-RoutingPolicyChecked:
	Jjy0HYp5qGwPkNG6n1uLbvDG8iw39+Li1I9ye9h7urgFwSnq361fmbo0pzEB/XAL4am95IzaXNb4ch5c/PDAVSNY3B6BEqJeUNPUu1fQxf+aKrFEeAtvqJ2frbceBRxxHFIX968OMNlnSXrh8NKld0V6+EGP7MhgmSi71f7xUsH17xC/cTxw1vp+HOvF++x+p1oAoc2zL42lD05vTHEB/0IUDdZJqXbBq58eomb0q9lDbQZh3UeC90EI4SjruAUzaPhIwgXon0atMZYsxKTK1Pf7xdpP7+PeMn639gvo5YWCt0uP/QxT8jAufSyAe97hZ8od8WJggzKNKb37E+5iag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b/S9d94YRnvD5YAaXeejjEw5QMwQDdIgbzgETan2Sa6Y3uN5VsZYnOJ12H6ahAmR8+dhWRGjtaaBsZOmko5hvtn63HP/2jNtJvC26C8eT/K724rpsgGDGyDMTDq+aBDdyXDFv5pQrz/UVM2HBYaxsywHxPw5eKcbayyQ56Zg/O8KXbVgWfCFg+Jnxt3IKSssS1sONnr6+QpOgVo6t2+ETufsPQX1xf7+Za00tEJ7lgbnltmcxiqHlEmUF1BeVnyWViAGxyVM5mv5rTYyiQcSJ/PnkljKJ46es8SDlwM6fJ+qihE683xQC4y1l0bBVMOpdsDAHZ7x6N3xgYtXCrR6p68mcVgQOry3d6J8zcrVbmYNROypdYmC8xnulNPKkxD4O1DqbEwfzrveKIAm3yPCjuOG4wTiiBl47JZl2LUTLgME1CqtfTsHCwK51tnrYkxjpoyoPYRUkQa0E4U54/eBVflkVmejoG7uiUoKDhn10NKC1YZhHMjlrJ52PzkDHYnnIP2qrxU1qNghnYpu2/HzZlJiXGZia4zsK19LDW2uWtahVTrbRUaTqZ1oH9Wdtyk0cm+PEw2YK9UOBM/JHdmnnSEdTuH/q4NoKc8oTPUzVLCr9biBT8swqI66JrM2uJvh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b83c79-91ff-4dad-6b73-08dee7e4a376
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:30:31.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0q3INvdAfsYYrQRHutuip8qbaQnq3Ne3e1BAt3WS4Fvrqx8GqoCQ4VK95BtZ/6HKYv2Oxbx4r4tdNF7B+lFwfjVe5tyW4kR5foKxyP9JvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

Here's another attempt in fixing the problems with writeback of the
btree inode on zoned filesystems.

The symptoms we're seeing with it are:
- Hang on unmount because btree inode folios can't get written back
  on the final iput() because the block-groups are already gone.
- The recently added WARN() in invalidate_and_check_btree_folios()
  firing
- The ASSERT(btrfs_header_bytenr()) in btrfs_free_tree_block() firing.

Johannes Thumshirn (4):
  btrfs: zoned: flush active metadata block group at btree_writepages()
    start
  btrfs: zoned: drop stranded dirty metadata on transaction abort
  btrfs: zoned: drop stranded dirty metadata buffers at unmount
  btrfs: zoned: don't clobber the extent buffer when zeroing it out

 fs/btrfs/disk-io.c   |  21 ++++--
 fs/btrfs/extent_io.c | 166 +++++++++++++++++++++++++++++++++++++------
 fs/btrfs/extent_io.h |   1 +
 3 files changed, 159 insertions(+), 29 deletions(-)

-- 
2.54.0

