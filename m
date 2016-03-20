Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40307 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbcCTML0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 08:11:26 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Patrick Tschackert <Killing-Time@gmx.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount btrfs partition, please help :(
Date: Sun, 20 Mar 2016 13:11:23 +0100
Message-ID: <2392152.Z0f9U26f6o@merkaba>
In-Reply-To: <CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>
References: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56> <CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
