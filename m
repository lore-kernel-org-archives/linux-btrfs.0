Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:43385 "EHLO smtp2.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbbHMML4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 08:11:56 -0400
Received: from fex.belwue.de (fex.belwue.de [129.143.4.198])
	by smtp2.belwue.de with ESMTP id t7DCBtEO003634
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:11:55 +0200 (MEST)
	env-from (framstag@rus.uni-stuttgart.de)
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
	by fex.belwue.de (Postfix) with SMTP id 35EFD2036A
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:11:55 +0200 (CEST)
Date: Thu, 13 Aug 2015 14:11:55 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150813121155.GC24122@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 2015-08-12 (11:03), Chris Murphy wrote:
> On Wed, Aug 12, 2015 at 7:07 AM, Ulli Horlacher
> <framstag@rus.uni-stuttgart.de> wrote:
> 
> > /dev/sdb and /dev/sde are in reality the same physical disk!
> 
> When does all of this confusion happen? Is it already confused before
> mkfs or only after mkfs or only after mount?

I have not looked closely before the mkfs.btrfs, because I noticed no
problems.


> I would find out what instigates it, wipe all signatures from everything,
> reboot, start from scratch

This is not an option for me, because this server (despite its name) is a
production system.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum IZUS/TIK         E-Mail: horlacher@tik.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
