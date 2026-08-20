Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6B525228C
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787265144; cv=none; b=Gom7GQM7edCwkDfTUb0XKL1yEh4HoYpHQVSGXo6QBpytkQOk6iQY2ZmIL8X+DpnG78I1+NgNrgkH49T6q4oxBGbQuBONQgTtvr27yvbx2Pm8tAXYyli4wcbRQdvag8bEMSM7S/6v0G8hXJf0epVcqrZzieXGffbLEYJ8Qxen1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787265144; c=relaxed/simple;
	bh=WkFAk0oizc4ksAiMTfaFldvEO3cUVPI25pyt9o9RwTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tDa64/cZlC13ush8YOxpjOvDb9l069aCCNS2gnWtMeCYxxuF/1Js/Ko7Z586TfPBzf0c3gm+eC9mjtPX3dmEY69kiQfVg7IiDHoFUML8iSyJGj9Fr51G0rERdhXz+hgXom/KiPlFn8lDlNsAz6EdQ0U6Vr1Bew/moRAA7a1Y9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZE4cd0a1; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZE4cd0a1"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-499acf0fb55so1995215e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 15:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787265140; x=1787869940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DhEm7/W6oHaQeNkFFrItHdLxIfQKw7WVZcWqUkkTfhg=;
        b=ZE4cd0a1fMC0sn3TbzkwUPOS1BkOicu7l7rgzJPdoHDVLV9Bzprc1A7gBrWUoiqE1g
         pXKsd6s2aRgs5NTld9ag2cybO+RFxH3VuB+0Z42KtcLjzxoNADYaf2gUmG/khcGZcc9s
         lR1mBg0TCaTRNf6w/3u3QauMCweW2CbbWYtRVSpg79cihbLYUUZTJ8yACHGqAcoVEoX0
         hTs+eBhL+T+m248biPrCgDySfNuvZvROit5Ou9vQ3LMSIYoiLo+Qvie6tfITp4yZ5hR/
         TVhivfjtc6rqm9bcLDADdjQDC2ncfGGx/4frMuTzcG/+U9MXFcL1HZymDtp2DeynEJ9V
         79qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787265140; x=1787869940;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DhEm7/W6oHaQeNkFFrItHdLxIfQKw7WVZcWqUkkTfhg=;
        b=HJPEsJZHVH8w5McHhvkvvzYmmLHbSwtyG/v+WyhvyhGqvuqRh2CTftvzuvSjJy3hVs
         UFqu2Iz1w1HbG17/bxfiQpskF4Hn8pKq+KlTmw+aF67XqNWUkxOBdIhpmydMm9Gp9lYk
         /f97j/UPpobqrsnn4T4Pa2FShORlzP+cB6gBwqBikMkWY7J99GXOPVrVYqHvd4IUwPy7
         6h/TkFcMiRhuUKzCKdl+7m0GjzFlugwhfKP2wrfr8U/S+7ObF0u12heAJWntCmazPr2D
         zEDpp4e516QDDiUDK2L4c6UiNU8ZlUf48akDRkCRWYjTA6XoI6m/H/QUH2jjYT5s6wMI
         D2JQ==
X-Forwarded-Encrypted: i=1; AHgh+RoD9iaFCT4huB7EfPAb8LzXjulb5LSOP9GQImC2+8LY8morjyxlmZBoOOgX9pLsaXeaaJ73hgEWXOJ01Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCZ4NvHbvT5QkdbNYlB+oxBV06n76GKZZ28cgv7yTjAH+7Eu3b
	Ukt7/PSvtWU55L1FSWoBEu+TDMXi/GUilpTUdCh6sVTOuy7T/QI7GIiWNekLi7seQ/GfiOJvNME
	S458aLLs=
X-Gm-Gg: AR+sD11R8HpbSB0OqQ8pCOnA/3dacvmvLwwIIxGs072j1ov8r8XObuFEQISuLern2zy
	MnV7aiy/t+BcNCjUBC/FUAB0AD4lljvz+J+VNnBl0fOjhzMqqGEJCasLo/vMBqzVa3vkVW7KzgC
	jX++DKV/bCeR0zaqk/WyQ0p7hbQVaKx4JsxrPp4VBJy3acxhGzFYrNv5iYdWvoL1YhzII5GPdnq
	abjtkfkv5Y+PV5aiqyKFa2TWTh5VUJtnjMvqWXVjpAihihI5kfnAAzg4tPCx1woCUbu24q0AtqG
	qc9e89HgtNIEufKeeQI0PtIxmEBGtE8QII3J9pLf0jKGklro+nr+tCyU1i+ys91pIHocHeMczgz
	kcQzsb/oTmHcFh/0Q8lmsBX66D2AuTNBTvJAQqeXkEVQr0UbPlkJJ7CJS9LeGvkx93DZBZBY153
	qAihKynTOAcyf+2uH7q6NFlOEUjwCCGG1NRUM67VALG/eqc57QPA2yIEpmFqDq13O9
X-Received: by 2002:a05:600c:c4a6:b0:499:726a:a017 with SMTP id 5b1f17b1804b1-499b82f4090mr35847165e9.1.1787265140022;
        Thu, 20 Aug 2026 15:32:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ae48761sm18236792c88.12.2026.08.20.15.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 15:32:19 -0700 (PDT)
Message-ID: <2252e770-a254-4971-9acc-c3768f3bb119@suse.com>
Date: Fri, 21 Aug 2026 08:02:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: drain sysfs callbacks before stopping transaction
 kthread
To: Jiacheng Xu <stitch@zju.edu.cn>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20b09e24.16b27.1a01f23ee08.Coremail.stitch@zju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20b09e24.16b27.1a01f23ee08.Coremail.stitch@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/20 21:57, Jiacheng Xu 写道:
> btrfs_label_store() and btrfs_feature_attr_store() wake up the
> transaction kthread through fs_info->transaction_kthread.
> 
> During filesystem teardown, close_ctree() stops the transaction kthread
> before removing the mounted filesystem's sysfs attributes. A concurrent
> sysfs write can therefore enter one of these callbacks after the kthread
> has been stopped and pass an invalid task pointer to wake_up_process().
> 
> This results in a concurrent null-pointer dereference in
> try_to_wake_up(). The scheduler is not the root cause; the invalid
> transaction kthread pointer is used by a Btrfs sysfs callback during
> teardown.
> 
> Split mounted sysfs cleanup into two stages. Remove attributes which may
> have store callbacks before stopping the transaction kthread. The
> remaining sysfs kobjects are removed at the original teardown point,
> after the kthread has been stopped.

Why not just simpliy reject sysfs write operations when the fs has 
CLOSING_START or without FS_OPEN flags?

> 
> Apply the same ordering to the open_ctree() failure path when the
> transaction kthread has already been created.
> 
> Tested-by: Jiacheng Xu <stitch@zju.edu.cn>
> Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
> ---
> fs/btrfs/disk-io.c | 16 ++++++++++++++--
> fs/btrfs/sysfs.c   | 26 +++++++++++++++++++++-----
> fs/btrfs/sysfs.h   |  3 +++
> 3 files changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2f1666d9544e..4f5bcc576dc6 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3363,6 +3363,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>        struct btrfs_root *tree_root;
>        struct btrfs_root *chunk_root;
>        struct btrfs_root *remap_root;
> +     bool sysfs_attrs_removed = false;
>        int ret;
>        int level;
> 
> @@ -3780,6 +3781,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
> fail_qgroup:
>        btrfs_free_qgroup_config(fs_info);
> fail_trans_kthread:
> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
> +     sysfs_attrs_removed = true;
> +
>        kthread_stop(fs_info->transaction_kthread);
>        btrfs_cleanup_transaction(fs_info);
>        btrfs_free_fs_roots(fs_info);
> @@ -3793,7 +3797,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>        filemap_write_and_wait(fs_info->btree_inode->i_mapping);
> 
> fail_sysfs:
> -     btrfs_sysfs_remove_mounted(fs_info);
> +     if (!sysfs_attrs_removed)
> +             btrfs_sysfs_remove_mounted_attrs(fs_info);
> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
> 
> fail_fsdev_sysfs:
>        btrfs_sysfs_remove_fsid(fs_info->fs_devices);
> @@ -4318,6 +4324,9 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
> 
>        set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> 
> +     /* Drain sysfs callbacks before stopping the transaction kthread. */
> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
> +
>        /*
>        * If we had UNFINISHED_DROPS we could still be processing them, so
>        * clear that bit and wake up relocation so it can stop.
> @@ -4538,7 +4547,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>                          percpu_counter_sum(&fs_info->ordered_bytes));
> 
> -     btrfs_sysfs_remove_mounted(fs_info);
> +     btrfs_sysfs_remove_mounted_kobjects(fs_info);
>        btrfs_sysfs_remove_fsid(fs_info->fs_devices);
> 
>        btrfs_put_block_group_cache(fs_info);
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 0d14570c8bc2..d90d76a152e9 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1707,11 +1707,23 @@ static void btrfs_sysfs_remove_fs_devices(struct btrfs_fs_devices *fs_devices)
>        }
> }
> 
> -void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
> +/*
> + * Remove attributes which may have store callbacks. kernfs waits for active
> + * callbacks during removal, so this must be done before stopping any kthread
> + * which can be woken up by those callbacks.
> + */
> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info)
> {
>        struct kobject *fsid_kobj = &fs_info->fs_devices->fsid_kobj;
> 
> -     sysfs_remove_link(fsid_kobj, "bdi");
> +     addrm_unknown_feature_attrs(fs_info, false);
> +     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
> +     sysfs_remove_files(fsid_kobj, btrfs_attrs);
> +}
> +
> +static void btrfs_sysfs_remove_mounted_dirs(struct btrfs_fs_info *fs_info)
> +{
> +     sysfs_remove_link(&fs_info->fs_devices->fsid_kobj, "bdi");
> 
>        if (fs_info->space_info_kobj) {
>              sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
> @@ -1730,9 +1742,18 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>              kobject_put(fs_info->debug_kobj);
>        }
> #endif
> -     addrm_unknown_feature_attrs(fs_info, false);
> -     sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
> -     sysfs_remove_files(fsid_kobj, btrfs_attrs);
> +}
> +
> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info)
> +{
> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
> +     btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
> +}
> +
> +void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
> +{
> +     btrfs_sysfs_remove_mounted_dirs(fs_info);
> +     btrfs_sysfs_remove_mounted_attrs(fs_info);
>        btrfs_sysfs_remove_fs_devices(fs_info->fs_devices);
> }
> 
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index 05498e5346c3..0d008fc8f1b8 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -35,6 +35,9 @@ void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action)
> int __init btrfs_init_sysfs(void);
> void __cold btrfs_exit_sysfs(void);
> int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
> +void btrfs_sysfs_remove_mounted_attrs(struct btrfs_fs_info *fs_info);
> +void btrfs_sysfs_remove_mounted_kobjects(struct btrfs_fs_info *fs_info);
> void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
> void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache);
> int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);

