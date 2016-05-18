Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752518AbcERTio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 15:38:44 -0400
Subject: Re: [PATCH 6/7] Btrfs: fix eb memory leak due to readpage failure
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-6-git-send-email-bo.li.liu@oracle.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <97b7a496-9cb5-13bc-010f-f126d272c35e@fb.com>
Date: Wed, 18 May 2016 15:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <1463184422-13584-6-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2016 08:07 PM, Liu Bo wrote:
> eb->io_pages is set in read_extent_buffer_pages().
>
> In case of readpage failure, for pages that have been added to bio,
> it calls bio_endio and later readpage_io_failed_hook() does the work.
>
> When this eb's page (couldn't be the 1st page) fails to add itself to bio
> due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
>  and ends up with a memory leak eventually.
>
> This adds the 'atomic_dec(&eb->io_pages)' to the readpage error handling.

Wait why can't this be done in
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 99286d1..2327200 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3069,6 +3069,30 @@ static int __do_readpage(struct extent_io_tree *tree,
>  			*bio_flags = this_bio_flag;
>  		} else {
>  			SetPageError(page);
> +			/*
> +			 * Only metadata io request has this issue, for data it
> +			 * just unlocks extent and releases page's lock.
> +			 *
> +			 * eb->io_pages is set in read_extent_buffer_pages().
> +			 *
> +			 * When this eb's page fails to add itself to bio,
> +			 * it cannot decrease eb->io_pages via bio_endio, and
> +			 * ends up with extent_buffer_under_io() always being
> +			 * true, because of that, eb won't be freed and we have
> +			 * a memory leak eventually.
> +			 *
> +			 * Here we still hold this page's lock, and other tasks
> +			 * who're also reading this eb are blocked.
> +			 */
> +			if (rw & REQ_META) {
> +				struct extent_buffer *eb;
> +
> +				WARN_ON_ONCE(!PagePrivate(page));
> +				eb = (struct extent_buffer *)page->private;
> +
> +				WARN_ON_ONCE(atomic_read(&eb->io_pages) < 1);
> +				atomic_dec(&eb->io_pages);
> +			}
>  			unlock_extent(tree, cur, cur + iosize - 1);
>  		}
>  		cur = cur + iosize;
>

This isn't the right way to do this.  It looks like we don't propagate 
up errors from __do_readpage, which we need to in order to clean up 
properly.  So do that and then change the error stuff to decrement the 
io_pages for the remaining, you can see write_one_eb for how to deal 
with that properly.  Thanks,

Josef
