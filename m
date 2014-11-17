Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:62229 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQTpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 14:45:53 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so6365643vcb.21
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 11:45:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
Date: Mon, 17 Nov 2014 20:45:52 +0100
Message-ID: <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
Subject: Fwd: BTRFS messes up snapshot LV with origin
From: MegaBrutal <megabrutal@gmail.com>
To: kreijack@inwind.it, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-11-17 20:04 GMT+01:00 Goffredo Baroncelli <kreijack@inwind.it>:
>
> Regarding b)
> I am bit confused: if I understood correctly, the root filesystem was
> picked from a LVM-snapshot, so grub-probe *correctly* reported that
> the root device is the snapshot.


This is not what happens. The system doesn't even get a reboot when
the mix-up happens.

You boot from the original device, create an LVM-snapshot*, and mount
starts to report the snapshot as the root device, while in fact it
isn't.

I know my initial descriptions of the bug were misleading, as myself
didn't know what the heck is going on.

>From this point, please take these comments as reference:
https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1391429/comments/2
https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1391429/comments/4


* I know I shouldn't make an LVM-snapshot of a mounted file system,
but this is not the point.


P.S.: E-mail sent twice, as lists didn't accept it in HTML. Plus I'm
not on the GRUB list, and can't post there.
