From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Accidental formatting
Date: Mon, 06 Feb 2012 08:40:52 +0100
Message-ID: <5pc409-hou.ln1@hurikhan.ath.cx>
References: <4F2F4BF9.7070609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fahrzin Hemmati <fahhem2@gmail.com> schrieb:

> I recently re-installed Ubuntu, and somewhere along the way the
> installer decided to clear out /var, which happens to be a separate
> btrfs device from /. When I do "btfrs filesystem df /var" it outputs this:
> 
> Data: total=134.01GB, used=485.78
> System, DUP: total=8.00MB, used=20.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.62GB, used=6.87MB
> Metadata: total=8.00MB, used=0.00
> 
> The reserved Data, 134GB, resembles closely the amount of data on my
> drive before the formatting. Therefore, I believe what happened was the
> installer didn't format /var, just cleared out the files. I didn't
> properly backup /var, but I have important files on it. Is there a way
> to have btrfs look around the reserved metadata area for orphaned files
> and get them back?

I'd try "photorec" on this although I believe it will be hard for photorec 
to recover the files due to btrfs' COW behaviour.

You could also try Josef's rescue tool or trying to intentionally corrupt 
you current tree root so you could use "mount -o recovery" to let btrfs 
mount an older tree root. This is just an idea, I think the btrfs folks here 
have better ideas how to accomplish mounting an older tree root.

HTH
Kai

