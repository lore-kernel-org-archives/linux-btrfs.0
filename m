Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37170 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdHILNZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 07:13:25 -0400
Received: by mail-lf0-f67.google.com with SMTP id x16so4258198lfb.4
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 04:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170809104820.25c3601e@gmail.com>
References: <20170809104820.25c3601e@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Wed, 9 Aug 2017 13:13:08 +0200
Message-ID: <CANznX5HW86Kd21wgv9AuHgng=NQENsKKFBqUHpM0N6=b4TnEuA@mail.gmail.com>
Subject: Re: BTRFS warning: unhandled fiemap cache detected
To: =?UTF-8?Q?Mario_Fugazzi=C2=AE?= <fugazzi99@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As much as I can tell it's nothing to worry about. (I have thousands
of these warnings.) I don't know why the patch was submitted for 4.13
but not applied to the next 4.12.x , since it looks like a trivial
tiny fix for an annoying problem.

On Wed, Aug 9, 2017 at 10:48 AM, Mario Fugazzi® <fugazzi99@gmail.com> wrote:
> Hi everyone :-)
>
> After updating the kernel to the latest one 4.12 I receive a lot of warnings in
> my dmesg but only on my ssd that is a kingston hyperx predator.
> No message get logged for my other two traditional HD that are btrfs also.
> Warnings show only on boot and not on every boot.
> Kernel is now 4.12.5 but I got that till upgrading to 4.12, in 4.11 no warnings.
>
> Just wanted to know if I have to worry about this, scrubs are ok and btrfs
> check give me no problems.
>
> Thank you very much.
> Mario.
>
> Some sample:
>
> [   13.486100] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
> [   13.486110] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
> [   13.486261] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960824832 len=12288 flags=0x0
> [   13.486280] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960763392 len=4096 flags=0x0
> [   13.486434] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
> [   13.486446] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960775680 len=4096 flags=0x0
> [   13.486616] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960783872 len=24576 flags=0x0
> [   13.486650] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960808448 len=4096 flags=0x0
> [   13.486719] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960812544 len=8192 flags=0x0
> [   13.486742] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960820736 len=4096 flags=0x0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
