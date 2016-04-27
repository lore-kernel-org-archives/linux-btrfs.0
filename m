Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38425 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbcD0MDK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 08:03:10 -0400
Received: by mail-wm0-f41.google.com with SMTP id u206so45966044wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 05:03:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALq5X_gW2QaQenhCworrc757QUCffCchNORFWxgw8Xn+vvjtJw@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
	<CALq5X_iJcbXeaQxPAoHPwXyDSSXSx7HnWPApbQcXB4s7utGG_g@mail.gmail.com>
	<CAD=QJKjfrL1qbhDpE5W4vJZOyHKNd=G7+wCMapZSwUYs-dkOoQ@mail.gmail.com>
	<CALq5X_gW2QaQenhCworrc757QUCffCchNORFWxgw8Xn+vvjtJw@mail.gmail.com>
Date: Wed, 27 Apr 2016 08:03:09 -0400
Message-ID: <CAD=QJKg460+GcgFi+pEiBaX4ao-yz9KqRNa+VOCv8cBF4Hppvw@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: David Alcorn <nroclaed@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Thanks for the update, sorry for the delay, this email was sitting in
my drafts folder.  Instructions follow.

On 26 April 2016 at 05:23, David Alcorn <nroclaed@gmail.com> wrote:
>
> Nicholas:
>
> 1. My RAID array is partially filled and backed up.
> 2. I prefer to mount by UUID.
> 3. n/a
> 4. the relevant content of my blkid is:
> "/dev/sda1: UUID="AEF6-E013" TYPE="vfat"
> PARTUUID="b4b9c894-aa4f-4c83-ba27-8919eaaeac49"
> /dev/sda2: UUID="a428a1ea-5174-47b6-a894-521166a7a354" TYPE="ext2"
> PARTUUID="e25bcabb-2fd3-4515-bf74-3a2f0c548fec"
> /dev/sda3: UUID="1b413c7c-d39d-4c10-9f1d-4f3a21791c50"
> UUID_SUB="e2d12168-c216-425f-9a82-6d46dad8ccc8" TYPE="btrfs"
> PARTLABEL="primary" PARTUUID="1651d9f1-35ff-458b-ae64-bb6003c72159"
> /dev/sdb: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
> UUID_SUB="b4c6bbc5-ea80-4a79-89ca-333d351b09e5" TYPE="btrfs"
> /dev/sdc: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
> UUID_SUB="c4ac65e7-45bb-4450-9aa4-80a7fbebed3a" TYPE="btrfs"
> /dev/sdd: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
> UUID_SUB="5f55bf3b-8e82-4b50-8b62-5dc45c892281" TYPE="btrfs"
> /dev/sde: UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d"
> UUID_SUB="5a12cbd5-bdc2-4258-9bc8-23d95cbb1db6" TYPE="btrfs"
>
>
> I omitted /dev/sdf from my blkid content as it is an unused,
> transitory drive that will be redeployed after "/" is moved to the
> array.  /dev/sda is my flash drive with separate partitions for efi
> (vfat), /boot/ (ext2) and "/" (btrfs subvolume).

Note: I'm guessing you read the Debian wiki entry on btrfs before
2016-03-14?  If you read it after this date, I might need to make the
fact that UEFI systems cannot boot from raw drives more explicit.

Ok, here is how you move everything on your raid6 array to a
subvolume--the goal is to have two subvolumes on your RAID6, one for
rootfs, and one for whatever you're using the bulk storage for.  I'm
assuming you haven't yet created one, but I think these commands will
still work, even if you have; you'll just have nested subvolumes in
that case.  Personally, I prefer alphanumeric subvolume naming, but
I'll use the @ convention for clarity.

These instructions assume that you've booted from you flash disk.
Please note that I'm not sure if this will work if your flash rootfs
is installed on subvolid=5...

btrfs sub list /
# If there is no output, make a note of it.

mkdir /tmp/tank
mount -o noatime UUID="c2cf44d3-28e0-492a-9d51-00a41b71428d" /tmp/tank
btrfs sub list /tmp/tank

cd /tmp/tank
btrfs sub create @tank
ls -1 | egrep -v '@tank' while read d; do mv "$d" @tank/; done
# There!  Now all your data is in a subvolume

btrfs sub snap -r / /rootfs-snapshot
btrfs send /rootfs-snapshot | btrfs receive /tmp/tank
# if this fails for any reason, send the output to this mailing list,
and mention if "btrfs sub list /"
# had any output.
# then umount /tmp/tank && sync

btrfs property set /tmp/tank/rootfs-snapshot ro false && mv rootfs-snapshot @
# There! now everything except for /boot and /boot/efi is on your raid6

# You have a choice between following the following instructions or
editing your grub command line.  Personally I would choose to edit the
grub command line.
# if you choose do it this way, run these commands:
#
# sync
# umount /tmp/tank
# sync
# reboot
#
# edit your grub command line by hitting the "e" key when the menu
comes up.  Find the bit that
# says root= and make sure it looks something like
# root=/dev/sdb ro rootflags=subvol=@

Boot it, and scroll down to the "IF YOU FOLLOWED" section.

##### alternatively #####

cd /tmp/tank/@
mount none -t proc proc
mount -o bind /dev dev
mount none -t sysfs sysfs
mount -o bind /boot boot
mount -o bind /boot/efi
chroot ./


#### IF YOU FOLLOWED the "edit grub command line" method, start here ####

editor /etc/fstab
# change the first line, for /

UUID=c2cf44d3-28e0-492a-9d51-00a41b71428d    /    btrfs
subvol=/@,noatime    0    0

# if you have a line for your raid6 subvolume, find it, and change it to

UUID=c2cf44d3-28e0-492a-9d51-00a41b71428d    /some/location    btrfs
 subvol=/@tank,noatime    0    0

# You just need to run the following command to get grub to use the
rootfs on your raid6

cp -arx /boot /boot.bak
update-grub
grep '/@/' /boot/grub/grub.cfg
# this should output something!  If it doesn't, seek help on IRC.

# What I would personally do is manually edit /boot/grub/grub.cfg...
# At any rate if that grep command outputted nothing, your system won't boot.
# restore booting from you /dev/sda with the following command
# cp -arx /boot.bak/* /boot
# /\ this /\ should allow your usb stick to continue booting.
# Continuing could trash your grub installation on /dev/sda if grep
'/@/' /boot/grub/grub.cfg
# didn't provide any output.

# If that grep verified that you'll be booting to @ as your rootfs,
then it's safe to do the following:
grub-install /dev/sda
sync

#### IF YOU FOLLOWED the "edit grub command line" method, you're done! ###

### alternatively (continued) ####
exit
umount proc dev sys boot/efi
umount boot
cd ../ && umount tank
sync
reboot

And it should work ;-)
Nicholas
