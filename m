From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: remove crc32c.h and use libcrc32c directly.
Date: Sun, 19 Apr 2009 19:30:35 -0400
Message-ID: <1240183836.10853.1.camel@think.oraclecorp.com>
References: <1240142561.3589.143.camel@macbook.infradead.org>
	 <1240182709.8932.2.camel@think.oraclecorp.com>
	 <1240183171.3589.421.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240183171.3589.421.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-20 at 00:19 +0100, David Woodhouse wrote:
> On Sun, 2009-04-19 at 19:11 -0400, Chris Mason wrote:
> > How does this enable the HW crc32c?  Unless I'm missing something you're
> > doing crc32c instead of btrfs_crc32c, but btrfs_crc32c was #defined to
> > crc32c?
> 
> It doesn't. You're _already_ using the hardware crc32c.
> 

Ok, that makes more sense ;) I'll fixup the changelog when I merge the
patch.  I didn't have the HW crc enabled in my config, so it wasn't
switching over.

-chris


