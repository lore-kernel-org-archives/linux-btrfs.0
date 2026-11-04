Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793815221;
	b=4pLIz3UOn14GVHBHrmLRgB8C4s2GzrEUEC5iwLOpQerYzBRDfdttGx0uMhZFviU49Hfl
	 5AYrdAyzsmWLwC4g1GHH36NCzSNKhuuUvOXvBuqrX4t/hKiP++Ajx5qmrqcGqQFTMUL7W
	 W3PNmCvzPlqE1Y1M+IM4PbK2OnE5Q2pdIjT7YuDs8H+hXOKAdMIt2oKxa1h0Mm/8Udtat
	 kG6UDuhX63ZjXM0MYayjnvzPBzLlO9bp9d4zHnPsOrU9+PMxrrgQMNly8RCzQ1sbXmoP8
	 BhTSEyxsd2q51hMJSwUlpDEPKumxI6+Jsb3TSUUEg+Au7+a39Gne5q4y8L6H1fERlhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815221;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=c02aKpRwVT41c4Cvhuz9Cocr6EuWMjLz4xwoNPqAsQ0=;
	b=3SNQVh1/q/ibQulw/1o2+qc5BpK69NLOyyFhYNyQ93hIr9fuqzxnTnFnMpvkxGImZBA+
	 5Prb2Ul1WnkPMAggGNEE4mLch02g2tY1abNwzcjhBZuW09i7Zuma8ANG9B9IRivO7iZQd
	 0E3B7Tcbsf0rbI2PI/q1m+Y43vlzH1J7cOfSkiT4xV35LMZUbb9QB/8vW6PSGPvQy9Byh
	 bapmWEOnZAvlvGpNmMdYo/xvI27UaWePnCqhFqU+ZntL4mXxUAH+CDXM16DirwiHyyRMc
	 aCoxG099nVrLb7wzQKbw8+7QUljrRzlLX5bxWPbrE4I0KcOiyzsqDFymjPUWuUCGDFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m6l4EM2S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954B4606B20A;
	Wed,  4 Nov 2026 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m6l4EM2S
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793815221;
	b=sRij9/AXkf/o/jywjqui97OGswmvANxX0sPKyDudSxHUKA6JZ5Q/D0+VUCRekYFxKiXh
	 K5IKHWxAN7oQKhwmQZZzlDDfZOU2rvXRw4Su7a02H46B6mHga/YAXrAVxf+gylmltMZhw
	 YXxv5hzN4kpq7/mqvmu5FfylHF9NGr3kPe48Ten0TqeHSFlJY3LXa36MAIVNOP+Qn0oik
	 R0YeUhw1mNRSe3TbTqK+gFfgBAmBjrO/jucehm2/MUZq+n8RssFj/ML/unsAsgQKoj7lg
	 bVlnNnnYNYC6M4Z0HG3y/sMs49PwsXRYQoeeK66Dp9kUv6DjaYR602PbZKUcEh53Tcg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793815221;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=c02aKpRwVT41c4Cvhuz9Cocr6EuWMjLz4xwoNPqAsQ0=;
	b=R7wibfjmtzRQeqlPPWx7o7Qx3O/1AjEZFEFxriLzKE69LQVMvr99gsAOrE7W0Qylt7oo
	 xLQCiW2JpGRS3/V7Oy4tHGwybB8Uflj7syjaUQ7sA7xhtE73gkCRWIHc8/DcN99TYKjbl
	 EjiI4MAOhpogoUaVB1wWQ1BJ81nAMq4Kbko6X9rvMChkbht6BE9DXb+XuNGe0E1FHh5IN
	 2FaWeMEP4WfcWqISLeLGNuhP3kWlNKDcQ0tTk++ojdeyFv8VIjvmav7f3T/tdwOaT3eQM
	 e5leR5PFrpCCrbNdrOApttzebTFCwqNrK32rifnrEe/ODsPfNXfC3kUNhVS5lq6JIUw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B2F41F000C1;
	Wed,  4 Nov 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815221;
	bh=c02aKpRwVT41c4Cvhuz9Cocr6EuWMjLz4xwoNPqAsQ0=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=m6l4EM2S44s9Ef562sFJeFe8xeWHfGEC8fDYfRR1rjwm11QCZF1nd07QtCJRTcPHR
	 oSjSs8R2eI/d9TqpAwh3bGNdsINcVPoLDThH/2TfoaRE4xOgb4XFdC8DkoxHTCX0Al
	 fKAMb+WMP+h7H8BRUuEF96boDgcC9qLjBI6NCfW0/X3p+CXkG3KDw3M8dgslkuxNWb
	 fhslAeTx3sSVI5A4OBo1gbQShavV/dhhFMvw8mZj8K+E3COukqEbHIFEqq6oDlH2nm
	 ry1ltwEVbMq/R6iJmVjo7I1aft5xqnxtdC5uijs2D5E+oV8zJ19jtA/wOpMASehz+x
	 JiEH+Ki3Dzd6A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7E12C46EFD;
	Wed,  4 Nov 2026 18:00:19 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Subject: [PATCH v2 0/2] btrfs: zoned: fix silent data loss from leaked
 active zone reservation
Date: Wed, 04 Nov 2026 23:00:18 +0500
Message-Id: <20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NQQ6CMBCF4auQWTumrUTElfcwLEo7hYlATds0K
 uHuVk7g8nuL/60QKTBFuFYrBMoc2S8F6lCBGfUyELItBiXUWQrVYp+Ci/jxC1nUJnGmHTiRfmD
 fn2qtlW0v0kBJPAM5fu35e1c8ckw+vPe3LH/rn+EsUWDTNNYK6Vwr69swa56Oxs/Qbdv2BRtR3
 kfIAAAA
X-Change-ID: 20261029-btrfs-zoned-active-zone-leak-bb34aa2d981c
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, stable@vger.kernel.org, 
 Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793815218; l=6777;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=xSIK1HX5mQGo89AMMrRLlOySg0P+Nsrmd95DAFY59Lo=;
 b=emwMDsMWXPt6AOxgNdVxeiOFjEDbRGhbOc4MF8tqbjPKLwNWOWafh4qpVWQoMCt2ArDmJFv58
 1WgME60WkIRBBZifEREzfeMLF3h4dTKhB8RT0kUgkjG9iTn2ot9mnnE
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com

On zoned btrfs, buffered writeback can fail with -ENOSPC after a
balance on a device with plenty of free space, and the data is lost:

  BTRFS error (device ublkb0): cow_file_range failed, root=5 inode=...
    start=... len=16777216 cur_offset=... cur_alloc_size=0: -28

write() and close() succeed, cp and rsync exit with 0, and only the
first syncfs() returns -ENOSPC. In the original report (ublk zoned
device, 16 MiB zones, 7.2.11) a 3.7 GB git pack file copied with rsync
lost 37 ranges of 16 MiB. The code involved is the same in master and
in btrfs for-next. The v1 cover letter has the traces and more detail.

Cause
-----

1. btrfs_relocate_block_group() ignores -EAGAIN from
   btrfs_zone_finish(), which it gets for a metadata or system block
   group with tree blocks not written yet and for the data relocation
   block group. The block group is then removed with its zones still
   active, and its share of reserved_active_zones is never given back.
   On the reporter's machine the reservation was -3 before a remount,
   with four removed block groups still on zone_active_bgs.

2. With a negative reservation, btrfs_can_activate_zone() always
   reports a free active zone for data. When the active zones run out,
   the allocator neither finishes a block group nor waits for one: it
   allocates a chunk it cannot activate, and find_free_extent() returns
   -ENOSPC.

Patch 1 finishes the zones of the relocated block group before it is
removed; by then it is read-only and empty, and its tree blocks are
written. Patch 2 treats a negative reservation as zero for data, as
it can also be negative for a short time without the leak. Patch 1 has
to come first: patch 2 alone leaves no active zone for a new system
block group and runs into the deadlock under "Not fixed here".

Both are marked for stable 7.0 and later only, as
btrfs_relocate_chunk_finish() appeared in 7.0. I can send backports
for older stable trees if that is wanted.

Reproducer
----------

zoned null_blk, 16 MiB zones, 16 open zones, commit=300. Each forced
metadata+system balance after new chunks were allocated leaves one block
group behind; then several writers lose their data:

  mount -t configfs none /sys/kernel/config
  d=/sys/kernel/config/nullb/zdev; mkdir $d
  echo 4096 > $d/blocksize; echo 1 > $d/memory_backed; echo 1 > $d/zoned
  echo 16 > $d/zone_size; echo 8192 > $d/size; echo 16 > $d/zone_max_open
  echo 1 > $d/power
  mkfs.btrfs -f -O zoned -d single -m single /dev/zdev
  mount -o commit=300 /dev/zdev /mnt
  for r in 1 2 3 4 5 6; do
          dd if=/dev/urandom of=/mnt/pre$r bs=1M count=64
          btrfs balance start --force -m -s /mnt
  done
  for i in 1 2 3 4 5 6 7 8; do
          dd if=/dev/urandom of=/tmp/src$i bs=1M count=512
  done
  for i in 1 2 3 4 5 6 7 8; do cp /tmp/src$i /mnt/data$i & done; wait
  sync -f /mnt; sync -f /mnt
  echo 3 > /proc/sys/vm/drop_caches
  for i in 1 2 3 4 5 6 7 8; do cmp /tmp/src$i /mnt/data$i; done

"Zombies" are active metadata/system block groups in mountstats with a
write pointer but used, reserved and unusable all 0; the reservation is
3 minus the active metadata and system block groups.

                    zombies  reservation  cow_file_range  syncfs  files
                                          failures                differ
  for-next                3           -2           31625  fail x2    8/8
  for-next + series       0            1               0  0, 0       0/8
  patch 1 only (v1)       0            1               0  0, 0       0/8
  patch 2 only (v1)  deadlock in balance (see below)

for-next is df5b88a7914e; the last two rows are v1 on master.

Testing
-------

v2 on for-next in a virtme-ng VM with CONFIG_PROVE_LOCKING and zoned
null_blk, data checked on disk after dropping caches: buffered, small
file and O_DIRECT writers with 16 and 128 open zones, filling the
filesystem, and writers with balance in a loop (system, metadata and
full balance, 10 and 16 open zones): no errors, no data loss, no
deadlock. The transaction abort below hit 3 of the 7 runs with
balance, as it does on master, in the commit in relocate_block_group()
before the code changed here. v1 was also tested on master with a ublk
device as in the report: the pack file that came out corrupted on
master was intact with the patches.

Not fixed here
--------------

- Recursive ro_block_group_mutex: btrfs_inc_block_group_ro() ->
  reserve_chunk_space() -> btrfs_zoned_activate_one_bg(info, true) ->
  btrfs_zone_finish_one_bg() -> do_zone_finish() ->
  btrfs_inc_block_group_ro(). Balance and writeback hang on master when
  a system block group is relocated with no active zone left.
- "error while writing out transaction: -EAGAIN" from the commit in
  relocate_block_group() aborts the transaction during balance while
  writing.
- A failed REQ_OP_ZONE_FINISH in call_zone_finish(), and a stripe that
  cannot be activated after others were in btrfs_zone_activate(), leak
  the reservation as well.

I used an AI assistant (Claude) for the investigation, the reproducer
and drafting the patches and this mail; the result was reviewed and
tested as described above.

---
Changes in v2:
- Rebase onto btrfs for-next.
- Patch 1: finish the block group as fully written after waiting for
  extent buffer writeback, instead of do_zone_finish(bg, false), which
  takes it read-only again: for a system block group that can allocate
  a system chunk under ro_block_group_mutex and take it again. Clearing
  the data relocation flag by hand is not needed anymore.
- Patch 1: if finishing fails, warn and remove the block group as
  before, instead of returning the error and keeping an empty read-only
  block group (btrfs_relocate_sys_chunks() would BUG() on the error).
- Patch 2: say in the comments that tree-log block groups count too and
  that the reservation is per zone.
- Mark both patches for stable 7.0 and later only, see above.
- Tests redone with v2 on for-next.
- Shorter cover letter, the v1 one has the details.
- Link to v1: https://lore.kernel.org/r/20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com

---
Mark Korenberg (2):
      btrfs: zoned: finish the zones of a relocated block group
      btrfs: zoned: don't treat a negative zone reservation as free zones

 fs/btrfs/volumes.c |  1 +
 fs/btrfs/zoned.c   | 54 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/zoned.h   |  9 ++++++++-
 3 files changed, 58 insertions(+), 6 deletions(-)
---
base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c
change-id: 20261029-btrfs-zoned-active-zone-leak-bb34aa2d981c

Best regards,
-- 
Mark Korenberg <socketpair@gmail.com>


