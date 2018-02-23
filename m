Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:63118 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeBWIYN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 03:24:13 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5B254AC0109
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 17:24:10 +0900 (JST)
Subject: Re: [PATCH v2 06/27] libbtrfsutil: add btrfs_util_create_subvolume()
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
 <afd80fc716f0242909ca573abdf0ba3ae432b6e4.1518720598.git.osandov@fb.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <3bbfd6e3-d89e-add3-3391-74802cbcdf6a@jp.fujitsu.com>
Date: Fri, 23 Feb 2018 17:24:04 +0900
MIME-Version: 1.0
In-Reply-To: <afd80fc716f0242909ca573abdf0ba3ae432b6e4.1518720598.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/02/16 4:04, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

> +static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
> +						    char *name, size_t name_len,
> +						    int *fd)
> +{
> +	char *tmp_path, *slash, *dirname, *basename;
> +	size_t len;
> +
> +	/* Ignore trailing slashes. */
> +	len = strlen(path);
> +	while (len > 1 && path[len - 1] == '/')
> +		len--;
> +
> +	tmp_path = malloc(len + 1);
> +	if (!tmp_path)
> +		return BTRFS_UTIL_ERROR_NO_MEMORY;
> +	memcpy(tmp_path, path, len);
> +	tmp_path[len] = '\0';
> +
> +	slash = memrchr(tmp_path, '/', len);
> +	if (slash == tmp_path) {
> +		dirname = "/";
> +		basename = tmp_path + 1;
> +	} else if (slash) {
> +		*slash = '\0';
> +		dirname = tmp_path;
> +		basename = slash + 1;
> +	} else {
> +		dirname = ".";
> +		basename = tmp_path;
> +	}
> +
> +	len = strlen(basename);
> +	if (len >= name_len) {
> +		errno = ENAMETOOLONG;

tmp_path should be also freed here.

> +		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
> +	}
> +	memcpy(name, basename, len);
> +	name[len] = '\0';
> +
> +	*fd = openat(dirfd, dirname, O_RDONLY | O_DIRECTORY);
> +	if (*fd == -1) {
> +		free(tmp_path);
> +		return BTRFS_UTIL_ERROR_OPEN_FAILED;
> +	}
> +
> +	free(tmp_path);
> +	return BTRFS_UTIL_OK;
> +}


