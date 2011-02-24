From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH] Btrfs: add ioctl to set compress or cow per file/dir
Date: Thu, 24 Feb 2011 11:37:52 -0700
Message-ID: <EE604399-9A36-4E16-82F5-659BA93413B5@dilger.ca>
References: <4D6627A7.7050001@cn.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D6627A7.7050001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-02-24, at 2:40 AM, liubo wrote:
>  #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
> +#define FS_NOCOW_FL			0x00200000 /* Do not cow file */
> +#define FS_COW_FL			0x00100000 /* Cow file */
>  #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */

I'm assuming that FS_COW_FL should not be the same as FS_DIRECTIO_FL?

Cheers, Andreas





