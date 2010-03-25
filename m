From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Thu, 25 Mar 2010 18:38:54 -0400
Message-ID: <4BABE5FE.1000701@gmail.com>
References: <4BA6E563.4090206@gmail.com> <87sk7r60zw.fsf@basil.nowhere.org> <4BA93530.4080303@gmail.com> <20100324023711.GC20695@one.firstfloor.org> <4BAAD397.8060408@gmail.com> <20100325094119.GJ20695@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100325094119.GJ20695@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
> On Wed, Mar 24, 2010 at 11:08:07PM -0400, jim owens wrote:
>> Agree, so the write design needs to prevent bad checksums.
> 
> How? Do you have a plan for that?

Yes... have Josef do it. ;)

The options I considered are:
1 - buffer always for uncompressed, the same as compressed.
2 - checksum before bio_add_page and again before page_cache_release
and fail or do buffering if checksum mismatch.
3 - write protect pages and block them in fault handler.

#3 is done in other operating systems but is painful, so I would
choose #2 because I think we can do more I/O that way at almost
the same cpu cost as #1 and we don't double the memory use.

jim
