Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E082CC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 15:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB363206C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 15:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfAGPa3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:30:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:42498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729740AbfAGPa3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 10:30:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A3D8AFAD
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 15:30:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 78CA2DA7E8; Mon,  7 Jan 2019 16:29:55 +0100 (CET)
Date:   Mon, 7 Jan 2019 16:29:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Replace open-coded maths with DIV_ROUND_UP
Message-ID: <20190107152955.GV23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-7-nborisov@suse.com>
 <20190103144432.GH23615@twin.jikos.cz>
 <488fa8c9-4d3c-4d1f-c4a1-8e0d45f0cd14@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <488fa8c9-4d3c-4d1f-c4a1-8e0d45f0cd14@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 05:33:26PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.01.19 г. 16:44 ч., David Sterba wrote:
> > On Thu, Jan 03, 2019 at 10:50:04AM +0200, Nikolay Borisov wrote:
> >> In a couple of places it's required to calculate the number of pages
> >> given a start and end offsets. Currently this is opencoded, unify the
> >> code base by replacing all such sites with the DIV_ROUND_UP macro. Also,
> >> current open-coded sites were buggy in that they were adding
> >> 'PAGE_SIZE', rather than 'PAGE_SIZE - 1'.
> > 
> > Didn't you find it strange that it's so consistently wrong? After a
> > closer inspection, you'd find that the end of the range is inclusive. So
> > the math is correct and your patch introduces a bug.
> 
> But since we are talking about number of pages, why does the range need
> to be inclusive. Indeed, let's take delalloc_to_write in
> writepage_delalloc. Say we have a 1mb range, 0-1m - that's 256 pages
> right so with DIV_ROUND_UP we'll have:
> 
> (1048576 + 4096 - 1) / 4096 = 256
> 
> with the old version we'll have:
> 
> 1048576 + 4096 / 4096 = 257

No, it's not 1048576 but 1048575. The end of the range is inclusive, ie.
the value in end is the end of the interval. Not one byte after.

It's even written in the comment in writepage_delalloc just above the
line where you switch to DIV_ROUND_UP.
