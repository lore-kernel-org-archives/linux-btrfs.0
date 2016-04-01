Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35351 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbcDAXji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 19:39:38 -0400
Received: by mail-lf0-f48.google.com with SMTP id k79so92715827lfb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 16:39:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160401204043.GN9342@torres.zugschlus.de>
References: <20160401134029.GH9342@torres.zugschlus.de>
	<CAPmG0jY7qftBouGb=g6RC5MTS4qjmAx2S=95p=Fpqqr35bk_eA@mail.gmail.com>
	<20160401163020.GL9342@torres.zugschlus.de>
	<20160401165012.GM9342@torres.zugschlus.de>
	<CAPmG0jZVcer1dyqNeJx8FmQRXqC9vqQrcFv2e3wzGJD+uZkqLA@mail.gmail.com>
	<20160401204043.GN9342@torres.zugschlus.de>
Date: Sat, 2 Apr 2016 01:39:36 +0200
Message-ID: <CAPmG0jZAmWYD+rSJL1S2MDN97jka8NwVijd4ohZDAvvSk32PpQ@mail.gmail.com>
Subject: Re: Another ENOSPC situation
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2016 at 10:40 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Fri, Apr 01, 2016 at 09:20:52PM +0200, Henk Slager wrote:
>> On Fri, Apr 1, 2016 at 6:50 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
>> > On Fri, Apr 01, 2016 at 06:30:20PM +0200, Marc Haber wrote:
>> >> On Fri, Apr 01, 2016 at 05:44:30PM +0200, Henk Slager wrote:
>> >> > On Fri, Apr 1, 2016 at 3:40 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
>> >> > > btrfs balance -mprofiles seems to do something. one kworked and one
>> >> > > btrfs-transaction process hog one CPU core each for hours, while
>> >> > > blocking the filesystem for minutes apiece, which leads to the host
>> >> > > being nearly unuseable up to the point of "clock and mouse pointer
>> >> > > frozen for nearly ten minutes".
>> >> >
>> >> > I assume you still have your every 10 minutes snapshotting running
>> >> > while balancing?
>> >>
>> >> No, I disabled the cronjob before trying the balance. I might be
>> >> crazy, but not stup^wunexperienced.
>> >
>> > That being said, I would still expect the code not to allow _this_
>> > kind of effect on the entire system when two alledgely incompatible
>> > operations run simultaneously. I mean, Linux is a multi-user,
>> > multi-tasking operating system where one simply cannot expect all
>> > processes to be cooperative to each other. We have the operating
>> > systems to prevent this kind of issues, not to cause them.
>>
>> Maybe look at it differently: Does user mh have trouble using this
>> laptop w.r.t. storing files?
>
> No. I would have cried murder otherwise.
>
>> In openSUSE Tumbleweed (the snapshot from end of march), root access
>> is needed to change the default snapshotting config, otherwise you
>> will have a 10 year history. After that change has been done according
>> to needs of the user, there is no need to run manual balance.
>
> So you are saying the balancing a filesystem should never be
> necessary? Or what are you trying to say?

There is a package  bbtrfsmaintenance  which does balancing for the
user after it is configured by root according to user's wishes and
needs.

Key thing I want to say is that you should change you snapshotting
rate and/or policy. It has been hinted before and it is more a
psychological issue than technical I think.
