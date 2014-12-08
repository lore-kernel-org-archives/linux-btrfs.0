Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:46150 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbaLHRUM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Dec 2014 12:20:12 -0500
Message-ID: <5485DDC7.2080500@pobox.com>
Date: Mon, 08 Dec 2014 09:20:07 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Konstantin <newsbox1026@web.de>, Phillip Susi <psusi@ubuntu.com>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de>
In-Reply-To: <5484F198.3070206@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/07/2014 04:32 PM, Konstantin wrote:
> I know this and I'm using 0.9 on purpose. I need to boot from these
> disks so I can't use 1.2 format as the BIOS wouldn't recognize the
> partitions. Having an additional non-RAID disk for booting introduces a
> single point of failure which contrary to the idea of RAID>0.

GRUB2 has raid 1.1 and 1.2 metadata support via the mdraid1x module. LVM 
is also supported. I don't know if a stack of both is supported.

There is, BTW, no such thing as a (commodity) computer without a single 
point of failure in it somewhere. I've watched government contracts 
chase this demon for decades. Be it disk, controller, network card, bus 
chip, cpu or stick-of-ram you've got a single point of failure 
somewhere. Actually you likely have several such points of potential 
failure.

For instance, are you _sure_ your BIOS is going to check the second 
drive if it gets read failure after starting in on your first drive? 
Chances are it won't because that four-hundred bytes-or-so boot loader 
on that first disk has no way to branch back into the bios.

You can waste a lot of your life chasing that ghost and you'll still 
discover you've missed it and have to whip out your backup boot media.

It may well be worth having a second copy of /boot around, but make sure 
you stay out of bandersnatch territory when designing your system. "The 
more you over-think the plumbing, the easier it is to stop up the pipes."
