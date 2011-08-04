From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: INSTALL hint: create device btrfs-control
Date: 04 Aug 2011 20:35:00 +0200
Message-ID: <BrDfNwli1uB@helmut.hullen.de>
References: <20110804173548.GA8970@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804173548.GA8970@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 04.08.11:

>> you should please add a hint in
>>
>>    .../git/mason/btrfs-progs-unstable.git
>>
>> in the file "INSTALL" with at least the contents (please excuse my
>> gerlish)
>>
>> "btrfs" needs the device "btrfs-control". Perhaps you have to create
>> it:
>>
>>         mknod /dev/btrfs-control c 10 234

>    This should probably go in the problems FAQ [1] on the wiki
> instead, since (a) it's really a problem with your distribution, and
> (b) probably quite rare now that the majority of people are running
> distributions with udev.

Sorry - it's no problem of my distribution; slackware uses udev.

But I run/maintain a very special system, without udev, with most  
modules integrated in the kernel etc. - it's for a special kind of  
servers, not for end user workstations.

And I believe btrfs should run not only for "the majority of people"  
without problems but also for systems which aren't "main stream".

>    What are the symptoms of not having the device node? (i.e. how
> would I diagnose this particular problem?)

Please wait some hours (or days); I'll have to build a test system (I  
won't change my running systems ...).

Viele Gruesse!
Helmut
