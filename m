Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36068 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbDNJPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 05:15:00 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1429002060-16597-1-git-send-email-bo.li.liu@oracle.com>
References: <1429002060-16597-1-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 14 Apr 2015 10:14:59 +0100
Message-ID: <CAL3q7H4kacnDiQLpBr0ZMKCPY7dK=uO-PPrNmhUqiWutMY5k=g@mail.gmail.com>
Subject: Re: [PATCH] xfstests: make "BTRFS_UTIL_PROG filesystem defragment" work
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 14, 2015 at 10:01 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> _require_defrag() needs to check if the command is executable, but btrfs has
> its subcommand "filesystem defragment", which makes this checking fail.
>
> This workarounds it and now we can run case generic/324, generic/018, btrfs/005.

There's already a patch from Zhao to fix the regression:

https://patchwork.kernel.org/patch/6205031/

thanks

>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  common/defrag | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/common/defrag b/common/defrag
> index f923dc0..f36a68b 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -37,7 +37,11 @@ _require_defrag()
>         ;;
>      esac
>
> -    _require_command "$DEFRAG_PROG" defragment
> +    if [ "$FSTYP" == "btrfs" ]; then
> +           _require_command "$BTRFS_UTIL_PROG" defragment
> +    else
> +           _require_command "$DEFRAG_PROG" defragment
> +    fi
>      _require_xfs_io_command "fiemap"
>  }
>
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
