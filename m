Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49895 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2F0IQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 04:16:01 -0400
Received: by obbuo13 with SMTP id uo13so1144272obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 01:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
	<20120625192632.GF7404@localhost.localdomain>
	<CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
Date: Wed, 27 Jun 2012 11:15:59 +0300
Message-ID: <CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
Subject: Re: fio reports data corruption with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
I have rerun the test with btrfs-next master branch. fio reported
mismatched blocks again. Mount options were the same (-o
noatime,nodatacow).

In both cases the drive is a 135Gb drive, while the total size of
allocated block groups is around 60Gb:
Data: total=62.01GB, used=49.04GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.00GB, used=5.58MB
Metadata: total=8.00MB, used=0.00

(In addition, one of the fio processes crashed with the following stack trace:
Program terminated with signal 6, Aborted.
#0  0x00007fbd66ddf445 in raise () from /lib/x86_64-linux-gnu/libc.so.6
(gdb) bt
#0  0x00007fbd66ddf445 in raise () from /lib/x86_64-linux-gnu/libc.so.6
#1  0x00007fbd66de2bab in abort () from /lib/x86_64-linux-gnu/libc.so.6
#2  0x00007fbd66e1ce2e in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#3  0x00007fbd66e27626 in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#4  0x0000000000419e91 in verify_io_u ()
#5  0x000000000041cc0e in ?? ()
#6  0x000000000041cf49 in io_u_sync_complete ()
#7  0x000000000040b090 in ?? ()
#8  0x000000000040b4ae in ?? ()
#9  0x00000000004076a3 in main ()
I will recompile fio with symbols for later tests).

I have put all the files here (including core), just in case:
https://docs.google.com/folder/d/0B1AuaIB8xZtbb3ExRk5qRVFjYWc/edit

fio output:
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
job0: Laying out IO file(s) (1000 file(s) / 4997MB)
job1: Laying out IO file(s) (1000 file(s) / 4921MB)
job2: Laying out IO file(s) (1000 file(s) / 5140MB)
job3: Laying out IO file(s) (1000 file(s) / 5086MB)
job4: Laying out IO file(s) (1000 file(s) / 4869MB)
job5: Laying out IO file(s) (1000 file(s) / 5106MB)
job6: Laying out IO file(s) (1000 file(s) / 4980MB)
job7: Laying out IO file(s) (1000 file(s) / 5052MB)
job8: Laying out IO file(s) (1000 file(s) / 5075MB)
job9: Laying out IO file(s) (1000 file(s) / 4964MB)
md5: verify failed at file /mnt/btrfs/job5.6.0 offset 9728, length 512
       Expected CRC: 00000000000000000000000000000000
       Received CRC: e3e8620ae5404f1b8603a0d36f18cd38
       received data dumped as job5.6.0.9728.received
       expected data dumped as job5.6.0.9728.expected
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
job0: Laying out IO file(s) (1000 file(s) / 4997MB)
job1: Laying out IO file(s) (1000 file(s) / 4921MB)
job2: Laying out IO file(s) (1000 file(s) / 5140MB)
job3: Laying out IO file(s) (1000 file(s) / 5086MB)
job4: Laying out IO file(s) (1000 file(s) / 4869MB)
job5: Laying out IO file(s) (1000 file(s) / 5106MB)
job6: Laying out IO file(s) (1000 file(s) / 4980MB)
job7: Laying out IO file(s) (1000 file(s) / 5052MB)
job8: Laying out IO file(s) (1000 file(s) / 5075MB)
job9: Laying out IO file(s) (1000 file(s) / 4964MB)
fio: pid=2684, got signal=6

job0: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2679
  read : io=2425.2MB, bw=139606 B/s, iops=9 , runt=18215098msec
    clat (usec): min=1 , max=1516.9K, avg=28821.71, stdev=53801.70
     lat (usec): min=1 , max=1516.9K, avg=28823.38, stdev=53801.36
    bw (KB/s) : min=    0, max= 1677, per=15058.66%, avg=150.59, stdev=127.61
  write: io=2422.1MB, bw=139478 B/s, iops=9 , runt=18215071msec
    clat (usec): min=12 , max=11509K, avg=74324.21, stdev=123810.94
     lat (usec): min=12 , max=11509K, avg=74324.85, stdev=123810.96
    bw (KB/s) : min=    0, max= 1541, per=14368.19%, avg=143.68, stdev=89.16
  cpu          : usr=0.08%, sys=0.21%, ctx=501180, majf=0, minf=4422
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=175461/175326/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.14%, 10=1.74%, 20=0.36%, 50=2.44%
     lat (usec): 100=0.51%, 250=0.05%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.32%, 4=6.40%, 10=24.17%, 20=19.52%, 50=18.35%
     lat (msec): 100=10.57%, 250=12.64%, 500=2.42%, 750=0.18%, 1000=0.07%
     lat (msec): 2000=0.08%, >=2000=0.01%
job1: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2680
  read : io=2390.2MB, bw=143712 B/s, iops=9 , runt=17445480msec
    clat (usec): min=0 , max=1511.4K, avg=26605.60, stdev=47176.79
     lat (usec): min=0 , max=1511.4K, avg=26606.23, stdev=47176.79
    bw (KB/s) : min=    0, max= 1196, per=15100.71%, avg=151.01, stdev=131.88
  write: io=2381.9MB, bw=143117 B/s, iops=9 , runt=17445461msec
    clat (usec): min=12 , max=7148.5K, avg=74260.28, stdev=108522.47
     lat (usec): min=13 , max=7148.5K, avg=74260.91, stdev=108522.49
    bw (KB/s) : min=    0, max= 1433, per=14424.66%, avg=144.25, stdev=93.19
  cpu          : usr=0.09%, sys=0.21%, ctx=477064, majf=0, minf=4373
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=173501/172436/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.11%, 10=1.46%, 20=0.29%, 50=2.16%
     lat (usec): 100=0.43%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.13%, 4=5.32%, 10=24.42%, 20=19.56%, 50=20.53%
     lat (msec): 100=10.76%, 250=12.49%, 500=2.01%, 750=0.15%, 1000=0.06%
     lat (msec): 2000=0.06%, >=2000=0.01%
job2: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2681
  read : io=2496.4MB, bw=148172 B/s, iops=10 , runt=17663792msec
    clat (usec): min=0 , max=1529.4K, avg=24625.57, stdev=43194.30
     lat (usec): min=0 , max=1529.4K, avg=24626.67, stdev=43194.32
    bw (KB/s) : min=    0, max= 1963, per=15564.69%, avg=155.65, stdev=138.00
  write: io=2501.8MB, bw=148471 B/s, iops=10 , runt=17663741msec
    clat (usec): min=12 , max=9705.8K, avg=72681.05, stdev=109065.67
     lat (usec): min=12 , max=9705.8K, avg=72681.67, stdev=109065.70
    bw (KB/s) : min=    0, max= 1326, per=14916.54%, avg=149.17, stdev=95.28
  cpu          : usr=0.09%, sys=0.22%, ctx=502065, majf=0, minf=4681
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=181669/181083/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.10%, 10=1.55%, 20=0.30%, 50=2.23%
     lat (usec): 100=0.43%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.11%, 4=4.99%, 10=25.09%, 20=20.24%, 50=20.70%
     lat (msec): 100=10.25%, 250=11.82%, 500=1.89%, 750=0.15%, 1000=0.05%
     lat (msec): 2000=0.05%, >=2000=0.01%
job3: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2682
  read : io=2462.5MB, bw=149508 B/s, iops=10 , runt=17270645msec
    clat (usec): min=0 , max=1512.6K, avg=24019.27, stdev=41028.90
     lat (usec): min=0 , max=1512.6K, avg=24019.92, stdev=41028.95
    bw (KB/s) : min=    0, max= 1765, per=15659.51%, avg=156.60, stdev=138.16
  write: io=2471.4MB, bw=150044 B/s, iops=10 , runt=17270600msec
    clat (usec): min=10 , max=8980.6K, avg=72398.80, stdev=104022.76
     lat (usec): min=10 , max=8980.6K, avg=72399.45, stdev=104022.79
    bw (KB/s) : min=    0, max= 1419, per=15025.37%, avg=150.25, stdev=95.46
  cpu          : usr=0.09%, sys=0.22%, ctx=496947, majf=0, minf=4580
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=178605/178801/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.10%, 10=1.47%, 20=0.28%, 50=2.21%
     lat (usec): 100=0.41%, 250=0.05%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.11%, 4=4.93%, 10=24.98%, 20=20.44%, 50=20.99%
     lat (msec): 100=10.23%, 250=11.73%, 500=1.82%, 750=0.14%, 1000=0.05%
     lat (msec): 2000=0.04%, >=2000=0.01%
job4: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2683
  read : io=2358.7MB, bw=150618 B/s, iops=10 , runt=16416381msec
    clat (usec): min=0 , max=1512.5K, avg=23370.23, stdev=38338.33
     lat (usec): min=0 , max=1512.5K, avg=23371.36, stdev=38339.09
    bw (KB/s) : min=    0, max= 1343, per=15690.18%, avg=156.90, stdev=133.97
  write: io=2370.1MB, bw=151442 B/s, iops=10 , runt=16416264msec
    clat (usec): min=12 , max=9559.6K, avg=72489.79, stdev=102465.13
     lat (usec): min=12 , max=9559.6K, avg=72490.44, stdev=102465.16
    bw (KB/s) : min=    0, max= 1207, per=15094.32%, avg=150.94, stdev=90.87
  cpu          : usr=0.09%, sys=0.23%, ctx=474742, majf=5, minf=4304
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=170943/171046/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.10%, 10=1.56%, 20=0.29%, 50=2.28%
     lat (usec): 100=0.45%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.11%, 4=5.02%, 10=24.92%, 20=20.54%, 50=20.89%
     lat (msec): 100=9.98%, 250=11.82%, 500=1.79%, 750=0.13%, 1000=0.04%
     lat (msec): 2000=0.03%, >=2000=0.01%
job5: (groupid=0, jobs=1): err= 0: pid=2684
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=178658/178373/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.11%, 10=1.54%, 20=0.30%, 50=2.20%
     lat (usec): 100=0.44%, 250=0.05%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.10%, 4=4.72%, 10=24.58%, 20=20.33%, 50=21.37%
     lat (msec): 100=10.26%, 250=11.86%, 500=1.91%, 750=0.15%, 1000=0.04%
     lat (msec): 2000=0.04%, >=2000=0.01%
job6: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2685
  read : io=2405.8MB, bw=145560 B/s, iops=10 , runt=17325411msec
    clat (usec): min=0 , max=1509.8K, avg=23944.81, stdev=40459.55
     lat (usec): min=0 , max=1509.8K, avg=23946.23, stdev=40460.22
    bw (KB/s) : min=    0, max= 1287, per=15327.71%, avg=153.28, stdev=124.51
  write: io=2422.9MB, bw=146636 B/s, iops=10 , runt=17325313msec
    clat (usec): min=10 , max=155338K, avg=75211.59, stdev=387812.27
     lat (usec): min=10 , max=155338K, avg=75212.22, stdev=387812.28
    bw (KB/s) : min=    0, max= 1122, per=14759.86%, avg=147.60, stdev=76.71
  cpu          : usr=0.09%, sys=0.22%, ctx=480817, majf=0, minf=4501
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=173670/174837/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.12%, 10=1.54%, 20=0.31%, 50=2.25%
     lat (usec): 100=0.41%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.10%, 4=4.86%, 10=24.85%, 20=20.37%, 50=20.73%
     lat (msec): 100=10.16%, 250=12.04%, 500=1.96%, 750=0.14%, 1000=0.04%
     lat (msec): 2000=0.04%, >=2000=0.01%
job7: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2686
  read : io=2461.8MB, bw=147350 B/s, iops=10 , runt=17517920msec
    clat (usec): min=0 , max=1509.7K, avg=24600.73, stdev=41725.53
     lat (usec): min=0 , max=1509.7K, avg=24601.50, stdev=41725.56
    bw (KB/s) : min=    0, max= 1520, per=15458.08%, avg=154.58, stdev=125.61
  write: io=2441.5MB, bw=146135 B/s, iops=10 , runt=17517870msec
    clat (usec): min=12 , max=85757K, avg=74337.25, stdev=230850.35
     lat (usec): min=12 , max=85757K, avg=74337.88, stdev=230850.36
    bw (KB/s) : min=    0, max= 1091, per=14685.98%, avg=146.86, stdev=80.26
  cpu          : usr=0.09%, sys=0.22%, ctx=489164, majf=0, minf=4543
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=177574/176604/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.11%, 10=1.53%, 20=0.31%, 50=2.23%
     lat (usec): 100=0.43%, 250=0.04%, 500=0.01%, 1000=0.01%
     lat (msec): 2=0.12%, 4=4.97%, 10=25.11%, 20=20.07%, 50=20.59%
     lat (msec): 100=10.26%, 250=11.97%, 500=1.98%, 750=0.15%, 1000=0.04%
     lat (msec): 2000=0.04%, >=2000=0.01%
job8: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2687
  read : io=2470.9MB, bw=145841 B/s, iops=10 , runt=17764551msec
    clat (usec): min=0 , max=1510.6K, avg=26085.23, stdev=45212.81
     lat (usec): min=1 , max=1510.6K, avg=26086.16, stdev=45212.74
    bw (KB/s) : min=    0, max= 1164, per=15345.15%, avg=153.45, stdev=123.91
  write: io=2451.2MB, bw=144674 B/s, iops=10 , runt=17764524msec
    clat (usec): min=10 , max=9094.4K, avg=73556.38, stdev=110604.39
     lat (usec): min=10 , max=9094.4K, avg=73557.01, stdev=110604.42
    bw (KB/s) : min=    0, max= 1048, per=14543.02%, avg=145.43, stdev=82.24
  cpu          : usr=0.09%, sys=0.22%, ctx=493970, majf=0, minf=4589
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=178703/177873/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.10%, 10=1.53%, 20=0.30%, 50=2.20%
     lat (usec): 100=0.42%, 250=0.04%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.12%, 4=5.28%, 10=24.60%, 20=19.86%, 50=20.38%
     lat (msec): 100=10.68%, 250=12.16%, 500=2.02%, 750=0.16%, 1000=0.05%
     lat (msec): 2000=0.06%, >=2000=0.01%
job9: (groupid=0, jobs=1): err=84 (file:io_u.c:1425,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2688
  read : io=2403.8MB, bw=138958 B/s, iops=9 , runt=18138650msec
    clat (usec): min=0 , max=1513.3K, avg=28563.33, stdev=51247.73
     lat (usec): min=1 , max=1513.3K, avg=28564.82, stdev=51247.66
    bw (KB/s) : min=    0, max= 1285, per=14877.37%, avg=148.77, stdev=121.79
  write: io=2410.7MB, bw=139357 B/s, iops=9 , runt=18138607msec
    clat (usec): min=10 , max=139931K, avg=75209.33, stdev=353297.66
     lat (usec): min=10 , max=139931K, avg=75209.97, stdev=353297.67
    bw (KB/s) : min=    0, max= 1367, per=14277.24%, avg=142.77, stdev=82.35
  cpu          : usr=0.09%, sys=0.21%, ctx=496079, majf=0, minf=4532
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=174228/174718/0, short=0/0/0
     lat (usec): 2=0.01%, 4=0.14%, 10=1.66%, 20=0.31%, 50=2.41%
     lat (usec): 100=0.52%, 250=0.06%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.18%, 4=5.65%, 10=23.90%, 20=20.28%, 50=18.80%
     lat (msec): 100=10.73%, 250=12.63%, 500=2.39%, 750=0.17%, 1000=0.07%
     lat (msec): 2000=0.08%, >=2000=0.01%

Run status group 0 (all jobs):
   READ: io=21874MB, aggrb=1KB/s, minb=0KB/s, maxb=150KB/s,
mint=16416381msec, maxt=17694821418msec
  WRITE: io=21873MB, aggrb=1KB/s, minb=0KB/s, maxb=151KB/s,
mint=16416264msec, maxt=17694821418msec
fio: file hash not empty on exit

Thanks,
Alex.



On Tue, Jun 26, 2012 at 10:39 AM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi Josef,
> Mount options were noatime, nodatacow.
> So you say that fio might have received ENOSPC, but didn't abort the test?
>
> I will compile your branch and let you know.
>
> I did not see any error messages from the kernel, except from:
> Jun 25 10:04:28 vc kernel: [  436.730890] btrfs: setting nodatacow
> Jun 25 10:04:28 vc kernel: [  436.744139] btrfs: no dev_stats entry
> found for device /dev/sdb2 (devid 1) (OK on first mount after mkfs)
> Jun 25 10:13:12 vc kernel: [  960.844149] INFO: task
> flush-btrfs-2:3349 blocked for more than 120 seconds.
> Jun 25 10:13:12 vc kernel: [  960.846600] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jun 25 10:13:12 vc kernel: [  960.847507] flush-btrfs-2   D
> ffffffff8180ca80     0  3349      2 0x00000000
> Jun 25 10:13:12 vc kernel: [  960.847515]  ffff8801186337a0
> 0000000000000046 0000000013e332ba ffffffff81c1d780
> Jun 25 10:13:12 vc kernel: [  960.847520]  ffff880118633fd8
> ffff880118633fd8 ffff880118633fd8 0000000000013840
> Jun 25 10:13:12 vc kernel: [  960.847525]  ffffffff81c13020
> ffff8801176f5b80 ffff880118633790 ffff88011fc140e8
> Jun 25 10:13:12 vc kernel: [  960.847530] Call Trace:
> Jun 25 10:13:12 vc kernel: [  960.847554]  [<ffffffff8166c239>]
> schedule+0x29/0x70
> Jun 25 10:13:12 vc kernel: [  960.847558]  [<ffffffff8166c30f>]
> io_schedule+0x8f/0xd0
> Jun 25 10:13:12 vc kernel: [  960.847574]  [<ffffffff812f0a3f>]
> get_request_wait+0xef/0x240
> Jun 25 10:13:12 vc kernel: [  960.847587]  [<ffffffff81073a80>] ?
> add_wait_queue+0x60/0x60
> Jun 25 10:13:12 vc kernel: [  960.847592]  [<ffffffff812f191f>]
> blk_queue_bio+0x7f/0x3a0
> Jun 25 10:13:12 vc kernel: [  960.847596]  [<ffffffff812ee784>]
> generic_make_request.part.50+0x74/0xb0
> Jun 25 10:13:12 vc kernel: [  960.847600]  [<ffffffff812eef18>]
> generic_make_request+0x68/0x70
> Jun 25 10:13:12 vc kernel: [  960.847603]  [<ffffffff812eefa7>]
> submit_bio+0x87/0x110
> Jun 25 10:13:12 vc kernel: [  960.847649]  [<ffffffffa006f8c7>]
> btrfs_map_bio+0x167/0x210 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847669]  [<ffffffffa00428ad>]
> btrfs_submit_bio_hook+0x7d/0x140 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847691]  [<ffffffffa00609fa>]
> submit_one_bio+0x6a/0xa0 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847713]  [<ffffffffa0061059>]
> flush_epd_write_bio+0x39/0x50 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847734]  [<ffffffffa00662c0>]
> extent_writepages+0x50/0x60 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847754]  [<ffffffffa0045ba0>] ?
> btrfs_submit_direct+0x1e0/0x1e0 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847759]  [<ffffffff81073654>] ?
> bit_waitqueue+0x14/0xc0
> Jun 25 10:13:12 vc kernel: [  960.847779]  [<ffffffffa00436d8>]
> btrfs_writepages+0x28/0x30 [btrfs]
> Jun 25 10:13:12 vc kernel: [  960.847793]  [<ffffffff81128191>]
> do_writepages+0x21/0x40
> Jun 25 10:13:12 vc kernel: [  960.847805]  [<ffffffff811a5462>]
> writeback_single_inode+0x112/0x380
> Jun 25 10:13:12 vc kernel: [  960.847809]  [<ffffffff811a5886>]
> writeback_sb_inodes+0x1b6/0x270
> Jun 25 10:13:12 vc kernel: [  960.847813]  [<ffffffff811a59de>]
> __writeback_inodes_wb+0x9e/0xd0
> Jun 25 10:13:12 vc kernel: [  960.847816]  [<ffffffff811a5c9b>]
> wb_writeback+0x28b/0x340
> Jun 25 10:13:12 vc kernel: [  960.847823]  [<ffffffff810125c7>] ?
> __switch_to+0x137/0x410
> Jun 25 10:13:12 vc kernel: [  960.847833]  [<ffffffff81197d02>] ?
> get_nr_dirty_inodes+0x52/0x80
> Jun 25 10:13:12 vc kernel: [  960.847837]  [<ffffffff811a5def>]
> wb_check_old_data_flush+0x9f/0xb0
> Jun 25 10:13:12 vc kernel: [  960.847842]  [<ffffffff811a72c9>]
> wb_do_writeback+0x149/0x1d0
> Jun 25 10:13:12 vc kernel: [  960.847848]  [<ffffffff8105f610>] ?
> usleep_range+0x50/0x50
> Jun 25 10:13:12 vc kernel: [  960.847852]  [<ffffffff811a73db>]
> bdi_writeback_thread+0x8b/0x290
> Jun 25 10:13:12 vc kernel: [  960.847855]  [<ffffffff811a7350>] ?
> wb_do_writeback+0x1d0/0x1d0
> Jun 25 10:13:12 vc kernel: [  960.847860]  [<ffffffff81072fe3>]
> kthread+0x93/0xa0
> Jun 25 10:13:12 vc kernel: [  960.847868]  [<ffffffff81676be4>]
> kernel_thread_helper+0x4/0x10
> Jun 25 10:13:12 vc kernel: [  960.847873]  [<ffffffff81072f50>] ?
> kthread_freezable_should_stop+0x70/0x70
> Jun 25 10:13:12 vc kernel: [  960.847877]  [<ffffffff81676be0>] ?
> gs_change+0x13/0x13
>
> Thanks,
> Alex.
>
>
>
> On Mon, Jun 25, 2012 at 10:26 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> On Mon, Jun 25, 2012 at 12:30:34PM -0600, Alex Lyakas wrote:
>>> Greetings everybody,
>>>
>>> I am running a fio test on btrfs compiled from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git,
>>> up to commit:
>>> cb77fcd88569cd2b7b25ecd4086ea932a53be9b3 Btrfs: delay iput with async extents
>>> including this commit.
>>>
>>> Below is a fio configuration file, and later fio textual output.
>>> Here:
>>> https://docs.google.com/folder/d/0B1AuaIB8xZtbNTRuSW1zVGozWFE/edit
>>> are "expected" vs "received" mismatch reports. Strangely, when I read
>>> the mismatched block from the file reported as corrupted by fio, I
>>> receive data different both from "expected" and "received" blocks that
>>> fio reports. I added one such file (job0.1.0.88576.now) to the
>>> pastebin as well.
>>>
>>> If you think that my fio configuration file is faulty, please let me
>>> know. fio version is 1.59. The idea is to run 10 io processes in
>>> parallel.
>>>
>>
>> So we think it may be enospc, so try btrfs-next
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>>
>> which has an enospc fix related to creating a crapptone of files.  Let me know
>> if that helps.  Thanks,
>>
>> Josef
