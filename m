From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 14:40:06 -0700
Message-ID: <201105051440.07434.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105051332.20992.CACook@quantum-sci.com> <BANLkTim3uMUXN7Q=zqXoopUeR8gphWHi_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTim3uMUXN7Q=zqXoopUeR8gphWHi_Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 5 May, 2011 13:40:25 cwillu wrote:
> Could you include the information I asked for previously?  (Kernel
> version, output of btrfs fi df and btrfs fi show)

Kernel 2.6.37-2
# btrfs fi df /home
Data, RAID0: total=2.61TB, used=2.47TB
Data: total=8.00MB, used=8.00MB
System, RAID1: total=8.00MB, used=196.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=6.88GB, used=4.64GB
Metadata: total=8.00MB, used=0.00
# df /dev/sdb
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb             3907029168 2659716272 1242565920  69% /home
# df /dev/sdc
Filesystem           1K-blocks      Used Available Use% Mounted on
udev                   1895384       268   1895116   1% /dev
(this doesn't make any sense)
# btrfs fi show
failed to read /dev/sdg
failed to read /dev/sdf
failed to read /dev/sde
failed to read /dev/sdd
failed to read /dev/sr0
Label: none  uuid: 85537aa8-30dc-4f87-ac55-6c8344304184
        Total devices 2 FS bytes used 2.47TB
        devid    1 size 1.82TB used 1.31TB path /dev/sdb
        devid    2 size 1.82TB used 1.31TB path /dev/sdc
Btrfs Btrfs v0.19

 
> Defrag is not the same as balancing, and neither is quite the same as
> the balancing of the internal b-trees that make up the filesystem.

I know they're not the same.  But I am asking:

I thought balancing was supposed to be automatic in BTRFS?  

Is defrag not automatic?

No idea what 'balancing of the internal b-trees' is.



