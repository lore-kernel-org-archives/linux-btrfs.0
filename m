Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:32930 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3IANoP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 09:44:15 -0400
Received: by mail-wg0-f41.google.com with SMTP id b12so994100wgh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 06:44:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi76cVH5TskpE2-2P=9W3qTuiRW2LUZiEXAOAOVa1oUoPCA@mail.gmail.com>
References: <CAGqmi76cVH5TskpE2-2P=9W3qTuiRW2LUZiEXAOAOVa1oUoPCA@mail.gmail.com>
From: =?UTF-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>
Date: Sun, 1 Sep 2013 16:43:53 +0300
Message-ID: <CAGqmi74WTpkmwH=PsgiepVR6r5A6NuNmmGguJdAWh6j591AEUg@mail.gmail.com>
Subject: Re: Mixed blocks, he can avoid ENOSPACE error, when he can't
 allocated metadata blocks?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list, sorry for my bad english anyway.
if my message is  delirium, just ignore this message.
My question:
When using mixed blocks, metadata and data chunks has be merge, but we
have (when using mixed) speed penalty.
how many penalty will be have if we using mixed?

Kernel 3.11-rc7, Ubuntu 13.10 x64
my simple test:
#Mixed
sudo mkfs.btrfs -f -M /dev/sdb #sdb old seagate hdd 80G
sudo mount /dev/sdb /mnt
time sudo dd if=/dev/zero of=/mnt/zero bs=1M count=4096
~48.5s
time sudo rm /mnt/zero
~1.5s
sudo umount /mnt
---
#default setting
sudo mkfs.btrfs -f /dev/sdb
sudo mount /dev/sdb /mnt
time sudo dd if=/dev/zero of=/mnt/zero bs=1M count=4096
~48.5s
time sudo rm /mnt/zero
~1.5s
sudo umount /mnt
---
#raw write
time sudo dd if=/dev/zero of=/dev/sdb bs=1M count=4096
~59s

I don't see any different between mixed and defaults blocks.
So using mixed blocks have sense? Or this is outdated function?
Can i change in future type of chunk allocation between mixed and
default (with using balance function)?

i believe in mixed blocks because this function can awoid problems
with ENOSPACE error (when system can't allocated metadata chunk) and
can up space utilization on the disk.
On slow hdd, we no see any different between profiles, and on speed
ssd perfomance penalty should not be significant.

(i just using btrfs on my PC (1 TB hdd) and laptop (ssd 128 GB), i
like this fs and i haven't any problem
(Only enospace, but i just add temp drive and using balance to fix this)
and i just try optimizing fs).
