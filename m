Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45125 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0JG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 05:06:28 -0400
Received: by mail-wi0-f169.google.com with SMTP id cb5so2557469wib.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 02:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131024084756.14051.61595@localhost.localdomain>
References: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
	<20131024084756.14051.61595@localhost.localdomain>
Date: Sun, 27 Oct 2013 09:06:26 +0000
Message-ID: <CAHCKNJhbBk-4LbFfEVM4ULiHzRgqA0ZD1Hi-qXnEGKkYqN7TVg@mail.gmail.com>
Subject: Re: 3.11 and 3.12rc continual hard lock ups
From: Sean Clarke <sean.clarke@sec-consulting.co.uk>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
   I set dmesg -n7 and didn't see anything extra logged (I had to use
sudo to enable it. I am not familiar with sysrq-w and sysrq-t, however
you ask "while it is locked", this is a "real" hard lock. everything
is unresponsive and the machine even fails to respond to ping request.
It happened again over night and again the only clues where the
btrfs-transaction and btrfs-flush_del going ballistic.

Regards
Sean Clarke
---------------------------------------------
SEC Consulting Limited
Phone: +44 (0)23 8040 5599
Website: http://www.sec-consulting.co.uk
Email: sean.clarke@sec-consulting.co.uk


On Thu, Oct 24, 2013 at 9:47 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Sean Clarke (2013-10-23 15:26:15)
>> Hi,
>>    I have an Intel Core i7 based fileserver with 18TB BTRFS in a 6x
>> 3TB RAID 1+0 configuration. The system was working fine running Ubuntu
>> 13.04 (kernel 3.11.0-12-generic). The system was upgraded to Ubuntu
>> 13.10 (kernel 3.11) and began to lock up daily, sometimes every couple
>> of hours. Previously it never crashed and was only taken down for
>> maintenance so a bug was files on launchpad
>> (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1237794).
>
> Does your kernel  config include the softlockup detector?  If you could
> please do sysrq-w and sysrq-t while it is locked, it'll help us track it
> down.
>
> It will be much easier if you have a serial console or network console,
> and you've increased your kernel logging level to the highest value
> (dmesg -n7)
>
> -chris
