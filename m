Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731567AbeGSQDq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:03:46 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45E60AFC8
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 15:20:06 +0000 (UTC)
Date: Thu, 19 Jul 2018 17:19:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: Refactor loop in
 btrfs_release_extent_buffer_page
Message-ID: <20180719151957.GT26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-2-git-send-email-nborisov@suse.com>
 <20180629123508.GQ2287@twin.jikos.cz>
 <78c98716-d567-e8ca-8978-f951e4d340ae@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <78c98716-d567-e8ca-8978-f951e4d340ae@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 01:03:41PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.06.2018 15:35, David Sterba wrote:
> > On Wed, Jun 27, 2018 at 04:38:22PM +0300, Nikolay Borisov wrote:
> >> The purpose of the function is to free all the pages comprising an
> >> extent buffer. This can be achieved with a simple for loop rather than
> >> the slitghly more involved 'do {} while' construct. So rewrite the
> >> loop using a 'for' construct. Additionally we can never have an
> >> extent_buffer that is 0 pages so remove the check for index == 0. No
> >> functional changes.
> > 
> > The reversed loop makes sense, the first page is special and used for
> > locking the whole extent buffer's pages, as can be seen eg.
> > 897ca6e9b4fef86d5dfb6b31 or 4f2de97acee6532b36dd6e99 . Also see current
> > alloc_extent_buffer for the locking and managing the private bit.
> 
> Turns out  page[0] is not special and it's not used for any special
> locking whatsoever. In csum_dirty_buffer this page is used so that when
> we submit a multipage eb then we only perform csum calculation once, i.e
> when the first page (page[0]) is submitted.
> btrfs_release_extent_buffer_page OTOH no longer takes an index but just
> an EB and iterates all the pages.
> 
> The fact that page0 is unlocked last in alloc_extent_buffer seems to be
> an artefact of the code refactoring rather than a deliberate behavior.
> Furthermore I've been running tests with sequential unlocking (and
> complete removal of the SetPageChecked/ClearPageChecked function from
> alloc_extent_buffer) of the pages and didn't observe any problems
> whatsoever on both 4g and 1g configuration ( the latter is more likely
> to trigger premature page eviction hence trigger any lurking races
> between alloc_extent_buffer and btree_releasepage. I will be sending a
> patch after I do a bit more testing but so far the results are good.

With more patch archeology I agree that the page zero is not used in any
sense that would require the reversed loop. Patch added to misc-next.
