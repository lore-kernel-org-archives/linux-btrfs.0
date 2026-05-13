Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3758925B092;
	Wed, 13 May 2026 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633029; cv=none; b=H+3y7llLWZbDMv3X1vCK9Gh072FVRu/4syxOiCNO3HI5C9VEMTysAzZzOpc65tBSkeIcO+WMeXRQAE4jvUZIjj//LZT8QJWBoAdVZtTIkzrxgrDDteBEeUqCx+z8E7uX8EckDexngo/lkzx44H7nGL10dmvuRCRGVBbbTjqVMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633029; c=relaxed/simple;
	bh=FNkKaWomWo5dMY3oipdiNoSLKa1PeI2qatnnjSChxGk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abgeqzauq49PAQTHmbUwT4ZBWUvkae5sgO+bcv92GVVZwwrV2QLeEPtxRnmMyNZ4rgS5v0qXxEOHyRELcZouD2/rL7oF1wArSIIoSwiePAGI71FGa+NVskmQnNUjGR5rlQLl76Aol/Vxwou8JU9mucnxETIRbnbnmIHgeCSCWQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=a4okj2Ab; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DFZ6463X; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="a4okj2Ab";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DFZ6463X"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 75558140006E;
	Tue, 12 May 2026 20:43:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 12 May 2026 20:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778633027; x=
	1778719427; bh=xGXgYy0NF7jTwIkyyPrVyPfIrwleX/Hx8x47eyO73KQ=; b=a
	4okj2AbpQCXcY0E1ttnlqTvSALlI//fOB8vlTHNU0jSNjrjxUXV8qJp05T59bvjW
	wBPViLeh66Ilx2aMobphaqAuZXJ+aBuNxQcJP4NQR7lGisOZSXvGu5POl4QhmxEF
	dWtNwldrvRfPeSwA2WRaRUHINQbkVqfxUKkHrhHEoYvTmIfZ0jIPU6FTIGsW9scM
	TwXBS0kdmXVq6IVCn6DVB+VJRS2WiZDyT/4VUoOGyuh57nTa2NmWwYo0dihYuGHw
	qOxPwLoYRuJK5EIBySgfuB13KgIp3qUB3JFqcghjFZGbKTTdjh3enfD1cYbmhKOZ
	m+kd7Z972gFMoGjYTlGIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1778633027; x=1778719427; bh=xGXgYy0NF7jTwIkyyPrVyPfIrwle
	X/Hx8x47eyO73KQ=; b=DFZ6463XhgB+hX0U87vv3ZW8HPB5vKpXoaRo3rm44SFu
	UmeXAPKmHrbwq44rXm9SZPFlaG3tZBL6+cuf7vSR6XdbRpxFdNk+h/VzaEzOWQ++
	3Dd5VgsNBBg9zaaDn5W2/M8uOU2ctWpXFyIDdxztE35R9GbD8RWF9xyH4CAMuk0Y
	GV3bcg3/WptdxKHFfwSv80iD+oD39DXBy/blU0QMuoDi92+N6x4i5/pzqpfpGW43
	pOKAgXCsk16RRS5/GLTl1hiwujCpaMbFgFlYbSFQMOXxUxs8az7mTAVjNNeIWdCx
	8jUMbr/BZ/CDn5plI42kGwPvwmtPw71sA2BJZF+wog==
X-ME-Sender: <xms:Q8kDau_PreOk3KArNkBxspK7UuO8bk_Sql-ZxGbltbJq_XK2zZwDbA>
    <xme:Q8kDamfG8PRYDUps-LyiSHCkP5E7DOL3aJkevYnqqWC0lUEWOAqLqBPCunL23SPFJ
    H_Py4yskk2jpir0LimrNUy-4RbPsQ7OBbiAgSkdRBxx5unyWIfrvtp0>
X-ME-Received: <xmr:Q8kDanF_GkCzuzahTK0z2MNq4tYpgUlKw61motKLwPegBwQStVXxjRorF_yAwnq__JNGyRHoKD8KXMtu46_gYVYdtS8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdefvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepfedpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
    dprhgtphhtthhopehfshhtvghsthhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Q8kDakdKhZ4eegb1JXn_7B6OSRbe-qQgL8EnGpL-q3_YJFp17YGVmg>
    <xmx:Q8kDahF0w7hi8FIC3aDMhf1mrgE1_gJBu7eeLI3fyZ8IA-3xkO1kqA>
    <xmx:Q8kDatVxWmaO0eMuSw72IXiRXS7KWE6L-HL7KrtvRF5AkBKDUKxfkQ>
    <xmx:Q8kDaoLjDesjXeABrnaG7p7W4p80gocugbTTTkmQRd6UMh52vh-0jA>
    <xmx:Q8kDakKtOhqOL6pxdCUvhNmGWmvlmuaLSWrlbypwiBW3hg9nIXYFt7Jm>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 20:43:46 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: [PATCH 2/2] btrfs: test qgroup deletion races with squota writes
Date: Tue, 12 May 2026 17:43:34 -0700
Message-ID: <2c8668284ded13c7cc63ece213d9e1edc3e6ea85.1778632843.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778632843.git.boris@bur.io>
References: <cover.1778632843.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using simple quotas, an extent's EXTENT_OWNER_REF can long outlive
the subvolume that created it, since the extent can pick up additional
references that keep it alive after the owning subvolume is deleted.

Several lifecycle bugs around the owning qgroup arise from this:

  1. Freeing an extent whose owner qgroup is gone: must not cause an
     underflow nor a transaction abort.

  2. Creating an extent in the same transaction that the owner subvolume
     is deleted: the qgroup may already be gone by the time the squota
     delta is recorded, leaving behind an EXTENT_OWNER_REF that points
     at a qgroup that never accumulated a usage delta.  Manually
     re-creating that qgroup and then freeing the extent would underflow
     it.

  3. Destroying a live subvolume's qgroup while delayed refs for newly
     allocated tree blocks have not yet flushed: rfer/excl read as 0,
     so the destroy looked safe, but the alloc delta was silently lost.

  4. Destroying the qgroup of a live subvolume whose data predates
     'btrfs quota enable --simple': pre-existing extents are not
     accounted (generation < qgroup_enable_gen), so rfer/excl stay 0
     permanently and a usage-only check happily destroys a qgroup
     belonging to a still-mounted, still-writeable subvolume.

Add four cases covering these scenarios.  On a fixed kernel all four
'qgroup destroy' (and the re-create in case 2) operations are refused
because the subvol check rejects the request; on an unfixed kernel
they would succeed and leave the filesystem with broken accounting or
trigger a transaction abort.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/btrfs/348     | 136 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out |  10 ++++
 2 files changed, 146 insertions(+)
 create mode 100755 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out

diff --git a/tests/btrfs/348 b/tests/btrfs/348
new file mode 100755
index 00000000..ab816301
--- /dev/null
+++ b/tests/btrfs/348
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Meta Platforms, Inc.  All Rights Reserved.
+#
+# FS QA Test 348
+#
+# Test various race conditions between qgroup deletion and squota writes
+#
+. ./common/preamble
+_begin_fstest auto qgroup subvol clone
+
+# Import common functions.
+. ./common/reflink
+
+# real QA test starts here
+
+_require_scratch_reflink
+_require_cp_reflink
+_require_scratch_enable_simple_quota
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: check for subvolume before deleting squota qgroup"
+_fixed_by_kernel_commit 0c309d66dacd \
+	"btrfs: forbid creating subvol qgroups"
+
+subv1=$SCRATCH_MNT/subv1
+subv2=$SCRATCH_MNT/subv2
+
+prepare()
+{
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
+	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
+	$BTRFS_UTIL_PROG subvolume create $subv2 >> $seqres.full
+	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
+	_cp_reflink $subv1/f $subv2/f
+}
+
+# An extent can long outlive its owner. Test this by deleting the owning
+# subvolume, committing the transaction, then deleting the reflinked copy.
+free_from_deleted_owner()
+{
+	echo "free from deleted owner"
+	prepare
+	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
+
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
+	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+	rm $subv2/f
+	_scratch_unmount
+}
+
+# A race where we delete the owner in the same transaction as writing the
+# extent leads to incrementing the squota usage of the missing qgroup.
+# This leaves behind an owner ref with an owner id that cannot exist, so
+# freeing the extent now frees from that qgroup, but there has never
+# been a corresponding usage to free.
+add_to_deleted_owner()
+{
+	echo "add to deleted owner"
+	prepare
+	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
+
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+	$BTRFS_UTIL_PROG subvolume delete $subv1 >> $seqres.full
+	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT >> $seqres.full
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+	$BTRFS_UTIL_PROG qgroup create 0/$subvid1 $SCRATCH_MNT >> $seqres.full
+	rm $subv2/f
+	_scratch_unmount
+}
+
+# Create a subvol, destroy its qgroup before delayed refs update rfer/excl.
+# On an unfixed kernel the qgroup destroy succeeds (rfer == 0), silently
+# losing the alloc delta. On a fixed kernel the destroy is refused because
+# the ROOT_ITEM still exists.
+same_txn_destroy_race()
+{
+	echo "same txn destroy race"
+	prepare
+
+	# Commit so the next subvol create starts a fresh transaction.
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+
+	# New subvol -- tree block alloc delayed ref is pending, rfer/excl=0.
+	local subv3=$SCRATCH_MNT/subv3
+	$BTRFS_UTIL_PROG subvolume create $subv3 >> $seqres.full
+	local subvid3=$(_btrfs_get_subvolid $SCRATCH_MNT subv3)
+
+	# rfer/excl still 0 (delayed refs not flushed). Destroy should fail
+	# because the ROOT_ITEM exists.
+	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid3 $SCRATCH_MNT 2>&1
+
+	_scratch_unmount
+}
+
+# Enable squotas on a filesystem that already has a subvolume with data.
+# Pre-existing extents have generation < qgroup_enable_gen, so the qgroup's
+# rfer/excl stay 0 permanently. On an unfixed kernel can_delete_squota_qgroup
+# only checks rfer/excl, so the qgroup can be destroyed for a live subvol.
+# On a fixed kernel, the subvol check prevents deletion.
+pre_existing_data_destroy()
+{
+	echo "pre-existing data destroy"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+
+	# Create subvol and write data BEFORE enabling squotas.
+	$BTRFS_UTIL_PROG subvolume create $subv1 >> $seqres.full
+	$XFS_IO_PROG -fc "pwrite -q 0 128K" $subv1/f
+	sync
+
+	# Enable squotas. Pre-existing data is not accounted (gen < enable_gen).
+	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+
+	local subvid1=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
+
+	# Destroy the qgroup. rfer/excl = 0 because data predates squotas.
+	# Should fail because the ROOT_ITEM still exists.
+	$BTRFS_UTIL_PROG qgroup destroy 0/$subvid1 $SCRATCH_MNT 2>&1
+
+	_scratch_unmount
+}
+
+free_from_deleted_owner
+add_to_deleted_owner
+same_txn_destroy_race
+pre_existing_data_destroy
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
new file mode 100644
index 00000000..0a1cf11f
--- /dev/null
+++ b/tests/btrfs/348.out
@@ -0,0 +1,10 @@
+QA output created by 348
+free from deleted owner
+ERROR: unable to destroy quota group: Device or resource busy
+add to deleted owner
+ERROR: unable to destroy quota group: Device or resource busy
+ERROR: unable to create quota group: Invalid argument
+same txn destroy race
+ERROR: unable to destroy quota group: Device or resource busy
+pre-existing data destroy
+ERROR: unable to destroy quota group: Device or resource busy
-- 
2.54.0

