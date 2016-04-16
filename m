Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34048 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcDPRiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Apr 2016 13:38:51 -0400
Received: by mail-yw0-f195.google.com with SMTP id h6so18669943ywc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Apr 2016 10:38:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Apr 2016 19:38:48 +0200
Message-ID: <CANznX5E9T5xKwKL6NbC6b6hR7t=KH76Kdd77YgG0Moui6dbFAw@mail.gmail.com>
Subject: Unexpectedly slow removal of fragmented files (RAID-5)
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As you can see from the attached terminal log below, file deletion can
take an unexpectedly long time, even if there is little disk I/O from
other tasks.

Listing the contents of similar directories (<=1000 files with ~1Gb
size) can also be surprisingly slow (several seconds for a simple ls
command).

According to nmon's disk statistics the hard drives were not
over-saturated with I/O and mostly did reads rather than writes:

xDiskName Busy  Read WriteKB|0          |25         |50          |75       100|
xsdb       46%  435.7    0.0|RRRRRRRRRRRRRRRRRRRRRRRR                         >
xsdc       56%  461.7    0.0|RRRRRRRRRRRRRRRRRRRRRRRRRRRR                     >
xsdd       51%  431.7    0.0|RRRRRRRRRRRRRRRRRRRRRRRRRR                       >
xTotals Read-MB/s=1.3      Writes-MB/s=0.0      Transfers/sec=237.3

I see nothing strange in the kernel log and my btrfs stats are clean
from errors (and the SMART attributes are also fine):

# btrfs device stats /dev/sdb
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0

(same as above for all drives)

This is a RAID-5 filesystem with 3 devices:

# btrfs fi show
Label: none  uuid: 7d4769d6-2473-4c94-b476-4facce24b425
        Total devices 3 FS bytes used 5.13TiB
        devid    1 size 3.64TiB used 2.89TiB path /dev/sdc
        devid    2 size 3.64TiB used 2.89TiB path /dev/sdd
        devid    3 size 3.64TiB used 2.89TiB path /dev/sdb


# btrfs fi df /data
Data, RAID5: total=5.78TiB, used=5.13TiB
System, RAID5: total=64.00MiB, used=560.00KiB
Metadata, RAID5: total=11.00GiB, used=7.47GiB
GlobalReserve, single: total=512.00MiB, used=23.94MiB


These are fairly fast HDDs (3 equal models):
Model Number:       ST4000NM0033-9ZM170
Firmware Revision:  SN06

My current kernel is 4.5.1 (gentoo ~amd64) but this is not a new phenomenon.

Here is what I did for a quick benchmark (I would accept suggestions
how to measure/quantify this thing better):

# ls -Al
total 460860220
-rw-rw----+ 1 ipcamrec nogroup 1147656438 Apr  1 19:06 2016-04-01_18.30.avi
-rw-rw----+ 1 ipcamrec nogroup 1714611460 Apr  1 20:09 2016-04-01_19.08.avi
-rw-rw----+ 1 ipcamrec nogroup 1889729894 Apr  1 21:09 2016-04-01_20.09.avi
-rw-rw----+ 1 ipcamrec nogroup 1889900328 Apr  1 22:09 2016-04-01_21.09.avi
-rw-rw----+ 1 ipcamrec nogroup 1889872856 Apr  1 23:09 2016-04-01_22.09.avi
-rw-rw----+ 1 ipcamrec nogroup 1889847800 Apr  2 00:09 2016-04-01_23.09.avi
-rw-rw----+ 1 ipcamrec nogroup 1889926046 Apr  2 01:09 2016-04-02_00.09.avi
-rw-rw----+ 1 ipcamrec nogroup  623610962 Apr  2 01:29 2016-04-02_01.09.avi
-rw-rw----+ 1 ipcamrec nogroup 1886283564 Apr  2 02:29 2016-04-02_01.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889900926 Apr  2 03:29 2016-04-02_02.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889861230 Apr  2 04:29 2016-04-02_03.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889804690 Apr  2 05:29 2016-04-02_04.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889857562 Apr  2 06:29 2016-04-02_05.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889818618 Apr  2 07:29 2016-04-02_06.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1889895388 Apr  2 08:29 2016-04-02_07.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1025430638 Apr  2 09:01 2016-04-02_08.29.avi
-rw-rw----+ 1 ipcamrec nogroup 1890289896 Apr  2 10:03 2016-04-02_09.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889813210 Apr  2 11:03 2016-04-02_10.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1233504110 Apr  2 11:42 2016-04-02_11.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1641288188 Apr  2 12:37 2016-04-02_11.45.avi
-rw-rw----+ 1 ipcamrec nogroup  386146966 Apr  2 12:53 2016-04-02_12.41.avi
-rw-rw----+ 1 ipcamrec nogroup 1681678050 Apr  2 13:48 2016-04-02_12.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1539937212 Apr  2 14:39 2016-04-02_13.50.avi
-rw-rw----+ 1 ipcamrec nogroup    6094144 Apr  2 14:41 2016-04-02_14.40.avi
-rw-rw----+ 1 ipcamrec nogroup 1047267124 Apr  2 15:14 2016-04-02_14.41.avi
-rw-rw----+ 1 ipcamrec nogroup  646180950 Apr  2 15:37 2016-04-02_15.16.avi
-rw-rw----+ 1 ipcamrec nogroup  647643096 Apr  2 15:58 2016-04-02_15.37.avi
-rw-rw----+ 1 ipcamrec nogroup 1885294996 Apr  2 17:00 2016-04-02_16.00.avi
-rw-rw----+ 1 ipcamrec nogroup   53816900 Apr  2 17:02 2016-04-02_17.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1890431554 Apr  2 18:03 2016-04-02_17.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889900590 Apr  2 19:03 2016-04-02_18.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1601785838 Apr  2 20:03 2016-04-02_19.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889895806 Apr  2 21:03 2016-04-02_20.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889839996 Apr  2 22:03 2016-04-02_21.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889895188 Apr  2 23:03 2016-04-02_22.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889775096 Apr  3 00:03 2016-04-02_23.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889922352 Apr  3 01:03 2016-04-03_00.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889870066 Apr  3 02:03 2016-04-03_01.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889866336 Apr  3 03:03 2016-04-03_02.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889933686 Apr  3 04:03 2016-04-03_03.03.avi
-rw-rw----+ 1 ipcamrec nogroup 1889833068 Apr  3 05:03 2016-04-03_04.03.avi
-rw-rw----+ 1 ipcamrec nogroup  305105832 Apr  3 07:07 2016-04-03_06.07.avi
-rw-rw----+ 1 ipcamrec nogroup  863985532 Apr  3 08:07 2016-04-03_07.07.avi
-rw-rw----+ 1 ipcamrec nogroup  115893820 Apr  3 08:12 2016-04-03_08.07.avi
-rw-rw----+ 1 ipcamrec nogroup  404410606 Apr  3 09:56 2016-04-03_08.56.avi
-rw-rw----+ 1 ipcamrec nogroup  318688062 Apr  3 10:18 2016-04-03_10.02.avi
-rw-rw----+ 1 ipcamrec nogroup  776013620 Apr  3 11:50 2016-04-03_10.50.avi
-rw-rw----+ 1 ipcamrec nogroup  407126582 Apr  3 12:52 2016-04-03_11.52.avi
-rw-rw----+ 1 ipcamrec nogroup    5222642 Apr  3 12:53 2016-04-03_12.52.avi
-rw-rw----+ 1 ipcamrec nogroup  335602134 Apr  3 13:41 2016-04-03_12.57.avi
-rw-rw----+ 1 ipcamrec nogroup  654760918 Apr  3 15:50 2016-04-03_14.50.avi
-rw-rw----+ 1 ipcamrec nogroup 1138170738 Apr  3 16:50 2016-04-03_15.50.avi
-rw-rw----+ 1 ipcamrec nogroup  444315988 Apr  3 18:51 2016-04-03_17.51.avi
-rw-rw----+ 1 ipcamrec nogroup  495482230 Apr  3 19:42 2016-04-03_18.51.avi
-rw-rw----+ 1 ipcamrec nogroup   98437182 Apr  3 20:04 2016-04-03_19.43.avi
-rw-rw----+ 1 ipcamrec nogroup 1009751020 Apr  3 22:04 2016-04-03_21.04.avi
-rw-rw----+ 1 ipcamrec nogroup  291075530 Apr  3 23:05 2016-04-03_22.05.avi
-rw-rw----+ 1 ipcamrec nogroup  272429166 Apr  3 23:27 2016-04-03_23.05.avi
-rw-rw----+ 1 ipcamrec nogroup  341137180 Apr  4 03:31 2016-04-04_02.31.avi
-rw-rw----+ 1 ipcamrec nogroup  602545974 Apr  4 04:31 2016-04-04_03.31.avi
-rw-rw----+ 1 ipcamrec nogroup   63110992 Apr  4 04:33 2016-04-04_04.31.avi
-rw-rw----+ 1 ipcamrec nogroup 1883785172 Apr  4 05:34 2016-04-04_04.34.avi
-rw-rw----+ 1 ipcamrec nogroup  311071472 Apr  4 06:56 2016-04-04_05.56.avi
-rw-rw----+ 1 ipcamrec nogroup  559851054 Apr  4 07:56 2016-04-04_06.56.avi
-rw-rw----+ 1 ipcamrec nogroup   11070228 Apr  4 07:57 2016-04-04_07.56.avi
-rw-rw----+ 1 ipcamrec nogroup  172597544 Apr  4 08:44 2016-04-04_07.58.avi
-rw-rw----+ 1 ipcamrec nogroup  410391580 Apr  4 09:50 2016-04-04_08.50.avi
-rw-rw----+ 1 ipcamrec nogroup  938198488 Apr  4 10:50 2016-04-04_09.50.avi
-rw-rw----+ 1 ipcamrec nogroup  227971978 Apr  4 12:28 2016-04-04_11.28.avi
-rw-rw----+ 1 ipcamrec nogroup 1890570598 Apr  4 13:39 2016-04-04_12.39.avi
-rw-rw----+ 1 ipcamrec nogroup   91584732 Apr  4 14:13 2016-04-04_13.40.avi
-rw-rw----+ 1 ipcamrec nogroup  539566470 Apr  4 15:38 2016-04-04_14.38.avi
-rw-rw----+ 1 ipcamrec nogroup  141768396 Apr  4 15:45 2016-04-04_15.38.avi
-rw-rw----+ 1 ipcamrec nogroup  234323930 Apr  4 16:46 2016-04-04_15.46.avi
-rw-rw----+ 1 ipcamrec nogroup    2998164 Apr  4 16:47 2016-04-04_16.46.avi
-rw-rw----+ 1 ipcamrec nogroup 1409584128 Apr  4 18:32 2016-04-04_17.48.avi
-rw-rw----+ 1 ipcamrec nogroup   81657388 Apr  4 19:45 2016-04-04_19.15.avi
-rw-rw----+ 1 ipcamrec nogroup  100296758 Apr  4 20:26 2016-04-04_19.46.avi
-rw-rw----+ 1 ipcamrec nogroup  848315436 Apr  4 21:28 2016-04-04_20.28.avi
-rw-rw----+ 1 ipcamrec nogroup 1036507574 Apr  4 23:29 2016-04-04_22.29.avi
-rw-rw----+ 1 ipcamrec nogroup  150136940 Apr  5 00:35 2016-04-04_23.35.avi
-rw-rw----+ 1 ipcamrec nogroup  587350146 Apr  5 01:35 2016-04-05_00.35.avi
-rw-rw----+ 1 ipcamrec nogroup  302783792 Apr  5 01:50 2016-04-05_01.35.avi
-rw-rw----+ 1 ipcamrec nogroup  108630214 Apr  5 03:52 2016-04-05_02.52.avi
-rw-rw----+ 1 ipcamrec nogroup  459133672 Apr  5 04:52 2016-04-05_03.52.avi
-rw-rw----+ 1 ipcamrec nogroup 1467170546 Apr  5 05:52 2016-04-05_04.52.avi
-rw-rw----+ 1 ipcamrec nogroup  568396516 Apr  5 06:58 2016-04-05_05.58.avi
-rw-rw----+ 1 ipcamrec nogroup  435623644 Apr  5 08:03 2016-04-05_07.03.avi
-rw-rw----+ 1 ipcamrec nogroup  341284300 Apr  5 08:18 2016-04-05_08.03.avi
-rw-rw----+ 1 ipcamrec nogroup  372133432 Apr  5 09:22 2016-04-05_08.22.avi
-rw-rw----+ 1 ipcamrec nogroup  105314392 Apr  5 10:22 2016-04-05_09.22.avi
-rw-rw----+ 1 ipcamrec nogroup    1982990 Apr  5 13:47 2016-04-05_13.45.avi
-rw-rw----+ 1 ipcamrec nogroup  254972540 Apr  5 23:34 2016-04-05_22.34.avi
-rw-rw----+ 1 ipcamrec nogroup  282488812 Apr  6 03:34 2016-04-06_02.34.avi
-rw-rw----+ 1 ipcamrec nogroup  144028854 Apr  6 06:00 2016-04-06_05.35.avi
-rw-rw----+ 1 ipcamrec nogroup  946798696 Apr  6 12:42 2016-04-06_11.42.avi
-rw-rw----+ 1 ipcamrec nogroup   71922160 Apr  6 14:43 2016-04-06_13.43.avi
-rw-rw----+ 1 ipcamrec nogroup  946789228 Apr  6 15:55 2016-04-06_14.55.avi
-rw-rw----+ 1 ipcamrec nogroup  946514090 Apr  6 17:03 2016-04-06_16.03.avi
-rw-rw----+ 1 ipcamrec nogroup  946474452 Apr  6 18:03 2016-04-06_17.03.avi
-rw-rw----+ 1 ipcamrec nogroup  313656626 Apr  6 18:23 2016-04-06_18.03.avi
-rw-rw----+ 1 ipcamrec nogroup  946822236 Apr  6 19:25 2016-04-06_18.25.avi
-rw-rw----+ 1 ipcamrec nogroup  802487258 Apr  6 20:25 2016-04-06_19.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946486090 Apr  6 21:25 2016-04-06_20.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946452216 Apr  6 22:25 2016-04-06_21.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946479000 Apr  6 23:25 2016-04-06_22.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946513826 Apr  7 00:25 2016-04-06_23.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946487990 Apr  7 01:25 2016-04-07_00.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946489072 Apr  7 02:25 2016-04-07_01.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946534198 Apr  7 03:25 2016-04-07_02.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946523252 Apr  7 04:25 2016-04-07_03.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946477098 Apr  7 05:25 2016-04-07_04.25.avi
-rw-rw----+ 1 ipcamrec nogroup  903143428 Apr  7 06:25 2016-04-07_05.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946430212 Apr  7 07:25 2016-04-07_06.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946449344 Apr  7 08:25 2016-04-07_07.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946465210 Apr  7 09:25 2016-04-07_08.25.avi
-rw-rw----+ 1 ipcamrec nogroup  946472898 Apr  7 10:25 2016-04-07_09.25.avi
-rw-rw----+ 1 ipcamrec nogroup  185100862 Apr  7 13:26 2016-04-07_12.26.avi
-rw-rw----+ 1 ipcamrec nogroup   67475010 Apr  7 14:09 2016-04-07_13.26.avi
-rw-rw----+ 1 ipcamrec nogroup    1467990 Apr  7 14:10 2016-04-07_14.09.avi
-rw-rw----+ 1 ipcamrec nogroup  946667224 Apr  7 16:28 2016-04-07_15.28.avi
-rw-rw----+ 1 ipcamrec nogroup  179298580 Apr  7 17:28 2016-04-07_16.28.avi
-rw-rw----+ 1 ipcamrec nogroup   24921484 Apr  7 17:31 2016-04-07_17.29.avi
-rw-rw----+ 1 ipcamrec nogroup   12744118 Apr  7 18:49 2016-04-07_18.48.avi
-rw-rw----+ 1 ipcamrec nogroup  385569192 Apr  7 19:49 2016-04-07_18.49.avi
-rw-rw----+ 1 ipcamrec nogroup  946809968 Apr  7 21:50 2016-04-07_20.50.avi
-rw-rw----+ 1 ipcamrec nogroup    6646730 Apr  8 00:07 2016-04-08_00.06.avi
-rw-rw----+ 1 ipcamrec nogroup   31968656 Apr  8 02:47 2016-04-08_02.44.avi
-rw-rw----+ 1 ipcamrec nogroup  946762998 Apr  8 04:47 2016-04-08_03.47.avi
-rw-rw----+ 1 ipcamrec nogroup  946465002 Apr  8 08:00 2016-04-08_07.00.avi
-rw-rw----+ 1 ipcamrec nogroup  946477318 Apr  8 09:00 2016-04-08_08.00.avi
-rw-rw----+ 1 ipcamrec nogroup  946494780 Apr  8 10:00 2016-04-08_09.00.avi
-rw-rw----+ 1 ipcamrec nogroup  946510296 Apr  8 11:00 2016-04-08_10.00.avi
-rw-rw----+ 1 ipcamrec nogroup  946484476 Apr  8 12:00 2016-04-08_11.00.avi
-rw-rw----+ 1 ipcamrec nogroup  609598970 Apr  8 12:39 2016-04-08_12.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1806134264 Apr  8 13:44 2016-04-08_12.44.avi
-rw-rw----+ 1 ipcamrec nogroup 1889800704 Apr  8 14:44 2016-04-08_13.44.avi
-rw-rw----+ 1 ipcamrec nogroup 1827079560 Apr  8 15:42 2016-04-08_14.44.avi
-rw-rw----+ 1 ipcamrec nogroup 1883215112 Apr  8 17:07 2016-04-08_16.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889948336 Apr  8 18:07 2016-04-08_17.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889749660 Apr  8 19:07 2016-04-08_18.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1445027140 Apr  8 20:07 2016-04-08_19.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889935032 Apr  8 21:07 2016-04-08_20.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889900836 Apr  8 22:07 2016-04-08_21.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889915258 Apr  8 23:07 2016-04-08_22.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889786688 Apr  9 00:07 2016-04-08_23.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1885619160 Apr  9 01:07 2016-04-09_00.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1886135810 Apr  9 02:07 2016-04-09_01.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1886453736 Apr  9 03:07 2016-04-09_02.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889910782 Apr  9 04:07 2016-04-09_03.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1865087742 Apr  9 05:07 2016-04-09_04.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1874140666 Apr  9 06:07 2016-04-09_05.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1870302394 Apr  9 07:08 2016-04-09_06.07.avi
-rw-rw----+ 1 ipcamrec nogroup 1889881160 Apr  9 08:08 2016-04-09_07.08.avi
-rw-rw----+ 1 ipcamrec nogroup 1889976608 Apr  9 09:08 2016-04-09_08.08.avi
-rw-rw----+ 1 ipcamrec nogroup 1887500316 Apr  9 10:08 2016-04-09_09.08.avi
-rw-rw----+ 1 ipcamrec nogroup 1129198662 Apr  9 10:44 2016-04-09_10.08.avi
-rw-rw----+ 1 ipcamrec nogroup 1890514742 Apr  9 12:13 2016-04-09_11.12.avi
-rw-rw----+ 1 ipcamrec nogroup  147325100 Apr  9 12:17 2016-04-09_12.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889497662 Apr  9 15:27 2016-04-09_14.27.avi
-rw-rw----+ 1 ipcamrec nogroup 1887175874 Apr  9 16:27 2016-04-09_15.27.avi
-rw-rw----+ 1 ipcamrec nogroup 1888408308 Apr  9 17:27 2016-04-09_16.27.avi
-rw-rw----+ 1 ipcamrec nogroup 1472776032 Apr  9 18:14 2016-04-09_17.27.avi
-rw-rw----+ 1 ipcamrec nogroup   32828964 Apr  9 19:14 2016-04-09_19.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1613118370 Apr  9 20:16 2016-04-09_19.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889843550 Apr  9 21:16 2016-04-09_20.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889766742 Apr  9 22:16 2016-04-09_21.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1883340980 Apr  9 23:16 2016-04-09_22.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889733650 Apr 10 00:16 2016-04-09_23.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889807436 Apr 10 01:16 2016-04-10_00.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889901864 Apr 10 02:16 2016-04-10_01.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889853270 Apr 10 03:16 2016-04-10_02.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1889868776 Apr 10 04:16 2016-04-10_03.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1886411510 Apr 10 05:16 2016-04-10_04.16.avi
-rw-rw----+ 1 ipcamrec nogroup 1666576744 Apr 10 06:12 2016-04-10_05.16.avi
-rw-rw----+ 1 ipcamrec nogroup    6126314 Apr 10 06:13 2016-04-10_06.12.avi
-rw-rw----+ 1 ipcamrec nogroup 1841930382 Apr 10 07:13 2016-04-10_06.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1881541012 Apr 10 08:13 2016-04-10_07.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889829398 Apr 10 09:13 2016-04-10_08.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889874158 Apr 10 10:13 2016-04-10_09.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889911196 Apr 10 11:13 2016-04-10_10.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1883908146 Apr 10 12:13 2016-04-10_11.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889787018 Apr 10 13:13 2016-04-10_12.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889839888 Apr 10 14:13 2016-04-10_13.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1887992232 Apr 10 15:13 2016-04-10_14.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889885252 Apr 10 16:13 2016-04-10_15.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889901498 Apr 10 17:13 2016-04-10_16.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889950316 Apr 10 18:13 2016-04-10_17.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889787864 Apr 10 19:13 2016-04-10_18.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1528635106 Apr 10 20:13 2016-04-10_19.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889891988 Apr 10 21:13 2016-04-10_20.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1886282040 Apr 10 22:13 2016-04-10_21.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889883034 Apr 10 23:13 2016-04-10_22.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889945840 Apr 11 00:13 2016-04-10_23.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1888993082 Apr 11 01:13 2016-04-11_00.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889714666 Apr 11 02:13 2016-04-11_01.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889664878 Apr 11 03:13 2016-04-11_02.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1888301486 Apr 11 04:13 2016-04-11_03.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1889331298 Apr 11 05:13 2016-04-11_04.13.avi
-rw-rw----+ 1 ipcamrec nogroup 1175923264 Apr 11 05:53 2016-04-11_05.13.avi
-rw-rw----+ 1 ipcamrec nogroup   68419728 Apr 11 05:57 2016-04-11_05.53.avi
-rw-rw----+ 1 ipcamrec nogroup 1873436694 Apr 11 06:57 2016-04-11_05.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1887436602 Apr 11 07:57 2016-04-11_06.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889887466 Apr 11 08:57 2016-04-11_07.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889943284 Apr 11 09:57 2016-04-11_08.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889852218 Apr 11 10:57 2016-04-11_09.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889378748 Apr 11 11:57 2016-04-11_10.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889802804 Apr 11 12:57 2016-04-11_11.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889855746 Apr 11 13:57 2016-04-11_12.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1889218854 Apr 11 14:57 2016-04-11_13.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1886705378 Apr 11 15:57 2016-04-11_14.57.avi
-rw-rw----+ 1 ipcamrec nogroup 1886708870 Apr 11 16:58 2016-04-11_15.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889858446 Apr 11 17:58 2016-04-11_16.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889054330 Apr 11 18:58 2016-04-11_17.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1597641750 Apr 11 19:58 2016-04-11_18.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889919826 Apr 11 20:58 2016-04-11_19.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1888412398 Apr 11 21:58 2016-04-11_20.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1885794380 Apr 11 22:58 2016-04-11_21.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1884707414 Apr 11 23:58 2016-04-11_22.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889900728 Apr 12 00:58 2016-04-11_23.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889884398 Apr 12 01:58 2016-04-12_00.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1889781178 Apr 12 02:58 2016-04-12_01.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1886016728 Apr 12 03:58 2016-04-12_02.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1864038114 Apr 12 04:59 2016-04-12_03.58.avi
-rw-rw----+ 1 ipcamrec nogroup 1779118662 Apr 12 05:59 2016-04-12_04.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1878431810 Apr 12 06:59 2016-04-12_05.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1884806130 Apr 12 07:59 2016-04-12_06.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1885702092 Apr 12 08:59 2016-04-12_07.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1881580148 Apr 12 09:59 2016-04-12_08.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1886342064 Apr 12 10:59 2016-04-12_09.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889929230 Apr 12 11:59 2016-04-12_10.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1882495168 Apr 12 12:59 2016-04-12_11.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1885307000 Apr 12 13:59 2016-04-12_12.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889860072 Apr 12 14:59 2016-04-12_13.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1884934696 Apr 12 15:59 2016-04-12_14.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889882852 Apr 12 16:59 2016-04-12_15.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889784990 Apr 12 17:59 2016-04-12_16.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1885806914 Apr 12 18:59 2016-04-12_17.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1607545204 Apr 12 19:59 2016-04-12_18.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889882508 Apr 12 20:59 2016-04-12_19.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889947490 Apr 12 21:59 2016-04-12_20.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889834884 Apr 12 22:59 2016-04-12_21.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889721934 Apr 12 23:59 2016-04-12_22.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889895236 Apr 13 00:59 2016-04-12_23.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889698574 Apr 13 01:59 2016-04-13_00.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1889946950 Apr 13 02:59 2016-04-13_01.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1885390690 Apr 13 03:59 2016-04-13_02.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1877844660 Apr 13 05:00 2016-04-13_03.59.avi
-rw-rw----+ 1 ipcamrec nogroup 1757176460 Apr 13 06:00 2016-04-13_05.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1885521466 Apr 13 07:00 2016-04-13_06.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1889892866 Apr 13 08:00 2016-04-13_07.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1886193044 Apr 13 09:00 2016-04-13_08.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1889794896 Apr 13 10:00 2016-04-13_09.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1885350196 Apr 13 11:00 2016-04-13_10.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1336132512 Apr 13 11:42 2016-04-13_11.00.avi
-rw-rw----+ 1 ipcamrec nogroup 1890034904 Apr 13 12:45 2016-04-13_11.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1889776672 Apr 13 13:45 2016-04-13_12.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1880740714 Apr 13 14:45 2016-04-13_13.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1875794124 Apr 13 15:45 2016-04-13_14.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1889825012 Apr 13 16:45 2016-04-13_15.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1887208784 Apr 13 17:45 2016-04-13_16.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1878739912 Apr 13 18:45 2016-04-13_17.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1771658642 Apr 13 19:45 2016-04-13_18.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1480254696 Apr 13 20:39 2016-04-13_19.45.avi
-rw-rw----+ 1 ipcamrec nogroup 1882739980 Apr 13 21:39 2016-04-13_20.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1884628236 Apr 13 22:39 2016-04-13_21.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1884958958 Apr 13 23:39 2016-04-13_22.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1889835790 Apr 14 00:39 2016-04-13_23.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1889783508 Apr 14 01:39 2016-04-14_00.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1889724314 Apr 14 02:39 2016-04-14_01.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1889866656 Apr 14 03:39 2016-04-14_02.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1818663080 Apr 14 04:39 2016-04-14_03.39.avi
-rw-rw----+ 1 ipcamrec nogroup  364210108 Apr 14 04:55 2016-04-14_04.39.avi
-rw-rw----+ 1 ipcamrec nogroup 1804660656 Apr 14 05:55 2016-04-14_04.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1871579468 Apr 14 06:55 2016-04-14_05.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889785546 Apr 14 07:55 2016-04-14_06.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889806018 Apr 14 08:55 2016-04-14_07.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889911056 Apr 14 09:55 2016-04-14_08.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889655502 Apr 14 10:55 2016-04-14_09.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889742888 Apr 14 11:55 2016-04-14_10.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889864286 Apr 14 12:55 2016-04-14_11.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889917390 Apr 14 13:55 2016-04-14_12.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889711224 Apr 14 14:55 2016-04-14_13.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889939708 Apr 14 15:55 2016-04-14_14.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889765090 Apr 14 16:55 2016-04-14_15.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889881158 Apr 14 17:55 2016-04-14_16.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1890026126 Apr 14 18:55 2016-04-14_17.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1608598284 Apr 14 19:55 2016-04-14_18.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1885417494 Apr 14 20:55 2016-04-14_19.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889832776 Apr 14 21:55 2016-04-14_20.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889889072 Apr 14 22:55 2016-04-14_21.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889872752 Apr 14 23:55 2016-04-14_22.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889822794 Apr 15 00:55 2016-04-14_23.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889798404 Apr 15 01:55 2016-04-15_00.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889890758 Apr 15 02:55 2016-04-15_01.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1890012674 Apr 15 03:55 2016-04-15_02.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1886543896 Apr 15 04:55 2016-04-15_03.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1879452268 Apr 15 05:55 2016-04-15_04.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889820840 Apr 15 06:55 2016-04-15_05.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889867506 Apr 15 07:55 2016-04-15_06.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889958432 Apr 15 08:55 2016-04-15_07.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889908950 Apr 15 09:55 2016-04-15_08.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889641944 Apr 15 10:55 2016-04-15_09.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889915392 Apr 15 11:56 2016-04-15_10.55.avi
-rw-rw----+ 1 ipcamrec nogroup 1889909256 Apr 15 12:56 2016-04-15_11.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889818798 Apr 15 13:56 2016-04-15_12.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889829392 Apr 15 14:56 2016-04-15_13.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889775508 Apr 15 15:56 2016-04-15_14.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889756860 Apr 15 16:56 2016-04-15_15.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889786532 Apr 15 17:56 2016-04-15_16.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1890056526 Apr 15 18:56 2016-04-15_17.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1649906488 Apr 15 19:56 2016-04-15_18.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1772135186 Apr 15 20:56 2016-04-15_19.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889986124 Apr 15 21:56 2016-04-15_20.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889844574 Apr 15 22:56 2016-04-15_21.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889801404 Apr 15 23:56 2016-04-15_22.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889904724 Apr 16 00:56 2016-04-15_23.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889869040 Apr 16 01:56 2016-04-16_00.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889867918 Apr 16 02:56 2016-04-16_01.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889990608 Apr 16 03:56 2016-04-16_02.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889813948 Apr 16 04:56 2016-04-16_03.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1820414790 Apr 16 05:56 2016-04-16_04.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889908338 Apr 16 06:56 2016-04-16_05.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889860952 Apr 16 07:56 2016-04-16_06.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889859886 Apr 16 08:56 2016-04-16_07.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889893872 Apr 16 09:56 2016-04-16_08.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889812792 Apr 16 10:56 2016-04-16_09.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889832438 Apr 16 11:56 2016-04-16_10.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889872918 Apr 16 12:56 2016-04-16_11.56.avi
-rw-rw----+ 1 ipcamrec nogroup 1889939730 Apr 16 13:56 2016-04-16_12.56.avi
-rw-rw----+ 1 ipcamrec nogroup  871225198 Apr 16 14:24 2016-04-16_13.56.avi
-rw-rw----+ 1 ipcamrec nogroup  121789784 Apr 16 14:29 2016-04-16_14.25.ts


# filefrag *
2016-04-01_18.30.avi: 71 extents found
2016-04-01_19.08.avi: 115 extents found
2016-04-01_20.09.avi: 117 extents found
2016-04-01_21.09.avi: 126 extents found
2016-04-01_22.09.avi: 122 extents found
2016-04-01_23.09.avi: 119 extents found
2016-04-02_00.09.avi: 110 extents found
2016-04-02_01.09.avi: 35 extents found
2016-04-02_01.29.avi: 111 extents found
2016-04-02_02.29.avi: 110 extents found
2016-04-02_03.29.avi: 118 extents found
2016-04-02_04.29.avi: 197 extents found
2016-04-02_05.29.avi: 132 extents found
2016-04-02_06.29.avi: 118 extents found
2016-04-02_07.29.avi: 129 extents found
2016-04-02_08.29.avi: 70 extents found
2016-04-02_09.03.avi: 189 extents found
2016-04-02_10.03.avi: 133 extents found
2016-04-02_11.03.avi: 92 extents found
2016-04-02_11.45.avi: 93 extents found
2016-04-02_12.41.avi: 35 extents found
2016-04-02_12.55.avi: 102 extents found
2016-04-02_13.50.avi: 97 extents found
2016-04-02_14.40.avi: 2 extents found
2016-04-02_14.41.avi: 76 extents found
2016-04-02_15.16.avi: 43 extents found
2016-04-02_15.37.avi: 40 extents found
2016-04-02_16.00.avi: 127 extents found
2016-04-02_17.00.avi: 6 extents found
2016-04-02_17.03.avi: 119 extents found
2016-04-02_18.03.avi: 117 extents found
2016-04-02_19.03.avi: 112 extents found
2016-04-02_20.03.avi: 131 extents found
2016-04-02_21.03.avi: 145 extents found
2016-04-02_22.03.avi: 124 extents found
2016-04-02_23.03.avi: 122 extents found
2016-04-03_00.03.avi: 127 extents found
2016-04-03_01.03.avi: 119 extents found
2016-04-03_02.03.avi: 111 extents found
2016-04-03_03.03.avi: 107 extents found
2016-04-03_04.03.avi: 118 extents found
2016-04-03_06.07.avi: 137 extents found
2016-04-03_07.07.avi: 118 extents found
2016-04-03_08.07.avi: 6 extents found
2016-04-03_08.56.avi: 127 extents found
2016-04-03_10.02.avi: 31 extents found
2016-04-03_10.50.avi: 115 extents found
2016-04-03_11.52.avi: 125 extents found
2016-04-03_12.52.avi: 1 extent found
2016-04-03_12.57.avi: 19 extents found
2016-04-03_14.50.avi: 108 extents found
2016-04-03_15.50.avi: 110 extents found
2016-04-03_17.51.avi: 122 extents found
2016-04-03_18.51.avi: 101 extents found
2016-04-03_19.43.avi: 19 extents found
2016-04-03_21.04.avi: 107 extents found
2016-04-03_22.05.avi: 124 extents found
2016-04-03_23.05.avi: 34 extents found
2016-04-04_02.31.avi: 114 extents found
2016-04-04_03.31.avi: 105 extents found
2016-04-04_04.31.avi: 4 extents found
2016-04-04_04.34.avi: 221 extents found
2016-04-04_05.56.avi: 72 extents found
2016-04-04_06.56.avi: 127 extents found
2016-04-04_07.56.avi: 1 extent found
2016-04-04_07.58.avi: 3 extents found
2016-04-04_08.50.avi: 130 extents found
2016-04-04_09.50.avi: 115 extents found
2016-04-04_11.28.avi: 102 extents found
2016-04-04_12.39.avi: 129 extents found
2016-04-04_13.40.avi: 67 extents found
2016-04-04_14.38.avi: 127 extents found
2016-04-04_15.38.avi: 13 extents found
2016-04-04_15.46.avi: 30 extents found
2016-04-04_16.46.avi: 1 extent found
2016-04-04_17.48.avi: 117 extents found
2016-04-04_19.15.avi: 36 extents found
2016-04-04_19.46.avi: 91 extents found
2016-04-04_20.28.avi: 117 extents found
2016-04-04_22.29.avi: 115 extents found
2016-04-04_23.35.avi: 93 extents found
2016-04-05_00.35.avi: 83 extents found
2016-04-05_01.35.avi: 23 extents found
2016-04-05_02.52.avi: 117 extents found
2016-04-05_03.52.avi: 113 extents found
2016-04-05_04.52.avi: 154 extents found
2016-04-05_05.58.avi: 128 extents found
2016-04-05_07.03.avi: 100 extents found
2016-04-05_08.03.avi: 19 extents found
2016-04-05_08.22.avi: 53 extents found
2016-04-05_09.22.avi: 125 extents found
2016-04-05_13.45.avi: 2 extents found
2016-04-05_22.34.avi: 411 extents found
2016-04-06_02.34.avi: 268 extents found
2016-04-06_05.35.avi: 11 extents found
2016-04-06_11.42.avi: 373 extents found
2016-04-06_13.43.avi: 124 extents found
2016-04-06_14.55.avi: 263 extents found
2016-04-06_16.03.avi: 277 extents found
2016-04-06_17.03.avi: 289 extents found
2016-04-06_18.03.avi: 97 extents found
2016-04-06_18.25.avi: 137 extents found
2016-04-06_19.25.avi: 168 extents found
2016-04-06_20.25.avi: 186 extents found
2016-04-06_21.25.avi: 296 extents found
2016-04-06_22.25.avi: 255 extents found
2016-04-06_23.25.avi: 323 extents found
2016-04-07_00.25.avi: 323 extents found
2016-04-07_01.25.avi: 393 extents found
2016-04-07_02.25.avi: 440 extents found
2016-04-07_03.25.avi: 275 extents found
2016-04-07_04.25.avi: 140 extents found
2016-04-07_05.25.avi: 144 extents found
2016-04-07_06.25.avi: 159 extents found
2016-04-07_07.25.avi: 136 extents found
2016-04-07_08.25.avi: 221 extents found
2016-04-07_09.25.avi: 161 extents found
2016-04-07_12.26.avi: 98 extents found
2016-04-07_13.26.avi: 92 extents found
2016-04-07_14.09.avi: 1 extent found
2016-04-07_15.28.avi: 285 extents found
2016-04-07_16.28.avi: 205 extents found
2016-04-07_17.29.avi: 5 extents found
2016-04-07_18.48.avi: 3 extents found
2016-04-07_18.49.avi: 70 extents found
2016-04-07_20.50.avi: 288 extents found
2016-04-08_00.06.avi: 2 extents found
2016-04-08_02.44.avi: 11 extents found
2016-04-08_03.47.avi: 178 extents found
2016-04-08_07.00.avi: 121 extents found
2016-04-08_08.00.avi: 131 extents found
2016-04-08_09.00.avi: 147 extents found
2016-04-08_10.00.avi: 264 extents found
2016-04-08_11.00.avi: 259 extents found
2016-04-08_12.00.avi: 148 extents found
2016-04-08_12.44.avi: 246 extents found
2016-04-08_13.44.avi: 180 extents found
2016-04-08_14.44.avi: 169 extents found
2016-04-08_16.07.avi: 248 extents found
2016-04-08_17.07.avi: 266 extents found
2016-04-08_18.07.avi: 267 extents found
2016-04-08_19.07.avi: 279 extents found
2016-04-08_20.07.avi: 119 extents found
2016-04-08_21.07.avi: 333 extents found
2016-04-08_22.07.avi: 290 extents found
2016-04-08_23.07.avi: 289 extents found
2016-04-09_00.07.avi: 281 extents found
2016-04-09_01.07.avi: 316 extents found
2016-04-09_02.07.avi: 269 extents found
2016-04-09_03.07.avi: 280 extents found
2016-04-09_04.07.avi: 210 extents found
2016-04-09_05.07.avi: 146 extents found
2016-04-09_06.07.avi: 155 extents found
2016-04-09_07.08.avi: 277 extents found
2016-04-09_08.08.avi: 272 extents found
2016-04-09_09.08.avi: 248 extents found
2016-04-09_10.08.avi: 172 extents found
2016-04-09_11.12.avi: 146 extents found
2016-04-09_12.13.avi: 12 extents found
2016-04-09_14.27.avi: 134 extents found
2016-04-09_15.27.avi: 132 extents found
2016-04-09_16.27.avi: 137 extents found
2016-04-09_17.27.avi: 100 extents found
2016-04-09_19.13.avi: 3 extents found
2016-04-09_19.16.avi: 127 extents found
2016-04-09_20.16.avi: 244 extents found
2016-04-09_21.16.avi: 153 extents found
2016-04-09_22.16.avi: 186 extents found
2016-04-09_23.16.avi: 158 extents found
2016-04-10_00.16.avi: 167 extents found
2016-04-10_01.16.avi: 106 extents found
2016-04-10_02.16.avi: 107 extents found
2016-04-10_03.16.avi: 104 extents found
2016-04-10_04.16.avi: 106 extents found
2016-04-10_05.16.avi: 103 extents found
2016-04-10_06.12.avi: 3 extents found
2016-04-10_06.13.avi: 275 extents found
2016-04-10_07.13.avi: 111 extents found
2016-04-10_08.13.avi: 106 extents found
2016-04-10_09.13.avi: 107 extents found
2016-04-10_10.13.avi: 107 extents found
2016-04-10_11.13.avi: 106 extents found
2016-04-10_12.13.avi: 107 extents found
2016-04-10_13.13.avi: 106 extents found
2016-04-10_14.13.avi: 106 extents found
2016-04-10_15.13.avi: 106 extents found
2016-04-10_16.13.avi: 106 extents found
2016-04-10_17.13.avi: 107 extents found
2016-04-10_18.13.avi: 105 extents found
2016-04-10_19.13.avi: 113 extents found
2016-04-10_20.13.avi: 106 extents found
2016-04-10_21.13.avi: 105 extents found
2016-04-10_22.13.avi: 104 extents found
2016-04-10_23.13.avi: 105 extents found
2016-04-11_00.13.avi: 317 extents found
2016-04-11_01.13.avi: 271 extents found
2016-04-11_02.13.avi: 321 extents found
2016-04-11_03.13.avi: 281 extents found
2016-04-11_04.13.avi: 175 extents found
2016-04-11_05.13.avi: 182 extents found
2016-04-11_05.53.avi: 7 extents found
2016-04-11_05.57.avi: 122 extents found
2016-04-11_06.57.avi: 215 extents found
2016-04-11_07.57.avi: 162 extents found
2016-04-11_08.57.avi: 122 extents found
2016-04-11_09.57.avi: 244 extents found
2016-04-11_10.57.avi: 274 extents found
2016-04-11_11.57.avi: 316 extents found
2016-04-11_12.57.avi: 300 extents found
2016-04-11_13.57.avi: 267 extents found
2016-04-11_14.57.avi: 308 extents found
2016-04-11_15.58.avi: 313 extents found
2016-04-11_16.58.avi: 304 extents found
2016-04-11_17.58.avi: 272 extents found
2016-04-11_18.58.avi: 279 extents found
2016-04-11_19.58.avi: 274 extents found
2016-04-11_20.58.avi: 259 extents found
2016-04-11_21.58.avi: 263 extents found
2016-04-11_22.58.avi: 269 extents found
2016-04-11_23.58.avi: 254 extents found
2016-04-12_00.58.avi: 257 extents found
2016-04-12_01.58.avi: 287 extents found
2016-04-12_02.58.avi: 270 extents found
2016-04-12_03.58.avi: 168 extents found
2016-04-12_04.59.avi: 190 extents found
2016-04-12_05.59.avi: 106 extents found
2016-04-12_06.59.avi: 107 extents found
2016-04-12_07.59.avi: 122 extents found
2016-04-12_08.59.avi: 116 extents found
2016-04-12_09.59.avi: 121 extents found
2016-04-12_10.59.avi: 123 extents found
2016-04-12_11.59.avi: 125 extents found
2016-04-12_12.59.avi: 122 extents found
2016-04-12_13.59.avi: 205 extents found
2016-04-12_14.59.avi: 261 extents found
2016-04-12_15.59.avi: 275 extents found
2016-04-12_16.59.avi: 228 extents found
2016-04-12_17.59.avi: 244 extents found
2016-04-12_18.59.avi: 267 extents found
2016-04-12_19.59.avi: 312 extents found
2016-04-12_20.59.avi: 334 extents found
2016-04-12_21.59.avi: 359 extents found
2016-04-12_22.59.avi: 295 extents found
2016-04-12_23.59.avi: 268 extents found
2016-04-13_00.59.avi: 287 extents found
2016-04-13_01.59.avi: 314 extents found
2016-04-13_02.59.avi: 339 extents found
2016-04-13_03.59.avi: 177 extents found
2016-04-13_05.00.avi: 259 extents found
2016-04-13_06.00.avi: 221 extents found
2016-04-13_07.00.avi: 113 extents found
2016-04-13_08.00.avi: 114 extents found
2016-04-13_09.00.avi: 152 extents found
2016-04-13_10.00.avi: 134 extents found
2016-04-13_11.00.avi: 86 extents found
2016-04-13_11.45.avi: 202 extents found
2016-04-13_12.45.avi: 141 extents found
2016-04-13_13.45.avi: 121 extents found
2016-04-13_14.45.avi: 126 extents found
2016-04-13_15.45.avi: 126 extents found
2016-04-13_16.45.avi: 122 extents found
2016-04-13_17.45.avi: 126 extents found
2016-04-13_18.45.avi: 127 extents found
2016-04-13_19.45.avi: 169 extents found
2016-04-13_20.39.avi: 281 extents found
2016-04-13_21.39.avi: 115 extents found
2016-04-13_22.39.avi: 110 extents found
2016-04-13_23.39.avi: 118 extents found
2016-04-14_00.39.avi: 122 extents found
2016-04-14_01.39.avi: 108 extents found
2016-04-14_02.39.avi: 117 extents found
2016-04-14_03.39.avi: 138 extents found
2016-04-14_04.39.avi: 56 extents found
2016-04-14_04.55.avi: 318 extents found
2016-04-14_05.55.avi: 110 extents found
2016-04-14_06.55.avi: 105 extents found
2016-04-14_07.55.avi: 107 extents found
2016-04-14_08.55.avi: 110 extents found
2016-04-14_09.55.avi: 109 extents found
2016-04-14_10.55.avi: 134 extents found
2016-04-14_11.55.avi: 110 extents found
2016-04-14_12.55.avi: 109 extents found
2016-04-14_13.55.avi: 113 extents found
2016-04-14_14.55.avi: 107 extents found
2016-04-14_15.55.avi: 124 extents found
2016-04-14_16.55.avi: 107 extents found
2016-04-14_17.55.avi: 111 extents found
2016-04-14_18.55.avi: 106 extents found
2016-04-14_19.55.avi: 136 extents found
2016-04-14_20.55.avi: 159 extents found
2016-04-14_21.55.avi: 166 extents found
2016-04-14_22.55.avi: 156 extents found
2016-04-14_23.55.avi: 122 extents found
2016-04-15_00.55.avi: 109 extents found
2016-04-15_01.55.avi: 113 extents found
2016-04-15_02.55.avi: 109 extents found
2016-04-15_03.55.avi: 153 extents found
2016-04-15_04.55.avi: 212 extents found
2016-04-15_05.55.avi: 112 extents found
2016-04-15_06.55.avi: 105 extents found
2016-04-15_07.55.avi: 112 extents found
2016-04-15_08.55.avi: 108 extents found
2016-04-15_09.55.avi: 124 extents found
2016-04-15_10.55.avi: 136 extents found
2016-04-15_11.56.avi: 125 extents found
2016-04-15_12.56.avi: 126 extents found
2016-04-15_13.56.avi: 129 extents found
2016-04-15_14.56.avi: 126 extents found
2016-04-15_15.56.avi: 125 extents found
2016-04-15_16.56.avi: 142 extents found
2016-04-15_17.56.avi: 127 extents found
2016-04-15_18.56.avi: 123 extents found
2016-04-15_19.56.avi: 123 extents found
2016-04-15_20.56.avi: 123 extents found
2016-04-15_21.56.avi: 123 extents found
2016-04-15_22.56.avi: 125 extents found
2016-04-15_23.56.avi: 124 extents found
2016-04-16_00.56.avi: 123 extents found
2016-04-16_01.56.avi: 124 extents found
2016-04-16_02.56.avi: 123 extents found
2016-04-16_03.56.avi: 669 extents found
2016-04-16_04.56.avi: 340 extents found
2016-04-16_05.56.avi: 173 extents found
2016-04-16_06.56.avi: 158 extents found
2016-04-16_07.56.avi: 157 extents found
2016-04-16_08.56.avi: 158 extents found
2016-04-16_09.56.avi: 169 extents found
2016-04-16_10.56.avi: 162 extents found
2016-04-16_11.56.avi: 163 extents found
2016-04-16_12.56.avi: 186 extents found
2016-04-16_13.56.avi: 126 extents found
2016-04-16_14.25.ts: 40 extents found

# time rm *

real    41m14.653s
user    0m0.006s
sys     0m36.110s



If I copy a similar folder to a freshly created Btrfs filesystem with
a single slow HDD (an old 5400RPM notebook drive with single data and
single metadata mode rather than RAID or DUP), rm takes merely a few
seconds to complete on the copy (of course, the average extents per
files are ~1.5 on the new filesystem rather than ~150 like here).

I run regular defrag on the whole filesystem (daily cronjob at
nights). This is how a recursive defrag leaves these files (and I also
run defrag on directory metadata with find).

I can think of some ways to reduce the fragmentation but I wonder if
this is normal or it's a kind of "bug" (or rather a lack of
optimization due to the development state of Btrfs RAID-5).


I tried to "tune" the io scheduler and some other kernel parameters
(as well as changing between different schedulers) and while they do
have some effects on the overall performance, it's not that much (1-5%
is not significant when one wishes for >100% difference).
