Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40725 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754803AbdERGJN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 02:09:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dBEcR-0006Q1-LD
        for linux-btrfs@vger.kernel.org; Thu, 18 May 2017 08:09:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 6 corrupted
Date: Thu, 18 May 2017 06:08:56 +0000 (UTC)
Message-ID: <pan$5e76f$e72f3dc7$e211b36e$44e19024@cox.net>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
        <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
        <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
        <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
        <20170518032956.axcluisxusxelmx6@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Thu, 18 May 2017 05:29:57 +0200 as excerpted:

> On Thu, May 18, 2017 at 04:09:38AM +0200, Łukasz Wróblewski wrote:
>> Thanks guys.
>> 
>> I will try when stable 4.12 comes out.
> 
> It won't come out for ~2.5 months.  I'd recommend building the -rc,
> recovering, then going back to a stable kernel.

??  4.12-rc1 is already out.  rc-s normally come out weekly and there's 
almost always 7-8 of them, depending on how Linus feels about the 
stability of things in the last few rc-s and what his coming schedule 
looks like.

So we should only be looking at another ~7 weeks until 4.12.0 release, 
now.  Where'd ~2.5 months come from?  Were you including the two weeks of 
commit window pre-rc1 that's already passed?  That'd make it about 9-10 
weeks, so about 2.5 months, but about half a month of that's already gone.

Or does Linus have a couple weeks of no-release holiday coming up?  IIRC 
he usually does releases even on holiday, tho, but he may delay opening 
the commit window or delay an rc a couple days.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

