Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:46129 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3KGJda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 04:33:30 -0500
Message-ID: <527B5E6C.9000506@giantdisaster.de>
Date: Thu, 07 Nov 2013 10:33:32 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented
 ordered execution based on kernel workqueue
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Nov 2013 13:51:52 +0800, Qu Wenruo wrote:
> Use kernel workqueue to implement a new btrfs_workqueue_struct, which
> has the ordering execution feature like the btrfs_worker.
> 
> The func is executed in a concurrency way, and the
> ordred_func/ordered_free is executed in the sequence them are queued
> after the corresponding func is done.
> The new btrfs_workqueue use 2 workqueues to implement the original
> btrfs_worker, one for the normal work and one for ordered work.
> 
> At this patch, high priority work queue or thresholding is not added yet.
> The high priority feature and thresholding will be added in the following patches.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
[...]
> diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
> index 1f26792..eee6709 100644
> --- a/fs/btrfs/async-thread.h
> +++ b/fs/btrfs/async-thread.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2007 Oracle.  All rights reserved.
> + * Copyright (C) 2013 Fujitsu.  All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public
> @@ -118,4 +119,47 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
>  			struct btrfs_workers *async_starter);
>  void btrfs_requeue_work(struct btrfs_work *work);
>  void btrfs_set_work_high_prio(struct btrfs_work *work);
> +
> +struct btrfs_workqueue_struct {
> +	struct workqueue_struct *normal_wq;
> +	struct workqueue_struct *ordered_wq;
> +
> +	/*
> +	 * Spinlock to ensure that both ordered and normal work can
> +	 * be inserted to each workqueue at the same sequance,
> +	 * which will reduce the ordered_work waiting time and disk head moves.
> +	 */
> +	spinlock_t insert_lock;
> +};
> +
> +struct btrfs_work_struct {
> +	void (*func)(struct btrfs_work_struct *arg);
> +	void (*ordered_func)(struct btrfs_work_struct *arg);
> +	void (*ordered_free)(struct btrfs_work_struct *arg);
> +
> +	/* Don't touch things below */
> +	struct work_struct normal_work;
> +	struct work_struct ordered_work;
> +	struct completion normal_completion;
> +};

If you compare the Btrfs sources before applying your patchset and after
applying all 17 patches, one change is this:
-struct btrfs_work {
+struct btrfs_work_struct {

Which causes changes s/struct btrfs_work/struct btrfs_work_struct/ like
in patch 16/17:
-	struct btrfs_work	work;
+	struct btrfs_work_struct
+				work;

-static void scrub_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_bio_end_io_worker(struct btrfs_work_struct *work);

I just don't see any good reason for renaming 'struct foo' to 'struct
foo_struct'.


