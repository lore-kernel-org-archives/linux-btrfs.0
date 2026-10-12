Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3B2418348
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803127; cv=none; b=uRZx8V0Xcn6BrX1yokZZ6waS1/jJOSIvuHfs8S5aen496tuQHrZ5247dOZZwIvyJqcfDjgpkFr+pZVDB4hZ9NT9SzC/qnXsnFRBDwIpGJY0cepdfoq7rE2WEIA278E7B9A+NY8GQ7JQZvT/lUmRPhkaymWCkjnBQ6r4utqfre+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803127; c=relaxed/simple;
	bh=uSYuJuxYf5CYLSkKjCsurqq7KxXCdfdNnxu4pQitVZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dD1jqgIBwXftviEAQIBV9DCm1GYdM1+T12ZX/FeBs+ZtGeoUIXMAoawupn+10yjyh130yJCYQrO4rROhWG2VMDAWdvZNbx4jZK/1Mbai1QfwH27hop1y1piRrP5U0+RKAEgvXZnWlyEvU2B/nHXhHLy3wcVZfil2RwCzXuDRg8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsrQ98Fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsrQ98Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E444D1F008A0
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 11:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791803122;
	bh=jium8qoRQff7tf7aIB2kyynHhKF7RdmHYmbH57IDVSk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WsrQ98FgMVWALFjVvwIgyyEALI216qLYRq4Ln/nKiFo20NMZRQ2WWZEcUh/eh7nRb
	 GYeUlFCqJ7N9shEA6lLEYPoKWma5R9uO3nhw9BP+pJaZPZoJ5Gy1Yp7fO48O01hR06
	 2FczQ4qwOmBGRBNXqMeHowXS44AkB8vn9vpZHjFxEwXktKaoLaLX/TmMjMDPwGqNPH
	 s53xjQaa9vpveT0FdZ6XYcpll86BTbCSN7pqekkQBtXlfVclkqC82oiezhKtIcHsq0
	 vdgqxZiGSDWw0mNlPEZP+5xVYQlGPlpK/N6gfFxyWOkg65JI3cIAyFtS9XbAIEGiam
	 MCEWfswAbqrtw==
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-7cb3388613fso1132496137.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 04:05:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBywcVNDHbsxxC+oVGuCZlwj0B2k9HDtdheyMsMhwpuEW4x8RD5ypE0GBOcIQe20qiuhsfulUP4zxATszw==@vger.kernel.org
X-Gm-Message-State: AFq9FYINMjEqumQta7XtEZLSLe68DuymKEndQzXldn+8thJR5+5pdXxg
	HE5Dav7LJMNcZOTKUfUq9dP52LY5PNH4cTX2fjTcBkKdFY7n4RN7GARKXxjhUK4BqnQ9dwH6w+m
	Ekt+sQ1rZOJimlJj2nL+nzwDie+CIGJc=
X-Received: by 2002:a05:6102:160a:b0:7c1:bc57:c7f3 with SMTP id
 ada2fe7eead31-7cb3668a2c0mr2765728137.5.1791803121988; Mon, 12 Oct 2026
 04:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791395660.git.goledhruva@gmail.com> <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
In-Reply-To: <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 12 Oct 2026 12:04:44 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6FG=gWjJ-fy7FTBKSYyfUha2n93YbwtFFadMYU7ZuZjg@mail.gmail.com>
X-Gm-Features: AclHuK8jt1Zpu2UUOvRzMmgjp9cGQrMgtqQRcNtiOcV91NH7E1xMjXLl0ubm97U
Message-ID: <CAL3q7H6FG=gWjJ-fy7FTBKSYyfUha2n93YbwtFFadMYU7ZuZjg@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
To: Dhruva G <goledhruva@gmail.com>
Cc: fstests@vger.kernel.org, Anand Jain <asj@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org, 
	Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 8:40=E2=80=AFPM Dhruva G <goledhruva@gmail.com> wro=
te:
>
> Check that a bounded --nocomp request rewrites compressed extents in the
> selected range while distant untouched regions still point to their
> original compressed storage.
> Cover a partial final sector, zero length, a length extending past EOF,
> start at EOF, and the empty-file no-op. Preserve contents and sizes acros=
s
> the conversion and a remount.
>
> Add shared FIEMAP and integrity helpers for the NOCOMPRESS tests. Require
> full mapping coverage and inspect every overlapping extent so holes and
> partly converted ranges cannot pass. Include a small ioctl helper to
> probe kernel support and check errno without btrfs-progs translation.
>
> Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
> ---
>  .gitignore                |   1 +
>  common/btrfs_nocomp       | 134 ++++++++++++++++++++++++++++++++++++++
>  src/Makefile              |   2 +-
>  src/btrfs_defrag_nocomp.c |  63 ++++++++++++++++++
>  tests/btrfs/355           |  80 +++++++++++++++++++++++
>  tests/btrfs/355.out       |   2 +
>  6 files changed, 281 insertions(+), 1 deletion(-)
>  create mode 100644 common/btrfs_nocomp
>  create mode 100644 src/btrfs_defrag_nocomp.c
>  create mode 100755 tests/btrfs/355
>  create mode 100644 tests/btrfs/355.out
>
> diff --git a/.gitignore b/.gitignore
> index 0b6b9452..1bfa12ef 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -216,6 +216,7 @@ tags
>  /src/truncate
>  /src/t_btrfs_received_uuid_ioctl
>  /src/btrfs_ioctl
> +/src/btrfs_defrag_nocomp
>
>  # Symlinked files
>  /tests/generic/035.out
> diff --git a/common/btrfs_nocomp b/common/btrfs_nocomp
> new file mode 100644
> index 00000000..7e2111e1
> --- /dev/null
> +++ b/common/btrfs_nocomp
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) Meta Platforms, Inc. and affiliates.
> +# Helpers for BTRFS_DEFRAG_RANGE_NOCOMPRESS tests.
> +
> +_nc_require()
> +{

Such a odd name because:

1. All our require functions are named as _require_something, but here
the logic is inverted.

2. "nc" is not really intuitive, is rather cryptic, specially taking
into account this is specific for the no compress option for defrag -
there's no indication in the name this is defrag related.

> +       _require_scratch
> +       _require_test_program btrfs_defrag_nocomp
> +       _require_xfs_io_command fiemap ranged
> +       _require_btrfs_command filesystem defragment --nocomp
> +       _require_btrfs_no_nodatacow
> +       _require_btrfs_no_nodatasum
> +       _require_btrfs_no_autodefrag
> +       _require_btrfs_support_sectorsize 4096
> +       _wants_kernel_commit 009b2056cb25 \
> +               "btrfs: defrag: add flag to force no-compression"
> +}
> +
> +_nc_write()
> +{
> +       $XFS_IO_PROG -f -c "pwrite -S $4 -b 128K $2 $3" -c fsync "$1" \
> +               >> "$seqres.full" 2>&1 || _fail "write failed: $1"
> +}

A useless wrapper. Just make the tests call XFS_IO_PROG, this does not
add any value at all.

> +
> +_nc_probe()
> +{
> +       local result
> +
> +       _nc_write "$SCRATCH_MNT/probe" 0 131072 0x5a
> +       result=3D$($here/src/btrfs_defrag_nocomp "$SCRATCH_MNT/probe" 0 1=
31072) ||
> +               _fail "NOCOMPRESS probe failed"
> +       case "$result" in
> +       OK) ;;
> +       EOPNOTSUPP|ENOTTY) _notrun "kernel does not support NOCOMPRESS" ;=
;
> +       *) _fail "unexpected NOCOMPRESS probe result: $result" ;;
> +       esac
> +       rm -f "$SCRATCH_MNT/probe"
> +}

Too complex, we usually just call the user space utility on a simple
scenario that should never fail and if it fails we skip the test
saying the feature is not supported by the kernel.
And we do it in a _require_something function as well.

> +
> +_nc_defrag()
> +{
> +       local file=3D"${@: -1}"
> +
> +       $BTRFS_UTIL_PROG filesystem defragment --nocomp "$@" \
> +               >> "$seqres.full" 2>&1 || _fail "NOCOMPRESS defrag failed=
"
> +       $XFS_IO_PROG -c fsync "$file" >> "$seqres.full" 2>&1 ||
> +               _fail "fsync after defrag failed"
> +}

Another pointless wrapper.
I also dislike this practice of adding a _fail for everything.
Just let the tests fail with a golden output mismatch.

> +
> +_nc_map()
> +{
> +       $XFS_IO_PROG -c "fiemap -v $2 $3" "$1" > "$tmp.nc-map" \
> +               2>> "$seqres.full" || _fail "fiemap failed: $1"
> +       cat "$tmp.nc-map" >> "$seqres.full"
> +}

Yet another wrapper.

> +
> +# FIEMAP prints logical offsets in 512-byte units. Check every overlappi=
ng
> +# extent and complete coverage, so a hole or a partly converted range fa=
ils.
> +# The caller supplies byte offsets and lengths, including a partial EOF =
sector.
> +_nc_check_range()
> +{
> +       _nc_map "$1" "$2" "$3"
> +       $AWK_PROG -v start=3D"$2" -v len=3D"$3" -v mode=3D"$4" '
> +       BEGIN {
> +               first =3D int(start / 512)
> +               end =3D int((start + len + 511) / 512)
> +               next_block =3D first
> +       }
> +       $1 ~ /^[0-9]+:$/ && $5 ~ /^0x/ {
> +               gsub(/[^0-9]/, " ", $2)
> +               split($2, logical)
> +               lo =3D logical[1] + 0
> +               hi =3D logical[2] + 1
> +               if (hi <=3D first || lo >=3D end)
> +                       next
> +               if (mode =3D=3D "hole") {
> +                       bad =3D 1
> +                       next
> +               }
> +               flags =3D strtonum($5)
> +               encoded =3D and(flags, 0x8) !=3D 0
> +               unwritten =3D and(flags, 0x800) !=3D 0
> +               inline =3D and(flags, 0x200) !=3D 0
> +               if (and(flags, 0x6) || lo > next_block)
> +                       bad =3D 1
> +               if (mode =3D=3D "compressed" && (!encoded || unwritten ||=
 inline))
> +                       bad =3D 1
> +               if (mode =3D=3D "regular" && (encoded || unwritten || inl=
ine))
> +                       bad =3D 1
> +               if (mode =3D=3D "inline" && (!encoded || unwritten || !in=
line))
> +                       bad =3D 1
> +               if (mode =3D=3D "prealloc" && (encoded || !unwritten || i=
nline))
> +                       bad =3D 1
> +               if (hi > next_block)
> +                       next_block =3D hi
> +       }
> +       END { exit bad || (mode !=3D "hole" && next_block < end) }
> +       ' "$tmp.nc-map" || _fail "unexpected $4 mapping: $1 ($2, $3)"
> +}

Why do we need this level of complexity?
Adding an awk script to process fiemap output and detect unexpected
results is overly complex.

Why not do what we do in every other test that checks the extent
layout of a file?
Simply call fiemap in the test and add the expected output to the
golden output file.
That's simple, does the work and it's the preferred way to do things in fst=
ests.

> +
> +# Ignore flags such as LAST, which may change when another range is rewr=
itten.
> +_nc_mapping()
> +{
> +       _nc_map "$1" "$2" "$3"
> +       _filter_xfs_io_fiemap < "$tmp.nc-map" | \
> +               $AWK_PROG '{ print $1, $2, $3, $4 }'
> +}
> +
> +_nc_save_file()
> +{
> +       md5sum "$1" >> "$tmp.nc-checksums" || _fail "checksum failed: $1"
> +       stat -c '%s %n' "$1" >> "$tmp.nc-sizes" || _fail "stat failed: $1=
"
> +}

This name "save_file" is totally confusing.

> +
> +_nc_verify_files()
> +{
> +       local size file actual
> +
> +       md5sum -c "$tmp.nc-checksums" >> "$seqres.full" 2>&1 ||
> +               _fail "file contents changed"
> +       while read -r size file; do
> +               actual=3D$(stat -c %s "$file") || _fail "stat failed: $fi=
le"
> +               [ "$actual" =3D "$size" ] || _fail "file size changed: $f=
ile"
> +       done < "$tmp.nc-sizes"
> +}
> +
> +_nc_raw_expect()
> +{
> +       local expected=3D"$1" result
> +       shift
> +       result=3D$($here/src/btrfs_defrag_nocomp "$@") || _fail "raw ioct=
l failed"
> +       [ "$result" =3D "$expected" ] ||
> +               _fail "expected $expected, got $result"
> +}

This is all stuff we can do in the tests by calling md5sum and placing
the expected digest in the golden output file, like we do in many
other tests.

> diff --git a/src/Makefile b/src/Makefile
> index 76cf50c3..07bf681d 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -36,7 +36,7 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize pre=
allo_rw_pattern_reader \
>         fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail=
 \
>         detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>         uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alig=
nment \
> -       rw_hint fs-monitor btrfs_ioctl
> +       rw_hint fs-monitor btrfs_ioctl btrfs_defrag_nocomp
>
>  EXTRA_EXECS =3D dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>               btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/btrfs_defrag_nocomp.c b/src/btrfs_defrag_nocomp.c
> new file mode 100644
> index 00000000..4b066418
> --- /dev/null
> +++ b/src/btrfs_defrag_nocomp.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) Meta Platforms, Inc. and affiliates.
> +/* Issue NOCOMPRESS requests without userspace range/error translation. =
*/

Why do we need a C program?
Why not just have the tests call btrfs-progs:  btrfs filesystem
defragment --nocomp ....

This patchset adds an insane level of complexity for no good reason,
making the tests hard to read and maintain.

I can't see why just calling btrfs-progs, fiemap and md5sum directly
in the tests and then placing the expected output in the golden file
is not enough...

Thanks.


> +#include <errno.h>
> +#include <fcntl.h>
> +#include <linux/btrfs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +
> +#ifndef BTRFS_DEFRAG_RANGE_NOCOMPRESS
> +#define BTRFS_DEFRAG_RANGE_NOCOMPRESS (1ULL << 3)
> +#endif
> +
> +static unsigned long long number(const char *s)
> +{
> +       char *end;
> +       unsigned long long value;
> +
> +       errno =3D 0;
> +       value =3D strtoull(s, &end, 0);
> +       if (errno || *end || end =3D=3D s || *s =3D=3D '-') {
> +               fprintf(stderr, "invalid number: %s\n", s);
> +               exit(2);
> +       }
> +       return value;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       struct btrfs_ioctl_defrag_range_args range =3D { 0 };
> +       int fd, err =3D 0;
> +       const char *result;
> +
> +       if (argc !=3D 4) {
> +               fprintf(stderr, "usage: %s file start len\n", argv[0]);
> +               return 2;
> +       }
> +       range.flags =3D BTRFS_DEFRAG_RANGE_NOCOMPRESS;
> +       range.start =3D number(argv[2]);
> +       range.len =3D number(argv[3]);
> +       fd =3D open(argv[1], O_RDONLY | O_CLOEXEC);
> +       if (fd < 0) {
> +               perror("open");
> +               return 2;
> +       }
> +       if (ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range) < 0)
> +               err =3D errno;
> +       close(fd);
> +       switch (err) {
> +       case 0: result =3D "OK"; break;
> +       case EINVAL: result =3D "EINVAL"; break;
> +       case EOPNOTSUPP: result =3D "EOPNOTSUPP"; break;
> +       case ENOTTY: result =3D "ENOTTY"; break;
> +       default:
> +               fprintf(stderr, "unexpected errno %d (%s)\n", err, strerr=
or(err));
> +               return 1;
> +       }
> +       puts(result);
> +       return 0;
> +}
> diff --git a/tests/btrfs/355 b/tests/btrfs/355
> new file mode 100755
> index 00000000..12befb91
> --- /dev/null
> +++ b/tests/btrfs/355
> @@ -0,0 +1,80 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) Meta Platforms, Inc. and affiliates.
> +#
> +# FS QA Test 355
> +#
> +# Verify bounded NOCOMPRESS conversion and EOF range handling.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick defrag compress fiemap
> +
> +. ./common/filter
> +. ./common/btrfs_nocomp
> +
> +_nc_require
> +_scratch_mkfs -s 4k >> "$seqres.full" 2>&1 || _fail "mkfs failed"
> +_scratch_mount -o compress=3Dzlib
> +_nc_probe
> +
> +file=3D"$SCRATCH_MNT/range"
> +_nc_write "$file" 0 4194304 0x5a
> +_nc_save_file "$file"
> +_nc_check_range "$file" 0 4194304 compressed
> +_nc_mapping "$file" 0 131072 > "$tmp.prefix"
> +_nc_mapping "$file" 4063232 131072 > "$tmp.suffix"
> +
> +_nc_defrag -s 1M -l 512K "$file"
> +_nc_check_range "$file" 1048576 524288 regular
> +_nc_check_range "$file" 0 1048576 compressed
> +_nc_check_range "$file" 1572864 2621440 compressed
> +_nc_mapping "$file" 0 131072 > "$tmp.prefix-after"
> +_nc_mapping "$file" 4063232 131072 > "$tmp.suffix-after"
> +cmp -s "$tmp.prefix" "$tmp.prefix-after" || _fail "prefix mapping change=
d"
> +cmp -s "$tmp.suffix" "$tmp.suffix-after" || _fail "suffix mapping change=
d"
> +
> +# The two-sector tail can be compressed, unlike a single-sector tail on =
a
> +# 4K filesystem. First convert a one-byte range, then use an unaligned s=
tart
> +# and end the request at EOF, one byte into the final 4K sector.
> +tail=3D"$SCRATCH_MNT/partial"
> +_nc_write "$tail" 0 135169 0x39
> +_nc_save_file "$tail"
> +_nc_check_range "$tail" 131072 4097 compressed
> +_nc_defrag -s 128K -l 1 "$tail"
> +_nc_check_range "$tail" 131072 4096 regular
> +_nc_defrag -s 131073 -l 4096 "$tail"
> +_nc_check_range "$tail" 131072 4097 regular
> +
> +# Zero length means to EOF; a length extending past EOF must be clamped.
> +for mode in zero huge; do
> +       f=3D"$SCRATCH_MNT/$mode"
> +       _nc_write "$f" 0 262144 0x38
> +       _nc_save_file "$f"
> +       _nc_check_range "$f" 0 262144 compressed
> +       case "$mode" in
> +       zero) _nc_defrag -s 128K -l 0 "$f" ;;
> +       huge) _nc_defrag -s 128K -l 16M "$f" ;;
> +       esac
> +       _nc_check_range "$f" 0 131072 compressed
> +       _nc_check_range "$f" 131072 131072 regular
> +done
> +
> +# A nonempty file rejects start =3D=3D EOF, but an empty file is a no-op=
.
> +_nc_raw_expect EINVAL "$file" 4194304 4096
> +touch "$SCRATCH_MNT/empty" || _fail "create empty file failed"
> +_nc_save_file "$SCRATCH_MNT/empty"
> +_nc_raw_expect OK "$SCRATCH_MNT/empty" 0 0
> +_nc_verify_files
> +_scratch_cycle_mount compress=3Dzlib
> +_nc_verify_files
> +_nc_check_range "$file" 1048576 524288 regular
> +_nc_check_range "$file" 0 1048576 compressed
> +_nc_check_range "$file" 1572864 2621440 compressed
> +_nc_check_range "$tail" 131072 4097 regular
> +for mode in zero huge; do
> +       _nc_check_range "$SCRATCH_MNT/$mode" 0 131072 compressed
> +       _nc_check_range "$SCRATCH_MNT/$mode" 131072 131072 regular
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/355.out b/tests/btrfs/355.out
> new file mode 100644
> index 00000000..4e4c5e98
> --- /dev/null
> +++ b/tests/btrfs/355.out
> @@ -0,0 +1,2 @@
> +QA output created by 355
> +Silence is golden
> --
> 2.43.0
>
