Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56526 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3IWJLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 05:11:43 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so1036227bkb.20
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 02:11:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <523F99CA.5000703@cn.fujitsu.com>
References: <1379883353-7358-1-git-send-email-fdmanana@gmail.com>
	<523F99CA.5000703@cn.fujitsu.com>
Date: Mon, 23 Sep 2013 10:11:42 +0100
Message-ID: <CAL3q7H4X_KD2RsRoQ7T9ZwigbGeofFcE_wxE8BOnZDObjvP_=Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix sync fs to actually wait for all data to be persisted
From: Filipe David Manana <fdmanana@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 2:30 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>
> On      sun, 22 Sep 2013 21:55:53 +0100, Filipe David Borba Manana wrote:
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
> >
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
> >       item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
> >               location key (257 INODE_ITEM 0) type FILE
> >               namelen 6 datalen 0 name: foobar
> >       item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
> >               inode generation 6 transid 6 size 6001 block group 0 mode 100644 links 1
> >       item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
> >               inode ref index 2 namelen 6 name: foobar
> >       item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
> >               extent data disk byte 12845056 nr 8192
> >               extent data offset 0 nr 8192 ram 8192
> >               extent compression 0
> > checksum tree key (CSUM_TREE ROOT_ITEM 0)
> >
> > Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> > ---
> >  fs/btrfs/super.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 6ab0df5..557e38f 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -913,6 +913,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
> >       struct btrfs_trans_handle *trans;
> >       struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> >       struct btrfs_root *root = fs_info->tree_root;
> > +     int ret;
> >
> >       trace_btrfs_sync_fs(wait);
> >
> > @@ -921,6 +922,10 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
> >               return 0;
> >       }
> >
> > +     ret = btrfs_start_all_delalloc_inodes(fs_info, 0);
> > +     if (ret)
> > +             return ret;
> > +
>
> I don't think we should call btrfs_start_all_delalloc_inodes(), because this function is also
> called by do_sync(), but do_sync() syncs the whole fs before calling it, so if we add
> btrfs_start_all_delalloc_inodes() here, we will sync the fs twice, and the second one is unnecessary.

Where is that do_sync() function exactly? I'm not finding any with
that exact name in fs/btrfs/* nor fs/*
I used this approach because (besides working) it's what is done in
btrfs_commit_transaction() (via btrfs_start_delalloc_flush and
btrfs_wait_delalloc_flush). Why can it be like that in the transaction
commit and not in btrfs_sync_fs() ?

>
> Calling writeback_inodes_sb() before btrfs_sync_fs() is better way to fix this problem.

Just tested it, and it works that way too. Uploading a new patch.

Thanks for the feedback/review Miao.

>
> Thanks
> Miao
>
> >       btrfs_wait_all_ordered_extents(fs_info);
> >
> >       trans = btrfs_attach_transaction_barrier(root);
> >
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
