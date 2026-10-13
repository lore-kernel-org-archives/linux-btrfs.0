Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087984DDB5F
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791890001; cv=pass; b=RLOPuJTZXC/G/ieHzrmvLDRQ4pVU6FknvocUcaptEJr8L5Ubz16GnaGaSprgSnerdHWuOC2BQ/WEvPun54kEmsz28WJliMuAPjejNt3tkaX9adHG8M+WvwUWUcNN3AZ+9t9kPxd5wtttqrtdEeTby+PRBJyYKLKDKj8z3C6ArlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791890001; c=relaxed/simple;
	bh=W6WTGsXRBI8mYN8L0qSr5GQI9BhXSERGgvRH9PMEXzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZRMT3KiYgG9fgmcxzideRy+yF7/twDGA7gD9fAiBBM4Fth2hoHADmltxGjWgoLNaV4Md7Y8qcK/BawNsZbcQrMY4JEQWoq+se+malYI8f5JslvOGdjxxY7mG8Bxv3bYpoNWrhq/kQYRaU4ADi3zXCzxdRJTRZOAbCzsPsbD2n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IDIGWwIa; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IDIGWwIa"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1880e1bf1so26075255e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 04:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791889998; cv=none;
        d=google.com; s=arc-20260327;
        b=N9CfPzdZZ4VkgUL3rjVmyn2TcHpQyxIIrb2hyqQ9igz9wqeU2MLam80XRUlCA0SsdF
         CNlJerxXwPRLeNEo6ROPdyROTBUrwD/v5UXEhA5PnjMcOSp1z0fT52L9T3+YViiUSWZx
         +DI1xEd3sxnmNrVSu+7/TjcANKljWnL/HFsU4RENQkb5MpigsZo4La9uy6hkugkb00Ls
         dATAkEiJ5Y5yta+G4ckArCiICkZZb4Ctcr4DDj9tuy7HGI6ABsvNFAz12wG3xTjQjmGY
         KPmieL9n+Gr3z29IBqx6UWJ643+M+DrorGQkLE2BaxxTZUCIeQ4VktENXOtx8MDLp7oL
         cMjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0al2L/zJTanu+94NFMRYKtJkCF8mmt8cwR1wMSTnrxE=;
        fh=qA3eo+mcoFKB9z0T9fN/nts7xxQ/fcmyi4rWardHwoI=;
        b=KdVZUtSSZ8sNNEK/2cUzfGvhPZvBH/Wo+Fwu4Th47fVtBes1dPImRtKnOcEUshqWVH
         T6w9SYuZRzA6xqJT9yqadUikdsPGvT+Hz69BFe9PdxiKdjbZZ2ij/HbAPfb0N+97h4oV
         xt4vLfbNMZyq9E2GCeYOVUEIlWJQ1HdvauniL4gw5x+TU2pFrblSRbAEmJrRD9RVU4CB
         Ergr57zXF7QKKzWHOlSAT+RtCKlZVosCdUksws0z6e2Kiqf2+UWhZOy0zfduKIDcZEiJ
         4Z6sA3YPJjPMUIurvx116pRJ78tN1F2wMZ9gjbWb2rU5Sp4x6xpF3SWCmeXEfQknDA1s
         FcLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791889998; x=1792494798; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0al2L/zJTanu+94NFMRYKtJkCF8mmt8cwR1wMSTnrxE=;
        b=IDIGWwIaut2bLfX+1Caef8inF88Pe78St8VQXsVqGztxP7FsItbyyEyMA1bU1h0LMT
         8cWmtJaHOnOfTNtDToQaepRJhOE1Hw0Cs44t6osAKR5r5XtWhfmnxM0DOQHiFeUg9hk9
         ZPdADdd/gidkGqSc6TLzBRzb19hZpVvSE4UqvSvqdhQN7yjSBSscYk0ufdn20XfDrKg8
         7oPB2JTvaPM9yTjcjtPXbB0loYtY8qt3Tbyjjys4hSQbFuy29Ckkbyb4TJCCgWAKw0x7
         MGNpEi19nI3TqrXspZSVMx3+JeTmv1QoYUxRHdbvME5KdJ3mKWakJrxM/m5BfJDJAbxz
         wEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791889998; x=1792494798;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0al2L/zJTanu+94NFMRYKtJkCF8mmt8cwR1wMSTnrxE=;
        b=gI062TGP2V5OG9ty2moJAiOIx/QLAhds/6nwZG2lkd3H+I99d5EMTfAGiCdM1CB+ZL
         JY0FixLMVuzgSZELP9Zb+y9qD2NYxOJR6JSAXG9KJYjORJuO20LNx62Wb4/MNPbQKWCR
         pGSGmwR6WYwti5oH0gKL05nDP2x41cguKlc9kdMmB2lMPrc3UYp+kY9j7kRThfT3V+KI
         EtGf6gwSngg/C2G5RfQCzHz39dJvDWBSI4petplHxzHbZee135KBoB44rQyWDWwSWjzo
         RYsVcDgN8a1PLz3AX/iZvQB4jBok0KeGFRG8FcNestmFPvg6UMgd0Mf1Y++9TLz43R1q
         1C9g==
X-Forwarded-Encrypted: i=1; AKwUvBwO1Nw10u75tz2XEsDvrMG9OulnSg5oGeM8miNgOsO3bPO7eTwpHANCGwVMA/EeEzmhm5ScfPzRLQMU9g==@vger.kernel.org
X-Gm-Message-State: AFq9FYIWwuue0nrxB/FR+fLgPkq+IQ0GVZ/3R2on2hBPwU04XPnAFbuy
	Yafp8LBkqJIbwfxywrHUevLN0d1/ds/8rwqY3o4AYwW9WyoyYrypAylvcgVynbusTKvora+PDlv
	Uzxoz/QczrHYPCNojNM7ExYa+fhBsyf2yftKjXbSzsBJ8vHcLqrlgTOtGsw==
X-Gm-Gg: AYBFou0K47ulRhASeo0PGbPAPX/1n5KeE12LvIcOv/PbcUBbwwnPuJU/5YbtlS/osc/
	dJ/brmUS1e7BesvcSsHBGex36wGasBdXoEgM/yjgnqSSkqBRML6XFhE18ciKOgjeNLcFtaubbS7
	ZMkWNC5Hu6TUld+s+OXZJo0ezwGDwzbbZ7BoY9CiaaDcVjDiikeTiL1BGJjat9AOCbO0SpLFmLR
	g7UfSW7EuL/a92GcF689DuRB5FE3oHuFq/XXqD3IodypGBYmpLSyncP+W26o0hqH7SEup8LdPVN
	sPN4MdA00TdXImmLpEUKcSgjWEabeKfbrh5/VfbJ24QVl8U1RPmKKxoh765uddy+gjDHJTGAIVC
	Ouhukk7CBQA1789XS4r1LxfYDPfVXy6GjmqcVO0OZ7ULdtmFnEQdFNA==
X-Received: by 2002:a05:600c:6099:b0:4a0:1feb:de6a with SMTP id
 5b1f17b1804b1-4a18e4e7a85mr231148915e9.30.1791889998109; Tue, 13 Oct 2026
 04:13:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com> <20261007160349.22411-1-adarshdas950@gmail.com>
In-Reply-To: <20261007160349.22411-1-adarshdas950@gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 13 Oct 2026 13:13:06 +0200
X-Gm-Features: AclHuK8-yEscoTG0Qgn4MHnDQBj5lanM9_dYA2t6goTepP0TOEot4V9lOrBTODE
Message-ID: <CAPjX3Fd-MEY5mMk9eu_3ukhZ7yixhWSqECEALCAVFHA0P6HYDg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: unwind device add when sysfs registration fails
To: Adarsh Das <adarshdas950@gmail.com>
Cc: johannes.thumshirn@wdc.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 18:04, Adarsh Das <adarshdas950@gmail.com> wrote:
> btrfs_init_new_device() ignored the return value of
> btrfs_sysfs_add_device(). When sysfs link creation failed (e.g. -EEXIST),
> the add path continued, aborted the transaction with the same errno, and
> tripped WARN_ON(btrfs_abort_should_print_stack()) while leaving the device
> half-registered in memory.
>
> Check the return value and unwind when registration fails, without
> aborting the filesystem for errnos like -EEXIST. If add failed before
> anything was published in sysfs, tear down the in-memory device state only
> and do not call btrfs_sysfs_remove_device(). When the block-device link
> was created but devid kobject registration fails, drop the link inside
> btrfs_sysfs_add_device() before returning the error.
>
> Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/6a791c94.01d0871a.3a0d52.0099.GAE@google.com
> Tested-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
> Assisted-by: LLM
> Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
> ---
> v2:
>  - Unwind without sysfs remove when add failed (review on v1)
>  - Roll back block-device link if devid kobject add fails
> v1: https://lore.kernel.org/all/20261003111951.24527-1-adarshdas950@gmail.com/
> ---
>  fs/btrfs/sysfs.c   | 3 +++
>  fs/btrfs/volumes.c | 7 ++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 39cb01ee441a..2f034689e71b 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -2165,6 +2165,9 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
>         ret = kobject_init_and_add(&device->devid_kobj, &devid_ktype,
>                                    devinfo_kobj, "%llu", device->devid);
>         if (ret) {
> +               if (device->bdev)
> +                       sysfs_remove_link(devices_kobj,
> +                                         bdev_kobj(device->bdev)->name);
>                 kobject_put(&device->devid_kobj);
>                 btrfs_warn(device->fs_info,
>                            "devinfo init for devid %llu failed: %d",
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5d4536..56b38f012093 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3066,7 +3066,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>         mutex_unlock(&fs_info->chunk_mutex);
>
>         /* Add sysfs device entry */
> -       btrfs_sysfs_add_device(device);
> +       ret = btrfs_sysfs_add_device(device);
> +       if (ret) {
> +               mutex_unlock(&fs_devices->device_list_mutex);
> +               goto error_unwind_device;
> +       }
>
>         mutex_unlock(&fs_devices->device_list_mutex);
>
> @@ -3147,6 +3151,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>
>  error_sysfs:
>         btrfs_sysfs_remove_device(device);
> +error_unwind_device:
>         mutex_lock(&fs_info->fs_devices->device_list_mutex);
>         if (seeding_dev)
>                 btrfs_assign_next_active_device(device, seed_devices->latest_dev);

I'm wondering why not this?:

@@ -3066,7 +3066,9 @@ int btrfs_init_new_device(struct btrfs_fs_info
*fs_info, const char *device_path
        mutex_unlock(&fs_info->chunk_mutex);

        /* Add sysfs device entry */
-       btrfs_sysfs_add_device(device);
+       ret = btrfs_sysfs_add_device(device);
+       if (ret)
+               goto error_device;

        mutex_unlock(&fs_devices->device_list_mutex);

@@ -3148,6 +3150,7 @@ int btrfs_init_new_device(struct btrfs_fs_info
*fs_info, const char *device_path
 error_sysfs:
        btrfs_sysfs_remove_device(device);
        mutex_lock(&fs_info->fs_devices->device_list_mutex);
+error_device:
        mutex_lock(&fs_info->chunk_mutex);
        list_del_rcu(&device->dev_list);
        list_del(&device->dev_alloc_list);

--nX
