Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33467 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbCZHsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 03:48:31 -0400
Received: by lbcmq2 with SMTP id mq2so34991586lbc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 00:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$dcdc7$373a6425$8154757a$8cf7e564@cox.net>
References: <CAFzWkZGytSfhvx8zts=pwBseua-Hdpp+ZXmDPNLrpwJqhiaU_A@mail.gmail.com>
 <pan$dcdc7$373a6425$8154757a$8cf7e564@cox.net>
From: Anand Patil <anand.prabhakar.patil@gmail.com>
Date: Thu, 26 Mar 2015 00:48:08 -0700
Message-ID: <CAFzWkZHcyTkM-ZBm86bWZDrHfzSV_rtCD5VVeYFtH8tcLWJNMg@mail.gmail.com>
Subject: Re: Metadata about to fill up, how to make it bigger next time?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

Thanks very much, it's very helpful to know this. I do have in the low
thousands of subvolumes now (and as you say, normal usage is fine but
the btrfs management commands take some time). I'll make sure that the
number doesn't get much higher.

Anand

On Wed, Mar 25, 2015 at 10:28 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Anand Patil posted on Wed, 25 Mar 2015 16:45:09 -0700 as excerpted:
>
>> I have a BTRFS filesystem on a 1TB block device, kernel 3.16.2+, tools
>> v3.14_pre20140414. There are many (several thousand) subvolumes, folders
>> and small files.
>
> Sean G answered your immediate question (no, about full metadata doesn't
> mean you're about out of space as long as there's still unallocated space
> left to allocate more metadata chunks from), and he's correct, but the
> bit I quoted above is a potential warning flag of a different nature...
>
> But, that last sentence of the quote can be parsed at least two different
> ways.  Did the "several thousand" refer to subvolumes AND folders AND
> files, or only to subvolumes?
>
> The concern here is that btrfs doesn't scale particularly well to
> thousands of /subvolumes/, and while normal usage shouldn't suffer much,
> btrfs management commands such as btrfs balance and btrfs check, can take
> MUCH longer than they should, with that many subvolumes.
>
> The question of number of subvolumes normally occurs in the context of
> snapshots, since snapshots are a special kind of subvolume.  Ideally,
> you'll want to keep the total number of subvolumes (including snapshots)
> to under 1000, with the number of snapshots of any single subvolume
> limited to 250-ish (say under 300).  However, even just four subvolumes
> being snapshotted to this level will reach the thousand, and 2000-3000
> total isn't /too/ bad as long as it's no more than 250-300 snapshots per
> subvolume.  But DEFINITELY try to keep it under 3000, and preferably
> under 2000, as the scaling really does start to go badly as the number of
> subvolumes increases beyond that.  If you're dealing with 10k subvolumes/
> snapshots, that's too many and you ARE likely to find yourself with
> problems.
>
> (With something like snapper, configuring it for say half-hour or hourly
> snapshots at the shortest time, with twice-daily or daily being more
> reasonable in many circumstances, and then thinning it down to say daily
> after a few days and weekly after four weeks, goes quite a long way
> toward reducing the number of snapshots per subvolume.  Keeping it near
> 250-ish per subvolume is WELL within reason, and considering that a month
> or a year out, you're not likely to /care/ whether it's this hour or
> that, just pick a day or a week and if it's not what you want, go back or
> forward a day or a week, is actually likely to be more practical than
> having hundreds of half-hourly snapshots a year old to choose from.  And
> 250-ish snapshots per subvolume really does turn out to be VERY
> reasonable, provided you're doing reasonable thinning.)
>
> So you can see where "several thousand" subvolumes raised red flags for
> me, even if it's also possible to parse it as only a handful of
> subvolumes, with the rest of the several thousand being directories and
> files.
>
>
> Meanwhile, it's also worth considering your kernel and userspace
> versions.  Kernel 3.16 is a bit behind now, tho not /too/ bad, but I'd
> consider updating to 3.18 or 3.19 pretty soon.  Your userspace, however,
> is much further behind at 3.14.  Generally, it goes like this.  During
> normal runtime, the kernel is most critical as userspace simply relays
> commands to the kernel and it's the kernel code doing the work.  However,
> if something goes wrong and you're running for example btrfs check and/or
> btrfs restore to try to recover your data, THAT is when userspace code
> goes to work and a current userspace with as many of the previous bugs as
> possible patched, can mean the difference between an easy and mostly
> uneventful recovery and unnecessarily losing everything due to a bug
> fixed in the last version or two.
>
> So you definitely want a current btrfs-progs userspace (now 3.19.1 I
> believe, I'm a couple weeks old myself and still have a 3.19-rc) if you
> end up trying to recover, and given that, you might as well be running it
> routinely, as well.  And you definitely want a pretty current kernel as
> well, tho hanging one back (to 3.18 now, since 3.19 is current and 4.0
> aka 3.20 is in development) and paying attention to the list to see if
> there's any unfixed bugs in the new version before updating has proven
> useful with a couple kernels, recently.
>
> Which means your 3.16 kernel is a bit dated, and your 3.14-pre userspace
> is QUITE dated.  You really should consider updating, at least your
> userspace, before you find you need it for recovery.  And the kernel too,
> as soon as convenient, tho that's less critical for the moment as while
> moderately outdated, it's a couple kernel/userspace development cycles
> newer newer than your userspace.
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
