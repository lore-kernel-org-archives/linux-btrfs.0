Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47531 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3CLLrQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 07:47:16 -0400
Received: by mail-wi0-f179.google.com with SMTP id ez12so1738118wid.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 04:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1361460927-16355-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
	<1361460927-16355-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Tue, 12 Mar 2013 13:47:14 +0200
Message-ID: <CAOcd+r2HHDyHz0VqaJr5KWLMSMazFJ1kDKQULq7jkrEF6Ag15w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix backref walking race with tree deletions
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
I have been testing your patch, and definitely the reproducer now passes.
However, my system tests still hit the issue, but unfortunately I am
unable to isolate it into a bash script. All bash scripts work
alright:)

I have added some prints to attempt to debug this, and here is what I see:
So the extent in question is:

	item 16 key (4378624 EXTENT_ITEM 8192) itemoff 3163 itemsize 66
		extent refs 2 gen 6 flags 1
		extent data backref root 261 objectid 276 offset 0 count 1
		shared data backref parent 4214784 count 1

It is shared by three subvolumes: 257, 261,262, while 261/2 share the
same leaf in the file tree. 257 has its own leaf. Inode in all three
subvolumes is 276, and this is the only EXTENT_DATA of this inode.

file tree key (257 ROOT_ITEM 6)
	...
leaf 4214784 items 38 free space 461 generation 6 owner 256
	...
	item 29 key (276 INODE_ITEM 0) itemoff 1897 itemsize 160
		inode generation 6 transid 6 size 5777 block group 0 mode 100644 links 1
	item 30 key (276 INODE_REF 271) itemoff 1871 itemsize 26
		inode ref index 6 namelen 16 name: file_with_xattr1
	item 29 key (276 INODE_ITEM 0) itemoff 1897 itemsize 160
		inode generation 6 transid 6 size 5777 block group 0 mode 100644 links 1
	item 30 key (276 INODE_REF 271) itemoff 1871 itemsize 26
		inode ref index 6 namelen 16 name: file_with_xattr1
	item 31 key (276 XATTR_ITEM 3895912174) itemoff 1815 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr1
		data attr1_XXX
	item 32 key (276 XATTR_ITEM 4217771290) itemoff 1759 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr2
		data attr2_YYY
	item 33 key (276 EXTENT_DATA 0) itemoff 1706 itemsize 53
		extent data disk byte 4378624 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0

file tree key (261 ROOT_ITEM 10)
	...
leaf 4431872 items 38 free space 441 generation 11 owner 261
	...
	item 29 key (276 INODE_ITEM 0) itemoff 1877 itemsize 160
		inode generation 6 transid 6 size 5777 block group 0 mode 100644 links 1
	item 30 key (276 INODE_REF 271) itemoff 1851 itemsize 26
		inode ref index 6 namelen 16 name: file_with_xattr1
	item 31 key (276 XATTR_ITEM 3895912174) itemoff 1795 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr1
		data attr1_XXX
	item 32 key (276 XATTR_ITEM 4217771290) itemoff 1739 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr2
		data attr2_YYY
	item 33 key (276 EXTENT_DATA 0) itemoff 1686 itemsize 53
		extent data disk byte 4378624 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0

file tree key (262 ROOT_ITEM 11)
	...
leaf 4431872 items 38 free space 441 generation 11 owner 261
	...
	item 29 key (276 INODE_ITEM 0) itemoff 1877 itemsize 160
		inode generation 6 transid 6 size 5777 block group 0 mode 100644 links 1
	item 30 key (276 INODE_REF 271) itemoff 1851 itemsize 26
		inode ref index 6 namelen 16 name: file_with_xattr1
	item 31 key (276 XATTR_ITEM 3895912174) itemoff 1795 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr1
		data attr1_XXX
	item 32 key (276 XATTR_ITEM 4217771290) itemoff 1739 itemsize 56
		location key (0 UNKNOWN.0 0) type 8
		namelen 16 datalen 10 name: user.ztest_attr2
		data attr2_YYY
	item 33 key (276 EXTENT_DATA 0) itemoff 1686 itemsize 53
		extent data disk byte 4378624 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0

During the failure, roots 261 and 262 are found, but not root 257,
which is the root being sent. The send has no parent in this case
(full-send):

btrfs [find_extent_clone] Search [rt=257 ino=276 off=0 len=8192]
[found extent=4378624 extent_item_pos=0]
btrfs [iterate_extent_inodes] resolving for extent 4378624 pos=0
btrfs [iterate_extent_inodes] extent 4378624 pos=0 found 1 leafs
btrfs [iterate_extent_inodes] extent 4378624 pos=0 root 262 references
leaf 4431872
btrfs [iterate_extent_inodes] extent 4378624 pos=0 root 261 references
leaf 4431872
btrfs: ERROR did not find backref in send_root. inode=276, offset=0,
disk_byte=4378624 found extent=4378624

So btrfs_find_all_leafs() finds one leaf 4431872, which is shared
between 261 and 262. But it does not find leaf 4214784, which is the
leaf of subvolume 257.

The tree-dump I showed you is taken after the test failed, and at this
point if I try "btrfs send", everything is resolved alright:

btrfs [find_extent_clone] Search [rt=257 ino=277 off=0 len=8192]
[found extent=4386816 extent_item_pos=0]
btrfs [iterate_extent_inodes] resolving for extent 4386816 pos=0
btrfs [iterate_extent_inodes] extent 4386816 pos=0 found 2 leafs
btrfs [iterate_extent_inodes] extent 4386816 pos=0 root 262 references
leaf 4431872
btrfs [iterate_extent_inodes] extent 4386816 pos=0 root 261 references
leaf 4431872
btrfs [iterate_extent_inodes] extent 4386816 pos=0 root 257 references
leaf 4214784

Can you advise on how to debug this further?

Thanks,
Alex.



On Thu, Feb 21, 2013 at 5:35 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> When a subvolume is removed, we remove the root item from the root tree,
> while the tree blocks and backrefs remain for a while. When backref walking
> comes across one of those orphan tree blocks, it can find a backref for a
> no longer existing root. This is all good, we only must tolerate
> __resolve_indirect_ref returning an error and continue with the good refs
> found.
>
> Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/backref.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 04edf69..bd605c8 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -352,11 +352,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
>                 err = __resolve_indirect_ref(fs_info, search_commit_root,
>                                              time_seq, ref, parents,
>                                              extent_item_pos);
> -               if (err) {
> -                       if (ret == 0)
> -                               ret = err;
> +               if (err)
>                         continue;
> -               }
>
>                 /* we put the first parent into the ref at hand */
>                 ULIST_ITER_INIT(&uiter);
> --
> 1.7.1
>
