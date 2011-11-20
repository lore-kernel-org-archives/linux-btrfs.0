From: =?ISO-8859-2?Q?Karol_=A9ebesta?= <sebesta.karol@gmail.com>
Subject: BTRFS subvolume quota limits
Date: Sun, 20 Nov 2011 22:50:17 +0100
Message-ID: <CA+pWcCZoHcq4Ansh1MRQuuUfun_85vGj04G_KWLm61kk_hmtGQ@mail.gmail.com>
References: <CA+pWcCZ9qtMNDpzEhmTjvJFJ9WnjbxZcvYxnJUJjdratQYNCow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+pWcCZ9qtMNDpzEhmTjvJFJ9WnjbxZcvYxnJUJjdratQYNCow@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is there any possibility to set quota limit for subvolume created in
BTRFS pool as in Solaris ZFS?

I'm currently testing btrfs and I have a pool /home with two
partitions (disks) and three subvolumes on it:

Label: none =A0uuid: b742c9c7-162b-40d1-9186-f1c84418ff53
=A0 =A0 =A0 =A0Total devices 2 FS bytes used 513.02MB
=A0 =A0 =A0 =A0devid =A0 =A02 size 20.00GB used 1.26GB path /dev/sdb
=A0 =A0 =A0 =A0devid =A0 =A01 size 5.00GB used 1.26GB path /dev/sda6


BTRFS:/ # btrfs subvolume list /home
ID 257 top level 5 path Download
ID 258 top level 5 path Test
ID 261 top level 5 path Test2
BTRFS:/ #

These subvolumes are mounted as /apps, /Test and /Test2

/dev/sda6 =A0 =A0 =A0 =A025G =A0514M =A09.0G =A0 6% /home
/dev/sdb =A0 =A0 =A0 =A0 25G =A0514M =A09.0G =A0 6% /apps
/dev/sdb =A0 =A0 =A0 =A0 25G =A0514M =A09.0G =A0 6% /Test
/dev/sdb =A0 =A0 =A0 =A0 25G =A0514M =A09.0G =A0 6% /Test2

In Solaris ZFS I can use:

Example:

zfs set quota=3D1G home/Download =A0 --> and /apps will be have 1GB siz=
e
zfs set quota=3D5G home/Test =A0 --> and /Test will be have 5GB size
zfs set quota=3D10G home/Test2 =A0 --> and /Test2 will be have 10GB siz=
e

And in pool /home will be still 9GB free space for future extends.

It is possible in BTRFS? I know there is "btrfs filesystem resize" but
this only resize/reduce the whole /home pool and not set quota on
subvolumes as I need.

Any help is appreciated.

Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
