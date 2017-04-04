Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:53633 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754150AbdDDRgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:36:23 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:55618)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cvSNQ-003nMM-UZ
        for linux-btrfs@vger.kernel.org; Tue, 04 Apr 2017 18:36:21 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cvSNH-00015d-Rr
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Apr 2017 18:36:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22755.55691.456250.585931@tree.ty.sabi.co.uk>
Date: Tue, 4 Apr 2017 18:36:11 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Do different btrfs volumes compete for CPU?
In-Reply-To: <07258eab-5a2a-f028-48fb-60906b689cfa@rqc.ru>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
        <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
        <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
        <22751.32343.177176.307907@tree.ty.sabi.co.uk>
        <07258eab-5a2a-f028-48fb-60906b689cfa@rqc.ru>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] I tried to use eSATA and ext4 first, but observed
> silent data corruption and irrecoverable kernel hangs --
> apparently, SATA is not really designed for external use.

SATA works for external use, eSATA works well, but what really
matters is the chipset of the adapter card.

In my experience JMicron is not so good, Marvell a bit better,
best is to use a recent motherboard chipset with a SATA-eSATA
internal cable and bracket.

>> As written that question is meaningless: despite the current
>> mania for "threads"/"threadlets" a filesystem driver is a
>> library, not a set of processes (all those '[btrfs-*]'
>> threadlets are somewhat misguided ways to do background
>> stuff).

> But these threadlets, misguided as the are, do exist, don't
> they?

But that does not change the fact that it is a library and work
is initiated by user requests which are not per-subvolume, but
in effect per-volume.

> I understand that qgroups is very much work in progress, but
> (correct me if I'm wrong) right now it's the only way to
> estimate real usage of subvolume and its snapshots.

It is a way to do so and not a very good way. There is no
obviously good way to define "real usage" in the presence of
hard-links and reflinking, and qgroups use just one way to
define it. A similar problem happens with processes in the
presence of shared pages, multiple mapped shared libraries etc.

> For instance, if I have dozen 1TB subvolumes each having ~50
> snapshots and suddenly run out of space on a 24TB volume, how
> do I find the culprit without qgroups?

It is not clear what "culprit" means here. The problem is that
both hard-links and ref-linking create really significant
ambiguities as to used space. Plus the same problem would happen
with directories instead of subvolumes and hard-links instead of
reflinked snapshots.

> [ ... ] The chip is ASM1142, not Intel/AMD sadly but quite
> popular nevertheless.

ASMedia USB3 chipsets are fairly reliable at the least the card
ones on the system side. The ones on the disk side I don't know
much about. I have seen some ASMedia one that also seem OK. For
the disks I use a Seagate and a WDC external box from which I
have removed the original disk, as I have noticed that Seagate
and WDC for obvious reasons tend to test and use the more
reliable chipsets. I have also got an external USB3 dock with a
recent ASMedia chipset that also seems good, but I haven't used
it much.
