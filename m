Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55646 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964948Ab2EOWMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 May 2012 18:12:12 -0400
Date: Wed, 16 May 2012 00:12:04 +0200
From: David Sterba <dave@jikos.cz>
To: Avi Kivity <avi.kivity@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, dave@jikos.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: Problems with nodatacow/nodatasum
Message-ID: <20120515221204.GE24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
 <20120420091250.GK20982@twin.jikos.cz>
 <CAEbWaiqfh9KBM5U0QtqULHwLed854MeY=cPSxWRhoEGND9ve0A@mail.gmail.com>
 <20120421001551.GL30599@shiny>
 <CAEbWairER0P4eA299E7vizH5ZA-nHPv0ze8V_LF8dd=bPPgByQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEbWairER0P4eA299E7vizH5ZA-nHPv0ze8V_LF8dd=bPPgByQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 13, 2012 at 08:51:53PM +0300, Avi Kivity wrote:
> On Sat, Apr 21, 2012 at 3:15 AM, Chris Mason <chris.mason@oracle.com> wrote:
> >>
> >> Are there plans to allow per-subvolume nodatasum/nodatacow?
> >
> > It can be set on a per file basis, let me push out a commit to btrfs
> > progs with ioctls to set it.
> 
> Did this not happen, or am I barking up the wrong btrfs-progs.git tree?

Taking minimalistic approach, the following patch allows to enable true
NOCOW feature on a file (limted to files of 0 size), no specific mount
options are needed.

Tested on a ~350MB file, filled with /dev/urandom, then randomly
rewritten with zeros, filefrag output is same before and after the
operation.

Please note that due to the simplicity of implementation, only a
zero-sized file really becomes NOCOW, but in fact this mimics what
creating a file under -o nodatacow will produce.

The change is done by setting NOCOW attribute, with patched chattr
http://www.spinics.net/lists/linux-btrfs/msg09605.html
(or using the ioctl directly)


david


---
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -234,10 +234,22 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
                ip->flags |= BTRFS_INODE_DIRSYNC;
        else
                ip->flags &= ~BTRFS_INODE_DIRSYNC;
-       if (flags & FS_NOCOW_FL)
+       if (flags & FS_NOCOW_FL) {
                ip->flags |= BTRFS_INODE_NODATACOW;
-       else
+               /*
+                * Half-workaround for a NOCOW file.
+                * It's safe to turn of csums here, no extents exist
+                */
+               if (inode->i_size == 0)
+                       ip->flags |= BTRFS_INODE_NODATASUM;
+       } else {
+               /*
+                * Revert back under same assuptions as before
+                */
+               if (inode->i_size == 0)
+                       ip->flags &= ~BTRFS_INODE_NODATASUM;
                ip->flags &= ~BTRFS_INODE_NODATACOW;
+       }

        /*
         * The COMPRESS flag can only be changed by users, while the NOCOMPRESS

