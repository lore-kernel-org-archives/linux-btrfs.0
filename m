From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/1] ioctl to fetch csums of file extents
Date: Wed, 21 Jan 2009 12:57:36 -0500
Message-ID: <1232560656.22819.1.camel@think.oraclecorp.com>
References: <a37615150812191310y682c746bt4bd669c0fe5eb4ea@mail.gmail.com>
	 <a37615150812191314q30f7405agf40f4e6b352b123b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a37615150812191314q30f7405agf40f4e6b352b123b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-12-19 at 13:14 -0800, Yehuda Sadeh Weinraub wrote:
> This adds a new ioctl that requests for the csums of file's extent.
> The csums of contiguous extents can also be requested. The call will
> not return anything for extents that don't have csum information for
> their data, or that the csum list is not available.
> Presumably, the user calls fiemap first in order to get the list of
> extents. The max number of requested csum items is specified in the
> request and is updated according to the actual number of returned
> items.
> 

The swapfile discussions convinced me we're better off taking fiemap
support now and disabling bmap entirely, at least until we can fix the
swapfile code to work properly with btrfs.

So, I'd like to take this patch, but there is line wrapping and other
whitespace problems.  Could you please send it with a mail client that
doesn't mangle? ;)

(Attaching it is fine too, at least on this list)

Thanks!
-chris


