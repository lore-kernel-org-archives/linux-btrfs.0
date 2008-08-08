From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: block discard.
Date: Fri, 08 Aug 2008 15:10:17 +0100
Message-ID: <1218204617.12232.171.camel@pmac.infradead.org>
References: <1218202998.12232.161.camel@pmac.infradead.org>
	 <1218203792.15342.235.camel@think.oraclecorp.com>
	 <1218204306.12232.169.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218204306.12232.169.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-08 at 15:05 +0100, David Woodhouse wrote:
> On Fri, 2008-08-08 at 09:56 -0400, Chris Mason wrote:
> > So you mkfs ; dd large file ; rm large file ; look for discards?
> > 
> > Try rm large file ; sync ; sync; look for discards
> 
> Yeah, I did that. The actual data extent isn't getting removed.

Oh, you really did mean _two_ syncs. And then yes, I see why it isn't
working; mea culpa.

__free_extent for 0xc00000-0xc65000
num_bytes 413696, map_length 8388608, stripes 1
Discard from stripe 0: 24576-808
bio too big device ftla (808 > 255)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



