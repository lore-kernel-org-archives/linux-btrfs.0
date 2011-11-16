From: Tim Crone <tjcrone@gmail.com>
Subject: Segmentation Faults
Date: Wed, 16 Nov 2011 16:39:21 +0000 (UTC)
Message-ID: <loom.20111116T171334-175@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have some kind of corruption in my btrfs file system that causes kernel
segmentation faults when I try to delete files in my browser cache. Let me
know if you are interested in having any additional information besides what
is below. Thanks.

root@berna:~# uname -a
Linux berna 2.6.38-bpo.2-amd64 #1 SMP Mon Jun 6 15:24:02 UTC 2011
x86_64 GNU/Linux


root@berna:/usr/local/src/btrfs-progs# ./btrfsck -s 1 /dev/sda
using SB copy 1, bytenr 67108864
failed to read /dev/sr0: No medium found
ERROR: unable to scan the device '/dev/sdd' - Device or resource busy
failed to read /dev/sr0: No medium found
ERROR: unable to scan the device '/dev/sdd' - Device or resource busy
leaf parent key incorrect 1782596403200
bad block 1782596403200
incorrect offsets 3942 17510
bad block 1782603522048
warning, start mismatch 1778178670592 1778178764800
Aborted


root@berna:/home/tjc# rm -rf .cache/chromium
Segmentation fault
root@berna:/home/tjc#
Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877568] ------------[ cut here ]------------

Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877572] invalid opcode: 0000 [#1] SMP

Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877573] last sysfs file: /sys/devices/virtual/block/md0/uevent

Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877633] Stack:

Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877640] Call Trace:

Message from syslogd@localhost at Nov 16 11:19:35 ...
 kernel:[   66.877703] Code: 24 24 48 8b 74 24 28 48 8d 54 24 50 41 b9 01 00 
00 00 48 89 d9 4c 89 e7 e8 80 6e ff ff 83 f8 00 41 89 c5 0f 8c c5 02 00 00 74
04 <0f> 0b eb fe 4c 8b 2b 8b 73 40 4c 89 ef e8 a3 e5 ff ff 41 89 c6

(I was going to include some log entries, but the lines are longer than
80 characters and your system will not accept them.)





