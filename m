From: Arne Jansen <sensille@gmx.net>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Fri, 26 Aug 2011 08:37:14 +0200
Message-ID: <4E573F1A.2060807@gmx.net>
References: <4E54F884.9090004@cyberwizzard.nl> <CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Berend Dekens <btrfs@cyberwizzard.nl>, linux-btrfs@vger.kernel.org
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 26.08.2011 01:01, Gregory Maxwell wrote:
> On Wed, Aug 24, 2011 at 9:11 AM, Berend Dekens <btrfs@cyberwizzard.nl> wrote:
> [snip]
>> I thought the idea of COW was that whatever happens, you can always mount in
>> a semi-consistent state?
> [snip]
> 
> 
> It seems to me that if someone created a block device which recorded
> all write operations a rather excellent test could be constructed
> where a btrfs filesystem is recorded under load and then every partial
> replay is mounted and checked for corruption/data loss.
> 
> This would result in high confidence that no power loss event could
> destroy data given the offered load assuming well behaved
> (non-reordering hardware).  If it recorded barrier operations the a
> tool could also try many (but probably not all) permissible
> reorderings at every truncation offset.
> 

I like the idea. Some more thoughts:
 - instead of trying all reorderings it might be enough to just always
   deliver the oldest possible copy
 - the order in which btrfs writes the data probably depends on the
   order in which the device acknowledges the request. You might need
   to add some reordering there, too
 - you need to produce a wide variety of workloads, as problems might
   only occur at a special kind of it (directIO, fsync, snapshots...)
 - if there really is a regression somewhere, it would be good to also
   include the full block layer into the test, as the regression might
   not be in btrfs at all
 - as a first small step one could just use blktrace to record the write
   order and analyze the order on mount as well

> It seems to me that the existence of this kind of testing is something
> that should be expected of a modern filesystem before it sees
> widescale production use.
> --
