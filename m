Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53651 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbbKIBJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 20:09:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zvaxr-000334-VM
	for linux-btrfs@vger.kernel.org; Mon, 09 Nov 2015 02:09:44 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 02:09:43 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 02:09:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs send | receive error: no such file or directory
Date: Mon, 9 Nov 2015 01:09:36 +0000 (UTC)
Message-ID: <pan$54c7b$e9d09f14$3a0341ca$3b12a44@cox.net>
References: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Glen H posted on Sun, 08 Nov 2015 16:28:08 -0500 as excerpted:

> I really enjoy the features of btrfs but send|receive is failing me so
> my backups are not working.  I'm using "btrbk" to backup my drives (all
> local) and one of the three subvolumes errors out.

> I have two other source subvolumes on another rotational disk that
> send|receive fine to the same target drive (/mnt/backup2tb) .  There is
> plenty of space on the backup drive.

As a list regular and btrfs user myself, not a dev, this is simply 
general information that might be of use, not specific to this report.

Btrfs is in general "stabilizing and maturing, but not yet fully stable", 
and while stability has improved over time, that status is likely to 
remain for awhile.  Original estimates of the work necessary proved 
wildly optimistic, and features often take far more time to be coded and 
to stabilize to the general level of btrfs itself than was originally 
predicted.  Witness what happened to btrfs raid56 mode, for instance, 
originally predicted for 3.5 or 3.6, then introduced in 3.9 as runtime 
working but tools not there yet (making it effectively a raid0 that would 
"magically" upgrade to raid56 when support was complete), finally 
nominally completed in 3.19 but with bugs thru 4.1 at least, it 
effectively took three years longer than anticipated.  Or witness the 
btrfs quota code, which despite some rather herculean efforts by the devs 
(it's on at least the third rewrite), to this day has never really worked 
correctly, such that the recommendation is to not enable quotas if you 
don't need the feature, or switch to a fileysystem with more stable and 
mature quota support that actually works reliably, if you do.

The specific send/receive feature that's in question here works 
reasonably reliably in general -- if it completes successfully on both 
ends it's pretty reliably guaranteed to be a faithful copy -- but there 
have been various corner-cases that have needed fixed over time, and it 
appears you're hitting one of them.  As a real simple example that was 
one of the first corner-case fixes, consider the case where originally dir 
A contained subdir B, but at some point after the reference "parent" 
snapshot, that reversed and now subdir A is inside dir B. Send/receive 
originally couldn't handle that and would error out, but now that 
specific corner-case works.

So current send/receive status is that it should generally work, and when 
both ends complete without error the result is pretty reliable, but 
sometimes it doesn't work, and people using it should be prepared to use 
alternative syncing solutions (such as rsync) or to futz around with the 
directory structure (or simply do another full send parent, hopefully 
getting around the problem) until it can be made to work.

Meanwhile...

> For versions, I'm using:
> 
> - kernel  3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8 10:21:08
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> - Linux Mint 17.2 (based on Ubuntu 14.04) which has a stock kernel of
> 3.17 (but I upgraded to 3.19).
> 
> - btrfs-progs 3.19, 3.19.1 and 4.3 (all fail with the same error).

Again, as stated above, btrfs isn't yet fully stable and mature, tho it 
has gotten markedly more so over time.  While the general recommendation 
used to be to keep current with the kernel, and to a lessor extent the 
userspace (btrfs-progs), that has relaxed to some extent, such that the 
current general list recommendation is to choose one of either (a) 
keeping current, as previous, or (b) staying with the the last couple 
stable-kernel series.

That's currently 3.18 and 4.1, with 4.4 (which is in the initial two-week 
commit window phase, pre-rc1, ATM) already announced to be another stable 
series.  Running unsupported kernels doesn't mean we won't try to help, 
it just makes doing so harder, and people without a lot of time to reply 
might simply skip answering entirely.

Note that despite this "stabilizing not stable" status, various distros 
have chosen to ship btrfs and even use it by default, often with older 
kernels outside the (upstream and list) supported range.  People running 
them can expect to be asked to upgrade when posting to this list, and 
have at least three choices.  They can either (a) stick with what their 
distro provides and get their support from the distro which has chosen to 
support it, not here, (b) upgrade to something current and supported by 
the list, or (c) stick with what they have and muddle thru -- it's not 
that we refuse to support old versions, it's that known bugs in them have 
been fixed, and btrfs as a project has moved on, so we'll try to support 
it, but don't expect the devs to take too much interest in a bug not 
duplicated on current or current-stable, and in general, expect a lower 
likelihood of the list to be able to provide a fix.

So as I said, the latest 3.18 series kernel is generally supported (until 
4.4 comes out, anyway), but the 3.17 and 3.19 you're running are neither 
one long-term-stable releases and are out of upstream support, so can't 
be expected to have the latest fixes backported, unless of course the 
distro has done it, which puts it squarely back in distro support 
territory.

So I'd recommend upgrading to the 4.1 LTS kernel series, or failing that, 
switching to the 3.18 LTS kernel series (which would be a nominal 
downgrade from 3.19, but is an LTS kernel and thus actively getting 
backported fixes, while 3.19 is not), with an expectation that you'll 
need to upgrade to 4.1 or 4.4 in less than two months.

Or simply switch to current, the recently released 4.3 if you prefer, or 
the still in short-term-support 4.2.

Regardless, if at all possible, please get a 4.3 kernel somewhere if only 
for temporary testing, building it yourself if necessary, and check for 
sure whether it can properly send/receive the failing snapshot.  If so, 
and neither 3.18 nor 4.1 LTS can do it, there's a patch that didn't make 
it to stable that arguably needs to do so, while if not, we know there's 
either another corner-case lurking in the send/receive code to fix, or 
the problem is elsewhere (see the btrfs check discussion below).

As for btrfs-progs, things work this way.  With normal runtime (loosely 
stated, mounting and mounted filesystem operations), userspace pretty 
much just makes kernel calls, and the kernel code does all the real 
work.  This would include send/receive.  So in the normal runtime case, 
userspace version isn't nearly as critical as kernel version.  However, 
userspace commands that work with an unmounted filesystem, btrfs check, 
btrfs restore, etc, use their own code to work with the filesystem.  
Since in most cases you don't need to run these unless the filesystem is 
damaged and won't mount, it's at this point that having a current btrfs 
userspace with all the latest fixes becomes critical, as it can make the 
difference between fixing the problem or making it worse (the reason 
running btrfs check --repair is discouraged, except on the advice of a 
dev because they know it can fix the present problem, or if the 
alternative would be giving up and blowing the filesystem away, 
recreating a fresh one, because --repair can make problems it doesn't 
know about worse, of course, older versions not knowing about more such 
problems).

Since there's no problem mounting the filesystem, btrfs-progs version 
shouldn't make too much difference, certainly for the range of versions 
you posted.  But it might still be worthwhile to run a btrfs check 
(without --repair or other such switch, so the default read-only check is 
done, preferably with a new 4.3 btrfs-progs, but even your old ones may 
yield some information.  If check reports a problem, then it may not be 
yet another send/receive corner-case at all, but rather, a problem with 
the filesystem that doesn't appear under normal usage, but that send/
receive happens to error out on.

Meanwhile, a reasonable rule of thumb for btrfs-progs versions is to keep 
them at least as new as the kernel they're running with, since its 
release was designed with that kernel version... and problems known at 
that time, in mind.  Running newer isn't a problem at all, since newer 
userspace is designed to work with older kernels, and /generally/ running 
older shouldn't be a problem either, as long as it's not /too/ old and 
you don't have problems that a newer version is known to fix or need 
features only available in newer versions.  But running a 3.12 userspace, 
for instance, would be too old as so much has changed since then, 
including in the command organization and output, that it's simply harder 
to "impedance-match" that far back.  And if you're following the current 
or last-two-lts kernel series rule, it should be reasonably easy to run 
at least that new a userspace as well, so you just don't have to worry 
about it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

