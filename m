Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeABPmm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 10:42:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C97CFACBD
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Jan 2018 15:42:40 +0000 (UTC)
Date: Tue, 2 Jan 2018 16:40:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Cleanup of bio_get/set
Message-ID: <20180102154035.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513153540-10737-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513153540-10737-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 10:25:36AM +0200, Nikolay Borisov wrote:
> Hello, 
> 
> Here is a series which cleans the btrfs source code of all the redundant 
> bio_get/set calls. After it's applied there is only a single bio_get inovcation
> left in __alloc_device for the flush_bio (and that is wrong since it 
> leaks the bio, but this will be fixed in a follow up fix).
> 
> Nikolay Borisov (4):
>   btrfs: Remove redundant bio_get/set calls in compressed read/write
>     paths
>   btrfs: Remove redundant bio_get/set from submit_dio_repair_bio
>   btrfs: Remove redundan bio_get/bio_set pair from submit_one_bio
>   btrfs: Remove redundant pair of bio_get/set in __btrfs_submit_dio_bio

All

Reviewed-by: David Sterba <dsterba@suse.com>

and added to 4.16 queue.
