Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0242AE78
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 07:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774767809; cv=none; b=TsUXDay4YFWaRdZmBaPQ1itCrI6r0zhn3mum8TDoQE+ZaWqhLqIcLIjfFjl+qN8LHF9tZqiHat+CAG+bIMGiDeTmGCs3r0xPoPA+dxgEyQmIAaIlNkUDZyp7T8sSTqayx3IU9sI9RqfEh5fizSf0GEauw+XeQXFpTAxgIkFNY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774767809; c=relaxed/simple;
	bh=3HUKxSM6oaRr2TbspgDlR9M/W9dikUcCl+eSiHgmpGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IM7GTvmiw9NiarOTM6MOvdGSN227kuhDJmBM67fgryBu2QdGPTZvVSyxbt04DuMxkzizWiGSmEX8PnCiVIzi74g5uYVz+ytrRTKUdCq/3R2ebzkUJRX6Z0/t5Kvibee839veBsADavm8w1sO2uUcAlTzQrGhkUn4tFCjXt5BlT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fl/9441y; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fl/9441y"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-486fe655187so43433225e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 00:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774767806; x=1775372606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ThGTNLneGLxpxsZjLzURDO+LTdSj52Hz0aeufftXRBI=;
        b=fl/9441yX/QRPV+E0LHqeBDL3KHouoxh7p4ZZV3uJTODIisXT8PfbDZt2HlyArsuVn
         t2NgWBIHDWp01R99EF2Q+tvDAOvrqYfL0VE2xuTzl5D9R/nBgTstTheVWpJ5qfmazdhY
         EtFN9EPJ6EIlqv0ZQaW4+IMbcJgJF8lWyDengUn8J2e4E4KyorwI8EQ5L5vXxhgYhuU/
         TA9Nm7zq6OlyDXiaVpzj+RrFs2HCzZin4G0FCXym8eelPcYDYAa8KzWgQi+2Q0Kmv9y0
         a/Ecfgx1R2ClTWXOM85ZPstkeM8ZLdgUCQoDw1LCejvhQOXp6He8msCiLub9WcpLKu/z
         cwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774767806; x=1775372606;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThGTNLneGLxpxsZjLzURDO+LTdSj52Hz0aeufftXRBI=;
        b=OU6XFbGMvfq7oAVM9Nrz/ve7QVqNfqGEtqArXPt6rTXe7eDbHxl1QgQIbNRzzCrLi9
         9DxvXMQLHcnZVeESv22GAa/lgvJPttOH8Bxov8zBeftLuYyZNAJioSwRwnpBrRFoKN9S
         ySN4Bmp60lIPj2iwqeRsJ9secNpcK97SGeMjmPsysnA/RaHEJvxmHvjIs2TK88ZENauG
         +n62CmOxViV5vu2yCmPvtyR7E4YmsHG8p8Xve2y+At/5cNxc/CtXCDnT9Df76QNgPsiI
         8J17BWS8yzh70J9RCyNp136+iYrVnydzBmlaGvLcfCACWCJSYECnx795rA4stbf+QQnP
         ZKFg==
X-Forwarded-Encrypted: i=1; AJvYcCVh1i4WDHH44dFU8DOjBKIThCBKoHb4y8fgQ5hS2WeU6PKw49A1UQAS3N2wfrgCkvEj9IFONwr1UAfLIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYEOjW+1lG33xvgdzHuqsczNOWwOzXdoZ6UFAniC3AGKI8ReJB
	pDFYhi7bbrYRxFPlNPX9OQlt/EV4Dj45kLkKa8UPiplxcFz3d56SlWMnT9vbrEnlzXw=
X-Gm-Gg: ATEYQzy/Oi8TZWA32Gyj414cNiZOEV1ayQ8QpAiqT3uUJE+mroiZUcC+gmg1f+NDu6I
	MSD9yzeVyPFJDNNaYZFOlOX1XP7FzHHhQJvfHNZPJBRfm94DAig7NPxTn8nVn8RpIacWWAWl/2K
	/LkKW75a+dqvBBvmiM3P9YGGA73C3JZLdA54vfihajfGOZTdD5gy+80DSo9C2bs9p5T2pSZiPRQ
	+CagtsfGRGT9F3ajhjqBUGpiOQZf/X5//qXeJi9uIfoxHEBF7d5xIXD+pfuG1pMXsOy+NGwBFHI
	tJI1PfR431tmhK6Z6rmGY9lzlcVepH5q4mdaknw19fjUMHUWnJWrNqBQTjBRsepvt9j92GAAOQ6
	NbHhOqTtduc1+Wx0OMPpX2GQ7tunXdm8HypW8JzpP6gwniMWEihy+CdehohnYS14LwBXjO+EdBF
	8Esp5vJOvYG78c5cs7vfDMjjY9ceNHmu9X1nMEsuxGfOYxGqD3IiMQOGoLHeQYww==
X-Received: by 2002:a05:600d:8451:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-48727d4596dmr120201885e9.3.1774767805865;
        Sun, 29 Mar 2026 00:03:25 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916bd67dsm3129767a12.3.2026.03.29.00.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 00:03:24 -0700 (PDT)
Message-ID: <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com>
Date: Sun, 29 Mar 2026 17:33:19 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260329063417.642647-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/29 17:01, Teng Liu 写道:
> When open_ctree() fails during btrfs_read_chunk_tree(), readahead BIOs
> submitted by readahead_tree_node_children() may still be in flight. The
> error path frees fs_info without waiting for these BIOs to complete.
> When a readahead BIO later completes, btrfs_simple_end_io() calls
> btrfs_bio_counter_dec() which accesses the already-freed
> fs_info->dev_replace.bio_counter, causing a use-after-free.
> 
> This can be triggered by connecting a USB drive with a corrupted btrfs
> filesystem (e.g. chunk tree destroyed by a partial format), where the
> slow USB device keeps readahead BIOs in flight long enough for the
> error path to free fs_info before they complete. It can be reproduced
> on qemu with a properly corrupted btrfs img.
> 
>    BTRFS error (device sda): failed to read chunk tree: -2
>    BTRFS error (device sda): open_ctree failed: -2
>    BUG: unable to handle page fault for address: ffff89322ceb3000
>    RIP: 0010:percpu_counter_add_batch+0xe/0xb0
>     btrfs_bio_counter_sub+0x22/0x60
>     btrfs_simple_end_io+0x32/0x90
>     blk_update_request+0x12b/0x480
>     scsi_end_request+0x26/0x1b0
>     scsi_io_completion+0x50/0x790
> 
> Fix this by waiting for the bio_counter to reach zero in the error path
> before stopping workers, so all in-flight BIOs have completed their
> callbacks before fs_info is freed. The bio_counter is already
> initialized in init_mount_fs_info() so this wait is safe for all error
> paths reaching the fail_sb_buffer label.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
> Reported-by: AHN SEOK-YOUNG
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> ---
>   fs/btrfs/disk-io.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 01f2dbb69..61e6b8dca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3723,6 +3723,18 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>   	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>   
>   fail_sb_buffer:
> +	/*
> +	 * Wait for in-flight readahead BIOs before stopping workers.
> +	 * Readahead BIOs from btrfs_read_chunk_tree() (via
> +	 * readahead_tree_node_children) may still be in flight on slow
> +	 * devices (e.g. USB). Their completion callbacks
> +	 * (btrfs_simple_end_io) access fs_info->dev_replace.bio_counter
> +	 * which would be destroyed later, causing a use-after-free.
> +	 * The bio_counter was already initialized in init_mount_fs_info()
> +	 * so this wait is safe for all error paths reaching this label.
> +	 */
> +	wait_event(fs_info->dev_replace.replace_wait,
> +		   percpu_counter_sum(&fs_info->dev_replace.bio_counter) == 0);

This doesn't make any sense to me.

The wait and counter are all for dev-reaplce, not matching your 
description of the generic metadata readahead.

If you want to wait for all existing metadata reads, I didn't find a 
good helper, thus you will need to go through all extent buffers and 
wait for EXTENT_BUFFER_READING flags.

>   	btrfs_stop_all_workers(fs_info);
>   	btrfs_free_block_groups(fs_info);
>   fail_alloc:

