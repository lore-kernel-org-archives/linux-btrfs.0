From: cwillu <cwillu@cwillu.com>
Subject: Re: Creating backup snapshots (8 per filesystem) causes No space left
 on device?
Date: Sun, 15 Apr 2012 10:19:30 -0600
Message-ID: <CAE5mzvgKKj=7Xiv8uev5CKrGojjhep5mX9Si=kLd+=shQDyEnQ@mail.gmail.com>
References: <20120415150740.GA10248@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120415150740.GA10248@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

> but I can't get the filesystem show command to output anything useful:
> gandalfthegreat:~# btrfs filesystem show /dev/mapper/cryptroot
> Btrfs Btrfs v0.19

You need to run that as root.

> gandalfthegreat:~#
>
> and the btrfs df ssems to show that I'm ok:
> gandalfthegreat:~# btrfs filesystem df /home
> Data: total=169.01GB, used=134.70GB
> System, DUP: total=8.00MB, used=28.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=5.88GB, used=4.39GB
> Metadata: total=8.00MB, used=0.00
> gandalfthegreat:~#
>
> I read about rebalance but it's a mostly new fliesystem will little churn, and I'm
> not anywhere close to full filesystem yet.

The recommendation is basically a workaround for when the accounting
gets screwed up.  Balancing wouldn't help in the case where the
filesystem is actually full.
