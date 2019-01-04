Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77534C43612
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D53A21874
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546608326;
	bh=9GJC9Is4E7F/+Qn5rONzv9AFHdgVCETsJdbrtMzH7DQ=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Rto8kIpxmdt9AecdWAWqKlbUQUqY683Bh+4rzvKiRLJdoygp1vSffQXCKfuDGS4U4
	 xxpEbJRkSiZso9msbS//QFZNUUG7+3KZ2odsVOuBlgJyTduN7uTTf+S1cHJ//oOuSY
	 3jbZ8/m2y3+7a5s7AAlYpwPqbCH1AkgwEwZEhaE4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfADNZZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfADNZY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 08:25:24 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A27B21871;
        Fri,  4 Jan 2019 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546608323;
        bh=9GJC9Is4E7F/+Qn5rONzv9AFHdgVCETsJdbrtMzH7DQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Ae1Ki+Oph1u5X3PrGvFdWj8Y1orP+4+TWOf0rmKsJsRAbLeab3ZjVV3efLx5G8ibC
         E76hTcm8y/T3LkGxMga7AbfNgOfjQnBgk7dc5L9lEHKCcshH8Pgytug5xegEZXkDfO
         6vHCK7IF7CLLcocccnsZnHKpUICB8A7fkzZi10BM=
Date:   Fri, 4 Jan 2019 14:25:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: no need to check return value of debugfs_create
 functions
Message-ID: <20190104132520.GA22613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Meta-comment, why is there a btrfs debugfs directory at all?  All you
have here is a single "test" file that doesn't do anything except expose
a variable that never changes.  What is this directory and single file
for?  Can I just delete the whole thing?


diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5a5930e3d32b..38cbb2076d6c 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -905,12 +905,10 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
 }
 
-static int btrfs_init_debugfs(void)
+static void btrfs_init_debugfs(void)
 {
 #ifdef CONFIG_DEBUG_FS
 	btrfs_debugfs_root_dentry = debugfs_create_dir("btrfs", NULL);
-	if (!btrfs_debugfs_root_dentry)
-		return -ENOMEM;
 
 	/*
 	 * Example code, how to export data through debugfs.
@@ -924,7 +922,6 @@ static int btrfs_init_debugfs(void)
 #endif
 
 #endif
-	return 0;
 }
 
 int __init btrfs_init_sysfs(void)
@@ -935,9 +932,7 @@ int __init btrfs_init_sysfs(void)
 	if (!btrfs_kset)
 		return -ENOMEM;
 
-	ret = btrfs_init_debugfs();
-	if (ret)
-		goto out1;
+	btrfs_init_debugfs();
 
 	init_feature_attrs();
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
@@ -954,7 +949,6 @@ int __init btrfs_init_sysfs(void)
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 out2:
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
-out1:
 	kset_unregister(btrfs_kset);
 
 	return ret;
-- 
2.20.1

