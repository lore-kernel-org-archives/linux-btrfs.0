Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792745945;
	b=G8kqOEMT380Dx7fKe6+oT8z0BKLdumD2Jn4cJ8TwJnFNmFazTVSASAiLH2oLNckvOWX9
	 /A0XzkCXzoACxr8eRq0bcxNrWQir69t2SKsoTi2/3kZG8Ju4beV8n/lidi1Pom+fZvzfc
	 ZlZtEwYZhZMd4rm6bpHSd+lx34dn7u7pjKF6fpZzZW9d2zPiDnV8C4VDTyj4cyVq62dS4
	 iNujudSGyAbBmPraQl0rBxPk788Ly6nCcPylnJtGgvLvRC9rXgKLn2jO+AUBbLFKJRKbV
	 WjQ9pvqOzM2bhVl6rw5k3synzWf4i6Tcr/SzdiQVMuXhp4AwbfV/XyeqvgVCXocuR0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745945;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=XC4/7BWEVpdI5Gz3sarix5Zb88sOSjizSRYyuOGH0jU=;
	b=ZPujd8oXNI1JwCjdYOk8xnY+RgJUXxhpx68X+KeVvVDP1qfEfMe3BHCivniSMEJc5XVl
	 bmzatcbM4J8Bg8YbGgvJrCYG8vVNt4PASf3NKb0EEqKx85/9ae4cA+6lRoSP7G959ClHS
	 TuDjsbh8atc8Wy8S5WNHVNmdAayOE4BibkEoHLlcMmuLYxfLd02qfdvOl5zCoHEXdVQhw
	 w3TwjuWDsLQFAP9fheUt8opURI6HaCqcoWA4mwy2IXjOkrJVQvQnGuyLwEUeDdI2C0auI
	 oTGuVZhjqmP8fplLZpyy+VBtpkLxNJ7esgbPjTG0hfL4CQIj3WAcD1vfKIOUDoZEgqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXTyo27C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C7606A31B
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXTyo27C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85F41F031E1
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792745944;
	bh=XC4/7BWEVpdI5Gz3sarix5Zb88sOSjizSRYyuOGH0jU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JXTyo27CdLLPCOPCTlFqiMm9elmB1Y2vSNf+9CShKCG+y/8Cl4ZumbFOFt6ZrD3QY
	 2/hbn/hTbGga0xnIXb+WAv/LtNwk9aAME1883GS85pM/alThd4oBGEY2pdneDHrgBB
	 icsv6st0DxVyhbH22ln+n51F2RwyJMJVKaG/rKE4yn86GDyONJyH6v0icYrZORSIHQ
	 RCY0iJ9rfy643zAnU2UWEcQ6nc7R3v1Pt2j2FkYgk7lSVwP3ttam5pN5trIT4+F6qp
	 8jfEatzSEmp+C/XCe/O5Nh0P7HPckGJOPoiLFymF5IXp2PUMeakIaSyCyekX78L9io
	 74k7v4gjFz3Rg==
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-980c4f5c921so279913241.2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 01:59:04 -0700 (PDT)
X-Gm-Message-State: AFq9FYJw8cIaV4tQ3B987jaDGkFlqPxsFieM/Q4kdWYTa7lDYkknrDqp
	sh/gBKocVWWuMSh+Fij36M1BVb/IlDOldjiSDjIOnWd27VLbkc2APA8oEMh/9BUU8msgJRa0Qdz
	ybQkYa7KetXyuOyTHmaejI8KzOsMztUc=
X-Received: by 2002:a05:6102:d92:b0:7cc:23e7:e742 with SMTP id
 ada2fe7eead31-7ccc32777e9mr597701137.21.1792745944081; Fri, 23 Oct 2026
 01:59:04 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 23 Oct 2026 09:58:27 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5sKk3+P=AUf1OQ8mgD3Sb6hnDiuhgBMmovo-Wc1Ub99A@mail.gmail.com>
X-Gm-Features: AclHuK-NG4ZMe9pfrcpZvYuait6K4jlxe2DSDNlZHtrv8iEnsWP4X38s5zFHxHA
Message-ID: <CAL3q7H5sKk3+P=AUf1OQ8mgD3Sb6hnDiuhgBMmovo-Wc1Ub99A@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 10:15=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> A data extent in a block-group that uses the RAID stripe tree has its log=
ical
> to physical mapping stored in that tree, which only becomes durable when =
the
> stripe tree is written out at transaction commit. The log tree cannot car=
ry
> that mapping, so an fsync served by the log logs a file-extent item whose
> logical range could not be resolved afterwards. Log replay restored the f=
ile
> with the correct size, but reading it failed with EIO.
>
> Extents reach the log both from log_one_extent() and from copy_items(), s=
o
> cover a fast fsync and a full fsync.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v2:
> - Also test full fsync
>
>
>  tests/btrfs/363     | 67 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/363.out | 15 ++++++++++
>  2 files changed, 82 insertions(+)
>  create mode 100755 tests/btrfs/363
>  create mode 100644 tests/btrfs/363.out
>
> diff --git a/tests/btrfs/363 b/tests/btrfs/363
> new file mode 100755
> index 00000000..834f2673
> --- /dev/null
> +++ b/tests/btrfs/363
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 363
> +#
> +# Test that data fsynced on a RAID stripe tree file system is still read=
able
> +# after a power failure, both for a fast fsync and for a full fsync.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log volume raid-stripe-tree
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +       "btrfs: force a transaction commit when fsyncing stripe-tree exte=
nts"
> +
> +_cleanup()
> +{
> +       _cleanup_flakey
> +       rm -fr $tmp
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_btrfs_mkfs_feature "raid-stripe-tree"
> +_require_btrfs_fs_feature "raid_stripe_tree"
> +_require_scratch
> +_require_dm_target flakey
> +
> +# DUP keeps its mapping in the stripe tree, so a single device is enough=
 and
> +# dm-flakey can be layered on top of it.
> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || =
\
> +       _fail "mkfs failed"
> +
> +_init_flakey
> +_scratch_mount
> +
> +# The first fsync of an inode is always a full fsync. Do one here and th=
en
> +# commit the transaction, so that the second fsync of this file below is=
 a
> +# fast fsync.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | =
\
> +       _filter_xfs_io
> +_scratch_sync
> +
> +# Fast fsync: only the extents changed since the last fsync are logged.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +       _filter_xfs_io
> +
> +# Full fsync: this is the first fsync of this inode, so all of its items=
 are
> +# logged.
> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | =
\
> +       _filter_xfs_io

Btw this is not a very good way to test.

If we have a regression in the fast fsync path someday, this test will
miss it, because the full fsync on file 'full' triggers a transaction
commit, hiding the bug in the fast fsync path for file 'fast'.

So we should test differently:

1) do fast fsync
2) trigger power failure and mount
3) check file 'fast' data
4) do the full fsync
5) trigger power failure and mount
6) check file 'full' data

Sashiko pointed this:

https://sashiko.dev/#/patchset/20261022090754.2584747-1-johannes.thumshirn%=
40wdc.com

Thanks.


> +
> +# Simulate a power failure. The log is replayed on the next mount and bo=
th
> +# files must still have the data they were fsynced with.
> +_flakey_drop_and_remount
> +
> +echo "fast fsync:"
> +_hexdump $SCRATCH_MNT/fast
> +echo "full fsync:"
> +_hexdump $SCRATCH_MNT/full
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
> new file mode 100644
> index 00000000..fcf6e0a7
> --- /dev/null
> +++ b/tests/btrfs/363.out
> @@ -0,0 +1,15 @@
> +QA output created by 363
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fast fsync:
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >...............=
.<
> +*
> +020000
> +full fsync:
> +000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >...............=
.<
> +*
> +020000
> --
> 2.56.0
>
>
