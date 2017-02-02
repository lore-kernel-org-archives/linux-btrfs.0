Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdBBToz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 14:44:55 -0500
Date: Thu, 2 Feb 2017 20:43:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove duplicated find_get_pages_contig
Message-ID: <20170202194318.GF16723@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807990-17973-1-git-send-email-bo.li.liu@oracle.com>
 <20170202184243.GE16723@twin.jikos.cz>
 <20170202191115.GE6550@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202191115.GE6550@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 11:11:15AM -0800, Liu Bo wrote:
> On Thu, Feb 02, 2017 at 07:42:43PM +0100, David Sterba wrote:
> > On Mon, Jan 30, 2017 at 12:26:30PM -0800, Liu Bo wrote:
> > > This creates a helper to manipulate page bits to avoid duplicate uses.
> > 
> > This seems too short for what the patch does. It adds a new page ops bit
> > that would deserve a separate patch. Please try to split it to smaller
> > parts.
> 
> Hmm..the newly added 'PAGE_LOCK' is only used in lock_delalloc_pages in
> order to make the helper lock pages.
> 
> I could firstly introduce the helper from extent_clear_unlock_delalloc()
> , then introduce the new 'PAGE_LOCK' and make lock_delalloc_pages and
> __unlock_for_delalloc to use the helper, does it sound better to review
> and bisect?

This sounds better, thanks. The reason is mostly from the review side.
