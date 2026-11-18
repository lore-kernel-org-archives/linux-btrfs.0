Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794979243;
	b=uURmVZr/FPzotpxSLo1/VoFV+CypbLDzbrg80WjajM5/dHWJdXw7l88+Fg4gZ8sW3HFV
	 CBfwSaenKGW18maXUsnVfGc7BjVhZ/Dz1FlWpU89T48ZfZALolHKatsSznDhjVswfOtUW
	 2Ees/HMLixAQF2SwEDJJirG4nimZFE2mWTsKrL82CngYrItE2oYw79AyQ5rroY9rAlutl
	 Me4RYXkZDd3DOgzqJGELYQ06CzYRvSLdr8joyuTWuKphD58tZuz/p8KKTeTUsDUuOlTe6
	 Wov0TOzjY2GZVg31UXUUhqLZCbP/r3JKqWeqyoTngt9LDNA5N5GWbWw5kr/SzQioNJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794979243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=OYLTPcGbhG7sNZf8T8iR1UPBDlqo0wI/IsSoCvdujjE=;
	b=Azc/TK5O2/53A9cT2bSmHVmTsz/GVl6Epm1zlzRI9OgLY1AGYIe2HWtrhKVbpfA08yMU
	 51GcYMkbYy0dg7AM7CIzfYL+ryMh5cBaGWfAJ64VG0PoFF2xQ/S0nr3wTiRTDCTsj2S6j
	 CVGN4roAyQZihGcNeara9J6tjvXivUIapUiuOEVSpFYDYlYAGArL6QipZLx8Hbyf00aOI
	 onHXbFfD4HyEVfhsGuTUPS4WvearfRHB6/b5qGh8A6nIE4svbYAu1vyU2mrV+c+R4PoyS
	 4l0tKnWNRei0HB1tGX+Qaxhgxc+VQzZeYXYS2X53mTIFuIttr2T7QGpR3gfkXs/+enw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=He4nXpaB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4DE606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 05:20:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D4DE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=He4nXpaB
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a5506f09f5so301987f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:20:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794979241; cv=none;
        d=google.com; s=arc-20260327;
        b=CVYngQKvRBddKzKz7aKjLvf6TVum/Pom/S6wh/fCVafU0tyVBuEnAyN1GsFnX4sm8A
         b4r3lSoH57jsDIBOd8iQ2PoQbDDRNK/QPqJtgyEbDVxpmisJKcNfkllUzzyJo8N5f56K
         qLIB3fVwfTfIG/Uc2iUbnmUG/iPR6Zg2MrG8blWTDcomATZtOkG+NBGl+r15D5aXmCoB
         AVzdMJ7Xo7/hHKqy7qOseYqX6Kr7m9MSBwlCzCruA3gHlm7QEva3OGLgyXeAogfKjdH3
         mSjVY/kReu+biNEuthR9TkTL9AfKXd1ox7l31MrPUSBawAi9ARs77rtYD9lvZqh7cF+Q
         AyLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OYLTPcGbhG7sNZf8T8iR1UPBDlqo0wI/IsSoCvdujjE=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=cGSkVf48Rh52fbTEWIw1a2+l89ITC4JZ7diAgiDYBqg8V0QtZbSG68hmOzWJRGw1uX
         SQxX3W4Pp0Qv5/ouRoywG8IZWPI6D34M51mCdEWPV2jwT9wHtHr5LZlFNk4j4DBODcn5
         4HG/WaoM+yF27g89/cfIPMFcLjSn+1TrAPhWOiOlMZ4sY1Exnr+oWBySz50TlftYkZbQ
         CVlsscQ4zw7w0MVVA+uJFV3a0Zjt1cmLcdKuS585AH8G3TYnVty4csKKaajoB7l7K4ff
         70LtMOq6b5ZWeDWJQ3O4n0NObgW1O1Cwalt2hWsFe0OOLH0EhLLhIsNUNm+svp9QA80X
         AskA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794979241; x=1795584041; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OYLTPcGbhG7sNZf8T8iR1UPBDlqo0wI/IsSoCvdujjE=;
        b=He4nXpaBNr+ExxBrXRbFN4JsKboCXd5sOghL9ahAVKT0sZWGfvtIYN7EULJVRTE/Py
         V9GT3wYdWXAjTTM6g9E4d1y8mW28CIJ1pBvS6SPStDDTDQyGp3uxGFS5Wb/vJVH11xGH
         xNIj9tWEnsCrBbpqKuerf5yJspugF53bsmh6lJT/78M2pWxzxthmZMcZU3Wrmgzx/lQ4
         R5NIJw9IeTv2B7nY/htjzxB+BVWdHYYHaZ2sCU+fccxFSHDfhduhDhtX5xlVUYY+OO9j
         e7mMp+lIgXAp8qvHqr64hgM88EZ2V7d3PbhVMthgqk8rA8Eo/4Du2DR0bS8H5Nrjs6KW
         5M6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794979241; x=1795584041;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OYLTPcGbhG7sNZf8T8iR1UPBDlqo0wI/IsSoCvdujjE=;
        b=n4+cbamPXyc6MbCxEQ4uLVD8NB5GsZ86dtWfxMIyS6vARJgTEcDXAW0BboU6ErA1HW
         ItMcc2GB9WArqJb9NRnMlkjKqJnzliowF/Hj1YCwQv5aBQh7nfM6GKbWLaQv8Ft7Rjbt
         Pfjn0aQpHNNyz3VMYYTQUYSfRKfEuAs/K8vfU7HYPJcyHQZKPxJ1CIHh+CeEfuxoxApe
         9/kXpxe1j/x0K+RtuDffSuzHnYvTX+FetvtIu74nlj4bOHCx9ukhhvV/4k1rUT0UAgOB
         D6iZH43itMj2usbksqzhEN5L48dN3NF3wtmXDikjt3+zqeCH+sNe+v/L/uSYYQg9ERsp
         Mj2A==
X-Gm-Message-State: APuU4Z/gTf6nx84pnbenBa13K5ugrU4H925YlzjNrA0+XyGIgVO9Euyu
	zCqQVT38XEDzWVfWZhrDMklmp0EEZOP6ZwNVL6MU3iT4tjxnxuv2HtgwHubvgffewclOQsEtYbh
	3/qSEFCsAOp9ARNK2wnpm4Vfjj2P7moNHdr7wSnE6mm8hy+PHQqJerI4=
X-Gm-Gg: AZFdTZd0UsJKiJ2wEkljvXF+fvUizUdIPMcon+XiA9FMe4DPYNW6zSOCLnzDZa9ZZkk
	UzU9At+kT3I/amKgQTv6D+Xb2KLkmPUy0sK4dC7gwusDL/355s38Pi0g9SPd60pOCj+eS7+4pai
	bewiOI21V7PELXP8RknEKlJM/IdzXGHi1/mTbS2VIUoeqkWCcFBJ9sr1kQB0cg5WNZ+pIrREubG
	f55WCtRt4m4j/p9yDg3ECW5zXtYqYPyAyAeZrR+m79muygaBnD23rEfJY975RwAf0hHw7IJa0ka
	uvvbi75kx8aP8VbT8gx62BDNNUhWUCChbpgnk3c6xfsbg2VSPpVw9HYxXG4y7kUpp78nIBYrauk
	YsN0Go+ybS9kMoEK7vbBzF/g/Kb5Y9vWBXsJjA8tManDgmsiuhSiYr7D/gIuP4KW0VjSXh5Tje8
	BmbRXenzaFuxUEimGmGGQGthsDWHD/yCqIZQ==
X-Received: by 2002:a05:6000:1a8d:b0:48e:412:3813 with SMTP id
 ffacd0b85a97d-4a637f6367amr3301939f8f.20.1794979240896; Tue, 17 Nov 2026
 21:20:40 -0800 (PST)
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
 <036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com>
In-Reply-To: <036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Nov 2026 06:20:29 +0100
X-Gm-Features: Aa3M54qgbAlBbvrDHZlLRhJatPWYIr75lMozER2g5WYGO0_4WSAxO-MAr8Z4I3U
Message-ID: <CAPjX3Fea2P=2QbmOpgF_Yvyt1rtkcqvkFExNShzQ-=kYs1M2Bw@mail.gmail.com>
Subject: Re: [PATCH v5] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Nov 2026 at 18:10, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> We are using a RCU read section but then we call btrfs_find_device() which
> iterates the device lists using a plain list_for_each_entry() and that is
> not safe it can result in loading uninitialized or torn pointers, leading
> to arbitrary memory dereferences, use-after-free conditions, and kernel
> panics.
>
> Update btrfs_find_device() to use list_for_each_entry_rcu() and to always
> define a RCU read section, since we have several callers that don't lock
> the device_list_mutex before calling it, either because they are within
> an exclusive operation or because they are in a context where no
> concurrency can happen (like during mount for example).
>
> We also have manipulations of the devices lists that are not RCU safe, in
> btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(), btrfs_setup_sprout()
> and btrfs_rollback_sprout(), so update those places to use proper RCU list
> manipulation variants.
>
> Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f6070f
> Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

This one looks good to me.

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>
> V5: Simplify things by always creating a RCU read section within
>     btrfs_find_device(), as many callers don't lock device_list_mutex.
>
> V4: Update stale changelog and fix a use-after-free on a device after
>     removing it (both identified by Sashiko).
>
> V3: Fix some more RCU related issues pointed by Sashiko.
>
> V2: Fix other existing RCU issues pointed by Sashiko.
>
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/volumes.c     | 69 +++++++++++++++++++++++++++---------------
>  2 files changed, 46 insertions(+), 25 deletions(-)
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
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a494c913ad12..f128115a3a3b 100644
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
> @@ -7555,21 +7564,33 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
>         struct btrfs_device *device;
>         struct btrfs_fs_devices *seed_devs;
>
> +       /*
> +        * In many cases we are called under the protection of
> +        * fs_devices->device_list_mutex, in others we are not, so always use a
> +        * RCU read section (if a caller needs a wider RCU read section, nesting
> +        * RCU sections works fine).
> +        */
> +       rcu_read_lock();
>         if (dev_args_match_fs_devices(args, fs_devices)) {
> -               list_for_each_entry(device, &fs_devices->devices, dev_list) {
> -                       if (dev_args_match_device(args, device))
> +               list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
> +                       if (dev_args_match_device(args, device)) {
> +                               rcu_read_unlock();
>                                 return device;
> +                       }
>                 }
>         }
>
> -       list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> +       list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list) {
>                 if (!dev_args_match_fs_devices(args, seed_devs))
>                         continue;
> -               list_for_each_entry(device, &seed_devs->devices, dev_list) {
> -                       if (dev_args_match_device(args, device))
> +               list_for_each_entry_rcu(device, &seed_devs->devices, dev_list) {
> +                       if (dev_args_match_device(args, device)) {
> +                               rcu_read_unlock();
>                                 return device;
> +                       }
>                 }
>         }
> +       rcu_read_unlock();
>
>         return NULL;
>  }
> --
> 2.53.0
>
>
