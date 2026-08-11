Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013037.outbound.protection.outlook.com [40.107.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D91377034
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 23:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786489580; cv=fail; b=EYD5w+1f8/pvCbzAUBBC7gQ9BkGiNjmhgEYv3Ur9N19AAY7Tlh/O1qZxbot6ZRAPNfBbREk1J3yO8b930mpgCzt9yxqNPCRDE8b0RmReZob+Priff+JSuyK6M8llc3wvhOmSInkG9JFjSmFJJjRYB5dJg6a3ZBAIxb74hBYR7Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786489580; c=relaxed/simple;
	bh=dAOQw65TIKGSOe52+QMN7QcWvkAZCpUTzB8id6PXHAQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P6aHx6RRnwJvXR0HUtj8xMtrpBYkpS7UUZLw6ByyaAZRk2zSq1SI7UZOq7MGnehgFcle1xmyMYUFF5oEkUeZvlOukja3ySi0gwsZLwCTNykYoYFZqaR6XpSHC3+XRYhqPIT2QGsanKMXO8A02ymAFehoc64cyMGgzK+2ju9m8L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=selinc.com; spf=pass smtp.mailfrom=selinc.com; dkim=pass (2048-bit key) header.d=selinc.com header.i=@selinc.com header.b=l6MZpKvi; arc=fail smtp.client-ip=40.107.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=selinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=selinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=selinc.com header.i=@selinc.com header.b="l6MZpKvi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sphJ5gUmmwx4biPSzAIY4cF4Wkyn/clGxXZ5xlMCavc0xQbhhi7BzWrMvlI3ZUZ2s4SWKLzMyuh39rLnfaHJKcBrsEUTNKuMCiB/vRx08ZAwlEj0JxxI1F53BywIoDUMX8y20Xos32lc6hY8uydAGVlx0eOIhgV/HBDjD2d37bqUV7J55dvjcz/SI7XBYwMjaVLB2AXJKuzKAw3leWvvoYPqoeXwb50t7rRF4petwWl8sr1XoqMLv4tsNYjzNU3yJGuv9/LG2CwT/TUswbJs1MqOq35YDBsF3cIlBHioWRtrZ4iZgqMdU4+djRbC1XmIbUt+0dbum2ySQH81gIPY1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJdAXjIEmtBIYIQ2PqcaY45cRWS2mTO+LLL3RX8oLpk=;
 b=U9kx4vK1mzyjlLJtbbmayN3oRk9/V4J9NHiPITRKqWGofIarzglOG05uqW+Ccahcd5E9wLuzcjCwYWJpfmMUh8WsPG8lhVUA9Gp7WEcJ8YiLw6hQ/s9mFYBch1/BUbWaaQQh6LoSDAE2XzKEFyXQhq5chPs3clV3QwL47uwiJarMNJSPkQWC+NRjKVf22ccCiSurqaDpIJ0gthrgshPRmGaRybjksVSXVnIVWSPXApUAMt10RsmgVtAgju4GdRhlm7p7IqH5J95xzwCsnRj7Lz99JM80JOzxH+CI2p3viL4/AkgZ7a4wLA8+YTg+frylSM0uNQxRKiOqrVGR80AEmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 74.117.212.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=selinc.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=selinc.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJdAXjIEmtBIYIQ2PqcaY45cRWS2mTO+LLL3RX8oLpk=;
 b=l6MZpKviVymfr2BAgFI2GQQVaa5AM3wAhwk7B4Fge7K7YbBdn1Cz/GZzZbPtNhDJEWnc6IvUs3mQhnN1nZQ3j8+e2AJAThvEr3GRxkZOsrZv/+NvLvA27Z83KX/HmLik0OiZEuPOc4GtUQ3JzsflSQ7o3sOsMdlBiQQiv1KPk3NWK56NqkC2kg9RVW28bMWDineQ50V3qnnvfl6hukOcacdPGqkr0E1DUSNUyTCpkozXgdJkPaPyvgSUr4mJ7zzCZwklpXTSYPCqXyKHp1oy3dFjzhCUMAs9FeX1XHnuwT3N1MCmpQDcKDJyW8u2/OZlKn9RAnoUvqMRXP0xTwNAmA==
Received: from BN9PR03CA0402.namprd03.prod.outlook.com (2603:10b6:408:111::17)
 by SA1PR22MB5553.namprd22.prod.outlook.com (2603:10b6:806:3dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 23:06:15 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:111:cafe::c) by BN9PR03CA0402.outlook.office365.com
 (2603:10b6:408:111::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Tue,
 11 Aug 2026 23:06:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 74.117.212.83)
 smtp.mailfrom=selinc.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=selinc.com;
Received-SPF: Pass (protection.outlook.com: domain of selinc.com designates
 74.117.212.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=74.117.212.83; helo=email.selinc.com; pr=C
Received: from email.selinc.com (74.117.212.83) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Tue, 11 Aug 2026 23:06:14 +0000
Received: from LOGAFINLPC.ad.selinc.com (10.100.90.200) by
 wpul-exchange.ad.selinc.com (10.53.14.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 16:06:02 -0700
From: Logan Finley <logan_finley@selinc.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>, <clm@fb.com>, Logan Finley <logan_finley@selinc.com>
Subject: [RFC PATCH] btrfs: Write as many copies as possible if the current RAID1 profile is unreachable
Date: Tue, 11 Aug 2026 16:04:28 -0700
Message-ID: <20260811230427.4059275-1-logan_finley@selinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|SA1PR22MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 71276b83-af74-4ed6-0c5f-08def7fd249a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|23010399003|18002099003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+RRShJBkQd1xnsYMUEXUtfpyV8fV97uI6zZXgITcfOcTWYNofhUJP2L0xSFw57XqNRozeY5aF8MHC6XsChWS1f97tkI1sSBjSVjfaUueLrD2WU32YPNschYV8qfEcWYwcJKaNFh26j8Q4VwqxtaTBkAHYHYpzG6qlDtISvqx2jltmb4tF2FKLlEL/RSjhzEAQtUXTBZr1RZ4pFK5Jp5HNkN8wuYIRPMVqor+nMCj1PvZc2+zRc0ikGAWOPTBUAzlyw4nPOf8XRqkJWnNxBBGhpAfYQGaR9SlmhOFnuG6MsXMgL/XbepTjWdbI6Nc9/ubP9ERp/gzMli+OS6Ye1nO612JBSuRpQN+buMkzZNhTDa22hHI2XhGMReb7BkqliP+y2TUPDIhwYylYFqFHsEWjr9El7/FjhLDWfWaMijRRkuC+bhzsWEhn6rJeKA/fbRdInr7nKnO6CBiL1vI+42kn99yoZjzK9M6BGTkkT4FkKVnDGnLrF/5+7nYlUu7adPcZU4rKKiVqY3zb5tfRw2xS6SiBLp35UGLaz+rbLB+MrYexGnfNQ0Y7w6a+CdaBDVPrsFQ4IQgT8LaqWnd7lbK4N4o5Nu4K6Fp3qMUrp9BEhFEZ4vgwetcUVaXv/pededjEMZZ0q9uDbGZgXm0DVYgumd1aW/Q/uLA3TToTdHFjKfZeI8jdBfW8Uv6dKm489OmbSYRh8vpeGuUIw1joL7wVA==
X-Forefront-Antispam-Report:
	CIP:74.117.212.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:email.selinc.com;PTR:wpul-exchange1.selinc.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(23010399003)(18002099003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ChhAszmhP1aKYs3ucnz8NOSELGT6yzemOWtpjrDH0uP2TZf2tt7Cm3uRH95e+V8AIep78kE6dZ8gJ/qBeDllMytIKZEWEy9/xfexikar6jaTFyHXYOlwrINLOINt5TOU0Tky522VAetQfUlZUZ5FvC2XH0r2Gul2K57wPVpyJ7Co7WK2xMLBQdN2bMW8VKa6+opO7cPko4eiqWRSxfs+TzTJAv8ULOG/TJEhEizHzagfBpEWQ71tuQl6RspE/kOCQzgB9Bjm7cZcQ+Q0RzFES1AryyzI3nzAWsSANDTn5VuKKV653MnaIgyRolTiciz36AGmzUTrB2BNYa+1HWZb4gTdQ1sOKiVJ2SLHvTiB2NGEPMXAzhbkTkY2OQw/E39VBnjE20KLCaEKAHUpicgaHQBF5rXs43PQ6kr/qLBcTjEmabpEp9+OkFI8Bhk1dy1l
X-OriginatorOrg: selinc.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 23:06:14.4418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71276b83-af74-4ed6-0c5f-08def7fd249a
X-MS-Exchange-CrossTenant-Id: 12381f30-10fe-4e2c-aa3a-5e03ebeb59ec
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=12381f30-10fe-4e2c-aa3a-5e03ebeb59ec;Ip=[74.117.212.83];Helo=[email.selinc.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR22MB5553

While testing a three-disk btrfs filesystem consisting of only RAID1C3
block groups, I noticed that if I unmounted the filesystem, wiped one of
the disks, and then remounted the filesystem from the remaining two disks
with `-o degraded`, after a certain point new data begins to be written
into a "single" block group.

It appears that some data is initially written into the existing RAID1C3
chunks, but once enough data is written such that a new chunk needs to
be allocated, the next chunk allocated uses the "single" profile.

I'm not sure of a good way to fill up the System and Metadata block groups
enough to trigger a new chunk to be allocated, so I wasn't able to see
whether they also allocate "single"-profile chunks.

This was unexpected, since, to me, one of the benefits of RAID1C3 was more
time to keep operating safely (albeit in a degraded state) while an
operator makes their way to a machine to physically replace the failed
disk. With the current behavior, it seems that this isn't a valid use case
because any further disk failure could lead to the loss of newly written
data.

This (admittedly naive) patch modifies this behavior so that the RAID1
family of profiles writes as many copies as possible in a degraded state
when there are not enough disks present to write data in the configured
RAID profile.

Signed-off-by: Logan Finley <logan_finley@selinc.com>
---
What I'm looking for is feedback on whether this sort of patch is
desired upstream, whether the approach is valid, and whether or not
there are any gotchas I may have missed in the implementation.

Testing was done on an x86_64 qemu vm at commit a13307e97d5c ("Merge tag
'bpf-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf")
on the kdave/linux tree.
---
 fs/btrfs/block-group.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8def7abb728f..50a21a0d8765 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -176,6 +176,12 @@ u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
 			flags |= fs_info->avail_metadata_alloc_bits;
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
+	/* Degrade to a less redundant, but still redundant, RAID1 profile if possible. */
+	if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
+		flags |= BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
+		flags |= BTRFS_BLOCK_GROUP_RAID1;
+
 	return btrfs_reduce_alloc_profile(fs_info, flags);
 }
 
-- 
2.34.1
