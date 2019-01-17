Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06E4C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9A120851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfAQPwV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:52:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:43684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728426AbfAQPwV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:52:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 79F37AD4A;
        Thu, 17 Jan 2019 15:52:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3A59EDA83D; Thu, 17 Jan 2019 16:51:51 +0100 (CET)
Date:   Thu, 17 Jan 2019 16:51:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs: merge btrfs_find_device() and find_device()
Message-ID: <20190117155151.GV2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-6-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547739153-6916-6-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 11:32:32PM +0800, Anand Jain wrote:
> @@ -6637,19 +6616,36 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  	return BLK_STS_OK;
>  }
>  
> +/*
> + * Find a device specified by @devid or @uuid in the list of @fs_devices, or
> + * return NULL.
> + *
> + * If devid and uuid are both specified, the match must be exact, otherwise
> + * only devid is used.
> + *
> + * By default will check seed devices as well, unless @no_seed is 1.
> + */
>  struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
> -				       u64 devid, u8 *uuid, u8 *fsid)
> +				       u64 devid, u8 *uuid, u8 *fsid,
> +				       int no_seed)

Please use bool here and a positive meaning of the variable.
