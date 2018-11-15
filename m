Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB1DC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4E7223CB
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:36:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF4E7223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbeKPBoW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:44:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:54824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbeKPBoW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 20:44:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82AC6ABE2;
        Thu, 15 Nov 2018 15:36:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A8E52DAC4A; Thu, 15 Nov 2018 16:35:46 +0100 (CET)
Date:   Thu, 15 Nov 2018 16:35:46 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs: quiten warn if the replace is canceled at
 finish
Message-ID: <20181115153546.GU24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-8-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541946144-8174-8-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 11, 2018 at 10:22:22PM +0800, Anand Jain wrote:
> When we successfully cancel the replace its scrub returns -ECANCELED,
> which then passed to btrfs_dev_replace_finishing(), it cleans up based
> on the scrub returned status and propagates the same -ECANCELED back
> the parent function. As of now only user can cancel the replace-scrub,
> so its ok to quieten the warn here.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 1dc8e86546db..9031a362921a 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -497,7 +497,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	ret = btrfs_dev_replace_finishing(fs_info, ret);
>  	if (ret == -EINPROGRESS) {
>  		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
> -	} else {
> +	} else if (ret != -ECANCELED) {
>  		WARN_ON(ret);

While this looks ok, can you please rework it so there are no WARN_ON at
random places in device-replace, poorly substituting error handling?

The code flow in this case could be changed to make explicit checks for
the know codes and then a catch-all branch like:

if (ret == -EINPROGRESS) {
...
} else (if == -ESOMETHINGELSE) {
...
} else {
	unknown error, print error and do a proper cleanup
}

>  	}
>  
> @@ -954,7 +954,7 @@ static int btrfs_dev_replace_kthread(void *data)
>  			      btrfs_device_get_total_bytes(dev_replace->srcdev),
>  			      &dev_replace->scrub_progress, 0, 1);
>  	ret = btrfs_dev_replace_finishing(fs_info, ret);
> -	WARN_ON(ret);
> +	WARN_ON(ret && ret != -ECANCELED);

This one too, thanks.
