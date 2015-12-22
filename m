Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49188 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbbLVKX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 05:23:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBK6G-0001AM-Hi
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 11:23:24 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 11:23:24 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 11:23:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check inconsistency with raid1, part 1
Date: Tue, 22 Dec 2015 10:23:17 +0000 (UTC)
Message-ID: <pan$30f15$f6f8b13b$d72dd248$aaee075f@cox.net>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
	<CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
	<5677592F.5000202@cn.fujitsu.com>
	<CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
	<567762A3.9060007@cn.fujitsu.com>
	<20151222020529.1ac0c913@jupiter.sol.kaishome.de>
	<5678A5CC.7050900@cn.fujitsu.com>
	<20151222024804.5c4f7da2@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 22 Dec 2015 02:48:04 +0100 as excerpted:

> I just wondered if btrfs allows for the case where both stripes could
> have valid checksums despite of btrfs-RAID - just because a failure
> occurred right on the spot.
> 
> Is this possible? What happens then? If yes, it would mean not to
> blindly trust the RAID without doing the homeworks.

The one case where btrfs could get things wrong that I know of is as I 
discovered in my initial pre-btrfs-raid1-deployment testing...

1) Create a two-device btrfs raid1 (data and metadata) and ensure some 
data on it, including a test file with some content to be modified later. 
Sync and unmount normally.

2) Remove one of the two devices.

3) Mount the remaining device degraded-writable (it shouldn't allow 
mounting without degraded) and modify that test file.  Sync and unmount.

4) Switch devices and repeat, modifying that test file in some other 
incompatible way.  Sync and unmount.

To this point, everything should be fine, except that you now have two 
incompatible versions of the test file, potentially with the same 
separate-but-equal generation numbers after the separate degraded-
writable mount, modify, unmount, cycles.

5) Plug both devices in and mount normally.  Unless this has changed 
since my tests, btrfs will neither complain in dmesg nor otherwise 
provide any hint than anything is wrong.  If you read the file, it'll 
give you one of the versions, still not complaining or providing any hint 
that something's wrong.  Again unmount, without writing anything to the 
test file this time.

6) Try separately mounting each device individually again (without the 
other one available so degraded, can be writable or read-only this time) 
and check the file.  Each incompatible copy should remain in place on its 
respective device.  Reading the one copy (randomly chosen or more 
precisely, chosen based on PID even/odd, as that's what the btrfs raid1 
read-scheduler uses to decide which copy to read) didn't change the other 
one -- btrfs remained oblivious to the incompatible versions.  Again 
unmount.

7) Plug both devices in and mount the combined filesystem writable once 
again.  Scrub.

Back when I did my testing, I stopped at step 6 as I didn't understand 
that scrub was what I should use to resolve the problem.  However, based 
on quite a bit of later experience due to keeping a failing device (more 
and more sectors replaced with spares, turns out at least the SSD I was 
working with had way more spares than I would have expected, and even 
after several months when I finally gave up and replaced it, I was only 
down to about 85% of spares left, 15% used) around in raid1 mode for 
awhile, this should *NORMALLY* not be a problem.  As long as the 
generations differ, btrfs scrub can sort things out and catch up the 
"behind" device, resolving all differences to the latest generation copy.

8) But if both generations happen to be the same, having both been 
mounted separately and written so they diverged, but so they end up at 
the same generation when recombined...

>From all I know and from everything others told me when I asked at the 
time, which copy you get then is entirely unpredictable, and worse yet, 
you might get btrfs acting on divergent metadata when writing to the 
other device.


The caution, therefore, is to do your best not to ever let the two copies 
be both mounted degraded-writable, separately.  If only one copy is 
written to, then its generation will be higher than the other one, and 
scrub should have no problem resolving things.  Even if both copies are 
separately written to incompatibly, in most real-world cases one's going 
to have more generations written than the other and scrub should reliably 
and predictably resolve differences in favor of that one.  The problem 
only appears if they actually happen to have the same generation number, 
relatively unlikely except under controlled test conditions, but that has 
the potential to be a *BIG* problem should it actually occur.

So if for some reason you MUST mount both copies degraded-writable 
separately, the following are your options:

a) don't ever recombine them, doing a device replace missing with a third 
device instead (or a convert to single/dup); use one of the options below 
if you do need to recombine, or...

b) manually verify (using btrfs-show-super or the like) that the supers 
on each don't have the same generation before attempting a recombine, 
or...

c) wipe the one device and treat it as a new device add, so btrfs can't 
get mixed up with differing versions at the same generation number, or...

d) simply take your chances and hope that the generation numbers don't 
match.

(D should in practice be "good enough" if one was only mounted writable a 
very short time, while the other was written to over a rather longer 
period, such that it almost certainly had far more intervening commits 
and thus generations than the other.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

