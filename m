From: Chris Ball <cjb@laptop.org>
Subject: Re: Mount via /etc/fstab constant failure
Date: Thu, 31 Dec 2009 14:24:12 -0500
Message-ID: <m3hbr73q1v.fsf@pullcord.laptop.org>
References: <200912311822.57397.regomodo@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: regomodo <regomodo@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912311822.57397.regomodo@googlemail.com>
	(regomodo@googlemail.com's message of "Thu, 31 Dec 2009 18:22:57
	+0000")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Reg,

   > Hi, I have a btrfs 'pool' of x2 Samsung 500GB HDD's in non-raid
   > format. It works fine for the most part except for mounting on
   > bootup. Every bootup I have to change the block-device to and fro
   > /dev/sda & /dev/sdb. This happens on linux-2.6.32.2 and
   > 2.6.33-rc2.

Are you running "btrfsctl -a" in an initrd?  It's necessary to do that
before the mount call on a multi-disk volume.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
