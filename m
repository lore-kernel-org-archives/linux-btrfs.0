From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 8 Dec 2011 10:00:54 +0000 (UTC)
Message-ID: <slrnje12mm.7db.stephane.chazelas@spam.is.invalid>
References: <bb747e0c-d6d8-4f60-a3f6-cf64c856515e@mail.placs.net>
 <d0ff909c-00a0-4f34-a1dc-6be0a8fdd832@mail.placs.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-12-07, 12:35(-06), BJ Quinn:
> I've got a 6TB btrfs array (two 3TB drives in a RAID 0). It's
> about 2/3 full and has lots of snapshots. I've written a
> script that runs through the snapshots and copies the data
> efficiently (rsync --inplace --no-whole-file) from the main
> 6TB array to a backup array, creating snapshots on the backup
> array and then continuing on copying the next snapshot.
> Problem is, it looks like it will take weeks to finish. 
>
> I've tried simply using dd to clone the btrfs partition, which
> technically appears to work, but then it appears that the UUID
> between the arrays is identical, so I can only mount one or
> the other. This means I can't continue to simply update the
> backup array with the new snapshots created on the main array
> (my script is capable of "catching up" the backup array with
> the new snapshots, but if I can't mount both arrays...). 
[...]

You can mount them if you specify the devices upon mount.

Here's a method to transfer a full FS to some other with
different layout.

In this example, we're transfering from a FS on a 3GB device
(/dev/loop1) to a new FS on 2 2GB devices (/dev/loop2,
/dev/loop3)

truncate -s 3G a1
truncate -s 2G b1 b2
losetup /dev/loop1 a1
losetup /dev/loop2 b1
losetup /dev/loop2 b2

# our src FS on 1 disk:
mkfs.btrfs /dev/loop1
mkdir A B
mount /dev/loop1 A
# now we can fill it up, create subvolumes and snapshots...

# at this point, we decide to make a clone of it. To do that, we
# will make a snapshot of the device. For that, we need
# temporary storage as a block device. That could be a disk
# (like a USB key) or a nbd to another host, or anything. Here,
# I'm going to use a loop device to a file. You need enough
# space to store any modification done on the src FS while
# you're the transfer and what is needed to do the transfer
# (I can't tell you much about that).

truncate -s 100M sa
losetup /dev/loop4 sa

umount A
size=$(blockdev --getsize /dev/loop1)
echo 0 "$size" /dev/loop1) snapshot-origin /dev/loop1 | dmsetup create a
echo 0 "$size" snapshot /dev/loop1 /dev/loop4 N 8 | dmsetup create aSnap

# now we have /dev/mapper/a as the src device which we can
# remount as such and use:
mount /dev/mapper/a A

# and aSnap as a writable snapshot of the src device, which we
# mount separately:
mount /dev/mapper/aSnap B

# The trick here is that we're going to add the two new devices
# to "B" and remove the snapshot one. btrfs will automatically
# migrate the data to the new device:
btrfs device add /dev/loop2 /dev/loop3 B
btrfs device delete /dev/mapper/aSnap B
# END
Once that's completed, you should have a copy of A in B.

You may want to watch the status of the snapshot while you're
transfering to check that it doesn't get full 

That method can't be used to do some incremental "syncing"
between two FS for which you'd still need something similar to
"zfs send" (speaking of which, you may want to consider
zfsonlinux which is now reaching a point where it's about as
stable as btrfs, same performance level if not better and has a
lot more features. I'm doing the switch myself while waiting for
btrfs to be a bit more mature)

Because of the same uuid, the btrfs commands like filesystem
show will not always give sensible outputs. I tried to rename
the fsid by changing it in the superblocks, but it looks like it
is alsa included in a few other places where changing it
manually breaks some checksums, so I guess someone would have to
write a tool to do that job. I'm surprised it doesn't exist
already (or maybe it does and I'm not aware of it?).

-- 
Stephane

