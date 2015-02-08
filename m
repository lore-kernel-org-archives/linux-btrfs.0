Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:42935 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbbBHXet (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 18:34:49 -0500
Received: by mail-yk0-f173.google.com with SMTP id 142so9992239ykq.4
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 15:34:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
	<CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
	<CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
Date: Sun, 8 Feb 2015 16:34:48 -0700
Message-ID: <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 8, 2015 at 4:09 PM, constantine <costas.magnuse@gmail.com> wrote:
> By the way, /dev/sdc just completed the extended offline test without
> any error... I feel so confused,....

First, we know from a number of studies, including the famous (and now
kinda old) Google study that  a huge percent of drive failures come
with no SMART errors.

Second, SMART is only saying its internal test is good. The errors are
related to data transfer, so that implicates the enclosure (bridge
chipset or electronics), the cable, or the controller interface.
Actually it could also be a flaky controller or RAM on the drive
itself too which I don't think get checked with SMART tests.

-- 
Chris Murphy
