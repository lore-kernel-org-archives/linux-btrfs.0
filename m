Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56042 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBKKE6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 05:04:58 -0500
Received: by mail-qa0-f43.google.com with SMTP id o15so11477513qap.30
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 02:04:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
	<pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
Date: Tue, 11 Feb 2014 11:04:57 +0100
Message-ID: <CAJbEPe44PoBQkovMz=-w=A4DYYS2vAVoS+29z7J8Q+xaQrYGXQ@mail.gmail.com>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 February 2014 07:59, Duncan <1i5t5.duncan@cox.net> wrote:
> Saint Germain posted on Tue, 11 Feb 2014 04:15:27 +0100 as excerpted:
>
>> Ok I need to really understand how my motherboard works (new Z87E-ITX).
>> It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
>> UEFI.
>
> I expect it's truly UEFI.  But from what I've read most UEFI based
> firmware(possibly all in theory, with the caveat that there's bugs and
> some might not actually work as intended due to bugs) on x86/amd64 (as
> opposed to arm) has a legacy-BIOS mode fallback.  Provided it's not in
> secure-boot mode, if the storage devices it is presented don't have a
> valid UEFI config, it'll fall back to legacy-BIOS mode and try to detect
> and boot that.
>
> Which may or may not be what your system is actually doing.  As I said,
> since I've not actually experimented with UEFI here, my practical
> knowledge on it is virtually nil, and I don't claim to have studied the
> theory well enough to deduce in that level of detail what your system is
> doing.  But I know that's how it's /supposed/ to be able to work. =:^)
>

Hello Duncan;

Yes I also suspect something like that. Unfortunately it is not really
clear on their website how it works.
You can find a lot of marketing stuff, but not what is really needed
to boot properly !

> (FWIW, what I /have/ done, deliberately, is read enough about UEFI to
> have a general feel for it, and to have been previously exposed to the
> ideas for some time, so that once I /do/ have it available and decide
> it's time, I'll be able to come up to speed relatively quickly as I've
> had the general ideas turning over in my head for quite some time
> already, so in effect I'll simply be reviewing the theory and doing the
> lab work, while concurrently making logical connections about how it all
> fits together that only happen once one actually does that lab work.
> I've discovered over the years that this is perhaps my most effective way
> to learn, read about the general principles while not really
> understanding it the first time thru, then come back to it some months or
> years later, and I pick it up real fast, because my subconscious has been
> working on the problem the whole time! Come to think of it, that's
> actually how I handled btrfs, too, trying it at one point and deciding it
> didn't fit my needs at the time, leaving it for awhile, then coming back
> to it later when my needs had changed, but I already had an idea what I
> was doing from the previous try, with the result being I really took to
> it fast, the second time!  =:^)
>

I'll try to keep that in mind !

>> I understand. Normally the swap will only be used for hibernating. I
>> don't expect to use it except perhaps in some extreme case.
>
> If hibernate is your main swap usage, you might consider the noauto fstab
> option as well, then specifically swapon the appropriate one in your
> hibernate script since you may well need logic in there to figure out
> which one to use in any case.  I was doing that for awhile.
>
> (I've run my own suspend/hibernate scripts based on the documentation in
> $KERNDIR/Documentation/power/*, for years.  The kernel's docs dir really
> is a great resource for a lot of sysadmin level stuff as well as the
> expected kernel developer stuff.  I think few are aware of just how much
> real useful admin-level information it actually contains. =:^)

I am not so used to working without swap. I've worked for year with a
computer with low RAM and a swap and I didn't have any problem (even
when doing some RAM intensive task). So I haven't tried to fix it ;-)
If there is sufficient RAM, I suppose that the the swap doesn't get
used so it is not a problem to let it ?
I've hesitated a long time between ZFS and BTRFS, and one of the case
for ZFS was that it can handle natively swap in its "subvolume" (and
so in theory it can enter in the RAID1 as well). However the folks at
ZFS seem also to consider also swap as a relic of the past. I guess I
will keep it just in case. ;-)

The big problem I currently have is that based on your input, I
hesitate a lot on my partitioning scheme: should I use a dedicated
/boot partition or should I have one global BTRFS partition ?
It is not very clear in the doc (a lof of people used a dedicated
/boot because at that time, grub couldn't natively boot BTRFS it
seems, but it has changed).
Could you recommend a partitioning scheme for a simple RAID1 with 2
identical hard drives (just for home computing, not business).

Many thanks !
