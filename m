Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbdJ3N4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:56:51 -0400
Date: Mon, 30 Oct 2017 14:55:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: bo.li.liu@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: What is the purpose of EXTENT_PAGE_MAPPED
Message-ID: <20171030135500.GV3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f8f92f68-7ea9-e08e-bb4c-602616d46813@suse.de>
 <20171027041736.GA18058@lim.localdomain>
 <0f6ac8d3-af9b-c3f9-0d52-e3214306af6a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0f6ac8d3-af9b-c3f9-0d52-e3214306af6a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 30, 2017 at 03:21:51PM +0200, Nikolay Borisov wrote:
> 
> 
> On 27.10.2017 07:17, Liu Bo wrote:
> > On Tue, Oct 24, 2017 at 05:47:11AM -0500, Goldwyn Rodrigues wrote:
> >>
> >> EXTENT_PAGE_MAPPED gets set in set_page_extent_mapped(), but I don't see
> >> it being cross checked anytime. What is the purpose of setting it?
> > 
> > Please check commit d1310b2e0cd98eb1348553e69b73827b436dca7b, it was
> > used to differentiate page for metadata and for data, but I think
> > currently it's just a piece of legacy code.
> 
> Be that as it may - is there any reason why we are keeping this and can
> it be killed off?

Are we're talking about EXTENT_PAGE_PRIVATE? There's no
EXTENT_PAGE_MAPPED. There's some control dependency on the page private
bit and the value, so we should be careful and replace the function with
an assert (or a BUG_ON if it's a must-not-happen state). The page->private
points to an extent buffer, and if it's always an eb, then the
EXTENT_PAGE_PRIVATE is unused.
