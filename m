From: David Sterba <dave@jikos.cz>
Subject: Re: Details about compression and extents
Date: Thu, 12 Apr 2012 11:28:32 +0200
Message-ID: <20120412092832.GB23876@twin.jikos.cz>
References: <CAB9VWqCV2A9=nbbV59gPb9N_xBF_eivGE1rD7==qx0GSKe02og@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alexander Block <ablock84@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB9VWqCV2A9=nbbV59gPb9N_xBF_eivGE1rD7==qx0GSKe02og@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 10:27:13AM +0200, Alexander Block wrote:
> 1. How is decided what to compress and what not? After a fast test
> with a 2g image file, I've looked into the extents of that file with
> find-new and it turned out that only some of the first extents were
> compressed. The file was simply copied with cp.

with -o compress mount, a file extent is directly sent to compression
and if this turns out to be inefficient (ie. compressed size is larger
than uncompressed), then the NOCOMPRESS per-inode flag is set and no
further compression is done on that file. Yes this is not ideal and
this should be more adaptive than just bailing out completely after one
incompressible extent.

with -o compress-force the NOCOMPRESS flag is never set, so it may lead
to the other extreme that extents are compressed but it does not reduce
size at all.

> 2. I compared the extents of that mentioned file from a non-compressed
> fs and from a compressed fs and see much more and much smaller extents
> in the compressed fs. Does compression affect extent allocation or is
> this just a coincidence?

The extents size is limited to 128k right now, to reduce performance hit
when doing random reads from the middle. This also means more metadata
are needed for the extents.

> The source file was in use (VirtualBox was
> running) while I was copying it...if this has too much influence on
> extent allocation then please ignore the whole question.

This should not matter here.

> 3. How large are the blocks that get compressed? If it's dynamic, how
> is decided which size to use?

128k, fixed.

> 4. If there is no maximum on compressed extents size, is the whole
> extent compressed at once or in blocks?

currently in 4k blocks (where 4k == PAGE_CACHE_SIZE), though it also
depends on the compression method used. zlib is able to reuse the
dictionary for another block and the compression ratio is better at the
cost of speed.


david
