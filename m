From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH V3 3/6] btrfs: fix wrong calculation of stripe size
Date: Wed, 12 Jan 2011 08:51:07 -0500
Message-ID: <20110112135107.GC2645@localhost.localdomain>
References: <4D2442DC.1060109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2442DC.1060109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 06:07:24PM +0800, Miao Xie wrote:
> There are two tiny problem:
> - One is When we check the chunk size is greater than the max chunk size or not,
>   we should take mirrors into account, but the original code didn't.
> - The other is btrfs shouldn't use the size of the residual free space as the
>   length of of a dup chunk when doing chunk allocation. It is because the device
>   space that a dup chunk needs is twice as large as the chunk size, if we use
>   the size of the residual free space as the length of a dup chunk, we can not
>   get enough free space. Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
