Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36317 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbcBXH1a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 02:27:30 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1456295716-9589-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456295716-9589-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1456295716-9589-2-git-send-email-quwenruo@cn.fujitsu.com>
Date: Wed, 24 Feb 2016 07:27:29 +0000
Message-ID: <CAL3q7H5Vii4TVT9TMsnGMk1dMzF=Z69e-_0m6yE+n5JSgT8_Rw@mail.gmail.com>
Subject: Re: [PATCH 1/5] fstests: Add support to check btrfs sysfs features
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 6:35 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Btrfs has its sysfs interface showing what features current kernel/btrfs
> module support.
>
> Add _require_btrfs_kernel_feature() to check such interface.


I think you sent the wrong patch. This doesn't add such a function and
the changes are exactly the same as in:

[PATCH 1/5] fstests: rename _require_btrfs to _require_btrfs_subcommand

>
> Also rename _require_btrfs() to _require_btrfs_subcommand() to avoid
> confusion.

So if there's a dedicated patch to do that already (the one I
mentioned above), why do it here again? (and should be a separate
patch anyway, since it's unrelated)

>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  common/rc       | 2 +-
>  tests/btrfs/004 | 2 +-
>  tests/btrfs/048 | 1 +
>  tests/btrfs/059 | 1 +
>  4 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index af16c81..ff57862 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2706,7 +2706,7 @@ _require_deletable_scratch_dev_pool()
>  }
>
>  # We check for btrfs and (optionally) features of the btrfs command
> -_require_btrfs()
> +_require_btrfs_subcommand()
>  {
>         cmd=$1
>         _require_command "$BTRFS_UTIL_PROG" btrfs
> diff --git a/tests/btrfs/004 b/tests/btrfs/004
> index 905770a..2ce628e 100755
> --- a/tests/btrfs/004
> +++ b/tests/btrfs/004
> @@ -51,7 +51,7 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
>  _require_no_large_scratch_dev
> -_require_btrfs inspect-internal
> +_require_btrfs_subcommand inspect-internal
>  _require_command "/usr/sbin/filefrag" filefrag
>
>  rm -f $seqres.full
> diff --git a/tests/btrfs/048 b/tests/btrfs/048
> index c2cb4a6..d15346a 100755
> --- a/tests/btrfs/048
> +++ b/tests/btrfs/048
> @@ -48,6 +48,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_btrfs "property"
> +_require_btrfs_subcommand "property"
>
>  send_files_dir=$TEST_DIR/btrfs-test-$seq
>
> diff --git a/tests/btrfs/059 b/tests/btrfs/059
> index b9a6ef4..6e7f7ee 100755
> --- a/tests/btrfs/059
> +++ b/tests/btrfs/059
> @@ -51,6 +51,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_btrfs "property"
> +_require_btrfs_subcommand "property"
>
>  rm -f $seqres.full
>
> --
> 2.7.1
>
>
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
