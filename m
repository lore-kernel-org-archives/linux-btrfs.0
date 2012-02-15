From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache
 off?
Date: Wed, 15 Feb 2012 10:42:43 -0500
Message-ID: <1329320563.1897.6.camel@ayu>
References: <20120130003754.GD4380@merlins.org>
	 <20120201175624.GE16796@shiny> <20120202032345.GB31903@merlins.org>
	 <20120202124241.GW16796@shiny> <20120202152722.GI12429@merlins.org>
	 <20120130003754.GD4380@merlins.org> <20120201175624.GE16796@shiny>
	 <20120202032345.GB31903@merlins.org> <20120212223242.GA31989@merlins.org>
	 <4F384FAA.5060506@redhat.com> <20120213001400.GD31989@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, jeff@deserettechnology.com
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213001400.GD31989@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2012-02-12 at 16:14 -0800, Marc MERLIN wrote:
> Considering that I have a fairly new crucial 256GB SDD, I'm going to assume
> that this bit applies to me:
> "On the other side, TRIM is usually overrated. Drive itself should keep good
> performance even without TRIM, either by using internal garbage collecting
> process or by some area reserved for optimal writes handling."
> 
> So it sounds like I should just not give the "ssd" mount option to btrfs,
> and not worry about TRIM. 

The 'ssd' option on btrfs is actually completely unrelated to trim
support. Instead, it changes how blocks are allocated on the device,
taking advantage of the the improved random read/write speed. The 'ssd'
option should be autodetected on most SSDs, but I don't know if this is
handled correctly when you're using dm-crypt. (Btrfs prints a message at
mount time when it autodetects this.) It shouldn't hurt to leave it.

Discard is handled with a separate mount option on btrfs (called
'discard'), and is disabled by default even if you have the 'ssd' option
enabled, because of the negative performance impact it has had on some
SSDs.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

