Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out14.tpgi.com.au ([220.244.226.124]:45464 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbbELBKT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 21:10:19 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Philip Seeger <p0h0i0l0i0p@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
Date: Tue, 12 May 2015 01:04:32 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F645954A2D259@Server.waterlogic.com.au>
References: <554F6D43.2060806@googlemail.com>
 <CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com>
 <554F963D.2040209@googlemail.com> <201505111141.54771.russell@coker.com.au>
 <555145EA.6040009@googlemail.com>
In-Reply-To: <555145EA.6040009@googlemail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Philip Seeger
> Sent: Tuesday, 12 May 2015 10:15 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
> dev stats
> 
> > Sounds like you are having errors in your RAM, CPU, motherboard, or
> > hard drive cabling.  Turn the machine off ASAP and plug the disks into
> > a different system, if you keep it running you will make it worse.
> >
> I know it sounds like it, but the host is fine. The host filesystem (on which the
> vm virtual hdd resides) is healthy. Other vms are running on the same host,
> no problems there. Just to be sure, I will run memtest, but I'm pretty sure
> that's not it. The system is under high load a lot, but I don't think btrfs would
> fail because of a slow system.
> 
> So I have deleted all those corrupted files in this Arch vm, ran a scrub, 0
> errors, all fixed. I restored them, fixed some other things and now - I get
> checksum errors again. Interestingly, it looks like the corruption is not
> happening randomly, because the same sqlite files are affected under
> ~/.mozilla/ and exactly one library file (ghostscript).
> Meanwhile, other vms (not Arch but Fedora and Debian) are running without
> a problem (one of them using btrfs as well).
> 
> Is it possible that systemd isn't unmounting the filesystem properly, so it gets
> corrupted on shutdown? (Juest a wild guess.) Although I'm not sure if all this
> happened between reboots.

Are you using KVM with some form of disk caching? I had a windows vm that was constantly creating errors on the host filesystem (btrfs) somewhere within the disk image. I changed the caching option (I can't remember from/to what) and it fixed the error. It didn't seem to be causing any errors on the windows guest, but it's windows so you never know :)

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
