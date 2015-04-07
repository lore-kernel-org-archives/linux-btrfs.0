Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36736 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbbDGRPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 13:15:07 -0400
Received: by lbbqq2 with SMTP id qq2so39224747lbb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 10:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSK0SB-sLum7Ejb2qjXmB=JmQFHOw6LEk1ahyqZ9kOkSw@mail.gmail.com>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<20150407110354.GH13864@carfax.org.uk>
	<CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
	<20150407142030.GK13864@carfax.org.uk>
	<CAK1hC9s6ArS7-2wi-PFA9-RyTJv5T+gtHZ=U2NY-tS24UE3f6g@mail.gmail.com>
	<20150407164010.GL13864@carfax.org.uk>
	<CAJCQCtSK0SB-sLum7Ejb2qjXmB=JmQFHOw6LEk1ahyqZ9kOkSw@mail.gmail.com>
Date: Tue, 7 Apr 2015 19:15:05 +0200
Message-ID: <CAK1hC9s1BW+0n4Mg4_bu-FuCXrxkstawqPy7kQoEf4ySoLAeHA@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 7:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Apr 7, 2015 at 10:40 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>    One minor thing -- you've still got nested subvolumes here. You can
>> still run into the same kinds of management problems (not being able
>> to use mv efficiently to move subvolumes around). "active" doesn't
>> need to be a subvolume, it can (and, I'd argue, should) be an ordinary
>> directory.
>
> I agree. Or just incorporate into the naming convention of the
> subvolume. I've been following a variation on the naming scheme in the
> "What We Propose" here:
> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html

The server will indeed be a nspawn container with Fedora

> which is more intended for stateless systems. I add a field at the end
> :current vs :date where :date is yyyymmdd with an optional -X sequence
> in case there's more than one snapshot per day.
>
>
> --
> Chris Murphy



-- 

google.com/+arnaudgabourygabx
