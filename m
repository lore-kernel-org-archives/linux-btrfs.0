Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63169 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDILAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 07:00:15 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so1694867eek.25
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 04:00:14 -0700 (PDT)
Received: from honzk.localnet (nat-11.starnet.cz. [178.255.168.11])
        by mx.google.com with ESMTPSA id 48sm1541147eee.2.2014.04.09.04.00.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 09 Apr 2014 04:00:14 -0700 (PDT)
From: Jan Kouba <kouba.honza@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Unable to remove read-only seeding device from a filesystem.
Date: Wed, 09 Apr 2014 13:00:13 +0200
Message-ID: <1718136.Ye2ZxOq3uC@honzk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running this script:

dd if=/dev/zero of=seed-disk.img bs=1M seek=1k count=0
dd if=/dev/zero of=test-disk.img bs=1M seek=1k count=0

# Make image of seed device
mkfs.btrfs seed-disk.img
seed_dev=`losetup -f --show seed-disk.img`
mount $seed_dev /mnt/tmp
touch /mnt/tmp/a
umount /mnt/tmp
losetup -d $seed_dev
btrfstune -S 1 seed-disk.img

# Make read-only seed device
seed_dev=`losetup -f -r --show seed-disk.img`

test_dev=`losetup -f --show test-disk.img`

mount $seed_dev /mnt/tmp
btrfs dev add $test_dev /mnt/tmp
mount -o remount,rw /mnt/tmp

# This fails
btrfs dev delete $seed_dev /mnt/tmp

# cleanup
umount /mnt/tmp
losetup -d $seed_dev
losetup -d $test_dev

rm seed-disk.img
rm test-disk.img




the command 
"btrfs dev delete $seed_dev /mnt/tmp" fails with 
"ERROR: error removing the device '/dev/loop0' - Permission denied" message.

If /dev/loop0 is not read-only everything works. 

I tested this on ubuntu 13.10, 14.04 with stock kernel and btrfs-progs and on 
ubuntu 14.04 with latest PPA kernel (3.14.0-031400-generic) and v3.14 btrfs-
progs.

Is this behaviour expected or is it a bug? 

I thougt that btrfs never changes seeding devices, so I don't understand, why 
it needs to be writeable in order to remove it from a filesystem.


Jan Kouba





