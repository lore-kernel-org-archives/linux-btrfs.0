Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51143 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S2388535AbeGYCmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 22:42:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fi8di-0003e1-2X
        for linux-btrfs@vger.kernel.org; Wed, 25 Jul 2018 03:30:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: File permissions lost during send/receive?
Date: Wed, 25 Jul 2018 01:30:47 +0000 (UTC)
Message-ID: <pan$f0b84$d2852d74$655b38f0$15673ccb@cox.net>
References: <8202618.Xtt70Sb46P@thetick>
        <47372f67-70fd-8b11-0573-39d1137356e3@gmail.com>
        <pan$d56e4$375bb872$1bdbd77f$1569f8ce@cox.net> <1611860.S2UmG8tJGO@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Tue, 24 Jul 2018 22:42:06 +0200 as excerpted:

> On my system I get:
> 
> % sudo getcap /bin/ping /sbin/unix_chkpwd
> /bin/ping = cap_net_raw+ep
> /sbin/unix_chkpwd = cap_dac_override+ep
> 
>> (getcap on unix_chkpwd returns nothing, but while I use kde/plasma I
>> don't normally use the lockscreen at all, so for all I know that's
>> broken here too.)

OK, after remerging pam, I get the same for unix_chkpwd (tho here I have 
sbin merge so it's /bin/unix_chkpwd with sbin -> bin), so indeed, it must 
have been the same problem for you with it, that I've simply not run into 
since whatever killed the filecaps here, because I don't use the 
lockscreen.

But if I start using the lockscreen again and it fails, I know one not-so-
intuitive thing to check, now. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

