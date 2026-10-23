Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792791118;
	b=szo1pnYT4gI6QGb3eNrpkZQ00cM8+1Vr9M8DeDLQQW2MYT6ZaUhFyohCgqwRbOr1uxyU
	 Lf768NjSNq+lqijypVX3f4ycbj7mkXgc3zXbVJ86QyfLJY3v/hWeNYyv76ZAAJhuGnPns
	 FTpcnssCm7UEd+DpVbW+vTtWBrBaF72YPT3nkVFL22PMHt0z7pnCZ8S3e95VBR2kpMoTh
	 D4JHh5v7J4JWbgg/QA9fus/dNfyHaeBtUjX9s9+lW31BzznXsH/FWIAJE03EzIelzkzfS
	 XHoAyx3ntPp3Ko0b5OdlLTd1yzZYBkaMS26UooMg0JfQPSlrYW3fgLhJ0nJk+QMWhTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791118;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ocF8Lo8LjPq6cYFdYP45DVtx4rTESVf+gENIjLj4css=;
	b=vpwupLLGhImhH9yFW50e8GC0yLY0pLaC/WlKVYXhPEidYrA9IMdKpoVTXkOBroT7xoc8
	 RKDqs1vabRrfR9vtVOatK0ZODTCHcH7AIiggSDOlGOvszSevmURpK8oDY6HGTciOOwffR
	 wkwvzDm/bNrcqANDhYOtlp8jUCAM8VJmFw7K6ZG6ggg6/EAeU4bZ4dYYiQloJNXCquQU1
	 GY3UytB6O3sT+O8ZJhl1oWJp0/r8cx5WbsP5mkYLbixhaIpH/mifhAhZ/K/rF55UaAec5
	 v15xEiFFkMXL4YQ1v9mmmsM7dI/FZhN3yPSgEbNCA+QxjKu2NFkIW4tY6lozA3BI+Cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL6TH2Ul;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE8C606A31A;
	Fri, 23 Oct 2026 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL6TH2Ul
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792791117;
	b=XRKa0qG+BdJ+ViduIY0Ynftan/BV6A0GS6GY2wOXC53Am/0f+VvIU5IqX5EfY+ssZUk6
	 lSaPW7sJu8AjUiQxbOC2Sei1WYKjqtLL0dxcGsvX2coe+cUnfb7pag+aTmeL+mqxG6N3M
	 A2e3Yu7RSoZAIzBjAPj7G4PHiz3P8eWzW8PkoBFwKiQ3ATEy2Q5JVl8A2oScx8O6+ynXv
	 5HfdWJYbB2OPj32FLq+w5lKYAmAIEGiwcf58OZ2spKHANNY8H1SFrYe/p7KnR1AQc7Loz
	 Mk5mwU2YD6unzh1TK/91+YC1NftvQPeIMYgxXxTfLxsgzSFp8GAebqq7RY+Udmlk/CQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792791117;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ocF8Lo8LjPq6cYFdYP45DVtx4rTESVf+gENIjLj4css=;
	b=ITUTfEofUI/7/GgY30p+AOD8jWBwNY0g/bDjznJkNzxtWN9JVm5YYJsoyZiNH9T/Uxpe
	 WivgS5jGzxO/yeaAAxg+LPvvCvlqgKEDuHUW+gGeTLynyF4mfkUPh4NCqYlCBlA2nRnGT
	 7nbAQ+GcMe2+FG9U/asC7KkBgy3Z+maNTE0CnuhygROD7hbNnzqTOQBiiyGBNEfymofqC
	 nXEWG/rMJxucc1BTaxFz4pd1+2Z5U1Tj/6mxVq/LS7+C2bTMc8U8jQjb9QRQimQ4gFnNn
	 vqiORUD3MGOgXOaPPZ3HB9HKON63RSxBAPHXwOaDgprtOEmtvNvXSGXVQ9b05nzBBdA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9E1B71F01828;
	Fri, 23 Oct 2026 21:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792791117;
	bh=ocF8Lo8LjPq6cYFdYP45DVtx4rTESVf+gENIjLj4css=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=eL6TH2UlCHUYXvBDt+rBc2dfPce7f/XCrl7ROyIJcuQip5J5ylZQAT1jvU1cEknI9
	 WnAW93dn37MYJTJaC7vSfDX1G25v4p/gWLZ+l8xKWnBPrUgLUda7RdwOVilbwobUz0
	 VsJNFqwUtbpeZQnkfXFR/zx87oH9aHQCxfLvLs1v+Lm9wcHhBM+XOW1Ae87EX+PS4M
	 qPI+r+3W6D2lR/7QRLFvEWxYcSSUb66kHR8N92YsHZE93iZBs0p+8SAqGOvM9+lC3R
	 Sj2oiwfcRsEZGqJrf25ZZrblUwfjeXL24k1DmDRrf0HUnxuDteEsz8bgnPuspcL3Gr
	 2hswz8TYTcM7w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 00D9644633;
	Fri, 23 Oct 2026 21:31:55 +0000 (UTC)
From: Stanislav Zubenko via B4 Relay <devnull+zubenkos.external.gene.com@kernel.org>
Date: Fri, 23 Oct 2026 21:31:55 +0000
Subject: [PATCH] btrfs: fix race between device add and chunk allocation
 leading to transaction abort
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
Message-Id: <20261023-btrfs-device-add-race-v1-1-90cf05e8128f@external.gene.com>
X-B4-Tracking: v=1; b=H4sIAErS22oC/yWMQQrCQAxFr1KyNtCZFileRVxMk4zGRZWkFqH07
 qZ19x/891ZwMRWHS7OCyaKurykgnRqgR5nugsrBkNt8Tm3ucJytOnJcSbAwo5UYPFBfE3XCQw/
 hvk2qfo/u9fZn/4xPoXmPwbb9ADELwlF5AAAA
X-Change-ID: 20261023-btrfs-device-add-race-d8c4f1c3ed84
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Stanislav Zubenko <zubenkos@external.gene.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792791115; l=9455;
 i=zubenkos@external.gene.com; s=20261023; h=from:subject:message-id;
 bh=U7hv/vC2ZXRxYfgJAmHzlLJa2Sn+3zvaObhbPm1YuR0=;
 b=Qtg3cG7lhJThEgFKoxurxMFVKBdqgSZMc2lBXkUePCmhZB3ryfklnCI2CB9Fh6JcyIopFzUNn
 mbsD7cjms+8AAs+XvFbi5X8UBf/38lNKZ5UHwNYL5jYxtb5XsMPtEmR
X-Developer-Key: i=zubenkos@external.gene.com; a=ed25519;
 pk=0lNZ1Ki/iWkgLjsQ0VnWTZUii4kMtSjcrpbJKg4UoWQ=
X-Endpoint-Received: by B4 Relay for zubenkos@external.gene.com/20261023
 with auth_id=1296
X-Original-From: Stanislav Zubenko <zubenkos@external.gene.com>
Reply-To: zubenkos@external.gene.com
Content-Transfer-Encoding: 7bit

From: Stanislav Zubenko <zubenkos@external.gene.com>

While adding a device to a filesystem that was under heavy buffered write
load, a chunk allocation done by writeback aborted the transaction with
-ENOENT, which turned the filesystem read-only:

  BTRFS: Transaction aborted (error -2)
  WARNING: CPU: 15 PID: 1149147 at fs/btrfs/block-group.c:3731 do_chunk_alloc.cold+0x162/0x1b7 [btrfs]
  CPU: 15 PID: 1149147 Comm: kworker/u128:13 Tainted: G           OE      6.1.170-213.321.amzn2023.x86_64 #1
  Hardware name: Amazon EC2 r6i.16xlarge/, BIOS 1.0 10/16/2017
  Workqueue: writeback wb_workfn (flush-btrfs-1)
  RIP: 0010:do_chunk_alloc.cold+0x162/0x1b7 [btrfs]
  Call Trace:
   <TASK>
   btrfs_chunk_alloc+0x15d/0x2f0 [btrfs]
   find_free_extent_update_loop+0x1f6/0x2d0 [btrfs]
   find_free_extent+0x347/0x740 [btrfs]
   btrfs_reserve_extent+0x147/0x290 [btrfs]
   cow_file_range+0x15c/0x590 [btrfs]
   btrfs_run_delalloc_range+0x111/0x1d0 [btrfs]
   writepage_delalloc+0xc1/0x180 [btrfs]
   __extent_writepage+0x10c/0x460 [btrfs]
   extent_write_cache_pages+0x141/0x4e0 [btrfs]
   extent_writepages+0x7b/0x140 [btrfs]
   do_writepages+0xcd/0x1c0
   __writeback_single_inode+0x41/0x270
   writeback_sb_inodes+0x209/0x4c0
   __writeback_inodes_wb+0x4c/0xe0
   wb_writeback+0x1d7/0x2d0
   wb_do_writeback+0x22a/0x2b0
   wb_workfn+0x5d/0x250
   process_one_work+0x1e5/0x3b0
   worker_thread+0x50/0x3a0
   kthread+0xd9/0x100
   ret_from_fork+0x1f/0x30
   </TASK>
  BTRFS: error (device nvme1n1: state A) in do_chunk_alloc:3731: errno=-2 No such entry
  BTRFS info (device nvme1n1: state EA): forced readonly

The filesystem had a single data profile, it was about 80% full and was
receiving around 1GB/s of buffered writes. The abort happened about 11
seconds after "btrfs device add" was started for a sixth device, and the
add never completed (no "disk added" message was logged). The same
happened on a second machine with the same workload on the same day.

The -ENOENT comes from btrfs_update_device(), which does not find the
device item of the device being added. This is due to a race between
adding a device and chunk allocation, which the following diagram
illustrates:

         CPU 1                        CPU 2

 btrfs_init_new_device()
   btrfs_start_transaction()
   lock fs_devices->device_list_mutex
   lock fs_info->chunk_mutex
   adds the new device to
   fs_devices->alloc_list
   btrfs_clear_space_info_full()
   unlock fs_info->chunk_mutex

                              cow_file_range()
                                btrfs_reserve_extent()
                                  find_free_extent()
                                    btrfs_join_transaction()
                                      --> joins the transaction
                                          started by CPU 1
                                    btrfs_chunk_alloc()
                                      lock fs_info->chunk_mutex
                                      do_chunk_alloc()
                                        btrfs_create_chunk()
                                          --> picks the new device,
                                              it is the one with
                                              most free space
                                        btrfs_chunk_alloc_add_chunk_item()
                                          btrfs_update_device()
                                            --> doesn't find the
                                                device item of the
                                                new device, returns
                                                -ENOENT
                                        btrfs_abort_transaction()
                                      unlock fs_info->chunk_mutex
   btrfs_sysfs_add_device()
   unlock fs_devices->device_list_mutex
   btrfs_add_dev_item()
     btrfs_reserve_chunk_metadata()
       lock fs_info->chunk_mutex
       unlock fs_info->chunk_mutex
     inserts the device item in the
     chunk btree, but it's too late

Before commit 79bd37120b14 ("btrfs: rework chunk allocation to avoid
exhaustion of the system chunk array"), device items were only updated in
phase 2 of the chunk allocation, at btrfs_finish_chunk_alloc(), and that
was done while holding the device_list_mutex, which is taken there since
commit 50460e37186a ("Btrfs: fix race when finishing dev replace leading
to transaction abort"). Since adding a device holds the device_list_mutex
until after it registers the device in sysfs, the race window was only the
very short time between unlocking that mutex and inserting the device
item. The chunk allocation rework moved the device item updates to phase
1, under the protection of the chunk_mutex only, so the window now also
covers the sysfs registration and the system space reservation done by
btrfs_add_dev_item(), which must take the chunk_mutex itself and so can
end up waiting for the very chunk allocation that is going to fail.

Fix this by deferring everything that makes the new device usable by
the chunk allocator until btrfs_add_dev_item() has inserted its device
item in the chunk btree: adding it to the allocation list, accounting
its space in free_chunk_space, clearing the full flags of the space
infos and updating the per profile available space.

When sprouting a seed filesystem, keep doing this before inserting the
device item, because init_first_rw_device() has to allocate chunks from
the new device first. That is safe because a seed filesystem is
read-only and we are holding sb->s_umount, so nothing else can be
allocating chunks.

Fixes: 79bd37120b14 ("btrfs: rework chunk allocation to avoid exhaustion of the system chunk array")
CC: stable@vger.kernel.org # 5.15+
Assisted-by: LLM
Signed-off-by: Stanislav Zubenko <zubenkos@external.gene.com>
---
 fs/btrfs/volumes.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6574939e1..bc8ffa7bb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3066,15 +3066,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	mutex_lock(&fs_info->chunk_mutex);
 	list_add_rcu(&device->dev_list, &fs_devices->devices);
-	list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
 	fs_devices->num_devices++;
 	fs_devices->open_devices++;
 	fs_devices->rw_devices++;
 	fs_devices->total_devices++;
 	fs_devices->total_rw_bytes += device->total_bytes;
 
-	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
-
 	if (bdev_rot(device->bdev))
 		fs_devices->rotating = true;
 
@@ -3088,12 +3085,20 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    orig_super_num_devices + 1);
 
 	/*
-	 * we've got more storage, clear any full flags on the space
-	 * infos
+	 * The chunk allocator must not use the new device before its device
+	 * item is in the chunk btree, otherwise allocating a chunk on it fails
+	 * to update that item with -ENOENT and aborts the transaction.
+	 * Sprouting is the exception: init_first_rw_device() must allocate from
+	 * the new device before its item can be inserted, and nothing else can
+	 * allocate chunks since a seed filesystem is read-only and we are
+	 * holding sb->s_umount.
 	 */
-	btrfs_clear_space_info_full(fs_info);
-
-	btrfs_update_per_profile_avail(fs_info);
+	if (seeding_dev) {
+		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+		atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
+		btrfs_clear_space_info_full(fs_info);
+		btrfs_update_per_profile_avail(fs_info);
+	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	/* Add sysfs device entry */
@@ -3134,6 +3139,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		 * its fsid has been changed by btrfs_sprout_splice().
 		 */
 		btrfs_sysfs_update_sprout_fsid(fs_devices);
+	} else {
+		mutex_lock(&fs_info->chunk_mutex);
+		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+		atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
+		btrfs_clear_space_info_full(fs_info);
+		btrfs_update_per_profile_avail(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 	}
 
 	ret = btrfs_commit_transaction(trans);
@@ -3190,13 +3202,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (!list_empty(&device->post_commit_list))
 		list_del_init(&device->post_commit_list);
 	list_del_rcu(&device->dev_list);
-	list_del(&device->dev_alloc_list);
+	if (!list_empty(&device->dev_alloc_list)) {
+		list_del_init(&device->dev_alloc_list);
+		atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
+	}
 	fs_info->fs_devices->num_devices--;
 	fs_info->fs_devices->open_devices--;
 	fs_info->fs_devices->rw_devices--;
 	fs_info->fs_devices->total_devices--;
 	fs_info->fs_devices->total_rw_bytes -= device->total_bytes;
-	atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
 	btrfs_set_super_total_bytes(fs_info->super_copy,
 				    orig_super_total_bytes);
 	btrfs_set_super_num_devices(fs_info->super_copy,

---
base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
change-id: 20261023-btrfs-device-add-race-d8c4f1c3ed84

Best regards,
--  
Stanislav Zubenko <zubenkos@external.gene.com>


