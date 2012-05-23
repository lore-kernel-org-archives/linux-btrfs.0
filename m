Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42751 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab2EWOBH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 10:01:07 -0400
Date: Wed, 23 May 2012 16:00:29 +0200
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Btrfs: add device counters for detected IO and
 checksum errors
Message-ID: <20120523140029.GN24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <cover.1337682115.git.sbehrens@giantdisaster.de>
 <0072a9fd5bd99859983665e65b695b55cd186097.1337682115.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0072a9fd5bd99859983665e65b695b55cd186097.1337682115.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2012 at 12:53:47PM +0200, Stefan Behrens wrote:
>  		 */
>  		clear_buffer_uptodate(bh);
> +		btrfs_device_stat_inc(&device->cnt_write_io_errs);
> +		device->device_stats_dirty = 1;
> +		btrfs_device_stat_print_on_error(device);

this sequence repeats several times (with a slight change), IMHO it asks
for a helper.

void stat_inc(... *device, atomic_inc *cnt) {
	atomic_inc(cntr);
	device->device_stats_dirty = 1;
	btrfs_device_stat_print_on_error(device);
}

usage:

stat_inc(device, &device->cnt_write_io_errs);

I think it's unavoidable to leave out the 'device' parameter without a
macro trickery, but as there are only 2 params, it don't it's needed.


>  static void btrfs_end_bio(struct bio *bio, int err)
>  {
> -	struct btrfs_bio *bbio = bio->bi_private;
> +	struct btrfs_bio *bbio = (struct btrfs_bio *)
> +		(((uintptr_t)bio->bi_private) & ~((uintptr_t)3));

I suggest do use a helper for all the "var & 3" places, and comment why
is it so and what are the limitations. I can see from the code below
that it encodes number of devices and fails for > 3.

>  	int is_orig_bio = 0;
>  
> -	if (err)
> +	if (err) {
>  		atomic_inc(&bbio->error);
> +		if (err == -EIO || err == -EREMOTEIO) {
> +			unsigned int dev_nr = ((uintptr_t)bio->bi_private) & 3;

eg.

unsigned int dev_nr = bio_private_to_nr_dev(bio);

> @@ -4148,7 +4166,9 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
>  		} else {
>  			bio = first_bio;
>  		}
> -		bio->bi_private = bbio;
> +		BUG_ON((((uintptr_t)bbio) & 3) != 0);
> +		BUG_ON(dev_nr > 3);
> +		bio->bi_private = (void *)(((uintptr_t)bbio) | dev_nr);
>  		bio->bi_end_io = btrfs_end_bio;
>  		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
>  		dev = bbio->stripes[dev_nr].dev;


otherwise ok,
david
