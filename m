Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37401 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbeDSAAd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 20:00:33 -0400
Date: Wed, 18 Apr 2018 17:00:29 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Cc: linux-fsdevel@vger.kernel.org
Subject: d_instantiate() and unlock_new_inode() order in btrfs_mkdir()
Message-ID: <20180419000029.GA133757@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris and other btrfs folks,

btrfs_mkdir() calls d_instantiate() before unlock_new_inode(), which is wrong
because it exposes the inode to lookups before it's been fully initialized.
Most filesystems get it right, but f2fs and btrfs don't.  I sent a f2fs patch
(https://marc.info/?l=linux-fsdevel&m=152409178431350) and was going to send a
btrfs patch too, but in btrfs_mkdir() there is actually a comment claiming that
the existing order is intentional:

        d_instantiate(dentry, inode);
        /*
         * mkdir is special.  We're unlocking after we call d_instantiate
         * to avoid a race with nfsd calling d_instantiate.
         */
        unlock_new_inode(inode);

Unfortunately, I cannot find what it is refering to.  The comment was added by
commit b0d5d10f41a0 ("Btrfs: use insert_inode_locked4 for inode creation").
Chris, do you remember exactly what you had in mind when you wrote this?

And in case anyone wants it, here's a reproducer for the deadlock caused by the
current code that calls d_instantiate() before unlock_new_inode().  Note: it
needs CONFIG_DEBUG_LOCK_ALLOC=y.

	#include <sys/stat.h>
	#include <unistd.h>

	int main()
	{
		struct stat stbuf;

		if (fork() == 0) {
			for (;;)
				stat("dir/file", &stbuf);
		} else {
			for (;;) {
				mkdir("dir", 0777);
				stat("dir/file", &stbuf);
				rmdir("dir");
			}
		}
	}
