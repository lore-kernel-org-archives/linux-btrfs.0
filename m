Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34492 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbcFDVO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 17:14:57 -0400
Received: by mail-lf0-f67.google.com with SMTP id k192so2063531lfb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 14:14:56 -0700 (PDT)
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
To: "B. S." <bs27975@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5751E8D2.7070001@gmail.com>
 <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
 <5752873C.8050105@gmail.com> <5753105A.1030404@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <575344CD.4070900@gmail.com>
Date: Sun, 5 Jun 2016 00:14:53 +0300
MIME-Version: 1.0
In-Reply-To: <5753105A.1030404@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.06.2016 20:31, B. S. пишет:
>>>
>>> Yeah, when it comes to FDE, you either have to make your peace with
>>> trusting the manufacturer, or you can't. If you are going to boot
>>> your system with a traditional boot loader, an unencrypted partition
>>> is mandatory.
>>
>> No, it is not with grub2 that supports LUKS (and geli in *BSD world). Of
>> course initial grub image must be written outside of encrypted area and
>> readable by firmware.
> 
> Good to know. Do you have a link to a how to on such?
> 

As long as you use grub-install and grub-mkconfig this "just works" in
the sense they both detect encrypted container and add necessary drivers
and other steps to access it. The only manual setup is to add

GRUB_ENABLE_CRYPTODISK=y

to /etc/default/grub.

You will need to enter LUKS password twice - once in GRUB, once in
kernel (there is no interface for passing passphrase from bootloader to
Linux kernel). Some suggest including passphrase in initrd (on
assumption that it is encrypted anyway already); there are patches to
support use of external keyfile in grub as well.


