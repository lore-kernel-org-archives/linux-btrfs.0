Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794501650;
	b=dmc+rwnZLyQm2IMppqfkiyAtmoQAaD8HU39EsdqxSSVXI/1K+qWGuOw7aaWoLXC4N5A8
	 VJex+B1zHa11iZhZJU9eEf/yYD70DKe0Q98+uktqq7AJJoI0Z5QZfKVSNa3N0oBkLu8cq
	 9stqhRVvgP2iDy1LX/sgWqbIagxaKzeMZ9KlKVF0gU6zJdU9cPjnRJcCfEPzSzmTwpYyc
	 M0LjQ1qxKlIrOp0vZei7rQ1pYiG0Txbca/nobyOriP053x+mBzBnCNJQomsHKjPQYs0Pw
	 0/pIXsbNayaXuu8TlZuWXSEUCZF8eFqhlx3+gNQp77NIyOgJaSkUjOFtksLNSDz8OZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501650;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dqQ8pn06E8y7UmR4fLgZA0goeYeVLXGmGCNzZ7AcUm8=;
	b=GWlXEy8beZBnLAOQeKs5WOpnvqsePtV0iFj7UMQTNMP6CsM7L57jcw4AYzqZMLuifuv9
	 9XMC2bHNpwvk8XaxHb9b1MHBJ0DH/qGLFfFU1cv8/qs3uOm0ln6SERaqxxVqFtmY0j5l/
	 nV/8AyH1H0xMlDAJYBH8MfDe3Sx9KU7km1UdB+O0yKSgUGkIlHvd5uxHhB+rdWTHMzyYf
	 3G5D20IQp5rr8W2h2fIUh3mB8oCiSGH8rBpdHsqhQVIr0uZP4qJRuZoYkIV3/SwUm96XW
	 g5TVYUqadLLe9XoFMigr1q/xYbHGSFSDjuyGbrFfp5zf20wEzdBKs1IUUzr8u1TIr5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfV82xIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F6660A2602
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfV82xIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6211F000C7
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794501649;
	bh=dqQ8pn06E8y7UmR4fLgZA0goeYeVLXGmGCNzZ7AcUm8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=nfV82xIbnRhkNlzos1SRClibGKlPorrs5d7dnyQC7UNgHwPNcZcF4I92oj6QloyDn
	 KouRog7ILN20VrELNz5ma3WaKWuDH5JyQzlAIB/lmKxAyqInhUUNwr+HY7ZHm+x03G
	 o48x0JJoO1W4+JQP8EPkxwYcu/XSodMx4F+IVc7JlinZMoY+Ic7TcuMXcaM65yONes
	 Abu8Nl5e+nqMz0VcJMB6tVAaI9YEMilIHWTEe0Fi4SZnbT0gAm6M+/NljsXNTlKSdS
	 O0XZVGVE3pn0wRI7bVKI6BaIZROfqqzNyp6ZdDcKpXM8fByyOcdV9fkqldtYbVcWcK
	 saJof1aCt8/4g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
Date: Thu, 12 Nov 2026 16:40:30 +0000
Message-ID: <150f66a817441013417e0002b9d6c8a78010a494.1794501065.git.fdmanana@suse.com>
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

We can't just update btrfs_find_device() to use list_for_each_entry_rcu()
instead, because all other callers are not in a RCU read section and they
ensure protection from concurrent list changes by either holding the
device_list_mutex, uuid_mutex, under an exclusive operation or simply
being called in a context where concurrency can not happen (like during
mount). So use a macro to generate both a RCU and a non-RCU variant of
the function and make btrfs_ioctl_dev_info() use the RCU variant. We also
have manipulation of the devices and seed_list lists that is not RCU
safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those places
to use proper RCU list manipulation variants.

Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V3: Fix some more RCU related issues pointed by Sashiko.

V2: Fix other existing RCU issues pointed by Sashiko.


 fs/btrfs/dev-replace.c |   2 +-
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/volumes.c     | 100 +++++++++++++++++++++++++++++------------
 fs/btrfs/volumes.h     |   2 +
 4 files changed, 76 insertions(+), 30 deletions(-)

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
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 651a780dd7b1..3fc30649d01a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2791,7 +2791,7 @@ static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
 		args.uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info->fs_devices, &args);
+	dev = btrfs_find_device_rcu(fs_info->fs_devices, &args);
 	if (!dev) {
 		ret = -ENODEV;
 		goto out;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a494c913ad12..94af5ea3b0e1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 num_devices;
 	int ret = 0;
+	bool free_cur_devices = false;
 
 	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
 		btrfs_err(fs_info, "device remove not supported on extent tree v2 yet");
@@ -2483,8 +2484,29 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 
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
+	synchronize_rcu();
+	btrfs_free_device(device);
+	if (free_cur_devices)
+		free_fs_devices(cur_devices);
+
 	/*
 	 * At this point, the device is zero sized and detached from the
 	 * devices list.  All that's left is to zero out the old supers and
@@ -2503,24 +2525,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	*bdev_file = device->bdev_file;
-	synchronize_rcu();
-	btrfs_free_device(device);
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
-		free_fs_devices(cur_devices);
-	}
-
 	return btrfs_commit_transaction(trans);
 
 error_undo:
@@ -2799,7 +2803,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
 	fs_devices->rotating = false;
-	list_add(&seed_devices->seed_list, &fs_devices->seed_list);
+	list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
 
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
@@ -2821,11 +2825,15 @@ static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
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
@@ -7549,23 +7557,47 @@ static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
  * If devid and uuid are both specified, the match must be exact, otherwise
  * only devid is used.
  */
-struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
-				       const struct btrfs_dev_lookup_args *args)
+static struct btrfs_device *btrfs_find_device_int(
+				  const struct btrfs_fs_devices *fs_devices,
+				  const struct btrfs_dev_lookup_args *args,
+				  bool in_rcu)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *seed_devs;
+	/* If !CONFIG_PROVE_RCU_LIST we get variable unused warning. */
+	bool rcu_cond __maybe_unused;
+
+	/*
+	 * We are called in several contextes, sometimes protected by the
+	 * device_list_mutex, by being in an exclusive operation, in a context
+	 * where no concurrency can happen (so without any locking) or while
+	 * under an RCU read section.
+	 */
+	if (in_rcu) {
+		/*
+		 * rcu_read_lock_held() always returns true when
+		 * CONFIG_DEBUG_LOCK_ALLOC is not enabled.
+		 */
+		ASSERT(rcu_read_lock_held());
+		rcu_cond = false;
+	} else {
+		rcu_cond = true;
+	}
 
 	if (dev_args_match_fs_devices(args, fs_devices)) {
-		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		list_for_each_entry_rcu(device, &fs_devices->devices, dev_list,
+					rcu_cond) {
 			if (dev_args_match_device(args, device))
 				return device;
 		}
 	}
 
-	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
+	list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list,
+				rcu_cond) {
 		if (!dev_args_match_fs_devices(args, seed_devs))
 			continue;
-		list_for_each_entry(device, &seed_devs->devices, dev_list) {
+		list_for_each_entry_rcu(device, &seed_devs->devices, dev_list,
+					rcu_cond) {
 			if (dev_args_match_device(args, device))
 				return device;
 		}
@@ -7574,6 +7606,18 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
 	return NULL;
 }
 
+struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
+				       const struct btrfs_dev_lookup_args *args)
+{
+	return btrfs_find_device_int(fs_devices, args, false);
+}
+
+struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devices *fs_devices,
+					   const struct btrfs_dev_lookup_args *args)
+{
+	return btrfs_find_device_int(fs_devices, args, true);
+}
+
 static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 					    u64 devid, u8 *dev_uuid)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 891bc2432870..2319789635a3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -773,6 +773,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
 				       const struct btrfs_dev_lookup_args *args);
+struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devices *fs_devices,
+					   const struct btrfs_dev_lookup_args *args);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_info,
-- 
2.53.0

