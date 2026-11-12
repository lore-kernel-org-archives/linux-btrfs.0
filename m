Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.154.239.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491237;
	b=aVuSrS3d3T4lo3OODjPSzl0G5h4izFA0mINzjVm0AVKVABOb0Mvj8Zzw8KgTvoTV/cBs
	 2zvgXqBre8OfXaM2V4JkDDsLabx1gdjiaxubk23wEOKwNB7IJRYASAWSmwDj7+jD1ytpl
	 qt6zSFV8xM5EeY1WSayfPeKMs5VpTVx+nc4T1Rr0rDzA2XxClqIJk3y0C00WZ9MkczVQs
	 5SpnDjc9gn+ux8fUR8rpExULhHAvryS0RELhs517MAmKjdMjbPrZENXtbgeL1US2qD5Kg
	 L/Sg0xPISp93ohurNQmLP9RFEEm9ZQVC5R7ID7+Wv1zXyhKC4IWZMFUf6Og3QayBDkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491237;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Reply-To:
	 Content-Transfer-Encoding;
	bh=Rrp1X1YWSNAMJWln65D+arV/W5RD4l1c8EBUA/LakV8=;
	b=ud/pbLU1BsIdUK8qfy2Ei1h8eZpWNcZCqSvF7EQf60+D8OAV23C90A+VFhbXUlezu1Ux
	 gFTrVPgnT7IbaDFjyicGDkCzMscqQATjAL2PiHx6MNMxlz2sYcbDd6nHPAWCn/ybDYuFu
	 n3rnXm3OsOqGxQuXEeJnQuUG5UEZtXllkCd/3sZMtU6k6DiI2KY0UP/8vUD0zikAlCY4T
	 RG66kkv7llYYTn2Mu4XK7whKxBsKCuO/C8ugJMuSwfHXQCP71I72eCbRO3WtbkIL3Z2kk
	 nlHvdPlSy+ADt0n6K2uvfKpr87vLCfmbxOtL0QkAigLkuhO5z/qkpSWPvuErPFEFggw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=mIvxLHIf;
	arc=none smtp.remote-ip=178.154.239.223
Received: from forward400d.mail.yandex.net (forward400d.mail.yandex.net [178.154.239.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED13606A32D;
	Thu, 12 Nov 2026 13:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ED13606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=mIvxLHIf
Received: from mail-nwsmtp-smtp-production-canary-28 (mail-nwsmtp-smtp-production-canary-28.yp-c.yandex.net)
	by forward400d.mail.yandex.net (postfix) with ESMTPS id B5287815E4;
	Thu, 12 Nov 2026 16:47:06 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-28 with ESMTPSA id 3lUfioFgImI0-IKTDfIHj;
	Thu, 12 Nov 2026 16:47:06 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1794491226; bh=Rrp1X1YWSNAMJWln65D+arV/W5RD4l1c8EBUA/LakV8=;
	h=Reply-To:Message-ID:Date:Cc:Subject:To:From;
	b=mIvxLHIfbDhcpa8dUYw6GMzmW0xnPjrJCnYqM0/05cLkWZPkdS5eaf4osOn3D6iad
	 faUkGwS+7+eaA8R8awD3+CORNDSv4F389dk6dpleoeVDUjcPkL6EHDFlHuShzbjmQ0
	 UpclMu36cXSC7rtuGTwAxU7BQxZAnEIVG7F1/IEk=
Authentication-Results: mail-nwsmtp-smtp-production-canary-28; dkim=pass header.i=@yandex.ru
From: Alexey Kuznetsov <nondet@yandex.ru>
To: linux-btrfs@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Alexey Kuznetsov <axet@me.com>
Subject: [RFC PATCH 0/1] btrfs: hybrid physical bad-block handling
Date: Thu, 12 Nov 2026 08:47:02 -0500
Message-ID: <20261112134703.38510-1-nondet@yandex.ru>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Reply-To: Alexey Kuznetsov <axet@me.com>
Content-Transfer-Encoding: 8bit

From: Alexey Kuznetsov <axet@me.com>

This is an RFC for physical bad-block handling in btrfs: a design
proposal plus a loop-device prototype.  It is not a submission candidate.

Why the existing layers are not enough
--------------------------------------
Bad-block handling today lives either below the filesystem (dm-linear,
dm-quarantine, md, drive firmware) or in a logical structure such as
ext4's bad-block inode.  Neither knows which physical copy of a mirrored
logical extent failed.  As a result:

  - a filesystem cannot use its own redundancy to distinguish "this copy
    is bad" from "this logical extent is lost";
  - it cannot relocate only the data that lives in the bad physical
    range;
  - it cannot stop the allocator from reusing that range, and
  - it cannot report which files are affected instead of only which LBA
    failed.

The prototype keeps the layer split:

  block layer   physical remap/quarantine, no filesystem knowledge
  btrfs         detection, mirror salvage, relocation, reporting
  userspace     scanning, persistence, policy, initramfs

Bad extents are tracked per device as physical byte ranges, not as a
filesystem-wide logical list and not as an ext4-style inode.

What the prototype does
-----------------------
The series is against 6.12.  It adds fs/btrfs/bad-extents.c and hooks
scrub, the read path, the write path, the allocator, the device tree, and
the ioctl surface:

  - scrub records the physical range of every initially failed sector.
    An I/O error becomes "confirmed"; a checksum, header, or generation
    failure becomes "suspect".  Adjacent ranges coalesce and a second
    observation upgrades suspect to confirmed.

  - A read that overlaps a confirmed range fails before device I/O.  The
    failure goes through the normal read completion path, so btrfs retries
    another mirror and returns -EIO only when no copy is left.  Suspect
    ranges are read normally so they can still be verified and repaired.

  - Repair writes into a confirmed range are dropped, so repair cannot
    recreate a copy in known-bad media.

  - find_free_dev_extent() trims confirmed ranges out of candidate holes.
    New chunks never land there.  Suspect ranges remain allocatable.
    Zoned devices are intentionally untouched.

  - Ranges persist in the device tree as
    (devid, BTRFS_DEV_BAD_EXTENT_KEY, physical_start) items holding
    length, last logical offset, generation, state, and observation
    count, under a new incompat bit.  Mount loads them after device
    stats; add/remove/clear write through; SYNC commits a scrub report.
    Removing the last range clears the bit in the same transaction.

  - On RAID1/RAID1C3/RAID1C4/DUP/RAID10, an ordinary write whose stripe
    falls in a confirmed range is aliased to a healthy mirror of the same
    logical range inside btrfs_map_block().  All copies are still
    submitted, so the healthy copy is updated and the bad sector is never
    written.  If every copy is confirmed bad the write fails with -EIO.
    Device replace is excluded because it manages its own stripe
    duplication.  With the experimental raid-stripe-tree feature, the
    existing ordered-extent completion path records the aliased stripe;
    without RST the alias is per-write and reads rely on the existing
    mirror retry.

  - Data-relocation reads are exempt from fast-fail, because relocation
    is exactly the operation that has to read the old copy before moving
    it.

  - A userspace command, dmq btrfs-relocate, coalesces the reported
    ranges and drives BTRFS_IOC_BALANCE_V2 with
    BTRFS_BALANCE_ARGS_DEVID | BTRFS_BALANCE_ARGS_DRANGE.  That selects
    only chunks with a stripe on the affected device inside the bad
    physical range.  It works without btrfs-progs knowing the new
    incompat bit.  A companion userspace package also scans and persists
    a sector map and feeds dm-linear/dm-quarantine for the non-btrfs and
    boot paths.

Test results
------------
On 6.12.116 with loop devices, the prototype passes:

  - ioctl add/coalesce/upgrade/split/remove/clear;
  - persistence across unmount/remount and the incompat bit lifecycle;
  - scrub detection of a deliberately corrupted data sector, exact
    physical offset, SYNC, remount;
  - dmq import into a checksummed map and mount through dm-linear with
    EIO for the bad range;
  - fast-fail on a confirmed range, normal reads for a suspect range;
  - RAID1 fallback, skipped repair write, and EIO when both copies are
    confirmed;
  - allocator exclusion of a 176 MiB confirmed range (ENOSPC for a
    100 MiB write) with a suspect-range control;
  - a RAID1 in-place NODATACOW rewrite against a dm-quarantine poison
    range: the target's write counter stays at zero, the healthy mirror
    holds the new data, and a control write after clearing the extent
    does reach the poisoned range;
  - targeted relocation: BTRFS_IOC_BALANCE_V2 completes, the payload is
    unchanged, and a new copy appears outside the confirmed range.

The userspace test suite (62 tests) covers the ioctl ABI, balance ABI
packing, map import, and CLI behaviour.

Known limitations / why this is an RFC
--------------------------------------
  - The on-disk format and the ioctl ABI are placeholders.
  - btrfs-progs 6.14 does not know the incompat bit (btrfs check reports
    unsupported features 0x8000) and does not expose raid-stripe-tree
    (mkfs.btrfs -O list-all omits it), so the RST alias path could not be
    exercised on loop devices.
  - Fast-fail is whole-bio/chunk granular; more data than the bad sector
    may be failed and retried on another mirror.
  - Relocation is manual and chunk-granular.  It is not invoked from
    scrub.
  - Persisted items for a removed devid are not cleaned up.  Devids are
    not reused, so they are ignored.
  - Write redirection only covers mirror profiles.  Single-profile data
    and metadata still fail; reallocating a single-profile write through
    RST is a larger project.
  - Boot-chain and LBA-0 handling are discussed in the userspace design,
    not implemented here.

Questions for the list
----------------------
  - Is a per-device physical extent list in the device tree the right
    on-disk representation, or should this extend the raid-stripe tree or
    use a dedicated tree?
  - Should read fast-fail be per-sector instead of per-bio/chunk, and
    should the I/O path record errors automatically or only scrub and
    userspace imports?
  - Is an incompat bit appropriate for a feature that changes read
    semantics, or is a mount option / read-only toggle preferable?
  - How should this interact with device replace and balance?  The
    prototype excludes dev-replace writes and uses balance as the
    relocation engine.
  - What is the right policy for upgrading suspect to confirmed, and how
    should transient errors be excluded?
  - Is RST the right persistence mechanism for the write alias, or should
    there be a separate logical-to-physical indirection?

The userspace prototype and design notes, including the LBA-0 and
bootloader discussion, are at:
  https://gitlab.com/axet/kernel-badblocks

The patch follows.

Alexey Kuznetsov (1):
  btrfs: track physical bad extents, fast-fail, persist, and relocate

 fs/btrfs/Makefile               |   2 +-
 fs/btrfs/accessors.h            |  12 +
 fs/btrfs/bad-extents.c          | 825 ++++++++++++++++++++++++++++++++
 fs/btrfs/bad-extents.h          |  46 ++
 fs/btrfs/bio.c                  |  38 +-
 fs/btrfs/disk-io.c              |   8 +
 fs/btrfs/fs.h                   |   4 +
 fs/btrfs/ioctl.c                |  96 ++++
 fs/btrfs/scrub.c                |  32 ++
 fs/btrfs/sysfs.c                |   2 +
 fs/btrfs/volumes.c              |  29 ++
 fs/btrfs/volumes.h              |   5 +
 include/uapi/linux/btrfs.h      |  40 ++
 include/uapi/linux/btrfs_tree.h |  22 +
 14 files changed, 1159 insertions(+), 2 deletions(-)
 create mode 100644 fs/btrfs/bad-extents.c
 create mode 100644 fs/btrfs/bad-extents.h

-- 
2.47.3

