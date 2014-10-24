Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41650 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751AbaJXQNS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 12:13:18 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPF83msoJtpRRmMEeaLHQf=e6JyoTgR9TP3p_Q5XAZCLahh-yw@mail.gmail.com>
Date: Fri, 24 Oct 2014 10:13:18 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <63A348D8-0318-45F1-BC82-19096F8D3691@colorremedies.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com> <543B372F.10509@oracle.com> <CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com> <543C86C3.7040804@oracle.com> <CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com> <3E469DA1-1744-4AFC-9C56-04AE2CB6BA4F@colorremedies.com> <CAPF83msoJtpRRmMEeaLHQf=e6JyoTgR9TP3p_Q5XAZCLahh-yw@mail.gmail.com>
To: Suman C <schakrava@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 14, 2014, at 2:11 PM, Suman C <schakrava@gmail.com> wrote:

> After the reboot step, where I indicated that I mounted ro, I was
> unable to mount rw or rw,degraded. I get the "mount: wrong fs type,
> bad option, bad superblock…." error if I try to mount it rw.

I would test with kernel 3.17 at least, but better to use 3.18rc1 now. If you can reproduce it, then I'd file a bug. I'm a bit haphazard in my bug filing. It seems more effective to start a new subject with the word bug in brackets, and subject something like "can't mount rw,degraded" and then go through the reproduce steps being clear how the fs was created and all that. Also note not only what does happen, but what you expect to happen instead. Seems obvious but it should be done that way. I'd also file it as a bug the way we're asked to on the wiki which is bugzilla.kernel.org.

Chris Murphy