Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5F4C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383D22184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfCNQLI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfCNQLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 12:11:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2AF43307D85A;
        Thu, 14 Mar 2019 16:11:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-148.rdu2.redhat.com [10.10.121.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98D5E1001E63;
        Thu, 14 Mar 2019 16:11:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 16/38] vfs: Convert btrfs_test to fs_context
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Mar 2019 16:11:04 +0000
Message-ID: <155257986484.13720.17532595013012451617.stgit@warthog.procyon.org.uk>
In-Reply-To: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
References: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 14 Mar 2019 16:11:07 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chris Mason <clm@fb.com>
cc: Josef Bacik <josef@toxicpanda.com>
cc: David Sterba <dsterba@suse.com>
cc: linux-btrfs@vger.kernel.org
---

 fs/btrfs/tests/btrfs-tests.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 8a59597f1883..dabd43a37414 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -5,6 +5,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/fs_context.h>
 #include <linux/magic.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
@@ -22,17 +23,17 @@ static const struct super_operations btrfs_test_super_ops = {
 	.destroy_inode	= btrfs_test_destroy_inode,
 };
 
-static struct dentry *btrfs_test_mount(struct file_system_type *fs_type,
-				       int flags, const char *dev_name,
-				       void *data)
+
+static int btrfs_test_init_fs_context(struct fs_context *fc)
 {
-	return mount_pseudo(fs_type, "btrfs_test:", &btrfs_test_super_ops,
-			    NULL, BTRFS_TEST_MAGIC);
+	return vfs_init_pseudo_fs_context(fc, "btrfs_test:",
+					  &btrfs_test_super_ops, NULL,
+					  NULL, BTRFS_TEST_MAGIC);
 }
 
 static struct file_system_type test_type = {
 	.name		= "btrfs_test_fs",
-	.mount		= btrfs_test_mount,
+	.init_fs_context = btrfs_test_init_fs_context,
 	.kill_sb	= kill_anon_super,
 };
 

