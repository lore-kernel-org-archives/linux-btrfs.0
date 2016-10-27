Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942696AbcJ0OYQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 10:24:16 -0400
Date: Thu, 27 Oct 2016 19:25:27 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: make 17[1-4] work well when btrfs
 compression is enabled
Message-ID: <20161027112527.GE27776@eguan.usersys.redhat.com>
References: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 05:52:11PM +0800, Wang Xiaoguang wrote:
> When enabling btrfs compression, original codes can not fill fs
> correctly, here we introduce _fill_fs() in common/rc, which'll keep
> creating and writing files until enospc error occurs. Note _fill_fs
> is copied from tests/generic/256, but with some minor modifications.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Looks fine to me overall, generic/17[1-4] and generic/256 passed on xfs,
btrfs and btrfs with compress. But I'd like Darrick to review it as well :)

> ---
> V2: In common/, I did't find an existing function suitable for
>     these 4 test cases to fill fs, so I still use _pwrite_byte() with
>     a big enough file length fo fill fs. Note, for btrfs, metadata space
>     still is not full, only data space is full, but it's OK for these
>     4 test cases.
> 
>     All these 4 cases pass in xfs and btrfs(without compression), if
>     btrfs has compression enabled, these 4 cases will fail for false
>     enospc error, I have sent kernel patches to fix this bug.
> 
> V3: Introduce  _fill_fs in common/rc to fill fs.
> ---
>  common/rc         | 50 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/171 |  4 +---
>  tests/generic/172 |  4 ++--
>  tests/generic/173 |  4 +---
>  tests/generic/174 |  4 +---
>  tests/generic/256 | 65 +++++--------------------------------------------------
>  6 files changed, 60 insertions(+), 71 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 7a9fc90..0e1ac5d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4003,6 +4003,56 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +# Fill a file system by repeatedly creating files in the given folder
> +# starting with the given file size.  Files are reduced in size when
> +# they can no longer fit until no more files can be created.
> +_fill_fs()
> +{
> +	local file_size=$1
> +	local dir=$2
> +	local block_size=$3
> +	local switch_user=$4
> +	local file_count=1
> +	local bytes_written=0
> +
> +	if [ $# -ne 4 ]; then
> +		echo "Usage: _fill_fs filesize dir blocksize"

The usage info here is wrong, missing the "switch user" argument.

Thanks,
Eryu
