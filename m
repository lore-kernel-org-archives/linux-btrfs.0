Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:44340 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754062AbcK2TDR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 14:03:17 -0500
Subject: Re: Convert from RAID 5 to 10
To: Florian Lindner <mailinglists@xgm.de>, linux-btrfs@vger.kernel.org
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <d2551840-173a-712b-4039-99854e62539a@bouton.name>
Date: Tue, 29 Nov 2016 20:03:08 +0100
MIME-Version: 1.0
In-Reply-To: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 29/11/2016 à 18:20, Florian Lindner a écrit :
> [...]
>
> * Any other advice? ;-)

Don't rely on RAID too much... The degraded mode is unstable even for
RAID10: you can corrupt data simply by writing to a degraded RAID10. I
could reliably reproduce this on a 6 devices RAID10 BTRFS filesystem
with a missing device. It affected even a 4.8.4 kernel where our
PostgreSQL clusters got frequent write errors (on the fs itself but not
the 5 working devices) and managed to corrupt their data. Have backups,
you probably will need them.

With Btrfs RAID If you have a failing device, replace it early (monitor
the devices and don't wait for them to fail if you get transient errors
or see worrying SMART values). If you have a failed device, don't
actively use the filesystem in degraded mode. Replace or delete/add
before writing to the filesystem again.

Best regards,

Lionel
