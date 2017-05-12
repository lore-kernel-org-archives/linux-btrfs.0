Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33641 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755963AbdELOLm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 10:11:42 -0400
Received: by mail-io0-f176.google.com with SMTP id p24so40806682ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 07:11:42 -0700 (PDT)
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Ochi <ochi@arcor.de>
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
 <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
 <ba7f8443-6031-6658-d63b-e09dd3f2259e@gmail.com>
 <3b6c4fb2-c2d4-b6d6-934f-187b1c9106b7@arcor.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f902eeb4-5b4e-5de1-a1bd-582eb0b15f35@gmail.com>
Date: Fri, 12 May 2017 10:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <3b6c4fb2-c2d4-b6d6-934f-187b1c9106b7@arcor.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-12 09:54, Ochi wrote:
> On 12.05.2017 13:25, Austin S. Hemmelgarn wrote:
>> On 2017-05-11 19:24, Ochi wrote:
>>> Hello,
>>>
>>> here is the journal.log (I hope). It's quite interesting. I rebooted the
>>> machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing
>>> afterwards (around timestamp 66.*). However, I then logged into the
>>> machine from another terminal (around timestamp 118.*) which triggered
>>> something to make the device appear again :O Indeed, dm-3 was once again
>>> there after logging in. Does systemd mix something up?
>>>
>>> Hmm, I just did another mkfs once the devices where back, devices were
>>> missing, but they re-appeared a few seconds later, without logging into
>>> a terminal. After another mkfs, they were gone again and are now still
>>> gone after waiting a few minutes. It's really weird, I can't really tell
>>> what triggers this yet. Will test more tomorrow, let me know if you have
>>> any more ideas what to try.
>>
>> It looks like something made systemd think that it should tear down
>> the LUKS volumes, but it somehow only got /dev/dm-3 and not the
>> others, and then you logging in and triggering the creation of the
>> associated user slice somehow made it regain it's senses.  Next time
>> you see it disappear, try checking `systemctl status` for the unit you
>> have set up for the LUKS volume and see what that says.  I doubt it
>> will give much more info, but I suspect it will say it's stopped,
>> which will solidify that systemd is either misconfigured or doing
>> something stupid (and based on past experience, I'm willing to bet
>> it's the latter).
>
> I will take a closer look at systemd when I get home. I would like to
> point out that this sounds very related to these fairly recent systemd
> issues:
>
> https://github.com/systemd/systemd/issues/5781
>
> https://github.com/systemd/systemd/issues/5866
>
> So my best guess is that systemd is indeed doing weird stuff with
> multi-device btrfs volumes.
Oh, it's known that systemd does weird stuff with multi-device setups, 
even if they aren't BTRFS, but this is odd behavior that I've not seen 
anything about before (I don't use systemd myself except on the 
reference VM's I have for the various distros that use it by default, so 
I end up hearing about this stuff through word of mouth).

That said, some of the discussion in that first issue you mentioned 
actually provides a possible explanation for some of the issues existing 
at all, namely that there appears to be a disconnect between how BTRFS 
actually behaves and how the systemd developers thinks it behaves (the 
question from Pottering about what's doing the 'assembly' is 
particularly interesting, given that there is nothing other than the 
kernel that does the equivalent of the 'assembly' step for an MD array 
or scanning for an LVM array).
