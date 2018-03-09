Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbeCIPu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 10:50:26 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2A36CAF2D
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 15:50:25 +0000 (UTC)
Date: Fri, 9 Mar 2018 16:48:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: free-space-cache: Enhance free space
 cache free space check
Message-ID: <20180309154804.GU23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180308070231.28876-1-wqu@suse.com>
 <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>
 <4cba0a52-2b0d-ff20-a52b-6cf90535f525@suse.com>
 <990e0fd3-eb5a-8036-18c8-b88c3af1c0bf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <990e0fd3-eb5a-8036-18c8-b88c3af1c0bf@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 09, 2018 at 10:06:02AM +0200, Nikolay Borisov wrote:
> >>> +		 * space cache has less free space, and both kernel just discard
> >>> +		 * such cache. But if we find some case where free space cache
> >>> +		 * has more free space, this means under certain case such
> >>> +		 * cache can be loaded and cause double allocate.
> >>> +		 *
> >>> +		 * Detect such possibility here.
> >>> +		 */
> >>> +		if (diff > 0)
> >>> +			error(
> >>> +"free space cache has more free space than block group item, this could leads to serious corruption, please contact btrfs developers");
> >>
> >> I'm not entirely happy with this message. So they will post to the
> >> mailing list saying something along the lines of "I got this message
> >> what do I do no, please help".  Better to output actionable data so that
> >> the user can post it immediately.
> > 
> > Unfortunately, this is already the situation we don't expect to see.
> > 
> > What we really need is to know this could happen, and if possible some
> > info about the situation.
> > There is not much actionable data here.
> 
> Fair enough, at the very least I think we should put information how to
> contact btrfs developers. So put the address of the mailing list, I
> don't think it's safe to assume people will be aware of it .

This should go to the manual page or help string, and reference it from
here.
