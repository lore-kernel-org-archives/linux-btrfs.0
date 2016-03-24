Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34516 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbcCXLKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:10:55 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
References: <1458814272-5783-1-git-send-email-anand.jain@oracle.com>
Date: Thu, 24 Mar 2016 11:10:51 +0000
Message-ID: <CAL3q7H6LPKyNYYXyvmM=cKhhjSxxm4G4N1utoKO5L4tLGGa3_w@mail.gmail.com>
Subject: Re: [PATCH] fstest: btrfs: update 048.out inline with ui changes
From: Filipe Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 10:11 AM, Anand Jain <anand.jain@oracle.com> wrote:
> To be inline with progs changes
>   28831d54895443e5fc795392f23ce3a8b122cb71
>   btrfs-progs: cmd property: switch to common error message wrapper
> update 048.out
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/048.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
> index 0b20d0b5976c..1d3ccef8e870 100644
> --- a/tests/btrfs/048.out
> +++ b/tests/btrfs/048.out
> @@ -9,7 +9,7 @@ label=foobar
>  ***
>  label=
>  ***
> -ERROR: object is not compatible with property
> +ERROR: object is not compatible with property: label

This now makes the test fail with older versions of btrfs-progs...

Same observation as before, update your git branch and read the mailing list:

https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=232593dea51c53f3251f9b41cd89e9dba20f0159
https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=2dd2cea4b51810bbb4090ebdc20ee799e63e5fd8

>  ***
>
>  Testing subvolume ro property
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
