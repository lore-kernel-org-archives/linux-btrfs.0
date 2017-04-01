Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:58578 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbdDAKSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Apr 2017 06:18:07 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:59034)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cuG6e-000pl3-TW
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 11:18:04 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cuG6Z-0002mp-JB
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Apr 2017 11:17:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22751.32343.177176.307907@tree.ty.sabi.co.uk>
Date: Sat, 1 Apr 2017 11:17:59 +0100
To: linux-btrfs@vger.kernel.org
Subject: Re: Do different btrfs volumes compete for CPU?
In-Reply-To: <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
        <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
        <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Approximately 16 hours ago I've run a script that deleted
>> >~100 snapshots and started quota rescan on a large
>> USB-connected btrfs volume (5.4 of 22 TB occupied now).

That "USB-connected is a rather bad idea. On the IRC channel
#Btrfs whenever someone reports odd things happening I ask "is
that USB?" and usually it is and then we say "good luck!" :-).

The issues are:

* The USB mass storage protocol is poorly designed in particular
  for error handling.
* The underlying USB protocol is very CPU intensive.
* Most importantly nearly all USB chipsets, both system-side
  and peripheral-side, are breathtakingly buggy, but this does
  not get noticed for most USB devices.

>> Quota rescan only completed just now, with 100% load from
>> [btrfs-transacti] throughout this period,

> [ ... ] are different btrfs volumes independent in terms of
> CPU, or are there some shared workers that can be point of
> contention?

As written that question is meaningless: despite the current
mania for "threads"/"threadlets" a filesystem driver is a
library, not a set of processes (all those '[btrfs-*]'
threadlets are somewhat misguided ways to do background
stuff).

The real problems here are:

* Qgroups are famously system CPU intensive, even if less so
  than in earlier releases, especially with subvolumes, so the
  16 hours CPU is both absurd and expected. I think that qgroups
  are still effectively unusable.
* The scheduler gives excessive priority to kernel threads, so
  they can crowd out user processes. When for whatever reason
  the system CPU percentage rises everything else usually
  suffers.

> BTW, USB adapter used is this one (though storage array only
> supports USB 3.0):
> https://www.asus.com/Motherboard-Accessory/USB_31_TYPEA_CARD/

Only Intel/AMD USB chipsets and a few others are fairly
reliable, and for mass storage only with USB3 with UASPI, which
is basically SATA-over-USB (more precisely SCSI-command-set over
USB). Your system-side card seems to be recent enough to do
UASPI, but probably the peripheral-side chipset isn't. Things
are so bad with third-party chipsets that even several types of
add-on SATA and SAS cards are too buggy.
