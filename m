Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37266 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbbDHCG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 22:06:28 -0400
Received: by igblo3 with SMTP id lo3so27633190igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 19:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9s1BW+0n4Mg4_bu-FuCXrxkstawqPy7kQoEf4ySoLAeHA@mail.gmail.com>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<20150407110354.GH13864@carfax.org.uk>
	<CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
	<20150407142030.GK13864@carfax.org.uk>
	<CAK1hC9s6ArS7-2wi-PFA9-RyTJv5T+gtHZ=U2NY-tS24UE3f6g@mail.gmail.com>
	<20150407164010.GL13864@carfax.org.uk>
	<CAJCQCtSK0SB-sLum7Ejb2qjXmB=JmQFHOw6LEk1ahyqZ9kOkSw@mail.gmail.com>
	<CAK1hC9s1BW+0n4Mg4_bu-FuCXrxkstawqPy7kQoEf4ySoLAeHA@mail.gmail.com>
Date: Tue, 7 Apr 2015 20:06:28 -0600
Message-ID: <CAJCQCtT5=EDr9xNV4HbmZWSC6NseryB3SnYnSL9iVOEgcUnzUA@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: Chris Murphy <lists@colorremedies.com>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 11:15 AM, arnaud gaboury
<arnaud.gaboury@gmail.com> wrote:
> On Tue, Apr 7, 2015 at 7:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Tue, Apr 7, 2015 at 10:40 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>    One minor thing -- you've still got nested subvolumes here. You can
>>> still run into the same kinds of management problems (not being able
>>> to use mv efficiently to move subvolumes around). "active" doesn't
>>> need to be a subvolume, it can (and, I'd argue, should) be an ordinary
>>> directory.
>>
>> I agree. Or just incorporate into the naming convention of the
>> subvolume. I've been following a variation on the naming scheme in the
>> "What We Propose" here:
>> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
>
> The server will indeed be a nspawn container with Fedora

There's a recent thread "Recursive subvolume snapshots and deletion?"
about systemd nspawn containers. Those are organized in a nested
fashion, and hence one of the reasons for the recursive snapshot
feature request.

-- 
Chris Murphy
