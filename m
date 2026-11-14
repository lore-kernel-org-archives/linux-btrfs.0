Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675126;
	b=N9EjY7BLJ3olHqS1tkCxBYVkg48f0rPVrx0fGp6OH54bViMewVLzvuStoteEoVdU1i7B
	 JH7PFOkm8Iv2Iu0KHnOXTWH3yfF+MnAfpfYz9hWRjZZa9eoX2862pI9zNFe0mV+fcI96S
	 PFk4jra3qX+O6oSwYjF9hCN/5xwb3vPALC92WVG13lJ1uEBkCBsImmByP/uYdRj85rOoy
	 etTpX/tw9WSrcf+qIe7WQL5I8rOxJCMqsd6VrOPKwvK2duDcstNvp5TVq5rOyBIT8OMfF
	 E3EyMd0VJulr6Qzipnoqa4R6jxCPkrohmzEUDyjo4aY1T9ep/msxz+CNgsEZjFNBcTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675126;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Content-Type:Content-Transfer-Encoding;
	bh=0lqPMoLckk3hk/311uwxxNzds097FyRJTNyo3yq7jD8=;
	b=Foy/HmQ6hh+S1sKFuzfUlv51F8NpQ9ScskgHqL61gRfMpC/A5rph7Ki5Ujz14UBtEPNO
	 RIE3HiP4qfp9boQmKZq6bjfpCOWoUiv8fBEjXSCpSiUmNSg0X2l/JCP23yCxWuzW7EIFk
	 v4cPZ/d6y3SysgwJU/1ObrQtm3zccx1hL4O9JGYgr8M/4yIcFdZrW1Y/ckFSttNZhyB18
	 tODbJPBHUb7uCDwWsGDUi3zO0N4JDi//uFqCkpNpAC8yKm854A8HhSLyJWQbLnqDP904m
	 e4dHGQktKTF+6W+TdawbkF1MsmeoHXDp++z8ac+EEgep7/3bEfWPi4sxctJHFcUnC2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtbqYbVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166CB606A335
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtbqYbVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD7E1F000C4
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794675125;
	bh=0lqPMoLckk3hk/311uwxxNzds097FyRJTNyo3yq7jD8=;
	h=References:In-Reply-To:From:Date:Subject:To;
	b=ZtbqYbVxoeri4zNJQ3dyD7gG+iev/MsFY9pFTaGD1NEb/jhJjrjC4k4wZEozkjT5j
	 gK0qHBxwddmlJYb4fyjsjJ7R6NMdJFu/6AsZoBmOPV0U3WPzeMCLcAiNsOSnnY15G/
	 6IGqPL5/HxUMChyrfcBhPHpCYnGpDCJi3nTq3sBXZj2XYwK6svJkLdBUS45w4ogOcd
	 Ro87Qde6s28KkYpSZTxC7zFNZfLH63yXO2obrjow1jQoufAfBP4a3MoxYHGX9SnLZj
	 anQDWZOHGySKT61xdJX7ghrrgmBrJNdd73nPp909M61knyzCGwkQqBRbm1AcV5Phzy
	 XrKI/lyJnuKQw==
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7d2e14babc8so2356491137.2
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 08:52:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEFK8eY+k8fxpw2rgWqgITB5M3l+nCTKalWSEGBLcPF0em1NKKsxCEJCOneyrsD1dWeG05pg5dsLpqsPg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/r4kOMw1lP3nbrC0uJpIGiYAPXnAyPka3o/YsiPbzVovpeb3qN
	CYraluXtB7pXfTWk7o4XFAv5TFhe7Wlzmm3UzwgaVdKh/r7ajPvTzx0h1vfA7fbTqMahWdcLSdk
	CqKukLluMvNhO8IMr60n3yoABGf0+KNk=
X-Received: by 2002:a05:6102:510f:b0:7cc:3246:3095 with SMTP id
 ada2fe7eead31-7d64d8b73cbmr2413814137.34.1794675124824; Sat, 14 Nov 2026
 08:52:04 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
 <avh4IU-M5jYkc1uE@zlang-mailbox>
In-Reply-To: <avh4IU-M5jYkc1uE@zlang-mailbox>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sat, 14 Nov 2026 16:51:27 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4KZ-xerun6qOCxQDd4GPPj=B6KLZwa16rNQEVUKjAYDA@mail.gmail.com>
X-Gm-Features: AclHuK_pjttSZdxaRuKwogb5U38Qh2cC2BIZzwWFoyRfxpeZ7SVPYpG_nYw45pA
Message-ID: <CAL3q7H4KZ-xerun6qOCxQDd4GPPj=B6KLZwa16rNQEVUKjAYDA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test an incremental send scenario with hole punching
To: fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 3:05=E2=80=AFPM Zorro Lang <zlang@kernel.org> wrote=
:
>
> On Wed, Oct 21, 2026 at 09:17:25PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test an incremental send scenario where we punched a hole into a tail
> > section of a file extent item that is the last item in a leaf and the
> > next leaf in the subvolume tree was not changed (remains shared between
> > the parent and send snapshots).
> >
> > This currently fails and is fixed by the following kernel patch:
> >
> >   btrfs: send: fix missing hole punching during incremental send
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  tests/btrfs/362     | 84 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/362.out |  7 ++++
> >  2 files changed, 91 insertions(+)
> >  create mode 100755 tests/btrfs/362
> >  create mode 100644 tests/btrfs/362.out
> >
> > diff --git a/tests/btrfs/362 b/tests/btrfs/362
> > new file mode 100755
> > index 00000000..aca56540
> > --- /dev/null
> > +++ b/tests/btrfs/362
> > @@ -0,0 +1,84 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > +#
> > +# FS QA Test 362
> > +#
> > +# Test an incremental send scenario where we punched a hole into a tai=
l section
> > +# of a file extent item that is the last item in a leaf and the next l=
eaf in the
> > +# subvolume tree was not changed (remains shared between the parent an=
d send
> > +# snapshots).
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick send
> > +
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -fr $tmp.*
> > +     rm -fr $send_files_dir
> > +}
> > +
> > +. ./common/filter
> > +
> > +_require_test
> > +_require_scratch
> > +_require_btrfs_support_sectorsize 4096
> > +_require_xfs_io_command "fpunch"
> > +
> > +_fixed_by_kernel_commit xxxxxxxxxx \
> > +     "btrfs: send: fix missing hole punching during incremental send"
> > +
> > +send_files_dir=3D$TEST_DIR/btrfs-test-$seq
> > +
> > +rm -fr $send_files_dir
> > +mkdir $send_files_dir
> > +
> > +first_stream=3D"$send_files_dir/1.send"
> > +second_stream=3D"$send_files_dir/2.send"
> > +
> > +# We need a very specific leaf layout where we punch a hole in the las=
t file
> > +# extent item of a leaf and the next leaf was not modified in the send=
 snapshot,
> > +# so we set a fixed size of 16K.
> > +_scratch_mkfs -n 16K >> $seqres.full 2>&1 || _fail "first mkfs failed"
> > +_scratch_mount
> > +
> > +touch $SCRATCH_MNT/foo
> > +# 205 extents of 64K each with a 64K hole between them.
> > +for ((i =3D 0; i < 410; i +=3D 2)); do
> > +     offset=3D$((i * 64 * 1024))
> > +     $XFS_IO_PROG -c "pwrite -b 64K -S 0xab $offset 64K" \
> > +             $SCRATCH_MNT/foo > /dev/null
> > +done
> > +
> > +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
> > +
> > +# Punch a hole in the last 16K of the last file extent item of the fir=
st leaf,
> > +# which starts at file offset 12845056, so 12845056 + 64K - 16K =3D 12=
894208.
> > +# This does not cause any change in the second leaf of the fs tree, so=
 it will
> > +# be shared between the snapshots.
> > +$XFS_IO_PROG -c "fpunch 12894208 16K" $SCRATCH_MNT/foo
> > +
> > +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
> > +
> > +echo "File digest in the original fs: $(_md5_checksum $SCRATCH_MNT/sna=
p2/foo)"
> > +
> > +_btrfs send -f $first_stream $SCRATCH_MNT/snap1
> > +_btrfs send -f $second_stream -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
> > +
> > +# Create a new fs and apply both send streams.
> > +_scratch_unmount
> > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "second mkfs failed"
> > +_scratch_mount
> > +
> > +_btrfs receive -f $first_stream $SCRATCH_MNT
> > +_btrfs receive -f $second_stream $SCRATCH_MNT
> > +
> > +echo "File digest in the new fs:      $(_md5_checksum $SCRATCH_MNT/sna=
p2/foo)"
> > +
> > +# Check the region we punched a hole is full of zeroes.
> > +echo "Hole data:"
> > +od -A d -t x1 -j 12894208 -N $((16 * 1024)) $SCRATCH_MNT/snap2/foo
>
>
> Can this be replaced with common helper: _hexdump ?

I don't have a strong objection to that, but honestly I prefer it as
it is because it prints the addresses in decimal format, which is more
human readable and directly matches the value passed to the hole
punching operation above, making it easier to read.

Do you want to make the change yourself, or should I send a new
version just for that?

>
> Thanks,
> Zorro
>
> > +
> > +# success, all done
> > +_exit 0
> > diff --git a/tests/btrfs/362.out b/tests/btrfs/362.out
> > new file mode 100644
> > index 00000000..789abb53
> > --- /dev/null
> > +++ b/tests/btrfs/362.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 362
> > +File digest in the original fs: a5a06694d9f7fc3245afb2f391636e44
> > +File digest in the new fs:      a5a06694d9f7fc3245afb2f391636e44
> > +Hole data:
> > +12894208 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > +*
> > +12910592
> > --
> > 2.53.0
> >
> >
