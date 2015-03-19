Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:33972 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbCSXTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 19:19:33 -0400
Received: by yhch68 with SMTP id h68so32359317yhc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 16:19:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
Date: Thu, 19 Mar 2015 17:19:32 -0600
Message-ID: <CAJCQCtRkUnXvvMP=uSpxkusNMgXNVvmXKCeJ-rfNe9gi6W+Gqw@mail.gmail.com>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
From: Chris Murphy <lists@colorremedies.com>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 5:06 PM, G. Richard Bellamy
<rbellamy@pteradigm.com> wrote:
> When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
> INFO: task mount:302 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:329 blocked for more than 120 seconds.

If you boot single user is it semi-responsive enough to sysrq+w [1]
and post the resulting dmesg?


>My 3.18.6 works just fine.

What do you get for 'btrfs check <dev>' You either need to run this
from the initramfs (totally unmounted file system) or rescue media
with a decently recent btrfs progs.


[1]
https://www.kernel.org/doc/Documentation/sysrq.txt


-- 
Chris Murphy
