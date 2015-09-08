Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32901 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbbIHUeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:34:15 -0400
Received: by wiclk2 with SMTP id lk2so134000843wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 13:34:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150908202839.GO23944@carfax.org.uk>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk> <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
 <CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
 <CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com>
 <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
 <CAA85sZueV2NuTeUdvWjEJKc8L1u6h7Tbdne0vPtd75zxshPBgw@mail.gmail.com>
 <CAJCQCtSz7YAEyTGtga73Ze29qtsgDCHLsrsWtqP_-r4YwhxhEA@mail.gmail.com> <20150908202839.GO23944@carfax.org.uk>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Tue, 8 Sep 2015 22:33:54 +0200
Message-ID: <CAA85sZt+xsE9i7-kWtm-Mt2jb=voUG4vt40rnY7oTMDOYrcnSw@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Ian Kumlien <ian.kumlien@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2015 at 22:28, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Sep 08, 2015 at 02:17:55PM -0600, Chris Murphy wrote:
>> On Tue, Sep 8, 2015 at 2:13 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
>> > On 8 September 2015 at 22:08, Chris Murphy <lists@colorremedies.com> wrote:
>> >> On Tue, Sep 8, 2015 at 2:00 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:

[--8<--]

>> > -o degraded should allow readwrite *IF* the data can be written to....
>> > My question is also, would this keep me from "adding devices"?
>> > I mean, it did seem like a catch 22 earlier, but that would really
>> > make a mess of things...
>>
>> It is not possible to add a device to an ro filesystem, so effectively
>> the fs read-writeability is broken in this case.
>
>    I thought this particular issue had already been dealt with in 4.2?
> (i.e. you can still mount an FS RW if it's degraded, but there are
> still some single chunks on it).

Single chunks are only on sda - not on sdb...

There should be no problem...

>    Ian: If you can still mount the FS read/write with both devices in
> it, then it might be worth trying to balance away the problematic
> single chunks with:
>
> btrfs bal start -dprofiles=single -mprofiles=single /mountpoint
>
>    Then unmount, pull the dead drive, and remount -odegraded.

It never completes, too many errors and eventually the disk disappears
until the machine is turned off and on again... (normal disk reset
doesn't work)
