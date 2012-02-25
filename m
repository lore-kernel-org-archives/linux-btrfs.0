From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: block rsv returned -28
Date: Sat, 25 Feb 2012 04:31:58 +0000 (UTC)
Message-ID: <pan.2012.02.25.04.31.57@cox.net>
References: <4F4846E1.50307@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christian Robert posted on Fri, 24 Feb 2012 21:26:41 -0500 as excerpted:

> [ 1326.479217] hdparm: sending ioctl 330 to a partition!
> [ 1326.479219] hdparm: sending ioctl 330 to a partition!
> [ 1327.639153] parted: sending ioctl 1261 to a partition!
> [ 1327.639157] parted: sending ioctl 1261 to a partition!

FWIW, these warnings are expected ATM and don't have anything to do with 
btrfs.

They relate to kernel changes that will eventually result in increased 
strictness and security (hdparm won't be able to send suspend commands to 
a single partition, for instance, when it'll obviously apply to the whole 
drive), but are for now simply warnings, when whole-device commands are 
sent to a single partition instead of the whole device, thus allowing 
time for the necessary changes in userspace apps to be made.

There was an article about it in the LWN weekly edition some weeks ago.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

