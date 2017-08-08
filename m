Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36400 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdHHJAD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Aug 2017 05:00:03 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170808084548.18963-47-ming.lei@redhat.com>
References: <20170808084548.18963-1-ming.lei@redhat.com> <20170808084548.18963-47-ming.lei@redhat.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 8 Aug 2017 10:00:02 +0100
Message-ID: <CAL3q7H5=f5MAZRN1SzkEhBSHbyXCexVHQPnj=PnWioChYQz7rg@mail.gmail.com>
Subject: Re: [PATCH v3 46/49] fs/btrfs: convert to bio_for_each_segment_all_sp()
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 8, 2017 at 9:45 AM, Ming Lei <ming.lei@redhat.com> wrote:
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Can you please add some meaningful changelog? E.g., why is this
conversion needed.

> ---
>  fs/btrfs/compression.c |  3 ++-
>  fs/btrfs/disk-io.c     |  3 ++-
>  fs/btrfs/extent_io.c   | 12 ++++++++----
>  fs/btrfs/inode.c       |  6 ++++--
>  fs/btrfs/raid56.c      |  1 +
>  5 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 28746588f228..55f251a83d0b 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -147,13 +147,14 @@ static void end_compressed_bio_read(struct bio *bio)
>         } else {
>                 int i;
>                 struct bio_vec *bvec;
> +               struct bvec_iter_all bia;
>
>                 /*
>                  * we have verified the checksum already, set page
>                  * checked so the end_io handlers know about it
>                  */
>                 ASSERT(!bio_flagged(bio, BIO_CLONED));
> -               bio_for_each_segment_all(bvec, cb->orig_bio, i)
> +               bio_for_each_segment_all_sp(bvec, cb->orig_bio, i, bia)
>                         SetPageChecked(bvec->bv_page);
>
>                 bio_endio(cb->orig_bio);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 080e2ebb8aa0..a9cd75e6383d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -963,9 +963,10 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
>         struct bio_vec *bvec;
>         struct btrfs_root *root;
>         int i, ret = 0;
> +       struct bvec_iter_all bia;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i) {
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia) {
>                 root = BTRFS_I(bvec->bv_page->mapping->host)->root;
>                 ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
>                 if (ret)
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c8f6a8657bf2..4de9cfd1c385 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2359,8 +2359,9 @@ static unsigned int get_bio_pages(struct bio *bio)
>  {
>         unsigned i;
>         struct bio_vec *bv;
> +       struct bvec_iter_all bia;
>
> -       bio_for_each_segment_all(bv, bio, i)
> +       bio_for_each_segment_all_sp(bv, bio, i, bia)
>                 ;
>
>         return i;
> @@ -2463,9 +2464,10 @@ static void end_bio_extent_writepage(struct bio *bio)
>         u64 start;
>         u64 end;
>         int i;
> +       struct bvec_iter_all bia;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i) {
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia) {
>                 struct page *page = bvec->bv_page;
>                 struct inode *inode = page->mapping->host;
>                 struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> @@ -2534,9 +2536,10 @@ static void end_bio_extent_readpage(struct bio *bio)
>         int mirror;
>         int ret;
>         int i;
> +       struct bvec_iter_all bia;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i) {
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia) {
>                 struct page *page = bvec->bv_page;
>                 struct inode *inode = page->mapping->host;
>                 struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> @@ -3693,9 +3696,10 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
>         struct bio_vec *bvec;
>         struct extent_buffer *eb;
>         int i, done;
> +       struct bvec_iter_all bia;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i) {
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia) {
>                 struct page *page = bvec->bv_page;
>
>                 eb = (struct extent_buffer *)page->private;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 084ed99dd308..eeb2ff662ec4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8047,6 +8047,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
>         struct bio_vec *bvec;
>         struct extent_io_tree *io_tree, *failure_tree;
>         int i;
> +       struct bvec_iter_all bia;
>
>         if (bio->bi_status)
>                 goto end;
> @@ -8064,7 +8065,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
>
>         done->uptodate = 1;
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i)
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia)
>                 clean_io_failure(BTRFS_I(inode)->root->fs_info, failure_tree,
>                                  io_tree, done->start, bvec->bv_page,
>                                  btrfs_ino(BTRFS_I(inode)), 0);
> @@ -8143,6 +8144,7 @@ static void btrfs_retry_endio(struct bio *bio)
>         int uptodate;
>         int ret;
>         int i;
> +       struct bvec_iter_all bia;
>
>         if (bio->bi_status)
>                 goto end;
> @@ -8162,7 +8164,7 @@ static void btrfs_retry_endio(struct bio *bio)
>         failure_tree = &BTRFS_I(inode)->io_failure_tree;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> -       bio_for_each_segment_all(bvec, bio, i) {
> +       bio_for_each_segment_all_sp(bvec, bio, i, bia) {
>                 ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
>                                              bvec->bv_offset, done->start,
>                                              bvec->bv_len);
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 208638384cd2..9247226a2efd 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1365,6 +1365,7 @@ static int find_logical_bio_stripe(struct btrfs_raid_bio *rbio,
>         u64 logical = bio->bi_iter.bi_sector;
>         u64 stripe_start;
>         int i;
> +       struct bvec_iter_all bia;

Unused variable.

Thanks.

>
>         logical <<= 9;
>
> --
> 2.9.4
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
