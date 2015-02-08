Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40933 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbbBHX60 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 18:58:26 -0500
Received: by mail-lb0-f181.google.com with SMTP id b6so4210266lbj.12
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 15:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
 <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
 <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
 <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
 <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
 <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com> <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 8 Feb 2015 23:58:04 +0000
Message-ID: <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Second, SMART is only saying its internal test is good. The errors are
> related to data transfer, so that implicates the enclosure (bridge
> chipset or electronics), the cable, or the controller interface.
> Actually it could also be a flaky controller or RAM on the drive
> itself too which I don't think get checked with SMART tests.

Which test should I do from now on (on a weekly basis?) so as to
prevent similar things from happening?
