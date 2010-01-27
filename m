From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH]btrfs: avoid comparing with NULL pointer
Date: Wed, 27 Jan 2010 16:00:20 +0800
Message-ID: <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
References: <4B5FDCD1.8060806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, jbacik@redhat.com, jens.axboe@oracle.com,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org, strongzgy@gmail.com
To: Liuwenyi <qingshenlwy@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751972Ab0A0IAW@vger.kernel.org>
In-Reply-To: <4B5FDCD1.8060806@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/1/27 Liuwenyi <qingshenlwy@gmail.com>:
> In this patch, I adjust the seqence of if-conditions.
> It will assess the page->private situation.
> First, we make sure the page->private is not null.
> And then, we can do some with this page->private.
>
> ---
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Yan Zheng <zheng.yan@oracle.com>
> Cc: Josef Bacik <jbacik@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> fs/btrfs/disk-io.c | 4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 009e3bd..a300dca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bio)
>
> bio_for_each_segment(bvec, bio, i) {
> page = bvec->bv_page;
> - if (page->private == EXTENT_PAGE_PRIVATE) {
> + if (!page->private) {
> length += bvec->bv_len;
> continue;
> }
> - if (!page->private) {
> + if (page->private == EXTENT_PAGE_PRIVATE) {
> length += bvec->bv_len;
> continue;
> }
> --

Why do you want to do this? The code is perfect safe even
page->private is NULL. Furthermore, your patch is malformed.

Yan, Zheng
