Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B6FC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D532087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jH9FB/nl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7D532087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJMDIY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33654 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDIX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id q40-v6so15087091qte.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=CmIQJ2t4XtqsjVffqXoBO7xUxEc9XCxX0h3fJq21XS8=;
        b=jH9FB/nllsXsHUyfQHofb/3U/Dtctfx5CW99Q/6QH/tcS8jmT0xgWwdrS+Z5gIk6AL
         j2ti7iuUv2XPLavGOlWFYQCxGpv80PQg/Jy/sAZXq6Odk/p8RBH9K9OdKhISHrQis8CB
         Pd4f9Nv1Y2UHlhpeMN5ooPLZ5D5IwKk6kLjoHDlqvjgXg/ApjVXjJPhkx7yU5qtB/QZc
         tpayMVGy/qdIhylD+3cqTsuM3rOPTvyMDEDzjRpjk1Ns70TL8ncn9L69UgwkaOdn20rf
         lTzJ711kHC51RrlOv/RbHq6rKDqvGsVzjL9Q1hZDRMvJcCeOAITTrGSFb7HXTiMv9Sp5
         cJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=CmIQJ2t4XtqsjVffqXoBO7xUxEc9XCxX0h3fJq21XS8=;
        b=OQ15B+C+Lj92Ve0smFHwTD6F10gPYPRmcJk26ehNTY+WZEelc6+NoESjNIv+nPSBn9
         05hnbvMP7PnvL1IOO2jLt2j7g2R65XFc5MeG+EoQ29DFQM6GOrpFuVeO9+8LFoTYjMEh
         EoWze9FJJSADwQNyEIqgPkwFn4tEpLa0MAKNd4RhW4dCxRyFh0gcWnD7vsuiIJj2pdrq
         EmQ3BLPNl9p51yC16dHMeRnFPr9LInrSq4ebNGEGNQrKAjBisSEuOiTQu5HtgFfybZwp
         jqABc5K7E+l6oYaIr2BLpVa8O5WhadfQdgTycKZiF9JX/5oqnI2wJVWI773SNtTmYpAd
         C02A==
X-Gm-Message-State: ABuFfohCOvWw6c3cDnqbuE2x1x/QhCLpa+UR4RKrvEuDCp9RQ6b6Ev0w
        y9xev14XXAcfQYvLwQUzSyoKF+x0nZk=
X-Google-Smtp-Source: ACcGV63ft6QL35tMqzHOQdH5Z/94Jrfmz3R6Y82O+6UE7I0O45xMAwvSv4ug1lZWSGQkUTagEJdhBA==
X-Received: by 2002:a0c:b62c:: with SMTP id f44-v6mr7531092qve.184.1539372861952;
        Fri, 12 Oct 2018 12:34:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y26-v6sm1256695qty.52.2018.10.12.12.34.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 36/42] btrfs: wait on caching when putting the bg cache
Date:   Fri, 12 Oct 2018 15:32:50 -0400
Message-Id: <20181012193256.13735-37-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While testing my backport I noticed there was a panic if I ran
generic/416 generic/417 generic/418 all in a row.  This just happened to
uncover a race where we had outstanding IO after we destroy all of our
workqueues, and then we'd go to queue the endio work on those free'd
workqueues.  This is because we aren't waiting for the caching threads
to be done before freeing everything up, so to fix this make sure we
wait on any outstanding caching that's being done before we free up the
block group, so we're sure to be done with all IO by the time we get to
btrfs_stop_all_workers().  This fixes the panic I was seeing
consistently in testing.

------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:6112!
SMP PTI
Modules linked in:
CPU: 1 PID: 27165 Comm: kworker/u4:7 Not tainted 4.16.0-02155-g3553e54a578d-dirty #875
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Workqueue: btrfs-cache btrfs_cache_helper
RIP: 0010:btrfs_map_bio+0x346/0x370
RSP: 0000:ffffc900061e79d0 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff880071542e00 RCX: 0000000000533000
RDX: ffff88006bb74380 RSI: 0000000000000008 RDI: ffff880078160000
RBP: 0000000000000001 R08: ffff8800781cd200 R09: 0000000000503000
R10: ffff88006cd21200 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8800781cd200 R15: ffff880071542e00
FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000817ffc4 CR3: 0000000078314000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 btree_submit_bio_hook+0x8a/0xd0
 submit_one_bio+0x5d/0x80
 read_extent_buffer_pages+0x18a/0x320
 btree_read_extent_buffer_pages+0xbc/0x200
 ? alloc_extent_buffer+0x359/0x3e0
 read_tree_block+0x3d/0x60
 read_block_for_search.isra.30+0x1a5/0x360
 btrfs_search_slot+0x41b/0xa10
 btrfs_next_old_leaf+0x212/0x470
 caching_thread+0x323/0x490
 normal_work_helper+0xc5/0x310
 process_one_work+0x141/0x340
 worker_thread+0x44/0x3c0
 kthread+0xf8/0x130
 ? process_one_work+0x340/0x340
 ? kthread_bind+0x10/0x10
 ret_from_fork+0x35/0x40
Code: ff ff 48 8b 4c 24 28 48 89 de 48 8b 7c 24 08 e8 d1 e5 04 00 89 c3 e9 08 ff ff ff 4d 89 c6 49 89 df e9 27 fe ff ff e8 5a 3a bb ff <0f> 0b 0f 0b e9 57 ff ff ff 48 8b 7c 24 08 4c 89 f9 4c 89 ea 48
RIP: btrfs_map_bio+0x346/0x370 RSP: ffffc900061e79d0
---[ end trace 827eb13e50846033 ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b5366932298..4bacb5042d08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9894,6 +9894,7 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 
 		block_group = btrfs_lookup_first_block_group(info, last);
 		while (block_group) {
+			wait_block_group_cache_done(block_group);
 			spin_lock(&block_group->lock);
 			if (block_group->iref)
 				break;
-- 
2.14.3

