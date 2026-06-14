Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FFF70830;
	Sun, 14 Jun 2026 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781450689; cv=none; b=dhJQECKrQNFJzrmSXq9BTyyJ2bOHdmEJLN7CY3dVo5LpmklKKH++ogRE43l5VkVyZT4QHysECSLOH5XPK4JvMZv1Z4DhTybO/eaSTCUm+/SWO9yoJMzP9FDSyj3H2KuWMQFkkM6CzV+ZjvEXS5KXnluvxmJctS1O/H22qZ4GVGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781450689; c=relaxed/simple;
	bh=JagBFG1XjZ1lHpzlNBDWnk5TVqL64k0g9kR5hS570AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrDu9eDaooPlC6zXzfM5Y/8P9imILYs/lo5Lfk6rqXj/g6Ng5/ACLNwzprDw+IUCq6uaBYvPhuCx9hCVuRmrNULV65JXE0hS2FTuzRFtXjPLz3QsCIxzmsActjDNmcldY0ABzXSzjHAS4KCB1oA3/CXUN/T/3cIZuZTsoB+pS3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbJjHpxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbJjHpxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0931F000E9;
	Sun, 14 Jun 2026 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781450688;
	bh=kZS1/zBQAKHaQ7b6ooIdy/HggP1MlkR7XKg5P/6oScY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QbJjHpxybdbiRtaomm6qyZ3wluhq8nVdQbfJuzinjVmIJwCye3b6vzzeHr3T2pcAC
	 D2DmXCCJiKK97HAMzNgJyHxpyzlMRXl5kpBJ7F2l1pSdM/mUUiQ1x7m4LWemrIZ31P
	 NWTnjBnILdU2z3acVOwapzk/zngsz4iL+LVScGRjNLLog+ODxHLHefMCAfvKhcNsyP
	 bnDb+DajpPZJ5kBg4olY1xPPTlWQwQjoV0UEn7rJi5V6ivJy4IubEPpDbqEcUUoeIp
	 QRX/fyHTLvtYXNMkoo2DuUo3QoE9wJpvCbYuuMpwuzdapar+5MS5Sqh2ilp63GNwuM
	 NQ1hoJW4/P4jQ==
Date: Sun, 14 Jun 2026 23:24:40 +0800
From: Zorro Lang <zlang@kernel.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add a test case for writes with prealloc
 extents beyond i_size
Message-ID: <ai7Fm0OzuKXV1zHw@zlang-mailbox>
Mail-Followup-To: Filipe Manana <fdmanana@kernel.org>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
 <CAL3q7H7hCDQJxk1an8mk7030fb=qVdCeHaqza=H4DbCvWxtvrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7hCDQJxk1an8mk7030fb=qVdCeHaqza=H4DbCvWxtvrQ@mail.gmail.com>

On Sun, Jun 14, 2026 at 11:57:39AM +0100, Filipe Manana wrote:
> On Thu, May 28, 2026 at 11:27 AM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test writing into a file range containing prealloc extents beyond the current
> > i_size, with an unmount and mount after fallocate and the write, to verify
> > that the file data, size and extent layout were not lost.
> >
> > This used to fail on btrfs when not using the no-holes feature (which is
> > a default since btrfs-progs 5.15) before this recent kernel fix:
> >
> >    080ecbd05432 ("btrfs: mark file extent range dirty after converting prealloc extents")
> >
> > So in order to reproduce the failure when using an unpatched kernel and
> > a btrfs-progs >= 5.15, one must run the test with:
> >
> >    MKFS_OPTIONS="-O ^no-holes"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Zorro, this is missing in the patches-in-queue branch (and for-next).
> Did you miss this?

Hi Filipe,

Sorry, I got this patch mixed up with another one -- 32b4dfff ("generic: add a
test case for fallocate i_size extension"). They have the same author, reviewer,
and case number, and even their commit logs look very similar. At first glance,
I mistakenly thought it was a patch I had already merged :-P

Thank you for pointing this out. I will test it and merge it into the
patches-in-queue branch right away, and it will be released next week
along with the others.

Thanks,
Zorro

> 
> Thanks.
> 
> > ---
> >  tests/generic/796     | 54 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/796.out | 10 ++++++++
> >  2 files changed, 64 insertions(+)
> >  create mode 100755 tests/generic/796
> >  create mode 100644 tests/generic/796.out
> >
> > diff --git a/tests/generic/796 b/tests/generic/796
> > new file mode 100755
> > index 00000000..c42a4722
> > --- /dev/null
> > +++ b/tests/generic/796
> > @@ -0,0 +1,54 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > +#
> > +# FS QA Test 796
> > +#
> > +# Test writing into a file range containing prealloc extents beyond the current
> > +# i_size, with an unmount and mount after fallocate and the write, to verify
> > +# that the file data, size and extent layout were not lost.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc preallocrw fiemap
> > +
> > +. ./common/filter
> > +. ./common/punch # for _filter_fiemap
> > +
> > +_require_scratch
> > +_require_xfs_io_command "falloc" "-k"
> > +_require_xfs_io_command "fiemap"
> > +
> > +_fixed_by_fs_commit btrfs 080ecbd05432 \
> > +       "btrfs: mark file extent range dirty after converting prealloc extents"
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +# The fiemap results in the golden output requires file allocations to align to
> > +# 1M boundaries.
> > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > +
> > +# Create our file with a size of 0 and a prealloc extent in the range [0, 2M].
> > +$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
> > +
> > +# Unmount and mount again to remove any in memory state of the inode. We will
> > +# verify later that neither metadata nor extents were lost during unmount.
> > +_scratch_cycle_mount
> > +
> > +# Write into the [0, 1M] range, which increases the inode's i_size.
> > +$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filter_xfs_io
> > +
> > +# Unmount and mount again to remove any in memory state of the inode. We will
> > +# verify later that neither metadata nor extents were lost during unmount.
> > +_scratch_cycle_mount
> > +
> > +# Check file data (and size).
> > +echo "File data:"
> > +_hexdump $SCRATCH_MNT/foo
> > +
> > +# Check we have unwritten extents in range [1M, 2M].
> > +echo "Fiemap output:"
> > +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
> > +
> > +# Success, all done.
> > +_exit 0
> > diff --git a/tests/generic/796.out b/tests/generic/796.out
> > new file mode 100644
> > index 00000000..c6c6e6a8
> > --- /dev/null
> > +++ b/tests/generic/796.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 796
> > +wrote 1048576/1048576 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +File data:
> > +000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >................<
> > +*
> > +100000
> > +Fiemap output:
> > +0: [0..2047]: data
> > +1: [2048..4095]: unwritten
> > --
> > 2.47.2
> >
> >
