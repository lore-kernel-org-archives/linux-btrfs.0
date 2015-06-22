Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38613 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbbFVLhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:37:05 -0400
Received: by igin14 with SMTP id n14so13957821igi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 04:37:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434964128-31757-7-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
	<1434964128-31757-7-git-send-email-robbieko@synology.com>
Date: Mon, 22 Jun 2015 12:37:03 +0100
Message-ID: <CAL3q7H7YZycROwg4CpXKYLM6o6EzcoRh3jZ6158inrekFj+G3w@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] Btrfs: incremental send, don't send utimes for
 non-existing directory
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:08 AM, Robbie Ko <robbieko@synology.com> wrote:
> There's one case where we can't issue a utimes operation for a directory.

There's one where we attempt to get utimes from a directory that
doesn't exist in the send snapshot.

> First, 261 can't move to d/item1 without the rename of inode 265. So as 262.
> Thus 261 and 262 need to wait for rename.
> Second, since 263 will be deleted and there are two waiting sub-directory
> 261 and 262, rmdir_ino of 261 will set to 263 and rmdir_ino of 262 is not set.
> If 262 is processed earlier than 261, utime of both 263 and 264 will be
> updated. However, 263 should not update since it will vanish.

You can't just start explaining an example, referring to inode numbers
etc, without showing the example before. How the parent and send
snapshots look like? So move up the example (parent  and send
snapshots directory hierarchy) before explaining it. We read top down
and not bottom up.

>
> I've found that the following case is the main cause of such error
> and it's fs tree is shown via btrfs-debug-tress as below.
>
> file tree key (459 ROOT_ITEM 20487)
> node 132988928 level 1 items 3 free 490 generation 20487 owner 459
> fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
> chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
>         key (256 INODE_ITEM 0) block 132710400 (8100) gen 20486
>         key (264 INODE_ITEM 0) block 130695168 (7977) gen 20480
>         key (266 XATTR_ITEM 952319794) block 126042112 (7693) gen 20464
> leaf 132710400 items 166 free space 3639 generation 20486 owner 455
> fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
> chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
>         item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>                 inode generation 20425 transid 20442 size 32 block
> group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
>         item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>                 inode ref index 0 namelen 2 name: ..
> ...
>         item 165 key (262 XATTR_ITEM 1100961104) itemoff 7789 itemsize 39
>                 location key (0 UNKNOWN.0 0) type XATTR
>                 namelen 8 datalen 1 name: user.a78
>                 data a
>                 binary 61
> leaf 130695168 items 133 free space 7332 generation 20480 owner 455
> fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
> chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
>         item 0 key (264 INODE_ITEM 0) itemoff 16123 itemsize 160
>                 inode generation 20428 transid 20434 size 10 block
> group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
>         item 1 key (264 INODE_REF 256) itemoff 16112 itemsize 11
>                 inode ref index 11 namelen 1 name: c
> ...
>
> We can see that inode 262 is right at the end of leaf. Then send_utime() will
> use btrfs_search_slot() to find a appropriate place to put 262 where is at the
> back of 262. However, that place is uninitialized on disk. Suppose we read
> atime tv_sec:576469548413222912, tv_nsec:1919251317 and then send it out.
> Receiving side will  got EINVAL since tv_nsec:1919251317 is greater
> than 999,999,999.

"...place to put 262..." -> it's actually inode 263, plus we aren't
attempting to put anything anywhere.

So you can explain this by mentioning that we're trying to send utimes
for a directory/inode that doesn't exist in the send snapshot. That
send_utimes() will use part of a leaf beyond its boundaries or a wrong
slot (belonging to some other unrelated inode), because
btrfs_search_slot() returns 1 when we call it to find the inode item
to extract a utimes value from, and send_utimes() is not prepared to
deal with such case because it assumes no one calls it for an inode
that doesn't exist in the send root. And that you fix the problem in
the offending caller.


>
> So fix this by don't send utimes for non-existing directory for this case.
>
> Example:
>
> Parent snapshot:
> |---- a/ (ino 259)
>     |---- c (ino 264)
> |---- b/ (ino 260)
>     |---- d (ino 265)
> |---- del/ (ino 263)
>     |---- item1/ (ino 261)
>     |---- item2/ (ino 262)
>
> Send snapshot:
> |---- a/ (ino 259)
> |---- b/ (ino 260)
> |---- c/ (ino 264)
>     |---- item2 (ino 262)
> |---- d/ (ino 265)
>     |---- item1/ (ino 261)
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>
> V2:don't send utimes for non-existing directory
>
>  fs/btrfs/send.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index cd22f7d..579a4c8 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3243,8 +3243,18 @@ finish:
>          * and old parent(s).
>          */
>         list_for_each_entry(cur, &pm->update_refs, list) {
> -               if (cur->dir == rmdir_ino)
> +               /*
> +                * don't send utimes for non-existing directory
> +                */
> +               ret = get_inode_info(sctx->send_root, cur->dir, NULL,
> +                            NULL , NULL, NULL, NULL, NULL);
> +               if (ret == -ENOENT) {
> +                       ret = 0;
>                         continue;
> +               }
> +               if (ret < 0)
> +                       goto out;
> +
>                 ret = send_utimes(sctx, cur->dir, cur->dir_gen);
>                 if (ret < 0)
>                         goto out;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
