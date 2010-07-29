From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH 7/7] btrfs: fix a wrong error check in add_ra_bio_pages()
Date: Thu, 29 Jul 2010 18:38:39 +0800
Message-ID: <AANLkTim+U2s5-vHhmPqam9wj0+0_=01bq3JjnR=xB8T2@mail.gmail.com>
References: <4C513C95.3080403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C513C95.3080403@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/7/29 Miao Xie <miaox@cn.fujitsu.com>:
> From: Liu Bo <liubo2009@cn.fujitsu.com>
>
> Only when a page is not found by page_index, we'll go to the error ch=
eck.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> =A0fs/btrfs/compression.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index cb3877c..8458840 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -467,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode=
 *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_lock();
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D radix_tree_lookup(&mapping->p=
age_tree, page_index);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_unlock();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (page) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page) {
> =A0check_misses:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0misses++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (misses > 4)

This patch is wrong. The word "miss" here means "miss for read-ahead be=
cause
the page is already in the page cache"

Yan, Zheng
