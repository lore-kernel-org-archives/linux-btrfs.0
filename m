Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34518 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756443AbdELLZW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 07:25:22 -0400
Received: by mail-it0-f68.google.com with SMTP id c26so5607903itd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 04:25:21 -0700 (PDT)
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Ochi <ochi@arcor.de>, lists@colorremedies.com
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
 <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ba7f8443-6031-6658-d63b-e09dd3f2259e@gmail.com>
Date: Fri, 12 May 2017 07:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-11 19:24, Ochi wrote:
> Hello,
>
> here is the journal.log (I hope). It's quite interesting. I rebooted the
> machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing
> afterwards (around timestamp 66.*). However, I then logged into the
> machine from another terminal (around timestamp 118.*) which triggered
> something to make the device appear again :O Indeed, dm-3 was once again
> there after logging in. Does systemd mix something up?
>
> Hmm, I just did another mkfs once the devices where back, devices were
> missing, but they re-appeared a few seconds later, without logging into
> a terminal. After another mkfs, they were gone again and are now still
> gone after waiting a few minutes. It's really weird, I can't really tell
> what triggers this yet. Will test more tomorrow, let me know if you have
> any more ideas what to try.

It looks like something made systemd think that it should tear down the 
LUKS volumes, but it somehow only got /dev/dm-3 and not the others, and 
then you logging in and triggering the creation of the associated user 
slice somehow made it regain it's senses.  Next time you see it 
disappear, try checking `systemctl status` for the unit you have set up 
for the LUKS volume and see what that says.  I doubt it will give much 
more info, but I suspect it will say it's stopped, which will solidify 
that systemd is either misconfigured or doing something stupid (and 
based on past experience, I'm willing to bet it's the latter).

