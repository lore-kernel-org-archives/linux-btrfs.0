Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:36365 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbBEDAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 22:00:19 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so2331608yhl.13
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 19:00:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150205023835.GA23108@hungrycats.org>
References: <CAJCQCtS1cTQqbsYM01baLUmqTXDNE5HZfM-uL8gx0HkHXo-a+A@mail.gmail.com>
	<CAJCQCtQUrfYhiG_Huv+M5w=6bEsvgnY1kUbreO-dANMhCrALbQ@mail.gmail.com>
	<20150205023835.GA23108@hungrycats.org>
Date: Wed, 4 Feb 2015 20:00:18 -0700
Message-ID: <CAJCQCtTdbVOqY0zyCuxSwstZs=MLGVtipw2LStXhRy78HG=8mA@mail.gmail.com>
Subject: Re: paused balance convert from raid1 can no longer be a writeable mount
From: Chris Murphy <lists@colorremedies.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 4, 2015 at 7:38 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Wed, Feb 04, 2015 at 01:53:09PM -0700, Chris Murphy wrote:
>> This is completely reproducible with a brand new file system created
>> as raid1, using kernel 3.19 and btrfs-progs 3.18.
>
> I think you'll find it's reproducible with any kernel after 3.8-rc1
> (circa October 2012).
>
>> The conversion from raid1 to single, if paused, will apparently break
>> the file system's ability to be subsequently mounted writable.
>
> Only if you remove a disk (or one fails).

Conversion is done while degraded, so yes.

> The problem is that one is more than the maximum number of missing devices
> for the single profile, and you are missing one disk, so the filesystem
> gives up.  It doesn't check that all the single chunks are on currently
> present disks.
>
> If you revert commit 292fd7fc39aa06668f3a8db546714e727120cb3e
> you might be able to finish the balance and resume non-degraded read-write
> operation.

Good to know. In my case it's a throw away file system. I guess the
current work around is to not force conversion down to single unless
for sure it won't be interrupted.

I haven't tested it but hopefully conversion of degraded raid1 to
raid10/5/6 can successfully be done. I can see someone with a raid1
say, oh screw it, just add more drives recover to raid5 rather than a
long raid1 rebuild followed by a raid5/6 conversion.


-- 
Chris Murphy
