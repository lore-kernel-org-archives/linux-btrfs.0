From: William Sheffler <will@sheffler.me>
Subject: ENOSPC on heterogeneous raid 0
Date: Wed, 8 Dec 2010 13:53:25 -0800
Message-ID: <AANLkTikWrcJ+hWr0WS+1eeXdGKce3Xf-aH9k5Fg4x8Z3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs community.

=46irst off, thanks for all your hard work... I have been following
btrfs with interest for several years now and very much look forward
to the day it replaces ext4. The real killer feature (of btrfs
specifically) for me is the ability to add *and remove* devices from a
filesystem, as this allows rolling upgrades of my server's disks. I
have a 16 port 3ware 1650SE on which I have a number of small raid
units and it will be fantastic to be able to remove the oldest,
upgrade, and add the new storage back. I had previously been using
ZFS, but since ZFS doesn't allow removal of devices, this rolling
upgrade strategy doesn't work.

My question is this: can btrfs handle striping (raid 0) across
heterogeneous devices? I seem to be losing any capacity on the larger
disk beyond what is available on the smaller disk. I really hope there
is some simple fix!

Here is a bit more info:

Upon the release of ubuntu 10.10, I decided to give Btrfs v0.19 a
shot. I created a raid5 on the 3ware card with 4 disks and did:

mkfs.btrfs /dev/sdc -L hugeR1

After moving some data onto the filesystem, I created a mirror on the
3ware card and added it to the fielsystem:

btrfs device add /dev/sdd /huge

then did:

btrfs filesystem balance /huge

and waited a few days. Unfortunately, I am now running to ENOSPC
errors with the filesystem only (in theory?) half full:

=A0df -h /huge
=46ilesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
/dev/sdc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 5.5T=A0 2.8T=A0 2.8T=A0=
 50% /huge

btrfs filesystem show
Label: 'hugeR1'=A0 uuid: 543aefd1-ad28-4685-a6fc-
15fbdaa9a591
=A0=A0=A0=A0=A0=A0=A0 Total devices 2 FS bytes used 2.70TB
=A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 4.09TB used 1.40TB path /de=
v/sdc
=A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 2 size 1.36TB used 1.31TB path /de=
v/sdd

I gather btrfs is spreading the data evenly across the two disks, but
in this case, I would like 3/4 of the data on devid 1 and 1/4 on devid
2.

=46or reference, I am on bunutu 10.10 with kernel 2.6.35-22:

uname -a
Linux huge 2.6.35-22-generic #35-Ubuntu SMP Sat Oct 16 20:36:48 UTC
2010 i686 GNU/Linux



Thank you very much for your help, and please let me know if I can
provide any additional information!

Will Sheffler


--
William H. Sheffler Ph.D.
Senior Fellow
Baker Lab
University of Washington
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
