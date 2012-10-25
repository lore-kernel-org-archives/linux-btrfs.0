Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64612 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2JYLid (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 07:38:33 -0400
Message-ID: <508924AB.4060902@gmail.com>
Date: Thu, 25 Oct 2012 17:08:19 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [RESEND PATCH] fs/super.c set_anon_super calling optimization
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com>
In-Reply-To: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
set_anon_super is called by many filesystems. Some call directly and 
some call through the wrapper. Many of them in the wrapper's call to 
this function are passing the second argument to this function which is 
not used anywhere.

This patch replaces the second variable with NULL.

Thanks,
Abhijit Pawar

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org

---

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 137d503..132db90 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -61,7 +61,7 @@ static const struct super_operations v9fs_super_ops,
v9fs_super_ops_dotl;
static int v9fs_set_super(struct super_block *s, void *data)
{
         s->s_fs_info = data;
-       return set_anon_super(s, data);
+       return set_anon_super(s, NULL);
}

/**
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..c9994a3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -954,7 +954,7 @@ static int btrfs_test_super(struct super_block *s, void
*data)

static int btrfs_set_super(struct super_block *s, void *data)
{
-       int err = set_anon_super(s, data);
+       int err = set_anon_super(s, NULL);
         if (!err)
                 s->s_fs_info = data;
         return err;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e831bce..486bf7a 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2260,7 +2260,7 @@ static int nfs_set_super(struct super_block *s, void
*data)
         s->s_flags = sb_mntdata->mntflags;
         s->s_fs_info = server;
         s->s_d_op = server->nfs_client->rpc_ops->dentry_ops;
-       ret = set_anon_super(s, server);
+       ret = set_anon_super(s, NULL);
         if (ret == 0)
                 server->s_dev = s->s_dev;
         return ret;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 71eb7e2..56d0059 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -89,7 +89,7 @@ static int sysfs_test_super(struct super_block *sb, void
*data)
static int sysfs_set_super(struct super_block *sb, void *data)
{
         int error;
-       error = set_anon_super(sb, data);
+       error = set_anon_super(sb, NULL);
         if (!error)
                 sb->s_fs_info = data;
         return error;

