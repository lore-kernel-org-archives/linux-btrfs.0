Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:46867 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeBWG2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 01:28:05 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 4A885AC01B3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 15:27:58 +0900 (JST)
Subject: Re: [PATCH v2 07/27] libbtrfsutil: add btrfs_util_subvolume_path()
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
 <af89178dc6f35fe6a807aec6fecc0611ae99b3fb.1518720598.git.osandov@fb.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <0452f2f6-02c5-7cb8-6a20-e1a65de096db@jp.fujitsu.com>
Date: Fri, 23 Feb 2018 15:27:52 +0900
MIME-Version: 1.0
In-Reply-To: <af89178dc6f35fe6a807aec6fecc0611ae99b3fb.1518720598.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/02/16 4:04, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

> +PUBLIC enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
> +							  char **path_ret)
> +{
> +	char *path, *p;
> +	size_t capacity = 4096;
> +
> +	path = malloc(capacity);
> +	if (!path)
> +		return BTRFS_UTIL_ERROR_NO_MEMORY;
> +	p = path + capacity - 1;
> +	p[0] = '\0';
> +
> +	if (id == 0) {
> +		enum btrfs_util_error err;
> +
> +		err = btrfs_util_is_subvolume_fd(fd);
> +		if (err)
> +			return err;

'path' should be freed here and below.

> +
> +		err = btrfs_util_subvolume_id_fd(fd, &id);
> +		if (err)
> +			return err;
> +	}
> +
> +	while (id != BTRFS_FS_TREE_OBJECTID) {
> +		struct btrfs_ioctl_search_args search = {
> +			.key = {
> +				.tree_id = BTRFS_ROOT_TREE_OBJECTID,
> +				.min_objectid = id,
> +				.max_objectid = id,
> +				.min_type = BTRFS_ROOT_BACKREF_KEY,
> +				.max_type = BTRFS_ROOT_BACKREF_KEY,
> +				.min_offset = 0,
> +				.max_offset = UINT64_MAX,
> +				.min_transid = 0,
> +				.max_transid = UINT64_MAX,
> +				.nr_items = 1,
> +			},
> +		};
> +		struct btrfs_ioctl_ino_lookup_args lookup;
> +		const struct btrfs_ioctl_search_header *header;
> +		const struct btrfs_root_ref *ref;
> +		const char *name;
> +		uint16_t name_len;
> +		size_t lookup_len;
> +		size_t total_len;
> +		int ret;
> +
> +		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search);
> +		if (ret == -1) {
> +			free(path);
> +			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
> +		}
> +
> +		if (search.key.nr_items == 0) {
> +			free(path);
> +			errno = ENOENT;
> +			return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
> +		}
> +
> +		header = (struct btrfs_ioctl_search_header *)search.buf;
> +		ref = (struct btrfs_root_ref *)(header + 1);
> +		name = (char *)(ref + 1);
> +		name_len = le16_to_cpu(ref->name_len);
> +
> +		id = header->offset;
> +
> +		lookup.treeid = id;
> +		lookup.objectid = le64_to_cpu(ref->dirid);
> +		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &lookup);
> +		if (ret == -1) {
> +			free(path);
> +			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
> +		}
> +		lookup_len = strlen(lookup.name);
> +
> +		total_len = name_len + lookup_len + (id != BTRFS_FS_TREE_OBJECTID);
> +		if (p - total_len < path) {
> +			char *new_path, *new_p;
> +			size_t new_capacity = capacity * 2;
> +
> +			new_path = malloc(new_capacity);
> +			if (!new_path) {
> +				free(path);
> +				return BTRFS_UTIL_ERROR_NO_MEMORY;
> +			}
> +			new_p = new_path + new_capacity - (path + capacity - p);
> +			memcpy(new_p, p, path + capacity - p);
> +			free(path);
> +			path = new_path;
> +			p = new_p;
> +			capacity = new_capacity;
> +		}
> +		p -= name_len;
> +		memcpy(p, name, name_len);
> +		p -= lookup_len;
> +		memcpy(p, lookup.name, lookup_len);
> +		if (id != BTRFS_FS_TREE_OBJECTID)
> +			*--p = '/';
> +	}
> +
> +	if (p != path)
> +		memmove(path, p, path + capacity - p);
> +
> +	*path_ret = path;
> +
> +	return BTRFS_UTIL_OK;
> +}
> +
>  static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
>  						    char *name, size_t name_len,
>  						    int *fd)
> 

