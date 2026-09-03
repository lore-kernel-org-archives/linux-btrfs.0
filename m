Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730039CD0C
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788427220; cv=pass; b=YMcNT0bvKICDjGE1WSX1efFjYhzwSdDVzlU8M15vm6ZHbRsev2opnI4T6D7IlxSJbJdxYtNP2t4mXFQmp/xm6OwoetCRYZwyCkODDDlb3BmDqfDKKVltAhqXDYyW0TkbCJtfNjYEAPw+kOKfsT18xwz8GMf9UXN/v97nmAlutgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788427220; c=relaxed/simple;
	bh=+PBGpyE7KvwHG/NjjEl6RxkEQBpT3FIXnKYMN1sfw98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MV4/P+4RY2usqFCLkbRSd3BgeBhbspF0tMLL47waujDss2iNXx0dH4kvYT85S0rlAwDe8qRxHKpvqhALLH4Ck8QIJ9hK9D3QNyMTZSxhTAlmkBjbnLJxHBUzZvzWvFSvLEVsMbLCdGnS9EqNfmvw1qUflyY6XCwrZd035QENzYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Jd6IOXgt; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Jd6IOXgt"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso15396535e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 02:20:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788427212; cv=none;
        d=google.com; s=arc-20260327;
        b=hjPjzPLoe++p68Q/DA8+Yk++YwaHvIDWz0I8i4P66ugwzrMYH160hsrQi9ihLkuVIZ
         oKmRSulY/x88NqYqdZmxbxm8ukZcyqi/nwOMqJFT5hfFoF3U93Evyw8ju+S1NHCYcBW/
         XUJWxV8chawm3G+0QbGyc4wRw1E9KQFFr+rSYG0nUTqqvEjCiEDkwizNpfA2iYTqy4S0
         xKqC3V1R4wZbwkmnfzpJNNeL80I8In5t/s9Zv00NnLN1psBa2A3W6DsN9moWC1GBQ2Kf
         yooa0yij84JubLqVmZ0pAC05iqYf+c9/be1mEwKGg2Y/LF+dXwxHLYAFu5wKzfTj+tfO
         Hf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uckpNnSnOun6MfyPMFtZP8oL0b6uLiacAEuGpWpDKsg=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=rFblE7JdjW/V4z31GqgiqQzEeLSdG6bec0PxgAsGnmL1gfwof4qlYGt2lwb8YeO244
         xc4s2nFbLNXlE72ApYjlar0cIXe2Z6nuEg+UJCsNM3Tao9oTFW8RPksPqV1IAU9KGPjp
         8TDSEd2gix782YCGKmX2Kl/JYYVI1b2KA0/05s6l0xT/O3AiFyjD/px9ERL7I8pZk09d
         iyyMQeYVTtsDYz5T26zE3IdPd7qaE4AukJyLAGq4lJ/PHvBwydMowGwl1awG/g+uxYZ+
         cd270X9qf2MQd2DWZJ1fM1exyuj1A1MvXedxrVAZwPRMQmlEIDrd3McXSnTctqMgPVKE
         vWxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788427212; x=1789032012; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uckpNnSnOun6MfyPMFtZP8oL0b6uLiacAEuGpWpDKsg=;
        b=Jd6IOXgtjBXPjDkuEU+pPwFim2OxHcIX8PNnrXGHI0wz9vquu7sMBh9OYYwVr0GdW4
         zxu2BwLf4vR7dvsONxr9/XZJ6YeGNGHxtOmyF2HYjSdxXmgsrMCScaxfI8n0dOtfCdtd
         qlVC9OxmZTc/plqIQRqu/d/1FNNCv4Cs+IeEMD/kTmuyqw5mNaKCXRY815bgwafyup5O
         y5Aaubb4sdEnPO4Gf7xQWE5mYAec+nM7GU3wolKoytmc8/zd/es10ddbTvqT9rZ2xQcV
         njgQIIzAL18pHY/W+8nKw08Twm8SHbaHtymDWzifMU1UFUWSyG6uwkwwcn6cdjyOipEZ
         2K6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788427212; x=1789032012;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uckpNnSnOun6MfyPMFtZP8oL0b6uLiacAEuGpWpDKsg=;
        b=LYgHdoT7a74Ibn5D9Tm7ZHpYNyvm8LRoSc1oL+uCZ1b8VbvVIxUVaMZytrD163ECIS
         /CX1/jJR7Altmv3SGy6+Bqp316PR3IJQJjzHcK8gMhq+5Arv4IoBRaLkpSdDueTcN+5m
         yFdtwojaRmO3X4Yzt7SiIbM0+m6z5rlRSXIm+LTLfTWTm1vO2VYIzijeM9SR2nU4XxY+
         RVc3oVsimNvICRVXBw3/e2M/eaO913cR6iB0+TMAwWGV0CE4AJchB6rRWYqPy36uM4vH
         meXVWbPedRbgGA/C5r+SwouMf+E8ARUW4lTyzLz6dkuzRA2y66RMLgmegH4HezA0EkOB
         uwHQ==
X-Gm-Message-State: AFuF++kSelbKs6NE/tKtD0E6ylmoW8T1blgoS39yDdUle4yHYV+AMY9u
	hUM5mZc+TVw5KXamd0ya46b9L238RXr22QK4V34L8LyILBm7drHrPuy1+HMkq2hELef5ooizFRk
	IlpzckpsC+88UwsSZSVXc2jpNxZOBXCUJCt+u+8ZUZQ==
X-Gm-Gg: AYBFou3g1Zq7gyAOz2bx0X75jmzU56e1Uf5/rGGcIAc8OgmEtRYCEmv02RUI7Avye0N
	rBjeMLfr4qeHK9zs7zOCBo9/F+b6VlINdkpSwWj5M9TJQ4w+i/0+XaM9AvTVQsuAXg4pf8vS4TP
	Ubb3vNkrXh3wwRJkwpp5tROLlZKGeu4l+doGbbKNJHUc385sVS5ehf9vnJisoDn14tsl8DP9lAV
	6OwprB4D0Qk3uz6LmrJs/2paoNR8wYyJpCdVncDhhF0rO5/B4ZcQEeMpgG1YIMhXrKi0g8mc1/q
	8+D/VVN/B3Wv2U3+u1wcWJlKtDbY41M4RvsWU6crMsHgcPM/pKilQSpnDdnYNDYV4Kh1GfsjNY2
	I4+fa1noa51E4VbJiB/rOZCgL2jJ0qi/4waUL3bWYAQ==
X-Received: by 2002:a05:600c:3f08:b0:49c:e1ed:26b1 with SMTP id
 5b1f17b1804b1-49ce5850cefmr204823095e9.16.1788427211752; Thu, 03 Sep 2026
 02:20:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
In-Reply-To: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 11:20:00 +0200
X-Gm-Features: AcwNN1VbI7yXZ0f1eKxFuqwj-UirzG9QsbGmGJlStLgvl7R16vb6BFY-BsuHuzE
Message-ID: <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
> introduced asynchronous data checksum generation for data writes.
>
> That feature can improve write performance, and was introduced in v6.19.
> We have not experienced bugs related to that, so it's time to move it out
> of experimental features for end users.
>
> Furthermore since the async checksum generation means
> should_async_write() will always return false, we no longer need to
> maintain the fs_info->workers workqueue, as the async checksum
> generation is using the system_percpu_wq.

I understand these are two related changes in one patch here. If
removing async writes depends on async checksums, it would be nice to
split this into a patch series.

Though I guess can live with that. Looks good enough to me.

Reviewed-by: Daniel Vacek <neelx@suse.com>

> Suggested-by: Daniel Vacek <neelx@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/bio.c       | 136 +------------------------------------------
>  fs/btrfs/disk-io.c   |  20 +------
>  fs/btrfs/file-item.c |   6 +-
>  fs/btrfs/file-item.h |   2 +-
>  fs/btrfs/fs.h        |  10 ----
>  fs/btrfs/super.c     |   1 -
>  6 files changed, 4 insertions(+), 171 deletions(-)
>
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 771b7d598aee..e08006543c3d 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
>  {
>         if (bbio->bio.bi_opf & REQ_META)
>                 return btree_csum_one_bio(bbio);
> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> -       return btrfs_csum_one_bio(bbio, true);
> -#else
> -       return btrfs_csum_one_bio(bbio, false);
> -#endif
> -}
> -
> -/*
> - * Async submit bios are used to offload expensive checksumming onto the worker
> - * threads.
> - */
> -struct async_submit_bio {
> -       struct btrfs_bio *bbio;
> -       struct btrfs_io_context *bioc;
> -       struct btrfs_io_stripe smap;
> -       int mirror_num;
> -       struct btrfs_work work;
> -};
> -
> -/*
> - * In order to insert checksums into the metadata in large chunks, we wait
> - * until bio submission time.   All the pages in the bio are checksummed and
> - * sums are attached onto the ordered extent record.
> - *
> - * At IO completion time the csums attached on the ordered extent record are
> - * inserted into the btree.
> - */
> -static void run_one_async_start(struct btrfs_work *work)
> -{
> -       struct async_submit_bio *async =
> -               container_of(work, struct async_submit_bio, work);
> -       int ret;
> -
> -       ret = btrfs_bio_csum(async->bbio);
> -       if (ret)
> -               async->bbio->bio.bi_status = errno_to_blk_status(ret);
> -}
> -
> -/*
> - * In order to insert checksums into the metadata in large chunks, we wait
> - * until bio submission time.   All the pages in the bio are checksummed and
> - * sums are attached onto the ordered extent record.
> - *
> - * At IO completion time the csums attached on the ordered extent record are
> - * inserted into the tree.
> - *
> - * If called with @do_free == true, then it will free the work struct.
> - */
> -static void run_one_async_done(struct btrfs_work *work, bool do_free)
> -{
> -       struct async_submit_bio *async =
> -               container_of(work, struct async_submit_bio, work);
> -       struct bio *bio = &async->bbio->bio;
> -
> -       if (do_free) {
> -               kfree(container_of(work, struct async_submit_bio, work));
> -               return;
> -       }
> -
> -       /* If an error occurred we just want to clean up the bio and move on. */
> -       if (bio->bi_status) {
> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
> -               return;
> -       }
> -
> -       /*
> -        * All of the bios that pass through here are from async helpers.
> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgroup's
> -        * context.  This changes nothing when cgroups aren't in use.
> -        */
> -       bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
> -}
> -
> -static bool should_async_write(struct btrfs_bio *bbio)
> -{
> -       struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
> -       bool auto_csum_mode = true;
> -
> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> -       /*
> -        * Write bios will calculate checksum and submit bio at the same time.
> -        * Unless explicitly required don't offload serial csum calculate and bio
> -        * submit into a workqueue.
> -        */
> -       return false;
> -#endif
> -
> -       /* Submit synchronously if the checksum implementation is fast. */
> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags))
> -               return false;
> -
> -       /*
> -        * Try to defer the submission to a workqueue to parallelize the
> -        * checksum calculation unless the I/O is issued synchronously.
> -        */
> -       if (op_is_sync(bbio->bio.bi_opf))
> -               return false;
> -
> -       /* Zoned devices require I/O to be submitted in order. */
> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
> -               return false;
> -
> -       return true;
> -}
> -
> -/*
> - * Submit bio to an async queue.
> - *
> - * Return true if the work has been successfully submitted, else false.
> - */
> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> -                               struct btrfs_io_context *bioc,
> -                               struct btrfs_io_stripe *smap, int mirror_num)
> -{
> -       struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
> -       struct async_submit_bio *async;
> -
> -       async = kmalloc_obj(*async, GFP_NOFS);
> -       if (!async)
> -               return false;
> -
> -       async->bbio = bbio;
> -       async->bioc = bioc;
> -       async->smap = *smap;
> -       async->mirror_num = mirror_num;
> -
> -       btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
> -       btrfs_queue_work(fs_info->workers, &async->work);
> -       return true;
> +       return btrfs_csum_one_bio(bbio);
>  }
>
>  static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_length)
> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>                 if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>                     !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
>                     !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
> -                       if (should_async_write(bbio) &&
> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
> -                               goto done;
> -
>                         ret = btrfs_bio_csum(bbio);
>                         status = errno_to_blk_status(ret);
>                         if (status)
> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>         }
>
>         btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> -done:
>         return map_length == length;
>
>  fail:
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a1d83ad9a4c0..0046f3cb75a1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>         if (fs_info->fixup_workers)
>                 destroy_workqueue(fs_info->fixup_workers);
>         btrfs_destroy_workqueue(fs_info->delalloc_workers);
> -       btrfs_destroy_workqueue(fs_info->workers);
>         if (fs_info->endio_workers)
>                 destroy_workqueue(fs_info->endio_workers);
>         if (fs_info->rmw_workers)
> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>         unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>         unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
>
> -       fs_info->workers =
> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
> -
>         fs_info->delalloc_workers =
>                 btrfs_alloc_workqueue(fs_info, "delalloc",
>                                       flags, max_active, 2);
> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>         fs_info->discard_ctl.discard_workers =
>                 alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
>
> -       if (!(fs_info->workers &&
> -             fs_info->delalloc_workers && fs_info->flush_workers &&
> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
>               fs_info->endio_workers && fs_info->endio_meta_workers &&
>               fs_info->endio_write_workers &&
>               fs_info->endio_freespace_worker && fs_info->rmw_workers &&
> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>          */
>         btrfs_flush_workqueue(fs_info->delalloc_workers);
>
> -       /*
> -        * We can have ordered extents getting their last reference dropped from
> -        * the fs_info->workers queue because for async writes for data bios we
> -        * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
> -        * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
> -        * has an error, and that later function can do the final
> -        * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
> -        * which adds a delayed iput for the inode. So we must flush the queue
> -        * so that we don't have delayed iputs after committing the current
> -        * transaction below and stopping the cleaner and transaction kthreads.
> -        */
> -       btrfs_flush_workqueue(fs_info->workers);
> -
>         /*
>          * When finishing a compressed write bio we schedule a work queue item
>          * to finish an ordered extent - end_bbio_compressed_write()
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 0fed4e0d32d5..7dbd9b8eec11 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct *work)
>  /*
>   * Calculate checksums of the data contained inside a bio.
>   */
> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>  {
>         struct btrfs_ordered_extent *ordered = bbio->ordered;
>         struct btrfs_inode *inode = bbio->inode;
> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>         btrfs_add_ordered_sum(ordered, sums);
>
>         bbio->csum_saved_iter = bio->bi_iter;
> -       if (!async) {
> -               csum_one_bio(bbio);
> -               return 0;
> -       }
>         bio_inc_remaining(bio);
>         INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>         schedule_work(&bbio->csum_work);
> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> index 6c678787c770..60a0eb17b3f6 100644
> --- a/fs/btrfs/file-item.h
> +++ b/fs/btrfs/file-item.h
> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>  int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>                             struct btrfs_root *root,
>                             struct btrfs_ordered_sum *sums);
> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>  int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>  int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>                              struct list_head *list, int search_commit,
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 3eba8438593c..203f7131f737 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
>         /* All fs/file tree roots that have delalloc inodes. */
>         struct list_head delalloc_roots;
>
> -       /*
> -        * There is a pool of worker threads for checksumming during writes and
> -        * a pool for checksumming after reads.  This is because readers can
> -        * run with FS locks held, and the writers may be waiting for those
> -        * locks.  We don't want ordering in the pending list to cause
> -        * deadlocks, and so the two are serviced separately.
> -        *
> -        * A third pool does submit_bio to avoid deadlocking with the other two.
> -        */
> -       struct btrfs_workqueue *workers;
>         struct btrfs_workqueue *delalloc_workers;
>         struct btrfs_workqueue *flush_workers;
>         struct workqueue_struct *endio_workers;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 464129b1b0d4..54f2da47c567 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>         btrfs_info(fs_info, "resize thread pool %d -> %d",
>                old_pool_size, new_pool_size);
>
> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
>         btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
>         btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
>         workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
> --
> 2.55.0
>
