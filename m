From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Unable to mount btrfs after crash
Date: Mon, 13 Apr 2009 09:31:31 -0400
Message-ID: <20090413133131.GA26533@infradead.org>
References: <EE151463-E687-43D0-91E0-02003C32972F@hachre.de> <1239629308.24841.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Glatt <mail@hachre.de>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1239629308.24841.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2009 at 09:28:28AM -0400, Chris Mason wrote:
> On Sun, 2009-04-12 at 02:03 +0200, Harald Glatt wrote:
> > Hi,
> > 
> > I have set up a btrfs within a 200 GB file that I mount via -o loop.
> > 
> > It worked fine so far but today it crashed when there was alot of  
> > concurrent writing/reading going on.
> > I'm testing it with a torrent client, so the data is really irrelevant  
> > - but it's a good amount of stress.
> > 
> 
> Loopback is somewhat tricky because the kernel loopback driver only
> writes into the page cache of the underlying file in the host
> filesystem.  So, the filesystem inside the loopback file thinks it has
> written things to disk but in reality it is just in cache.
> 
> If you crash in the middle of all of this, you're going to see
> significant corruptions of the FS inside the loopback file.

There's a patch floating around to add barrier support to the loop
driver to fix this issue.  I hoped it would get merged for 2.6.30
but it's not in yet.

