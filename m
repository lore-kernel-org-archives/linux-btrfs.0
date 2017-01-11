Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18905 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdAKSFs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 13:05:48 -0500
Date: Wed, 11 Jan 2017 10:05:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] sharing pages between mappings
Message-ID: <20170111180537.GA10498@birch.djwong.org>
References: <CAJfpegv9EhT4Y3QjTZBHoMKSiVGtfmTGPhJp_rh3a7=rFCHu5A@mail.gmail.com>
 <20170111115143.GJ16116@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170111115143.GJ16116@quack2.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2017 at 12:51:43PM +0100, Jan Kara wrote:
> On Wed 11-01-17 11:29:28, Miklos Szeredi wrote:
> > I know there's work on this for xfs, but could this be done in generic mm
> > code?
> > 
> > What are the obstacles?  page->mapping and page->index are the obvious
> > ones.
> 
> Yes, these two are the main that come to my mind. Also you'd need to
> somehow share the mapping->i_mmap tree so that unmap_mapping_range() works.
> 
> > If that's too difficult is it maybe enough to share mappings between
> > files while they are completely identical and clone the mapping when
> > necessary?
> 
> Well, but how would the page->mapping->host indirection work? Even if you
> have identical contents of the mappings, you still need to be aware there
> are several inodes behind them and you need to pick the right one
> somehow...
> 
> > All COW filesystems would benefit, as well as layered ones: lots of
> > fuse fs, and in some cases overlayfs too.
> > 
> > Related:  what can DAX do in the presence of cloned block?
> 
> For DAX handling a block COW should be doable if that is what you are
> asking about. Handling of blocks that can be written to while they are
> shared will be rather difficult (you have problems with keeping dirty bits
> in the radix tree consistent if nothing else).

I'm also interested in this topic, though I haven't gotten any further
than a hand-wavy notion of handling cow by allocating new blocks, memcpy
the contents to the new blocks (how?), then update the mappings to point
to the new blocks (how?).  It looks a lot easier now with the iomap
stuff, but that's as far as I got. :)

(IOWs it basically took all the time since the last LSF to get reflink
polished enough to handle regular files reasonably well.)

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
