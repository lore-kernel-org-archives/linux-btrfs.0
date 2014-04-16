Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:40918 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161205AbaDPN17 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:27:59 -0400
Received: by mail-qa0-f48.google.com with SMTP id s7so10129110qap.35
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:27:58 -0700 (PDT)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Wed, 16 Apr 2014 15:27:38 +0200
Message-ID: <CAEx9m44NE7sFAcOdPMc=mhye=hkhLgVMfmu_mbP4wzp_bGh_rA@mail.gmail.com>
Subject: How do I find the physical block number?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have created a 500GB partition on my HDD and formatted it for btrfs.
I created a file on it.
# echo "tmp data in the tmp file.." > /mnt/btrfs/tmp-file
# umount /mnt/btrfs

Next I want to know the blocks allocated for the file and I used
filefrag for it. I get some information as follows -

# mount -o max_inline=0 /dev/sdc2 /mnt/btrfs
# filefrag -v /mnt/btrfs/tmp-file
Filesystem type is: 9123683e
File size of /mnt/btrfs/tmp-file is 27 (1 block, blocksize 4096)
 ext logical physical expected length flags
   0       0 65924123               1 eof
/mnt/btrfs/tmp-file: 1 extent found

Now, I want to read the same data from the disk directly. I tried the
following -

block 65924123 = byte (65924123*4096) = 270025207808

# dd if=/dev/sdc2 of=tmp-file skip=270025207808 bs=1 count=4096
# cat tmp-file
I cannot read the file's contents but some garbage.

I read somewhere that the physical block number shown in filefrag may
actually be a logical block for the file system and it has an
additional translation to physical block number. So next I tried the
following -

# btrfs-map-logical -l 65924123 /dev/sdc2
mirror 1 logical 65924123 physical 74312731 device /dev/sdc2
mirror 2 logical 65924123 physical 1148054555 device /dev/sdc2

I again tried reading the block 74312731 using the dd command as
above, but it is still not the right block.

I want to know what does the physical block number returned by
filefrag mean, why there are two mappings for the above block number
and how I can find the exact physical disk block number the file
system actually writes to.

My sdc has the following partitions:
   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   419432447   209715200   83  Linux
/dev/sdc2      1468008448  2516584447   524288000   83  Linux (BTRFS)
/dev/sdc3       419432448  1468008447   524288000   83  Linux

Thanks,
Aastha.
