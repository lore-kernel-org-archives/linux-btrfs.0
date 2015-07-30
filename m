Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35518 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbG3LWN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 07:22:13 -0400
Received: by qgii95 with SMTP id i95so21380850qgi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2015 04:22:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
References: <1437763277.673610371@apps.rackspace.com>
	<55B54568.5060902@googlemail.com>
	<pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
Date: Thu, 30 Jul 2015 07:22:12 -0400
Message-ID: <CAGfcS_=Z=bRzMvFBDeYQDU8Vxa2UVha44nWogjQ_-_irrZD1xQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_systemd_=3A_Timed_out_waiting_for_defice_dev=2Ddisk=2D?=
	=?UTF-8?Q?by=E2=80=A6?=
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 1:20 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Philip Seeger posted on Sun, 26 Jul 2015 22:39:04 +0200 as excerpted:
>
>> Hi,
>>
>>> 50% of the time when booting, the system go in safe mode because my 12x
>>> 4TB RAID10 btrfs is taking too long to mount from fstab.
>>
>> This won't help, but I've seen this exact behavior too (some time ago).
>> Except that it wasn't 50% that it didn't work, more like almost
>> everytime.
>> Commenting out the fstab entry "fixed" it, mounting using a cronjob
>> (@reboot) worked without a problem.
>>
>> (As far as I remember, options like x-systemd.device-timeout didn't
>> change anything.)
>>
>> If someone has the answer, I'd be interested too.
>
> You mean something like a custom systemd *.service unit file?  That's
> what I'd do here. =:^)

I'd have to play with it to work out the kinks, but I'm pretty sure
you'd be better off with a mount unit instead of basically reinventing
a mount unit using a service unit.

I'd also think that you could also use drop-ins to enhance the
auto-generated units created by the fstab generator, if you just
wanted to add a dependency or such to a mount unit.  However, I've
never tried to create a drop-in for a generated unit.

Mount units should take any setting in systemd.unit which includes all
the ordering/dependency/etc controls.

--
Rich
