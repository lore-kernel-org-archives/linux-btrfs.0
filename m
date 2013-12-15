Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:38729 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LOCfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 21:35:54 -0500
Received: by mail-vb0-f54.google.com with SMTP id g10so2328114vbg.13
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 18:35:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
Date: Sun, 15 Dec 2013 03:35:53 +0100
Message-ID: <CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have done some more testing. I turned off everything using the disk
and only did defrag. I have created a script that gives me a list of
the files with the most extents. I started from the top to improve the
fragmentation of the worst files. The most fragmentet file was a file
of about 32GB with over 250 000 extents!
It seems that I can defrag a two to three largish (15-30GB) ~100 000
extents files just fine, but after a while the system locks up (not a
complete hard lock, but everythings hangs and a restart is necessary
to get a fully working system again)

It seems like defrag operations is triggering the issue. Probably in
combination with the large and heavily fragmentet files.

I have slowly managed to defragment the most fragmented files,
rebooting 4 times, so one of the worst files now is this one:

# filefrag vide01.mkv
vide01.mkv: 77810 extents found
# lsattr vide01.mkv
---------------- vide01.mkv

All the large fragmented files are ordinary mkv-files (video). The
reason for the heavy fragmentation was that perhaps 50 to 100 files
were written at the same time over a period of several days, with lots
of other activity going on as well. No problem for the system as it
was network limited most of the time.
Although defrag alone can trigger blocking, so can also straight rsync
from another internal 1000 MB/s continous reads internal array
combined with some random activity. It seems that the cause is just
heavy IO. Is it possible that even though I have seemingly lots of
space free in measured MBytes, that it is all so fragmented that btrfs
can't allocate space efficiently enough? Or would that give other
errors?

I actually downgraded from kernel 3.13-rc2 because of not being able
to do anything else if copying between the internal arrays without
btrfs hanging, although seemingly just temporarily and not as bad as
the defrag blocking.

I will try to free up some space before running more defrag too, just
to check if that is the issue.

Mvh

Hans-Kristian Bakke


On 15 December 2013 02:59, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Dec 14, 2013, at 5:28 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
>
>> When I look at the entire FS with df-like tools it is reported as
>> 89.4% used (26638.65 of 29808.2 GB). But this is shared amongst both
>> data and metadata I guess?
>
> Yes.
>
>>
>> I do know that ~90%+ seems full, but it is still around 3TB in my
>> case! Are the "percentage rules" of old times still valid with modern
>> disk sizes?
>
> Probably not. But you also reported rather significant fragmentation. And it's also still an experimental file system when not ~ 90% full. I think it's fair to say that this level of fullness is a less tested use case.
>
>
>
>> It seems extremely inconvenient that a filesystem like
>> btrfs is starting to misbehave at "only" 3TB available space for
>> RAID10 mirroring and metadata, which is probably a little bit over 1TB
>> actual filestorage counting everything in.
>
> I'm not suggesting the behavior is either desired or expected, but certainly blocking is better than an oops or a broken file system, and in the not too distant past such things have happened on full volumes. Given the level of fragmentation this behavior might be expected at the current state of development, for all I know.
>
> But if you care about this data, I'd take the blocking as a warning to back off on this usage pattern, unless of course you're intentionally trying to see at what point it breaks and why.
>
>>
>> I would normally expect that there is no difference in 1TB free space
>> on a FS that is 2TB in total, and 1TB free space on a filesystem that
>> is 30TB in total, other than my sense of urge and that you would
>> probably expect data growth to be more rapid on the 30TB FS as there
>> is obviously a need to store a lot of stuff.
>
> Seems reasonable.
>
>
>> Is "free space needed" really a different concept dependning on the
>> size of your FS?
>
> Maybe it depends more on the size and fragmentation of the files being access, and of remaining free space.
>
> Can you do an lsattr on these 25GB files that you say have ~ 100,000 extents? And what are these files?
>
>
>
> Chris Murphy
