From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 12:00:00 +0200
Message-ID: <C8TEkB+PCXB@helmut.hullen.de>
References: <CAG1y0sfCN8qJ2hra0pu2H1HnsrwPNdWi=YG+nCDWAaJWT9e8oQ@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfCN8qJ2hra0pu2H1HnsrwPNdWi=YG+nCDWAaJWT9e8oQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Fajar,

Du meintest am 08.05.12:

>>> And you can use three BTRFS filesystems the same way as three Ext4
>>> filesystems if you prefer such a setup if the time spent for
>>> restoring the backup does not make up the cost for one additional
>>> disk for you.
>>
>> But where's the gain? If a disk fails I have a lot of tools for
>> repairing an ext2/3/4 system.

> It won't work if you use it in RAID0 (e.g. with LVM spanning three
> disks, then use ext4 on top of the LV).

But when I use ext2/3/4 I neither need RAID0 nor do I need LVM.

> As others said, if your only concern is "if a disk is dead, I want to
> be able to access data on other disks", then simply use btrfs as
> three different fs, mounted on three directories.

But then I don't need especially btrfs.

> btrfs will shine when:
> - you need checksum and self-healing in raid10 mode
> - you have lots of small files
> - you have highly compressible content
> - you need snapshot/clone feature

For my video collection (mpeg2) nothing fits ...

The only advantage I see with btrfs is

        adding a bigger disk
        deleting/removing a smaller disk

with really simple commands.

Viele Gruesse!
Helmut
