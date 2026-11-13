Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589018;
	b=BSPjRrxWtliqaOWdJ/sH6clBTHeBcZY2EzwKW+UVl3gH0jfeaqm4UHzjsbXImZ/zAS5T
	 tOgevPzykPGyHKvpTejPx4DImxpjDp1VcQNMLeOHRiqGdteuN8RXFgIiMQrW8988Mfrac
	 LB/NOUggmAyMqsddmEFUz3k6ljewLScfLWJCzRhNfk8EjW5Dr34yADiHZXDv/ogCyLBTs
	 vPQpYEYGLFwWXm9mIxKArQpzpMsQ+btMu34Z6k335kWQWj65mexH3UeTFs6CAFrd7rijq
	 83BeiT2e9rBCw3CZyfJGJ6OJhnktHK3CvstkR7mI6KgmY4y8icgNnHWB/cADiIfbbCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589018;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=v+3n3QIKD2XESIVp/hD5U66lgAF1Tq/zRRDUdkArR8M=;
	b=JTzPFpwttDAi3c69LfbNAe8n4py/Y5f8JiRYSXS2Ao0mvggIQfBtOdnf1ibOjOtF9/Ft
	 u5DezXkc+0RFdYaNF87/B0fP/axvGMkbe8jRv9PF5mM0YbQD5l5K/zuX1snVZfq3er1cs
	 SZZFAtBuDi6yn1x4Xlv7JRa/OlFZQfNKRGgZYMJlyVqEmqK4Tv4pXA1GK+dJf98OHco+Y
	 fAAPE/A+eq+KwENEgOQO4f+/Fnkh2y16VUFVK4WyoQ97AaeJN5TSUZGnycx1HFNmU0HyX
	 J7qqu4QLxLSNhHi185Hqou/wLsbw1FAZ8U/0P4uYcj62jQRAMQWfwrb8cvPqjqoijVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N/R6ev9S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E2606A32E
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/R6ev9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E131F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794589017;
	bh=v+3n3QIKD2XESIVp/hD5U66lgAF1Tq/zRRDUdkArR8M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=N/R6ev9S7tMY81OBHQiHMZQhMFtzNzrQ2b/UyS5Pam2Us6uq3XrLGUag6OZ/JNCRm
	 w0VVaMaoZZENaWi9UvY8ZoFfGer/GrQV04CSge/c9CRfblCXKQubOcfqHVvFqt4wsY
	 dPpkX7lLBI3bO6SHWgBX9p8a/UF48XRRYHCDyCjQjsLZ5uFzkRU/rLaz9QvES2nq87
	 j/drzbnvwsI/FezrFSoB18PqlWZay71hNb/uOsZlST3qaXbI/wsC75Zpvlv9b7Xkth
	 hBbRP65q7OFPVRBr4roL5CaTKBQs8WoN3h76AYiIjQPk8n6DgTk6oDfdP0R3BxzE7h
	 /eDeoivfVTvdQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
Date: Fri, 13 Nov 2026 16:56:55 +0000
Message-ID: <036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
References: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are using a RCU read section but then we call btrfs_find_device() which
iterates the device lists using a plain list_for_each_entry() and that is
not safe it can result in loading uninitialized or torn pointers, leading
to arbitrary memory dereferences, use-after-free conditions, and kernel
panics.

Update btrfs_find_device() to use list_for_each_entry_rcu() and to always
define a RCU read section, since we have several callers that don't lock
the device_list_mutex before calling it, either because they are within
an exclusive operation or because they are in a context where no
concurrency can happen (like during mount for example).

We also have manipulations of the devices lists that are not RCU safe, in
btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(), btrfs_setup_sprout()
and btrfs_rollback_sprout(), so update those places to use proper RCU list
manipulation variants.

Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V5: Simplify things by always creating a RCU read section within
    btrfs_find_device(), as many callers don't lock device_list_mutex.

V4: Update stale changelog and fix a use-after-free on a device after
    removing it (both identified by Sashiko).

V3: Fix some more RCU related issues pointed by Sashiko.

V2: Fix other existing RCU issues pointed by Sashiko.

 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/volumes.c     | 69 +++++++++++++++++++++++++++---------------
 2 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3c48cc714fef..6f04d0a49d86 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -319,7 +319,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		goto error;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	list_add(&device->dev_list, &fs_devices->devices);
+	list_add_rcu(&device->dev_list, &fs_devices->devices);
 	fs_devices->num_devices++;
 	fs_devices->open_devices++;
 	mutex_unlock(&fs_devices->device_list_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a494c913ad12..f128115a3a3b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 num_devices;
 	int ret = 0;
+	bool free_cur_devices = false;
 
 	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
 		btrfs_err(fs_info, "device remove not supported on extent tree v2 yet");
@@ -2483,8 +2484,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 
 	num_devices = btrfs_super_num_devices(fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
+
+	/*
+	 * This can happen if cur_devices is the private seed devices list.  We
+	 * cannot call close_fs_devices() here because it expects the uuid_mutex
+	 * to be held, but in fact we don't need that for the private
+	 * seed_devices, we can simply decrement cur_devices->opened and then
+	 * remove it from our list and free the fs_devices.
+	 */
+	if (cur_devices->num_devices == 0) {
+		list_del_rcu(&cur_devices->seed_list);
+		ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
+		cur_devices->opened--;
+		free_cur_devices = true;
+	}
+
 	mutex_unlock(&fs_devices->device_list_mutex);
 
+	*bdev_file = device->bdev_file;
+
 	/*
 	 * At this point, the device is zero sized and detached from the
 	 * devices list.  All that's left is to zero out the old supers and
@@ -2503,23 +2521,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	*bdev_file = device->bdev_file;
 	synchronize_rcu();
 	btrfs_free_device(device);
-
-	/*
-	 * This can happen if cur_devices is the private seed devices list.  We
-	 * cannot call close_fs_devices() here because it expects the uuid_mutex
-	 * to be held, but in fact we don't need that for the private
-	 * seed_devices, we can simply decrement cur_devices->opened and then
-	 * remove it from our list and free the fs_devices.
-	 */
-	if (cur_devices->num_devices == 0) {
-		list_del_init(&cur_devices->seed_list);
-		ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
-		cur_devices->opened--;
+	if (free_cur_devices)
 		free_fs_devices(cur_devices);
-	}
 
 	return btrfs_commit_transaction(trans);
 
@@ -2799,7 +2804,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
 	fs_devices->rotating = false;
-	list_add(&seed_devices->seed_list, &fs_devices->seed_list);
+	list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
 
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
@@ -2821,11 +2826,15 @@ static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
 	lockdep_assert_held(&uuid_mutex);
 	lockdep_assert_held(&fs_devices->device_list_mutex);
 
-	list_del_init(&seed_devices->seed_list);
-	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+	list_del_rcu(&seed_devices->seed_list);
+	/*
+	 * Before splicing seed_devices, update the fs_devices of each seed
+	 * device, otherwise a concurrent RCU reader could get a use-after-free
+	 * on device->fs_devices still pointing to seed_devices.
+	 */
+	list_for_each_entry(device, &seed_devices->devices, dev_list)
 		device->fs_devices = fs_devices;
-	}
+	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
 
 	fs_devices->seeding = true;
 	fs_devices->num_devices = seed_devices->num_devices;
@@ -7555,21 +7564,33 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *seed_devs;
 
+	/*
+	 * In many cases we are called under the protection of
+	 * fs_devices->device_list_mutex, in others we are not, so always use a
+	 * RCU read section (if a caller needs a wider RCU read section, nesting
+	 * RCU sections works fine).
+	 */
+	rcu_read_lock();
 	if (dev_args_match_fs_devices(args, fs_devices)) {
-		list_for_each_entry(device, &fs_devices->devices, dev_list) {
-			if (dev_args_match_device(args, device))
+		list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
+			if (dev_args_match_device(args, device)) {
+				rcu_read_unlock();
 				return device;
+			}
 		}
 	}
 
-	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
+	list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list) {
 		if (!dev_args_match_fs_devices(args, seed_devs))
 			continue;
-		list_for_each_entry(device, &seed_devs->devices, dev_list) {
-			if (dev_args_match_device(args, device))
+		list_for_each_entry_rcu(device, &seed_devs->devices, dev_list) {
+			if (dev_args_match_device(args, device)) {
+				rcu_read_unlock();
 				return device;
+			}
 		}
 	}
+	rcu_read_unlock();
 
 	return NULL;
 }
-- 
2.53.0

