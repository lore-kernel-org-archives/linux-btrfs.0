Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36366 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbbGaIiF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 04:38:05 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435631143-12247-1-git-send-email-naota@elisp.net>
References: <1435631143-12247-1-git-send-email-naota@elisp.net>
Date: Fri, 31 Jul 2015 09:38:04 +0100
Message-ID: <CAL3q7H4gVq-X4Zuz_qvSWDcMXzruwA8R0stwJMxHG+QRWK0Fqw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] btrfs: fix search key advancing condition
From: Filipe David Manana <fdmanana@gmail.com>
To: Naohiro Aota <naota@elisp.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 3:25 AM, Naohiro Aota <naota@elisp.net> wrote:
> The search key advancing condition used in copy_to_sk() is loose. It can
> advance the key even if it reaches sk->max_*: e.g. when the max key = (512,
> 1024, -1) and the current key = (512, 1025, 10), it increments the
> offset by 1, continues hopeless search from (512, 1025, 11). This issue
> make ioctl() to take unexpectedly long time scanning all the leaf a blocks
> one by one.
>
> This commit fix the problem using standard way of key comparison:
> btrfs_comp_cpu_keys()
>
> Signed-off-by: Naohiro Aota <naota@elisp.net>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

thanks

> ---
>  fs/btrfs/ioctl.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1c22c65..07dc01d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1932,6 +1932,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>         u64 found_transid;
>         struct extent_buffer *leaf;
>         struct btrfs_ioctl_search_header sh;
> +       struct btrfs_key test;
>         unsigned long item_off;
>         unsigned long item_len;
>         int nritems;
> @@ -2015,12 +2016,17 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>         }
>  advance_key:
>         ret = 0;
> -       if (key->offset < (u64)-1 && key->offset < sk->max_offset)
> +       test.objectid = sk->max_objectid;
> +       test.type = sk->max_type;
> +       test.offset = sk->max_offset;
> +       if (btrfs_comp_cpu_keys(key, &test) >= 0)
> +               ret = 1;
> +       else if (key->offset < (u64)-1)
>                 key->offset++;
> -       else if (key->type < (u8)-1 && key->type < sk->max_type) {
> +       else if (key->type < (u8)-1) {
>                 key->offset = 0;
>                 key->type++;
> -       } else if (key->objectid < (u64)-1 && key->objectid < sk->max_objectid) {
> +       } else if (key->objectid < (u64)-1) {
>                 key->offset = 0;
>                 key->type = 0;
>                 key->objectid++;
> --
> 2.4.4
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
