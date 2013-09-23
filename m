Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41513 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3IWJ7W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 05:59:22 -0400
Date: Mon, 23 Sep 2013 17:59:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix sync fs to actually wait for all data to
 be persisted
Message-ID: <20130923095913.GB18072@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1379883353-7358-1-git-send-email-fdmanana@gmail.com>
 <1379928200-21566-1-git-send-email-fdmanana@gmail.com>
 <CAL3q7H5Bh1T0W+Cb3njO6pk_=fqiqoJXrD_oKgtchCq=crMVzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5Bh1T0W+Cb3njO6pk_=fqiqoJXrD_oKgtchCq=crMVzQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 10:53:20AM +0100, Filipe David Manana wrote:
> On Mon, Sep 23, 2013 at 10:23 AM, Filipe David Borba Manana
> <fdmanana@gmail.com> wrote:
> > Currently the fs sync function (super.c:btrfs_sync_fs()) doesn't
> > wait for delayed work to finish before returning success to the
> > caller. This change fixes this, ensuring that there's no data loss
> > if a power failure happens right after fs sync returns success to
> > the caller and before the next commit happens.
> >
> > Steps to reproduce the data loss issue:
> >
> > $ mkfs.btrfs -f /dev/sdb3
> > $ mount /dev/sdb3 /mnt/btrfs
> > $ perl -e '$d = ("\x41" x 6001); open($f,">","/mnt/btrfs/foobar"); print $f $d; close($f);' && btrfs fi sync /mnt/btrfs
> >
> > Right after the btrfs fi sync command (a second or 2 for example), power
> > off the machine and reboot it. The file will be empty, as it can be verified
> > after mounting the filesystem and through btrfs-debug-tree:
> >
> > $ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
> >         item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
> >                 location key (257 INODE_ITEM 0) type FILE
> >                 namelen 6 datalen 0 name: foobar
> >         item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
> >                 inode generation 7 transid 7 size 0 block group 0 mode 100644 links 1
> >         item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
> >                 inode ref index 2 namelen 6 name: foobar
> > checksum tree key (CSUM_TREE ROOT_ITEM 0)
> > leaf 29429760 items 0 free space 3995 generation 7 owner 7
> > fs uuid 6192815c-af2a-4b75-b3db-a959ffb6166e
> > chunk uuid b529c44b-938c-4d3d-910a-013b4700bcae
> > uuid tree key (UUID_TREE ROOT_ITEM 0)
> >
> > After this patch, the data loss no longer happens after a power failure and
> > btrfs-debug-tree shows:
> >
> > $ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
> >         item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
> >                 location key (257 INODE_ITEM 0) type FILE
> >                 namelen 6 datalen 0 name: foobar
> >         item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
> >                 inode generation 6 transid 6 size 6001 block group 0 mode 100644 links 1
> >         item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
> >                 inode ref index 2 namelen 6 name: foobar
> >         item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
> >                 extent data disk byte 12845056 nr 8192
> >                 extent data offset 0 nr 8192 ram 8192
> >                 extent compression 0
> > checksum tree key (CSUM_TREE ROOT_ITEM 0)
> >
> > Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> > ---
> >
> > V2: Use writeback_inodes_sb() instead of btrfs_start_all_delalloc_inodes(), as
> >     suggested by Miao Xie.
> >
> >  fs/btrfs/super.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 6ab0df5..38b4392 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -921,6 +921,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
> >                 return 0;
> >         }
> >
> > +       writeback_inodes_sb(sb, WB_REASON_SYNC);
> >         btrfs_wait_all_ordered_extents(fs_info);
> 
> Ignore this 2nd patch version please, for 2 reasons:
> 
> 1) It triggers a WARN_ON because writeback_inodes_sb() requires the
> sb->u_mount semaphore to be acquired before, which is not always the
> case (it is when called through btrfs_kill_super, otherwise it isn't)
> 
> 2) It doesn't guarantee that  inodes are actually written (see comment
> of writeback_inodes_sb()), so we can return 0 (success) when the
> writes actually didn't happen/succeed. Because of this,
> btrfs_start_all_delalloc_inodes() is more honest.

What about
        case BTRFS_IOC_SYNC:
		btrfs_start_all_delalloc_inodes();
                btrfs_sync_fs(file->f_dentry->d_sb, 1);
                return 0;

This way, there is no impact on calling sync(1).

-liubo
