From: William Uther <willu.mailingLists@cse.unsw.edu.au>
Subject: raid1 disk exchange issues
Date: Sun, 24 Oct 2010 20:04:34 +1100
Message-ID: <12F14FAE-060D-412F-BDF8-2E525653856F@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
  I chose the weekend to upgrade my ageing MythTV box.  Now I've broken things.  I'm wondering if there is a way to recover.  To be clear - I appear to have my data, I just can't seem to get where I want from here.

  The particular issue that I'm having is that I have a raid1 filesystem with two devices attached, one is missing and I can't seem to replace it with the drive I have available.

  I could move back off btrfs, but thought I'd ask first. :)

  Backstory:

  I was using a raid1 zfs-fuse store for the machine (plus a smaller boot disk).  When I dist-upgraded to lucid (yes, this is all with the ubuntu 2.6.32 kernel), zfs-fuse started behaving strangely.  As fuse was a hassle anyway, I decided to try switching to btrfs.  I didn't want to lose the data as I changed formats, but figured that as everything was raid1, switching shouldn't be a huge issue.  :)  But btrfs doesn't let you add disks to a raid1 array later, so this is what I did:

# get the size of the disk you want to move to (in 1k blocks)
cat /proc/partitions # look for /dev/sdb1
# create a large, sparse data file
dd if=/dev/zero of=large.img bs=1k count=1 seek=<size of /dev/sdb1 in blocks>
# mount it on a loopback device
losetup /dev/loop0 large.img
# make the raid1 btrfs filesystem using the disk and the sparsely backed loop
mkfs.btrfs -m raid1 -d raid1 /dev/sdb1 /dev/loop0
# mount the filesystem once
mount -t btrfs /dev/sdb1 btrfs-mnt
# then unmount it again
umount btrfs-mnt
# undo the loopback setup
losetup -d /dev/loop0
# remove the sparse file
rm large.img
# mount the drive again in degraded mode
mount -t btrfs -odegraded /dev/sdb1 btrfs-mnt

# copy stuff onto the drive
cp -a stuff btrfs-mnt/

# add the other drive to the raid1 array
btrfs-vol -a /dev/sdc1 /data
# remove the missing device
btrfs-vol -r missing /data

What I didn't register the first time through was that the 'btrfs -a /dev/sdc1' where I added the second drive gave an 'ioctl returns 0' (that message doesn't scream error at me).

However, I did notice that removing the missing drive failed.  I then looked at btrfs-show and noticed that /dev/sdc1 'used 0.0', which didn't look right.

I tried a balance, but that just took a long time to complete, iostat said it was never touching /dev/sdc1, and it didn't change anything.

About this time, btrfs-show gave:

root:~# btrfs-show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 591.35GB
	devid    1 size 931.51GB used 746.75GB path /dev/sdb1
	devid    3 size 931.51GB used 0.00 path /dev/sdc1
	*** Some devices missing

Btrfs Btrfs v0.19

And I couldn't remove either /dev/sdc1 or 'missing'.  I tried updating my kernel to mainline 2.6.34 to see if a newer version of btrfs might help, and the reference to /dev/sdc1 has gone away:

root:~# btrfs-show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 2 FS bytes used 592.19GB
	devid    1 size 931.51GB used 746.75GB path /dev/sdb1
	*** Some devices missing

Btrfs Btrfs v0.19

I still get the error trying to add the new device, even with the new kernel.

I've switched back to the ubuntu kernel to make the lirc remote work, and /dev/sdc1 remains gone.  :)

Question:

Is there any way to turn this into a raid1 setup?  Or should I change to a different filesystem for the moment?

Thanks for any help,

Will       :-}

