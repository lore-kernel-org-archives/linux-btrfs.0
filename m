Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EDC4137BC
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588383; cv=fail; b=cVKodAr9TDMHmfnglhEh2JwxrYmSoJFeTvRD0di/KzcE1JMKIlSjFRwOD44cku/ZBZIGLtXHU1+RrSdxOk1uPlDTqgoWYWi2tGPHA8rnDDJrkr2mqsTvIv/Oj7OAV01B9zAPlQCmSmjNeeetyGHCN19XK5QT2hMpaxo0WV9RfoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588383; c=relaxed/simple;
	bh=VWMTVOB/hpFX6uO3aWyZJtt77hLjlJ6kZ7xightOgrA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YlnIO+oz0YAnqgRHHNX5HYUerF34dvRlSxqEV7wAsXMP/qCBfaIoRNlkUIFLiRkYpKyH+9AqPer32kXOWGKIFdYqeYDNUkODb3QaX5TIvom8lXuqvjTKFf7J9b3axFT5yxzhjj4fIwIQ71DqcRwUU26o1yeqPwj9qryf0eZZ2DQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HPMIXbj+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=MV09veOo; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HPMIXbj+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MV09veOo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787588381; x=1819124381;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=VWMTVOB/hpFX6uO3aWyZJtt77hLjlJ6kZ7xightOgrA=;
  b=HPMIXbj+If/mmyNhxYLoxLJdkGqPLFN2GfV1vpykN0ux0hZzXATmv68E
   J2halVLM6edXTQKEMvchXT3/bV4n4vgxpILlgeDkrAeciLfLw+TXq03oh
   r9vP7PsGZrQ/MDO+SqFPoH+4UMoLzSqa4t328mwnESpAYNDjEDMtZbUMT
   jJ8a3ZTheDOFHzbeavrFOhcRl4WnSZrDqkB5Rn2XxBcCkqiQnkeIUarmG
   6pJGv57GvSqXbOfvCbPYItTvt4vrW8NzdSR73+jZMgZWMRh4qweHReiuc
   JPlMYdXnW2Be8fDCIKABc1/OfzcG/epwYXp20aHsyz4pxurnSoWmIfnYj
   g==;
X-CSE-ConnectionGUID: wciy8xhZR9+5bDP7QUKr/w==
X-CSE-MsgGUID: ju88z4FHSPmA/XXzqU+wiQ==
X-IronPort-AV: E=Sophos;i="6.25,240,1779120000"; 
   d="scan'208";a="152593400"
Received: from mail-eastus2azon11011008.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 00:19:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kHOskmCcqZ/trcDoogR31ftBZN1++NJiz3KldEy/7OU1Jy3Naz0TMogYYL0+RdLQZpRMONgHcd5+n8FqExgli+uXjQL9zb+qidgeZwdR4MuN+SPAU6TMYY3EZs3rziHLfCnwysfwUHKa2l8QIHI5Rb8Du2D33Eeo9dQOvasY5wa5+/35VAN/KnKreRbf4YqleXzHG2egMht9i/i23xflbyR5a6DGEbX2BZbGh+XLrPLPYA9OVV+MXK97kmLRDrmnmFGbV37nrmKI4SBq+oZLgIwvztjTrwVj+3IlbTokzyIXigYPBmaB3ZeqVM6p4NMFCxEfpjDxOSGZhRD5S6Wt3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4wlvnQWfhqrLccnTITUCToHLGTEnAiFUOq01Dy1pd8=;
 b=SAUc+c8DreWbBaEmab9hetRP4mAAdgzNnR4DBWUBDd/tnWw1hQhHCHlGCH96ckcT/D4jngOkc/+w/gRq4uSwYJHtS43wHxo29zfUyOrKmWTUOF2MVk3pP8PnBdJcZoyBSlb686NQdem2fOxQJCljQR5BJNZ+b84yFLpwhzpa9ViajC77pZO07Ufq2VpaEnEFBizUpBdAJyBHt1MRHvNEnpxHYaUc4ekrAVL1aVuzMkFkonW1031xn8VB1NGrblV+KP1VZZyfR2nSnz9rg9hMiTQuqdzUiCt3aznzOiYUCrwCJTFPgwbWUmOjNNbDeivEODKpneSSCJrw8z0dQXP/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4wlvnQWfhqrLccnTITUCToHLGTEnAiFUOq01Dy1pd8=;
 b=MV09veOoBraPWbCQFtz9gitARbQJmA8qo90iHkKjGXSvCIXgGLxcHTZlsTsAtdwJFa45qRMGZdvpLwfvAB/T5Y0DkuzJKIZTXHL145NmgZseSqjsO9kHdR6zF7intrE7dLwbknQuaJBB1wGyq7QBcO8GsMGnSZFfUOLJIVYnnnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SN7PR04MB8642.namprd04.prod.outlook.com (2603:10b6:806:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 16:19:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 16:19:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: handle RAID profiles in btrfs_can_activate_zone()
Date: Mon, 24 Aug 2026 18:19:10 +0200
Message-ID: <20260824161910.2009296-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SN7PR04MB8642:EE_
X-MS-Office365-Filtering-Correlation-Id: 06ab7413-db5a-4eb1-9189-08df01fb76fa
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10070799003|19092799006|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	rSnpEdFy8g1ZtxbMMQP94dUon6D+W2yEt9PlFTz78n5kUnwgVyvP696zCcDQN3ZhIt7n4OjbLmXvmFcqi4SMO7KiYhrQIsFVCldCGy638/3pVNaDQHkxbaZauHge/pY16GNkBLs4tKpMVi+vabWvZ4UvEDbCCn5OQbgnS3X78tC/Micz8ZC5jbJ0ymhuRG64UgLDKGzqYo7MWQOAkyK7zxCHRe2xSgMitwSttn/QUV+MFpjlRyy7q1d8ohVwur8gj1I6WC4CPN6zvMldGdRlH5pjLDxYVfad3a8C0+nXjuKc6K0T/2NPXFPkKtX6mlQUeHb/EGvlJnkXi8Ihu6FJ7foeXXv1DuGq9HXsHMUNCcZ+EUUfoobQw0EFctC/VB3Z1U/8ge+VFtXLMzj+U0IUNSUjjNFp12JLwoRDC5Us6nZtrCYcbmZgbZ6LFNFuAk7ojQEvrLg+vRfpr/fa5VUHJQSAoX5uD4BmmEmK+grLryrMv9otUdr6BAg1l2gjTzcmcdJW/ZqJ+KbXnke5TW1Zo2xVyFOolGlSUIgOg4KmndNyiQBNDqealfezBEJRdjO5OVSdvYRlG3ooaEzbNxHS2NmoQ0n5YblWgU2kY8GfdN2apfaRuQN4jIfMEBTwE2pYfT0wB7gMRBg2BvJgoE72OPWiczTILKp12F3+3azyZKk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10070799003)(19092799006)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2w46loASf5avNDy85K8Tou3G70akDbmBBLJIm0liQz/Dhb3jVuXu71vB4f1U?=
 =?us-ascii?Q?7W0nBaaw8kdWYjTSisCzD7cHaa4WNxeXSn/Tz8Xkm6dCaxktrs9cYz+c0eUD?=
 =?us-ascii?Q?u8j6bBGlxVyrHL87d+nNXT8PxFjrtj3t2M3jhXDQg8vzP5vvl6fHHe8TH4aI?=
 =?us-ascii?Q?U/U6SP8QIDPkpPA3UQnL5yyJCHmgCCvrBTH68fpEa/rsICXneDDymjc3kdxi?=
 =?us-ascii?Q?ntUuBfAwMMF+Ny63+jHDrOFuqaPoDqfRn2Rv0/+IVIGHOwlhedf11izPI6Pg?=
 =?us-ascii?Q?WjNXDA3/j3UgMZ8d8Ee9ZAGCgcTmTXcp9inlzUp4ygKJs1x1eoxbAUnyFGZz?=
 =?us-ascii?Q?I9LSGEbXxY6Bs5iQik614DdYSfDU95PdQMMuzhxAv/j3OvefMh9Bd8DmbZx0?=
 =?us-ascii?Q?SZSaspTKhKRyRGKWaktPGgoROIkhq77bIUE9JzE+g8GO0XyIyrplEf2+uSzu?=
 =?us-ascii?Q?pfVAZVkWqBi7EtuJDPOwix4P8z9wJZQDOhhNbffYqmWIHu1CMxaT+/YwpA02?=
 =?us-ascii?Q?59Vs8b+9DNzTF4GzWyUSr2gcORiaomd7/2fI621FFiss4mhUwKhM/WBl0/5I?=
 =?us-ascii?Q?gLLC9oB3r/6dstUU1uZ8rPH0in3WnvMG9fo17MWlUIWvVTyMsWl59leO5JWL?=
 =?us-ascii?Q?MNQYZPapW6U6uOBybcLaHW2dNQp/fI7E8F/3Vtcd32PpVcK6/kZYz7u3Dbiz?=
 =?us-ascii?Q?rtA9RgTPfOQpI2E4tu6+IrYKxh+xg9RchOYimtZWbcWcGlwuSEA5f9YdWoOs?=
 =?us-ascii?Q?TbhK6Dh6lwE6If2mbrzAY2/lUKZCXdzPXdFX7lDNzIxpykIx8s0m4U/l5wI+?=
 =?us-ascii?Q?5yjjSgYjvTSsFa/QG2wTlJNDpQtvkssiacjEeSwKn0EkcxaU/XkGBladlGXv?=
 =?us-ascii?Q?F0qxme20WPL+vULY2k0T2kQav21IfklVZWCfsqjOlhV+4MUoD1qykPDsdNy7?=
 =?us-ascii?Q?+QWDGx0aL1kU7c1SNNYiWtd1HeWIzyNlfXdq9Bflvczs6V7g1U8dlaeyx04G?=
 =?us-ascii?Q?d+Z0Aa41DqCnVdG8lIXhIwBSERqythqCHK8h6qE5wS76Qz1vfOOfVuNZFWih?=
 =?us-ascii?Q?ai2RB0xGc1kuCdRKw6H35AooTXzGpvHMV8kTNWcwRLlxm0qNMtSrWcxYkzN1?=
 =?us-ascii?Q?EHkdt837nZ8wjMqDcjpW6oNby1VGS6T2RNGiLckKlgLZN/393FKxPU42G8bF?=
 =?us-ascii?Q?L+C6sIS8EX2/sNZS5yTeOMg4w8qclljvy0AsNF8D0gM1th0IcKfOiq6O8QzW?=
 =?us-ascii?Q?0TmqcjqNhkHr4txInRvMzrkMqae7HYvckcIquHu8jS73sZXeJxGh7ZHs33Yo?=
 =?us-ascii?Q?6yeL0FcIjAmBUmC2t+MQSzk45OQL+tG2Gti0Niq0+WNfHD47O1i5fOCJNx6R?=
 =?us-ascii?Q?IeIIkylSgzWKAeq6/tu0r8sE0D+/CeJ3t7BasBJWyTFDx212Hh6BlDvimAU7?=
 =?us-ascii?Q?gp2oueG4zADT6dsptH0BsVj4kugNYLGTHUptuV2Bi+OndwjlC8xnhUTlAwDH?=
 =?us-ascii?Q?yNUrCvlTVmGOi9isEANr7lwc/NKQN9IWbdrkDzMhwhLDMdbwEmmZW8+sc54z?=
 =?us-ascii?Q?zmcLrOSwM8+SOO/DiPPT78meKwT/upZ3qdxkqrI/wYtZ+S4JHtBVAMII0w5+?=
 =?us-ascii?Q?aXioWuojSyZUGU3ePRglQ4oBfUvpXCQW4jvfFVKxQ2xuTVBYdzGDmUKMk6Vm?=
 =?us-ascii?Q?9vINqIOtN9Gf0FJv25sb2lPh/Mk0OGfi8kfEjwMwSJTe5qYjZ/9QBNnv5AFL?=
 =?us-ascii?Q?cVixJXU7I746iTLaSZNWTHJAC1x4YWqMxkoDkbwqBSMDbdsRCOV/ehSNqSoM?=
X-MS-Exchange-AntiSpam-MessageData-1: pjyJQAGtCHBgPLobx/IsN794bTWtQgvYjLM=
X-Exchange-RoutingPolicyChecked:
	r2nDTFBkyTfN1Zrg74tX1hAEImoO8Wf0DnzFADUSR3tv8u6y0XoTlqSLVKleH5EU8uL7pApyTBdytaooRbFIno0WKzOvljg/deOsT5Qpy1bozAnSNAYze/e0L3LMoU2h6F5ftwzBsXQfNZ7BkdMjIfB0tDlIO2rFQT3M8hS6dS03e+/mYDPbWyxeFntXdleGIY30HZxmWfVxJoGFuMGEETOzANMOwNBuKfuha/nCcpwARXzCKcX4wpD8OIwURCT6QAFyMB9070/BTLgIqvsTIPdUoSCL8yyNUMz5VIWxmUWH/NRO3Ivra8b5FV53GAMpBcOHyL7Zl+jQzNkHbYHWGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HMsW6icoaSyHWyO/95AQ6pcut+QTDJZlXfLXnhdNVQqUVxJyb8QlquevR5cZ4vpzvV0T3yQ0tKPsGjsS0EFrhWJhhXE4pvg2wa8cCoFF3fCZm4O/rJwcrft+WVahEiecYkUzqpPsBTa0++p8eKAeedPrBckoZq6RF5WjTX6E6MeUBQuuOnRP3rReUeoxHok5h+33kfIfK/1aZ0Gjwerr6zUHPMSaRZHjyGw3Y/ZuzPu5IKBo8TQfvbbs2ekcpDtJu4vIzfQ6B44AQgCglK5ilb9uvUZ3sxSYUt7y2IkxC2Xk2gNRI9lU4nHF/LouHAJOZ8of7g1iwl0J/bQAH6GBVqeFj0D4PCOJ3/2F8TRIBPhEC1XnRLzs7nkCycYtgmNqXADLj1veSD6sC3jDo1R9/zthKSE6x3iGtc2Po6EfmbCUM3q2CNXLJOVHuxuZ1Yl8QRvulmT/C8O6OVTwui/3+k47TdtZ5SnPVNdN1kFWJh9oDD828wyFK7d46J8iclyzz0HeE0Ju2MrfTcJfjLoDTpXB0/X/hfuai+GsUw9MuzEmDO3QSWMiykGUcBhCp1lEFzlXxTD65nqWYAbozi2UR57J4dL8FtAnBG4UpauIUwUqCao7zwHmCWk+9TG07sbU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ab7413-db5a-4eb1-9189-08df01fb76fa
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 16:19:25.5903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osbQAHopdtSP4cc4oTaSlDU3UEdYNjQqx0Zc1O7MdJOohO67JRjLnQm/K5tiTTIHsDiixBYVotnOM2xu4KNT0BsoAFtI2R43oW+/Dbgf85g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8642

btrfs_can_activate_zone() only accounts for the single and DUP profiles.
For a RAID0, RAID1, RAID1C3, RAID1C4 or RAID10 block group the profile
switch matches no case, so 'ret' stays false and the function reports
that no zone can be activated, even when the devices have plenty of
active zones left.

As a side effect BTRFS_FS_NEED_ZONE_FINISH gets set and, since
btrfs_can_activate_zone() bails out early once that bit is set, data
allocations will fail permanently: writers loop on -EAGAIN and hang in
btrfs_new_extent_direct() waiting for the bit to clear.

Each of these profiles needs one active zone per device, just like
single, so handle them the same way.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9d448cdd60c4..107833fcf2be 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2689,6 +2689,11 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 
 		switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 		case 0: /* single */
+		case BTRFS_BLOCK_GROUP_RAID0:
+		case BTRFS_BLOCK_GROUP_RAID1:
+		case BTRFS_BLOCK_GROUP_RAID1C3:
+		case BTRFS_BLOCK_GROUP_RAID1C4:
+		case BTRFS_BLOCK_GROUP_RAID10:
 			ret = (atomic_read(&zinfo->active_zones_left) >= (1 + reserved));
 			break;
 		case BTRFS_BLOCK_GROUP_DUP:
-- 
2.55.0

