Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469374;
	b=TrcLndcZkc5hZvxxXp3wuOy5ANbzh4pXIDGoUViYMxL2DU2dwQQEM6waqkBMRifQlcVu
	 z5KOQhCC6LAM14SoPlAJoRZa0pLbfv6mTV8OfvfMN3QKMYK5FuGGHf2Ptxl+rqav0COH6
	 1pO3J6c2QyODEig9rvnk9eG3OJILXecLF2x4a0xkk6QZgHkLFQTea2VUh/7LuUbQ0tKZm
	 79GvITcEtwmaeEd5kNViV1ADEKFY6R2usnfboJ3ogB9qmSYF6LIisDSZY/Rp6jigPR9tq
	 o+Y6iZbB9iYMbh4qtdQ2WCI9C0Igf1IhtfJYY1bBuOxpnyO4cvfoQ0ZwyRgzGwMhPMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=c9potHSopAhDs6JHnKq+9TFBn3kUX6VriieMObcMjAo=;
	b=ZmNBZqK8yQinWNnYtUPBytSmQ1eONvrq70qPJ6OzD1KFBkDz6EarBUgGz/HKopOGtuqI
	 kXCn8lxVrHLhDdZhW07z4CQ8VT7gbzakZLw9DjeiM4yJnlHra8Z40fwMkvKULzF9YcCGX
	 8YwDFsYxILwgRUT5Yyc7D3+GNmALJB1BVBbh7aDc178VtnFFWU2n6RDTfYnVTtdT48L6v
	 iRK1mSkYVDjrwALkj4FJgBokI1AlaSiZndntFoT1zahjAMb6uRiUqtep7OTp2w/YJTO4h
	 nz6QUWAJ0ok3rXcrh6/8N9lL5O9mrnJAmwOMBsmlYDvEgRZ8dAbZJWXf6zz9L6kpZwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=RoHMEBAY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF46606A33B
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAF46606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=RoHMEBAY
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so29308185e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 23:42:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794469372; cv=none;
        d=google.com; s=arc-20260327;
        b=IuK1HyLIu+lCyevQbh5WVs+MBZIW0qdWQOFKpasDJ8Bp5hbfuK4vVMrJFYoV9Jy4hN
         2NctmxrTtrDp+gSi/knS44oTNxXz3OboIJzFmX37Djy4izddQQW+63/DZqCqvOccrxfC
         QjlVHrsHoBi7OmPCquMvOpF0E8OJYEOq+gTQiX+Xz6pHJXN6b/KwBKg/HGwXuF3SrsmM
         TjA09QxkEFrghUkILVaM0HhTIoN1EmoY2wAHNDRV4oPsNVwmSPJUpwiAdJvll0s9rjGb
         U0pScSGi7SjByBwGACQJtZyfkRViC9Fwjb36/Qp6qpeXnqGKkX69cGqJLO0vGXT31fqw
         nt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=c9potHSopAhDs6JHnKq+9TFBn3kUX6VriieMObcMjAo=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=bRHnJbZAEZxWvgiraF90FPSVtOUwnda9CtsVOd+jFOp5b4EC06z33GpUaUa+45yOcO
         k5efsoQq9ybdYW48gTgsGZrgQKZHit5ifewEf/rDRkEylo1O53uVpcJ0D8ywvmQr/seE
         Rko47q9JN2QlJma4MdS3Qv3wQjd0zT/dJgDNRWYywlzpq11tNkAooFDfaDaEp24pb7F1
         KSdWhEz/LSo5w9+N2R8S+UUIEyQlXIvvp77DPpn7wJ5j5uShI4v+M0gB3921lj6aYoSw
         xRdm/NAIzkskvmm6VxMxRdVcqUraiiFKa6l6xEjXMtEhMt2c0kq7ro34MkjAQskKU+JP
         Hf6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794469372; x=1795074172; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c9potHSopAhDs6JHnKq+9TFBn3kUX6VriieMObcMjAo=;
        b=RoHMEBAYSjYr4ndU1mCGE5oZA+mngFxDmwFuKOOf45mn+dTOEp+hdEn+Vor4yvT1lM
         UsWlPHFzuEtvYyzRPvUOUSmyHMsZq4mpH6OkO2rQ3GrR+PodzcA21z7+TQWZJUlNOVmG
         Srl4fzj3vMBbyvdYb6Us1AhkSqgoQJ1gepUwnnr4cHqn8jBOu7VKYiz90ohIu9z1ctAi
         f668gB/wARxT80IykHF08A8c9kBvoV2ZEaUtzZ0jtnO9/gToA+JmTqd9hV4LazQ0GLvp
         103BRE5ERerPNLbVGE71+/EQVdKrVAKcRmBfV0cw4vUZEcfPVEzNWwi8C9b7sktGUMY+
         VVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794469372; x=1795074172;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c9potHSopAhDs6JHnKq+9TFBn3kUX6VriieMObcMjAo=;
        b=xPNh09kUlzH2YTnQh6ZjoAdgKT6CCM8Lzsupk7ea0fTTRNxigF7HAffebtUrs+vmZr
         SmI1/9RgMTPMEV2nMQi5vwo1svkBQaUt5O/m1GngvP65aRXRzyZ9GxjPqERJrTO7NSAy
         rt5gSMuAZE0QqWn/gNhx1PHvMlK6qYNYQytdEqpEcepkSGyOQvsJCdsvXQQKKnV7xKAI
         ru3WVue54dz7ca/Y4vrWPiMZaRIlRuv5mvX6qFRiHihioXPxLx07WiHZ+ec6FK2hPpZc
         rskLnNq9sf4GvoxGEyyz7rQX5/VpZob+U4VuUEmKuwYzk8Ab0W14k831itXCuYaCVn46
         QPUg==
X-Gm-Message-State: APuU4Z+GhoKGkIC183G1WObA1+tXciPMU55ZLDAqDi6+gTZhcdbe3AK+
	Tx21lWLCOXAUiH+8VfjcrFVCJ0cxcr9aInrV+A0KzBFsYBi6V9fWTNlRcUI+hbLSxQiP/G2/mJJ
	A1TTTvUPueLZXyXOJOiPCkPo1Pdo9p/lnMfXmplWTdJ9lAghJkgl433yPpg==
X-Gm-Gg: AYBFou22eopj6oT7UErWpUb1jDPw+Pfo20FD862vjnY+6EEkVg8ftsA3Jx7ut9rEVsv
	RZfLKE6xNpw4ctOKaSlsYawdaYo8FjMH8+wS6gPmFMZyaY+lCTgQn+dxFQkfxmq6lDVyYcOU3/w
	dunnCcwLrvUqHCvjPCbH73RwSCfaMqLIE3Bn1WMWETNEBThXIksbNUbHQxa3/R5xIs703m6Z6FK
	inSAmN+s4aDqKmvrVj2m5tDtdj+wU1jTnZIB1sxkyJKHC28Phtdu2Z+EaoCDZy4Kaz1maGLM20b
	kazmrA1VjxJBpaVa8ENxDP3/WejSmIV3yu5+fL3BsiU2k3wsDnLpJoUA4YGYmlwxx+igy6NnIuT
	fyt5LgP9cVmWo/QsyvjW4V60BhoyS0MenT4AKWkYMcu7UsjPWPEsjj8g1IDblC/fcqyw0mZ4dno
	kRgT3MTLRncAtsvvWmrzLO3mr6u6K43VoACQ==
X-Received: by 2002:a05:600c:620e:b0:4a2:1a:a11d with SMTP id
 5b1f17b1804b1-4ba091aacf9mr81876735e9.0.1794469372145; Wed, 11 Nov 2026
 23:42:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
 <7523a44da9b8504e6cbc65b9f5388c07a7aaa645.1794426971.git.fdmanana@suse.com>
In-Reply-To: <7523a44da9b8504e6cbc65b9f5388c07a7aaa645.1794426971.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 12 Nov 2026 08:42:41 +0100
X-Gm-Features: AclHuK_ccE3vmU8VVFHUQP9NKfsEQv6Y8l_SkREDdOG3gsfqoWuJHIPbTwx2Cjs
Message-ID: <CAPjX3Ffhw3z0xqNRWwxDQg3n0qnuGY+rzSZAHZBZyOrKMrgmqw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Nov 2026 at 21:08, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> We are using a RCU read section but then we call btrfs_find_device() which
> iterates the device lists using a plain list_for_each_entry() and that is
> not safe it can result in loading uninitialized or torn pointers, leading
> to arbitrary memory dereferences, use-after-free conditions, and kernel
> panics.
>
> We can't just update btrfs_find_device() to use list_for_each_entry_rcu()
> instead, because all other callers are not in a RCU read section and they
> ensure protection from concurrent list changes by either holding the
> device_list_mutex, uuid_mutex, under an exclusive operation or simply
> being called in a context where concurrency can not happen (like during

I guess you missed that list_for_each_entry_rcu() has an api where you
can provide an optional lockdep condition in case it's being used
outside the rcu_read section. Using that there is no need to clone the
function.

I'd say something like this is the clean way to use it:

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2313,7 +2313,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
  if (ret)
  return ret;

- device = btrfs_find_device(fs_info->fs_devices, args);
+ device = btrfs_find_device_rcu(fs_info->fs_devices, args, true);
  if (!device) {
  if (args->missing)
  ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
@@ -7307,23 +7307,26 @@ static bool dev_args_match_device(const struct
btrfs_dev_lookup_args *args,
  * If devid and uuid are both specified, the match must be exact, otherwise
  * only devid is used.
  */
-struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
*fs_devices,
-       const struct btrfs_dev_lookup_args *args)
+struct btrfs_device *btrfs_find_device_rcu(const struct
btrfs_fs_devices *fs_devices,
+   const struct btrfs_dev_lookup_args *args,
+   bool cond)
 {
  struct btrfs_device *device;
  struct btrfs_fs_devices *seed_devs;

+ cond ||= lock_is_held(&fs_devices->device_list_mutex) ||
lock_is_held(&uuid_mutex);
+
  if (dev_args_match_fs_devices(args, fs_devices)) {
- list_for_each_entry(device, &fs_devices->devices, dev_list) {
+ list_for_each_entry_rcu(device, &fs_devices->devices, dev_list, cond) {
  if (dev_args_match_device(args, device))
  return device;
  }
  }

- list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
+ list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list, cond) {
  if (!dev_args_match_fs_devices(args, seed_devs))
  continue;
- list_for_each_entry(device, &seed_devs->devices, dev_list) {
+ list_for_each_entry_rcu(device, &seed_devs->devices, dev_list, cond) {
  if (dev_args_match_device(args, device))
  return device;
  }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0082c166af91..c2a7b76343e5 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -764,8 +764,13 @@ void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
       struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices
*fs_devices,
-       const struct btrfs_dev_lookup_args *args);
+struct btrfs_device *btrfs_find_device_rcu(const struct
btrfs_fs_devices *fs_devices,
+   const struct btrfs_dev_lookup_args *args,
+   bool cond);
+static inline struct btrfs_device *btrfs_find_device(const struct
btrfs_fs_devices *fs_devices,
+     const struct btrfs_dev_lookup_args *args) {
+ btrfs_find_device_rcu(fs_devices, args, false);
+}
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,

Note, explicit btrfs_find_device_rcu() is only used here in the case
where no concurency protection is needed. All the other users keep
using btrfs_find_device() as before.

And sorry about the broken formatting (Gmail).

--nX

> mount). So use a macro to generate both a RCU and a non-RCU variant of
> the function and make btrfs_ioctl_dev_info() use the RCU variant. We also
> have manipulation of the devices and seed_list lists that is not RCU
> safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those places
> to use RCU list manipulation variants instead and take the uuid_mutex
> in btrfs_rm_device() before deleting from the seed_list list as well as
> synchronizing RCU after unlocking.
>
> Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
> Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>
> V2: Fix other existing RCU issues pointed by Sashiko.
>
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/ioctl.c       |  2 +-
>  fs/btrfs/volumes.c     | 67 +++++++++++++++++++++++++++---------------
>  fs/btrfs/volumes.h     |  2 ++
>  4 files changed, 47 insertions(+), 26 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 3c48cc714fef..6f04d0a49d86 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -319,7 +319,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>                 goto error;
>
>         mutex_lock(&fs_devices->device_list_mutex);
> -       list_add(&device->dev_list, &fs_devices->devices);
> +       list_add_rcu(&device->dev_list, &fs_devices->devices);
>         fs_devices->num_devices++;
>         fs_devices->open_devices++;
>         mutex_unlock(&fs_devices->device_list_mutex);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 651a780dd7b1..3fc30649d01a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2791,7 +2791,7 @@ static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
>                 args.uuid = di_args->uuid;
>
>         rcu_read_lock();
> -       dev = btrfs_find_device(fs_info->fs_devices, &args);
> +       dev = btrfs_find_device_rcu(fs_info->fs_devices, &args);
>         if (!dev) {
>                 ret = -ENODEV;
>                 goto out;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a494c913ad12..89951666d5fa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2515,9 +2515,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>          * remove it from our list and free the fs_devices.
>          */
>         if (cur_devices->num_devices == 0) {
> -               list_del_init(&cur_devices->seed_list);
> +               mutex_lock(&uuid_mutex);
> +               list_del_rcu(&cur_devices->seed_list);
>                 ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
>                 cur_devices->opened--;
> +               mutex_unlock(&uuid_mutex);
> +               synchronize_rcu();
>                 free_fs_devices(cur_devices);
>         }
>
> @@ -2799,7 +2802,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
>         fs_devices->open_devices = 0;
>         fs_devices->missing_devices = 0;
>         fs_devices->rotating = false;
> -       list_add(&seed_devices->seed_list, &fs_devices->seed_list);
> +       list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
>
>         generate_random_uuid(fs_devices->fsid);
>         memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
> @@ -2821,7 +2824,7 @@ static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
>         lockdep_assert_held(&uuid_mutex);
>         lockdep_assert_held(&fs_devices->device_list_mutex);
>
> -       list_del_init(&seed_devices->seed_list);
> +       list_del_rcu(&seed_devices->seed_list);
>         list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
>         list_for_each_entry(device, &fs_devices->devices, dev_list) {
>                 device->fs_devices = fs_devices;
> @@ -7549,30 +7552,46 @@ static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
>   * If devid and uuid are both specified, the match must be exact, otherwise
>   * only devid is used.
>   */
> -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
> -                                      const struct btrfs_dev_lookup_args *args)
> -{
> -       struct btrfs_device *device;
> -       struct btrfs_fs_devices *seed_devs;
> +#define BTRFS_GENERATE_FIND_DEVICE(func_name, iter_macro)                      \
> +struct btrfs_device *func_name(const struct btrfs_fs_devices *fs_devices,      \
> +                              const struct btrfs_dev_lookup_args *args)        \
> +{                                                                              \
> +       struct btrfs_device *device;                                            \
> +       struct btrfs_fs_devices *seed_devs;                                     \
> +                                                                               \
> +       if (dev_args_match_fs_devices(args, fs_devices)) {                      \
> +               iter_macro(device, &fs_devices->devices, dev_list) {            \
> +                       if (dev_args_match_device(args, device))                \
> +                               return device;                                  \
> +               }                                                               \
> +       }                                                                       \
> +                                                                               \
> +       iter_macro(seed_devs, &fs_devices->seed_list, seed_list) {              \
> +               if (!dev_args_match_fs_devices(args, seed_devs))                \
> +                       continue;                                               \
> +               iter_macro(device, &seed_devs->devices, dev_list) {             \
> +                       if (dev_args_match_device(args, device))                \
> +                               return device;                                  \
> +               }                                                               \
> +       }                                                                       \
> +                                                                               \
> +       return NULL;                                                            \
> +}
>
> -       if (dev_args_match_fs_devices(args, fs_devices)) {
> -               list_for_each_entry(device, &fs_devices->devices, dev_list) {
> -                       if (dev_args_match_device(args, device))
> -                               return device;
> -               }
> -       }
> +/*
> + * Instantiate the non-RCU version.
> + * Callers must hold device_list_mutex, or uuid_mutex, under an exclusive
> + * operation or be in a context where the lists can not be changed concurrently.
> + */
> +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device, list_for_each_entry)
>
> -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> -               if (!dev_args_match_fs_devices(args, seed_devs))
> -                       continue;
> -               list_for_each_entry(device, &seed_devs->devices, dev_list) {
> -                       if (dev_args_match_device(args, device))
> -                               return device;
> -               }
> -       }
> +/*
> + * Instantiate the RCU version.
> + * Callers must hold rcu_read_lock().
> + */
> +BTRFS_GENERATE_FIND_DEVICE(btrfs_find_device_rcu, list_for_each_entry_rcu)
>
> -       return NULL;
> -}
> +#undef BTRFS_GENERATE_FIND_DEVICE
>
>  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
>                                             u64 devid, u8 *dev_uuid)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 891bc2432870..2319789635a3 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -773,6 +773,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
>                       struct btrfs_device *device, u64 new_size);
>  struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
>                                        const struct btrfs_dev_lookup_args *args);
> +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devices *fs_devices,
> +                                          const struct btrfs_dev_lookup_args *args);
>  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
>  int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
>  struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_info,
> --
> 2.53.0
>
>
