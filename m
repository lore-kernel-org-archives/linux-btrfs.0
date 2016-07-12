Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36235 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964775AbcGLPeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 11:34:12 -0400
Received: by mail-io0-f179.google.com with SMTP id b62so19838328iod.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 08:34:12 -0700 (PDT)
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
 <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
 <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
 <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
 <e6f35e35-f2bd-03f6-5544-4fb8fa527042@gmail.com>
 <CAJCQCtQvp8p71Uwv2x-Sag+1W=T9wKWn4YckKSYyqrbjdOYQcQ@mail.gmail.com>
 <3e97fc5d-74ab-b1bc-1556-32ddd8d2ba8f@gmail.com>
 <CAJCQCtSrwFwhFhZo6CrEyCgsj3LATqLYu2uOwyOORP3KUazK=Q@mail.gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f5af09d8-05d6-5815-58c0-cdbe8cda9453@gmail.com>
Date: Tue, 12 Jul 2016 11:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSrwFwhFhZo6CrEyCgsj3LATqLYu2uOwyOORP3KUazK=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-11 17:07, Chris Murphy wrote:
> On Fri, Jul 8, 2016 at 6:24 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> To clarify, I'm not trying to argue against adding support, I'm arguing
>> against it being mandatory.
>
> By "D-Bus support" I did not mean to indicate mandating it, just that
> it would be one possible way to get some very basic state change
> messages to user space tools so we're doing the least amount of wheel
> reinvention as possible.
Minimizing the amount of work would be good, but I would not agree about 
D-Bus doing that.  It's easy to debug socket based IPC, it's not easy to 
debug D-Bus based IPC.  From a development perspective, I'd say we need 
to get something working with sockets first, and then worry about D-Bus 
once we have working infrastructure and abstraction for IPC.
>
>
>>  A filesystem which requires specific system
>> services to be running just for regular maintenance tasks is not a well
>> designed filesystem.  To be entirely honest, I'm not all that happy about
>> the functional dependency on udev to have device discovery, but there's no
>> point in me arguing about that...
>
> Well everything else that came before it is effectively deprecated, so
> there's no going back. The way forward would be to get udev more
> granular state information about a Btrfs volume than 0 and 1.
People still use other options, usually in embedded systems, but options 
do exist and are used.

That said, I couldn't agree more about reporting more info about the 
state of the FS, but I still feel that scanning on device connection is 
not a good thing with the way things are currently designed in the 
kernel, not just the binary state reporting.
>
>>
>> Just thinking aloud, but why not do a daemon that does the actual
>> monitoring, and then provide an interface (at least a UNIX domain socket,
>> and optionally a D-Bus endpoint) that other tools can use to query
>> filesystem status.  LVM already has a similar setup for monitoring DM-RAID
>> volumes, snapshots, and thin storage pools, although it's designed as an
>> event driven tool that does something when specific things happen (for
>> example, possibly auto-extending snapshots when they start to get full).
>
> That would be consistent with mdadm --monitor and dmeventd, but it is
> yet another wheel reinvention at the lower level, which then also
> necessitates higher level things to adapt to that interface. It would
> be neat if there could be some unification and consistency.
>
A consistent external API would be a good thing, but I'm not sure if 
unifying the internal design would be.  Trying to unify handling in an 
external project would make things less reliable, not more reliable, 
because

