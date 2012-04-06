From: Daniel J Blueman <daniel@quora.org>
Subject: [3.4-rc1] attempt to access beyond end of device and livelock
Date: Fri, 6 Apr 2012 19:36:59 +0800
Message-ID: <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
References: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef, Chris,

When testing BTRFS with RAID 0 metadata on linux-3.4-rc1, we see
discard ranges exceeding the end of the block device [1], potentially
causing dataloss; when this occurs, filesystem writeback becomes
catatonic due to continual resubmission.

Simply mounting with discard a raid0 metadata filesystem and copying
some data in [2] provokes the issue.

Thanks,
=A0Daniel

--- [1]

attempt to access beyond end of device
ram0: rw=3D129, want=3D8452072, limit=3D4096000
=2E..

--- [2]

modprobe brd rd_size=3D2048000 (or boot with ramdisk_size=3D2048000)
mkfs.btrfs -m raid0 /dev/ram0 /dev/ram1
mount /dev/ram0 /mnt -o discard
cd /mnt && tar -xvzf linux.tar.gz
<access beyond end of device and livelock>
--=20
Daniel J Blueman
