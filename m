Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70993E5EF1;
	Mon, 15 Jun 2026 13:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529499; cv=none; b=Czs/2fpMqici/Rq2AFgFbIsEl63clX9aSkrgl2cRxGKl99iiv7t5MLUg1Yjk0ni89h4kUh9O+WWvXEXIcQl/yzqcCM8TLMpvi8xuJiNEvjnYQ1amLGfXV7qXrffKND67OCkUGSnKKgrj9e21tnCl20+uXaYP0fNqrngx23QrdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529499; c=relaxed/simple;
	bh=7IviJDmECLct1mfX+ucUEKM7lpwiYuU/Cv+mO4JFoXk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Qj4JgB0ssyTgSGkouDDAjBP3wVq+Wca+GDDbaefTq8MtZn9LyVXGgEZLVRzSWrawEexgyRZvc7d/i1q7FL6nJMKmXlsvbAJdMKle0ATfVoHrJmpNtrdYdChU1EYL0pCWfXi6NxbdpFksIjccrOad0KQ35NsbUaMM8oSPstcGGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nfb/Xlnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nfb/Xlnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AC01F000E9;
	Mon, 15 Jun 2026 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529498;
	bh=8X0V3Tc4hL+9KAbpOBY/kFW6p/k2S39HHy+Iy9zaNRI=;
	h=From:Subject:Date:To:Cc;
	b=Nfb/XlnpXNQYZrUOXcgxFHJRVfNuXIuhTHuztah3LprXzljOXFHelkfY8NaYJHyZJ
	 /npvHLw2Bhjj+pKCzXwCd6VDtY62dUtC6lk02T+m4AAWeAuoYTVD2kXYlKtmtPF9JH
	 31Fr9s/PlhP+2uHdk0xyOputTHeiTH+w9KSiz5iWSRKVq7aBsgfM95pDDN0QZ49S2x
	 WBqYiGTO5yUMYxGQHDAbr+WwXszANiowU1xEYMBWSriqWpsnDguHzTaJkyWK5WuGwB
	 b3szPPlZIgLrs+fq0NsE+4KIOSSi8BugxQVugFHOzS3APbIZLWq+yMhR71P4mgi0Qs
	 ci5Lyr2vBzSdg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 0/6] block,btrfs: fix frozen-superblock strand on
 device add/remove/replace
Date: Mon, 15 Jun 2026 15:18:03 +0200
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIv7L2oC/yWNyw6CMBBFf4XM2hogWB9bEz/ArTGkwEUqsTQzg
 A/Cv0t1eU5uzp1IwBZCh2gixmjFdm6BZBVR2Rh3g7LVwpTGqY51slHPjlslgwermoEP8grunQ9
 eeoZ5qGy/M9DZVicmpqXiGbV9/R4udD4d6fqXMhR3lH1oh1lhBKpg48omqLGWdVA0z19j6V4Bo
 wAAAA==
X-Change-ID: 20260615-work-super-freeze_deny_upstream-498ae64761a0
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3862; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7IviJDmECLct1mfX+ucUEKM7lpwiYuU/Cv+mO4JFoXk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/56ueNXjMJO+inJ5zqSWxY87vmYoTZ0dt1Uza8aL4
 Kd5CyoedpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkWQfDP0N2kxvaeQ/3+/9M
 uZZSbnb105OKd/IMM+LPlwnpn9+e84KR4ZjOfrkLOyT65gbJ2if4zorevvlkVuadtt0Hkv5eZHU
 25AEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A block-device freeze that races a btrfs device membership change can leave
the whole filesystem stuck frozen, recoverable only with a manual FITHAW.

btrfs holds each of its devices open with the superblock as the block-device
holder.  bdev_freeze() - issued by "dmsetup suspend", an LVM snapshot, or
FIFREEZE on the bare device - resolves that holder to freeze the filesystem,
and bdev_thaw() ("dmsetup resume") resolves it again to thaw.  If a freeze
lands while btrfs is adding, removing or replacing a device, it rides in on
the device's holder link and freezes the filesystem; the membership change
then drops that link, so the matching thaw can no longer find the
superblock.  The filesystem stays frozen with no way back short of FITHAW.

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
it.  Re-allowing after the holder is gone avoids re-stranding on a racing
freeze; doing it while the file is still open keeps the block device alive
without referencing it after the final fput.

Patch 1 is independent: it fixes a pre-existing target-device leak on the
mark_block_group_to_copy() failure path in btrfs_dev_replace_start().  The
replace bracket reuses that 'leave' unwind, so it comes first.

With the fix the racing suspend is refused with -EBUSY mid-removal and the
filesystem stays writable.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (6):
      btrfs: destroy the target device when mark_block_group_to_copy() fails
      block: allow making a block device unfreezable
      block: split bdev_yield_claim() out of bdev_fput()
      btrfs: deny freezing a device while it is being removed
      btrfs: deny freezing a device while it is being added
      btrfs: deny freezing devices undergoing a replace

 block/bdev.c              | 73 ++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/dev-replace.c    | 67 +++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c          |  4 +--
 fs/btrfs/volumes.c        | 83 ++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/volumes.h        |  6 +++-
 include/linux/blk_types.h |  2 +-
 include/linux/blkdev.h    |  3 ++
 7 files changed, 206 insertions(+), 32 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260615-work-super-freeze_deny_upstream-498ae64761a0

