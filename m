Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DAAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 326822075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732987AbfC0XnC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:43:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731002AbfC0XnB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 19:43:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9ECACDBD9E;
        Wed, 27 Mar 2019 23:43:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C45860C18;
        Wed, 27 Mar 2019 23:42:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 19/68] vfs: Convert btrfs_test to use the new mount API
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Date:   Wed, 27 Mar 2019 23:42:58 +0000
Message-ID: <155373017856.7602.13957875777837118321.stgit@warthog.procyon.org.uk>
In-Reply-To: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
References: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 27 Mar 2019 23:43:01 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Convert the btrfs_test filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: David Sterba <dsterba@suse.com>
cc: Chris Mason <clm@fb.com>
cc: Josef Bacik <josef@toxicpanda.com>
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
 

