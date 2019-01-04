Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D58FC43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54EE320874
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfADP3t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:29:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:56212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726948AbfADP3t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:29:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33791ACFB
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 15:29:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D6CA1DA7CE; Fri,  4 Jan 2019 16:29:18 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:29:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs: Use ihold instead of igrab in
 cow_file_range_async
Message-ID: <20190104152918.GP23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103085005.32053-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:50:01AM +0200, Nikolay Borisov wrote:
> ihold is supposed to be used when the caller already has a reference to
> the inode. In the case of cow_file_range_async this invariants holds,
> since the 3 call chains leading to this function all take a reference:
> 
> btrfs_writepage  <--- does igrab
>  extent_write_full_page
>   __extent_writepage
>    writepage_delalloc
>      btrfs_run_delalloc_range
>       cow_file_range_async
> 
> extent_write_cache_pages <--- does igrab
>  __extent_writepage (same callchain as above)
> 
> and
> 
> submit_compressed_extents <-- already called from async CoW submit path,
> 			      which would have done ihold.
>  extent_write_locked_range
>   __extent_writepage

So by the logic the inode reference needs to be taken early, eg. in
btrfs_writepage and all low-level callbacks or helpers are fine with
ihold.

Reviewed-by: David Sterba <dsterba@suse.com>
