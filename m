Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsmx010.vodafonemail.xion.oxcs.net ([153.92.174.88]:37320 "EHLO
        vsmx010.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932662AbdELNzI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 09:55:08 -0400
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
 <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
 <ba7f8443-6031-6658-d63b-e09dd3f2259e@gmail.com>
From: Ochi <ochi@arcor.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <3b6c4fb2-c2d4-b6d6-934f-187b1c9106b7@arcor.de>
Date: Fri, 12 May 2017 15:54:59 +0200
MIME-Version: 1.0
In-Reply-To: <ba7f8443-6031-6658-d63b-e09dd3f2259e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.05.2017 13:25, Austin S. Hemmelgarn wrote:
> On 2017-05-11 19:24, Ochi wrote:
>> Hello,
>>
>> here is the journal.log (I hope). It's quite interesting. I rebooted the
>> machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing
>> afterwards (around timestamp 66.*). However, I then logged into the
>> machine from another terminal (around timestamp 118.*) which triggered
>> something to make the device appear again :O Indeed, dm-3 was once again
>> there after logging in. Does systemd mix something up?
>>
>> Hmm, I just did another mkfs once the devices where back, devices were
>> missing, but they re-appeared a few seconds later, without logging into
>> a terminal. After another mkfs, they were gone again and are now still
>> gone after waiting a few minutes. It's really weird, I can't really tell
>> what triggers this yet. Will test more tomorrow, let me know if you have
>> any more ideas what to try.
> 
> It looks like something made systemd think that it should tear down the 
> LUKS volumes, but it somehow only got /dev/dm-3 and not the others, and 
> then you logging in and triggering the creation of the associated user 
> slice somehow made it regain it's senses.  Next time you see it 
> disappear, try checking `systemctl status` for the unit you have set up 
> for the LUKS volume and see what that says.  I doubt it will give much 
> more info, but I suspect it will say it's stopped, which will solidify 
> that systemd is either misconfigured or doing something stupid (and 
> based on past experience, I'm willing to bet it's the latter).

I will take a closer look at systemd when I get home. I would like to 
point out that this sounds very related to these fairly recent systemd 
issues:

https://github.com/systemd/systemd/issues/5781

https://github.com/systemd/systemd/issues/5866

So my best guess is that systemd is indeed doing weird stuff with 
multi-device btrfs volumes.
