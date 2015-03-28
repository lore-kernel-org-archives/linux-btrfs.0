Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36631 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbC1Lyy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 07:54:54 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <7a5ac15c7ec2019aec97d6caa2fd98cc591ded95.1426497160.git.zhaolei@cn.fujitsu.com>
References: <7a5ac15c7ec2019aec97d6caa2fd98cc591ded95.1426497160.git.zhaolei@cn.fujitsu.com>
Date: Sat, 28 Mar 2015 11:54:53 +0000
Message-ID: <CAL3q7H7+NyWNnJmAwjsWzsm0pSU5VBV9QBXz5UhjBBpy7Tu45A@mail.gmail.com>
Subject: Re: [PATCH v2] fix "utility required warning" with empty utility name
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 16, 2015 at 9:14 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> In generic/019, if we hadn't install fio, we will get following output:
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 lenovo 4.0.0-rc3_HEAD_9eccca0843205f87c00404b663188b88eb248051_
>  MKFS_OPTIONS  -- /dev/sda6
>  MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda6 /var/ltf/tester/scratch_mnt
>
>  generic/019      [not run]  utility required, skipped this test <- *
>  Not run: generic/019
>  Passed all 0 tests
>
> When fio is not installed, "$FIO_PROG" is set to blank, and
> _require_fio() call _require_command() with none arguments.
>
> This patch fixed all misuse of _require_command(), add 2nd argument
> to let _require_command() output right message, and add quotes to
> first argument to avoid argument shifting.
>
> Changelog v1->v2:
>  Fix all misuse of _require_command(), suggested-by:
>  Eryu Guan <eguan@redhat.com>
>
> Suggested-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  common/defrag   | 2 +-
>  common/rc       | 6 +++---
>  tests/btrfs/003 | 2 +-
>  tests/btrfs/004 | 2 +-
>  tests/btrfs/011 | 2 +-
>  tests/btrfs/012 | 6 +++---
>  tests/btrfs/079 | 2 +-
>  tests/ext4/004  | 4 ++--
>  tests/xfs/094   | 2 +-
>  tests/xfs/103   | 2 +-
>  tests/xfs/122   | 2 +-
>  tests/xfs/195   | 2 +-
>  12 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/common/defrag b/common/defrag
> index f5e36fb..f923dc0 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -37,7 +37,7 @@ _require_defrag()
>         ;;
>      esac
>
> -    _require_command $DEFRAG_PROG
> +    _require_command "$DEFRAG_PROG" defragment

So with this change one can no longer run the test btrfs/005:

btrfs/005 96s ... [not run] /home/fdmanana/git/hub/btrfs-progs/btrfs
filesystem defragment utility required, skipped this test

The DEFRAG_PROG value is never an empty string when FSTYP is btrfs,
and this change makes _require_command think "btrfs filesystem
defragment" is the name of the program instead of just "btrfs".

>      _require_xfs_io_command "fiemap"
>  }
>
> diff --git a/common/rc b/common/rc
> index 1ed9df5..c1a50f2 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1299,7 +1299,7 @@ _require_dm_flakey()
>  {
>      # require SCRATCH_DEV to be a valid block device
>      _require_block_device $SCRATCH_DEV
> -    _require_command $DMSETUP_PROG
> +    _require_command "$DMSETUP_PROG" dmsetup
>
>      modprobe dm-flakey >/dev/null 2>&1
>      $DMSETUP_PROG targets | grep flakey >/dev/null 2>&1
> @@ -2289,7 +2289,7 @@ _require_deletable_scratch_dev_pool()
>  _require_btrfs()
>  {
>         cmd=$1
> -       _require_command $BTRFS_UTIL_PROG btrfs
> +       _require_command "$BTRFS_UTIL_PROG" btrfs
>         if [ -z "$1" ]; then
>                 return 1;
>         fi
> @@ -2302,7 +2302,7 @@ _require_fio()
>  {
>         job=$1
>
> -       _require_command $FIO_PROG
> +       _require_command "$FIO_PROG" fio
>         if [ -z "$1" ]; then
>                 return 1;
>         fi
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index d559f8e..9b60ea5 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -51,7 +51,7 @@ _supported_os Linux
>  _require_scratch
>  _require_scratch_dev_pool 4
>  _require_deletable_scratch_dev_pool
> -_require_command $WIPEFS_PROG
> +_require_command "$WIPEFS_PROG" wipefs
>
>  rm -f $seqres.full
>
> diff --git a/tests/btrfs/004 b/tests/btrfs/004
> index 1d5b816..b548914 100755
> --- a/tests/btrfs/004
> +++ b/tests/btrfs/004
> @@ -53,7 +53,7 @@ _supported_os Linux
>  _require_scratch
>  _require_no_large_scratch_dev
>  _require_btrfs inspect-internal
> -_require_command "/usr/sbin/filefrag"
> +_require_command "/usr/sbin/filefrag" filefrag
>
>  rm -f $seqres.full
>
> diff --git a/tests/btrfs/011 b/tests/btrfs/011
> index 0207057..f4f2fbe 100755
> --- a/tests/btrfs/011
> +++ b/tests/btrfs/011
> @@ -63,7 +63,7 @@ _need_to_be_root
>  _supported_fs btrfs
>  _require_scratch_nocheck
>  _require_scratch_dev_pool 4
> -_require_command $BTRFS_SHOW_SUPER_PROG btrfs-show-super
> +_require_command "$BTRFS_SHOW_SUPER_PROG" btrfs-show-super
>
>  rm -f $seqres.full
>  rm -f $tmp.tmp
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> index 9e3f991..d513759 100755
> --- a/tests/btrfs/012
> +++ b/tests/btrfs/012
> @@ -57,9 +57,9 @@ _require_scratch_nocheck
>  BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
>  E2FSCK_PROG="`set_prog_path e2fsck`"
>
> -_require_command $BTRFS_CONVERT_PROG btrfs-convert
> -_require_command $MKFS_EXT4_PROG mkfs.ext4
> -_require_command $E2FSCK_PROG e2fsck
> +_require_command "$BTRFS_CONVERT_PROG" btrfs-convert
> +_require_command "$MKFS_EXT4_PROG" mkfs.ext4
> +_require_command "$E2FSCK_PROG" e2fsck
>
>  rm -f $seqres.full
>
> diff --git a/tests/btrfs/079 b/tests/btrfs/079
> index 202d3e6..4f59ff9 100755
> --- a/tests/btrfs/079
> +++ b/tests/btrfs/079
> @@ -61,7 +61,7 @@ _require_scratch
>  _need_to_be_root
>  # Since xfs_io's fiemap always use SYNC flag and can't be unset,
>  # we must use filefrag to call fiemap without SYNC flag.
> -_require_command "/usr/sbin/filefrag"
> +_require_command "/usr/sbin/filefrag" filefrag
>  _require_xfs_io_command "falloc"
>
>  filesize=$((10 * 1024 * 1024 * 1024)) #10G size
> diff --git a/tests/ext4/004 b/tests/ext4/004
> index 68f02b6..595cd7c 100755
> --- a/tests/ext4/004
> +++ b/tests/ext4/004
> @@ -72,8 +72,8 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>
> -_require_command $DUMP_PROG
> -_require_command $RESTORE_PROG
> +_require_command "$DUMP_PROG" dump
> +_require_command "$RESTORE_PROG" restore
>
>  rm -f $seqres.full
>  echo "Silence is golden"
> diff --git a/tests/xfs/094 b/tests/xfs/094
> index cb27559..cee42d6 100755
> --- a/tests/xfs/094
> +++ b/tests/xfs/094
> @@ -46,7 +46,7 @@ _supported_fs xfs
>  _supported_os IRIX Linux
>  _require_realtime
>  _require_scratch
> -_require_command $XFS_IO_PROG xfs_io
> +_require_command "$XFS_IO_PROG" xfs_io
>
>  _filter_realtime_flag()
>  {
> diff --git a/tests/xfs/103 b/tests/xfs/103
> index 113f643..cbe884f 100755
> --- a/tests/xfs/103
> +++ b/tests/xfs/103
> @@ -66,7 +66,7 @@ _filter_noymlinks_flag()
>  # real QA test starts here
>  _supported_os Linux IRIX
>  _supported_fs xfs
> -_require_command $XFS_IO_PROG xfs_io
> +_require_command "$XFS_IO_PROG" xfs_io
>  _require_scratch
>
>  _create_scratch
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 8f1d5b4..682ffb4 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -39,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  # real QA test starts here
>  _supported_fs xfs
>  _supported_os Linux
> -_require_command $INDENT_PROG "indent"
> +_require_command "$INDENT_PROG" indent
>
>  # filter out known changes to xfs type sizes
>  _type_size_filter()
> diff --git a/tests/xfs/195 b/tests/xfs/195
> index 76f130e..21fcb00 100755
> --- a/tests/xfs/195
> +++ b/tests/xfs/195
> @@ -65,7 +65,7 @@ _supported_os Linux
>
>  _require_test
>  _require_user
> -_require_command $XFSDUMP_PROG xfsdump
> +_require_command "$XFSDUMP_PROG" xfsdump
>
>  echo "Preparing subtree"
>  mkdir $TEST_DIR/d
> --
> 1.8.5.1
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
