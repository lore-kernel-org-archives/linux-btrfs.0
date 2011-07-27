From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v7 1/8] btrfs: added helper functions to iterate backrefs
Date: Wed, 27 Jul 2011 15:59:05 +0800
Message-ID: <4E2FC549.90303@cn.fujitsu.com>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net> <c821ea4b363f4894b421a51d882c1f2b6c2eae00.1311333004.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c821ea4b363f4894b421a51d882c1f2b6c2eae00.1311333004.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

> +struct btrfs_data_container *init_data_container(s32 total_bytes)
> +{
> +	struct btrfs_data_container *data;
> +	unsigned long alloc_bytes;
> +
> +	if (total_bytes < 0)
> +		return ERR_PTR(-EINVAL);
> +
> +	alloc_bytes = max((unsigned long)total_bytes, sizeof(*data));

The return type of sizeof() is unsigned int, so this will cause compile
warning.

We can use max_t() instead.

> +	data = kmalloc(alloc_bytes, GFP_NOFS);
> +	if (!data)
> +		return ERR_PTR(-ENOMEM);
> +
> +	data->size = total_bytes - sizeof(*data);
> +	data->elem_cnt = 0;
> +	data->elem_missed = 0;
> +
> +	return data;
> +}
