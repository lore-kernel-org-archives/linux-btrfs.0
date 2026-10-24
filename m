Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792882203;
	b=YxTEI6ja7HZxtyaQxpA49pEtQKOzOusBhvxECvmkhbQHwan1OY0gmnc+V5khjdcyFt3N
	 uWQKxo1kv/9aLrr1i2lgpM2bKs25/fWSDJBgKCt1ymT8teld67mhFRuK47wHvlulNgp+A
	 oOBi8vVOwehK/c5DGvd/Ty1YYhEHpdhO+cV13cyIOVzK9j73pODVFMtH/Rh+8in63jX+B
	 O4AHJ1YK59hARe+uW+ZOQBNCIfbld9KQDN28VTo67heAgnGPWr/R2zqeaCSmCeiFwTKlq
	 N7vZzS3iQ0DozaQXO6DR4SSEKVkfWitu+xeKk2VRB38VHvpk5LmEDq8Ux+nlB57ybEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792882203;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=i0Qh1imY6pGPEZ/CCWkGU9zuwSPAAzYpR2YimXWTGcY=;
	b=Z7Zn7US4BaWSMeUs5OIkwqsHD6wperKV7gXTr8TT0lU4vmtbUz6SH7c0XceFha0ojCOJ
	 KLlLmuziQjW9kR/bJL7bS2913jG/RIBlpcGulJHxIJNql+fXH2GAz778mAwt80A1oNzMM
	 Iucvv3Je5MUDwoAay+0QJPhamo56CTaG1UPeo1Cg6R33VuAHdWUlfeH+7dfO++HfBrDyz
	 Vor4+Uxabl0KNAwy7PM2UWTQvrk6CCufK9/oFOXKijt09L+g95BnOW0YAeAacjxb4yRmd
	 CACW5H8qhNEUfcaNoi/rasW+AZmchbvmRSSPqBe0I94xMxUTKk0vxeK4j50qCrj/zpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Um0jKM+v;
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B2F606A31A;
	Sat, 24 Oct 2026 22:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66B2F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Um0jKM+v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792882192; x=1793486992; i=quwenruo.btrfs@gmx.com;
	bh=i0Qh1imY6pGPEZ/CCWkGU9zuwSPAAzYpR2YimXWTGcY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Um0jKM+vwVWF0fGWkphWq4/bbnLqfh/lLS3ugS4aCPyc1XxwSUfkj/A5thweu6bL
	 EkxpC/HOj/HrJOKtAYkfTgUOe01qqp6bZBNRl05QcpCdPkiocyd8ee6L8lF9uf/q4
	 tB6rvBgZZenFnU3tkVgJQRhe9p60nYSAzTaTlODWgcELrhfKvchvu4yV0ygjLHgE5
	 XTcG8C0fttPK9HnhTTINEW/JzMh4DZSEhOGxpSA1P8tsAq7Ktp/eqmUZJHYxPkqGL
	 X0K96BJPP1Jy3187BM+JSEHLbK1sIaBVM5grRxnAXZP7x92xdHA8fP6I0/3QiRWPJ
	 uvfXYWL7OPh5picAqQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MaJ3n-1x6Br30UKb-00MOq2; Sun, 25
 Oct 2026 00:49:52 +0200
Message-ID: <d325a805-2f1a-4619-a8ee-3a69a9ee7e22@gmx.com>
Date: Sun, 25 Oct 2026 09:19:46 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix race between device add and chunk allocation
 leading to transaction abort
To: zubenkos@external.gene.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261023-btrfs-device-add-race-v1-1-90cf05e8128f@external.gene.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20261023-btrfs-device-add-race-v1-1-90cf05e8128f@external.gene.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:62GkZn0lI7tqOHCmiyVxQXFDI87Mnh5oyDNavh7lYbZDxZuKZ6G
 SNgSGaFkot65UmnqMReMRY+xN7f+p6h7phOmGxyA+Wbrb2HR8Uf/8f8QCsj1LwJHQuSubbR
 ViF5UMgXDBsN6rEBKjPbERSgW6JaEyg1/kCOBBNSubuKb35vjUPsYQ1HDhLJp+zz5eXIATN
 bsb37Hr5jMdsxN+m/gDvg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FtHxu9RjXXk=;Bk9ABRznYnxEg1BNuZj88oossSW
 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
 3BA=



=E5=9C=A8 2026/10/24 08:01, Stanislav Zubenko via B4 Relay =E5=86=99=E9=81=
=93:
> From: Stanislav Zubenko <zubenkos@external.gene.com>
>=20
> While adding a device to a filesystem that was under heavy buffered writ=
e
> load, a chunk allocation done by writeback aborted the transaction with
> -ENOENT, which turned the filesystem read-only:
>=20
>    BTRFS: Transaction aborted (error -2)
>    WARNING: CPU: 15 PID: 1149147 at fs/btrfs/block-group.c:3731 do_chunk=
_alloc.cold+0x162/0x1b7 [btrfs]
>    CPU: 15 PID: 1149147 Comm: kworker/u128:13 Tainted: G           OE   =
   6.1.170-213.321.amzn2023.x86_64 #1
>    Hardware name: Amazon EC2 r6i.16xlarge/, BIOS 1.0 10/16/2017
>    Workqueue: writeback wb_workfn (flush-btrfs-1)
>    RIP: 0010:do_chunk_alloc.cold+0x162/0x1b7 [btrfs]
>    Call Trace:
>     <TASK>
>     btrfs_chunk_alloc+0x15d/0x2f0 [btrfs]
>     find_free_extent_update_loop+0x1f6/0x2d0 [btrfs]
>     find_free_extent+0x347/0x740 [btrfs]
>     btrfs_reserve_extent+0x147/0x290 [btrfs]
>     cow_file_range+0x15c/0x590 [btrfs]
>     btrfs_run_delalloc_range+0x111/0x1d0 [btrfs]
>     writepage_delalloc+0xc1/0x180 [btrfs]
>     __extent_writepage+0x10c/0x460 [btrfs]
>     extent_write_cache_pages+0x141/0x4e0 [btrfs]
>     extent_writepages+0x7b/0x140 [btrfs]
>     do_writepages+0xcd/0x1c0
>     __writeback_single_inode+0x41/0x270
>     writeback_sb_inodes+0x209/0x4c0
>     __writeback_inodes_wb+0x4c/0xe0
>     wb_writeback+0x1d7/0x2d0
>     wb_do_writeback+0x22a/0x2b0
>     wb_workfn+0x5d/0x250
>     process_one_work+0x1e5/0x3b0
>     worker_thread+0x50/0x3a0
>     kthread+0xd9/0x100
>     ret_from_fork+0x1f/0x30
>     </TASK>
>    BTRFS: error (device nvme1n1: state A) in do_chunk_alloc:3731: errno=
=3D-2 No such entry
>    BTRFS info (device nvme1n1: state EA): forced readonly
>=20
> The filesystem had a single data profile, it was about 80% full and was
> receiving around 1GB/s of buffered writes. The abort happened about 11
> seconds after "btrfs device add" was started for a sixth device, and the
> add never completed (no "disk added" message was logged). The same
> happened on a second machine with the same workload on the same day.
>=20
> The -ENOENT comes from btrfs_update_device(), which does not find the
> device item of the device being added. This is due to a race between
> adding a device and chunk allocation, which the following diagram
> illustrates:
>=20
>           CPU 1                        CPU 2
>=20
>   btrfs_init_new_device()
>     btrfs_start_transaction()
>     lock fs_devices->device_list_mutex
>     lock fs_info->chunk_mutex
>     adds the new device to
>     fs_devices->alloc_list
>     btrfs_clear_space_info_full()
>     unlock fs_info->chunk_mutex
>=20
>                                cow_file_range()
>                                  btrfs_reserve_extent()
>                                    find_free_extent()
>                                      btrfs_join_transaction()
>                                        --> joins the transaction
>                                            started by CPU 1
>                                      btrfs_chunk_alloc()
>                                        lock fs_info->chunk_mutex
>                                        do_chunk_alloc()
>                                          btrfs_create_chunk()
>                                            --> picks the new device,
>                                                it is the one with
>                                                most free space
>                                          btrfs_chunk_alloc_add_chunk_ite=
m()
>                                            btrfs_update_device()
>                                              --> doesn't find the
>                                                  device item of the
>                                                  new device, returns
>                                                  -ENOENT
>                                          btrfs_abort_transaction()
>                                        unlock fs_info->chunk_mutex
>     btrfs_sysfs_add_device()
>     unlock fs_devices->device_list_mutex
>     btrfs_add_dev_item()
>       btrfs_reserve_chunk_metadata()
>         lock fs_info->chunk_mutex
>         unlock fs_info->chunk_mutex
>       inserts the device item in the
>       chunk btree, but it's too late
>=20
> Before commit 79bd37120b14 ("btrfs: rework chunk allocation to avoid
> exhaustion of the system chunk array"), device items were only updated i=
n
> phase 2 of the chunk allocation, at btrfs_finish_chunk_alloc(), and that
> was done while holding the device_list_mutex, which is taken there since
> commit 50460e37186a ("Btrfs: fix race when finishing dev replace leading
> to transaction abort"). Since adding a device holds the device_list_mute=
x
> until after it registers the device in sysfs, the race window was only t=
he
> very short time between unlocking that mutex and inserting the device
> item. The chunk allocation rework moved the device item updates to phase
> 1, under the protection of the chunk_mutex only, so the window now also
> covers the sysfs registration and the system space reservation done by
> btrfs_add_dev_item(), which must take the chunk_mutex itself and so can
> end up waiting for the very chunk allocation that is going to fail.
>=20
> Fix this by deferring everything that makes the new device usable by
> the chunk allocator until btrfs_add_dev_item() has inserted its device
> item in the chunk btree: adding it to the allocation list, accounting
> its space in free_chunk_space, clearing the full flags of the space
> infos and updating the per profile available space.
>=20
> When sprouting a seed filesystem, keep doing this before inserting the
> device item, because init_first_rw_device() has to allocate chunks from
> the new device first. That is safe because a seed filesystem is
> read-only and we are holding sb->s_umount, so nothing else can be
> allocating chunks.
>=20
> Fixes: 79bd37120b14 ("btrfs: rework chunk allocation to avoid exhaustion=
 of the system chunk array")
> CC: stable@vger.kernel.org # 5.15+
> Assisted-by: LLM
> Signed-off-by: Stanislav Zubenko <zubenkos@external.gene.com>
> ---
>   fs/btrfs/volumes.c | 34 ++++++++++++++++++++++++----------
>   1 file changed, 24 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6574939e1..bc8ffa7bb 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3066,15 +3066,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *=
fs_info, const char *device_path
>  =20
>   	mutex_lock(&fs_info->chunk_mutex);
>   	list_add_rcu(&device->dev_list, &fs_devices->devices);
> -	list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
>   	fs_devices->num_devices++;
>   	fs_devices->open_devices++;
>   	fs_devices->rw_devices++;
>   	fs_devices->total_devices++;
>   	fs_devices->total_rw_bytes +=3D device->total_bytes;
>  =20
> -	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
> -
>   	if (bdev_rot(device->bdev))
>   		fs_devices->rotating =3D true;
>  =20
> @@ -3088,12 +3085,20 @@ int btrfs_init_new_device(struct btrfs_fs_info *=
fs_info, const char *device_path
>   				    orig_super_num_devices + 1);
>  =20
>   	/*
> -	 * we've got more storage, clear any full flags on the space
> -	 * infos
> +	 * The chunk allocator must not use the new device before its device
> +	 * item is in the chunk btree, otherwise allocating a chunk on it fail=
s
> +	 * to update that item with -ENOENT and aborts the transaction.
> +	 * Sprouting is the exception: init_first_rw_device() must allocate fr=
om
> +	 * the new device before its item can be inserted, and nothing else ca=
n
> +	 * allocate chunks since a seed filesystem is read-only and we are
> +	 * holding sb->s_umount.
>   	 */
> -	btrfs_clear_space_info_full(fs_info);
> -
> -	btrfs_update_per_profile_avail(fs_info);
> +	if (seeding_dev) {
> +		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
> +		atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
> +		btrfs_clear_space_info_full(fs_info);
> +		btrfs_update_per_profile_avail(fs_info);
> +	}
>   	mutex_unlock(&fs_info->chunk_mutex);
>  =20
>   	/* Add sysfs device entry */
> @@ -3134,6 +3139,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>   		 * its fsid has been changed by btrfs_sprout_splice().
>   		 */
>   		btrfs_sysfs_update_sprout_fsid(fs_devices);
> +	} else {
> +		mutex_lock(&fs_info->chunk_mutex);

Sashiko mentioned a critical problem, that if the device is removed=20
before reaching this branch?

Also sashiko has another high level problem exposed, I believe you=20
should take care of both sashiko reviews:

https://sashiko.dev/#/patchset/20261023-btrfs-device-add-race-v1-1-90cf05e=
8128f%40external.gene.com

> +		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
> +		atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
> +		btrfs_clear_space_info_full(fs_info);
> +		btrfs_update_per_profile_avail(fs_info);
> +		mutex_unlock(&fs_info->chunk_mutex);
>   	}
>  =20
>   	ret =3D btrfs_commit_transaction(trans);
> @@ -3190,13 +3202,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *=
fs_info, const char *device_path
>   	if (!list_empty(&device->post_commit_list))
>   		list_del_init(&device->post_commit_list);
>   	list_del_rcu(&device->dev_list);
> -	list_del(&device->dev_alloc_list);
> +	if (!list_empty(&device->dev_alloc_list)) {
> +		list_del_init(&device->dev_alloc_list);
> +		atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
> +	}
>   	fs_info->fs_devices->num_devices--;
>   	fs_info->fs_devices->open_devices--;
>   	fs_info->fs_devices->rw_devices--;
>   	fs_info->fs_devices->total_devices--;
>   	fs_info->fs_devices->total_rw_bytes -=3D device->total_bytes;
> -	atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
>   	btrfs_set_super_total_bytes(fs_info->super_copy,
>   				    orig_super_total_bytes);
>   	btrfs_set_super_num_devices(fs_info->super_copy,
>=20
> ---
> base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
> change-id: 20261023-btrfs-device-add-race-d8c4f1c3ed84
>=20
> Best regards,
> --
> Stanislav Zubenko <zubenkos@external.gene.com>

