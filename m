Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:36820 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932388AbcJ0Auo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 20:50:44 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id 26455BA56
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 02:50:38 +0200 (CEST)
Subject: Re: Compression and device replace on raid10 kernel panic on 4.4.6
 and 4.6.x
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
 <e7707a30-e715-8a6f-c3ad-0e9171951f34@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <eef3fc06-8283-33dd-cd81-f63921212105@bouton.name>
Date: Thu, 27 Oct 2016 02:50:38 +0200
MIME-Version: 1.0
In-Reply-To: <e7707a30-e715-8a6f-c3ad-0e9171951f34@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 27/10/2016 à 01:54, Lionel Bouton a écrit :
>
> I'll post the final result of the btrfs replace later (it's currently at
> 5.6% after 45 minutes).

Result : kernel panic (so 4.8.4 didn't solve my main problem).
Unfortunately I don't have a remote KVM anymore so I couldn't capture
this one. panic=60 however did its job twice (I tried to mount the
filesystem again) confirming that a panic occured.

It seems the problem may be located at a precise location. Yesterday the
last replace resume logged :
Oct 26 00:40:56 zagreus kernel: BTRFS info (device sdb2): continuing
dev_replace from <missing disk> (devid 7) to /dev/sdb2 @12%

And today I was switching between a screen terminal windows when the
crash happened and the replace was at 12.6%. A mount triggers the crash
in ~20 seconds which is similar to what happened yesterday on the last try.

I've successfully canceled the replace to get back a usable system.

I'll stop for tonight and see what happens during the day. I'd like to
try a device add / delete next but I'm worried I could end up with a
completely unusable filesystem if the device delete hits the same
problem than replace.
If the replace resuming on mount crashes the system I can cancel it but
there's no way to do so with a device delete. Or is by any chance the
skip_balance mount option a way to cancel a delete ?

Best regards,

Lionel
