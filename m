Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24818 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbcE1QGy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 12:06:54 -0400
Subject: Re: [PATCH] btrfs: Use __u64 in exported linux/btrfs.h.
To: Vinson Lee <vlee@freedesktop.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?B?R2FicsOtZWwgQXJ0aMO6ciBQw6l0dXJzc29u?=
	<gabriel@system.is>
References: <1464419078-19855-1-git-send-email-vlee@freedesktop.org>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5749C223.5090204@oracle.com>
Date: Sun, 29 May 2016 00:06:59 +0800
MIME-Version: 1.0
In-Reply-To: <1464419078-19855-1-git-send-email-vlee@freedesktop.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 05/28/2016 03:04 PM, Vinson Lee wrote:
> This patch fixes this build error.
>
> /usr/include/linux/btrfs.h:121:3: error: unknown type name ‘u64’
>     u64 devid;
>     ^~~

  Thanks for fixing this.

-Anand


> Fixes: 6b526ed70cf1 ("btrfs: introduce device delete by devid")
> Signed-off-by: Vinson Lee <vlee@freedesktop.org>
> ---
>   include/uapi/linux/btrfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 23c6960e94a4..2bdd1e3e7007 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -118,7 +118,7 @@ struct btrfs_ioctl_vol_args_v2 {
>   	};
>   	union {
>   		char name[BTRFS_SUBVOL_NAME_MAX + 1];
> -		u64 devid;
> +		__u64 devid;
>   	};
>   };
>
>
