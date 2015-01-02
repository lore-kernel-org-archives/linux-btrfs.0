Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39037 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbABMod (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 07:44:33 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
Date: Fri, 2 Jan 2015 12:44:30 +0000
Message-ID: <CAL3q7H5YBzTwkRycRyuoj_K82rX3hn+BeYU2L-Wzik-dKMur_A@mail.gmail.com>
Subject: Re: [PATCH] xfstests: btrfs: fix up 001.out
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 31, 2014 at 7:48 PM, Anand Jain <anand.jain@oracle.com> wrote:
> The subvol delete output has changed with btrfs-progs
>     -Delete subvolume 'SCRATCH_MNT/snap'
>     +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
>
> make the matching changes in the xfstests btrfs 001.out

Hi Anand,

This is a wrong approach to fix it.
With this change it means the test will now fail with a btrfs-progs
release older than v3.18...

The test should just ignore the output and check if the snapshot
creation command succeeds.
See how more recent tests do it - they are calling
_run_btrfs_util_prog (which calls run_check).

thanks

>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/001.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
> index c782bde..8dc6eac 100644
> --- a/tests/btrfs/001.out
> +++ b/tests/btrfs/001.out
> @@ -33,7 +33,7 @@ subvol
>  Listing subvolumes
>  snap
>  subvol
> -Delete subvolume 'SCRATCH_MNT/snap'
> +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
>  List root dir
>  subvol
>  List root dir
> --
> 2.0.0.153.g79dcccc
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
