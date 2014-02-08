Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:50616 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaBHS3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 13:29:12 -0500
Received: from homiemail-a14.g.dreamhost.com (caiajhbdcahe.dreamhost.com [208.97.132.74])
	by hapkido.dreamhost.com (Postfix) with ESMTP id E3FFC9581
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Feb 2014 10:29:10 -0800 (PST)
Message-ID: <52F6776C.4000109@spicycrypto.ca>
Date: Sat, 08 Feb 2014 13:29:00 -0500
From: Nathan Kidd <nathan@spicycrypto.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Recovering from persistent  kernel oops on  'btrfs balance'
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I added a 2nd device and 'btrfs balance' crashed (kernel oops) half way 
through, now I can only read the fs from a rawhide livedvd, but even 
that can't fix the fs (finish balance, or remove 2nd device to try 
again).  I'd be grateful for any advice on getting back to a working 
btrfs filesystem.

Details
=======

Hardware： Asus P5G41T-M with Pentium dual core E2140，4GB ram, OS on 
ext4 drive, two 4TB Segate "NAS" SATA drives.

On Ubuntu 13.04 x86_64 (3.8 kernel, btrfs-tools 0.19+20130117)

1. Install new 4TB drive (/dev/sdb), use gparted to create full-disk 
btrfs partition, mount on /ark copy ~500GB data, everything working well 
for a couple weeks

2. Install additional identical 4TB drive,

Following 
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Adding_new_devices

3. btrfs device add /dev/sdc /ark

4. btrfs balance start -dconvert=raid1 -mconvert=raid1 /ark

5. After ~1 hour, at about 50% (according to 'btrfs balance status', the 
system locks up with this displayed (sorry, JPEG): 
http://i.imgur.com/Ds9pnZV.jpg

6. System repeat same oops on startup

7. After removing /dev/sdc system boots but can't see anything on /ark

I guess using a 3.8 kernel wasn't the smartest idea. Let's update.

8. Update to Ubuntu 13.11 x86_64 (3.11 kernel, btrfs-tools 
0.19+20130705-1) 	

9. Now system boots with /dev/sdc plugged in but still can't see data on 
/ark, IIRC the balance command gave similar kernel oops.

10。 Fine I'll try Rawhide. From Jan 30, 2014, kernel 
3.14.0-0.rc0.git17.1.fc21.x86_64

11. I can see data on /ark！

12. If I try to 'btrfs balance resume' or 'btrfs balance cancel' I get 
roughly the same kernel oops: http://pastebin.ca/2634583

13. 'btrfs device delete /dev/sdc /ark' says it cannot be done while 
balance is underway

14. Help!  Any suggestion on how to recover the btrfs fs?

My last resort idea is pull /dev/sdb (which seems to have actual data 
that rawhide can see), format /dev/sdc ext4, plug both drives in again 
and copy from btrfs /dev/sdb to ext4 /dev/sdc, then wipe the btrfs fs on 
/dev/sdb and try again with the 3.11 kernel (or just with rawhide?).
But that is a whole lot of copying it would be nice to avoid.

Thanks,

-Nathan


