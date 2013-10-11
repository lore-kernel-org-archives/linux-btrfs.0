Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3JKRci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 13:32:38 -0400
Date: Fri, 11 Oct 2013 10:32:35 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: init device stats for new devices
Message-ID: <20131011173235.GS25712@lenny.home.zabbo.net>
References: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 646d10d..9837439 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2041,6 +2041,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	device->in_fs_metadata = 1;
>  	device->is_tgtdev_for_dev_replace = 0;
>  	device->mode = FMODE_EXCL;
> +	device->dev_stats_valid = 1;
>  	set_blocksize(device->bdev, 4096);

Doesn't valid mean that the in-memory atomics reflect the counts in the
btree items?  Am I misunderstanding?

Seems like a reproducer would be: get non-zero stats, unmount, mount,
get stats strictly >=.

- z
