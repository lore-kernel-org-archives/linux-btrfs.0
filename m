Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793035091;
	b=hRfZ9XP5yjtMwD5dvbdTUtTNVjhq8aiAO3+zRxKZ/YHspiTPYgczsMcY8HVTbu+N6Pk4
	 m+BOmcsSzg3GvZ+YUH95880Yp0ZG9mbz4/dUNXWBHCVDkQeY/5+R6UDTHRSdLcoGvL7bR
	 xtQRHAVxKlcgrajApspztu8gQyIoem6Cf+g+msGMEOHfAs4PfZESVw+dRBeAuBV17wO4k
	 5VEnbMBD8p1uSfZRNAJKVtLIkCAEsoZLk2TH1HfOl4ogpRPp3qSalxvNv3lBm6R/5VVHM
	 XbarcjFr/0jYzkkEPz2iQyUA4nVwSWZpNgBPJSOqoRZLNPj49Bjb+mgJwhJy62kZEgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793035091;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XJnn5NkyLDa9N/CUoiVzAj3CnxRRTID38jqgYaGjxi4=;
	b=g0Hd97h1JdfOYit61bymgns4jGHW5+Ralr11tii+ig+PPXem6LA1Vpqj14BTNokogHuH
	 eDODeVPSt6lvj4U382VlgLQ7ASyoiWiW21a0xyFSql/89O7FZSbOxq7sR4YyKbOcQOv9w
	 29R+AylArYE4LTuwYeuvR93xu8+7NyIET1Bg8RImAMvqkMwk8fVjRo/QXdcZFM6w7gmnt
	 z39Px6BhDxoVF+9JOs61Hjcl+DdQRi7TnqP8x/tNa+u37o+6QQRfKeZfSLlR7gYV8NP6k
	 Pr67hapPHzoht1ASwh1zYmPB8kT8Z676WQeMhGJd5SL3elJIk/zz5hmap3nZ8qUg+/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZanWrwh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5741606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZanWrwh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573071F01828
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035090;
	bh=XJnn5NkyLDa9N/CUoiVzAj3CnxRRTID38jqgYaGjxi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IZanWrwhzcX5daUuAlFMqkG0+Plx+1GW6LodnQl7EVHZgSnraCwqVXoGfRhAYprkl
	 1vs2APJaA8asZ/fjiZSRobr5ZQiEc0Vu2IT6MKPb054M42MLMJeUvWHPBkXyMBMKXn
	 XG844qgiIwZfdz6meoYauuWguqH6lUrdNk4w5qdqjusnWNLidc96VSfP/tYrj+aDES
	 4+yLtp2wCBhEO4lf5doeMGQcGR/QMWXGrXEDnxWvZ0ZI7l/z5b+8ARuUh0ZdF7+c7j
	 GVqoLEs2k/p/6GIqyuSNlxcsVf8MPasIeNcBPKnmwW/Q+JyazHFFtbfjcK9ly3mwxY
	 mGOGuqwo/i6yw==
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-98c8cbdb9daso630412241.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 10:18:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwkSDWfE7oqMrLRpl33qdGFMJBc+oMaQ8piVa7TAnyD7pL4/8niVO0dFZoHO9A15CkIKaBPfardnxarfw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK+3zjT8Ul6PQIFgLMMMJgNzYhL//roP8aCpyXWHrHy1B+X/SIP
	xNVUN9mMPXFmaRYl7pc6xwFU2tlUpysJPB32HI2vVZo38Z2t6G7zYuGJ8eEz6uDppkTkKydJcbJ
	qEtM0zb1wInKUEDIfzMce8z4u9GQq4Ek=
X-Received: by 2002:a05:6102:c4b:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7ce5cc64ee0mr2336258137.10.1793035089545; Mon, 26 Oct 2026
 10:18:09 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023-btrfs-device-add-race-v1-1-90cf05e8128f@external.gene.com>
In-Reply-To: <20261023-btrfs-device-add-race-v1-1-90cf05e8128f@external.gene.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 26 Oct 2026 17:17:33 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5ByHxsMk-g=PPfaUUHaS6mQqW1FEDZq7-qmegOf79S=Q@mail.gmail.com>
X-Gm-Features: AclHuK-8CSqglckmDE3kP7wvRrF7_3RG_QhzAuBxuo-Zsii4LeWHtJh9Vd5sjBg
Message-ID: <CAL3q7H5ByHxsMk-g=PPfaUUHaS6mQqW1FEDZq7-qmegOf79S=Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix race between device add and chunk allocation
 leading to transaction abort
To: zubenkos@external.gene.com
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 10:33=E2=80=AFPM Stanislav Zubenko via B4 Relay
<devnull+zubenkos.external.gene.com@kernel.org> wrote:
>
> From: Stanislav Zubenko <zubenkos@external.gene.com>
>
> While adding a device to a filesystem that was under heavy buffered write
> load, a chunk allocation done by writeback aborted the transaction with
> -ENOENT, which turned the filesystem read-only:
>
>   BTRFS: Transaction aborted (error -2)
>   WARNING: CPU: 15 PID: 1149147 at fs/btrfs/block-group.c:3731 do_chunk_a=
lloc.cold+0x162/0x1b7 [btrfs]
>   CPU: 15 PID: 1149147 Comm: kworker/u128:13 Tainted: G           OE     =
 6.1.170-213.321.amzn2023.x86_64 #1
>   Hardware name: Amazon EC2 r6i.16xlarge/, BIOS 1.0 10/16/2017
>   Workqueue: writeback wb_workfn (flush-btrfs-1)
>   RIP: 0010:do_chunk_alloc.cold+0x162/0x1b7 [btrfs]
>   Call Trace:
>    <TASK>
>    btrfs_chunk_alloc+0x15d/0x2f0 [btrfs]
>    find_free_extent_update_loop+0x1f6/0x2d0 [btrfs]
>    find_free_extent+0x347/0x740 [btrfs]
>    btrfs_reserve_extent+0x147/0x290 [btrfs]
>    cow_file_range+0x15c/0x590 [btrfs]
>    btrfs_run_delalloc_range+0x111/0x1d0 [btrfs]
>    writepage_delalloc+0xc1/0x180 [btrfs]
>    __extent_writepage+0x10c/0x460 [btrfs]
>    extent_write_cache_pages+0x141/0x4e0 [btrfs]
>    extent_writepages+0x7b/0x140 [btrfs]
>    do_writepages+0xcd/0x1c0
>    __writeback_single_inode+0x41/0x270
>    writeback_sb_inodes+0x209/0x4c0
>    __writeback_inodes_wb+0x4c/0xe0
>    wb_writeback+0x1d7/0x2d0
>    wb_do_writeback+0x22a/0x2b0
>    wb_workfn+0x5d/0x250
>    process_one_work+0x1e5/0x3b0
>    worker_thread+0x50/0x3a0
>    kthread+0xd9/0x100
>    ret_from_fork+0x1f/0x30
>    </TASK>
>   BTRFS: error (device nvme1n1: state A) in do_chunk_alloc:3731: errno=3D=
-2 No such entry
>   BTRFS info (device nvme1n1: state EA): forced readonly
>
> The filesystem had a single data profile, it was about 80% full and was
> receiving around 1GB/s of buffered writes. The abort happened about 11
> seconds after "btrfs device add" was started for a sixth device, and the
> add never completed (no "disk added" message was logged). The same
> happened on a second machine with the same workload on the same day.
>
> The -ENOENT comes from btrfs_update_device(), which does not find the
> device item of the device being added. This is due to a race between
> adding a device and chunk allocation, which the following diagram
> illustrates:
>
>          CPU 1                        CPU 2
>
>  btrfs_init_new_device()
>    btrfs_start_transaction()
>    lock fs_devices->device_list_mutex
>    lock fs_info->chunk_mutex
>    adds the new device to
>    fs_devices->alloc_list
>    btrfs_clear_space_info_full()
>    unlock fs_info->chunk_mutex
>
>                               cow_file_range()
>                                 btrfs_reserve_extent()
>                                   find_free_extent()
>                                     btrfs_join_transaction()
>                                       --> joins the transaction
>                                           started by CPU 1
>                                     btrfs_chunk_alloc()
>                                       lock fs_info->chunk_mutex
>                                       do_chunk_alloc()
>                                         btrfs_create_chunk()
>                                           --> picks the new device,
>                                               it is the one with
>                                               most free space
>                                         btrfs_chunk_alloc_add_chunk_item(=
)
>                                           btrfs_update_device()
>                                             --> doesn't find the
>                                                 device item of the
>                                                 new device, returns
>                                                 -ENOENT
>                                         btrfs_abort_transaction()
>                                       unlock fs_info->chunk_mutex
>    btrfs_sysfs_add_device()
>    unlock fs_devices->device_list_mutex
>    btrfs_add_dev_item()
>      btrfs_reserve_chunk_metadata()
>        lock fs_info->chunk_mutex
>        unlock fs_info->chunk_mutex
>      inserts the device item in the
>      chunk btree, but it's too late
>
> Before commit 79bd37120b14 ("btrfs: rework chunk allocation to avoid
> exhaustion of the system chunk array"), device items were only updated in
> phase 2 of the chunk allocation, at btrfs_finish_chunk_alloc(), and that
> was done while holding the device_list_mutex, which is taken there since
> commit 50460e37186a ("Btrfs: fix race when finishing dev replace leading
> to transaction abort"). Since adding a device holds the device_list_mutex
> until after it registers the device in sysfs, the race window was only th=
e
> very short time between unlocking that mutex and inserting the device
> item. The chunk allocation rework moved the device item updates to phase
> 1, under the protection of the chunk_mutex only, so the window now also
> covers the sysfs registration and the system space reservation done by
> btrfs_add_dev_item(), which must take the chunk_mutex itself and so can
> end up waiting for the very chunk allocation that is going to fail.
>
> Fix this by deferring everything that makes the new device usable by
> the chunk allocator until btrfs_add_dev_item() has inserted its device
> item in the chunk btree: adding it to the allocation list, accounting
> its space in free_chunk_space, clearing the full flags of the space
> infos and updating the per profile available space.
>
> When sprouting a seed filesystem, keep doing this before inserting the
> device item, because init_first_rw_device() has to allocate chunks from
> the new device first. That is safe because a seed filesystem is
> read-only and we are holding sb->s_umount, so nothing else can be
> allocating chunks.
>

The approach seems correct to me, but there are a few tweaks that
sashiko found and should be addressed as Qu mentioned before:

https://sashiko.dev/#/patchset/20261023-btrfs-device-add-race-v1-1-90cf05e8=
128f%40external.gene.com

> Fixes: 79bd37120b14 ("btrfs: rework chunk allocation to avoid exhaustion =
of the system chunk array")

So as you mentioned in one paragraph above, the race actually existed
before that commit, but it was simply much less likely to happen due
to a much shorter window.
So technically that commit did not introduce the problem, only
significantly increased the time window where the race could happen.

As far as I can see, the proposed fix would also fix the problem
before that commit.

The race seems to be very very very old, maybe introduced in
788f20eb5aff ("Btrfs: Add new ioctl to add devices") or in
0b86a832a1f3 ("Btrfs: Add support for multiple devices per
filesystem").
Though I'm not sure what should be in the Fixes tag, maybe just leave
the stable cc tag with 5.15 or the oldest supported stable series 5.10
(and see if it's easy to backport there).

Thanks.



> CC: stable@vger.kernel.org # 5.15+
> Assisted-by: LLM
> Signed-off-by: Stanislav Zubenko <zubenkos@external.gene.com>
> ---
>  fs/btrfs/volumes.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6574939e1..bc8ffa7bb 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3066,15 +3066,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>
>         mutex_lock(&fs_info->chunk_mutex);
>         list_add_rcu(&device->dev_list, &fs_devices->devices);
> -       list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
>         fs_devices->num_devices++;
>         fs_devices->open_devices++;
>         fs_devices->rw_devices++;
>         fs_devices->total_devices++;
>         fs_devices->total_rw_bytes +=3D device->total_bytes;
>
> -       atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
> -
>         if (bdev_rot(device->bdev))
>                 fs_devices->rotating =3D true;
>
> @@ -3088,12 +3085,20 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>                                     orig_super_num_devices + 1);
>
>         /*
> -        * we've got more storage, clear any full flags on the space
> -        * infos
> +        * The chunk allocator must not use the new device before its dev=
ice
> +        * item is in the chunk btree, otherwise allocating a chunk on it=
 fails
> +        * to update that item with -ENOENT and aborts the transaction.
> +        * Sprouting is the exception: init_first_rw_device() must alloca=
te from
> +        * the new device before its item can be inserted, and nothing el=
se can
> +        * allocate chunks since a seed filesystem is read-only and we ar=
e
> +        * holding sb->s_umount.
>          */
> -       btrfs_clear_space_info_full(fs_info);
> -
> -       btrfs_update_per_profile_avail(fs_info);
> +       if (seeding_dev) {
> +               list_add(&device->dev_alloc_list, &fs_devices->alloc_list=
);
> +               atomic64_add(device->total_bytes, &fs_info->free_chunk_sp=
ace);
> +               btrfs_clear_space_info_full(fs_info);
> +               btrfs_update_per_profile_avail(fs_info);
> +       }
>         mutex_unlock(&fs_info->chunk_mutex);
>
>         /* Add sysfs device entry */
> @@ -3134,6 +3139,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs=
_info, const char *device_path
>                  * its fsid has been changed by btrfs_sprout_splice().
>                  */
>                 btrfs_sysfs_update_sprout_fsid(fs_devices);
> +       } else {
> +               mutex_lock(&fs_info->chunk_mutex);
> +               list_add(&device->dev_alloc_list, &fs_devices->alloc_list=
);
> +               atomic64_add(device->total_bytes, &fs_info->free_chunk_sp=
ace);
> +               btrfs_clear_space_info_full(fs_info);
> +               btrfs_update_per_profile_avail(fs_info);
> +               mutex_unlock(&fs_info->chunk_mutex);
>         }
>
>         ret =3D btrfs_commit_transaction(trans);
> @@ -3190,13 +3202,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>         if (!list_empty(&device->post_commit_list))
>                 list_del_init(&device->post_commit_list);
>         list_del_rcu(&device->dev_list);
> -       list_del(&device->dev_alloc_list);
> +       if (!list_empty(&device->dev_alloc_list)) {
> +               list_del_init(&device->dev_alloc_list);
> +               atomic64_sub(device->total_bytes, &fs_info->free_chunk_sp=
ace);
> +       }
>         fs_info->fs_devices->num_devices--;
>         fs_info->fs_devices->open_devices--;
>         fs_info->fs_devices->rw_devices--;
>         fs_info->fs_devices->total_devices--;
>         fs_info->fs_devices->total_rw_bytes -=3D device->total_bytes;
> -       atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
>         btrfs_set_super_total_bytes(fs_info->super_copy,
>                                     orig_super_total_bytes);
>         btrfs_set_super_num_devices(fs_info->super_copy,
>
> ---
> base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
> change-id: 20261023-btrfs-device-add-race-d8c4f1c3ed84
>
> Best regards,
> --
> Stanislav Zubenko <zubenkos@external.gene.com>
>
>
>
