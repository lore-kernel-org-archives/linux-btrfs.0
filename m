Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794691299;
	b=C5ekNo542CI/67yBMW6ufyUUO2GPAETZ1REpkkxwr0JU2olBIBZLV8qQ7TsJeDckGbN6
	 wYQcaO0JPBupoXFVGBiv3DmNSjU4MMwRtJpAhYEWnF1qha6GM6Z2t7LwrtXI9ojGOHzvG
	 jaViZUzisihkGuuT1uqIZEWmMbJS5k5mCDFlvGw0VRHtaiC5l9uDutxd8mxD0zuN8qbzl
	 V4G2b/gUVDDWj8WV3TaiLh3KPSPh0trFWh4+8J3gyexmGnrUyxxfnDrd4oFPHl5pI8m5g
	 9Md5lnpaOOfF2UvuDRi+A/0rW8reJnzL98JUgsSRTpR37+nS9P/dn+uQWbKk21pgppA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794691299;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=9ZuyfI8WkgRbBjR5eKXmMTqwvLagRhNhdq+B2h7eXsM=;
	b=opauw1fvuV/ZSTPIOANkjVyuLnCd1KefnAPzfnUghKOueJdKDgMDxzb2fB5VSA4zRi8T
	 ZJEgRPXTiWR2M+8NVvlBqz3I08M7IvclHQO7MfaXgf8Z4UtKN6jQ0heZV8GbsxHMStBWq
	 AEhblDwPNaOa4/pQOPb9rVaFb9JLFLmCjKtnOH0lnTXvzLH8swoiz4trm7V1d3STxw0s6
	 tqOvTmYdr2zn8oZL5LmpaKn7Z+VfjZFWdB21IXxu8pti2ThdKduIvPisDjJ+aYoFZHAYg
	 Ln4WCbAqI8eKfTtB5yT788zgp2LgE04/2ECSUOo4SfB0vAbXzPzQPvl/nkquDSVXg7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hl2qXjvy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2C3606A323;
	Sat, 14 Nov 2026 21:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hl2qXjvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1DE1F000C4;
	Sat, 14 Nov 2026 21:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794691298;
	bh=9ZuyfI8WkgRbBjR5eKXmMTqwvLagRhNhdq+B2h7eXsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hl2qXjvyTPbgveEoOYYSLcMi9XViHfZ8y+dP6GiiCm27R0EiaDvMkEhJEJa3QzLtZ
	 olNOLDYswLR7Zh3Vydegv3MZl9W54nXROrvQ2gNVCgNWBj2ah+sY5CHDWlrajh1R7W
	 jo3+jG+BUdPLAjyIQV5TL4sz7GWZV74mc8GemyoEwaXoHHIthTh1+aV8va5RCCClKU
	 5QwMKzyDjJNGebdG4UnFZT8FPdRtpGm/PMIurxEQOHy+BxG4J0tIVOQNbxklBmR5E3
	 4We2fIfihWd2ycyIh9e9uNSmYIh6KyzzhFUsNWmLZlh7ZxxqN7IZMWOe3tNFIPbw1f
	 x2uKDXzoaCe3A==
Date: Sun, 15 Nov 2026 05:21:30 +0800
From: Zorro Lang <zlang@kernel.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test an incremental send scenario with hole
 punching
Message-ID: <avjP-YcABrnO5RZ1@zlang-mailbox>
Mail-Followup-To: Filipe Manana <fdmanana@kernel.org>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
 <avh4IU-M5jYkc1uE@zlang-mailbox>
 <CAL3q7H4KZ-xerun6qOCxQDd4GPPj=B6KLZwa16rNQEVUKjAYDA@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4KZ-xerun6qOCxQDd4GPPj=B6KLZwa16rNQEVUKjAYDA@mail.gmail.com>

On Sat, Nov 14, 2026 at 04:51:27PM +0000, Filipe Manana wrote:
> On Sat, Nov 14, 2026 at 3:05 PM Zorro Lang <zlang@kernel.org> wrote:
> >
> > On Wed, Oct 21, 2026 at 09:17:25PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Test an incremental send scenario where we punched a hole into a tail
> > > section of a file extent item that is the last item in a leaf and the
> > > next leaf in the subvolume tree was not changed (remains shared between
> > > the parent and send snapshots).
> > >
> > > This currently fails and is fixed by the following kernel patch:
> > >
> > >   btrfs: send: fix missing hole punching during incremental send
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  tests/btrfs/362     | 84 +++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/btrfs/362.out |  7 ++++
> > >  2 files changed, 91 insertions(+)
> > >  create mode 100755 tests/btrfs/362
> > >  create mode 100644 tests/btrfs/362.out
> > >
> > > diff --git a/tests/btrfs/362 b/tests/btrfs/362
> > > new file mode 100755
> > > index 00000000..aca56540
> > > --- /dev/null
> > > +++ b/tests/btrfs/362
> > > @@ -0,0 +1,84 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 362
> > > +#
> > > +# Test an incremental send scenario where we punched a hole into a tail section
> > > +# of a file extent item that is the last item in a leaf and the next leaf in the
> > > +# subvolume tree was not changed (remains shared between the parent and send
> > > +# snapshots).
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick send
> > > +
> > > +_cleanup()
> > > +{
> > > +     cd /
> > > +     rm -fr $tmp.*
> > > +     rm -fr $send_files_dir
> > > +}
> > > +
> > > +. ./common/filter
> > > +
> > > +_require_test
> > > +_require_scratch
> > > +_require_btrfs_support_sectorsize 4096
> > > +_require_xfs_io_command "fpunch"
> > > +
> > > +_fixed_by_kernel_commit xxxxxxxxxx \
> > > +     "btrfs: send: fix missing hole punching during incremental send"
> > > +
> > > +send_files_dir=$TEST_DIR/btrfs-test-$seq
> > > +
> > > +rm -fr $send_files_dir
> > > +mkdir $send_files_dir
> > > +
> > > +first_stream="$send_files_dir/1.send"
> > > +second_stream="$send_files_dir/2.send"
> > > +
> > > +# We need a very specific leaf layout where we punch a hole in the last file
> > > +# extent item of a leaf and the next leaf was not modified in the send snapshot,
> > > +# so we set a fixed size of 16K.
> > > +_scratch_mkfs -n 16K >> $seqres.full 2>&1 || _fail "first mkfs failed"
> > > +_scratch_mount
> > > +
> > > +touch $SCRATCH_MNT/foo
> > > +# 205 extents of 64K each with a 64K hole between them.
> > > +for ((i = 0; i < 410; i += 2)); do
> > > +     offset=$((i * 64 * 1024))
> > > +     $XFS_IO_PROG -c "pwrite -b 64K -S 0xab $offset 64K" \
> > > +             $SCRATCH_MNT/foo > /dev/null
> > > +done
> > > +
> > > +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
> > > +
> > > +# Punch a hole in the last 16K of the last file extent item of the first leaf,
> > > +# which starts at file offset 12845056, so 12845056 + 64K - 16K = 12894208.
> > > +# This does not cause any change in the second leaf of the fs tree, so it will
> > > +# be shared between the snapshots.
> > > +$XFS_IO_PROG -c "fpunch 12894208 16K" $SCRATCH_MNT/foo
> > > +
> > > +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
> > > +
> > > +echo "File digest in the original fs: $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
> > > +
> > > +_btrfs send -f $first_stream $SCRATCH_MNT/snap1
> > > +_btrfs send -f $second_stream -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
> > > +
> > > +# Create a new fs and apply both send streams.
> > > +_scratch_unmount
> > > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "second mkfs failed"
> > > +_scratch_mount
> > > +
> > > +_btrfs receive -f $first_stream $SCRATCH_MNT
> > > +_btrfs receive -f $second_stream $SCRATCH_MNT
> > > +
> > > +echo "File digest in the new fs:      $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
> > > +
> > > +# Check the region we punched a hole is full of zeroes.
> > > +echo "Hole data:"
> > > +od -A d -t x1 -j 12894208 -N $((16 * 1024)) $SCRATCH_MNT/snap2/foo
> >
> >
> > Can this be replaced with common helper: _hexdump ?
> 
> I don't have a strong objection to that, but honestly I prefer it as
> it is because it prints the addresses in decimal format, which is more
> human readable and directly matches the value passed to the hole
> punching operation above, making it easier to read.
> 
> Do you want to make the change yourself, or should I send a new
> version just for that?

If I were to change it, I'd have to merge the kernel patch above, rebuild and
install the kernel, run the tests, and then update the .out file.
Never mind, just using od works fine too, since the _hexdump helper was
originally introduced to replace the widespread use of the hexdump command
anyway. Anyway, no need to send a new version. If I find some time, I'll
make the change myself, or merging it directly :)

Thanks,
Zorro

> 
> >
> > Thanks,
> > Zorro
> >
> > > +
> > > +# success, all done
> > > +_exit 0
> > > diff --git a/tests/btrfs/362.out b/tests/btrfs/362.out
> > > new file mode 100644
> > > index 00000000..789abb53
> > > --- /dev/null
> > > +++ b/tests/btrfs/362.out
> > > @@ -0,0 +1,7 @@
> > > +QA output created by 362
> > > +File digest in the original fs: a5a06694d9f7fc3245afb2f391636e44
> > > +File digest in the new fs:      a5a06694d9f7fc3245afb2f391636e44
> > > +Hole data:
> > > +12894208 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > +*
> > > +12910592
> > > --
> > > 2.53.0
> > >
> > >
> 
