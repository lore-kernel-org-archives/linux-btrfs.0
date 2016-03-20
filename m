Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61732 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbcCTMQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 08:16:20 -0400
MIME-Version: 1.0
Message-ID: <trinity-5cf99084-7f8f-482b-9de1-46f9ad173925-1458476176364@3capp-gmx-bs14>
From: "Patrick Tschackert" <Killing-Time@gmx.de>
To: "Martin Steigerwald" <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount btrfs partition, please help :(
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Mar 2016 13:16:16 +0100
In-Reply-To: <2392152.Z0f9U26f6o@merkaba>
References: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56>
 <CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>,
 <2392152.Z0f9U26f6o@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for answering, I already upgraded to a backports kernel as mentioned here:
https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51748.html

I now have

$ uname -a
Linux vmhost 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.5-1~bpo8+1 (2016-02-23) x86_64 GNU/Linux

As I wrote here https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51748.html
the problem still persists :(
 
Cheers,
Patrick

Gesendet: Sonntag, 20. März 2016 um 13:11 Uhr
Von: "Martin Steigerwald" <martin@lichtvoll.de>
An: "Chris Murphy" <lists@colorremedies.com>
Cc: "Patrick Tschackert" <Killing-Time@gmx.de>, "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Betreff: Re: unable to mount btrfs partition, please help :(
On Samstag, 19. März 2016 19:34:55 CET Chris Murphy wrote:
> >>> $ uname -a
> >>> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
> >>> (2016-02-29) x86_64 GNU/Linux
> >>
> >>This is old. You should upgrade to something newer, ideally 4.5 but
> >>4.4.6 is good also, and then oldest I'd suggest is 4.1.20.
> >>
> > Shouldn't I be able to get the newest kernel by executing "apt-get update
> > && apt-get dist-upgrade"? That's what I ran just now, and it doesn't
> > install a newer kernel. Do I really have to manually upgrade to a newer
> > one?
> I'm not sure. You might do a list search for debian, as I know debian
> users are using newer kernels that they didn't build themselves.

Try a backport¹ kernel. Add backports and do

apt-cache search linux-image

I use 4.3 backport kernel successfully on two server VMs which use BTRFS.

[1] http://backports.debian.org/

Thx,
--
Martin
