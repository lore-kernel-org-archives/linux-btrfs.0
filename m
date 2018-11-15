Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A37C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7E8223CB
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE7E8223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbeKPBg3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:36:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:53858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbeKPBg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 20:36:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20663AD00;
        Thu, 15 Nov 2018 15:28:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11339DAC4A; Thu, 15 Nov 2018 16:27:55 +0100 (CET)
Date:   Thu, 15 Nov 2018 16:27:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/9] btrfs: replace cancel is successful if scrub cancel
 is successful
Message-ID: <20181115152754.GS24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-6-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541946144-8174-6-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 11, 2018 at 10:22:20PM +0800, Anand Jain wrote:
> In btrfs_dev_replace_cancel() we should check if the
> btrfs_scrub_cancel() is successful. If the btrfs_scrub_cancel() fails, return
> BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED so that user can try to
> cancel the replace again.

I've updated the subject and changelog as this was not easy to
understand what's going on.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index d32d696d931c..9fc3cb8d3918 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -799,18 +799,22 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>  		btrfs_dev_replace_write_unlock(dev_replace);
>  		break;
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
> -		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>  		tgt_device = dev_replace->tgtdev;
>  		src_device = dev_replace->srcdev;
>  		btrfs_dev_replace_write_unlock(dev_replace);
> -		btrfs_scrub_cancel(fs_info);
> -		/*
> -		 * btrfs_dev_replace_finishing() will handle the cleanup part
> -		 */
> -		btrfs_info_in_rcu(fs_info,
> -			"dev_replace from %s (devid %llu) to %s canceled",
> -			btrfs_dev_name(src_device), src_device->devid,
> -			btrfs_dev_name(tgt_device));
> +		ret = btrfs_scrub_cancel(fs_info);
> +		if (ret) {

This should be ret < 0, fixed.

> +			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
> +		} else {
> +			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
> +			/*
> +			 * btrfs_dev_replace_finishing() will handle the cleanup part
> +			 */
> +			btrfs_info_in_rcu(fs_info,
> +				"dev_replace from %s (devid %llu) to %s canceled",
> +				btrfs_dev_name(src_device), src_device->devid,
> +				btrfs_dev_name(tgt_device));
> +		}
>  		break;
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>  		/*
> -- 
> 1.8.3.1
