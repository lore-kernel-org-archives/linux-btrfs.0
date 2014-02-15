Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53980 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaBOSZC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 13:25:02 -0500
Received: by mail-bk0-f50.google.com with SMTP id d7so532577bkh.9
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Feb 2014 10:25:00 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1391220015-21946-1-git-send-email-fdmanana@gmail.com>
References: <1391220015-21946-1-git-send-email-fdmanana@gmail.com>
Date: Sat, 15 Feb 2014 18:25:00 +0000
Message-ID: <CAL3q7H6Q9uf_wm=oSFdxEJ52DnviMqSDuOzhTihtf_TJMJfMzg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix send dealing with file renames and directory moves
From: Filipe David Manana <fdmanana@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 1, 2014 at 2:00 AM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> This fixes a case that the commit titled:
>
>    Btrfs: fix infinite path build loops in incremental send
>
> didn't cover. If the parent-child relationship between 2 directories
> is inverted, both get renamed, and the former parent has a file that
> got renamed too (but remains a child of that directory), the incremental
> send operation would use the file's old path after sending an unlink
> operation for that old path, causing receive to fail on future operations
> like changing owner, permissions or utimes of the corresponding inode.
>
> This is not a regression from the commit mentioned before, as without
> that commit we would fall into the issues that commit fixed, so it's
> just one case that wasn't covered before.
>
> Simple steps to reproduce this issue are:
>
>       $ mkfs.btrfs -f /dev/sdb3
>       $ mount /dev/sdb3 /mnt/btrfs
>       $ mkdir -p /mnt/btrfs/a/b/c/d
>       $ touch /mnt/btrfs/a/b/c/d/file
>       $ mkdir -p /mnt/btrfs/a/b/x
>       $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap1
>       $ mv /mnt/btrfs/a/b/x /mnt/btrfs/a/b/c/x2
>       $ mv /mnt/btrfs/a/b/c/d /mnt/btrfs/a/b/c/x2/d2
>       $ mv /mnt/btrfs/a/b/c/x2/d2/file /mnt/btrfs/a/b/c/x2/d2/file2
>       $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap2
>       $ btrfs send -p /mnt/btrfs/snap1 /mnt/btrfs/snap2 > /tmp/incremental.send
>
> A patch to update the test btrfs/030 from xfstests, so that it covers
> this case, will be submitted soon.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Hi,

Should this go to 3.14? It is covered by the test case btrfs/030 for xfstests.

thanks

> ---
>  fs/btrfs/send.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 7250d86..e0b49f6 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2121,8 +2121,6 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
>         u64 parent_inode = 0;
>         u64 parent_gen = 0;
>         int stop = 0;
> -       u64 start_ino = ino;
> -       u64 start_gen = gen;
>         int skip_name_cache = 0;
>
>         name = fs_path_alloc();
> @@ -2134,7 +2132,6 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
>         if (is_waiting_for_move(sctx, ino))
>                 skip_name_cache = 1;
>
> -again:
>         dest->reversed = 1;
>         fs_path_reset(dest);
>
> @@ -2149,13 +2146,8 @@ again:
>                         stop = 1;
>
>                 if (!skip_name_cache &&
> -                   is_waiting_for_move(sctx, parent_inode)) {
> -                       ino = start_ino;
> -                       gen = start_gen;
> -                       stop = 0;
> +                   is_waiting_for_move(sctx, parent_inode))
>                         skip_name_cache = 1;
> -                       goto again;
> -               }
>
>                 ret = fs_path_add_path(dest, name);
>                 if (ret < 0)
> --
> 1.7.9.5
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
