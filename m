From: Timothy Renner <timothy.renner@gmail.com>
Subject: Unable to remove devices in multi-device setup
Date: Thu, 23 Jun 2011 11:40:07 -0700
Message-ID: <4E038887.4070709@gmail.com>
Reply-To: timothy.renner@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Apologies if this has been asked already...

I am testing btrfs across multiple devices to see if removing them is 
working smoothly yet(smallish loopback devices, a few 2GB and one 5GB) 
and I always seem to hit a point where I can no longer remove a device.  
I've created the filesystem as RAID 0, so there should be no duplication 
of metadata or data.  I'm running yesterday's git checkout of 
btrfs-progs and kernel 2.6.39.1, so am reasonably up to date.


Label: none  uuid: 3898d5ac-868f-41d3-94ad-89be0b6c5841
         Total devices 3 FS bytes used 3.10GB
         devid    6 size 2.00GB used 2.00GB path /dev/loop0
         devid    5 size 2.00GB used 309.81MB path /dev/loop1
         devid    7 size 5.08GB used 2.00GB path /dev/loop4

(= ~9 GB total space)

/dev/sda7            158374020 107979012  42350036  72% /d

Data, RAID0: total=4.03GB, used=3.10GB
System, RAID0: total=16.00MB, used=4.00KB
Metadata, RAID0: total=256.00MB, used=3.66MB

When I try to remove /dev/loop1, it chugs away for a while, 
re-allocating my data and then I get the error: "ERROR: error removing 
the device '/dev/loop1'"

My first question is why the data on this device can't be fully 
re-allocated, even though there is plenty of space on other of the other 
devices...  Is this a currently known bug in removing devices, or is 
there a good reason that brtfs can't let go of this device?  Is it 
holding onto a metadata block and can't re-allocate it elsewhere?  I've 
tried a rebalance to no effect... It moves some data back into 
/dev/loop1, but on a remove I run into the same problem.

My second question is:  Is there is a public bug database for btrfs?  A 
bugzilla or other such setup?

-Tim

