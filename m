Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45839 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbcIAPI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 11:08:26 -0400
Date: Thu, 1 Sep 2016 17:07:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix memory leak in reading btree blocks
Message-ID: <20160901150702.GP16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1470252781-9455-1-git-send-email-bo.li.liu@oracle.com>
 <20160824231549.GA27943@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160824231549.GA27943@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2016 at 04:15:50PM -0700, Liu Bo wrote:
> Hi David,
> 
> On Wed, Aug 03, 2016 at 12:33:01PM -0700, Liu Bo wrote:
> > So we can read a btree block via readahead or intentional read,
> > and we can end up with a memory leak when something happens as
> > follows,
> > 1) readahead starts to read block A but does not wait for read
> >    completion,
> > 2) btree_readpage_end_io_hook finds that block A is corrupted,
> >    and it needs to clear all block A's pages' uptodate bit.
> > 3) meanwhile an intentional read kicks in and checks block A's
> >    pages' uptodate to decide which page needs to be read.
> > 4) when some pages have the uptodate bit during 3)'s check so
> >    3) doesn't count them for eb->io_pages, but they are later
> >    cleared by 2) so we has to readpage on the page, we get
> >    the wrong eb->io_pages which results in a memory leak of
> >    this block.
> > 
> > This fixes the problem by firstly getting all pages's locking and
> > then checking pages' uptodate bit.
> 
>    t1(readahead)                              t2(readahead endio)                                       t3(the following read)
> read_extent_buffer_pages                    end_bio_extent_readpage                                  
>   for pg in eb:                                for page 0,1,2 in eb:
>       if pg is uptodate:                           btree_readpage_end_io_hook(pg)
>           num_reads++                              if uptodate:                                                
>   eb->io_pages = num_reads                             SetPageUptodate(pg)              _______________
>   for pg in eb:                                for page 3 in eb:                                     read_extent_buffer_pages   
>        if pg is NOT uptodate:                      btree_readpage_end_io_hook(pg)                       for pg in eb:
>            __extent_read_full_page(pg)                 sanity check reports something wrong                 if pg is uptodate:
>                                                        clear_extent_buffer_uptodate(eb)                         num_reads++
>                                                            for pg in eb:                                eb->io_pages = num_reads
>                                                                ClearPageUptodate(page)  _______________
>                                                                                                         for pg in eb:
>                                                                                                             if pg is NOT uptodate:
>                                                                                                                 __extent_read_full_page(pg)
> 
> So t3's eb->io_pages is not consistent with the number of pages it's
> reading, and during endio(), atomic_dec_and_test(&eb->io_pages) will
> get a negative number so that we're not able to free the eb.

Thanks for the details, that helped me. I'll add the schematic to the
commit log.

Reviewed-by: David Sterba <dsterba@suse.com>
