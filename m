Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40244 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753745AbdBDIWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 03:22:31 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZvbz-0008UL-3v
        for linux-btrfs@vger.kernel.org; Sat, 04 Feb 2017 09:22:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Very slow balance / btrfs-transaction
Date: Sat, 4 Feb 2017 08:22:17 +0000 (UTC)
Message-ID: <pan$dd6b9$f272402c$c0b70b44$e64ed91e@cox.net>
References: <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
        <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
        <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
        <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
        <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
        <CAKuJGC-3pmzOWmaUZx-xav9W1zp+m=1PLhunKDm2Cw80c+6-Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lakshmipathi.G posted on Sat, 04 Feb 2017 08:25:04 +0530 as excerpted:

>>Should quota support generally be disabled during balances?
> 
> If this true and quota impacts balance throughput, at-least there should
> an alert message like "Running Balance with quota will affect
> performance" or similar before starting.

The problem isn't that, exactly, tho that's part of it.  The problem with 
quotas is that the feature itself isn't yet mature.  At least until very 
recently, and possibly still, quotas couldn't be depended upon to work 
correctly (various not entirely uncommon corner-cases would trigger 
negative numbers, etc), and even when they do work correctly, they simply 
don't scale well in combination with balance, check, etc -- that 10X 
difference isn't uncommon.

So my recommendation for quotas has been and remains, unless you're 
actively working with the devs on improving them, it's probably better to 
keep them disabled.  Either you actually need quota functionality or you 
don't.  If you do, it's better to use a mature filesystem where quotas 
are a mature feature that works dependably.  If you don't, just leave the 
feature off, as it continues to simply not be worth the troubles and 
scaling issues it triggers.

IOW, btrfs quotas might work and scale well some day, but that day isn't 
today, and it's not going to be tomorrow or next kernel cycle, either.  
It's going to take awhile, and you'll be much happier with btrfs in the 
mean time if you don't have them enabled.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

