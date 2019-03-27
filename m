Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6A4C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 07:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2072075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 07:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfC0HZK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 03:25:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbfC0HZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 03:25:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F6CCADC7
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 07:25:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH URGENT 2/2] btrfs-progs: disk-io: Flush to ensure super block write is FUA
Date:   Wed, 27 Mar 2019 15:25:00 +0800
Message-Id: <20190327072500.11156-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327072500.11156-1-wqu@suse.com>
References: <20190327072500.11156-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
There are tons of reports of btrfs-progs screwing up the fs, the most
recent one is "btrfs check --clear-space-cache v1" triggered BUG_ON()
and then leaving the fs with transid mismatch problem.

[CAUSE]
In kernel, we have block layer handing the flush work, even on devices
without FUA support (like most SATA device using default libata
settings), kernel handles FUA write by flushing the device, then normal
write, and finish it with another flush.

The pre-flush, write, post-flush works pretty well to implement FUA
write.

However in btrfs-progs we just use pwrite(), there is nothing keeping
the write order.

So even for basic v1 free space cache clearing, we have different vision
on the write sequence from kernel bio layer (by dm-log-writes) and user
space pwrite() calls.

In btrfs-progs, with extra debug output in write_tree_block() and
write_dev_supers(), we can see btrfs-progs follows the right write
sequence:

  Opening filesystem to check...
  Checking filesystem on /dev/mapper/log
  UUID: 3feb3c8b-4eb3-42f3-8e9c-0af22dd58ecf
  write tree block start=1708130304 gen=39
  write tree block start=1708146688 gen=39
  write tree block start=1708163072 gen=39
  write super devid=1 gen=39
  write tree block start=1708179456 gen=40
  write tree block start=1708195840 gen=40
  write super devid=1 gen=40
  write tree block start=1708130304 gen=41
  write tree block start=1708146688 gen=41
  write tree block start=1708228608 gen=41
  write super devid=1 gen=41
  write tree block start=1708163072 gen=42
  write tree block start=1708179456 gen=42
  write super devid=1 gen=42
  write tree block start=1708130304 gen=43
  write tree block start=1708146688 gen=43
  write super devid=1 gen=43
  Free space cache cleared

But from dm-log-writes, the bio sequence is a different story:

  replaying 1742: sector 131072, size 4096, flags 0(NONE)
  replaying 1743: sector 128, size 4096, flags 0(NONE) <<< Only one sb write
  replaying 1744: sector 2828480, size 4096, flags 0(NONE)
  replaying 1745: sector 2828488, size 4096, flags 0(NONE)
  replaying 1746: sector 2828496, size 4096, flags 0(NONE)
  replaying 1787: sector 2304120, size 4096, flags 0(NONE)
  ......
  replaying 1790: sector 2304144, size 4096, flags 0(NONE)
  replaying 1791: sector 2304152, size 4096, flags 0(NONE)
  replaying 1792: sector 0, size 0, flags 8(MARK)

During the free space cache clearing, we committed 3 transaction but
dm-log-write only caught one super block write.

This means all the 3 writes were merged into the last super block write.
And the super block write was the 2nd write, before all tree block
writes, completely screwing up the metadata CoW protection.

No wonder crashed btrfs-progs can make things worse.

[FIX]
Fix this super serious problem by implementing pre and post flush for
the primary super block in btrfs-progs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 238b1821be14..275ccff965e2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1585,6 +1585,16 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 	u32 crc;
 	int i, ret;
 
+	/*
+	 * We need to write super block after all metadata written.
+	 * This is the equivalent of kernel pre-flush for FUA.
+	 */
+	ret = fsync(device->fd);
+	if (ret < 0) {
+		error("failed to flush: %m");
+		ret = -errno;
+		goto write_err;
+	}
 	if (fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		btrfs_set_super_bytenr(sb, fs_info->super_bytenr);
 		crc = ~(u32)0;
@@ -1605,6 +1615,12 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 			error("failed to write super block: %m");
 			goto write_err;
 		}
+		ret = fsync(device->fd);
+		if (ret < 0) {
+			error("failed to flush: %m");
+			ret = -errno;
+			goto write_err;
+		}
 		return 0;
 	}
 
@@ -1632,6 +1648,18 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 			error("failed to write super block %i: %m", i);
 			goto write_err;
 		}
+		/*
+		 * Flush after the primary sb write, this is the equivalent of
+		 * kernel post-flush for FUA write.
+		 */
+		if (i == 0) {
+			ret = fsync(device->fd);
+			if (ret < 0) {
+				error("failed to flush: %m");
+				ret = -errno;
+				goto write_err;
+			}
+		}
 	}
 
 	return 0;
-- 
2.21.0

