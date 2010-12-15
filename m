From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/5 v3] Btrfs: Add readonly support to replace BUG_ON
 phrase
Date: Wed, 15 Dec 2010 16:38:13 +0800
Message-ID: <4D087E75.3030901@cn.fujitsu.com>
References: <4CF8A73C.1060504@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	"Yan, Zheng" <zheng.z.yan@linux.intel.com>,
	Wenyi Liu <qingshenlwy@gmail.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF8A73C.1060504@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, chris,

Is there any comment on this "Forced readonly mounts on errors" patchset?

thanks,
Liu Bo

On 12/03/2010 04:15 PM, liubo wrote:
> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
> Meanwhile, they are very ugly and should be handled more propriately.
> 
> There are mainly two ways to deal with these BUG_ON()s.
> 
> 1. For those errors which can be handled well by callers, we just return their
> error number to callers.
> 
> 2. For others, We can force the filesystem readonly when it hits errors, which
>  is what this patchset has done. Replaced BUG_ON() with the interface provided
>  in this patchset, we will get error infomation via dmesg. Since btrfs is now 
> readonly, we can save our data safely and umount it, then a btrfsck is 
> recommended.
> 
> By these ways, we can protect our filesystem from panic caused by those 
> BUG_ONs.
> 
> We still need a incompat flag to make old kernels happy.
> 
> This patchset needs more test.
> 
> v2->v3:
> - since btrfs may do log replay after crash, even it is mounted as readonly,
>   and we have add a readonly check at start transaction time, it needs to set
>   and to restore readonly flags around log replay.
> 
> v1->v2:
> - in order to avoid deadlock thing, move write super stuff from error handle
>   path to unmount time.
> - remove BTRFS_SUPER_FLAG_VALID, just use BTRFS_SUPER_FLAG_ERROR to make it
>   simple.
> - add MS_RDONLY check at start of a transaction instead of commit transaction.
> ---
>  fs/btrfs/ctree.h       |   19 ++++++++++
>  fs/btrfs/disk-io.c     |   56 +++++++++++++++++++++++++++++-
>  fs/btrfs/super.c       |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/transaction.c |    3 ++
>  4 files changed, 164 insertions(+), 2 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

