Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3FMVJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 17:09:04 -0400
Message-ID: <51BA34EC.1080800@friedels.name>
Date: Thu, 13 Jun 2013 23:09:00 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: raid0, raid1, raid5, what to choose?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'd appreciate your recommendation on this:

I have three hdd with 3TB each. I intend to use them as raid5 eventually.
currently I use them like this:

# mount|grep sd
/dev/sda1 on /mnt/Datenplatte type ext4
/dev/sdb1 on /mnt/BTRFS/Video type btrfs
/dev/sdb1 on /mnt/BTRFS/rsnapshot type btrfs

#df -h
/dev/sda1       2,7T  1,3T  1,3T  51% /mnt/Datenplatte
/dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/Video
/dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/rsnapshot

Now, what surprises me, and here I lack memory- is that sdb appears 
twice.. I think, I created a raid1, but how can I find out?

#/usr/local/smarthome# ~/btrfs/btrfs-progs/btrfs fi show /dev/sdb1
Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
         Total devices 2 FS bytes used 2.68TB
         devid    2 size 2.73TB used 2.73TB path /dev/sdc1
         devid    1 size 2.73TB used 2.73TB path /dev/sdb1

Now, I wanted to convert it to raid0, because I lack space and 
redundancy is not important for the Videos and the Backup, but this fails:
~/btrfs/btrfs-progs/btrfs fi balance start -dconvert=raid0  /mnt/BTRFS/
ERROR: error during balancing '/mnt/BTRFS/' - Inappropriate ioctl for device

dmesg does not help here.

Anyway: This gave me some time to think about this. In fact, as soon as 
raid5 is stable, I want to have all three as a raid5. Will this be 
possible with a balance command? If so: will this be possible as soon as 
raid5 is stable, or will I have to wait longer?

What approach do you recommend?

Greetings,
Hendrik





