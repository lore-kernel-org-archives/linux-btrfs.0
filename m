Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36154 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbbFCPxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 11:53:18 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433315455-814-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <CAL3q7H7yZyUXAsK41e1ZAwVsV3WB8_XNJR_sQ4p8UZLfEM5hDA@mail.gmail.com>
	<1433315455-814-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Date: Wed, 3 Jun 2015 16:53:17 +0100
Message-ID: <CAL3q7H71H1Q9_d7ogQ0mi+e14wySOuSUh3eEmbBcvkXyO1eSDg@mail.gmail.com>
Subject: Re: [PATCH] xfstests: btrfs: 022: add a quota rescan -w to wait
 rescan finished.
From: Filipe David Manana <fdmanana@gmail.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 3, 2015 at 8:10 AM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> When we enable quota, btrfs will rescan quota numbers. We need
> to wait the rescan finished before any more operations on btrfs
> qgroups. Otherwith, the new btrfs-progs would WARN out:
>
> WARNING: Rescan is running, qgroup data may be incorrect.
>
> It would make btrfs/022 failed.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks, it works and it makes sense.

> ---
>  tests/btrfs/022 | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tests/btrfs/022 b/tests/btrfs/022
> index 5c1a82d..56d4f3d 100755
> --- a/tests/btrfs/022
> +++ b/tests/btrfs/022
> @@ -51,6 +51,7 @@ _basic_test()
>  {
>         _run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
>         _run_btrfs_util_prog quota enable $SCRATCH_MNT/a
> +       _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>         subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
>         $BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | grep $subvolid >> \
>                 $seqres.full 2>&1
> --
> 1.8.4.2
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
