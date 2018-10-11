Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B854C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6570B20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="v/Ttiglt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6570B20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbeJLDY1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:27 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43913 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDY1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id q41-v6so11337394qtq.10
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=91liZIK+wxIF7dRdH1otjGSMGHeQwahR4ZLfPo8AmG8=;
        b=v/TtigltNv8iu0A4OOER5xeVDELJDu+ylZUhS/Y0Eo2MtY+2ODahH2ZKfEj6ZcnxrF
         35S2HvDSeyPIKhAqV2B76rV1G0AgCgc2JdeWLVSNnWi2z6sfNHaOxM8bjbeBlcQfZHtj
         XMqddfcf0YENay4onUheOzOCQotpxnKuNkdSnXBk3MgTjxXqOPvIFbp6A1KIa7qXp2DA
         RPoKnjEIobPNYAwDsg3OeM7yEEigBD7fObqPvR91oKbnDXXrYTDpz5Z/+LfySXzOiznJ
         4DEUwq68qgUor/bGVjYkd+AN5FZdQmtMXi/XUo5fPvuQYxIdEbvS0yyq/QPHL7yzpyQd
         WbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=91liZIK+wxIF7dRdH1otjGSMGHeQwahR4ZLfPo8AmG8=;
        b=AJGS9d3g7Wmnmwfy1JAFpkIbx/syRd92VNzIVWKKIsXku3vXJ9e/1OADAyQoL4j9It
         tuqncgMrS1XdD9sDO8WFknuMjLMo0zhRbWfYvBOcvNZ07/qyAcf/f8GG8Qd8iwM6/pEY
         L9Ry2KNsSgTPhcKixEBGS5IcFtjomU50/Y2S749FgrIuOUqvnDsPJAuSacCaTnIAMnMF
         voC/JzZ9K239fVxMZs2NRIECCGeSV28mCzzU4FROTqIZCUVD0YUWPIpQM9urThC/d52l
         h1rqzwYpQfA03jLdfKczl0jjKIaRoY+y3NUoE5PYFMHJv3QTitR/IvlTvbZ0456LaV5d
         y00Q==
X-Gm-Message-State: ABuFfohV7jPrQNhsZ35YfWkK1Na33c6/ciDnnR/z6D7lJi7iBmaRdHEZ
        RpJAtCnuxESzgE2y41hqn3RxAQ==
X-Google-Smtp-Source: ACcGV62d8xlbIahJXMdbeEBhKdCju+vZsZBjE2S7VmmaXocH0iZxSSCbSNC8UDdrqKO0k7TYWm9nPQ==
X-Received: by 2002:aed:25d1:: with SMTP id y17-v6mr2954267qtc.217.1539287741071;
        Thu, 11 Oct 2018 12:55:41 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s17-v6sm16895967qtj.31.2018.10.11.12.55.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:40 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 36/42] btrfs: wait on caching when putting the bg cache
Date:   Thu, 11 Oct 2018 15:54:25 -0400
Message-Id: <20181011195431.3441-37-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 6174d1b7875b..4b74d8a97f7c 100644
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

