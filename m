Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A74C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B91320693
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfCMPet (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:34:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfCMPet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:34:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C11AAEFF
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:34:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04F2DDA875; Wed, 13 Mar 2019 16:36:02 +0100 (CET)
Date:   Wed, 13 Mar 2019 16:36:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] Compress path cleanups
Message-ID: <20190313153601.GC31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190312152030.31987-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 05:20:23PM +0200, Nikolay Borisov wrote:
> Here is the v4 of the compress path cleanups, this version  incorporates 
> feeback from v3, namely: 
> 
> * Use struct_size when calculating the size of the struct to allocated in 
> cow_file_range_async
> 
> * Reinstated the comment about ihold in cow_file_range_async
> 
> * Renamed "struct async_chunk *" variables from async_cow to async_chunk
> 
> * Gave patch 1 a more explicit title. 
> 
> * added RB tags from Johanness to patch 3 and 4
> 
> Nikolay Borisov (7):
>   btrfs: Preallocate chunks in cow_file_range_async
>   btrfs: Rename async_cow to async_chunk
>   btrfs: Remove fs_info from struct async_chunk
>   btrfs: Make compress_file_range take only struct async_chunk
>   btrfs: Replace clear_extent_bit with unlock_extent
>   btrfs: Set iotree only once in submit_compressed_extents
>   btrfs: Factor out common extent locking code in
>     submit_compressed_extents

Overall looks good, I'll add it to misc-5.2 after some testing, thanks.
