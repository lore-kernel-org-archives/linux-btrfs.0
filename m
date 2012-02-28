From: Alex <alex@bpmit.com>
Subject: Re: SELinux inode size gotcha in btrfs.
Date: Tue, 28 Feb 2012 11:30:26 +0000 (UTC)
Message-ID: <loom.20120228T122833-822@post.gmane.org>
References: <loom.20120227T210703-631@post.gmane.org> <20120227231749.GR1046@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dave <at> jikos.cz> writes:

> 
> That's right. Inode represented as btrfs_inode_item does not contain any
> xattr fields, they're stored independently as a btrfs_dir_item of type
> BTRFS_FT_XATTR . Due to the way the b-tree keys are built, the xattr
> item key should be stored near the inode item key, that's for the tree
> search side. The xattr data are always stored inline in the b-tree leaf.
> 


Thank you David and Hugo,

My bad on three counts:
1) My courtesy close seems to have gone missing.
 Sorry and thank you for replying.
2) I, perhaps, should have pointed to
https://wiki.debian.org/SELinux/Setup#Prerequisites
_.28kernel_and_filesystems.29
which gives a better explanation.
3) Made it clear that I wasn't attacking
 XFS, It's my fs of (non /boot) choice
for some years now; I'm exploring SELinux
 (after the recent Linux conf au 2012
talk) and know I have used inode size defaults
 for my xfs init back in the day!

Best

Al.

