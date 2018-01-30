Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:51010 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeA3PFk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 10:05:40 -0500
Received: by mail-it0-f48.google.com with SMTP id x128so982665ite.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 07:05:40 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <6804d30d-53ff-403f-1eac-ac5da01509f7@gmail.com>
 <20180130134649.GA7126@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2e6b43ce-048f-2404-9455-c768f95e34fb@gmail.com>
Date: Tue, 30 Jan 2018 10:05:34 -0500
MIME-Version: 1.0
In-Reply-To: <20180130134649.GA7126@polanet.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-30 08:46, Tomasz Pala wrote:
> On Mon, Jan 29, 2018 at 08:05:42 -0500, Austin S. Hemmelgarn wrote:
> 
>> Seriously, _THERE IS A RACE CONDITION IN SYSTEMD'S CURRENT HANDLING OF
>> THIS_.  It's functionally no different than prefacing an attempt to send
>> a signal to a process by checking if the process exists, or trying to
>> see if some other process is using a file that might be locked by
> 
> Seriously, there is a race condition on train stations. People check if
> the train has stopped and opened the door before they move their legs to
> get in, but the train might be already gone - so this is pointless.
> 
> Instead, they should move their legs continuously and if the train is > not on the station yet, just climb back and retry.
No, that's really not a good analogy given the fact that that check for 
the presence of a train takes a normal person milliseconds while the 
event being raced against (the train departing) takes minutes.  In the 
case being discussed, the check takes milliseconds and the event being 
raced against also takes milliseconds.  The scale here is drastically 
different.>
> See the difference? I hope now you know what is the race condition.
> It is the condition, where CONSEQUENCES are fatal.
Yes, the consequences of the condition being discussed functionally are 
fatal (you completely fail to mount the volume), because systemd doesn't 
retry mounting the root filesystem, it just breaks, which is absolutely 
at odds with the whole 'just works' mentality I always hear from the 
systemd fanboys and developers.

You're already looping forever _waiting_ for the volume to appear.  How 
is that any different from lopping forever trying to _mount_ the volume 
instead given that failing to mount the volume is not going to damage 
things.  The issue here is that systemd refuses to implement any method 
of actually retrying things that fail during startup.>
> mounting BEFORE volume is complete is FATAL - since no userspace daemon
> would ever retrigger the mount and the system won't came up. Provide one
> btrfsd volume manager and systemd could probably switch to using it.
And here you've lost any respect I might have had for you.

**YOU DO NOT NEED A DAEMON TO DO EVERY LAST TASK ON THE SYSTEM**

Period, end of story.

<rant>
This is one of the two biggest things I hate about systemd (the journal 
is the other one for those who care).  You don't need some special 
daemon to set the time, or to set the hostname, or to fetch account 
data, or even to track who's logged in (though I understand that the 
last one is not systemd's fault originally).

As much as it may surprise the systemd developers, people got on just 
fine handling setting the system time, setting the hostname, fetching 
account info, tracking active users, and any number of myriad other 
tasks before systemd decided they needed to have their own special daemon.
</rant>

In this particular case, you don't need a daemon because the kernel does 
the state tracking.  It only checks that state completely though _when 
you ask it to mount the filesystem_ because it requires doing 99% of the 
work of mounting the filesystem (quite literally, you're doing pretty 
much everything short of actually hooking things up in the VFS layer). 
We are not a case like MD where there's just a tiny bit of metadata to 
parse to check what the state is supposed to be.  Imagine if LVM 
required you to unconditionally activate all the LV's in a VG when you 
activate the VG and what logic would be required to validate the VG 
then, and you're pretty close to what's needed to check state for a 
BTRFS volume (translating LV's to chunks and the VG to the filesystem as 
a whole).  There is no point in trying to parse that data every time a 
new device shows up, it's a waste of time (at a minimum, you're almost 
doubling the amount of time it takes to mount a volume if you are doing 
this each time a device shows up), energy, and resources in general.
> 
> mounting AFTER volume is complete is FINE - and if the "pseudo-race" happens
> and volume disappears, then this was either some operator action, so the
> umount SHOULD happen, or we are facing some MALFUNCION, which is fatal
> itself, not by being a "race condition".
Short of catastrophic failure, the _volume_ doesn't disappear, a 
component device does, and that is where the problem lies, especially 
given that the ioctl only tracks that each component device has been 
seen, not that all are present at the moment the ioctl is invoked.
