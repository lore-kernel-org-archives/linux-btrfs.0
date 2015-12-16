Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36290 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbLPEFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 23:05:19 -0500
Received: by mail-qk0-f176.google.com with SMTP id t125so46702415qkh.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 20:05:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABRuA+hhvykxErKocd9oiX6d+PvGmmAF8tJdMxFr6xovSfw9kQ@mail.gmail.com>
References: <E3AE2CD5-D3F1-48CF-9C5E-092DDF41AF3A@neb.com>
	<CABRuA+is8wdP_6RFr+VmFMjXsNTVosRavuEvzR0RhbFxpoa=ZQ@mail.gmail.com>
	<CABRuA+hhvykxErKocd9oiX6d+PvGmmAF8tJdMxFr6xovSfw9kQ@mail.gmail.com>
Date: Tue, 15 Dec 2015 23:05:18 -0500
Message-ID: <CABRuA+iHMEbm7+YgAHwyahSywx1w-EeQewmA1beawH7XdbQzFg@mail.gmail.com>
Subject: Re: need to recover large file
From: Michael Darling <darlingm@gmail.com>
To: "Langhorst, Brad" <Langhorst@neb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

... Didn't read all of your original post originally, because I
haven't been into those internals.  Now that I have, I see it seems to
be using 6 devices, so you might have to use 1 hard drive 6*size of
partition (others can say if this will work), or 6 other hard drives
to make the backups.  Although, I'm not sure what raid configuration
there may be, which could reduce the number of copies you had to make.

On Tue, Dec 15, 2015 at 10:59 PM, Michael Darling <darlingm@gmail.com> wrote:
>
> Or, even better yet, just unplug the drive completely and let someone more knowledgeable with btrfs say my dd suggestion works, as long as you don't mount either when they're both plugged in.  I know the urge to just work on something, but bad recovery attempts can make recoverable data lost forever.
>
> On Tue, Dec 15, 2015 at 10:56 PM, Michael Darling <darlingm@gmail.com> wrote:
>>
>> First thing first, if the file is as important as it sounds like.  Since there's no physical problem with the hard drive, go get (or if you have one laying around, use) another hard drive that is at least as big as the partition that file was on.  Then completely unmount the original partition.  Do a dd copy of the entire partition it was on.
>>
>> Then DO NOT mount either partition.  You do NOT want to mount a btrfs partition when there's a dd clone hooked up, because the UUID's are the same on both.
>>
>> Turn off the machine, pull the new backup copy, then go back to work on recovery attempts.  If recovery goes wrong, restore the fresh backup copy by another dd.  Make sure again to NOT mount either while more than one copy is plugged in.
>>
