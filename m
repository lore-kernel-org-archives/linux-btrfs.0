Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:48756 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbbBIAhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 19:37:31 -0500
Received: by mail-yh0-f50.google.com with SMTP id a41so6200691yho.9
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 16:37:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
	<CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
	<CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
	<CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
	<CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
Date: Sun, 8 Feb 2015 17:37:30 -0700
Message-ID: <CAJCQCtSiqT039nko_Y12iPXhetPXi_Lue27mQFNfDvEAb6GftQ@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 8, 2015 at 4:58 PM, constantine <costas.magnuse@gmail.com> wrote:

> Which test should I do from now on (on a weekly basis?) so as to
> prevent similar things from happening?

You should check dmesg after each scrub and at each mount. You can also use

btrfs scrub -Bd <mountpoint>

This means scrub won't run in the background and will report detailed
errors at the end. -R includes a bit more information. You can also
get lifetime (or since last reset) stats per device:

btrfs device stats <mountpoint>

And use -z to reset.


-- 
Chris Murphy
