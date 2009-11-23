From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 1/2] btrfs-progs: multidevice support for check_mounted
Date: Mon, 23 Nov 2009 10:01:43 +0100
Message-ID: <20091123090143.GB10852@nb.net.home>
References: <200911211533.25878.lists-receive@programmierforen.de> <200911211538.38351.lists-receive@programmierforen.de> <20091121202109.GD16301@nb.net.home> <200911221433.13074.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911221433.13074.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 22, 2009 at 02:33:13PM +0100, Andi Drebes wrote:
> In the new patch below, is_pseudo_fs() is replaced by
> is_existing_blk_or_reg_file(). We ignore entries associated with an
> invalid path or paths that don't point to a regular or block file.
> However, if a path used in a pseudo-filesystem entry points to the
> file that is being checked, check_mounted() returns 1. In my eyes,
> this is extremely unlikely.
...
> +/* Checks if a file exists and is a block or regular file*/
> +int is_existing_blk_or_reg_file(const char* filename)
> +{
> +	struct stat st_buf;
> +
> +	if(stat(filename, &st_buf) < 0) {
> +		if(errno == ENOENT)
> +			return 0;
> +		else
> +			return -errno;
> +	}
> +
> +	return (S_ISBLK(st_buf.st_mode) || S_ISREG(st_buf.st_mode));
> +}

 Yes, this looks better.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
