From: "Michael Niederle" <mniederle@gmx.at>
Subject: Re: kernel BUG
Date: Fri, 24 Dec 2010 01:32:24 +0100
Message-ID: <20101224013224.43c0f9b3@simplux>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org>
	<20101223215500.4f177913@simplux>
	<m3d3os3tuz.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3d3os3tuz.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris!

>    > But exactly the same crash happened again some minutes ago. (I'm
>    > now back to my old kernel.)  
> 
> Not sure I understand.  Do you mean that the same crash happens on
> your older kernel now, or that you've reverted to your older kernel
> because you had another -rc5 crash?  If the crash happens on -rc5 but
> not the older kernel (what revision is the older kernel?), that's
> extremely interesting.

It happened again on -rc5.

But the reason for the crashes could also be a hardware problem - today I used
(unintentionally) another USB-port (USB 2.0) for the drive containing the
btrfs-file-system then I used (for several month) before (USB 3.0).

Currently I'm running with -rc7. If the system still runs tomorrow morning I
will do another test with -rc5 - this time on the USB 3.0 port. This should show
whether this is a hardware or software problem.

Greetings, Michael
