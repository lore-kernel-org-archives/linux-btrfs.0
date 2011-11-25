From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 65/99] btrfs: ->submit_bio_hook error push-up
Date: Fri, 25 Nov 2011 01:46:04 +0100
Message-ID: <20111125004604.GI12759@twin.jikos.cz>
References: <20111124003533.395674389@suse.com> <20111124004227.342118564@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124004227.342118564@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2011 at 07:36:38PM -0500, Jeff Mahoney wrote:
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2752,10 +2759,12 @@ retry:
>  static void flush_epd_write_bio(struct extent_page_data *epd)
>  {
>  	if (epd->bio) {
> +		int ret;
>  		if (epd->sync_io)
> -			submit_one_bio(WRITE_SYNC, epd->bio, 0, 0);
> +			ret = submit_one_bio(WRITE_SYNC, epd->bio, 0, 0);
>  		else
> -			submit_one_bio(WRITE, epd->bio, 0, 0);
> +			ret = submit_one_bio(WRITE, epd->bio, 0, 0);
> +		BUG_ON(ret < 0);

this if/else could be transfomed in the same way as in

"63/99 btrfs: Simplify btrfs_submit_bio_hook"

int rw = WRITE;

if (epd->sync_io)
	rw = WRITE_SYNC;

ret = submit_one_bio(rw, ...);
