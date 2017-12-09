Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbdLINcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Dec 2017 08:32:22 -0500
Subject: Re: [PATCH] Btrfs: raid56: fix race between merge_bio and
 rbio_orig_end_io
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208230235.30636-1-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <233e3f98-5f56-c2b8-1aa3-32ea360fe577@suse.com>
Date: Sat, 9 Dec 2017 15:32:18 +0200
MIME-Version: 1.0
In-Reply-To: <20171208230235.30636-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.12.2017 01:02, Liu Bo wrote:
> We're not allowed to take any new bios to rbio->bio_list in
> rbio_orig_end_io(), otherwise we may get merged with more bios and
> rbio->bio_list is not empty.
> 
> This should only happens in error-out cases, the normal path of
> recover and full stripe write have already set RBIO_RMW_LOCKED_BIT to
> disable merge before doing IO.
> 
> Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 5aa9d22..127c782 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -859,12 +859,23 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
>   */
>  static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
>  {
> -	struct bio *cur = bio_list_get(&rbio->bio_list);
> +	struct bio *cur;
>  	struct bio *next;
>  
> +	/*
> +	 * We're not allowed to take any new bios to rbio->bio_list
> +	 * from now on, otherwise we may get merged with more bios and
> +	 * rbio->bio_list is not empty.
> +	 */
> +	spin_lock(&rbio->bio_list_lock);
> +	set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
> +	spin_unlock(&rbio->bio_list_lock);

do we really need the spinlock, bit operations are atomic?

> +
>  	if (rbio->generic_bio_cnt)
>  		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
>  
> +	cur = bio_list_get(&rbio->bio_list);
> +
>  	free_raid_bio(rbio);
>  
>  	while (cur) {
> 
