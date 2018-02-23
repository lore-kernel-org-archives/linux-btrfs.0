Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:55817 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWC0p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 21:26:45 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 696F2AC01C5
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 11:26:40 +0900 (JST)
Subject: Re: [PATCH v2 26/27] btrfs-progs: use libbtrfsutil for subvolume list
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
 <6492726d6e89bf792627e4431f7ba7691f09c3d2.1518720598.git.osandov@fb.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <2bbba01e-1c72-90ae-a7b5-56b341ec1c1a@jp.fujitsu.com>
Date: Fri, 23 Feb 2018 11:26:35 +0900
MIME-Version: 1.0
In-Reply-To: <6492726d6e89bf792627e4431f7ba7691f09c3d2.1518720598.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/02/16 4:05, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

> +static struct subvol_list *btrfs_list_deleted_subvols(int fd,
> +						      struct btrfs_list_filter_set *filter_set)
> +{
> +	struct subvol_list *subvols = NULL;
> +	uint64_t *ids = NULL;
> +	size_t i, n;
> +	enum btrfs_util_error err;
> +	int ret = -1;
> +
> +	err = btrfs_util_deleted_subvolumes_fd(fd, &ids, &n);
> +	if (err) {
> +		error_btrfs_util(err);
> +		return NULL;
> +	}
> +
> +	subvols = malloc(sizeof(*subvols) + n * sizeof(subvols->subvols[0]));
> +	if (!subvols) {
> +		error("out of memory");
> +		goto out;
> +	}
> +
> +	subvols->num = 0;
> +	for (i = 0; i < n; i++) {
> +		struct listed_subvol *subvol = &subvols->subvols[subvols->num];
> +
> +		err = btrfs_util_subvolume_info_fd(fd, ids[i], &subvol->info);
> +		if (err) {

I think there is a small chance that subvolume would be removed from tree between 
btrfs_util_deleted_subvolumes_fd() and btrfs_util_subvolume_info_fd().
So, error of BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND should be ignored.

> +			error_btrfs_util(err);
> +			goto out;
> +		}
> +
> +		subvol->path = strdup("DELETED");
> +		if (!subvol->path)
> +			goto out;
> +
> +		if (!filters_match(subvol, filter_set)) {
> +			free(subvol->path);
> +			continue;
> +		}
> +
> +		subvols->num++;
> +	}
> +
> +	ret = 0;
> +out:
> +	if (ret) {
> +		free_subvol_list(subvols);
> +		subvols = NULL;
> +		free(ids);
> +	}
> +	return subvols;
> +}

