From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Sun, 5 Feb 2012 16:15:20 +0000 (UTC)
Message-ID: <pan.2012.02.05.16.15.20@cox.net>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
	<82ivv8-dsn.ln1@hurikhan.ath.cx>
	<CAKcLGm_=bRf7g+ezE7OBRNka57Z_NcofkMW-XkGmC1jAFv0gyw@mail.gmail.com>
	<pjp109-kdo.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 05 Feb 2012 09:01:25 +0100 as excerpted:

> This is why I got this external backup disk. ;-)

You've tested that backup, I hope?  If you're using it as a system disk, 
be sure you can boot from it without the main disk running so the system 
can't pull anything from it.

I mention this because I have an external that's not directly bootable.  
I had to create a USB stick to boot from, that can then load the system 
off the unbootable USB drive after the kernel is loaded.  People could be 
caught out if they weren't aware it wasn't bootable...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

