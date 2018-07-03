Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933238AbeGCIdK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 04:33:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3A95ADAD
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 08:33:08 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] btrfs: Check each block group has corresponding
 chunk at mount time
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180703080830.8300-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <034ca6af-0f07-f9b8-86c0-463333bb41f5@suse.com>
Date: Tue, 3 Jul 2018 11:33:07 +0300
MIME-Version: 1.0
In-Reply-To: <20180703080830.8300-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.07.2018 11:08, Qu Wenruo wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199837, if a
> crafted btrfs with incorrect chunk<->block group mapping, it could leads
> to a lot of unexpected behavior.
> 
> Although the crafted image can be catched by block group item checker
> added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if one
> crafted a valid enough block group item which can pass above check but
> still mismatch with existing chunk, it could cause a lot of undefined
> behavior.
> 
> This patch will add extra block group -> chunk mapping check, to ensure
> we have a completely matching (start, len, flags) chunk for each block
> group at mount time.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Add better error message for each mismatch case.
>   Rename function name, to co-operate with later patch.
>   Add flags mismatch check.
> ---

It's getting really hard to keep track of the various validation patches
you sent with multiple versions + new checks. Please batch everything in
a topic series i.e "Making checks stricter" or some such and send
everything again nicely packed, otherwise the risk of mis-merging is
increased. I now see that Gu Jinxiang from fujitsu also started sending
validation fixes.
