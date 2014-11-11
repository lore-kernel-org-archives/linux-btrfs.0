Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ble59-2-81-56-123-40.fbx.proxad.net ([81.56.123.40]:37164 "EHLO
	jmuchemb.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaKKVF5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 16:05:57 -0500
Message-ID: <54627A33.90202@jmuchemb.eu>
Date: Tue, 11 Nov 2014 22:05:55 +0100
From: Julien Muchembled <jm@jmuchemb.eu>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel >= 3.16 saturates I/O endlessly and without reason
References: <54626D23.20701@jmuchemb.eu> <1415737858.25389.0@mail.thefacebook.com>
In-Reply-To: <1415737858.25389.0@mail.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/11/14 21:30, Chris Mason a écrit :
> On Tue, Nov 11, 2014 at 3:10 PM, Julien Muchembled <jm@jmuchemb.eu> wrote:
>> I upgraded my kernel from 3.15.10 to 3.17.2 and after a while, btrfs kworkers started to read/write data at maximum speed for hours whereas I was doing nothing. So I rebooted with kernel 3.15.10 and hopefully everything went back to normal. Later attempts to upgrade to 3.16.7 or 3.17.2 showed the same issue, immediately at boot or after a while.
>>
>> In order to investigate a little, I copied the partition and mounted it in qemu (snapshot mode, with cow file in tmpfs, debian kernel 3.16.7-2). I could see that btrfs always wrote the same ~8MB in loop. qemu used all cpu and when I stopped it, it wrote 190G and the generation number raised from 625955 to 853922.
>>
>> I dumped the FS with btrfs-image. The restored FS has the same issue so I can send the image (78M) to anyone who would like to debug.
> 
> Which mount options are you using?  This sounds like something in autodefrag...

I've never used autodefrag.
In qemu, I did:

  mount -t btrfs -o noatime /dev/sda /mnt/sda
