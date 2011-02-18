From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with large max_sectors_kb
Date: Fri, 18 Feb 2011 15:18:51 -0500
Message-ID: <1298059754-sup-2258@think>
References: <bug-29302-10286@https.bugzilla.kernel.org/> <20110217153719.9ecc67df.akpm@linux-foundation.org> <20110218174315.GD5615@twin.jikos.cz> <1298056463-sup-4453@think> <20110218115603.5f235b07.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Cc: David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	bugzilla-daemon <bugzilla-daemon@bugzilla.kernel.org>,
	bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
	fox <fox@murder.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110218115603.5f235b07.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrew Morton's message of 2011-02-18 14:56:03 -0500:
> On Fri, 18 Feb 2011 14:16:12 -0500
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > Are there any more kernel messages involved before the oops starts? 
> 
> The full dmesg is in bugzilla. https://bugzilla.kernel.org/show_bug.cgi?id=29302

Ok, so it isn't part of the open devices code that prints errors, my
guess is we're failing to read a good super.

Could you please mkfs.btrfs /dev/xxx, sync, then btrfsck /dev/xxx, I want
to make sure things are really getting written.

Here's a patch that makes sure we have a good bdev after scanning,
hopefully it will let us debug things without your box going boom.

-chris

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d39a989..d8f7ee0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -757,6 +757,10 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	tree_root->fs_info = fs_info;
 
 	bdev = fs_devices->latest_bdev;
+	if (!bdev) {
+		printk(KERN_CRIT "btrfs read devices failed on %s\n", dev_name);
+		goto error_close_devices;
+	}
 	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
 	if (IS_ERR(s))
 		goto error_s;
