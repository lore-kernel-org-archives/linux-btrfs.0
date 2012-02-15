From: Marc MERLIN <marc@merlins.org>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Wed, 15 Feb 2012 08:55:40 -0800
Message-ID: <20120215165540.GC4763@merlins.org>
References: <20120202032345.GB31903@merlins.org> <20120202124241.GW16796@shiny> <20120202152722.GI12429@merlins.org> <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org> <20120212223242.GA31989@merlins.org> <4F384FAA.5060506@redhat.com> <20120213001400.GD31989@merlins.org> <1329320563.1897.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, jeff@deserettechnology.com
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329320563.1897.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 10:42:43AM -0500, Calvin Walton wrote:
> On Sun, 2012-02-12 at 16:14 -0800, Marc MERLIN wrote:
> > Considering that I have a fairly new crucial 256GB SDD, I'm going to assume
> > that this bit applies to me:
> > "On the other side, TRIM is usually overrated. Drive itself should keep good
> > performance even without TRIM, either by using internal garbage collecting
> > process or by some area reserved for optimal writes handling."
> > 
> > So it sounds like I should just not give the "ssd" mount option to btrfs,
> > and not worry about TRIM. 
> 
> The 'ssd' option on btrfs is actually completely unrelated to trim
> support. Instead, it changes how blocks are allocated on the device,
> taking advantage of the the improved random read/write speed. The 'ssd'
> option should be autodetected on most SSDs, but I don't know if this is
> handled correctly when you're using dm-crypt. (Btrfs prints a message at
> mount time when it autodetects this.) It shouldn't hurt to leave it.
 
Yes, I found out more after I got my laptop back up (I had limited search
while I was rebuilding it). Thanks for clearing up my improper guess at the
time :)

The good news is that ssd mode is autodetected through dmcrypt:
[   23.130486] device label btrfs_pool1 devid 1 transid 732 /dev/mapper/cryptroot
[   23.130854] btrfs: disk space caching is enabled
[   23.175547] Btrfs detected SSD devices, enabling SSD mode

> Discard is handled with a separate mount option on btrfs (called
> 'discard'), and is disabled by default even if you have the 'ssd' option
> enabled, because of the negative performance impact it has had on some
> SSDs.

That's what I read up later. It's a bit counter intuitive after all the work
what went into TRIM to then figure out that actually there are more reasons
not to bother with it then to do :)
On the plus side, it means SSDs are getting better and don't need special
code that makes data recovery harder should you ever need it.

I tried updating the wiki pages, because:
https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html
says nothing about
- trim/discard
- dmcrypt

while
https://btrfs.wiki.kernel.org/articles/g/o/t/Gotchas.html
still states 'btrfs volumes on top of dm-crypt block devices (and possibly
LVM) require write-caching to be turned off on the underlying HDD. Failing
to do so, in the event of a power failure, may result in corruption not yet
handled by btrfs code. (2.6.33) '

I'm happy to fix both pages, but the login link of course doesn't work and
I'm not sure where the canonical copy to edit actually is or if I can get
access.

That said if someone else can fix it too, that's great :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
