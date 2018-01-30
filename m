Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48727 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbeA3QIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 11:08:00 -0500
Date: Tue, 30 Jan 2018 17:07:59 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130160759.GE7126@polanet.pl>
References: <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <6804d30d-53ff-403f-1eac-ac5da01509f7@gmail.com>
 <20180130134649.GA7126@polanet.pl>
 <2e6b43ce-048f-2404-9455-c768f95e34fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <2e6b43ce-048f-2404-9455-c768f95e34fb@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 10:05:34 -0500, Austin S. Hemmelgarn wrote:

>> Instead, they should move their legs continuously and if the train is > not on the station yet, just climb back and retry.
> No, that's really not a good analogy given the fact that that check for 
> the presence of a train takes a normal person milliseconds while the 
> event being raced against (the train departing) takes minutes.  In the 

OMG... preventing races by "this would always take longer"? Seriously?

> You're already looping forever _waiting_ for the volume to appear.  How 

udev is waiting for events, not systemd. Nobody will do some crazy
cross-layered shortcuts to overcome other's lazyness.

> is that any different from lopping forever trying to _mount_ the volume 

Yes, because udev doesn't mount anything, ever. Not this binary dude!

> instead given that failing to mount the volume is not going to damage 
> things. 

Failed premature attempt to mount prevents the system from booting WHEN
the devices are ready - this is fatal. System boots randomly on racy
conditions.

But hey, "the devices will always appear faster, than the init attempt
to do the mount"!

Have you ever had some hardware RAID controller? Never heard about
devices appearing after 5 minutes of warming up?

> The issue here is that systemd refuses to implement any method 
> of actually retrying things that fail during startup.>

1. Such methods are trivial and I've already mentioned them a dozen of times.
2. They should be implemented in btrfs-upstream, not systemd-upstream,
   but I personally would happily help with writing them here.
3. They require full-circle path of 'allow-degraded' to be passed
   through btrfs code.

>> mounting BEFORE volume is complete is FATAL - since no userspace daemon
>> would ever retrigger the mount and the system won't came up. Provide one
>> btrfsd volume manager and systemd could probably switch to using it.
> And here you've lost any respect I might have had for you.

Going personal? So thank you for discussion and good bye.

Please refrain from answering me, I'm not going to discuss this any
further with you.

> **YOU DO NOT NEED A DAEMON TO DO EVERY LAST TASK ON THE SYSTEM**

Sorry dude, but I won't repeat for the 5th times all the alternatives.

You *all* refuse to step in ANY possible solution mentioned.
You *all* except the systemd to do ALL the job, just like other init
systems were forced to do, against the good design principles.

Good luck having btrfs degraded mount under systemd.

> <rant>
> This is one of the two biggest things I hate about systemd(the journal 
> is the other one for those who care).

The journal has currently *many* drawbacks, but this is not 'by design'
but 'by appropriate code missing for now'. The same applies to btrfs,
isn't it?

> You don't need some special daemon to set the time,

Ever heard about NTP?

> or to set the hostname,

FUD - no such daemon

> or to fetch account data,

FUD

> or even to track who's logged in

FUD

> As much as it may surprise the systemd developers, people got on just 
> fine handling setting the system time, setting the hostname, fetching 
> account info, tracking active users, and any number of myriad other 
> tasks before systemd decided they needed to have their own special daemon.
> </rant>

Sure, in myriad of different scattered distro-specific files. The only
reason systemd stepped in for some of there is that nobody else could
introduce and force Linux-wide consensus. And if anyone would succeed,
there would be some Austins blaming them for 'overtaking good old
trashyard into coherent de facto standard.'

> In this particular case, you don't need a daemon because the kernel does 
> the state tracking. 

Sure, MD doesn't require daemon and LVM doesn't require either. But they
do provide some - I know, they are all wrong.

-- 
Tomasz Pala <gotar@pld-linux.org>
