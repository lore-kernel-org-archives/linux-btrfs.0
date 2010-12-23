From: Chris Ball <cjb@laptop.org>
Subject: Re: kernel BUG
Date: Thu, 23 Dec 2010 14:43:39 -0500
Message-ID: <m3hbe446ms.fsf@pullcord.laptop.org>
References: <20101223191213.50848c09@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101223191213.50848c09@simplux> (Dipl.'s message of "Thu, 23
	Dec 2010 19:12:13 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Hi!  I got a kernel BUG at
   > 
   > fs/btrfs/disk-io.c:2311
   > 
   > when testing the 2.6.37-rc5 kernel today.

It's good to mention which line this is, since the line numbers are
always changing.  This is:

        if (total_errors > max_errors) {
                printk(KERN_ERR "btrfs: %d errors while writing supers\n",
                       total_errors);
                BUG();
        }
                                                                       
in write_all_supers().  Does dmesg say anything about the nature of
the errors above the BUG() line?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
