Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34137 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbcCXLI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:08:57 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
References: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
Date: Thu, 24 Mar 2016 11:08:56 +0000
Message-ID: <CAL3q7H5APJE6bWpi=kYMuC4sMRvYuEh5ouVTLxfQCRQO4EThew@mail.gmail.com>
Subject: Re: [PATCH] fstest: btrfs: remove _need_to_be_root fix btrfs/118
From: Filipe Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 10:13 AM, Anand Jain <anand.jain@oracle.com> wrote:
> commit 56ff01f471c9b72de0a447b37cdb1051adcede6a
>     xfstests: remove _need_to_be_root
>
> Removed _need_to_be_root(), and so btrfs/118 needs an update

https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=3a9242688d64c669ca764ee2c5599abfc885c131

It's always a good idea to check if one is using the latest git branch
and the mailing list... :)

>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/118 | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tests/btrfs/118 b/tests/btrfs/118
> index 3ed1cbef1068..740cb92b0669 100755
> --- a/tests/btrfs/118
> +++ b/tests/btrfs/118
> @@ -45,7 +45,6 @@ _cleanup()
>  . ./common/dmflakey
>
>  # real QA test starts here
> -_need_to_be_root
>  _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
> --
> 2.7.0
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
