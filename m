Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35377 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964829AbcCIX2B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 18:28:01 -0500
Received: by mail-io0-f175.google.com with SMTP id g203so85755311iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 15:28:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160309214527.GH14112@merlins.org>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<20160309211004.GK27437@merlins.org>
	<CAJCQCtRDGvxgktjQ8zduHAxh=6TvNsnEa9tz75NUvsj-SwsJ9A@mail.gmail.com>
	<20160309214527.GH14112@merlins.org>
Date: Wed, 9 Mar 2016 18:28:00 -0500
Message-ID: <CAGfcS_=1TNV=SWGwHSwqJn4943iCHNNpB=xeuK7FeS7YWg=reQ@mail.gmail.com>
Subject: Re: btrfs and containers
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Tobias Hunger <tobias.hunger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 9, 2016 at 4:45 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Mar 09, 2016 at 02:21:26PM -0700, Chris Murphy wrote:
>> > I have a very stripped down docker image that actually mounts portion of
>> > of my root filesystem read only.
>> > While it's running out of a btrfs filesystem, you can't run btrfs
>> > commands against it:
>> > 05233e5c91f0:/# btrfs fi show
>> > 05233e5c91f0:/# btrfs subvol list /
>> > ERROR: can't perform the search - Operation not permitted
>> > 05233e5c91f0:/# btrfs subvol list .
>> > ERROR: can't perform the search - Operation not permitted
>> >
>> > I didn't do anything special, it's just working that way.
>>
>> Yep, you're not using --privileged in which case you can't list
>> things. But I'm not sure what the equivalent is off hand with
>> systemd-nspawn containers, I think those may always be privileged?
>
> Ok, cool. I just used docker out of the box, glad to know it errs on
> the secure side by default.
> (and I don't have systemd, so that may also help me there)
>

I'm sure the default capability list for systemd-nspawn and docker is
different.  I know that you can tune nspawn to give the container
whatever capabilities you want it to.  In general though a general
warning is that linux containers are still not quite 100% secure when
root is running inside.  Obviously the fewer capabilities you give
them the better, but the level of isolation isn't quite to VM levels.
It is better than chroot levels, however.
