Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33706 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbeA3UkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 15:40:19 -0500
Received: by mail-io0-f179.google.com with SMTP id n7so12922307iob.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 12:40:18 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
 <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
 <f8f72b3e-e0c0-cccb-a52a-8c8568e103ba@dirtcellar.net>
 <c6b6bb8c-b4ea-07f9-400f-39d8de9c0be9@gmail.com>
 <20180130195000.GA21701@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <31eb3a0f-c8e2-10b3-4edb-f0005ff88e24@gmail.com>
Date: Tue, 30 Jan 2018 15:40:13 -0500
MIME-Version: 1.0
In-Reply-To: <20180130195000.GA21701@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-30 14:50, Tomasz Pala wrote:
> On Tue, Jan 30, 2018 at 08:46:32 -0500, Austin S. Hemmelgarn wrote:
> 
>>> I personally think the degraded mount option is a mistake as this
>>> assumes that a lightly degraded system is not able to work which is false.
>>> If the system can mount to some working state then it should mount
>>> regardless if it is fully operative or not. If the array is in a bad
>>> state you need to learn about it by issuing a command or something. The
>>> same goes for a MD array (and yes, I am aware of the block layer vs
>>> filesystem thing here).
>> The problem with this is that right now, it is not safe to run a BTRFS
>> volume degraded and writable, but for an even remotely usable system
> 
> Mounting read-only is still better than not mounting at all.
Agreed, but what most people who are asking about this are asking for is 
to have the system just run missing a drive.
> 
> For example, my emergency.target has limited network access and starts
> ssh server so I could recover from this situation remotely.
> 
>> with pretty much any modern distro, you need your root filesystem to be
>> writable (or you need to have jumped through the hoops to make sure /var
>> and /tmp are writable even if / isn't).
> 
> Easy to handle by systemd. Not only this, but much more is planned:
> 
> http://0pointer.net/blog/projects/stateless.html
> 
It's reasonably easy to handle even in a normal init system.  The issue 
is that most distros don't really support it well.  Arch and Gentoo make 
it trivial, but they let you configure storage however the hell you 
want.  Pretty much everybody else is mostly designed to assume that /var 
is a part of /, they mostly work if it's not, but certain odd things 
cause problems, and you have to go through somewhat unfriendly 
configuration work during install to get a system set up that way (well, 
unfriendly if you're a regular user, it's perfectly fine for a seasoned 
sysadmin).

Also, slightly OT, but has anyone involved in the development described 
in the article you linked every looked beyond the typical Fedora/Debian 
environment for any of the stuff the conclusions section says you're 
trying to achieve?  Just curious, since NixOS can do almost all of it 
with near zero effort except for the vendor data part (NixOS still 
stores it's config in /etc, but it can work with just one or two files), 
and a handful of the other specific items have reasonably easy ways to 
implement them that just aren't widely supported (for example, factory 
resets have at least three options already, OverlayFS (bottom layer is 
your base image, stored in a read-only verified manner, top layer is 
writable for user customization), BTRFS seed devices (similar to an 
overlay, just at the block level), and bootable, self-installing, 
compressed system images).
