Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:64192 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBTIs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 03:48:28 -0500
Received: by mail-vc0-f175.google.com with SMTP id ij19so1578694vcb.34
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 00:48:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392864546-545-2-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	<1392864546-545-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 08:48:26 +0000
Message-ID: <CAMU1PDgNnvuw3cjx4-qfi4PxHiyswdSzjZdoDwv+uEJTvx1r4Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] btrfs-progs: fix segment fault when exec
 btrfs-debug-tree as non-root
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 February 2014 02:49, Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:
> When exec btrfs-debug-tree as non-root user, we get a segment fault.
> Because the btrfs_scan_block_devices return a success 0 when we fail
> to open a device. Now we just return the errno if this case happens.
>
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  utils.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/utils.c b/utils.c
> index 97e23d5..1878abc 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1517,7 +1517,8 @@ scan_again:
>                 scans++;
>                 goto scan_again;
>         }
> -       return 0;
> +
> +       return errno ? -errno : 0;
>  }
>
>  u64 parse_size(char *s)
> --
> 1.8.1.4

Hi Gui,

This strikes me as not not right because errno is only documented as
being set when open() returns -1 on failure.  In the success case
errno is not set so you can't assume it will be 0.

I think the following might work:
1) Initilase ret = 0 at the start of btrfs_scan_block_devices()
2) In the open(fullpath, O_RDONLY) failure case set ret = fd
3) return ret

Thanks,
Mike
