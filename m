Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB7AC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 537EF2085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfAGR7i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:59:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:44270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbfAGR7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 12:59:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6ADFAD38
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 17:59:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 445CDDA7E8; Mon,  7 Jan 2019 18:59:06 +0100 (CET)
Date:   Mon, 7 Jan 2019 18:59:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] More misc fixes
Message-ID: <20190107175905.GA23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:49:58AM +0200, Nikolay Borisov wrote:
> Here is an assortment of fixes, mainly around the async (compressed) cow path. 
> Just removes some redundant arguments/local variables, makes shrink_delalloc a
> bit more readable by simplifying variable usage and giving more appropriate names. 
> Also documents the ->inode null check in async_cow_submit and cleans up open-coded
> usage of DIV_ROUND_UP. No functional changes to any of the patches. 
> 
> Nikolay Borisov (7):
>   btrfs: Remove inode argument from async_cow_submit
>   btrfs: Remove isize local variable in compress_file_range
>   btrfs: Use ihold instead of igrab in cow_file_range_async
>   btrfs: Remove WARN_ON in btrfs_alloc_delalloc_work
>   btrfs: Document logic in async_cow_submit
>   btrfs: Replace open-coded maths with DIV_ROUND_UP
>   btrfs: Refactor shrink_delalloc

All but 6/7 applied, the one still needs to be clarified.
