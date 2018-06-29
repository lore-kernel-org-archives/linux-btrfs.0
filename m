Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56972 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752768AbeF2NxK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 09:53:10 -0400
Date: Fri, 29 Jun 2018 15:53:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Rename EXTENT_BUFFER_DUMMY to
 EXTENT_BUFFER_PRIVATE
Message-ID: <20180629135308.GS2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-4-git-send-email-nborisov@suse.com>
 <20180629124633.GR2287@twin.jikos.cz>
 <97349690-b129-1b5b-17c5-4363fe2a879d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <97349690-b129-1b5b-17c5-4363fe2a879d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 09:07:12PM +0800, Qu Wenruo wrote:
> >> @@ -5117,7 +5117,7 @@ void free_extent_buffer(struct extent_buffer *eb)
> >>  
> >>  	spin_lock(&eb->refs_lock);
> >>  	if (atomic_read(&eb->refs) == 2 &&
> >> -	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
> >> +	    test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags))
> >>  		atomic_dec(&eb->refs);
> 
> Also discussed in off list mail, this extra atomic_dec for cloned eb
> looks confusing.
> (That also explains why after cloning the eb, we call
> extent_buffer_get() and only frees it once, and still no eb leaking)
> What about just removing such special handling?

The extent_buffer_get can be moved to the cloning function, all callers
increase the reference but the missing dec is indeed confusing. However
I don't think we can remove it completely. We need to keep the eb::refs
at the same level for all eb types (regular, STALE, DUMMY), so we can
use eg. free_extent_buffer.

There may be other way how to clean it that I don't see now, so if you
think you can improve the reference handling, then go for it.
