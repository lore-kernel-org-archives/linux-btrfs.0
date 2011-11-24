From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: btrfs encryption problems
Date: Thu, 24 Nov 2011 16:54:29 -0500
Message-ID: <20111124165429.10496040@Bidule>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
	<20111123110956.GB31800@attic.humilis.net>
	<CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
	<20111124160617.680b676f@zougloub.eu>
	<CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org
To: 810d4rk <810d4rk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 24 Nov 2011 21:43:50 +0000
810d4rk <810d4rk@gmail.com> wrote:

> > These printks indicate that the encryption or password is not the same as used when creating the device.
> > So at this stage, this has nothing to do with btrfs.
> 
> No, Ive decrypted the volume with the password, I can confirm it and
> also I haven't change it, BTW I have some new output from the kernel
> when trying to mount it:
>
> [21754.913248] usb 2-1.1: new high speed USB device number 20 using ehci_hcd
> [21755.119495] scsi45 : usb-storage 2-1.1:1.0
> [21757.616505] scsi 45:0:0:0: Direct-Access     WDC WD75
> 00BPVT-22HXZT1   01.0 PQ: 0 ANSI: 5
> [21757.633275] sd 45:0:0:0: Attached scsi generic sg4 type 0
> [21757.634765] sd 45:0:0:0: [sdc] 1465149168 512-byte logical blocks:
> (750 GB/698 GiB)
> [21757.635789] sd 45:0:0:0: [sdc] Write Protect is off
> [21757.635798] sd 45:0:0:0: [sdc] Mode Sense: 43 00 00 00
> [21757.637434] sd 45:0:0:0: [sdc] Write cache: disabled, read cache:
> enabled, doesn't support DPO or FUA
> [21757.727481]  sdc: sdc1
> [21757.730497] sd 45:0:0:0: [sdc] Attached SCSI disk
> [21757.737422] sd 45:0:0:0: [sdc]  Sense Key : Recovered Error
> [current] [descriptor]
> [21757.737438] Descriptor sense data with sense descriptors (in hex):
> [21757.737443]         72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 57 00
> [21757.737462]         00 00 00 00 00 50
> [21757.737472] sd 45:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d
> [21757.868565] sd 45:0:0:0: [sdc]  Sense Key : Recovered Error
> [current] [descriptor]
> [21757.868580] Descriptor sense data with sense descriptors (in hex):
> [21757.868585]         72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [21757.868604]         00 00 00 00 00 50
> [21757.868614] sd 45:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d
> [21777.246960] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
> [21777.283216] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
> [21777.338992] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem
> [21777.456509] REISERFS warning (device dm-1): sh-2021
> reiserfs_fill_super: can not find reiserfs on dm-1
> [21777.503417] XFS (dm-1): bad magic number
> [21777.503428] XFS (dm-1): SB validate failed
> [21777.622915] FAT-fs (dm-1): bogus number of reserved sectors
> [21777.622926] FAT-fs (dm-1): Can't find a valid FAT filesystem
> [21777.663109] FAT-fs (dm-1): bogus number of reserved sectors
> [21777.663120] FAT-fs (dm-1): Can't find a valid FAT filesystem

My mistake, the same printks are printed when the encryption key is incorrect, I've seen that here.
It looks like you have some ugly hardware errors.
The kernel cannot read from the drive, so it cannot guess the file system on it.
If the data is valuable, you could try to ddrescue the drive to a bigger one.
 (>750GB... and that will take time...) and attempt to mount the rescued data.
If the drive is in an USB enclosure, you could plug it directly via SATA to the system (maybe it has issues?).


++
-- 
cJ
