Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbaFCPx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 11:53:57 -0400
Date: Tue, 3 Jun 2014 17:53:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Philip Worrall <philip.worrall@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Add support for LZ4 compression
Message-ID: <20140603155353.GP22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 31, 2014 at 11:48:28PM +0000, Philip Worrall wrote:
> LZ4 is a lossless data compression algorithm that is focused on 
> compression and decompression speed. LZ4 gives a slightly worse
> compression ratio compared with LZO (and much worse than Zlib)
> but compression speeds are *generally* similar to LZO. 
> Decompression tends to be much faster under LZ4 compared 
> with LZO hence it makes more sense to use LZ4 compression
> when your workload involves a higher proportion of reads.
> 
> The following patch set adds LZ4 compression support to BTRFS
> using the existing kernel implementation. It is based on the 
> changeset for LZO support in 2011. Once a filesystem has been 
> mounted with LZ4 compression enabled older versions of BTRFS 
> will be unable to read it. This implementation is however 
> backwards compatible with filesystems that currently use 
> LZO or Zlib compression. Existing data will remain unchanged 
> but any new files that you create will be compressed with LZ4.

tl;dr simply copying what btrfs+LZO does will not buy us anything in
terms of speedup or space savings.

I've been working on adding LZ4 to btrfs for some time and still do in
my spare time. The project idea roughly outlines my goals:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Compression_enhancements

The initial compression support introduced a very simple format of the
compressed data. The simplicity was probably a good choice for a first
approach and allowed early adoption.

The main drawback of the format is that the compressed data are fed to
the compressor in 4k (page size) blocks and LZO (same for LZ4) does not
keep and reuse the state from previous blocks. This is different from
ZLIB which does, but is slower more yet more space effective.

The small blocks do not give much space for data reuse and the results
for LZO and LZ4 are very close, the difference was not measurable in my
tests. The raw speed of compression/decompression of the algorithms is
different, but we have to measure it under real loads where eg. the
decompression speedup does not weigh much in the overall performance.

The natural step forward is to compress in larger blocks, but this also
means designing new storage format for the compressed data and change
the kernel implementation accordingly. Also, this is not something that
can be done incrementally. One incompat bit should completely cover the
new stuff.

At the moment, there is no strong need for LZ4, though there are
numerous remarks in the online media about when btrfs will support it.

The situation was different for ZFS. The original compressor was LZJB,
that was derived from LZRW1 and tweaked for speed. The ratio suffered a
from that. LZO is better in this regard and the licensing issues do not
prevent adding it to btrfs, unlike ZFS (though there were other
concerns). LZ4 is released under BSD license, so it was a natural choice
IMO.

The usecase for LZ4 in btrfs builds on the high compressor mode that
maintains the same binary format but is able to achieve higher ratio.
The high compression would be triggered through defrag if there are
resources available, otherwise the real-time version would be used for
new writes. Applying a defrag on the system files (binaries, libs)
should improve performance in the read-mostly load you've mentioned
above.

I don't have much time to continue on that. I dont't mind sharing the
code (some draft is lying around in my git repos) and letting somebody
continue, but this needs experience with kernel internals regarding
memory management and performance tuning.

So, this is a NAK for your patchset.
