Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34895 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbbLLWMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Dec 2015 17:12:34 -0500
Received: by pfd5 with SMTP id 5so22819213pfd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 14:12:33 -0800 (PST)
Received: from localhost (220-253-24-178.dyn.iinet.net.au. [220.253.24.178])
        by smtp.gmail.com with ESMTPSA id x86sm18633214pfi.68.2015.12.12.14.12.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Dec 2015 14:12:32 -0800 (PST)
Date: Sun, 13 Dec 2015 09:12:29 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Fixing recursive fault and parent transid verify failed
Message-ID: <20151212221229.GA3121@alistair-xps13>
References: <20151207015715.GA13954@alistair-xps13>
 <pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
 <20151207100256.GA6836@alistair-xps13>
 <pan$cb93a$b4f560b9$2dfdbdbc$17d7a835@cox.net>
 <20151207195504.GA9262@alistair-xps13>
 <pan$73edd$edd83c4d$2a373055$4b6032dd@cox.net>
 <20151208223847.GA4419@alistair-xps13>
 <pan$39f4c$4a92c925$153447bf$d623c310@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$39f4c$4a92c925$153447bf$d623c310@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 09, 2015 at 10:19:41AM +0000, Duncan wrote:
> Alistair Grant posted on Wed, 09 Dec 2015 09:38:47 +1100 as excerpted:
> 
> > On Tue, Dec 08, 2015 at 03:25:14PM +0000, Duncan wrote:
> > Thanks again Duncan for your assistance.
> > 
> > I plugged the ext4 drive I planned to use for the recovery in to the
> > machine and immediately got a couple of errors, which makes me wonder
> > whether there isn't a hardware problem with the machine somewhere.
> > 
> > So decided to move to another machine to do the recovery.
> 
> Ouch!  That can happen, and if you moved the ext4 drive to a different 
> machine and it was fine there, then it's not the drive.
> 
> But you didn't say what kind of errors or if you checked SMART, or even 
> how it was plugged in (USB or SATA-direct or...).  So I guess you have 
> that side of things under control.  (If not, there's some here who know 
> quite a bit about that sort of thing...)

Yep, I'm familiar enough with smartmontools, etc. to (hopefully) figure
this out on my own.


> 
> > So I'm now recovering on Arch Linux 4.1.13-1 with btrfs-progs v4.3.1
> > (the latest version from archlinuxarm.org).
> > 
> > Attempting:
> > 
> > sudo btrfs restore -S -m -v /dev/sdb /mnt/btrfs-recover/ ^&1 | tee
> > btrfs-recover.log
> > 
> > only recovered 53 of the more than 106,000 files that should be
> > available.
> > 
> > The log is available at:
> > 
> > https://www.dropbox.com/s/p8bi6b8b27s9mhv/btrfs-recover.log?dl=0
> > 
> > I did attempt btrfs-find-root, but couldn't make sense of the output:
> > 
> > https://www.dropbox.com/s/qm3h2f7c6puvd4j/btrfs-find-root.log?dl=0
> 
> Yeah, btrfs-find-root's output deciphering takes a bit of knowledge.  
> Between what I had said and the wiki, I was hoping you could make sense 
> of things without further help, but...
>
> ...

It turns out that a drive from a separate filesystem was dying and
causing all the weird behaviour on the original machine.

Having two failures at the same time (drive physical failure and btrfs
filesystem corruption) was a bit too much for me, so I aborted the btrfs
restore attempts, bought a replacement drive and just went back to the
backups (for both failures).

Unfortunately, I now won't be able to determine whether there was any
connection between the failures or not.

So while I didn't get to practice my restore skills, the good news is
that it is all back up and running without any problems (yet :-)).

Thank you very much for the description and detailed set of steps for
using btrfs-find-root and restore.  While I didn't get to use them this
time, I've added links to the mailing list archive in my btrfs wiki user
page so I can find my way back (and if others search for restore and
find root they may also benefit from your effort).

Thanks again,
Alistair

