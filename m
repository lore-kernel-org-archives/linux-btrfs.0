Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47712 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753152AbeA3PYT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 10:24:19 -0500
Date: Tue, 30 Jan 2018 16:24:16 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130152415.GC7126@polanet.pl>
References: <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
 <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 14:00:53 -0500, Austin S. Hemmelgarn wrote:

> We already do so in the accepted standard manner.  If the mount fails 
> because of a missing device, you get a very specific message in the 
> kernel log about it, as is the case for most other common errors (for 
> uncommon ones you usually just get a generic open_ctree error).  This is 
> really the only option too, as the mount() syscall (which the mount 
> command calls) returns only 0 on success or -1 and an appropriate errno 
> value on failure, and we can't exactly go about creating a half dozen 
> new error numbers just for this (well, technically we could, but I very 
> much doubt that they would be accepted upstream, which defeats the purpose).

This is exacly why the separate communication channel being the ioctl is
currently used. And I really don't understand why do you fight against
expanding this ioctl response.

> With what you're proposing for BTRFS however, _everything_ is a 
> complicated decision, namely:
> 1. Do you retry at all?  During boot, the answer should usually be yes, 
> but during normal system operation it should normally be no (because we 
> should be letting the user handle issues at that point).

This is exactly why I propose to introduce ioctl in btrfs.ko that
accepts userspace-configured (as per-volume policy) expectations.

> 2. How long should you wait before you retry?  There is no right answer 
> here that will work in all cases (I've seen systems which take multiple 
> minutes for devices to become available on boot), especially considering 
> those of us who would rather have things fail early.

btrfs-last-resort@.timer per analogy to mdadm-last-resort@.timer

> 3. If the retry fails, do you retry again?  How many times before it 
> just outright fails?  This is going to be system specific policy.  On 
> systems where devices may take a while to come online, the answer is 
> probably yes and some reasonably large number, while on systems where 
> devices are known to reliably be online immediately, it makes no sense 
> to retry more than once or twice.

All of this is systemd timer/service job.

> 4. If you are going to retry, should you try a degraded mount?  Again, 
> this is going to be system specific policy (regular users would probably 
> want this to be a yes, while people who care about data integrity over 
> availability would likely want it to be a no).

Just like above - user-configured in systemd timers/services easily.

> 5. Assuming you do retry with the degraded mount, how many times should 
> a normal mount fail before things go degraded?  This ties in with 3 and 
> has the same arguments about variability I gave there.

As above.

> 6. How many times do you try a degraded mount before just giving up? 
> Again, similar variability to 3.
> 7. Should each attempt try first a regular mount and then a degraded 
> one, or do you try just normal a couple times and then switch to 
> degraded, or even start out trying normal and then start alternating? 
> Any of those patterns has valid arguments both for and against it, so 
> this again needs to be user configurable policy.
> 
> Altogether, that's a total of 7 policy decisions that should be user 
> configurable. 

All of them easy to implement if the btrfs.ko could accept
'allow-degraded' per-volume instruction and return 'try-degraded' in the
ioctl.

> Having a config file other than /etc/fstab for the mount 
> command should probably be avoided for sanity reasons (again, BTRFS is a 
> filesystem, not a volume manager), so they would all have to be handled 
> through mount options.  The kernel will additionally have to understand 
> that those options need to be ignored (things do try to mount 
> filesystems without calling a mount helper, most notably the kernel when 
> it mounts the root filesystem on boot if you're not using an initramfs). 
>   All in all, this type of thing gets out of hand _very_ fast.

You need to think about the two separately:
1. tracking STATE - this is remembering 'allow-degraded' option for now,
2. configured POLICY - this is to be handled by init system.

-- 
Tomasz Pala <gotar@pld-linux.org>
