Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50454 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbaLHWiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 17:38:17 -0500
Message-ID: <54862854.9070808@web.de>
Date: Mon, 08 Dec 2014 23:38:12 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Phillip Susi <psusi@ubuntu.com>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485DDC7.2080500@pobox.com>
In-Reply-To: <5485DDC7.2080500@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Robert White schrieb am 08.12.2014 um 18:20:
> On 12/07/2014 04:32 PM, Konstantin wrote:
>> I know this and I'm using 0.9 on purpose. I need to boot from these
>> disks so I can't use 1.2 format as the BIOS wouldn't recognize the
>> partitions. Having an additional non-RAID disk for booting introduces a
>> single point of failure which contrary to the idea of RAID>0.
>
> GRUB2 has raid 1.1 and 1.2 metadata support via the mdraid1x module.
> LVM is also supported. I don't know if a stack of both is supported.
>
> There is, BTW, no such thing as a (commodity) computer without a
> single point of failure in it somewhere. I've watched government
> contracts chase this demon for decades. Be it disk, controller,
> network card, bus chip, cpu or stick-of-ram you've got a single point
> of failure somewhere. Actually you likely have several such points of
> potential failure.
>
> For instance, are you _sure_ your BIOS is going to check the second
> drive if it gets read failure after starting in on your first drive?
> Chances are it won't because that four-hundred bytes-or-so boot loader
> on that first disk has no way to branch back into the bios.
>
> You can waste a lot of your life chasing that ghost and you'll still
> discover you've missed it and have to whip out your backup boot media.
>
> It may well be worth having a second copy of /boot around, but make
> sure you stay out of bandersnatch territory when designing your
> system. "The more you over-think the plumbing, the easier it is to
> stop up the pipes."
You are right, there is as good as always a single point of failure
somewhere, even if it is the power plant providing your electricity ;-).
I should have written "introduces an additional single point of failure"
to be 100% correct but I thought this was obvious. As I have replaced
dozens of damaged hard disks but only a few CPUs, RAMs etc. it is more
important for me to reduce the most frequent and easy-to-solve points of
failure. For more important systems there are high availability
solutions which alleviate many of the problems you mention of but that's
not the point here when speaking about the major bug in BTRFS which can
make your system crash.


