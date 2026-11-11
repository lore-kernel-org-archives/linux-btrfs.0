Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419582;
	b=NMtU/8NxbbC8mr0j/VecsX9YDeSKNuPZoVfqKfzIoTDa/N6gKNIHfotqD7w7EpPO/EW6
	 eBLS8XTqWyIY0u5KM1oRPblM7g0g0JILwonjqpfuRRkNSwolAKjKX9H24ZJ18fiaIFf9s
	 a8GaU3+8O5c0Lw1/byeZK47qTpA+/wKRlHVI2CutO7zDX/THnYBB5OlHzhdvNeoKammqa
	 RYi8dORrNSm3SGgZrSAEEsQX1Sgi+cghNn5bn3tamVhQccN5X4u7vNJTqD+3W2sgecgex
	 X32IMVSOpeyGSboQody4RtkHjnTo8ewdGj6YQB8xE/UaPSifrv09EEjczsycJcs/OXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419582;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GkjFHtQWF0tztspkFzgV81jcKJwRqCZN0wCqyxbV20I=;
	b=pUmEfYoU6+CYY+lHvdVH2/HvY1dtt6Xflq4TUp5k5TOopiqRg2RaVaXQQDdkkw8aRqCg
	 R9qWeqlFGQiNYvIUGQFV7dPlxpiKQKzWbfcZH/JXit0KWHcfvLW/jGbc14qCca+MrylT3
	 fzVqpuV7N3Ga6AbC3JPlS/kRtlPss/7QbrTh0P0b6AGVZ33q++uwsiilr+wDhprct7tzO
	 7AYMk/KmXjKc6PGG5/7qsKvyr2SdE6j02LFxZ9yt9y5505iCETWXl9FT6gT7whray/aig
	 smCGdXkMF57rtWNhRj1WQA7u9f2ufrRAOjRMX68skFGpYi9GCmD4xciiyrLAd5bZ4wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HbwYtqID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A94606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HbwYtqID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060961F00A05
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419582;
	bh=GkjFHtQWF0tztspkFzgV81jcKJwRqCZN0wCqyxbV20I=;
	h=From:To:Subject:Date;
	b=HbwYtqIDPCqDojoJ0uqLZ+1jrvlASh4W3KY7fsqqea5tf/fHvn/OFk8zgzyjJDYP5
	 PSQ9ofZMYOIL5I0uS36SsyaDSag+29gcWjA9ROKzsNc5d0GZp/8Ney9mXH+RnQbMj0
	 2+wtqNrA0wjul5M17d456Aq25Y0+sj6mg0B17/F7QFDkT3xtTEKWJKxazAM/vAlqnz
	 LsVt2KJt7CXRGjtKnBO2BMghXrMUxXPUGsroLcd3ZvISr05JmAj3aIv1y0nDWw3ZKP
	 2l389ruYfibKHYYYV2cIdbJJzCtv9iGXRETY9QCHnPUzsXuNsyvj/+vjlV9gttGwmr
	 aR4ouHCPoUa6w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
Date: Wed, 11 Nov 2026 17:52:58 +0000
Message-ID: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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
the function and make btrfs_ioctl_dev_info() use the RCU variant.

Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c   |  2 +-
 fs/btrfs/volumes.c | 58 +++++++++++++++++++++++++++++-----------------
 fs/btrfs/volumes.h |  2 ++
 3 files changed, 40 insertions(+), 22 deletions(-)

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
index a494c913ad12..c44ae0e9afc1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7549,30 +7549,46 @@ static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
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

