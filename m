Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:65259 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaF2WWw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 18:22:52 -0400
Received: by mail-la0-f52.google.com with SMTP id ty20so4269070lab.39
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 15:22:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
	<3081460.dX0cLeJPhK@quad>
	<CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>
Date: Sun, 29 Jun 2014 17:22:49 -0500
Message-ID: <CAPoQQ-1CfL7HrzO2Zgv9SjkLbRNiuZJpMRgWG3Pz9Fd6bnDwoA@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Cody P Schafer <dev@codyps.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 29, 2014 at 3:02 PM, Cody P Schafer <dev@codyps.com> wrote:
> On Fri, Jun 27, 2014 at 7:22 PM, Chris Samuel <chris@csamuel.org> wrote:
>> On Fri, 27 Jun 2014 05:20:41 PM Duncan wrote:
>>
>>> If I'm not mistaken the fix for the 3.16 series bug was:
>>>
>>> ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>>>
>>> Btrfs: fix deadlocks with trylock on tree nodes.
>>
>> That patch applies cleanly to 3.15.2 so if it is indeed the fix it should
>> probably go to -stable for the next 3.15 release..
>>
>> Unfortunately my test system died a while ago (hardware problem) and I've not
>> been able to resurrect it yet.
>
> I'm also seeing stuck tasks on btrfs (3.14.4, 3.15.1, 3.15.2).
> I've also tried 3.15.2 with ea4ebde02e08558b020c4b61bb9a4c applied on
> top with similar results.
> I've been triggering the hang with 'rsync -hPaHAXx --del /mnt/home/a/
> /home/a/' where /mnt/home and /home are 2 separate btrfs filesystems
> on 2 separate disks.
>
> dmesg with w-trigger: http://bpaste.net/show/419555/ (3.15.2 + ea4ebde)

And here's the same thing but with lockdep enabled (in the hope that
that info might be useful)
http://bpaste.net/show/419899/
