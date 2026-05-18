Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9E43FDBE7;
	Mon, 18 May 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779121745; cv=none; b=FyW93UVHNWkxRViL3a26hCsk6ZiZ3RLwUIG/tmdOgnNyvqwk8+sEb52QoSO9hiR0NC4+P/QIzgpA800HhvUEGoLtA3YbZ+X0rHNCOB5ud3HZHD/6LwaFaqlFPKCmhlbgNXglfc7lagfZPMfjQSdCGakeajfY1MVDTrslYV2rFAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779121745; c=relaxed/simple;
	bh=QQUGz4eLND2h7NTphEtgU7ovr8O3uF+aeDJIcNJawYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R391FoVBPUvGIwLXSb9ktf6xtZeESjh9zc6CGQEnxw36gyoGeT1Bayyh15AxOMJYIn/rHd5d424TZb+tl7qT0T6hnHgFDOD9rO2zP+zqxVAmG+FciGJWrd6GMxJxoe8QcbUxGNSGSs8NjeSwiU6IDm/vjcQul7NLxh9aDvOfoS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ho9MqfrO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mX/oBwcX; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ho9MqfrO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mX/oBwcX"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id C84CDEC02C1;
	Mon, 18 May 2026 12:29:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 18 May 2026 12:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779121741; x=1779208141; bh=MmB60suihx
	ljgoG2iigS/1+XdFxZhE7augVe4mxsZCg=; b=ho9MqfrOzSV7DDS6AykiXtLAMj
	NGVu/7eWytSYZ0+ddEGbs/HxEzue9o0wabvRYVrX3nCBrAC9Z9wXBFOHcGghWsNP
	YWiShxEjWOHdkX+al8QkjhXV7Z7PyzO9bgB2orGjyFzRdTWfnQXPsqhJw4icwW0n
	rVeUVIZajT+qtJfSnFUluYgKUnX3Rd+KIpvknA/KMYFx7ektAwmyuRPsKHNICQZl
	/8MarKUjkksLPaNsCnEGaBdRrUpF9ZAR+ySgfVk5nQUvheMYg+MXRDifDOsTZKRy
	5mI2zdkp8AejRgycW+MHeI/NXjRuhSVwK7SVhMEzj6GR0c+txENnySgrWyzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779121741; x=1779208141; bh=MmB60suihxljgoG2iigS/1+XdFxZhE7augV
	e4mxsZCg=; b=mX/oBwcX3JROuVHW5LoAMxBwwfQezEHtsfmofbYtcxdha2SeS6r
	gEzGd+WEhcn9tTy+JoPu2Ivv2YMKJT6bV/+4Ei3enN6Yawz9wc+sXj+edGVJLpGQ
	igM5cSGnV68UzzowEeeNiMSCNn0M2m7Q9YBJO1PcjMqv5/jscvTtW8uxjhMiZjgy
	LqCv4fKrFj0TVzqo+RFXskTk6KJKYwt5yELscfRNGoy1ID44j9b0nQWfnfUMOfPu
	rCsK+lRQBO4RmN8HvFyu8WZF4+UP+ipIfIEiLORGs1IM/nzTpgrZicLPkBQMeV5l
	7x9jHxDpwjeWV++8lyDAZdsy3IPro8GnkjA==
X-ME-Sender: <xms:TT4LaodpGPPiwQCshRCsj3ij0hUFvdz772AaUefo-VlIUcdJdHKBEQ>
    <xme:TT4LaoBGyKNp873xBlNBiNr89biLCL4vHKUHC6hATsFF4SnGZmh63y7wRBxAuZfzS
    YwVgX9RRoBfXIPcvnYGa_8z1dFbK9UG8_FTB9g5aBf_520mPr2PDw>
X-ME-Received: <xmr:TT4Laj863lagDQalThVyDPJ6vUIuS3aGTz7ce_HRTaNqsHbzHAP1ToigFDehkNsiZrBLrpppiQYXQcaujOBkiWJh-kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufeelfeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepkedvkeffjeellefhveehvdejudfhjedthfdvveeiie
    eiudfguefgtdejgfefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeegpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopegrnhgrjhgrihhnrdhsghesghhmrghilhdr
    tghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghpthht
    ohepfhhsthgvshhtshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:TT4LarK0nUdfszE-fOHPAJQIrqqEH6l8rHFTt0IvkSLVjhiL3XL0EA>
    <xmx:TT4LakjvgKYMYWXWEViSOaew_TAvaUXzvLwdB-L2PYcygn_XV4MILA>
    <xmx:TT4Laj54bd2UUZTQk-GSFutbg0ocJqNMcgu0K9fjEl32or4E4tffeQ>
    <xmx:TT4LakZ53uHLJYKNHN-76b1cJ9AtXTtdD-I2az3mHjr1IN6buifFVA>
    <xmx:TT4LakvulM1Rfpg9rwcgU3qkPBcHAUgS9mFAGWevQFde0T0DsZ9vbvXo>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 May 2026 12:29:00 -0400 (EDT)
Date: Mon, 18 May 2026 09:28:41 -0700
From: Boris Burkov <boris@bur.io>
To: Anand Jain <anajain.sg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: test qgroup deletion races with squota writes
Message-ID: <20260518162841.GA3181893@zen.localdomain>
References: <cover.1778632843.git.boris@bur.io>
 <2c8668284ded13c7cc63ece213d9e1edc3e6ea85.1778632843.git.boris@bur.io>
 <e29e3b26-bd22-41d7-92f0-8d89bf73f5ea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e29e3b26-bd22-41d7-92f0-8d89bf73f5ea@gmail.com>

On Mon, May 18, 2026 at 05:18:18PM +0800, Anand Jain wrote:
> 
> 
> It appears that transaction commit could race with the testcase.
> 

Thank you for running the test and reporting the failure, sorry for the
inconvenience.

> 
> --------
> SECTION       -- gen
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 vm1 7.1.0-rc3-gf5d9f327e4b2 #14 SMP

What kernel branch are you running this on? I couldn't find the sha
f5d9f327e4b2, but I took a look at linus's 7.1-rc3 tag and the fixes
aren't there:

$ git ql v7.1-rc3 fs/btrfs/qgroup.c
e0a85137a882 btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
9a0448847310 btrfs: unexport btrfs_qgroup_reserve_meta()
534c0adacdeb btrfs: collapse __btrfs_qgroup_reserve_meta() into btrfs_qgroup_reserve_meta_prealloc()
5adf3f32c0b3 btrfs: collapse __btrfs_qgroup_free_meta() into btrfs_qgroup_free_meta_prealloc()

vs.

$ git ql btrfs/for-next fs/btrfs/qgroup.c
5c3eb7a1bce0 btrfs: swallow btrfs_record_squota_delta() ENOENT
5e4ccd2a4e70 btrfs: clamp to avoid squota underflow
ed2bb38054d9 btrfs: fix squota accounting during enable generation
404bf5a24f2e btrfs: check for subvolume before deleting squota qgroup
452a1a22e98b btrfs: add missing unlikely to if branches leading to a DEBUG_WARN()
e0a85137a882 btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
9a0448847310 btrfs: unexport btrfs_qgroup_reserve_meta()

I believe that:
404bf5a24f2e btrfs: check for subvolume before deleting squota qgroup

is the critical one, as mentioned in the test's "You _MAY_ be missing
kernel fix" section. Do you have that patch?

If not, I think that is the most likely explanation.

Thanks,
Boris

> PREEMPT_DYNAMIC Sun May 17 21:25:06 +08 2026
> MKFS_OPTIONS  -- -f /dev/vde
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vde
> /mnt/scratch
> 
> btrfs/348    10s ... - output mismatch (see
> /Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad)
>     --- tests/btrfs/348.out	2026-05-18 14:04:31.427635000 +0800
>     +++ /Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad
> 2026-05-18 17:13:33.000000000 +0800
>     @@ -5,6 +5,4 @@
>      ERROR: unable to destroy quota group: Device or resource busy
>      ERROR: unable to create quota group: Invalid argument
>      same txn destroy race
>     -ERROR: unable to destroy quota group: Device or resource busy
>      pre-existing data destroy
>     -ERROR: unable to destroy quota group: Device or resource busy
>     ...
>     (Run 'diff -u /Volumes/work/ws/fstests/tests/btrfs/348.out
> /Volumes/work/ws/fstests/results//gen/btrfs/348.out.bad'  to see the
> entire di)
> 
> HINT: You _MAY_ be missing kernel fix:
>       XXXXXXXXXXXX btrfs: check for subvolume before deleting squota qgroup
> 
> HINT: You _MAY_ be missing kernel fix:
>       0c309d66dacd btrfs: forbid creating subvol qgroups
> 
> Ran: btrfs/348
> Failures: btrfs/348
> Failed 1 of 1 tests
> 
> 
> Thanks, Anand
> 
> 
> 
> 
> 
> 
> 
> On 13/5/26 08:43, Boris Burkov wrote:
> > When using simple quotas, an extent's EXTENT_OWNER_REF can long outlive
> > the subvolume that created it, since the extent can pick up additional
> > references that keep it alive after the owning subvolume is deleted.
> > 
> > Several lifecycle bugs around the owning qgroup arise from this:
> > 
> >   1. Freeing an extent whose owner qgroup is gone: must not cause an
> >      underflow nor a transaction abort.
> > 
> >   2. Creating an extent in the same transaction that the owner subvolume
> >      is deleted: the qgroup may already be gone by the time the squota
> >      delta is recorded, leaving behind an EXTENT_OWNER_REF that points
> >      at a qgroup that never accumulated a usage delta.  Manually
> >      re-creating that qgroup and then freeing the extent would underflow
> >      it.
> > 
> >   3. Destroying a live subvolume's qgroup while delayed refs for newly
> >      allocated tree blocks have not yet flushed: rfer/excl read as 0,
> >      so the destroy looked safe, but the alloc delta was silently lost.
> > 
> >   4. Destroying the qgroup of a live subvolume whose data predates
> >      'btrfs quota enable --simple': pre-existing extents are not
> >      accounted (generation < qgroup_enable_gen), so rfer/excl stay 0
> >      permanently and a usage-only check happily destroys a qgroup
> >      belonging to a still-mounted, still-writeable subvolume.
> > 
> > Add four cases covering these scenarios.  On a fixed kernel all four
> > 'qgroup destroy' (and the re-create in case 2) operations are refused
> > because the subvol check rejects the request; on an unfixed kernel
> > they would succeed and leave the filesystem with broken accounting or
> > trigger a transaction abort.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  tests/btrfs/348     | 136 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/348.out |  10 ++++
> >  2 files changed, 146 insertions(+)
> >  create mode 100755 tests/btrfs/348
> >  create mode 100644 tests/btrfs/348.out
> > 
> > diff --git a/tests/btrfs/348 b/tests/btrfs/348
> > new file mode 100755
> > index 00000000..ab816301
> > --- /dev/null
> > +++ b/tests/btrfs/348
> > @@ -0,0 +1,136 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Meta Platforms, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 348
> > +#
> > +# Test various race conditions between qgroup deletion and squota writes
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto qgroup subvol clone
> > +
> > +# Import common functions.
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_scratch_enable_simple_quota
> > +
> > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > +	"btrfs: check for subvolume before deleting squota qgroup"
> > +_fixed_by_kernel_commit 0c309d66dacd \
> > +	"btrfs: forbid creating subvol qgroups"
> > +
> > +subv1=$SCRATCH_MNT/subv1
> > +subv2=$SCRATCH_MNT/subv2
> > +
> > +prepare()
> > +{
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount
> > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> > +	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
> > +	$BTRFS_UTIL_PROG subvolume create $subv2 >> $seqres.full
> > +	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
> > +	_cp_reflink $subv1/f $subv2/f
> > +}
> > +
> > +# An extent can long outlive its owner. Test this by deleting the owning
> > +# subvolume, committing the transaction, then deleting the reflinked copy.
> > +free_from_deleted_owner()
> > +{
> > +	echo "free from deleted owner"
> > +	prepare
> > +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> > +
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
> > +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +	rm $subv2/f
> > +	_scratch_unmount
> > +}
> > +
> > +# A race where we delete the owner in the same transaction as writing the
> > +# extent leads to incrementing the squota usage of the missing qgroup.
> > +# This leaves behind an owner ref with an owner id that cannot exist, so
> > +# freeing the extent now frees from that qgroup, but there has never
> > +# been a corresponding usage to free.
> > +add_to_deleted_owner()
> > +{
> > +	echo "add to deleted owner"
> > +	prepare
> > +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> > +
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
> > +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +	$BTRFS_UTIL_PROG qgroup create 0/$subvid1 $SCRATCH_MNT >> $seqres.full
> > +	rm $subv2/f
> > +	_scratch_unmount
> > +}
> > +
> > +# Create a subvol, destroy its qgroup before delayed refs update rfer/excl.
> > +# On an unfixed kernel the qgroup destroy succeeds (rfer == 0), silently
> > +# losing the alloc delta. On a fixed kernel the destroy is refused because
> > +# the ROOT_ITEM still exists.
> > +same_txn_destroy_race()
> > +{
> > +	echo "same txn destroy race"
> > +	prepare
> > +
> > +	# Commit so the next subvol create starts a fresh transaction.
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +
> > +	# New subvol -- tree block alloc delayed ref is pending, rfer/excl=0.
> > +	local subv3=$SCRATCH_MNT/subv3
> > +	$BTRFS_UTIL_PROG subvolume create $subv3 >> $seqres.full
> > +	local subvid3=$(_btrfs_get_subvolid $SCRATCH_MNT subv3)
> > +
> > +	# rfer/excl still 0 (delayed refs not flushed). Destroy should fail
> > +	# because the ROOT_ITEM exists.
> > +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid3 $SCRATCH_MNT 2>&1
> > +
> > +	_scratch_unmount
> > +}
> > +
> > +# Enable squotas on a filesystem that already has a subvolume with data.
> > +# Pre-existing extents have generation < qgroup_enable_gen, so the qgroup's
> > +# rfer/excl stay 0 permanently. On an unfixed kernel can_delete_squota_qgroup
> > +# only checks rfer/excl, so the qgroup can be destroyed for a live subvol.
> > +# On a fixed kernel, the subvol check prevents deletion.
> > +pre_existing_data_destroy()
> > +{
> > +	echo "pre-existing data destroy"
> > +	_scratch_mkfs >> $seqres.full
> > +	_scratch_mount
> > +
> > +	# Create subvol and write data BEFORE enabling squotas.
> > +	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
> > +	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
> > +	sync
> > +
> > +	# Enable squotas. Pre-existing data is not accounted (gen < enable_gen).
> > +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
> > +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +
> > +	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> > +
> > +	# Destroy the qgroup. rfer/excl = 0 because data predates squotas.
> > +	# Should fail because the ROOT_ITEM still exists.
> > +	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT 2>&1
> > +
> > +	_scratch_unmount
> > +}
> > +
> > +free_from_deleted_owner
> > +add_to_deleted_owner
> > +same_txn_destroy_race
> > +pre_existing_data_destroy
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
> > new file mode 100644
> > index 00000000..0a1cf11f
> > --- /dev/null
> > +++ b/tests/btrfs/348.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 348
> > +free from deleted owner
> > +ERROR: unable to destroy quota group: Device or resource busy
> > +add to deleted owner
> > +ERROR: unable to destroy quota group: Device or resource busy
> > +ERROR: unable to create quota group: Invalid argument
> > +same txn destroy race
> > +ERROR: unable to destroy quota group: Device or resource busy
> > +pre-existing data destroy
> > +ERROR: unable to destroy quota group: Device or resource busy
> 
