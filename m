Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF5DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 074F5214C1
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 074F5214C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbeKVChs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:37:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:60488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730072AbeKVChs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 21:37:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3495B047;
        Wed, 21 Nov 2018 16:02:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82B08DA871; Wed, 21 Nov 2018 17:02:27 +0100 (CET)
Date:   Wed, 21 Nov 2018 17:02:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between enabling quotas and subvolume
 creation
Message-ID: <20181121160227.GO24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181119162034.13132-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119162034.13132-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 04:20:34PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We have a race between enabling quotas end subvolume creation that cause
> subvolume creation to fail with -EINVAL, and the following diagram shows
> how it happens:
> 
>               CPU 0                                          CPU 1
> 
>  btrfs_ioctl()
>   btrfs_ioctl_quota_ctl()
>    btrfs_quota_enable()
>     mutex_lock(fs_info->qgroup_ioctl_lock)
> 
>                                                   btrfs_ioctl()
>                                                    create_subvol()
>                                                     btrfs_qgroup_inherit()
>                                                      -> save fs_info->quota_root
>                                                         into quota_root
>                                                      -> stores a NULL value
>                                                      -> tries to lock the mutex
>                                                         qgroup_ioctl_lock
>                                                         -> blocks waiting for
>                                                            the task at CPU0
> 
>    -> sets BTRFS_FS_QUOTA_ENABLED in fs_info
>    -> sets quota_root in fs_info->quota_root
>       (non-NULL value)
> 
>    mutex_unlock(fs_info->qgroup_ioctl_lock)
> 
>                                                      -> checks quota enabled
>                                                         flag is set
>                                                      -> returns -EINVAL because
>                                                         fs_info->quota_root was
>                                                         NULL before it acquired
>                                                         the mutex
>                                                         qgroup_ioctl_lock
>                                                    -> ioctl returns -EINVAL
> 
> Returning -EINVAL to user space will be confusing if all the arguments
> passed to the subvolume creation ioctl were valid.
> 
> Fix it by grabbing the value from fs_info->quota_root after acquiring
> the mutex.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to misc-next, thanks.
