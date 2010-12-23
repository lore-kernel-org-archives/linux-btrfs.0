From: "Michael Niederle" <mniederle@gmx.at>
Subject: Re: kernel BUG
Date: Thu, 23 Dec 2010 21:55:00 +0100
Message-ID: <20101223215500.4f177913@simplux>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hbe446ms.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

>    > Hi!  I got a kernel BUG at
>    > 
>    > fs/btrfs/disk-io.c:2311
>    > 
>    > when testing the 2.6.37-rc5 kernel today.  
> 
> It's good to mention which line this is, since the line numbers are
> always changing.  This is:
> 
>         if (total_errors > max_errors) {
>                 printk(KERN_ERR "btrfs: %d errors while writing supers\n",
>                        total_errors);
>                 BUG();
>         }
>                                                                        
> in write_all_supers().  Does dmesg say anything about the nature of
> the errors above the BUG() line?

The message was output to the console of the crashed system - so I'm sorry I
cannot supply further informations.

But exactly the same crash happened again some minutes ago. (I'm now back to my
old kernel.)

Greetings, Michael
