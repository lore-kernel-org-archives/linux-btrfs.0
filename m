Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 04:55:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCR6N-0006ix-2z
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 10:55:03 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 10:55:03 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 10:55:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 09 Feb 2014 10:37:03 +0100
Message-ID: <vqujsa-7l3.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de> <20140209041050.529ff6f9@natsu> <pan$e196e$601e36f4$65c8817c$b6141c66@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> Roman Mamedov posted on Sun, 09 Feb 2014 04:10:50 +0600 as excerpted:
> 
>> If you need to perform a btrfs-specific operation, you can easily use
>> the btrfs-specific tools to prepare for it, specifically use "btrfs fi
>> df" which could give provide every imaginable interpretation of free
>> space estimate and then some.
>> 
>> UNIX 'df' and the 'statfs' call on the other hand should keep the
>> behavior people are accustomized to rely on since 1970s.
> 
> Which it does... on filesystems that only have 1970s filesystem features.
> =:^)
> 
> RAID or multi-device filesystems aren't 1970s features and break 1970s
> behavior and the assumptions associated with it.  If you're not prepared
> to deal with those broken assumptions, don't.  Use mdraid or dmraid or lvm
> or whatever to combine your multiple devices into one logical devices as
> presented, and put your filesystem (either traditional filesystem, or
> even btrfs using traditional single-device functionality) on top of the
> single device the layer beneath the filesystem presents.  Problem solved!
> =:^)
> 
> Note that df only lists a single device as well, not the multiple
> component devices of the filesystem.  That's broken functionality by your
> definition, too, and again, using some other layer like lvm or mdraid to
> present multiple devices as a single virtual device, with a traditional
> single-device filesystem layout on top of that single device... solves
> the problem!
> 
> 
> Meanwhile, what I've done here is use one of df's commandline options to
> set its block size to 2 MiB, and further used bash's alias functionality
> to setup an alias accordingly:
> 
> alias df='df -B2M'
> 
> $ df /h
> Filesystem     2M-blocks  Used Available Use% Mounted on
> /dev/sda6          20480 12186      7909  61% /h
> 
> $ sudo btrfs fi show /h
> Label: hm0238gcnx+35l0  uuid: ce23242a-b0a9-423f-a9c3-7db2729f48d6
>         Total devices 2 FS bytes used 11.90GiB
>         devid    1 size 20.00GiB used 14.78GiB path /dev/sda6
>         devid    2 size 20.00GiB used 14.78GiB path /dev/sdb6
> 
> $ sudo btrfs fi df /h
> Data, RAID1: total=14.00GiB, used=11.49GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=768.00MiB, used=414.94MiB
> 
> 
> On btrfs such as the above I can read the 2M blocks as 1M and be happy.
> On btrfs such as my /boot, which aren't raid1 (I have two separate
> /boots, one on each device, with grub2 configured separately for each to
> provide a backup), or if I df my media partitions still on reiserfs on
> the old spinning rust, I can either double the figures DF gives me, or
> add a second -B option at the CLI, overriding the aliased option.
> 
> If I wanted something fully automated, it'd be easy enough to setup a
> script that checked what filesystem I was df-ing, matched that against a
> table of filesystems to preferred df block sizes, and supplied the
> appropriate -BxX option accordingly.  As I guess most admins after a few
> years, I've developed quite a library of scripts/aliases for various
> things I do routinely enough to warrant it, and this would be just one
> more joining the list. =:^)

Well done... And a good idea, I didn't think of it yet. But it's my idea of 
fixing it in user space. :-)

I usually leave the discussion when people start to argument with pointers 
to unix tradition... That's like starting a systemd discussion and telling 
me that systemd is broken by design while mentioning in the same sentence 
that sysvinit is working perfectly fine. The latter doesn't do so. The first 
is a matter of personal taste but is in no case broken... But... Well...

> But of course it's your system in question, and you can patch btrfs to
> output anything you like, in any format you like.  No need to bother with
> df's -B option if you'd prefer to patch the kernel instead.  Me, I'll
> stick to the -B option.  =:^)

That's essentially the FOSS idea. Actually, I don't want df behavior being 
broken for me. It uses fstat syscall, that returns blocks. Cutting returned 
values into half lies about the properties of the device - for EVERY 
application out there, no matter which assumptions are being made about the 
returned values. This breaks the fstat syscall. User-space should simply not 
rely on the assumption that 1k of user data occupies 1k worth of blocks 
(that's not true anyways because meta-data has to be allocated, too). When I 
had contact with unix first, df returned used/free blocks - native BLOCKS! 
No option to make it human readable. No forced intention that it would show 
you usable space for actual written data. The blocks were given as 512-byte 
sectors. I've been okay with that. I knew: If I cut the values in half, I'd 
get about the size of data I perhabs could fit in the device. If it had been 
a property of the device that 512 byte of user data would write two blocks, 
nobody had cared about df displaying "wrong" values.
 
-- 
Replies to list only preferred.

