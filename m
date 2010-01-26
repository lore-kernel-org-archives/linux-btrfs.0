From: "Mr. Tux" <tuxoholic@hotmail.de>
Subject: Re: Howto mount intact left-over device of a degraded btrfs-raid?
Date: Tue, 26 Jan 2010 13:20:30 +0100
Message-ID: <BLU0-SMTP1013A688BD201E681FCA798D85E0@phx.gbl>
References: <BLU0-SMTP89D73FD06036781FE98000D8640@phx.gbl> <BLU0-SMTP645D546639865D7DF323B2D85F0@phx.gbl> <20100125220839.GC2204@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100125220839.GC2204@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 25 January 2010 23:08:39 Josef Bacik wrote:

Hi Josef

>
> Hmm well I'm trying to reproduce that here and it's working fine, course I
> can't pull a cable on my disk since I only have one disk to test with. 
> Would you mind sending me your dmesg after you try
>
> mount -o degraded /dev/sda1 /mnt/
>
> so I can see whats going on.  Thanks,
>

Did you try 2.6.32.2 from kernel.org? Is it possible to use  a second test 
drive like I did? I know you can create a raid array with one device missing, 
but the segfault happened with a two member raid1.

I don't have the test environment any more, so I can't offer a backtrace right 
now - but I will set it up again in the next few days. If it happens again I 
will contact you and send you a backtrace.

Mr. Tux

