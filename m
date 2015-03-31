Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51137 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbbCaVqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 17:46:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yd3yy-0002qK-VS
	for linux-btrfs@vger.kernel.org; Tue, 31 Mar 2015 23:46:01 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 23:46:00 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 23:46:00 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
Date: Tue, 31 Mar 2015 23:45:47 +0200
Message-ID: <b5hrub-586.ln1@hurikhan77.spdns.de>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com> <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com> <CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> On Tue, Mar 31, 2015 at 2:09 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>> Well you have to rule that out before anyone on this list can really
>> help. Try booting Fedora 21 install media, and using smartctl -x on
>> the drive.
> 
> While you're at it, try to mount the Btrfs volume in question normally
> and report kernel messages. If mount fails, try it with -o recovery
> mount option, and also report kernel messages and whether that fails.

I had this happen, too, lately. It's quite often happening after an unclean 
shutdown (which currently quite often happend to me due to the xorg intel 
driver having GPU freezes). SysRq+W shows that the mount process is locked 
somewhere in the btrfs code path and won't quit if Ctrl+C'd...

Only way to fix it was to btrfs-zero-log. But it still took some reboots 
from initramfs until it successfully mounted again (I could mount it in 
initramfs right after zero-log but upon reboot it hung again though at a 
different stage probably).

So I guess there's some race on the one hand (happens from time to time non-
related to fixing it with zero-log), and a deadlock on the other hand after 
some unclean shutdowns (more or less random).

My setup is 3-device btrfs-mraid1-draid0 on bcache. Bcache wasn't involved 
in the backtrace of SysRq+W, however. Apparently I don't have a screenshot 
of it because my smart phone is currently fried...

-- 
Replies to list only preferred.

