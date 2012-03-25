From: Daniel J Blueman <daniel@quora.org>
Subject: attempt to access beyond end of device and livelock
Date: Sun, 25 Mar 2012 21:40:37 +0800
Message-ID: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Li Dongyang <lidongyang@novell.com>,
	Zheng Yan <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dongyang, Yan,

When testing BTRFS with RAID 0 metadata on linux-3.3, we see discard
ranges exceeding the end of the block device [1], potentially causing
dataloss; when this occurs, filesystem writeback becomes catatonic due
to continual resubmission.

The reproducer is quite simple [2]. Hope this proves useful...

Thanks,
  Daniel

--- [1]

attempt to access beyond end of device
ram0: rw=129, want=8452072, limit=4096000
...

--- [2]

modprobe brd rd_size=2048000 (or boot with ramdisk_size=2048000)
mkfs.btrfs -m raid0 /dev/ram0 /dev/ram1
mount /dev/ram0 /mnt -o discard
fio testcase
umount /mnt

--- [3] testcase

[global]
directory=/mnt
rw=randread
size=256m
ioengine=libaio
iodepth=4
invalidate=1
direct=1

[bgwriter]
rw=randwrite
iodepth=32

[queryA]
iodepth=1
ioengine=mmap
thinktime=3

[queryB]
iodepth=1
ioengine=mmap
thinktime=1

[bgupdater]
rw=randrw
iodepth=16
thinktime=1
size=32m
-- 
Daniel J Blueman
