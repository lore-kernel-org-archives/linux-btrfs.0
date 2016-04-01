Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36508 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcDATUy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 15:20:54 -0400
Received: by mail-lb0-f174.google.com with SMTP id qe11so77595754lbc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 12:20:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160401165012.GM9342@torres.zugschlus.de>
References: <20160401134029.GH9342@torres.zugschlus.de>
	<CAPmG0jY7qftBouGb=g6RC5MTS4qjmAx2S=95p=Fpqqr35bk_eA@mail.gmail.com>
	<20160401163020.GL9342@torres.zugschlus.de>
	<20160401165012.GM9342@torres.zugschlus.de>
Date: Fri, 1 Apr 2016 21:20:52 +0200
Message-ID: <CAPmG0jZVcer1dyqNeJx8FmQRXqC9vqQrcFv2e3wzGJD+uZkqLA@mail.gmail.com>
Subject: Re: Another ENOSPC situation
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2016 at 6:50 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Fri, Apr 01, 2016 at 06:30:20PM +0200, Marc Haber wrote:
>> On Fri, Apr 01, 2016 at 05:44:30PM +0200, Henk Slager wrote:
>> > On Fri, Apr 1, 2016 at 3:40 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
>> > > btrfs balance -mprofiles seems to do something. one kworked and one
>> > > btrfs-transaction process hog one CPU core each for hours, while
>> > > blocking the filesystem for minutes apiece, which leads to the host
>> > > being nearly unuseable up to the point of "clock and mouse pointer
>> > > frozen for nearly ten minutes".
>> >
>> > I assume you still have your every 10 minutes snapshotting running
>> > while balancing?
>>
>> No, I disabled the cronjob before trying the balance. I might be
>> crazy, but not stup^wunexperienced.
>
> That being said, I would still expect the code not to allow _this_
> kind of effect on the entire system when two alledgely incompatible
> operations run simultaneously. I mean, Linux is a multi-user,
> multi-tasking operating system where one simply cannot expect all
> processes to be cooperative to each other. We have the operating
> systems to prevent this kind of issues, not to cause them.

Maybe look at it differently: Does user mh have trouble using this
laptop w.r.t. storing files?

In openSUSE Tumbleweed (the snapshot from end of march), root access
is needed to change the default snapshotting config, otherwise you
will have a 10 year history. After that change has been done according
to needs of the user, there is no need to run manual balance.
