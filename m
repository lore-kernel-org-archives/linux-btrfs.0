Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54800 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3EKLNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 07:13:00 -0400
Received: by mail-ea0-f177.google.com with SMTP id o10so2615748eaj.36
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 04:12:59 -0700 (PDT)
Message-ID: <518E27B6.2040600@gmail.com>
Date: Sat, 11 May 2013 13:12:54 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>,
        Remco Hosman - Yerf IT <remco@yerf-it.nl>
CC: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH RESEND 1/2] Minor format cleanup.
References: <cover.1360786935.git.philipp.andreas@gmail.com>, <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: 518E278D.6070508@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean up the format of the definitions of BTRFS_BLOCK_GROUP_RAID5 and
BTRFS_BLOCK_GROUP_RAID6.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e3a4fd7..ea688aa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -954,8 +954,8 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
-#define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
-#define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
+#define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
+#define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 #define BTRFS_NR_RAID_TYPES		7
 -- 1.7.12.4

