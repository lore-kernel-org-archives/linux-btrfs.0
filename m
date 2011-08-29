From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: check file extent backref offset underflow
Date: Mon, 29 Aug 2011 09:59:13 +0800
Message-ID: <4E5AF271.9040606@cn.fujitsu.com>
References: <4E5AEAA1.1070200@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5AEAA1.1070200@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:
> Offset field in data extent backref can underflow if clone range ioctl
> is used. We can reliably detect the underflow because max file size is
> limited to 2^63 and max data extent size is limited by block group size.
> 
> Signed-off-by: Zheng Yan  <zheng.z.yan@intel.com>

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

...
> @@ -3323,8 +3323,11 @@ static int find_data_references(struct reloc_control *rc,
>  	}
>  
>  	key.objectid = ref_objectid;
> -	key.offset = ref_offset;
>  	key.type = BTRFS_EXTENT_DATA_KEY;
> +	if (ref_offset > ((u64)-1 << 32))
> +		key.offset = 0;
> +	else
> +		key.offset = ref_offset;

This needs comment, as we're working around a corner case and a magic number is
used.

>  
>  	path->search_commit_root = 1;
>  	path->skip_locking = 1;
> --
