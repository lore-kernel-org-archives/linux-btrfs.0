Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:34107 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaG2IEm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 04:04:42 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so8497352wes.20
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 01:04:40 -0700 (PDT)
MIME-Version: 1.0
From: Peter Waller <peter@scraperwiki.com>
Date: Tue, 29 Jul 2014 09:04:00 +0100
Message-ID: <CAFChkqszfFU51qkr1CSNgv0VKNhr8U_jEDv0_BPaZZghLzKojA@mail.gmail.com>
Subject: Machine lockup due to btrfs-transaction on AWS EC2 Ubuntu 14.04
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I've reported a bug with Ubuntu here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1349711

The machine in question has one BTRFS volume which is 87% full and
lives on an Logical Volume Manager (LVM) block device on top of one
Amazon Elastic Block Store (EBS) device.

We have other machines in a similar configuration which have not
displayed this behaviour.

The one thing which makes this machine different is that it has
directories which contain many thousands of files. We don't make heavy
use of subvolumes or snapshots.

More details follow:

# cat /proc/version_signature
Ubuntu 3.13.0-32.57-generic 3.13.11.4

The machine had a soft-lockup with messages like this appearing on the console:

[246736.752053] INFO: rcu_sched self-detected stall on CPU { 0}
(t=2220246 jiffies g=35399662 c=35399661 q=0)
[246736.756059] INFO: rcu_sched detected stalls on CPUs/tasks: { 0}
(detected by 1, t=2220247 jiffies, g=35399662, c=35399661, q=0)
[246764.192014] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u30:2:1828]
[246764.212058] BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:492]


After the first lockup and reboot, the following messages were in
dmesg, which I ignored because after some research I saw that they
were changed to warnings and considered non-harmful. A btrfs-scrub
performed after this failed without error:


[ 77.609490] BTRFS error (device dm-0): block group 10766778368 has
wrong amount of free space
[ 77.613678] BTRFS error (device dm-0): failed to load free space
cache for block group 10766778368
[ 77.643801] BTRFS error (device dm-0): block group 19356712960 has
wrong amount of free space
[ 77.648952] BTRFS error (device dm-0): failed to load free space
cache for block group 19356712960
[ 77.926325] BTRFS error (device dm-0): block group 20430454784 has
wrong amount of free space
[ 77.931078] BTRFS error (device dm-0): failed to load free space
cache for block group 20430454784
[ 78.111437] BTRFS error (device dm-0): block group 21504196608 has
wrong amount of free space
[ 78.116165] BTRFS error (device dm-0): failed to load free space
cache for block group 21504196608


After the second time I've observed the lockup and rebooted, these
messages have appeared:


[ 45.390221] BTRFS error (device dm-0): free space inode generation
(0) did not match free space cache generation (70012)
[ 45.413472] BTRFS error (device dm-0): free space inode generation
(0) did not match free space cache generation (70012)
[ 467.423961] BTRFS error (device dm-0): block group 518646661120 has
wrong amount of free space
[ 467.429251] BTRFS error (device dm-0): failed to load free space
cache for block group 518646661120


I would like to know if these second messages are harmful and if
remedial action is needed in response to the latter messages.
Searching for messages similar to my lockup I found this report which
suggested the problem may be fixed in 3.14.

Any advice appreciated,

Thanks,

- Peter
