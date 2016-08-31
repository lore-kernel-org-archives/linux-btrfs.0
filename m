Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753891AbcHaVtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 17:49:31 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0369283F40
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 21:49:31 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u7VLnT2c018860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 17:49:30 -0400
Subject: [PATCH V2] btrfs: fix perms on demonstration debugfs interface
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <13cedfd1-1eb2-6097-6f12-48e387042b9b@redhat.com>
Date: Wed, 31 Aug 2016 16:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs provides a helpful demonstration of how to export
a global variable via debugfs; however, it is unique among
other debugfs files in that it is world-writable, which causes
some concern to people who are not familiar with its purpose.

Fix it so that it is only user-writable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4879656..fb84685 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -834,7 +834,7 @@ static int btrfs_init_debugfs(void)
 	if (!btrfs_debugfs_root_dentry)
 		return -ENOMEM;
 
-	debugfs_create_u64("test", S_IRUGO | S_IWUGO, btrfs_debugfs_root_dentry,
+	debugfs_create_u64("test", S_IRUGO | S_IWUSR, btrfs_debugfs_root_dentry,
 			&btrfs_debugfs_test);
 #endif
 	return 0;

