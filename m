From: Malwina Bartoszynska <m.bartoszynska@rootbox.com>
Subject: "btrfs: =?utf-8?b?b3Blbl9jdHJlZQ==?= failed" error
Date: Wed, 21 Dec 2011 13:54:06 +0000 (UTC)
Message-ID: <loom.20111221T141346-863@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
after unmounting btrfs partition, I can't mount it again.

root@xxx:~# btrfs device scan
Scanning for Btrfs filesystems
root@xxx:~# mount /dev/sdb /data/osd.0/
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@xxxx:~# dmesg|tail
[57192.607912] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid 
2 transid14429 /dev/sda
[57204.796573] end_request: I/O error, dev fd0, sector 0
[57231.660913] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid 1
 transid 14429 /dev/sdb
[57231.680387] parent transid verify failed on 424308420608 wanted 6970
 found 8959
[57231.680546] parent transid verify failed on 424308420608 wanted 6970
found 8959
[57231.680705] parent transid verify failed on 424308420608 wanted 6970 
found 8959
[57231.680861] parent transid verify failed on 424308420608 wanted 6970 
found 8959
[57231.680869] parent transid verify failed on 424308420608 wanted 6970 
found 8959
[57231.680875] Failed to read block groups: -5
[57231.704165] btrfs: open_ctree failed
root@xxx:~#
root@xxx:~# btrfs filesystem show
Label: none  uuid: ed25c604-3e11-4459-85b5-e4090c4d22d0
        Total devices 4 FS bytes used 111.07GB
        devid    2 size 931.51GB used 56.02GB path /dev/sda
        devid    1 size 931.51GB used 56.02GB path /dev/sdb
        devid    4 size 232.89GB used 34.00GB path /dev/sdd
        devid    3 size 184.26GB used 34.00GB path /dev/sdc4

I was trying to fix it using btrfsc (from btrf-tools  0.19+20100601-3ubuntu3):

root@xxx:~# btrfsck /dev/sdb
parent transid verify failed on 424308420608 wanted 6970 found 8959
parent transid verify failed on 424308420608 wanted 6970 found 8959
parent transid verify failed on 424308420608 wanted 6970 found 8959
Segmentation fault

But it failed.
Also btrfsc from current git repository failed. 
root@xxx:/usr/src/test/btrfs-progs# ./btrfsck /dev/sdb
parent transid verify failed on 424308420608 wanted 6970 found 8959
parent transid verify failed on 424308420608 wanted 6970 found 8959
parent transid verify failed on 424308420608 wanted 6970 found 8959
parent transid verify failed on 424308420608 wanted 6970 found 8959
Ignoring transid failure
parent transid verify failed on 426205605888 wanted 8371 found 10836
parent transid verify failed on 426205605888 wanted 8371 found 10836
parent transid verify failed on 426205605888 wanted 8371 found 10836
parent transid verify failed on 426205605888 wanted 8371 found 10836
Ignoring transid failure
parent transid verify failed on 424601571328 wanted 8959 found 10264
parent transid verify failed on 424601571328 wanted 8959 found 10264
parent transid verify failed on 424601571328 wanted 8959 found 10264
parent transid verify failed on 424601571328 wanted 8959 found 10264
Ignoring transid failure
parent transid verify failed on 422394281984 wanted 6042 found 14369
parent transid verify failed on 422394281984 wanted 6042 found 14369
parent transid verify failed on 422394281984 wanted 6042 found 14369
parent transid verify failed on 422394281984 wanted 6042 found 14369
Ignoring transid failure
parent transid verify failed on 422394277888 wanted 6042 found 14369
parent transid verify failed on 422394277888 wanted 6042 found 14369
parent transid verify failed on 422394277888 wanted 6042 found 14369
parent transid verify failed on 422394277888 wanted 6042 found 14369
Ignoring transid failure
parent transid verify failed on 424867557376 wanted 8744 found 11654
parent transid verify failed on 424867557376 wanted 8744 found 11654
parent transid verify failed on 424867557376 wanted 8744 found 11654
parent transid verify failed on 424867557376 wanted 8744 found 11654
Ignoring transid failure
parent transid verify failed on 426748997632 wanted 8747 found 9681
parent transid verify failed on 426748997632 wanted 8747 found 9681
parent transid verify failed on 426748997632 wanted 8747 found 9681
parent transid verify failed on 426748997632 wanted 8747 found 9681
Ignoring transid failure
parent transid verify failed on 426748993536 wanted 8747 found 9681
parent transid verify failed on 426748993536 wanted 8747 found 9681
parent transid verify failed on 426748993536 wanted 8747 found 9681
parent transid verify failed on 426748993536 wanted 8747 found 9681
Ignoring transid failure
parent transid verify failed on 426749001728 wanted 8747 found 9681
parent transid verify failed on 426749001728 wanted 8747 found 9681
parent transid verify failed on 426749001728 wanted 8747 found 9681
parent transid verify failed on 426749001728 wanted 8747 found 9681
Ignoring transid failure
parent transid verify failed on 426749005824 wanted 8747 found 9681
parent transid verify failed on 426749005824 wanted 8747 found 9681
parent transid verify failed on 426749005824 wanted 8747 found 9681
parent transid verify failed on 426749005824 wanted 8747 found 9681
Ignoring transid failure
parent transid verify failed on 423647268864 wanted 6496 found 11645
parent transid verify failed on 423647268864 wanted 6496 found 11645
parent transid verify failed on 423647268864 wanted 6496 found 11645
parent transid verify failed on 423647268864 wanted 6496 found 11645
Ignoring transid failure
parent transid verify failed on 424308420608 wanted 6970 found 8959
Ignoring transid failure
leaf 417616629760 items 1 free space 3838 generation 5974 owner 7
fs uuid ed25c604-3e11-4459-85b5-e4090c4d22d0
chunk uuid b2b76fcf-3e03-4f9c-8cd1-4cad10c8bb2a
        item 0 key (EXTENT_CSUM EXTENT_CSUM 375473815552) itemoff 3863
 itemsize 
132
                extent csum item
failed to find block number 292758224896
Aborted


I am using Btrfs v0.19 on Ubuntu 11.10(kernel  3.0.0-14-generic x86_64).

How can I fix it?

Best regards,
-- 
Malwina Bartoszynska


