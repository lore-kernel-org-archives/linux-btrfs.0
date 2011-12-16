From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: speeding up slow btrfs filesystem
Date: Fri, 16 Dec 2011 18:51:51 +0100
Message-ID: <201112161851.52011.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On apt-get dist-upgrading my Amarok ThinkPad T23 with BTRFS as /
and as /home I get extremely slow operation - my ThinkPad T42 with Ext4
is running circles around it and thats likely not only due to the faste=
r CPU.

vmstat 1 shows:

procs -----------memory---------- ---swap-- -----io---- -system-- ----c=
pu----
 0  4 151452  75016     68 382084    0    0  1164    28  595 1959 31 19=
  0 50
 0  3 151452  74272     68 382560    0    0   488     0  538 1735 10  9=
  0 81
 4  2 151452  71644     68 385776    0    0  3804     0  663 1886 56 38=
  0  6
 3  2 151452  66916     68 387192    0    0  1264     0  633 1018 74 24=
  0  2
 1  3 151452  63296     68 389336    0    0  1580     0  656 4095 80 20=
  0  0
 2  3 151452  66272     68 390028    8    0   572     0  601 3449 40 17=
  0 43
 3  2 151452  65032     68 390828    0    0   760     0  673 2364 42 25=
  0 32
 3  2 151452  61816     68 393508    0    0  2672     0  748 2203 52 29=
  0 19
 2  2 151452  60824     68 394236    0    0   724     0  660 2338 51 22=
  0 27
 4  2 151452  59832     68 395024    0    0   808     0  662 2309 40 20=
  0 40
 0  2 151452  58708     68 395856    0    0   812    12  683 2217 46 23=
  0 30
 0  2 151452  57964     68 396416    0    0   512     0  619 2196 41 24=
  0 35

I know laptop harddisks aren=B4t the fastest, but AFAIR the T23 felt wa=
y faster
with Ext3/4.

I get quite some stalles when opening a new window in "screen". It can =
take
10-20 seconds to load the new Z-Shell into it. Also Amarok stops playin=
g
music for a while sometimes which it didn=B4t with Ext3/4. I suspect th=
at the
kernel does not service an I/O request of Amarok quickly enough.

Surprisingly I do not see an excessive amount of CPU usage of brtfs ker=
nel
threads with atop. But the disk seems to be quite busy with block out r=
ates
in vmstat of merely a few thousands at maximum.

Thus I suspect fragmentation of btrfs trees or files.

The filesystems has the following specifics - apt-get will work on / on=
ly
obviously:

deepdance:~> btrfs filesystem show
failed to read /dev/sr0
Label: 'debian'  uuid: 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
        Total devices 1 FS bytes used 7.34GB
        devid    1 size 15.00GB used 14.97GB path /dev/dm-0

Label: 'home'  uuid: a600de65-e1ab-4cbf-b150-bbaeaf9fa98d
        Total devices 1 FS bytes used 28.13GB
        devid    1 size 80.00GB used 40.54GB path /dev/dm-2

Btrfs Btrfs v0.19
deepdance:~> btrfs filesystem df /
Data: total=3D11.23GB, used=3D6.84GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.86GB, used=3D510.99MB

I cleaned out a lot of packages due to the slow dist-upgrades already
and also cause I do not need them on that laptop anymore. Thus the
data tree only uses half of the allocated space. BTRFS doesn=B4t seem
to give space back to the pool for all trees. Maybe it will do that
on btrfs filesystem balance?

home is:

deepdance:~> btrfs filesystem df /home
Data: total=3D37.01GB, used=3D27.54GB
System, DUP: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.75GB, used=3D598.76MB
Metadata: total=3D8.00MB, used=3D0.00
deepdance:~>

BTW why does it have two metadata and systems trees while /
only have one?

Currently I have:

deepdance:~> cat /proc/version
Linux version 3.0.0-2-686-pae (Debian 3.0.0-6) (ben@decadent.org.uk)
(gcc version 4.5.3 (Debian 4.5.3-9) ) #1 SMP Wed Nov 2 05:29:50
UTC 2011

from Debian Wheezy.

=46ree memory is quite okay:

deepdance:~> free -m
             total       used       free     shared    buffers     cach=
ed
Mem:           755        699         55          0          0        3=
47
-/+ buffers/cache:        352        402
Swap:         2047        148       1899

I am wondering on how to optimize performance on the /
BTRFS filesystem.

I am not sure whether to try btrfs filesystem balance or
btrfs filesystem defragment /.

I also wonder whether some Debian package management related
file might be fragmented. But the ones I tested do not seem to be:

deepdance:/var/lib/dpkg> filefrag available
available: 1 extent found
deepdance:/var/lib/dpkg> filefrag status  =20
status: 1 extent found
deepdance:/var/lib/dpkg>

But then I also do not know whether "filefrag" from "e2fsprogs"=20
1.42~WIP-2011-10-16-1 will work with BTRFS.

Any advice?

Its not critical for me to fix these issues (soon), but I am curious
whether its possible to get the filesystem speedier by some
maintenance.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
