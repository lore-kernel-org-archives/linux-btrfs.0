Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:52099 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2FYSag (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 14:30:36 -0400
Received: by yhnn12 with SMTP id n12so3672870yhn.10
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 11:30:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 21:30:34 +0300
Message-ID: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
Subject: fio reports data corruption with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings everybody,

I am running a fio test on btrfs compiled from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git,
up to commit:
cb77fcd88569cd2b7b25ecd4086ea932a53be9b3 Btrfs: delay iput with async extents
including this commit.

Below is a fio configuration file, and later fio textual output.
Here:
https://docs.google.com/folder/d/0B1AuaIB8xZtbNTRuSW1zVGozWFE/edit
are "expected" vs "received" mismatch reports. Strangely, when I read
the mismatched block from the file reported as corrupted by fio, I
receive data different both from "expected" and "received" blocks that
fio reports. I added one such file (job0.1.0.88576.now) to the
pastebin as well.

If you think that my fio configuration file is faulty, please let me
know. fio version is 1.59. The idea is to run 10 io processes in
parallel.

Thanks,
Alex.

-----fio configuration:---------
[global]
directory=/mnt/btrfs

rw=randrw
randrepeat=1

size=10000m
filesize=100k-10m
nrfiles=1000

bsrange=512b-64k
bs_unaligned
scramble_buffers=1

ioengine=sync

fsync=1024

verify=md5
do_verify=1
verify_fatal=1
verify_dump=1


[job0]

[job1]

[job2]

[job3]

[job4]

[job5]

[job6]

[job7]

[job8]

[job9]

-----fio output------------------
job0: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job1: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job2: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job3: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job4: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job5: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job6: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job7: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job8: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job9: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
fio 1.59
Starting 10 processes
job0: Laying out IO file(s) (1000 file(s) / 5131MB)
job1: Laying out IO file(s) (1000 file(s) / 5045MB)
job2: Laying out IO file(s) (1000 file(s) / 5168MB)
job3: Laying out IO file(s) (1000 file(s) / 4954MB)
job4: Laying out IO file(s) (1000 file(s) / 5041MB)
job5: Laying out IO file(s) (1000 file(s) / 4898MB)
job6: Laying out IO file(s) (1000 file(s) / 5099MB)
job7: Laying out IO file(s) (1000 file(s) / 5055MB)
job8: Laying out IO file(s) (1000 file(s) / 5049MB)
job9: Laying out IO file(s) (1000 file(s) / 4944MB)

job0: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3464
  read : io=2496.3MB, bw=136725 B/s, iops=9 , runt=19144097msec
    clat (usec): min=0 , max=1510.7K, avg=25048.70, stdev=42148.74
     lat (usec): min=0 , max=1510.7K, avg=25049.48, stdev=42148.66
    bw (KB/s) : min=    0, max= 1384, per=11.28%, avg=147.48, stdev=127.76
  write: io=2478.3MB, bw=135738 B/s, iops=9 , runt=19144074msec
    clat (usec): min=8 , max=6299.7K, avg=80909.59, stdev=134487.90
     lat (usec): min=8 , max=6299.7K, avg=80910.18, stdev=134487.93
    bw (KB/s) : min=    0, max=  881, per=10.68%, avg=139.44, stdev=86.23
  cpu          : usr=0.08%, sys=0.19%, ctx=515969, majf=0, minf=4547
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=180604/180349/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.23%, 10=1.62%, 20=0.75%, 50=2.20%
     lat (usec): 100=0.31%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.03%
     lat (msec): 2=0.61%, 4=7.66%, 10=24.17%, 20=19.00%, 50=18.18%
     lat (msec): 100=9.30%, 250=13.19%, 500=2.38%, 750=0.13%, 1000=0.03%
     lat (msec): 2000=0.13%, >=2000=0.02%
job1: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3465
  read : io=2450.6MB, bw=136831 B/s, iops=9 , runt=18779397msec
    clat (usec): min=0 , max=1489.8K, avg=23070.44, stdev=36372.06
     lat (usec): min=0 , max=1489.8K, avg=23071.12, stdev=36372.17
    bw (KB/s) : min=    0, max= 1894, per=11.18%, avg=146.18, stdev=123.43
  write: io=2446.7MB, bw=136609 B/s, iops=9 , runt=18779340msec
    clat (usec): min=7 , max=8154.8K, avg=82150.38, stdev=132095.17
     lat (usec): min=7 , max=8154.8K, avg=82150.98, stdev=132095.19
    bw (KB/s) : min=    0, max= 1477, per=10.70%, avg=139.58, stdev=79.31
  cpu          : usr=0.08%, sys=0.20%, ctx=499619, majf=0, minf=4467
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=177966/177189/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.15%, 10=1.49%, 20=0.61%, 50=2.02%
     lat (usec): 100=0.27%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.27%, 4=6.39%, 10=25.07%, 20=19.53%, 50=19.32%
     lat (msec): 100=9.09%, 250=13.41%, 500=2.05%, 750=0.09%, 1000=0.02%
     lat (msec): 2000=0.13%, >=2000=0.02%
job2: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3466
  read : io=2510.8MB, bw=140997 B/s, iops=9 , runt=18671605msec
    clat (usec): min=0 , max=1020.2K, avg=21983.31, stdev=33041.43
     lat (usec): min=0 , max=1020.3K, avg=21984.00, stdev=33041.54
    bw (KB/s) : min=    0, max= 1193, per=11.45%, avg=149.77, stdev=126.37
  write: io=2506.7MB, bw=140771 B/s, iops=9 , runt=18671552msec
    clat (usec): min=8 , max=6267.1K, avg=80858.49, stdev=131766.39
     lat (usec): min=8 , max=6267.1K, avg=80859.08, stdev=131766.41
    bw (KB/s) : min=    0, max= 1091, per=10.96%, avg=143.04, stdev=84.29
  cpu          : usr=0.08%, sys=0.20%, ctx=507090, majf=0, minf=4673
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=181766/181195/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.12%, 10=1.49%, 20=0.61%, 50=2.02%
     lat (usec): 100=0.27%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.23%, 4=6.05%, 10=25.29%, 20=19.92%, 50=19.74%
     lat (msec): 100=9.03%, 250=13.06%, 500=1.87%, 750=0.07%, 1000=0.01%
     lat (msec): 2000=0.13%, >=2000=0.02%
job3: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3467
  read : io=2403.8MB, bw=141394 B/s, iops=9 , runt=17825854msec
    clat (usec): min=0 , max=1507.1K, avg=21230.56, stdev=31634.13
     lat (usec): min=0 , max=1507.1K, avg=21242.66, stdev=31706.30
    bw (KB/s) : min=    0, max= 1631, per=11.43%, avg=149.48, stdev=129.48
  write: io=2410.3MB, bw=141781 B/s, iops=9 , runt=17825392msec
    clat (usec): min=7 , max=6122.6K, avg=80499.39, stdev=126021.57
     lat (usec): min=7 , max=6122.6K, avg=80499.99, stdev=126021.59
    bw (KB/s) : min=    0, max= 1368, per=10.98%, avg=143.31, stdev=87.04
  cpu          : usr=0.08%, sys=0.20%, ctx=488731, majf=6, minf=4475
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=174678/174992/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.15%, 10=1.47%, 20=0.64%, 50=1.98%
     lat (usec): 100=0.26%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.24%, 4=6.01%, 10=25.36%, 20=20.26%, 50=19.72%
     lat (msec): 100=8.71%, 250=13.17%, 500=1.77%, 750=0.07%, 1000=0.01%
     lat (msec): 2000=0.10%, >=2000=0.02%
job4: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3468
  read : io=2439.5MB, bw=141037 B/s, iops=9 , runt=18136577msec
    clat (usec): min=0 , max=1007.6K, avg=21403.03, stdev=31429.28
     lat (usec): min=0 , max=1007.6K, avg=21410.58, stdev=31463.14
    bw (KB/s) : min=    0, max= 1195, per=11.44%, avg=149.70, stdev=128.42
  write: io=2449.5MB, bw=141615 B/s, iops=9 , runt=18136396msec
    clat (usec): min=6 , max=6576.6K, avg=80851.64, stdev=130270.83
     lat (usec): min=6 , max=6576.6K, avg=80852.24, stdev=130270.85
    bw (KB/s) : min=    0, max= 1240, per=11.00%, avg=143.51, stdev=85.36
  cpu          : usr=0.08%, sys=0.20%, ctx=490020, majf=0, minf=4441
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=176712/177196/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.15%, 10=1.46%, 20=0.67%, 50=1.99%
     lat (usec): 100=0.25%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.23%, 4=5.95%, 10=24.99%, 20=20.16%, 50=20.13%
     lat (msec): 100=8.92%, 250=13.06%, 500=1.78%, 750=0.07%, 1000=0.01%
     lat (msec): 2000=0.11%, >=2000=0.02%
job5: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3469
  read : io=2367.9MB, bw=138834 B/s, iops=9 , runt=17877831msec
    clat (usec): min=0 , max=1077.8K, avg=21170.18, stdev=31605.60
     lat (usec): min=0 , max=1077.8K, avg=21170.98, stdev=31606.07
    bw (KB/s) : min=    0, max= 1250, per=11.34%, avg=148.27, stdev=126.53
  write: io=2381.5MB, bw=139679 B/s, iops=9 , runt=17877733msec
    clat (usec): min=8 , max=113686K, avg=82698.04, stdev=303004.44
     lat (usec): min=8 , max=113686K, avg=82698.64, stdev=303004.45
    bw (KB/s) : min=    0, max=  945, per=10.88%, avg=142.03, stdev=80.03
  cpu          : usr=0.08%, sys=0.20%, ctx=477997, majf=0, minf=4313
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=171549/172006/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.16%, 10=1.54%, 20=0.65%, 50=2.01%
     lat (usec): 100=0.25%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.23%, 4=5.90%, 10=25.08%, 20=20.17%, 50=19.83%
     lat (msec): 100=8.75%, 250=13.33%, 500=1.83%, 750=0.06%, 1000=0.02%
     lat (msec): 2000=0.10%, >=2000=0.02%
job6: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3470
  read : io=2480.1MB, bw=142701 B/s, iops=9 , runt=18230196msec
    clat (usec): min=0 , max=1104.2K, avg=21473.52, stdev=32023.64
     lat (usec): min=0 , max=1104.2K, avg=21474.12, stdev=32023.64
    bw (KB/s) : min=    0, max= 1334, per=11.57%, avg=151.33, stdev=130.32
  write: io=2462.7MB, bw=141646 B/s, iops=9 , runt=18230168msec
    clat (usec): min=8 , max=5290.6K, avg=80382.37, stdev=127185.58
     lat (usec): min=9 , max=5290.6K, avg=80382.97, stdev=127185.60
    bw (KB/s) : min=    0, max= 1494, per=10.99%, avg=143.47, stdev=85.71
  cpu          : usr=0.09%, sys=0.20%, ctx=496651, majf=0, minf=4584
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=179365/178598/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.16%, 10=1.47%, 20=0.65%, 50=1.99%
     lat (usec): 100=0.24%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.23%, 4=5.96%, 10=25.20%, 20=20.15%, 50=19.96%
     lat (msec): 100=9.01%, 250=12.95%, 500=1.78%, 750=0.07%, 1000=0.01%
     lat (msec): 2000=0.11%, >=2000=0.02%
job7: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3471
  read : io=2457.5MB, bw=140897 B/s, iops=9 , runt=18288243msec
    clat (usec): min=0 , max=1338.7K, avg=22043.04, stdev=33519.83
     lat (usec): min=0 , max=1338.7K, avg=22046.87, stdev=33527.50
    bw (KB/s) : min=    0, max= 1247, per=11.44%, avg=149.66, stdev=129.04
  write: io=2443.5MB, bw=140096 B/s, iops=9 , runt=18288053msec
    clat (usec): min=7 , max=8063.6K, avg=81557.61, stdev=132788.93
     lat (usec): min=8 , max=8063.6K, avg=81558.20, stdev=132788.95
    bw (KB/s) : min=    0, max= 1002, per=10.90%, avg=142.25, stdev=84.60
  cpu          : usr=0.08%, sys=0.20%, ctx=489184, majf=0, minf=4559
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=176436/176293/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.16%, 10=1.43%, 20=0.62%, 50=1.96%
     lat (usec): 100=0.24%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.24%, 4=6.06%, 10=25.24%, 20=19.99%, 50=19.64%
     lat (msec): 100=8.99%, 250=13.25%, 500=1.88%, 750=0.08%, 1000=0.02%
     lat (msec): 2000=0.11%, >=2000=0.02%
job8: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3472
  read : io=2459.6MB, bw=137875 B/s, iops=9 , runt=18701643msec
    clat (usec): min=0 , max=1511.2K, avg=23458.01, stdev=37066.34
     lat (usec): min=0 , max=1511.2K, avg=23459.06, stdev=37066.34
    bw (KB/s) : min=    0, max= 1156, per=11.21%, avg=146.57, stdev=126.45
  write: io=2441.6MB, bw=136866 B/s, iops=9 , runt=18701599msec
    clat (usec): min=8 , max=6941.5K, avg=82135.36, stdev=133215.89
     lat (usec): min=8 , max=6941.5K, avg=82135.95, stdev=133215.91
    bw (KB/s) : min=    0, max= 1077, per=10.67%, avg=139.19, stdev=83.27
  cpu          : usr=0.08%, sys=0.20%, ctx=491008, majf=0, minf=4569
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=177579/176670/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.14%, 10=1.50%, 20=0.60%, 50=1.98%
     lat (usec): 100=0.25%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.27%, 4=6.28%, 10=24.85%, 20=19.55%, 50=19.45%
     lat (msec): 100=9.31%, 250=13.49%, 500=2.02%, 750=0.09%, 1000=0.02%
     lat (msec): 2000=0.12%, >=2000=0.02%
job9: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=3473
  read : io=2401.2MB, bw=132245 B/s, iops=9 , runt=19039047msec
    clat (usec): min=0 , max=1476.2K, avg=25714.10, stdev=42489.38
     lat (usec): min=0 , max=1476.2K, avg=25715.47, stdev=42489.41
    bw (KB/s) : min=    0, max= 1445, per=10.87%, avg=142.23, stdev=122.88
  write: io=2393.6MB, bw=131825 B/s, iops=9 , runt=19038993msec
    clat (usec): min=7 , max=81630K, avg=83909.39, stdev=237517.33
     lat (usec): min=7 , max=81630K, avg=83909.98, stdev=237517.34
    bw (KB/s) : min=    0, max= 1680, per=10.37%, avg=135.39, stdev=81.47
  cpu          : usr=0.08%, sys=0.19%, ctx=490383, majf=0, minf=4490
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=173514/173472/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.18%, 10=1.53%, 20=0.67%, 50=2.08%
     lat (usec): 100=0.29%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.02%
     lat (msec): 2=0.39%, 4=6.60%, 10=23.68%, 20=19.59%, 50=18.79%
     lat (msec): 100=9.67%, 250=13.75%, 500=2.39%, 750=0.12%, 1000=0.03%
     lat (msec): 2000=0.13%, >=2000=0.02%

Run status group 0 (all jobs):
   READ: io=24466MB, aggrb=1308KB/s, minb=132KB/s, maxb=142KB/s,
mint=17825854msec, maxt=19144097msec
  WRITE: io=24413MB, aggrb=1305KB/s, minb=131KB/s, maxb=141KB/s,
mint=17825392msec, maxt=19144074msec
