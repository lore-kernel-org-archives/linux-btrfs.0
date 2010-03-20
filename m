From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/3] btrfs: handle kmalloc() failure
Date: Sat, 20 Mar 2010 14:24:15 +0300
Message-ID: <20100320112415.GW5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Return -ENOMEM if kmalloc() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 15f661d..be9b5df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1212,6 +1212,9 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 		return -EPERM;
 
 	args = kmalloc(sizeof(*args), GFP_KERNEL);
+	if (!args)
+		return -ENOMEM;
+
 	if (copy_from_user(args, argp, sizeof(*args))) {
 		kfree(args);
 		return -EFAULT;
