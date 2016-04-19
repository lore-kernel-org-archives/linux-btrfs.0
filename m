Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34322 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbcDSLOl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 07:14:41 -0400
Received: by mail-io0-f196.google.com with SMTP id z133so2102317iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 04:14:40 -0700 (PDT)
Subject: Re: Install to or Recover RAID Array Subvolume Root?
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
 <5714D39B.90402@gmail.com>
 <CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
 <5714FA2F.6010207@gmail.com>
 <CAJCQCtTSdnD+n9UR7hWtqLdBzjb6WQXF71XKTgKJNgZPcdA3fg@mail.gmail.com>
 <571502B4.2050401@gmail.com>
 <CAD=QJKjhYoMOKkB1GA5EWONHifeBUpVH9-WgL9R_PozS+o+PLw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5716130F.9050006@gmail.com>
Date: Tue, 19 Apr 2016 07:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjhYoMOKkB1GA5EWONHifeBUpVH9-WgL9R_PozS+o+PLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-18 16:34, Nicholas D Steeves wrote:
> On 18 April 2016 at 11:52, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>> On 2016-04-18 11:39, Chris Murphy wrote:
>>>
>>> On Mon, Apr 18, 2016 at 9:15 AM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>> Like I said in one of my earlier e-mails though, these kind of limitations
>> are part of why I switched to Gentoo, there's no GUI installer, but you can
>> put the system together however the hell you want (which is especially nice
>> with BTRFS, because none of the installers out there will let you use BTRFS
>> on top of LVM, which is useful for things like BTRFS raid1 on top of
>> DM-RAID0).
>
> Limitations?  ;-)  Debian has a variety of bootstrapping methods,
> though I forget if they're more analogous to starting a Gentoo
> installation from stage2 or stage3...I haven't used Gentoo since 2002.
> Please consult the following doc for one of the methods:
> https://www.debian.org/releases/stable/amd64/apds03.html.en
The closest I've ever seen for Debian to a Gentoo stage3 installation 
(the developers discourage usage of stage2 installs these days unless 
you're bootstrapping _everything_ yourself) is debbootstrap, and I could 
never get that to work reliably.

FWIW, the installer wasn't the only reason I switched to Gentoo, the two 
bigger ones for me were wanting newer software versions and needing 
different sets of features enabled on packages than the default builds, 
I ended up switching at the point that I was building more locally than 
I was installing from the repositories.
