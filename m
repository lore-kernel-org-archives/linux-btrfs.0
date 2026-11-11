Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794427385;
	b=3JGalqlBffVSmjb1W9pwB9KMFVtC/bv6mLOcjz9Gls/2/7M83oUTvA2wRnuWm8MYoVWV
	 55TkE1Z1yEivY89LbJgmGE8YsKtmjrHaHGTxBwHUJ0WfC1avfNJWsROlnlkRf3Nt+wvI7
	 AKzVbsN3xVLJBwTzg7l0u2RO+UNQ5fbUCB9eA1JJeAr6XWHrL7yrxu20MtW5MRsNxFawj
	 WZCpHpfG5EUYaE52DUs0bP0niDsca7n1IGLaQ3VM7xfdggceA7rAfLYkKi7gkPyXCgFOq
	 3AbjywyYNt8y2vnB3NLXXzFwyMC50+o9eW9UYvCqOP8Z2sVvcuzX0uJQMwwfdmBsOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794427385;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=plEETNLXcLdgjlBCcvxhvEcBxsmAQRzICMsLKrvd10g=;
	b=mLhLJ3IFou53jZniu6wmaZfI1S3hFsTjH09lVOh8haSAT+yZCf+nQbTMqSi2U/C5eN3e
	 x5ALSB4Stia8e/f+Ynh75qx753SuzftLP4UQIH3X9Wz2oO63doeJohyLLC+SRHereoRrb
	 sK3M9vKoiGFcRQCed/f+UDc7nwORpsVYGBaCy7fTynUadTNo3dg8jjGSU/4Ofs5qZD962
	 IiplcK2DyNaTViThQ0lX4A+cJfjj/pyF9OJFVNdZ1Hn77x+Aj4r54HjvAV9Skyx1O9C/j
	 P7RTbzDl/VW/LpzUJUNtqRXDKXKvxP3GjPybgbQJgrOw4OWNce7KLjitYSBgVu34bow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hi1rVF80;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC3E606A33B
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 20:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hi1rVF80
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5AA1F00A05
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 20:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794427385;
	bh=plEETNLXcLdgjlBCcvxhvEcBxsmAQRzICMsLKrvd10g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Hi1rVF80aoaHXodkwn/nzx2yx0svMhQkdajg3Sr8xFzMlbBmT3OJ2TqSlFP1owGsj
	 Rbl9BmxBe1LtCqhq8QL+uqqWje6w4jaW/yezj3AamfvIwzh5wdDcfe95UVyD3QS1/p
	 jzOiZk62hB+eMjWF9rel/6gGUqBLul8SP8MLkdrslhq0M3aad5VE2+xAxBPd2/ZP1M
	 E8oYN4NZOmQxyRPM92O4hif6a4Y8zAar1Dr1yHC+VRvdbb8A51m0v0w1VZYu9bqVz0
	 /D8WGCS7VMSShzQPPiJ70Kl8z5wV6z2U+LBMPiRZqN9Uf//OwmRSYLFi5qK3SI/xn0
	 X3++QdfTgiiNg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
Date: Wed, 11 Nov 2026 20:03:01 +0000
Message-ID: <7523a44da9b8504e6cbc65b9f5388c07a7aaa645.1794426971.git.fdmanana@suse.com>
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
to use RCU list manipulation variants instead and take the uuid_mutex
in btrfs_rm_device() before deleting from the seed_list list as well as
synchronizing RCU after unlocking.

Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix other existing RCU issues pointed by Sashiko.

 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/volumes.c     | 67 +++++++++++++++++++++++++++---------------
 fs/btrfs/volumes.h     |  2 ++
 4 files changed, 47 insertions(+), 26 deletions(-)

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
index a494c913ad12..89951666d5fa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2515,9 +2515,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	 * remove it from our list and free the fs_devices.
 	 */
 	if (cur_devices->num_devices == 0) {
-		list_del_init(&cur_devices->seed_list);
+		mutex_lock(&uuid_mutex);
+		list_del_rcu(&cur_devices->seed_list);
 		ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
 		cur_devices->opened--;
+		mutex_unlock(&uuid_mutex);
+		synchronize_rcu();
 		free_fs_devices(cur_devices);
 	}
 
@@ -2799,7 +2802,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
 	fs_devices->rotating = false;
-	list_add(&seed_devices->seed_list, &fs_devices->seed_list);
+	list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
 
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
@@ -2821,7 +2824,7 @@ static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
 	lockdep_assert_held(&uuid_mutex);
 	lockdep_assert_held(&fs_devices->device_list_mutex);
 
-	list_del_init(&seed_devices->seed_list);
+	list_del_rcu(&seed_devices->seed_list);
 	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		device->fs_devices = fs_devices;
@@ -7549,30 +7552,46 @@ static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
  * If devid and uuid are both specified, the match must be exact, otherwise
  * only devid is used.
  */
-struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
-				       const struct btrfs_dev_lookup_args *args)
-{
-	struct btrfs_device *device;
-	struct btrfs_fs_devices *seed_devs;
+#define BTRFS_GENERATE_FIND_DEVICE(func_name, iter_macro)			\
+struct btrfs_device *func_name(const struct btrfs_fs_devices *fs_devices,	\
+			       const struct btrfs_dev_lookup_args *args)	\
+{										\
+	struct btrfs_device *device;						\
+	struct btrfs_fs_devices *seed_devs;					\
+										\
+	if (dev_args_match_fs_devices(args, fs_devices)) {			\
+		iter_macro(device, &fs_devices->devices, dev_list) {		\
+			if (dev_args_match_device(args, device))		\
+				return device;					\
+		}								\
+	}									\
+										\
+	iter_macro(seed_devs, &fs_devices->seed_list, seed_list) {		\
+		if (!dev_args_match_fs_devices(args, seed_devs))		\
+			continue;						\
+		iter_macro(device, &seed_devs->devices, dev_list) {		\
+			if (dev_args_match_device(args, device))		\
+				return device;					\
+		}								\
+	}									\
+										\
+	return NULL;								\
+}
 
-	if (dev_args_match_fs_devices(args, fs_devices)) {
-		list_for_each_entry(device, &fs_devices->devices, dev_list) {
-			if (dev_args_match_device(args, device))
-				return device;
-		}
-	}
+/*
+ * Instantiate the non-RCU version.
+ * Callers must hold device_list_mutex, or uuid_mutex, under an exclusive
+ * operation or be in a context where the lists can not be changed concurrently.
+ */
+BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device, list_for_each_entry)
 
-	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
-		if (!dev_args_match_fs_devices(args, seed_devs))
-			continue;
-		list_for_each_entry(device, &seed_devs->devices, dev_list) {
-			if (dev_args_match_device(args, device))
-				return device;
-		}
-	}
+/*
+ * Instantiate the RCU version.
+ * Callers must hold rcu_read_lock().
+ */
+BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device_rcu, list_for_each_entry_rcu)
 
-	return NULL;
-}
+#undef BTRFS_GENERATE_FIND_DEVICE
 
 static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 					    u64 devid, u8 *dev_uuid)
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

