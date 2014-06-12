Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbaFLIrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 04:47:51 -0400
Date: Thu, 12 Jun 2014 10:47:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, Philip Worrall <philip.worrall@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Add support for LZ4 compression
Message-ID: <20140612084750.GJ1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
 <20140603155353.GP22324@twin.jikos.cz>
 <538F2666.6030402@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538F2666.6030402@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 04, 2014 at 10:00:06AM -0400, Chris Mason wrote:
> I have a slightly different reason for holding off on these.  Disk
> format changes are forever, and we need a really strong use case for
> pulling them in.

The format upgrade is inevitable for full bidirectional interoperability
of filesystems with non-pagesized sectorsize and compression. At the
moment this is not possible even without compression, but patches are on
the way.

> With that said, thanks for spending all of the time on this.  Pulling in
> Dave's idea to stream larger compression blocks through lzo (or any new
> alg) might be enough to push performance much higher, and better show
> case the differences between new algorithms.

The space savings and speed gains can be measured outside of btrfs.
>From the past numbers I see that 4k->64k chunk brings another 5-10% of
ratio and the de/compression speed is not worse.

Bigger chunks do not improve that much, but the overhead for assembling
the linear mappings would be decreased.

> The whole reason I chose zlib originally was because its streaming
> interface was a better fit for how FS IO worked.

Right, zlib has the streaming interface and accepts randomly scattered
blocks, but the others do not. LZ4 has a streaming extension proposed,
but I haven't looked at it closely whether it satisfies our constraints.
