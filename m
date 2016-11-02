Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.knebb.de ([85.25.100.221]:55124 "EHLO mail.knebb.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751752AbcKBKTQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 06:19:16 -0400
Subject: Re: Resizing BTRFS - raw partition
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
 <20161102091249.GL16645@carfax.org.uk>
 <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
 <20161102092926.GM16645@carfax.org.uk> <20161102101446.GB29764@angband.pl>
From: =?UTF-8?Q?Christian_V=c3=b6lker?= <cvoelker@knebb.de>
Message-ID: <f4ed1364-ad00-f8d5-cd6a-e78e4a1943fc@knebb.de>
Date: Wed, 2 Nov 2016 11:16:50 +0100
MIME-Version: 1.0
In-Reply-To: <20161102101446.GB29764@angband.pl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yohoo!

Well, slightly off-topic now.

It is a Debian derivative. Univention Corporate Server.

uname -r says: 4.1.0-ucs190-amd64

So I am pretty fine with the kernel.

But indeed, I have to think about getting a more up-to-date btrfs as I
ran on resizing in the "File too large" issue so I had to use "max"
instead of "+100G". No big deal, just a minor issue.

I use btrfs to checksum all files stored there as I had several issues
the last years where files got corrupted.

Greetings

Christian


Am 02.11.2016 um 11:14 schrieb Adam Borowski:
> On Wed, Nov 02, 2016 at 09:29:26AM +0000, Hugo Mills wrote:
>> On Wed, Nov 02, 2016 at 10:18:03AM +0100, Christian Völker wrote:
>>> thanks for the quick reply. Regarding version- I prefer to use stable
>>> Linux versions....and I am not going to upgrade just btrfs outside of
>>> the verndors builds. So I am stuck happily with this version. And I run
>>> Linux since more than 10years, so I am really fine with it, I guess :D
>>    Well, btrfs-progs 0.19 was last released several years ago. If your
>> kernel is of the same kind of age, then you're going to be seeing a
>> whole load of really nasty data-corrupting or filesystem-breaking bugs
>> which have since been fixed. Basically, if something goes wrong with
>> your FS when you're running a kernel that old, the main rsponse you'll
>> get is, "well, that was silly of you, wasn't it?", and you'll have to
>> make a new filesystem and restore from your backups and hope it
>> doesn't happen again.
> -progs 0.19 imply kernel 2.6.32 which comes from btrfs' infancy, when it
> was hardly merged into mainline.  It's buggier than experimental features
> like RAID5/6 nowadays.
>
>>    I would currently recommend running a 4.4 kernel or later. If you
>> want a "stable" kernel version from a distribution, and want some kind
>> of support for it when it goes wrong, you're probably going to have to
>> pay someone (Red Hat or SuSE, most likely) to support your
>> configuraion.
> Kernels around 3.16 or so are pretty reliable -- ones I'm using on
> production are 3.13 and 3.14, without a single issue.
>
> As 2.6.32 is for you "stable" rather than "ancient and unsupported", I guess
> you're on RHEL or a derivative.  For them, 3.10 is the next stable, which
> is on the verge of what could be reasonable (but I still second Hugo's
> advice of using at least the current LTS kernel, ie 4.4).
>
> TL;DR:
> DO NOT USE BTRFS ON ANCIENT KERNELS!!1!elebenty-one!
>
>
> Meow!

