Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from erza.pados.hu ([176.9.136.194]:49318 "EHLO erza.pados.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751905AbdCWOgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 10:36:46 -0400
Received: from localhost ([127.0.0.1] helo=webmail.pados.hu)
        by erza with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.88)
        (envelope-from <pados@pados.hu>)
        id 1cr3On-0005F8-UB
        for linux-btrfs@vger.kernel.org; Thu, 23 Mar 2017 15:07:34 +0100
Mime-Version: 1.0
Date: Thu, 23 Mar 2017 14:07:31 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <63b13b68a616abf8f828d6725f792be4@webmail.pados.hu>
From: "=?utf-8?B?S8Ohcm9seSBQYWRvcw==?=" <pados@pados.hu>
Subject: Bug: btrfs dev del missing fails where it shouldn't
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: Trying to remove a missing device tells me there are no missing devices, but obviously there is one
kernel: 4.9.13
btrfs-progs: 4.9.1

Steps to reproduce:

1) Create a raid1 array:

mkfs.btrfs -f -d raid1 -m raid1 /dev/sda /dev/sdb
mkdir /mnt/volatile
mount -t btrfs /dev/sda /mnt/volatile

2) Physically remove a device or simply issue:

echo 1 > /sys/block/sdb/device/delete

3) In preparation to remove the failed device, remount and rebalance:

mount -t btrfs -o remount,degraded /dev/sda /mnt/volatile
btrfs balance start -dconvert=single -mconvert=dup /mnt/volatile

4) Obviously the array still has a missing device, check this:

btrfs fi show
Label: none  uuid: 55fa0da0-26b5-4a66-ba54-e9488e47cf6e
        Total devices 2 FS bytes used 320.00KiB
        devid    1 size 3.74GiB used 896.00MiB path /dev/sda
        *** Some devices missing

5) Try to remove missing device and see the error:

btrfs dev del missing /mnt/volatile
ERROR: error removing device 'missing': no missing devices found to remove


Step 5) failed and can be replaced by:

btrfs dev del 2 /mnt/volatile/
[  402.828294] BTRFS info (device sdb): device deleted: id 2
btrfs fi show
Label: none  uuid: 55fa0da0-26b5-4a66-ba54-e9488e47cf6e
        Total devices 1 FS bytes used 320.00KiB
        devid    1 size 3.74GiB used 896.00MiB path /dev/sda

Still, 'missing' should be working, and having to use the devid is a PITA for both humans and scripts (the reason why 'missing' was added in the first place).


(Probably unrelated question: In the last btrfs fi show you can see 896MB is used on a 3.74GB filesystem. The filesystem was just created however as described in the above steps, it is 100% empty with no prior use or wear. So the brand-new formatted drive seems to be 23% full, is this normal?)
