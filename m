Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab3BTMy4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 07:54:56 -0500
Date: Wed, 20 Feb 2013 13:54:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified.
Message-ID: <20130220125453.GB9521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360167017-19632-1-git-send-email-mitch.harder@sabayonlinux.org>
 <20130206184621.GP14246@lenny.home.zabbo.net>
 <CAKcLGm-D18+J0fAm+rXU7-424PODP023KxrBOs_YMGF4B1+KWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm-D18+J0fAm+rXU7-424PODP023KxrBOs_YMGF4B1+KWg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 06, 2013 at 05:41:42PM -0600, Mitch Harder wrote:
> On Wed, Feb 6, 2013 at 12:46 PM, Zach Brown <zab@redhat.com> wrote:
> >> +     unsigned compressed_extent_size;
> >
> > It kind of jumps out that this mentions neither that it's the max nor
> > that it's in KB.  How about max_compressed_extent_kb?
> >
> >> +     fs_info->compressed_extent_size = 128;
> >
> > I'd put a DEFAULT_MAX_EXTENTS up by the MAX_ definition instead of using
> > a raw 128 here.
> >
> >> +     unsigned long max_compressed = root->fs_info->compressed_extent_size * 1024;
> >> +     unsigned long max_uncompressed = root->fs_info->compressed_extent_size * 1024;
> >
> > (so max_compressed is in bytes)
> >
> >>       nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
> >> -     nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
> >> +     nr_pages = min(nr_pages, (max_compressed * 1024UL) / PAGE_CACHE_SIZE);
> >
> > (and now that expression adds another * 1024, allowing {128,512}MB
> > extents :))
> >
> 
> Yuk!  I'm surprised this never manifested as a problem during testing.

Answer for the curious:

cow_file_range_async()

1076                 if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
1077                         cur_end = end;
1078                 else
1079                         cur_end = min(end, start + 512 * 1024 - 1);

in case of a compressed extent the end is at most 512K and the range
[start,end) processed in comprssed_file_range() calculates nr_pages from
that range.

So, 512 should be replaced wit max_compressed_extent_kb value. I've
experimented with higher values, it starts to break with 1024. The
errors seem to be around calculating block checksums and they just do
not fit into one page, roughly:

blocks = 1M / 4096 = 256
csum bytes = csum * blocks = 4 * 256 = 4096
leaf headers + csum bytes > PAGE_SIZE and slab debug reports corruption

max at 768 worked fine, the safe maximum is ~900.


david
