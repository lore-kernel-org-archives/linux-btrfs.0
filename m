Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41228 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaBIGjW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 01:39:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCO2y-0003uP-Ko
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 07:39:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 07:39:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 07:39:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 9 Feb 2014 06:38:53 +0000 (UTC)
Message-ID: <pan$e196e$601e36f4$65c8817c$b6141c66@cox.net>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de>
	<20140209041050.529ff6f9@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sun, 09 Feb 2014 04:10:50 +0600 as excerpted:

> If you need to perform a btrfs-specific operation, you can easily use
> the btrfs-specific tools to prepare for it, specifically use "btrfs fi
> df" which could give provide every imaginable interpretation of free
> space estimate and then some.
> 
> UNIX 'df' and the 'statfs' call on the other hand should keep the
> behavior people are accustomized to rely on since 1970s.

Which it does... on filesystems that only have 1970s filesystem features. 
=:^)

RAID or multi-device filesystems aren't 1970s features and break 1970s 
behavior and the assumptions associated with it.  If you're not prepared 
to deal with those broken assumptions, don't.  Use mdraid or dmraid or lvm 
or whatever to combine your multiple devices into one logical devices as 
presented, and put your filesystem (either traditional filesystem, or 
even btrfs using traditional single-device functionality) on top of the 
single device the layer beneath the filesystem presents.  Problem solved! 
=:^)

Note that df only lists a single device as well, not the multiple 
component devices of the filesystem.  That's broken functionality by your 
definition, too, and again, using some other layer like lvm or mdraid to 
present multiple devices as a single virtual device, with a traditional 
single-device filesystem layout on top of that single device... solves 
the problem!


Meanwhile, what I've done here is use one of df's commandline options to 
set its block size to 2 MiB, and further used bash's alias functionality 
to setup an alias accordingly:

alias df='df -B2M'

$ df /h
Filesystem     2M-blocks  Used Available Use% Mounted on
/dev/sda6          20480 12186      7909  61% /h

$ sudo btrfs fi show /h
Label: hm0238gcnx+35l0  uuid: ce23242a-b0a9-423f-a9c3-7db2729f48d6
        Total devices 2 FS bytes used 11.90GiB
        devid    1 size 20.00GiB used 14.78GiB path /dev/sda6
        devid    2 size 20.00GiB used 14.78GiB path /dev/sdb6

$ sudo btrfs fi df /h
Data, RAID1: total=14.00GiB, used=11.49GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=768.00MiB, used=414.94MiB


On btrfs such as the above I can read the 2M blocks as 1M and be happy.  
On btrfs such as my /boot, which aren't raid1 (I have two separate 
/boots, one on each device, with grub2 configured separately for each to 
provide a backup), or if I df my media partitions still on reiserfs on 
the old spinning rust, I can either double the figures DF gives me, or 
add a second -B option at the CLI, overriding the aliased option.

If I wanted something fully automated, it'd be easy enough to setup a 
script that checked what filesystem I was df-ing, matched that against a 
table of filesystems to preferred df block sizes, and supplied the 
appropriate -BxX option accordingly.  As I guess most admins after a few 
years, I've developed quite a library of scripts/aliases for various 
things I do routinely enough to warrant it, and this would be just one 
more joining the list. =:^)


But of course it's your system in question, and you can patch btrfs to 
output anything you like, in any format you like.  No need to bother with 
df's -B option if you'd prefer to patch the kernel instead.  Me, I'll 
stick to the -B option.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

