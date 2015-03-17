Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35750 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbCQPhs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 11:37:48 -0400
Received: by lbcgn8 with SMTP id gn8so9905525lbc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:37:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1426604663-7663-1-git-send-email-jbacik@fb.com>
References: <1426604663-7663-1-git-send-email-jbacik@fb.com>
Date: Tue, 17 Mar 2015 15:37:46 +0000
Message-ID: <CAL3q7H6bSau3LxUeptu=+5A9Qy7t3yi84iX_5+bYLnO_ubBgig@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix outstanding_extents accounting in DIO
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 3:04 PM, Josef Bacik <jbacik@fb.com> wrote:
> We are keeping track of how many extents we need to reserve properly based on
> the amount we want to write, but we were still incrementing outstanding_extents
> if we wrote less than what we requested.  We need to fix this logic to only do
> this if we request less than MAX_EXTENT_SIZE or if we write less than
> MAX_EXTENT_SIZE when we request an amount larger than MAX_EXTENT_SIZE.  This
> fixes the problem Filipe reported with generic/300.  Thanks,
>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

I hate to be the bringer of bad news, but this still causes the
warnings for the modified fstests/generic/300 everytime I run it.

I have all your recent patches dealing with fixing the accounting of
outstanding_extents applied:

$ git log --author='Josef Bacik' --pretty=oneline
4bfbd94312a4dc464f1827ca03faccb8da8f2aaf Btrfs: account merges properly
e0037ac670a4e462166f3ec28e691f8595fca607 Btrfs: fix merge delalloc logic
f46e5f2aebc726ed0dad860c3769a9bf63b0ea81 Btrfs: fix
outstanding_extents accounting in DIO
53f6e7d09b796371074ada19e452b7566682fe2f Btrfs: account for the
correct number of extents for delalloc reservations
b8c3ce1cfa5a5f7f6fe71b8f6ac4f601e7ccdf1f Btrfs: remove extra
run_delayed_refs in update_cowonly_root
(...)

Also, with the new fix for the merges of buffered extents ("Btrfs:
account merges properly") I get the assertion triggered again:

[13382.732589] BTRFS: assertion failed:
BTRFS_I(inode)->outstanding_extents >= num_extents, file:
fs/btrfs/extent-tree.c, line: 4983
[13382.735759] ------------[ cut here ]------------
[13382.736031] kernel BUG at fs/btrfs/ctree.h:4013!
[13382.736031] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
(...)
[13382.736031]  [<ffffffffa03be666>] drop_outstanding_extent+0x3d/0x6d [btrfs]

For this fio job (more stressful then the previous simple fio job):

[global]
ioengine=sync
direct=0
bssplit=130M/100
fallocate=none
filename=foobar

[job1]
numjobs=1
size=4G
rw=randwrite
time_based
runtime=60



> ---
>  fs/btrfs/inode.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 156d0f5..f6d2c56 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7387,7 +7387,24 @@ unlock:
>                 if (start + len > i_size_read(inode))
>                         i_size_write(inode, start + len);
>
> -               if (len < orig_len) {
> +               /*
> +                * direct_io can send down chunks > BTRFS_MAX_EXTENT_SIZE, so we
> +                * don't want to jack up outstanding_extents if we're just
> +                * allocating the largest extent we can for a range that we've
> +                * already reserved the approriate number of outstanding_extents
> +                * for.
> +                *
> +                * So if orig_len <= BTRFS_MAX_EXTENT_SIZE and our allocated len
> +                * is less than orig_len then we know we're going to end up with
> +                * more extents than we reserved.
> +                *
> +                * If orig_len > BTRFS_MAX_EXTENT_SIZE but we weren't able to
> +                * allocate a BTRFS_MAX_EXTENT_SIZE extent then we know we have
> +                * to add another outstanding extent.
> +                */
> +               if (len < orig_len &&
> +                   (orig_len <= BTRFS_MAX_EXTENT_SIZE ||
> +                    len < BTRFS_MAX_EXTENT_SIZE)) {
>                         spin_lock(&BTRFS_I(inode)->lock);
>                         BTRFS_I(inode)->outstanding_extents++;
>                         spin_unlock(&BTRFS_I(inode)->lock);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
