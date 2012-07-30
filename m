Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:36439 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2G3JgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 05:36:08 -0400
Message-ID: <50165584.70707@arndnet.de>
Date: Mon, 30 Jul 2012 11:36:04 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: C Anthony Risinger <anthony@xtfx.me>
CC: Konstantin Dmitriev <ksee.zelgadis@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: severe hardlink bug
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org> <CAGAVQTFADbS95X9NbtOBx7m=R3tXB1exauQtSpPfBc2m72tNqg@mail.gmail.com>
In-Reply-To: <CAGAVQTFADbS95X9NbtOBx7m=R3tXB1exauQtSpPfBc2m72tNqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 29.07.2012 21:13, schrieb C Anthony Risinger:
> On Sun, Jul 29, 2012 at 2:02 PM, Konstantin Dmitriev
> <ksee.zelgadis@gmail.com> wrote:
>> Dipl.-Ing. Michael Niederle <mniederle <at> gmx.at> writes:
>>
>>> I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
>>> the btrfs link restriction.
>>>
>>
>> I have hit the same issue - tried to run BackupPC with a pool on btrfs
>> filesystem. After some time the error of "too many links (31)" appeared to me.
>> Now I'm forced to migrate to some other filesystem...
> 
> btrfs only fails when you have hundreds of hardlinks to the same file
> in the *same* directory ... certainly not a standard use case.

Actually, "hundreds of hardlinks" is certainly over optimistic.
In my testing 15 links in the same directory were enough to get
the "Too many links" error. It depends on the length of the file
name of the hardlinks.

Best regards
Arnd
