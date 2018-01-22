Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:43331 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbeAVVG7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 16:06:59 -0500
Received: by mail-pg0-f48.google.com with SMTP id n17so8031771pgf.10
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:06:59 -0800 (PST)
MIME-Version: 1.0
From: Claes Fransson <claes.v.fransson@gmail.com>
Date: Mon, 22 Jan 2018 22:06:58 +0100
Message-ID: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
Subject: bad key ordering - repairable?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I really like the features of BTRFS, especially deduplication,
snapshotting and checksumming. However, when using it on my laptop the
last couple of years, it has became corrupted a lot of times.
Sometimes I have managed to fix the problems (at least so much that I
can continue to use the filesystem) with check --repair, but several
times I had to recreate the file system and reinstall the operating
system.

I am guessing the corruptions might be the results of unclean
shutdowns, mostly after system hangs, but also because of running out
of battery sometimes?
Furthermore, the power-led has recently started blinking (also when
the power-cable is plugged in), I guess because of an old and bad
battery. Maybe the current corruption also can have something to do
with this? However I almost always run with power cable plugged in in
last year, only on battery a few seconds a few times when moving the
laptop.

Currently, I can only mount the filesystem readonly, it goes readonly
automatically if I try to mount it normally.

When booting an OpenSUSE Tumbleweed-20180119 live-iso:
localhost:~ # uname -r
4.14.13-1-default
localhost:~ # btrfs --version
btrfs-progs v4.14.1

localhost:~ # btrfs check -p /dev/sda12
Checking filesystem on /dev/sda12
                                                    UUID:
d2819d5a-fd69-484b-bf34-f2b5692cbe1f
                                        bad key ordering 159 160

                           bad block 690436964352



            ERROR: errors found in extent allocation tree or chunk
allocation                                               checking free
space cache [.]
                                           checking fs roots [o]

                                 checking csums

                      bad key ordering 159 160

         Error looking up extent record -1

Right section didn't have a record
                                                        There are no
extents for csum range 22732550144-24923615232
                        Csum exists for 16303538176-24923615232 but
there is no extent record                                     ERROR:
errors found in csum tree
                                             found 344063430663 bytes
used, error(s) found
                      total csum bytes: 0

            total tree bytes: 453410816

total fs tree bytes: 0
                                                                total
extent tree bytes: 452952064
btree space waste bytes: 140165932
                                                    file data blocks
allocated: 108462080
 referenced 108462080

localhost:~ # btrfs inspect-internal dump-tree -b 690436964352
/dev/sda12
btrfs-progs v4.14.1
                                                               leaf
690436964352 items 170 free space 1811 generation 196864 owner 2
                            leaf 690436964352 flags 0x1(WRITTEN)
backref revision 1
    fs uuid d2819d5a-fd69-484b-bf34-f2b5692cbe1f
                                                  chunk uuid
52f81fe6-893b-4432-9336-895057ee81e1
.
.
.
        item 157 key (22732500992 EXTENT_ITEM 16384) itemoff 6538 itemsize 53
                refs 1 gen 821 flags DATA
                extent data backref root 287 objectid 51665 offset 0 count 1
        item 158 key (22732517376 EXTENT_ITEM 16384) itemoff 6485 itemsize 53
                refs 1 gen 821 flags DATA
                extent data backref root 287 objectid 51666 offset 0 count 1
        item 159 key (22732533760 EXTENT_ITEM 16384) itemoff 6485 itemsize 0
print-tree.c:428: print_extent_item: BUG_ON `item_size !=
sizeof(*ei0)` triggered, value 1
btrfs(+0x365c6)[0x55bdfaada5c6]
btrfs(print_extent_item+0x424)[0x55bdfaadb284]
btrfs(btrfs_print_leaf+0x94e)[0x55bdfaadbc1e]
btrfs(btrfs_print_tree+0x295)[0x55bdfaadcf05]
btrfs(cmd_inspect_dump_tree+0x734)[0x55bdfab1b024]
btrfs(main+0x7d)[0x55bdfaac7d4d]
/lib64/libc.so.6(__libc_start_main+0xea)[0x7ff42100ff4a]
btrfs(_start+0x2a)[0x55bdfaac7e5a]
Aborted (core dumped)


check --repair hangs after reporting "bad key ordering 159 160" with
no disk activity but constant high cpu usage.

localhost:~ # smartctl -a /dev/sda
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.14.13-1-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SanDisk SD8SB8U1T001122
Serial Number:    163076421231
LU WWN Device Id: 5 001b44 4a4dde388
Firmware Version: X4140000
User Capacity:    1,024,209,543,168 bytes [1.02 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 T13/2015-D revision 3
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Jan 22 15:28:46 2018 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x11) SMART execute Offline immediate.
                                        No Auto Offline data collection support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        No Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  10) minutes.

SMART Attributes Data Structure revision number: 4
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0032   100   100   ---    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   ---    Old_age
Always       -       7692
 12 Power_Cycle_Count       0x0032   100   100   ---    Old_age
Always       -       496
165 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       1112516724361
166 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       1
167 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       25
168 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       44
169 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       753
170 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       0
171 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       0
172 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       0
173 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       18
174 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       57
184 End-to-End_Error        0x0032   100   100   ---    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   ---    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   ---    Old_age
Always       -       1
194 Temperature_Celsius     0x0022   061   062   ---    Old_age
Always       -       39 (Min/Max 9/62)
199 UDMA_CRC_Error_Count    0x0032   100   100   ---    Old_age
Always       -       0
230 Unknown_SSD_Attribute   0x0032   100   100   ---    Old_age
Always       -       4733091251278
232 Available_Reservd_Space 0x0033   100   100   004    Pre-fail
Always       -       100
233 Media_Wearout_Indicator 0x0032   100   100   ---    Old_age
Always       -       19202
234 Unknown_Attribute       0x0032   100   100   ---    Old_age
Always       -       32167
241 Total_LBAs_Written      0x0030   253   253   ---    Old_age
Offline      -       22520
242 Total_LBAs_Read         0x0030   253   253   ---    Old_age
Offline      -       183882
244 Unknown_Attribute       0x0032   000   100   ---    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      7570         -
# 2  Extended offline    Completed without error       00%      7395         -
# 3  Extended offline    Completed without error       00%      6253         -
# 4  Short offline       Completed without error       00%      4030         -
# 5  Extended offline    Completed without error       00%      1568         -
# 6  Extended offline    Completed without error       00%      1434         -

Selective Self-tests/Logging not supported

localhost:~ # btrfs fi usage /mnt
Overall:
    Device size:                 450.00GiB
    Device allocated:            424.04GiB
    Device unallocated:           25.96GiB
    Device missing:                  0.00B
    Used:                        420.38GiB
    Free (estimated):             27.39GiB      (min: 27.39GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:411.98GiB, Used:410.55GiB
   /dev/sda12    411.98GiB

Metadata,single: Size:12.00GiB, Used:9.83GiB
   /dev/sda12     12.00GiB

System,single: Size:64.00MiB, Used:64.00KiB
   /dev/sda12     64.00MiB

Unallocated:
   /dev/sda12     25.96GiB

The filesystem had become pretty full, I had planned to increase the
Btrfs-partition size before it became corrupt.

Active kernel when the filesystem went read only: OpenSUSE Linux
4.14.14-1.geef6178-default, from the
http://download.opensuse.org/repositories/Kernel:/stable/standard/stable
repository.

Fstab mount options: noatime,autodefrag (I have been using the option
nossd with older kernels one period in the past on the filesystem).

If it matters, I have been running duperemove many times on the
filesystem since creation.

To test the RAM, I have been running mprime Blend-test for 24 hours
after the corruption without any error or warning.

Is there a way I can try to repair this filesystem without the need to
recreate it and reinstall the operating system? A reinstall including
all currently installed packages, and restoring all current system
settings, would probably take some time for me to do.
If it is currently not repairable, it would be nice if this kind of
corruption could be repaired in the future, even if losing a few
files. Or if the corruptions could be avoided in the first place.

Laptop: Asus N56JR-S4075H, bought new 2014
Hard drive: since 14 months a SanDisk X400 SD8SB8U1T001122 1TB SSD,
originally a Seagate ST750LM000 SSHD
RAM: lshw:-memory
          description: System Memory
          physical id: c
          slot: System board or motherboard
          size: 12GiB
        *-bank:0
             description: SODIMM DDR3 Synchronous 1600 MHz (0,6 ns)
             product: ASU16D3LS1KBG/4G
             vendor: Kingston
             physical id: 0
             serial: C32D5655
             slot: ChannelA-DIMM0
             size: 4GiB
             width: 64 bits
             clock: 1600MHz (0.6ns)
        *-bank:1
             description: DIMM [empty]
             product: [Empty]
             vendor: [Empty]
             physical id: 1
             serial: [Empty]
             slot: ChannelA-DIMM1
        *-bank:2
             description: SODIMM DDR3 Synchronous 1600 MHz (0,6 ns)
             product: M471B1G73QH0-YK0
             vendor: Samsung
             physical id: 2
             serial: 1519AD27
             slot: ChannelB-DIMM0
             size: 8GiB
             width: 64 bits
             clock: 1600MHz (0.6ns)
        *-bank:3
             description: DIMM [empty]
             product: [Empty]
             vendor: [Empty]
             physical id: 3
             serial: [Empty]
             slot: ChannelB-DIMM1
CPU: Intel(R) Core(TM) i7-4700HQ CPU @ 2.40GHz
BIOS version: N56JRH.202
SSD Partitions (among others): Btrfs with OpenSUSE Tumbleweed
installation, NTFS with Windows 10, Ext4 with Fedora installation.

I have never noticed any corruptions on the NTFS and Ext4 file systems
on the laptop, only on the Btrfs file systems.

Best regards,
Claes Fransson
