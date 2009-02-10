From: Aaron Straus <aaron@merfinllc.com>
Subject: Re: [PATCH] start work on delete snapshot code
Date: Tue, 10 Feb 2009 12:27:52 -0800
Message-ID: <20090210202752.GB20942@merfinllc.com>
References: <1234224453-4227-1-git-send-email-aaron@merfinllc.com> <loom.20090210T194303-716@post.gmane.org> <20090210195730.GA20942@merfinllc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michele Petrazzo <michele.petrazzo@unipex.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090210195730.GA20942@merfinllc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 10 11:57 AM, Aaron Straus wrote:
>   Thanks for the traceback, I'll look into it tonight and try to figure
> out what went wrong.

Hi,

  Actually that's an easy one.  That's a bad way of saying file not
found i.e. you tried to delete a snapshot that wasn't there.  Please
apply the following patch on top of the previous one.

  Thanks!

				=a=


-- 
===================
Aaron Straus
aaron@merfinllc.com

---

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6e09873..496e8d6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -787,6 +787,12 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	mutex_unlock(&dir->d_inode->i_mutex);
 
+	if (!inode) {
+		printk(KERN_INFO "btrfs:  snapshot not found\n");
+		ret = -ENOENT;
+		goto out_dput;
+	}
+
 	/* (1) locks needed? */
 	if (!(inode->i_mode & S_IFDIR)) {
 		printk(KERN_INFO "btrfs: not directory\n");
