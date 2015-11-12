Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33363 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbbKLKXs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 05:23:48 -0500
Received: by iouu10 with SMTP id u10so52679987iou.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 02:23:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
References: <56418E5D.9020604@gmx.com>
	<20151110125501.1aa6f155@natsu>
	<5641A7DA.6010102@gmx.com>
	<20151110140855.3ae7297c@natsu>
	<5641B64A.9020606@gmx.com>
	<pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
Date: Thu, 12 Nov 2015 10:23:47 +0000
Message-ID: <CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
Subject: Re: Ideas for btrfs-convert fix(or rework)
From: Vytautas D <vytdau@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ resending as it didnt get through. ]

I got different opinion. btrfs-convert is something that
brought me to btrfs. While there are other bugs to fix, someone
dedicating time to fix btrfs-convert is of high interest to me.
Sending right message to community, might make some rolling distros to
trust it and experiment with it.

Thanks Qu and everyone for great work,
-Vytas

On Tue, Nov 10, 2015 at 10:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Qu Wenruo posted on Tue, 10 Nov 2015 17:18:02 +0800 as excerpted:
>
>> Yes, some problem can be fixed by such balance, as after balance, data
>> and metadata will be relocated to correct new chunks.
>>
>> But there may be a lot of hidden bugs here.
>> And we can't ignore such malfunction just because it's OK under some
>> cases, or btrfs won't really become a production ready filesystem.
>
> Very good point in general, but remember the context we're talking about
> here, btrfs-convert.
>
> Convert is used once, if then, and a lot of generally considered stable
> filesystems get along perfectly fine without direct convert-from-ext*
> tools at all, telling people to either use their ext* as backups and
> restore/copy to their newly created filesystems of whatever new type, or
> backup the data they want to save from the old filesystem, then mkfs them
> directly to the new filesystem type, again, restoring/copying the backed
> up data back from the backups.
>
> And after all, people using anything /other/ than ext* are going to have
> to do that anyway, unless even /more/ work is invested to deal with all
> the /other/ filesystems... all for something that's optionally used once
> and must work well if used, then forgotten about.
>
> So an ext* specific convert tool, while definitely nice to have, remains
> entirely optional, and as such, unlike more critical actual filesystem
> features that will continue to be used as long as the filesystem exists,
> isn't really critical to btrfs becoming a production ready filesystem at
> all, because at some point, if it's still buggy it can simply be thrown
> away.
>
> So a buggy convert tool, being optional, doesn't really affect the
> production readiness of the filesystem as a whole, at all.
>
> Meanwhile, people really considering production readiness, at least in
> the enterprise setting, tend to be a pretty conservative bunch, and I'd
> argue that conservative admins will be unlikely to really trust such a
> conversion tool in any case, preferring to restore from existing
> backups.  I certainly know that /I'd/ have my doubts about trusting my
> data to a convert tool, and would /much/ rather do the copy over to the
> new filesystems thing, since at least that way, if anything goes wrong I
> know I still have the unchanged old copy that was perfectly fine to use
> the day/hour before still there and just as perfectly fine to use again.
> That's not something I'd be confident saying about the if-anything-goes-
> wrong behavior of a convert-in-place tool!
>
> So again, yes, convert is nice to have even if I'd never fully trust them
> myself, but it really doesn't affect the production readiness of the
> filesystem itself.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
