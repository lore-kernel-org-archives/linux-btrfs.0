From: Evert Vorster <evorster@gmail.com>
Subject: Strangeness on btrfs balance..
Date: Sat, 5 Feb 2011 03:31:27 -0700
Message-ID: <AANLkTin=G4c90Ew44gg=4E4joJPf6wizww=jqS0g8o1D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there...

I have kernel version 2.6.36.3, compiled with gcc 4.4.5, btrfstools
version 0.19+20101101

I have a btrfs filesystem (/data) consisting of two 1TB hard disks, raid0.

I added in another 1TB hard drive.

root@X86-64:~# btrfs filesystem show
failed to read /dev/sdh
failed to read /dev/sdg
failed to read /dev/sdf
failed to read /dev/sde
failed to read /dev/sr0
failed to read /dev/fd0u800
failed to read /dev/fd0
Label: none  uuid: 91a3ca88-7883-45a1-b83d-d95bf98a1d51
        Total devices 3 FS bytes used 1.20TB
        devid    3 size 931.51GB used 0.00 path /dev/sdb
        devid    1 size 931.51GB used 889.15GB path /dev/sdc
        devid    2 size 931.51GB used 889.13GB path /dev/sdd

Btrfs Btrfs v0.19

Sat Feb 05 03:22:29
root@X86-64:~#
----------------------------------------------------
So, I want to balance my data across these three devices, but I
noticed an inconsistencybteween "man btrfs" and btrfs' help...

root@X86-64:~# man btrfs | grep balance
       btrfs device balance <path>
       device balance <path>

Sat Feb 05 03:23:50

and

Sat Feb 05 03:24:19
root@X86-64:~# btrfs | grep balance
        btrfs filesystem balance <path>

Sat Feb 05 03:24:20

According to the man page, to balance a filesystem, the command is:
btrfs device balance <path>
In my case: btrfs device balance /data
This returns an error:

root@X86-64:~# btrfs device balance /data
ERROR: unknown command 'device'

When I try with
btrfs filesystem balance /data, I can see data being read and written
to the two original disks, but the new disk is not getting written to.
I keep an eye on disk IO with gkrellm. Also, after about an hour of
balancing, /dev/sdb is still completely empty.

Any idea of why this is happening?
Last few lines of dmesg:
floppy0: disk absent or changed during operation
end_request: I/O error, dev fd0, sector 128
end_request: I/O error, dev fd0, sector 0
btrfs: found 69 extents
btrfs: relocating block group 1897465380864 flags 9
btrfs: found 95 extents
btrfs: found 95 extents
btrfs: relocating block group 1895317897216 flags 9
btrfs: found 81 extents
btrfs: found 81 extents
btrfs: relocating block group 1893170413568 flags 9
btrfs: found 93 extents
btrfs: found 93 extents
btrfs: relocating block group 1891022929920 flags 9
btrfs: found 96 extents
btrfs: found 96 extents
btrfs: relocating block group 1888875446272 flags 9
btrfs: found 93 extents
btrfs: found 93 extents
btrfs: relocating block group 1886727962624 flags 9
btrfs: found 90 extents
btrfs: found 90 extents
btrfs: relocating block group 1884580478976 flags 9
btrfs: found 99 extents
btrfs: found 99 extents
btrfs: relocating block group 1882432995328 flags 9
btrfs: found 1 extents
btrfs: found 1 extents
btrfs: relocating block group 1880285511680 flags 9
btrfs: found 101 extents
btrfs: found 101 extents
btrfs: relocating block group 1878138028032 flags 9
btrfs: found 105 extents
btrfs: found 105 extents
btrfs: relocating block group 1875990544384 flags 9
btrfs: found 82 extents
btrfs: found 82 extents
btrfs: relocating block group 1873843060736 flags 9
btrfs: found 344 extents
btrfs: found 344 extents
btrfs: relocating block group 1871695577088 flags 9






-- 
http://magnatune.com - Music shared the way it should be.
