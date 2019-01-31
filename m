Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E731DC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25F920869
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfAaPWM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:22:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:44482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbfAaPWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:22:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58B3AAFA3
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 15:22:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E8AAEDA7D6; Thu, 31 Jan 2019 16:21:35 +0100 (CET)
Date:   Thu, 31 Jan 2019 16:21:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 01/15] btrfs: Honour FITRIM range constraints during free
 space trim
Message-ID: <20190131152135.GG2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20190130145102.4708-1-nborisov@suse.com>
 <20190130145102.4708-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130145102.4708-2-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 04:50:48PM +0200, Nikolay Borisov wrote:
> Up until know trimming the freespace was done irrespective of what the
> arguments of the FITRIM ioctl were. For example fstrim's -o/-l arguments
> will be entirely ignored. Fix it by correctly handling those paramter.
> This requires breaking if the found freespace extent is after the end
> of the passed range as well as completing trim after trimming
> fstrim_range::len bytes.

How does this work with with multipe-device filesystems? The fstrim
range would apply to all of them. Which does make some sense, though
might be unexpected as this does not happen for other filesystems.

The FITRIM range is in the physical coordinates, so eg. the taking the
maximum size of all devices and iterating over that by 1GiB steps would
go though the whole filesystem. Something to put to the changelog and
documentation.

> Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1fdba38761f7..fc3f6acc3c9b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -11190,9 +11190,9 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
>   * held back allocations.
>   */
>  static int btrfs_trim_free_extents(struct btrfs_device *device,
> -				   u64 minlen, u64 *trimmed)
> +				   struct fstrim_range *range, u64 *trimmed)
>  {
> -	u64 start = 0, len = 0;
> +	u64 start = range->start, len = 0;
>  	int ret;
>  
>  	*trimmed = 0;
> @@ -11235,8 +11235,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>  		if (!trans)
>  			up_read(&fs_info->commit_root_sem);
>  
> -		ret = find_free_dev_extent_start(trans, device, minlen, start,
> -						 &start, &len);
> +		ret = find_free_dev_extent_start(trans, device, range->minlen,
> +						 start, &start, &len);
>  		if (trans) {
>  			up_read(&fs_info->commit_root_sem);
>  			btrfs_put_transaction(trans);
> @@ -11249,6 +11249,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>  			break;
>  		}
>  
> +		/* If we are out of the passed range break */
> +		if (start > range->start + range->len - 1) {
> +			mutex_unlock(&fs_info->chunk_mutex);
> +			ret = 0;
> +			break;
> +		}
> +
> +		start = max(range->start, start);
> +		len = min(range->len, len);
> +
>  		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
>  		mutex_unlock(&fs_info->chunk_mutex);
>  
> @@ -11258,6 +11268,10 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>  		start += len;
>  		*trimmed += bytes;
>  
> +		/* We've trimmed enough */
> +		if (*trimmed >= range->len)
> +			break;
> +
>  		if (fatal_signal_pending(current)) {
>  			ret = -ERESTARTSYS;
>  			break;
> @@ -11341,8 +11355,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	devices = &fs_info->fs_devices->devices;
>  	list_for_each_entry(device, devices, dev_list) {
> -		ret = btrfs_trim_free_extents(device, range->minlen,
> -					      &group_trimmed);
> +		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
>  		if (ret) {
>  			dev_failed++;
>  			dev_ret = ret;
> -- 
> 2.17.1
