Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbbFONPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:15:08 -0400
Date: Mon, 15 Jun 2015 15:15:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
Message-ID: <20150615131507.GL6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com>
 <557E86A9.8040207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557E86A9.8040207@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:02:49PM +0800, Qu Wenruo wrote:
> In the following case of corruption, RAID1 or DUP will fail to recover
> it(Use 16K as leafsize)
> 0		4K		8K		12K		16K
> Mirror 0:
> |<-OK---------->|<----ERROR---->|<-----------------OK------------->|
> 
> Mirror 1:
> |<----------------------------OK--------------->|<------Error----->|
> 
> Since the CRC32 stored in header is calculated for the whole leaf,
> so both will fail the CRC32 check.
> 
> But the corruption are in different position, in fact, if we know where
> the corruption is (no need to be so accurate), we can recover the tree
> block by using the current part.
> 
> In above example, we can just use the correct 0~12K from mirror 1
> and then 12K~16K from mirror 0.

If the mirror 0 copy is intact, you can use it entirely. Your
improvement could help if each mirror is partially broken but we can
find good copies of all 4k blocks among all mirrors.

The natural question is how often this happens and if it's worth adding
the code complexity and what's the estimated speed drop.

I think the conditions are very rare and that we could add minimal code
to attempt to build the metadata block from the available copies without
the separate block checksums. This is an immediate idea so I could have
missed something:

* if a metadata-block checksum mismatches, do a direct comparison of the
  metadata-blocks in all available mirrors
  * if they match and checksums match, no help, it's damaged
  * if there's a good copy (ie the original checksum or data were
    corrupted), use it
  * otherwise attempt to rebuild the metadata block from what's available

* by direct comparisons of the 4k blocks, find the first where the
  metadataA and mirror1 blocks mismatch, offset N
* try to compute the checksum from metadataA[0..N-1] + mirror1 block N +
  rest of metadataA
  * if it's ok, use it
  * if not: the block N is corrupted in mirror1 (we've skipped it in
    metadataA)
    then repeat with metadataA[0..N] + mirror1[N+1..end]

That's a rough idea that I hope will cover most of the cases when it
happens. With some more exhaustive attempts to rebuild the metadata
block we can try to repair 2 damaged blocks.

As this is completely independent, we can test it separately, and also
add it as a rescue feature to the userspace tools.

> Yes, this corruption case may be minor enough, since even corruption in
> one mirror is rare enough.
> So I didn't introduce a new CRC32 checksum, but use the extra 32-4 bytes
> to store the partial CRC32 to keep the backward compatibility.

The above would work with any checksums, without the need to store the
per-block checksums which become impossible with strongher algorithms.
