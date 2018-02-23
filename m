Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:23269 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeBWHk5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 02:40:57 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A8729AC0105
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 16:40:50 +0900 (JST)
Subject: Re: [PATCH v2 11/27] libbtrfsutil: add subvolume iterator helpers
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
 <4cc1bad06e7e064dbf1af7a4e5b9d66ffe9c0913.1518720598.git.osandov@fb.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <2bd6c3a5-722f-412a-041c-66837bc21d73@jp.fujitsu.com>
Date: Fri, 23 Feb 2018 16:40:45 +0900
MIME-Version: 1.0
In-Reply-To: <4cc1bad06e7e064dbf1af7a4e5b9d66ffe9c0913.1518720598.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/02/16 4:04, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

> +PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator(const char *path,
> +								  uint64_t top,
> +								  int flags,
> +								  struct btrfs_util_subvolume_iterator **ret)
> +{
> +	enum btrfs_util_error err;
> +	int fd;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd == -1)
> +		return BTRFS_UTIL_ERROR_OPEN_FAILED;
> +
> +	err = btrfs_util_create_subvolume_iterator_fd(fd, top, flags, ret);
> +	if (err == BTRFS_UTIL_OK)
> +		(*ret)->flags |= BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD;

If btrfs_util_create_subvolume_iterator_fd() returns error, 'fd' remains open.
So, fd should be closed here.

> +
> +	return err;
> +}

