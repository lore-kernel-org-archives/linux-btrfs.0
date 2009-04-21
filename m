From: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 0/2] Trivial warning fixes.
Date: Tue, 21 Apr 2009 12:38:28 -0700
Message-ID: <1240342710-19009-1-git-send-email-joel.becker@oracle.com>
Cc: chris.mason@oracle.com, lmb@suse.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So I fired up my ia64 compile to check on some ocfs2 warning fixes, and
btrfs ones dropped out.  You can have 'em if you want 'em, I don't know
what the btrfs policy is here.  Simple stuff, mostly %llu vs u64.

You can also pull from:

git://oss.oracle.com/git/jlbec/linux-2.6.git btrfs-warnings

Joel


