Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67732264CA
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 01:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789952790; cv=none; b=p2a8zGCG9ppsXFzRfHCOPLnkD6q+sLKzM+z7VdAYMdjgpp1LBawNUyrK4J1dUkSHrYfXec9uYlzowJGOlxuyEcn9wEN/M6E5UGamRIbOzsB5KPxEMVk7zuHjxT1SsgnLnPgsZzCsciGsan3gyY5oO4DTJ4uViuoXwLAxRFRPQMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789952790; c=relaxed/simple;
	bh=dECPEo7GfCqxRbOnObhewcbBL4mvjx8FZrVralD6nW0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=W3CyWHAYQCO+EM1SjGRpIIwYw64RMlvnYo7oqDDO6+L0PykhzIWXAMS5utwwf9kYgasxEnzbHms0hXrli/1TG4a+9Q+g0dh5/Z+BILSpJj91qqN9HqOV5zS0LKNw8rMlG4bW75gxzOLcxyi2/R+7aoga9cy29QNAAJoDBWNkLss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LwycaZrh; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LwycaZrh"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55eff0so364684666b.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 18:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789952787; x=1790557587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fmuFensiFyLlvFmPu0nfg0vO+unWN/awX3YwPiES4cI=;
        b=LwycaZrh6wGfLpuRtdq01G8FSfEjvNnQDjAVPpF2LWXYB316oOv7HmYVdF77eVVmul
         SEdUMG9rUuqg5E4yETNmnb6tuG/ns5FarguMNj+1m/+2qR70Mm9aKokVazC++RkeqoIy
         fKCHDl+5p9p6xE/wri9URu2FEoA4Mj1V9yTGMzhijZ2zv+DzkVbaoSxwyYcdCfSAQws3
         kc54iGBOuhiQKApPyaJor9RK9NrV3doeEdpoH/kxeXqKcIhcaQcLaw+EUNNpE77ejm/t
         YPApZIQIoT9ZvTVen+jvcKRmk65TzBBHIafMII6S3NppY7xCfy+iANZbnNzcZxUuIE1g
         VqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789952787; x=1790557587;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fmuFensiFyLlvFmPu0nfg0vO+unWN/awX3YwPiES4cI=;
        b=kZynTpfWBN9mdsg+PivBalq3XPwt1hlGNatKSjsaQFdHEBb7hKcGQT464iu3qGJUmY
         uhhDIKLxD6Sj+ZcLnX4eQ6pbDhw0azxzHIS+uoxADKSMnn3mXhNx7Pzh9Y5Sjl3TyLeb
         hgB+v0Vxqa5OB9YZFBHRzuB0B1gtrks+w2ep8galh89Ry/vT8zY/6Gde3sBUr/e5MCqw
         S8Q+RhZBNCadHSovQiGnz9CChWA6NE+SCpGJD1bcTeBfOXxlaggSZMGPDacIClwbs//i
         aB7IQzCeJ7NPsa8M3xt6RVHe1mSF09tOJO9r3xi4uUqAFDuL0zu4vrZaYe84l08mzF8V
         g6kA==
X-Gm-Message-State: AFuF++lULC6CZU8A0+v7nlOZZ8JSdyPtlVrCjpIP6L9bonI0PHef2K8T
	mpQj+g2hWZADmXCVl2G/shOj4yPQ5e+Zv0k3Uvi7qV5dGVTs2lPN1H52RP3tx1Iuokh3cmz7Cb4
	cWKs1Q20=
X-Gm-Gg: AYBFou1vZke+kDw6rYFIty5prTnBAJEDlc8Tz4ZBhXNViCeJovGzwgSftw2B+ZNOpBx
	9xMU5Kr0fGFsUZ8brLfaFrkCWK+U+ikwfEGh+Tk1XDuO6JoKPJSRrKJraVWv8Isk2hcPPhWHvNP
	ixN4lDi4UFdStvAQ4aG8Iycj2n23Q13XE1EtOCvRZM4GYGXBy1s9/fUyTDfvSItzkp2EHyF86/d
	YvkyR8BZ3GXYGG/B67Fi8YyCf00omd8cDS36iFbscPcMvA3mddaqRfyi2Dzix/onyeaNDF2HaCS
	q81FF+lKuKBcUWWkwbIv+GCadI5egVZCRPtoINTgvbhU8Cfsfcfimg5z7idxmd4UV3UEEDPQKyD
	jgGyFzOdynVOaUQsTpTVc0YXF2B5HmzZUHYS4Gvh6jNHsXZOw1IidHFMGDLFzuGcK/4Svevygrz
	QNkgTxIrvkKcVLRwY//p3DrJN10DGjadzoVOO5WD+Rb6SHcrsrjJlhLBaDAz+4rthBFvuljG5bT
	Q==
X-Received: by 2002:a17:906:c14e:b0:c29:5af0:3b44 with SMTP id a640c23a62f3a-c2a157fc26emr690985166b.41.1789952786611;
        Sun, 20 Sep 2026 18:06:26 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a038ff8c39sm5486896a91.7.2026.09.20.18.06.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 18:06:25 -0700 (PDT)
Message-ID: <2f777aa2-bebb-4b21-9027-6a64371711ed@suse.com>
Date: Mon, 21 Sep 2026 10:36:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] btrfs: remove the tailing zeros from compressed
 inline extents
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1789951424.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <cover.1789951424.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/21 10:14, Qu Wenruo 写道:
> [CHANGELOG]
> v3:
> - Introduce an early i_size >= blocksize rejection to prevent race
>    Previously we allow inline extents for i_size == blocksize case, as
>    long as the compressed data can still be inlined.
> 
>    But that introduce a race with setsize(), which is masked by using
>    blocksize for compression.
> 
>    When reverting back to using i_size for compression, we can get a much
>    larger i_size than expectation.
> 
>    Close the race window by always requireing i_size < blocksize, which
>    makes btrfs_setsize() to always wait for the folio held by us before
>    updating the i_size.
> 
>    This unfortunately introduce a behavior change, so all the fixes tags
>    are dropped.

Please drop the whole series.

Filipe's merged v3 fix is good enough, and the extra i_size related race 
is very tricky to handle correctly.

The existing blocksize based compression so far is the safest solution, 
the saved a dozen of bytes are not worthy for the extra races.

Thanks,
Qu
> 
>    This is exposed by Sashiko during review of v1 and v2 patchsets, and
>    reproduced once during fstests runs, resulting the following
>    warning without the new rejection:
> 
> [  497.553473] BTRFS info (device dm-2 state M): use lzo compression, level 1
> [  497.599454] BTRFS info (device dm-2 state M): use zstd compression, level 3
> [  497.661405] ------------[ cut here ]------------
> [  497.661414] WARNING: zstd.c:41 at zstd_compress_bio+0x120a/0x1fb0 [btrfs], CPU#1: kworker/u47:5/3431
> [  497.666534] Modules linked in: dm_flakey btrfs(OE) nls_ascii nls_cp437 vfat fat i2c_i801 joydev psmouse pcspkr iTCO_wdt i2c_smbus mousedev xor raid6_pq loop vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock vmw_vmci qemu_fw_cfg ext4 crc16 mbcache jbd2 dm_mod virtio_net net_failover serio_raw virtio_rng virtio_balloon virtio_gpu virtio_scsi failover virtio_dma_buf lpc_ich virtio_blk [last unloaded: btrfs]
> [  497.677435] CPU: 1 UID: 0 PID: 3431 Comm: kworker/u47:5 Tainted: G           OE       7.3.0-rc3-custom+ #464 PREEMPT(full)  8f6fa45f5906dd4b1abb78057674460bd6af91c9
> [  497.681556] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> [  497.683051] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
> [  497.685450] Workqueue: writeback wb_workfn (flush-btrfs-222)
> [  497.687235] RIP: 0010:zstd_compress_bio+0x120a/0x1fb0 [btrfs]
> [  497.689061] Code: fd ff ff 48 89 ef e8 85 65 00 00 e9 db fd ff ff 48 89 df e8 38 e0 4b c2 e9 57 fe ff ff 48 89 d7 e8 2b e0 4b c2 e9 6f fa ff ff <0f> 0b e9 2c f0 ff ff e8 0a c5 ec c1 49 8d bf b8 01 00 00 48 b8 00
> [  497.694043] RSP: 0018:ffff88810a17ece8 EFLAGS: 00010202
> [  497.695504] RAX: 0000000000000011 RBX: ffff888102615e28 RCX: 0000001000000015
> [  497.697482] RDX: 0000000100000011 RSI: 0000000000000002 RDI: ffff88810a17ec58
> [  497.699455] RBP: 0000000000000011 R08: ffffffff846ca856 R09: ffff88810a17ec50
> [  497.701424] R10: ffffed102142fd8b R11: 0000000000000010 R12: 0000000000000003
> [  497.703444] R13: ffff888112695a00 R14: 000000000048f5e9 R15: ffff88819f5b0000
> [  497.705410] FS:  0000000000000000(0000) GS:ffff8882aed9b000(0000) knlGS:0000000000000000
> [  497.707610] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  497.709251] CR2: 000055967f60f000 CR3: 0000000111372000 CR4: 0000000000f50ef0
> [  497.711388] PKRU: 55555554
> [  497.712204] Call Trace:
> [  497.712923]  <TASK>
> [  497.713575]  ? _raw_spin_unlock_bh+0xe/0x20
> [  497.714781]  ? zstd_find_workspace.isra.0+0x283/0x8b0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.717434]  ? kmem_cache_alloc_noprof+0x194/0x420
> [  497.718798]  ? zstd_get_workspace+0xde/0x2c0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.721241]  ? zstd_get_workspace+0x2c0/0x2c0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.723730]  ? __asan_memset+0x27/0x50
> [  497.724907]  ? btrfs_free_compr_folio+0x2c0/0x2c0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.727535]  btrfs_compress_bio+0x683/0xb90 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.729989]  btrfs_run_delalloc_range+0x12d9/0x1ba0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.732712]  ? extent_writepage_io+0xe40/0xe40 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.735231]  ? btrfs_copy_subpage_dirty_bitmap+0x98/0x620 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.737989]  ? submit_uncompressed_range+0x260/0x260 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.740665]  ? btrfs_folio_set_lock+0x15c/0x420 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.743162]  writepage_delalloc+0x7d8/0x1270 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.745646]  ? find_lock_delalloc_range+0x7b0/0x7b0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.748277]  ? tag_pages_for_writeback+0x205/0x2d0
> [  497.749653]  ? folio_mkclean+0x163/0x3a0
> [  497.750784]  ? __traceiter_remove_migration_pte+0xb0/0xb0
> [  497.752297]  ? folio_wait_writeback+0xa8/0x200
> [  497.753574]  extent_write_cache_pages+0xb59/0x1e30 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.756187]  ? btrfs_do_readpage+0x2600/0x2600 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.758797]  btrfs_writepages+0x1c2/0x4a0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.761179]  ? virtqueue_add_inbuf_ctx+0x2820/0x2820
> [  497.762655]  ? extent_write_locked_range+0x8f0/0x8f0 [btrfs 1621afd7f58f5561128c1bbfbe7eb177867269dc]
> [  497.765264]  ? blk_mq_tag_update_sched_shared_tags+0xf0/0xf0
> [  497.766854]  ? sg_init_table+0x19/0x60
> [  497.767967]  do_writepages+0x212/0x550
> [  497.769062]  ? _raw_spin_lock+0x84/0xe0
> [  497.770185]  ? writeback_set_ratelimit+0x120/0x120
> [  497.771574]  __writeback_single_inode+0xeb/0xba0
> [  497.772902]  ? _raw_spin_lock+0x84/0xe0
> [  497.774015]  ? sync_lazytime+0x330/0x330
> [  497.775167]  ? _raw_spin_unlock+0xe/0x20
> [  497.776288]  ? wbc_attach_and_unlock_inode+0x346/0x610
> [  497.777741]  writeback_sb_inodes+0x5a3/0xff0
> [  497.779007]  ? asm_common_interrupt+0x26/0x40
> [  497.780399]  ? __writeback_single_inode+0xba0/0xba0
> [  497.781862]  ? queue_io+0x2a3/0x480
> [  497.782957]  ? wb_update_bandwidth+0xd0/0xd0
> [  497.784258]  wb_writeback+0x1d9/0x780
> [  497.785338]  ? writeback_inodes_wb.constprop.0+0x1d0/0x1d0
> [  497.786935]  ? _raw_write_lock_irq+0xe0/0xe0
> [  497.788340]  ? psi_group_change+0x38d/0x750
> [  497.789711]  wb_workfn+0x1f6/0xc10
> [  497.790877]  ? _raw_spin_unlock+0xe/0x20
> [  497.792082]  ? sync_inode_metadata+0xd0/0xd0
> [  497.793392]  ? __schedule+0xe8d/0x5ec0
> [  497.794549]  ? max_active_store+0x100/0x100
> [  497.795838]  ? _raw_spin_lock_irq+0x8a/0xe0
> [  497.797113]  process_one_work+0x721/0x10b0
> [  497.798376]  ? io_schedule_timeout+0x130/0x130
> [  497.799801]  ? pwq_dec_nr_in_flight+0xfd0/0xfd0
> [  497.801092]  ? _raw_spin_lock_irq+0x8a/0xe0
> [  497.802271]  ? _raw_write_lock_irq+0xe0/0xe0
> [  497.803477]  worker_thread+0x536/0xda0
> [  497.804548]  ? rescuer_thread+0x1480/0x1480
> [  497.805905]  kthread+0x352/0x450
> [  497.806874]  ? recalc_sigpending+0x15c/0x200
> [  497.808114]  ? kthread_affine_node+0x300/0x300
> [  497.809389]  ret_from_fork+0x473/0x710
> [  497.810484]  ? exit_thread+0x70/0x70
> [  497.811537]  ? __switch_to+0x3ab/0xcf0
> [  497.812645]  ? kthread_affine_node+0x300/0x300
> [  497.813930]  ret_from_fork_asm+0x11/0x20
> [  497.815060]  </TASK>
> [  497.815718] ---[ end trace 0000000000000000 ]---
> [  497.817260] BTRFS warning (device dm-2): zstd compression level 3 failed, error 64 root 263 inode 264 offset 0
> [  497.840873] BTRFS info (device dm-2 state M): use no compression
> 
> v2:
> - Remove the block based space saving checks completely from lzo
>    Zlib and ZSTD do not have block based space saving in the first place.
>    It's the caller's responsibility to check, and inlined and regular
>    extents have different requirements.
> 
>    This simplify the first patch a lot.
> 
> - Update the cover letter
>    Filipe's v3 fix is already merged, so we can not force push a fix but
>    to co-operate the v3 fix.
> 
> Commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
> delalloc helper") changed the compression input from [0, i_size) to [0,
> blocksize), which caused two problems:
> 
> - Other tools unable to decompress the inlined extent
>    U-boot and btrfs-restore are affected, as they only allocated a buffer
>    which is @ram_bytes sized.
>    That buffer is too small to contain the decompressed data, which is
>    @sectorsize.
> 
>    Those projects are fixed to have a more robust decompression routine
>    which can handle both cases now.
> 
> - Worse ratio for those compressed inline extent.
> 
>    For the same 3K 0xcd filled range, the results are small but
>    observable, 48 vs 61 bytes.
> 
> Filipe's v1 fix is very close to a proper fix, but btrfs will unable to
> create inlined extents for lzo.
> It turns out to be another bug in the copy_compressed_data_to_bio()
> function.
> 
> Which is doing a premature block size based space saving checks,
> meanwhile all other algorithms do not have block sized based checks, but
> only a simple "@compressed >= @input" check.
> Zlib and Zstd all rely on the caller to do proper space saving checks,
> as regular and inlined extents have different requirements.
> 
> So this series is to properly fix the bug, firstly fix the lzo
> regression which prevents inlined extent creation, then restore the old
> i_size based inline extent creation.
> 
> To prevent i_size being updated during writeback, add a new i_size <
> blocksize requirement, so btrfs_setsize() will always wait for us before
> updating the i_size during expansion.
> 
> However this introduces a new behavior change, that we can no longer
> create block sized (ram_bytes) inlined extents.
> 
> 
> Qu Wenruo (2):
>    btrfs: lzo: fix space saving checks
>    btrfs: remove the trailing zeros from compressed inline extent
> 
>   fs/btrfs/inode.c | 28 ++++++++++++++++++++++------
>   fs/btrfs/lzo.c   |  5 +++--
>   2 files changed, 25 insertions(+), 8 deletions(-)
> 

