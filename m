Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7EF43CEFF;
	Tue, 16 Jun 2026 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611108; cv=none; b=EwOgwnQpuElmuDr3EI+cWYxw9Z6+UbFMhvCEXnCRIL0ozr0Ljprdpjv6iusCzJGDU1BUdqOafNeufESCaNcEdLLKLdNmkqIZJ/RLU12BHknbDbclwh5+i47UTbmN4KQf34R1Otktmp1tZ6rQveKB8rXYWz+f4vKGvv8i4sOyW+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611108; c=relaxed/simple;
	bh=oTt2G+Dq6LG/18ZNY7JNTgN7ba+ih+G7Wo3XBrm7Mj4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=snrgXZ1xa9wpQ1dxAsMqAFhSkVH2rgY5piVxYH88BjD5HYqllZAYkG2QGyzFXCD0vfZS7at2fi3mf3u1RGeJ1Fhxv+84MgmMHGax3Ce0YldJNBDbVpMARVxWU0NjKhL5YYxYCcTapBAjAY/s7GU0jiReW1pwf7m1HnlCdiAOH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTQGhQiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTQGhQiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A008F1F000E9;
	Tue, 16 Jun 2026 11:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781611106;
	bh=qn+0lJ8xSrv0zWZQhO6DbpTlRseU8O1J57f7CpXQwUM=;
	h=From:Subject:Date:To:Cc;
	b=bTQGhQiPMtn02D8rRoobxm8ZgzpJQMy7wIROhH/V46okkLNQj6vgWsOGg6Brri/R0
	 CgJBUFaRe9LMWqiuBq0i8DAVEwkG/6cxQ5VoQo/kQISeWvfO4oQ3Sgb24Ld6mYnquu
	 AwIO+VDUWvSwjEHYj7gegUtaviU1vRShnQOI4Sej2ULsTjTExd1TTWkx0dNYk1pFUu
	 J9o53T3FFU1V9Ov+1Ilxg7IqcgLm3qlaenFb9JZknuZZmJV25OLaF0SpD9DxGjvj4O
	 1lbiiiC0JquqsSaoFo+mh7pqTOV1csz1cU+ToVFkcQexVcYUOSceM9rwKTzlN9ht9e
	 U9uGRfuhTNzUw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/5] block,btrfs: fix frozen-superblock strand on device
 add/remove/replace
Date: Tue, 16 Jun 2026 13:58:13 +0200
Message-Id: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFY6MWoC/42OXQ6CMBCEr2L6bElpsKhP3sMQUmCQ+lPILqBIu
 LtUL+DjNzv5dmbBIAcWx80sCKNj1/oV9HYjysb6C6SrVhZaaaNMvJPPlm6Shw4kawLeyCv4KR8
 67gn2IZPD3sIkqYmtEqulI9Tu9f1wzn7MQ3FF2QdtaBSWIQuyvmxCNNYchSicGsd9S9N33RgHx
 f9DxlgqaU2Z6mKfKKTV6QbyuEctXUS2LMsHzN32GvwAAAA=
X-Change-ID: 20260615-work-super-freeze_deny_upstream-498ae64761a0
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4514; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oTt2G+Dq6LG/18ZNY7JNTgN7ba+ih+G7Wo3XBrm7Mj4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZWsWHJ8bcXfEj1OBSH89WsQ+Hqny/Hr6U3fUvp2HmV
 7NX2j++d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkRQ7D/wj/mawZjtO3Hk9n
 d/K9zFngeddwz8xUF7bg2dVzDcQCXzH8L5F6V756RUuF6YEWzfDEtRfrDjKGHSp5zj7PbOXKmKz
 LrAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

This is another series of fixes that fell out of the device to
superblock hashtable work. These are all pre-existing bugs.

A block-device freeze that races a btrfs device membership change can leave
the whole filesystem stuck frozen, recoverable only with a manual FITHAW.

btrfs holds each of its devices open with the superblock as the block-device
holder.  bdev_freeze() - issued by "dmsetup suspend" or an LVM snapshot -
resolves that holder to freeze the filesystem, and bdev_thaw() ("dmsetup
resume") resolves it again to thaw.  If a freeze lands while btrfs is adding,
removing or replacing a device, it rides in on the device's holder link and
freezes the filesystem; the membership change then drops that link, so the
matching thaw can no longer find the superblock.  The filesystem stays frozen
with no way back short of FITHAW.

To reproduce on the remove path: build a two-device btrfs with one member
behind a dm-linear target, write enough data that removing that member
relocates for a few seconds, start "btrfs device remove" on it, and
"dmsetup suspend" the dm device while the removal is underway.  The suspend's
freeze blocks on the remove ioctl's write access and rides in as the ioctl
drops it; the removal then clears the device's holder link, so the matching
"dmsetup resume" can no longer reach the superblock.  On an unpatched kernel
the filesystem is left frozen and the next write hangs in D state until a
manual FITHAW (fsfreeze -u).

The fix lets a filesystem forbid freezing a device for the duration of a
membership change, modelled on deny_write_access()/allow_write_access().
bd_fsfreeze_count becomes signed: > 0 counts active freezes, < 0 counts deny
holders, and the two are mutually exclusive.  bdev_deny_freeze() reserves the
device (bdev_freeze() then returns -EBUSY) and bdev_allow_freeze() releases
it; both are a single lockless atomic, so a filesystem can deny under
s_umount without inverting against bdev_freeze()'s bd_fsfreeze_mutex.  btrfs
denies the device across each add, remove and replace, so a racing freeze is
refused instead of riding in, while a normal freeze of a settled member
still works.

To re-allow freezing safely on release, bdev_yield_claim() is split out of
bdev_fput(): the caller yields the holder while the device file is still
open, re-allows freezing on the now-holderless device, and only then closes
it. Re-allowing after the holder is gone avoids re-stranding on a racing
freeze; doing it while the file is still open keeps the block device alive
without referencing it after the final fput.

With the fix the racing suspend is refused with -EBUSY mid-removal and the
filesystem stays writable.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- block: bdev_thaw() now keeps bd_fsfreeze_count positive across the thaw
  and only drops it to 0 on success, so a bdev_deny_freeze() racing the thaw
  is refused instead of slipping in on a transient 0 and corrupting the
  sign-encoded counter.
- block: bdev_allow_freeze() WARN_ON_ONCE()s an unbalanced call (Jan Kara).
- block: bdev_yield_claim() early-returns instead of wrapping its body in an
  if (Johannes Thumshirn).
- btrfs: btrfs_open_device_deny_freeze() opens the probe BLK_OPEN_WRITE so a
  read-only device is rejected at "device add"; the by-dev open of the
  holder skipped the read-only check the previous by-path open enforced.
- Reword the cover: FIFREEZE freezes the superblock, not the bare device.
- Link to v1: https://patch.msgid.link/20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org

---
Christian Brauner (5):
      block: allow making a block device unfreezable
      block: split bdev_yield_claim() out of bdev_fput()
      btrfs: deny freezing a device while it is being removed
      btrfs: deny freezing a device while it is being added
      btrfs: deny freezing devices undergoing a replace

 block/bdev.c              | 113 +++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/dev-replace.c    |  65 +++++++++++++++++++++++---
 fs/btrfs/ioctl.c          |   4 +-
 fs/btrfs/volumes.c        |  84 +++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h        |   6 ++-
 include/linux/blk_types.h |   2 +-
 include/linux/blkdev.h    |   3 ++
 7 files changed, 229 insertions(+), 48 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260615-work-super-freeze_deny_upstream-498ae64761a0

