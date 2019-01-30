Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F02C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 13:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C7C20833
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 13:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbfA3Nyc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:54:32 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52424 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731018AbfA3Nyc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 08:54:32 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1goqJy-00074B-OG; Wed, 30 Jan 2019 06:54:30 -0700
Received: from ip68-227-174-240.om.om.cox.net ([68.227.174.240] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1goqJo-0000WK-8T; Wed, 30 Jan 2019 06:54:30 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, <linux-fsdevel@vger.kernel.org>
Date:   Wed, 30 Jan 2019 07:54:12 -0600
Message-ID: <87lg32p7y3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1goqJo-0000WK-8T;;;mid=<87lg32p7y3.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.240;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+NRWCNMOjN7f6HxY37fP9v+ISbT1YRFpk=
X-SA-Exim-Connect-IP: 68.227.174.240
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] fs/btrfs: On error always free subvol_name in btrfs_mount
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


The subvol_name is allocated in btrfs_parse_subvol_options and is
consumed and freed in mount_subvol.  Add a free to the error paths that
don't call mount_subvol so that it is guaranteed that subvol_name is
freed when an error happens.

Fixes: 312c89fbca06 ("btrfs: cleanup btrfs_mount() using btrfs_mount_root()")
Cc: stable@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5586ffd1426..0a3f122dd61f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1621,6 +1621,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 				flags | SB_RDONLY, device_name, data);
 			if (IS_ERR(mnt_root)) {
 				root = ERR_CAST(mnt_root);
+				kfree(subvol_name);
 				goto out;
 			}
 
@@ -1630,12 +1631,14 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 			if (error < 0) {
 				root = ERR_PTR(error);
 				mntput(mnt_root);
+				kfree(subvol_name);
 				goto out;
 			}
 		}
 	}
 	if (IS_ERR(mnt_root)) {
 		root = ERR_CAST(mnt_root);
+		kfree(subvol_name);
 		goto out;
 	}
 
-- 
2.17.1

