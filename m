Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53902 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVWAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 18:00:48 -0400
Message-ID: <53F7BD8E.10308@floga.de>
Date: Sat, 23 Aug 2014 00:00:46 +0200
From: =?ISO-8859-15?Q?Florian_Gamb=F6ck?= <mail@floga.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: superblock checksum mismatch after crash, cannot mount
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I think i just crashed my btrfs partition, is someone willing to guide 
me through the recovery steps?

The "crash" went like so: I was testing the watchdog ability of my 
Raspberry Pi, whose root filesystem is btrfs. To test if the watchdog 
works I started a fork bomb. Normally, the watchdog device would not be 
reset and the Pi restarts. My Pi actually shut down, but didn't start 
again. When inspecting the SD card in another computer, i could not 
mount the btrfs partition. The dmesg keeps saying:

BTRFS: device label RASPIROOT devid 1 transid 18320 /dev/sdf3
BTRFS: superblock checksum mismatch
BTRFS: open_ctree failed

When trying to mount in recovery mode, it says:

$ LANG=en_US sudo mount -t btrfs -o recovery,ro /dev/sdf3 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/sdf3,
        missing codepage or helper program, or other error

I also wanted to create a btrfs-image, but it went like:

checksum verify failed on 65536 found DFE4B1C4 wanted 712D0238
checksum verify failed on 65536 found DFE4B1C4 wanted 712D0238
Csum didn't match
Error reading metadata block
Error adding block -5
checksum verify failed on 65536 found DFE4B1C4 wanted 712D0238
checksum verify failed on 65536 found DFE4B1C4 wanted 712D0238
Csum didn't match
Error reading metadata block
Error flushing pending -5
create failed (Success)

Do you have any advice, how I can get the partition up running? Of 
course I do have backups and it would be a matter of minutes to reset 
the whole card, but I want to know the "btrfs like" way to repair the 
partition.

--
Best wishes
FloGa
