From: Josef Bacik <josef@redhat.com>
Subject: Btrfs: fix dentry->d_parent abuses V2
Date: Fri, 19 Nov 2010 15:36:08 -0500
Message-ID: <1290198971-21663-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph pointed out that my original d_parent cleanup patch was big and hard
to review since it really did 3 seperate things. The cleanup is broke up like
this

1) For places we have to use dentry->d_parent, use dget_parent/dput
2) For places where we already have the parent inode anyway, use that instead
3) A small safety fix for btrfs_log_dentry_safe

These patches make up the original patch that I posted, and have been tested
with xfstests, and have been in my tree for 2 weeks with all of the other work
I've been doing and have survived fine.  Thanks,

Josef
