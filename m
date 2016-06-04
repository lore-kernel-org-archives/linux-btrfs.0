Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34383 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbcFDVHy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 17:07:54 -0400
Received: by mail-lf0-f52.google.com with SMTP id s186so8776004lfs.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 14:07:53 -0700 (PDT)
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
To: Chris Murphy <lists@colorremedies.com>,
        Justin Brown <justin.brown@fandingo.org>
References: <5751E8D2.7070001@gmail.com>
 <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
 <CAJCQCtQUBsB-w7TrSAd=+t+E=6aqyPmcUrmMWyd6sg6BuJsS4Q@mail.gmail.com>
Cc: "B. S." <bs27975@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57534325.9070309@gmail.com>
Date: Sun, 5 Jun 2016 00:07:49 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQUBsB-w7TrSAd=+t+E=6aqyPmcUrmMWyd6sg6BuJsS4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.06.2016 22:05, Chris Murphy пишет:
...
>>
>> Yeah, when it comes to FDE, you either have to make your peace with
>> trusting the manufacturer, or you can't. If you are going to boot your
>> system with a traditional boot loader, an unencrypted partition is
>> mandatory.
> 
> /boot can be encrypted, GRUB supports this, but I'm unaware of any
> installer that does.

openSUSE supports installation on LUKS encrypted /boot. Installer has
some historical limitations regarding how encrypted container can be
setup, but bootloader part should be OK (including secure boot support).

> The ESP can't be encrypted.
> 

It should be possible if you use hardware encryption (SED).

> http://dustymabe.com/2015/07/06/encrypting-more-boot-joins-the-party/
> 
> It's vaguely possible for the SED variety of drive to support fully
> encrypted everything, including the ESP. The problem is we don't have
> OPAL support on Linux at all anywhere. And for some inexplicable
> reason, the TCG hasn't commissioned a free UEFI application for
> managing the keys and unlocking the drive in the preboot environment.
> For now, it seems, such support has to already be in the firmware.
> 


