Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54887 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaBOS0o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 13:26:44 -0500
Received: by mail-bk0-f53.google.com with SMTP id my13so3760882bkb.40
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Feb 2014 10:26:43 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1391220136-22034-1-git-send-email-fdmanana@gmail.com>
References: <1391220136-22034-1-git-send-email-fdmanana@gmail.com>
Date: Sat, 15 Feb 2014 18:26:43 +0000
Message-ID: <CAL3q7H5TLh6YDk4EJT7-eJ8Y_YjrSDWkFzdvZF=Yk4BpftO0pw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: more send support for parent/child dir
 relationship inversion
From: Filipe David Manana <fdmanana@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 1, 2014 at 2:02 AM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> The commit titled "Btrfs: fix infinite path build loops in incremental send"
> didn't cover a particular case where the parent-child relationship inversion
> of directories doesn't imply a rename of the new parent directory. This was
> due to a simple logic mistake, a logical and instead of a logical or.
>
> Steps to reproduce:
>
>   $ mkfs.btrfs -f /dev/sdb3
>   $ mount /dev/sdb3 /mnt/btrfs
>   $ mkdir -p /mnt/btrfs/a/b/bar1/bar2/bar3/bar4
>   $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap1
>   $ mv /mnt/btrfs/a/b/bar1/bar2/bar3/bar4 /mnt/btrfs/a/b/k44
>   $ mv /mnt/btrfs/a/b/bar1/bar2/bar3 /mnt/btrfs/a/b/k44
>   $ mv /mnt/btrfs/a/b/bar1/bar2 /mnt/btrfs/a/b/k44/bar3
>   $ mv /mnt/btrfs/a/b/bar1 /mnt/btrfs/a/b/k44/bar3/bar2/k11
>   $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap2
>   $ btrfs send -p /mnt/btrfs/snap1 /mnt/btrfs/snap2 > /tmp/incremental.send
>
> A patch to update the test btrfs/030 from xfstests, so that it covers
> this case, will be submitted soon.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---

Hi,

Should this go to 3.14 too? It is covered by the test case btrfs/030
for xfstests.

thanks

>  fs/btrfs/send.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e0b49f6..c47fcef 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3041,8 +3041,8 @@ static int wait_for_parent_move(struct send_ctx *sctx,
>
>         len1 = fs_path_len(path_before);
>         len2 = fs_path_len(path_after);
> -       if ((parent_ino_before != parent_ino_after) && (len1 != len2 ||
> -            memcmp(path_before->start, path_after->start, len1))) {
> +       if (parent_ino_before != parent_ino_after || len1 != len2 ||
> +            memcmp(path_before->start, path_after->start, len1)) {
>                 ret = 1;
>                 goto out;
>         }
> --
> 1.7.9.5
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
