Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753297AbdKWUrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 15:47:14 -0500
MIME-Version: 1.0
Message-ID: <trinity-60cff444-b07e-45c4-9090-9b8bf257bc11-1511470033242@3c-app-mailcom-bs15>
From: koller@caramail.com
To: linux-btrfs@vger.kernel.org
Subject: Re: Issue in recovering and using the mirror superblock
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Nov 2017 21:47:13 +0100
In-Reply-To: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
References: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As an update to my previous email:

I attempted the visual inspection of the second superblock (located at 256 GB) inside the .dd image by using

tail -c +$((0x4000000000+1)) /run/media/user01/SamsungHD/sda2.dd |hexdump -C|less

and sure enough, it shows that the supeblock is right there, clearly marked by the header string “_BHRfS_”, no mistake about it. Of course, this is no guarantee that it may not be corrupt. But why should it be? This part of the disk was not touched by the overwriting which damaged the partition -- and there was never a physical damage to the disk. 
Rather than assuming that there is some problem with this superblock it’s more reasonable to assume that there is some issue with the recovery tools I have used so far. 

Here is the report of my attempts to use the second superblock by using the availble recovery tools:

Both btrfsck and "btrfs rescue super-recover" produced the same error message.


When i ran:

sudo btrfsck -s2 /run/media/user01/SamsungHD/sda2.dd

I got:

using SB copy 2, bytenr 274877906944
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
bytenr mismatch, want=20971520, have=709
ERROR: cannot read chunk root
ERROR: cannot open file system

As reported in the previous email, when I used btrfs restore I got exactly the same error message.


HOWEVER, with "btrfs rescue super-recover" I got a totally different response:

Before Recovering:
	[All good supers]:
		device name = /run/media/user01/SamsungHD/sda2.dd
		superblock bytenr = 67108864

		device name = /run/media/user01/SamsungHD/sda2.dd
		superblock bytenr = 274877906944

	[All bad supers]:

All supers are valid, no need to recover

This message above ("All supers are valid, no need to recover") is also problematic, because in actuality the first mirror image at 64 MB is missing (I checked with hexdump, and it is not there at the expected location 0x4000000). 

Anyway, for sure there is some inconsistency between the behavior of the tools -- and none of them is helpful! 

I don’t know what to make of all this, but I am still left wondering what to do next. I have the second superblock, from which in theory I could restore my filesystem (or part of it), but I don’t know how to use it. I need some tools that work...

Any ideas?

Thanks








> Sent: Thursday, November 23, 2017 at 6:31 PM
> From: koller@caramail.com
> To: linux-btrfs@vger.kernel.org
> Subject: Issue in recovering and using the mirror superblock
>
> Hi,
> 
> I am trying to recover from a mistake I made by overwriting the first GBs of my Btrfs /home partition with a non-Btrfs filesystem.
> 
> I have already made a .dd image of the partition, and I am using it to try and find the mirror superblock, in particular the one at 256 GB.
> 
> When I run the "btrfs restore" command I get an error message, maybe because the mirror superblock -- I am not sure about the reason.
> 
> Using the dummy run option, from the command line I do
> 
> btrfs restore -D -u 2 /run/media/user01/SamsungHD/sda2.dd /run/media/user01/ToshibaHD/RecoveredData
> 
> The message is get is:
> 
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=20971520, have=709
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> 
> With the -u 1 option (instead of -u 2) I get:
> 
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=20971520, have=709
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=20971520, have=709
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> 
> I have reason to believe that the mirror superblock at 256 GB is intact (I am assuming that only the initial sectors of the partition were overwritten), so I do not understand why it is not being recovered. BTW, the size of the partition is above 300 GBs, so there is supposed to be a mirror superblock at 256 GB.
> 
> Can anyone help me?
> 
> --------
> 
> Here is the btrfs info:
> 
> uname -a
> Linux adfa-workstation 4.9.63-1-MANJARO #1 SMP PREEMPT Sat Nov 18 14:12:41 UTC 2017 x86_64 GNU/Linux
> 
> btrfs --version
> btrfs-progs v4.13
> 
> Thanks
> 
> Terry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
