Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3BDVz4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 16:55:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <chris.mason@fusionio.com>
Subject: Re: Oops when mounting btrfs partition
Date: Mon, 4 Feb 2013 21:55:50 +0000
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <4028366.UQxPtEU6If@wuerfel> <20130202152035.GA24264@shiny>
In-Reply-To: <20130202152035.GA24264@shiny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302042155.50977.arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 02 February 2013, Chris Mason wrote:

> > Feb  1 22:57:37 localhost kernel: [ 8561.599482] Kernel BUG at ffffffffa01fdcf7 [verbose debug info unavailable]
> 
> > Jan 14 19:18:42 localhost kernel: [1060055.746373] btrfs csum failed ino 15619835 off 454656 csum 2755731641 private 864823192
> > Jan 14 19:18:42 localhost kernel: [1060055.746381] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0
> > ...
> > Jan 21 16:35:40 localhost kernel: [1655047.701147] parent transid verify failed on 17006399488 wanted 54700 found 54764
> 
> These aren't good.  With a few exceptions for really tight races in fsx
> use cases, csum errors are bad data from the disk.  The transid verify
> failed shows we wanted to find a metadata block from generation 54700
> but found 54764 instead:
> 

I've done a full backup of all data now, without any further Ooops messages, but
I did get these:

[66155.429029] btrfs no csum found for inode 1212139 start 23707648
[66155.429035] btrfs no csum found for inode 1212139 start 23711744
[66155.429039] btrfs no csum found for inode 1212139 start 23715840
[66155.429042] btrfs no csum found for inode 1212139 start 23719936
[66155.452298] btrfs csum failed ino 1212139 off 23707648 csum 4112094897 private 0
[66155.452310] btrfs csum failed ino 1212139 off 23711744 csum 3308812742 private 0
[66155.452316] btrfs csum failed ino 1212139 off 23715840 csum 2566472073 private 0
[66155.452322] btrfs csum failed ino 1212139 off 23719936 csum 2290008602 private 0
[66159.876785] btrfs no csum found for inode 1212139 start 69992448
[66159.876792] btrfs no csum found for inode 1212139 start 69996544
[66159.876797] btrfs no csum found for inode 1212139 start 70000640
[66159.876801] btrfs no csum found for inode 1212139 start 70004736
[66159.921506] btrfs csum failed ino 1212139 off 69992448 csum 2290360822 private 0
[66159.921517] btrfs csum failed ino 1212139 off 69996544 csum 954182507 private 0
[66159.921524] btrfs csum failed ino 1212139 off 70000640 csum 2594579850 private 0
[66159.921532] btrfs csum failed ino 1212139 off 70004736 csum 25334750 private 0
[66932.289905] btrfs csum failed ino 2461761 off 94208 csum 3824674580 private 1950015541
[92042.101540] btrfs csum failed ino 687755 off 7048040448 csum 2502110259 private 2186199747
[110952.542245] btrfs csum failed ino 5423479 off 475136 csum 490948044 private 3797189576
[122692.216371] btrfs csum failed ino 7959218 off 2818048 csum 1904746846 private 2392844122
[138205.726897] btrfs: sdb1 checksum verify failed on 20495056896 wanted 8C9759CB found 9BFAB73B level 0

Inode 1212139 is the akonadi database that was used by kmail, so it constantly
got written to during the crashes. The file was completely corrupt. The
other inodes are mostly files that were backed up from the other machine
and have been on the drive I started using it, without ever being accessed.
I've probably had a few bit flips the entire time I was using the machine,
but never noticed before I started using a checksumming file system.

	Arnd
