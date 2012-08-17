Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61041 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2HQEUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Aug 2012 00:20:02 -0400
Received: by wgbdr13 with SMTP id dr13so2994245wgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 21:20:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.wdjl3kx0r07q8e@tron.scheibner.rb>
References: <20120401152749.61790@gmx.net>
	<CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
	<2272893.XFoXOC5Zif@bursa22>
	<op.wdjl3kx0r07q8e@tron.scheibner.rb>
Date: Thu, 16 Aug 2012 21:20:00 -0700
Message-ID: <CAPkEcwjF6pvqySbKGX6tJXb_4k=Z2BLg4OahuH=r6dsSF5ynDg@mail.gmail.com>
Subject: Re: cross-subvolume cp --reflink
From: james northrup <northrup.james@gmail.com>
To: Norbert Scheibner <scno@gmx.net>
Cc: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>,
        Hubert Kario <hka@qbs.com.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dunno if this thread is dead, but im inclined to patch in cp --reflink
to "fdupes" prog.  It  currently does provide a poor-man's dedupe via
md5sum and hardlink, or delete.

all the better if the distro-kernels can backport cross-snapshot
reflinks sooner than later.

On Sun, Apr 29, 2012 at 1:05 PM, Norbert Scheibner <scno@gmx.net> wrote:
> Am 29.04.2012, 01:53 Uhr, schrieb Hubert Kario <hka@qbs.com.pl>:
>
>
>> On Sunday 01 of April 2012 11:42:23 Jérôme Poulin wrote:
>>>
>>> On Sun, Apr 1, 2012 at 11:27 AM, Norbert Scheibner <scno@gmx.net> wrote:
>>> > Some users tested this patch successfully for week,s or months in 2 or
>>> > 3
>>> > kernel versions since then, true?
>>> If this feature must be implented in VFS in another patch, why not
>>> just activate what works and make the future patch disable it again?
>>
>>
>> Why would (should) it be impleemented in VFS? reflink copy is completely
>> different from normal copy and hard link.
>
>
> I wouldn't make a VFS issue out of that. That should be another discussion.
>
> But:
>
>> Subvolumes in btrfs are barriers *only* in btrfs and not visible in VFS.
>
>
> That is just a bug in my opinion, so it should work anyway, but to look at
> it from VFS point of view is strengthening me in wanting the outstanding
> patches integrated, as this feature could be supported by VFS in the future.
>
>
>> IMHO it's strictly btrfs business and not supporting reflink copy between
>> arbitrary directories is a bug.
>
>
> I don't know exactly, but I think ZFS is another candidate for "cp
> --reflink". For some of the log-structured filesystems this could be usefull
> too, but I don't know if some of them already supports this or plan to
> support this in the future.
>
> Greetings
>     Norbert
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
