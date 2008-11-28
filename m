From: Jonas Bonn <jonas@southpole.se>
Subject: Seed device questions
Date: Fri, 28 Nov 2008 11:30:31 +0100
Message-ID: <492FC847.1090605@southpole.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I am trying the 'seed device' functionality, trying to get a read-only 
block-device to act as a seed for multiple other filesystems.

The following sequence works for setting up the first filesystem.

#-------------

#First initialize 'seed device'
mkfs.btrfs /dev/vdb
mount /dev/vdb /mnt
btrfs -S subvol /mnt
echo hello > /mnt/subvol/xxx
umount /mnt

#Make block device a "seed device" (read-only)
btrfstune -S 1 /dev/vdb

#Mount the seed device... it will be mounted read-only.
mount /dev/vdb /mnt

#Add the writeable block device
btrfs-vol -a /dev/vdc /mnt

#Now remount the filesystem read-write.
mount -oremount,rw /mnt

#Now all changes to /mnt should go to /dev/vdc.

#--------------

After this, however, it's not possible to mount /dev/vdb again in order to set 
up a second filesystem as seed.  I want to do:

mount /dev/vdb /othermnt
btrfs-vol -a /dev/vdd /othermnt
mount -oremount,rw /othermnt

So my questions (comments):

i)  Is the seed-device _really_ read-only... no metadata updates or anything? 
(i.e. I can have my seed device on read-only media)
ii)  Should it be possible to have a device as a 'seed' for multiple other 
filesystems.
iii)  When the seeded filesystem is created, the size of the filesystem is the 
aggregate of all devices, whereas it should be the aggregate size of only the 
'writable' devices.

/Jonas

