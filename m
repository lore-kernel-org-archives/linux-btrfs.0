From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 14:44:29 +0700
Message-ID: <CAG1y0sfCN8qJ2hra0pu2H1HnsrwPNdWi=YG+nCDWAaJWT9e8oQ@mail.gmail.com>
References: <201205080007.51704.Martin@lichtvoll.de>
	<C8TEDWt9CXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TEDWt9CXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 8, 2012 at 2:39 PM, Helmut Hullen <Hullen@t-online.de> wrote:

>> And you can use three BTRFS filesystems the same way as three Ext4
>> filesystems if you prefer such a setup if the time spent for
>> restoring the backup does not make up the cost for one additional
>> disk for you.
>
> But where's the gain? If a disk fails I have a lot of tools for
> repairing an ext2/3/4 system.

It won't work if you use it in RAID0 (e.g. with LVM spanning three
disks, then use ext4 on top of the LV). Which is basically the same
thing that you did (using btrfs in raid0 mode).

As others said, if your only concern is "if a disk is dead, I want to
be able to access data on other disks", then simply use btrfs as three
different fs, mounted on three directories.

btrfs will shine when:
- you need checksum and self-healing in raid10 mode
- you have lots of small files
- you have highly compressible content
- you need snapshot/clone feature

Since you don't need either, IMHO it's actually better if you just use ext4.

-- 
Fajar
