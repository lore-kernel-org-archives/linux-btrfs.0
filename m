Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34720 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcCZMPj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 08:15:39 -0400
Received: by mail-ig0-f196.google.com with SMTP id av4so4341673igc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 05:15:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
Date: Sat, 26 Mar 2016 08:15:37 -0400
Message-ID: <CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

> Post 'btrfs fi usage' for the fileystem. That may give some insight
> what's expected to be on all the missing drives.

Here's the information, I believe that the missing we see in most
entries is the failed and absent drive, only the unallocated shows two
missing entries, the 2.73 TB is the missing but empty device. I don't
know if there's a way to prove it however.

ubuntu@btrfs-recovery:~$ sudo btrfs fi usage /mnt
Overall:
    Device size:          15.45TiB
    Device allocated:          12.12TiB
    Device unallocated:           3.33TiB
    Device missing:           5.46TiB
    Used:              10.93TiB
    Free (estimated):           2.25TiB    (min: 2.25TiB)
    Data ratio:                  2.00
    Metadata ratio:              2.00
    Global reserve:         512.00MiB    (used: 0.00B)

Data,RAID1: Size:6.04TiB, Used:5.46TiB
   /dev/sda       2.61TiB
   /dev/sdb       1.71TiB
   /dev/sdc       1.72TiB
   /dev/sdd       1.72TiB
   /dev/sdf       1.71TiB
   missing       2.61TiB

Metadata,RAID1: Size:14.00GiB, Used:11.59GiB
   /dev/sda       8.00GiB
   /dev/sdb       2.00GiB
   /dev/sdc       3.00GiB
   /dev/sdd       4.00GiB
   /dev/sdf       3.00GiB
   missing       8.00GiB

System,RAID1: Size:32.00MiB, Used:880.00KiB
   /dev/sda      32.00MiB
   missing      32.00MiB

Unallocated:
   /dev/sda     111.49GiB
   /dev/sdb      98.02GiB
   /dev/sdc      98.02GiB
   /dev/sdd      98.02GiB
   /dev/sdf      98.02GiB
   missing     111.49GiB
   missing       2.73TiB

I tried to remove missing, first remove missing only removes the
2.73TiB missing entry seen above. All the other missing entries
remain.

I can't "replace", it's not a valid command on my btrfs tools version;
I upgraded btrfs this morning in order to have the btrfs fi usage
command.

ubuntu@btrfs-recovery:~$ sudo btrfs version
btrfs-progs v4.0
ubuntu@btrfs-recovery:~$ dpkg -l | grep btrfs
ii  btrfs-tools                        4.0-2
 amd64        Checksumming Copy on Write Filesystem utilities

For those interested in my recovery techniques, here's how I rebuild
the overlay loop devices, be careful, these scripts make certain
assumptions that may not be accurate for your system:

On Client:

sudo umount /mnt
sudo /etc/init.d/open-iscsi stop

On Server:

/etc/init.d/iscsitarget stop
loop_devices=$(losetup -a | grep overlay | tr ":" " " | awk ' { printf
$1 " " } END { print "" } ')
for fn in /dev/mapper/sd??; do dmsetup remove $fn; done
for ln in $loop_devices; do losetup -d $ln; done
cd /home/ubuntu
rm sd*overlay

for device in sda3 sdb3 sdc1 sdd1 sde1 sdf1; do
  dev=/dev/$device
  ovl=/home/ubuntu/$device-overlay
  truncate -s512M $ovl
  newdevname=$device
  size=$(blockdev --getsize "$dev")
  loop=$(losetup -f --show -- "$ovl")
  echo Setting up loop for $dev using overlay $ovl on loop $loop for
target $newdevname
  printf '%s\n' "0 $size snapshot $dev $loop P 8" | dmsetup create "$newdevname"
done

Start the targets

/etc/init.d/iscsitarget start

On Client:

sudo /etc/init.d/open-iscsi start

-JohnF
