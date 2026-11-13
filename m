Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580162;
	b=eP05ufUf16Pr3qhIY2bSyDPr1mO+Xo+Fu+LRubqAj8QsQdQEOfJlXo1by8yNxu5tDK8W
	 ePnSnbNtiNNdPrpxB+v//PdpQrIlkuFAeed1GT2+LrJZ0BGk+7Vb+dknaMAUnYe8C+3uz
	 +mwKgMp3sMpDuK8KqdvcD8rpYr/1yDBrAIaAgLrKEoRPNEt7CTmijEUzUc9MPaaQvbrYY
	 FZBc9656TnqQb9zn38aZKGejlvpqobL7LIq24ATuvRcCMv4LVp6vbfOCYYe805K9o0LcJ
	 K0Fo0zcsHJEH4e6M6vvTVPd14EZk2RI6vSE9BGNBBgOJyj1BDoe8uWrcWwRl7M96RmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=eff/JjwhOv2bXxzs5qei19A6x00WqMi0DUYpqKxITDg=;
	b=kPaCO8+QFUzZUVqVTm5QiV0DO17iuC705FP5mxaWL0OuGpulMnGBI1nLHgtXEHAeKsWT
	 LbijxJL1JZ7vTT9hTnY+hkZzJae7iRECH3KyvtqxzANkhS4nU/bb/fmzsmUPdjIYA0qEd
	 d9llp+JVm+E3nJoCKuy7GeD1YG6ISQ7OcAtZ5wT6mixVL38P2DFehj8Dh6oGgqgrBytst
	 U5yRr2BR+c/Kb6l3xwk+wa7GjJWwG2eCKxgMelUonfiVuWm2prz46ms9NAKu29KJ/81qF
	 2d3ji4jWziRK8J5DXrAngwL1FZDAMhsYitKeOHsjw2Tz58+PZBh+J1O9GBHWEWhTchg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UcxuWOIm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44576606A8A8
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 14:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44576606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UcxuWOIm
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c40f29667e6so245685666b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 06:29:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794580160; cv=none;
        d=google.com; s=arc-20260327;
        b=GoNqonWGTJzKtKpAPL+WN9YekIo3+ap9fRRzAleZxv3r1vLHK+ltXLbeL8AHoJ/6Sd
         Qr332tO7HWYkM6pHAPSlU65j65zeo/d38Hm6bscjaJYZX52ikMzdOsDroLEYBLPM1Qzn
         JRAKv+WEqklKMKrwyEy0e6pCd2F20hWujDe6clg7wHswTGvmZkCuqfULEMO9hTXZgIe5
         10oC5MSk/mCqoMunHsNu15Ak0eJ3CenA6+6Yx/Y2xjAH1YK6iAxybFUkHvvhxM3sJOX6
         PcE4rDUpq4AaMtRyMmmr4z+UlsHmfJ60SnSmiLGeuWzqHsBo6DCYRJGop/fK9p4Y4cMP
         2o2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eff/JjwhOv2bXxzs5qei19A6x00WqMi0DUYpqKxITDg=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=Lmm6aio2QgbfX8IaWfWLZpwSiog59eNiEZadzfe5yroqSlUuZ3vpnUvbKGhMRnPs/e
         1e64dUHu5Ky7XNhvaVT5vQwU9SrZsk8mbRCPqcmPRacmwhSQMwjkZ14M/QRtzwXKOomu
         aQnvCwhyeh0YiLj1Gxc90bL7Fr6Fi2t1Y8IkOa/QDL2+JQ1KpUhyjxlev+PwxhMsK9DO
         u79tt+2pRKGbQZvZqwpwNAsiHZhKIUSlj+tc24W5UkR3FyxVrzfagqvZPcDPouj98FDZ
         +kunxHV22AtfC9SJxXNOJtH3Kal2jQ6zQDkwlD/ZkWcU770ieTfuUzndli2Cuwu6D9oc
         tsBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794580160; x=1795184960; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eff/JjwhOv2bXxzs5qei19A6x00WqMi0DUYpqKxITDg=;
        b=UcxuWOImbkqBkdKsZZhIbicydsz+fKsSwgeExUS2N1QfZjCd3UQUHUuqdO+DwSQSvN
         V1SDxZ7qslIlr3HCO8hUKCHGHXeqrVPZXzueXc3ZSrSN4jFySpFrujFatyK6KS7FPwbd
         AQM+bm6Ndj/UheJDdfT5upi4A+ukWmQJnKpwiLlO9j51hiiM6cqStVBjfMsnxCfgHJWE
         ljq4Hv9Y1ByQgcmhazAOEazTiDNsAW4tDyKkvNHtxx/JnwxRXM+35e/S7+LbmuXyJIJJ
         DrK2uHDLHbZWlxA5sHFzig7bu5Bg1bu14dY1S31dTuySS1Ccz1NcZVdrPPDfT5CjsDkX
         dthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794580160; x=1795184960;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eff/JjwhOv2bXxzs5qei19A6x00WqMi0DUYpqKxITDg=;
        b=JgDYIMlfHM22hsqvphoTQUqCBMO4XqGl8OqLkvg6Tg9p4tPse9x/bZYiTLBGpuRitQ
         dL/V1XzC0v3vIFYwaTH1KUlIzlVHFubQOycumIeZkHUfAH6nsRMxtC5e5YBjFYH51DrM
         yt9pANJJtSqr/YhOdTAf9CShIerD/DV3174a/6P5Abh5PFF5Otd09+Wk6XjzOm4hRgPU
         u6qqy/unTqMnS8d1I2HWu74T2FF0+OjEJWewEMTECwr217kxvNrvbBK3Kz0JtpMu+aY9
         2Dl24pNsCHiC5HS42T1lAxKf+bg333MJhJ6FiccxwuoltqYuNhXq+OS+yrsSmI0D9lmE
         oKCA==
X-Gm-Message-State: APuU4Z8Yvvg98ck6h4TuizUBEvN7efP6SXvzWRuf837tBg253joQy0RG
	fKbbJtQGad02/iW6AoenTDEJk65GosmRV4uD8ike0w17Dkjclb7tNot0McSBODM6hvzJtFJmW1t
	vICq7+krr0TOa/rwdP9aBM5sIqPPSXcThYoHVk3kKdthz2R04uGQTO8zt2g==
X-Gm-Gg: AYBFou3PYtOmgYS5azNTOz8OHKfLpXwkUNAj0WK+jI7VGc0U+ZddL9woP0YH4UIuXdf
	w+qZHAr1ss/TUJ1lkDdzsIPYw3tMtJz3NWY6DrQaQIrbXs+n1s6/tWJPMElV9Lq9ueHRZtHu9a/
	8i78LttPbnlTJ5AaYEJ1cmWdnAAmd/ScIWoux+1kOZf6P7KhCXdBBjANyUKdGzfOlji3y0m0IcU
	kdHlLIlmZL2Z15DcuIM19WB1lSE055+AamSHYOMMGtQcyZpnbd8YGJH+0W5XQtPrJ2fLTj3xxTe
	guQ0w27xKsFoPQlEsTdKyOcPzOacTvyck3OBc3sPm3JzN97hnoSWWLWYtyLVawbmzHucmMt5EoI
	b78oCTZLQsJMPZMlIfbLHADoPVyBZvTHGG4VwfCI5pily7IdnpMzylENg146S1Dy2ZuW/0DdApV
	XAVTUuGWx9LHNcxDNFZIu+iE8A23XEUsWaHbdyb46orIk3z9Eo7bi2fY4=
X-Received: by 2002:a17:906:dc8c:b0:c46:ba0d:3728 with SMTP id
 a640c23a62f3a-c50963cb4aamr236541866b.18.1794580160468; Fri, 13 Nov 2026
 06:29:20 -0800 (PST)
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
 <70526c96c1d0dbcf1f251f3ca40a55ec902cfe6b.1794502890.git.fdmanana@suse.com>
In-Reply-To: <70526c96c1d0dbcf1f251f3ca40a55ec902cfe6b.1794502890.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 13 Nov 2026 15:29:09 +0100
X-Gm-Features: AclHuK8ThKaM-lDPKqtkZIjztxh3RL5yR4DXi3TXzUNnZHee0yESJsi5IOlfDX0
Message-ID: <CAPjX3FekA6cHKqOaR=EDPKo1qPKJ2JbozuZA9X54yehS74E9LA@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Nov 2026 at 18:09, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> We are using a RCU read section but then we call btrfs_find_device() which
> iterates the device lists using a plain list_for_each_entry() and that is
> not safe it can result in loading uninitialized or torn pointers, leading
> to arbitrary memory dereferences, use-after-free conditions, and kernel
> panics.
>
> Update btrfs_find_device() to use list_for_each_entry_rcu().
> We also have manipulations of the devices and seed_list lists that are not
> RCU safe, in btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(),
> btrfs_setup_sprout() and btrfs_rollback_sprout(), so update those places
> to use proper RCU list manipulation variants.
>
> Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
> Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>
> V4: Update stale changelog and fix a use-after-free on a device after
>     removing it (both identified by Sashiko).
>
> V3: Fix some more RCU related issues pointed by Sashiko.
>
> V2: Fix other existing RCU issues pointed by Sashiko.
>
>
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/ioctl.c       |  2 +-
>  fs/btrfs/volumes.c     | 93 +++++++++++++++++++++++++++++++-----------
>  fs/btrfs/volumes.h     |  2 +
>  4 files changed, 73 insertions(+), 26 deletions(-)
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
> index a494c913ad12..b9504b637068 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>         struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>         u64 num_devices;
>         int ret = 0;
> +       bool free_cur_devices = false;
>
>         if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
>                 btrfs_err(fs_info, "device remove not supported on extent tree v2 yet");
> @@ -2483,8 +2484,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>
>         num_devices = btrfs_super_num_devices(fs_info->super_copy) - 1;
>         btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
> +
> +       /*
> +        * This can happen if cur_devices is the private seed devices list.  We
> +        * cannot call close_fs_devices() here because it expects the uuid_mutex
> +        * to be held, but in fact we don't need that for the private
> +        * seed_devices, we can simply decrement cur_devices->opened and then
> +        * remove it from our list and free the fs_devices.
> +        */
> +       if (cur_devices->num_devices == 0) {
> +               list_del_rcu(&cur_devices->seed_list);
> +               ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
> +               cur_devices->opened--;
> +               free_cur_devices = true;
> +       }
> +
>         mutex_unlock(&fs_devices->device_list_mutex);
>
> +       *bdev_file = device->bdev_file;
> +
>         /*
>          * At this point, the device is zero sized and detached from the
>          * devices list.  All that's left is to zero out the old supers and
> @@ -2503,23 +2521,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>                 }
>         }
>
> -       *bdev_file = device->bdev_file;
>         synchronize_rcu();
>         btrfs_free_device(device);
> -
> -       /*
> -        * This can happen if cur_devices is the private seed devices list.  We
> -        * cannot call close_fs_devices() here because it expects the uuid_mutex
> -        * to be held, but in fact we don't need that for the private
> -        * seed_devices, we can simply decrement cur_devices->opened and then
> -        * remove it from our list and free the fs_devices.
> -        */
> -       if (cur_devices->num_devices == 0) {
> -               list_del_init(&cur_devices->seed_list);
> -               ASSERT(cur_devices->opened == 1, "opened=%d", cur_devices->opened);
> -               cur_devices->opened--;
> +       if (free_cur_devices)
>                 free_fs_devices(cur_devices);
> -       }
>
>         return btrfs_commit_transaction(trans);
>
> @@ -2799,7 +2804,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
>         fs_devices->open_devices = 0;
>         fs_devices->missing_devices = 0;
>         fs_devices->rotating = false;
> -       list_add(&seed_devices->seed_list, &fs_devices->seed_list);
> +       list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
>
>         generate_random_uuid(fs_devices->fsid);
>         memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
> @@ -2821,11 +2826,15 @@ static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
>         lockdep_assert_held(&uuid_mutex);
>         lockdep_assert_held(&fs_devices->device_list_mutex);
>
> -       list_del_init(&seed_devices->seed_list);
> -       list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
> -       list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +       list_del_rcu(&seed_devices->seed_list);
> +       /*
> +        * Before splicing seed_devices, update the fs_devices of each seed
> +        * device, otherwise a concurrent RCU reader could get a use-after-free
> +        * on device->fs_devices still pointing to seed_devices.
> +        */
> +       list_for_each_entry(device, &seed_devices->devices, dev_list)
>                 device->fs_devices = fs_devices;
> -       }
> +       list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
>
>         fs_devices->seeding = true;
>         fs_devices->num_devices = seed_devices->num_devices;
> @@ -7549,23 +7558,47 @@ static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
>   * If devid and uuid are both specified, the match must be exact, otherwise
>   * only devid is used.
>   */
> -struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
> -                                      const struct btrfs_dev_lookup_args *args)
> +static struct btrfs_device *btrfs_find_device_int(
> +                                 const struct btrfs_fs_devices *fs_devices,
> +                                 const struct btrfs_dev_lookup_args *args,
> +                                 bool in_rcu)
>  {
>         struct btrfs_device *device;
>         struct btrfs_fs_devices *seed_devs;
> +       /* If !CONFIG_PROVE_RCU_LIST we get variable unused warning. */
> +       bool rcu_cond __maybe_unused;
> +
> +       /*
> +        * We are called in several contextes, sometimes protected by the
> +        * device_list_mutex, by being in an exclusive operation, in a context
> +        * where no concurrency can happen (so without any locking) or while
> +        * under an RCU read section.
> +        */
> +       if (in_rcu) {
> +               /*
> +                * rcu_read_lock_held() always returns true when
> +                * CONFIG_DEBUG_LOCK_ALLOC is not enabled.
> +                */
> +               ASSERT(rcu_read_lock_held());
> +               rcu_cond = false;
> +       } else {
> +               rcu_cond = true;

This is very wrong and dangerous! Hardwiring `true` is just bypassing
the protection.
This really needs to be

rcu_cond = lock_is_held(&fs_devices->device_list_mutex) ||
lock_is_held(&uuid_mutex);

as I suggested before. The API is designed so that you have to
annotate which locks protect the structure outside of RCU. And it's
also a good documentation by itself.

Moreover this monster is not exactly nice. The one-liner I suggested
before looked much cleaner.

--nX

> +       }
>
>         if (dev_args_match_fs_devices(args, fs_devices)) {
> -               list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +               list_for_each_entry_rcu(device, &fs_devices->devices, dev_list,
> +                                       rcu_cond) {
>                         if (dev_args_match_device(args, device))
>                                 return device;
>                 }
>         }
>
> -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> +       list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list,
> +                               rcu_cond) {
>                 if (!dev_args_match_fs_devices(args, seed_devs))
>                         continue;
> -               list_for_each_entry(device, &seed_devs->devices, dev_list) {
> +               list_for_each_entry_rcu(device, &seed_devs->devices, dev_list,
> +                                       rcu_cond) {
>                         if (dev_args_match_device(args, device))
>                                 return device;
>                 }
> @@ -7574,6 +7607,18 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
>         return NULL;
>  }
>
> +struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
> +                                      const struct btrfs_dev_lookup_args *args)
> +{
> +       return btrfs_find_device_int(fs_devices, args, false);
> +}
> +
> +struct btrfs_device *btrfs_find_device_rcu(const struct btrfs_fs_devices *fs_devices,
> +                                          const struct btrfs_dev_lookup_args *args)
> +{
> +       return btrfs_find_device_int(fs_devices, args, true);
> +}
> +
>  static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
>                                             u64 devid, u8 *dev_uuid)
>  {
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
