Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0059.outbound.protection.outlook.com ([104.47.2.59]:10624
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751460AbdCHPRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 10:17:43 -0500
From: Luca Citi <lciti@essex.ac.uk>
To: <linux-btrfs@vger.kernel.org>
Subject: btrfs throws ENOSPC even on almost empty filesystem when using "cfq"
 scheduler
Message-ID: <7d2d26be-302d-6f88-4107-aa1414dcc233@essex.ac.uk>
Date: Wed, 8 Mar 2017 14:59:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a follow up from my previous bug report:
http://www.spinics.net/lists/linux-btrfs/msg62916.html

I think this is a serious bug in btrfs and should be investigated.
I have done some further progress trying to collect information that may 
help btrfs developers understand where the problem originates and 
hopefully find a fix.

To recap:

I create a new empty btrfs partition with plenty of space (45 GB) and I 
use rsync to transfer around 8 GB of data (files of a linux root 
filesystem with a range of sizes).
Every time I try this, after 2-3 GB of data have been copied, I receive 
ENOSPC (No space left on device) errors. The errors happen when the 
transferring program tries to rename some of the files that have already 
been copied. I observe this behaviour both using rsync (from ext4 to 
btrfs) and using btrfs send/receive (from btrfs to btrfs). From what I 
have observed, errors are not thrown when creating the new file but only 
when the file created with a bogus name is renamed into the proper file 
name (see example below).

After some test, I noticed that the errors appeared when using Kubuntu 
but not when using Ubuntu. To reduce the effect of possible confounders, 
I tried both installed systems and live iso (16.10 and 16.04.2) and 
ended up doing my all my tests booting into recovery mode down to root 
shell (adding the "recovery" option to the kernel invocation in Grub2). 
Even from this root shell (single user, no network, no X, no display 
managers, ...) it looked like the btrfs filesystem could not cope with 
the task of creating room for the files or for their metadata fast 
enough in Kubuntu.

After hours spent trying to pin down what difference between Kubuntu and 
Ubuntu could explain the different behaviour, I found that the scheduler 
is different:
kubuntu: noop deadline [cfq]
ubuntu: noop [deadline] cfq

Steps to reproduce the problem.

The following assumes /dev/sda5 is an empty partition with 45GB of space 
and /dev/sda6 is a partition with roughly 8 GB of files of different sizes.
The same problem applies to running distributions in multi-user mode but 
I am showing the steps to reproduce it in the most controlled 
environment (pristine system, single user, no X, ...).
Boot from Ubuntu or Kubuntu 16.04.2 Live ISO adding the "recovery" 
option to the kernel. At the recovery menu, choose "root".

Then type:

mkdir /mnt/5
mkdir /mnt/6
mount /dev/sda6/ /mnt/6

First test: "deadline" scheduler (should work)

echo deadline > /sys/block/sda/queue/scheduler

... then:

bash -c 'for i in $(seq 1 10); do
wipefs -a /dev/sda5
mkfs.btrfs /dev/sda5
mount -o subvolid=0 /dev/sda5 /mnt/5
rsync -a --stats --one-file-system /mnt/6 /mnt/5
umount /dev/sda5
done' 2>&1 | tee /tmp/rsync.log


Second test: "cfq" scheduler (should fail with ENOSPC)

echo cfq > /sys/block/sda/queue/scheduler

... then:

bash -c 'for i in $(seq 1 10); do
wipefs -a /dev/sda5
mkfs.btrfs /dev/sda5
mount -o subvolid=0 /dev/sda5 /mnt/5
rsync -a --stats --one-file-system /mnt/6 /mnt/5
umount /dev/sda5
done' 2>&1 | tee /tmp/rsync.log


This produces errors like:
ERROR: rename o85450-15-0 -> 
usr/share/icons/oxygen/base/64x64/actions/window-duplicate.png failed: 
No space left on device


I hope someone can look into this.
Please let me know if you need additional information or if you would 
like me to run further tests.
Thanks in advance for your help.

Best wishes,
Luca

