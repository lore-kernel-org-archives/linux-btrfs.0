Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:50687 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbBIBew (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 20:34:52 -0500
Received: by mail-yk0-f181.google.com with SMTP id 200so4796127ykr.12
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 17:34:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSiqT039nko_Y12iPXhetPXi_Lue27mQFNfDvEAb6GftQ@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
	<CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
	<CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
	<CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
	<CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
	<CAJCQCtSiqT039nko_Y12iPXhetPXi_Lue27mQFNfDvEAb6GftQ@mail.gmail.com>
Date: Sun, 8 Feb 2015 18:34:51 -0700
Message-ID: <CAJCQCtS7W53iyedVtO4bWE7dJOD+P11BBYEn_m08QdMfA+URaw@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: constantine <costas.magnuse@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I just created a small 5 device btrfs raid1 volume, and added some
data to it so all the devices have been written to. Then unmounted the
volume, and destroyed one of the devices. So now I have a 4 device
raid1 mounted degraded. And I can still device delete another device.
So one device missing and one device removed. Shortly thereafter I get
a kernel panic. This is 3.19rc7.

https://bugzilla.kernel.org/show_bug.cgi?id=92921


Chris Murphy
