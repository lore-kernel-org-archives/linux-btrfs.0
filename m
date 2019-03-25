Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7767C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 896F620863
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfCYQk3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:40:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:45530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCYQk3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 12:40:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FDBFAF17
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 16:40:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A3A15DA98F; Mon, 25 Mar 2019 17:41:41 +0100 (CET)
Date:   Mon, 25 Mar 2019 17:41:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Exploit the fact pages passed to extent_readpages
 are always contiguous
Message-ID: <20190325164141.GL10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190311075538.19242-1-nborisov@suse.com>
 <20190313172709.GD31119@twin.jikos.cz>
 <7252ea0b-8a68-aad4-0b7a-a37f012e9f6c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7252ea0b-8a68-aad4-0b7a-a37f012e9f6c@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:17:14AM +0200, Nikolay Borisov wrote:
> 
> 
> On 13.03.19 г. 19:27 ч., David Sterba wrote:
> > On Mon, Mar 11, 2019 at 09:55:38AM +0200, Nikolay Borisov wrote:
> >> Currently extent_readpages (called from btrfs_redpages) will always call
> >> __extent_readpages which tries to create contiguous range of pages and
> >> call __do_contiguous_readpages when such contiguous range is created.
> >>
> >> It turns out this is unnecessary due to the fact that generic VFS code
> >> always calls filesystem's ->readpages callback (btrfs_readpages in
> >> this case) with already contiguous pages. Armed with this knowledge it's
> >> possible to simplify extent_readpages by eliminating the call to
> >> __extent_readpages and directly calling contiguous_readpages. The only
> >> edge case that needs to be handled is when add_to_page_cache_lru
> >> fails. This is easy as all that is needed is to submit whatever is the
> >> number of pages successfully added to the lru.
> > 
> > I'd like to have more details why this is correct. Submitting what we
> > have so far seems ok, the reasons why add_to_page_cache_lru are unclear
> > and go back to xarray.
> 
> I'm having a hard time parsing the sentence after the comma, could you
> rephrase that?

The errors that can be returned from add_to_page_cache_lru are deep
inside the MM code, I traced it to the xarray helpers that now manage
the page cache.

> > 
> > Possible error is EEXSIT, here it's clear that we don't need to read the
> 
> Not only EEXIST, the code can also fail due to memory pressure from
> mem_cgroup_try_charge in __add_to_page_cache_locked. In fact this code
> was triggered by some of the xfstests I can't remember which one hence I
> added the if (nr) check.

My concerns were about errors that could affect logic of the readpages,
for the hard errors like ENOMEM we can't do much. 

> > pages (already there). A sequence of such pages will make it wildly hop
> > from 1st for cycle iteration, to the if (nr) check and back.
> > 
> > Previously this looped still in the for-cycle, which was easier to
> > follow but otherwise not due to __extent_readpages. So I think it's an
> > improvement in the end, though a few comments would be good there.
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > 
> 
> <snip>
