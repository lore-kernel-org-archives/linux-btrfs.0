Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E06C07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56FBF20823
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfARReD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:34:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:37362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727527AbfARReC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 12:34:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BD830ADE3;
        Fri, 18 Jan 2019 17:34:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 35FB4DA773; Fri, 18 Jan 2019 18:33:31 +0100 (CET)
Date:   Fri, 18 Jan 2019 18:33:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: find_device cleanups
Message-ID: <20190118173330.GD2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 11:32:27PM +0800, Anand Jain wrote:
> find_device and its helper functions are as below
> 
>  btrfs_find_device_by_devspec()
>  btrfs_find_device_missing_or_by_path()
>  btrfs_find_device_by_path()
>  btrfs_find_device()
>  find_device()
> 
> Its quite confusing and too fragmented.
> 
> In this patch-set..
>  1/6 and 2/6 -- btrfs_find_device_missing_or_by_path() is collapsed into
>  btrfs_find_device_by_devspec() and cleanup the surviving function.
> 
>  3/6 -- rename btrfs_find_device_by_path() to find_device_by_superblock().
> 
>  4/6 and 5/6 -- collapses find_device() into btrfs_find_device().
> 
>  6/6 refactors btrfs_find_device() to return standard error code.
> 
> Resulting in..
> 
> btrfs_find_device():
>  Mainly used to get struct btrfs_device internally for a given devid
>  and or uuid and also helper function for btrfs_find_device_by_devspec().
> 
> btrfs_find_device_by_devspec() and a helper function find_device_by_superblock():
>  Is mainly to retrieve the struct btrfs_device of a userland given device_path.
> 
> Anand Jain (6):
>   btrfs: merge btrfs_find_device_missing_or_by_path() into parent
>   btrfs: cleanup btrfs_find_device_by_devspec()
>   btrfs: rename btrfs_find_device_by_path()
>   btrfs: refactor btrfs_find_device() take fs_devices as argument
>   btrfs: merge btrfs_find_device() and find_device()
>   btrfs: refactor btrfs_find_device() return error code

1,2,4, applied, please update 5 and resend. Thanks.
