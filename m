Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:55778 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbeA2TA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 14:00:57 -0500
Received: by mail-it0-f49.google.com with SMTP id c16so9583784itc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 11:00:57 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
Date: Mon, 29 Jan 2018 14:00:53 -0500
MIME-Version: 1.0
In-Reply-To: <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-29 12:58, Andrei Borzenkov wrote:
> 29.01.2018 14:24, Adam Borowski пишет:
> ...
>>
>> So any event (the user's request) has already happened.  A rc system, of
>> which systemd is one, knows whether we reached the "want root filesystem" or
>> "want secondary filesystems" stage.  Once you're there, you can issue the
>> mount() call and let the kernel do the work.
>>
>>> It is a btrfs choice to not expose compound device as separate one (like
>>> every other device manager does)
>>
>> Btrfs is not a device manager, it's a filesystem.
>>
>>> it is a btrfs drawback that doesn't provice anything else except for this
>>> IOCTL with it's logic
>>
>> How can it provide you with something it doesn't yet have?  If you want the
>> information, call mount().  And as others in this thread have mentioned,
>> what, pray tell, would you want to know "would a mount succeed?" for if you
>> don't want to mount?
>>
>>> it is a btrfs drawback that there is nothing to push assembling into "OK,
>>> going degraded" state
>>
>> The way to do so is to timeout, then retry with -o degraded.
>>
> 
> That's possible way to solve it. This likely requires support from
> mount.btrfs (or btrfs.ko) to return proper indication that filesystem is
> incomplete so caller can decide whether to retry or to try degraded mount.
We already do so in the accepted standard manner.  If the mount fails 
because of a missing device, you get a very specific message in the 
kernel log about it, as is the case for most other common errors (for 
uncommon ones you usually just get a generic open_ctree error).  This is 
really the only option too, as the mount() syscall (which the mount 
command calls) returns only 0 on success or -1 and an appropriate errno 
value on failure, and we can't exactly go about creating a half dozen 
new error numbers just for this (well, technically we could, but I very 
much doubt that they would be accepted upstream, which defeats the purpose).
> 
> Or may be mount.btrfs should implement this logic internally. This would
> really be the most simple way to make it acceptable to the other side by
> not needing to accept anything :)
And would also be another layering violation which would require a 
proliferation of extra mount options to control the mount command itself 
and adjust the timeout handling.

This has been done before with mount.nfs, but for slightly different 
reasons (primarily to allow nested NFS mounts, since the local directory 
that the filesystem is being mounted on not being present is treated 
like a mount timeout), and it had near zero control.  It works there 
because they push the complicated policy decisions to userspace (namely, 
there is no support for retrying with different options or trying a 
different server).

With what you're proposing for BTRFS however, _everything_ is a 
complicated decision, namely:
1. Do you retry at all?  During boot, the answer should usually be yes, 
but during normal system operation it should normally be no (because we 
should be letting the user handle issues at that point).
2. How long should you wait before you retry?  There is no right answer 
here that will work in all cases (I've seen systems which take multiple 
minutes for devices to become available on boot), especially considering 
those of us who would rather have things fail early.
3. If the retry fails, do you retry again?  How many times before it 
just outright fails?  This is going to be system specific policy.  On 
systems where devices may take a while to come online, the answer is 
probably yes and some reasonably large number, while on systems where 
devices are known to reliably be online immediately, it makes no sense 
to retry more than once or twice.
4. If you are going to retry, should you try a degraded mount?  Again, 
this is going to be system specific policy (regular users would probably 
want this to be a yes, while people who care about data integrity over 
availability would likely want it to be a no).
5. Assuming you do retry with the degraded mount, how many times should 
a normal mount fail before things go degraded?  This ties in with 3 and 
has the same arguments about variability I gave there.
6. How many times do you try a degraded mount before just giving up? 
Again, similar variability to 3.
7. Should each attempt try first a regular mount and then a degraded 
one, or do you try just normal a couple times and then switch to 
degraded, or even start out trying normal and then start alternating? 
Any of those patterns has valid arguments both for and against it, so 
this again needs to be user configurable policy.

Altogether, that's a total of 7 policy decisions that should be user 
configurable.  Having a config file other than /etc/fstab for the mount 
command should probably be avoided for sanity reasons (again, BTRFS is a 
filesystem, not a volume manager), so they would all have to be handled 
through mount options.  The kernel will additionally have to understand 
that those options need to be ignored (things do try to mount 
filesystems without calling a mount helper, most notably the kernel when 
it mounts the root filesystem on boot if you're not using an initramfs). 
  All in all, this type of thing gets out of hand _very_ fast.
