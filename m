From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Thu, 18 Dec 2008 10:55:35 -0500
Message-ID: <1229615735.27170.146.camel@think.oraclecorp.com>
References: <543762723@web.de> <20081216152004.GA7002@tux64-01>
	 <1229441170.27573.19.camel@think.oraclecorp.com>
	 <20081216162500.GA9685@tux64-01>
	 <099201c95fb6$d0633920$0301a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: Roland <devzero@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <099201c95fb6$d0633920$0301a8c0@bui.materna.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-16 at 20:45 +0100, Roland wrote:
> >I agree that adding more options will add more complexity but it seems
> > the same amount of work in kernel space will have to be done
> 
> regarding lzo compression itself - it`s already there(since july 2007).
> the in-kernel lzo is equivalent to minilzo. 
> (http://www.oberhumer.com/opensource/lzo/)

The compression code initially used the kernel lzo modules.  Even though
the zlib api is clunky and strange, it is actually a better fit to the
multi-page compressions that need to be done by btrfs.  So adding LZO
support would require some work to compress over multiple pages at a
time.

-chris


