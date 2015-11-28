Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44043 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbK1Hdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 02:33:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2a0y-0000zZ-06
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 08:33:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 08:33:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 08:33:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: could not find root 8
Date: Sat, 28 Nov 2015 07:33:39 +0000 (UTC)
Message-ID: <pan$61dc1$1d6f129a$57fc840c$64222dcc@cox.net>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
	<CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 27 Nov 2015 15:51:03 -0700 as excerpted:

> On Fri, Nov 27, 2015 at 1:43 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Nov 27, 2015 at 10:33:29PM +0200, Imran Geriskovan wrote:
>>> After upgrading from systemd227 to 228 these messages began to show up
>>> during boot:
>>>
>>> [   24.652118] BTRFS: could not find root 8
>>> [   24.664742] BTRFS: could not find root 8
>>>
>>> Are they important?
>>
>>    That's the quota tree. I don't know exactly what's happening, but
>> possibly systemd is now enabling qgroups for its own purposes, and what
>> you're seeing is simply the qgroups being enabled for the first time?
> 
> I'm seeing a feature in systemd 228, "systemd-tmpfiles learned two new
> line types “q” and “Q” that operate like “v”, but also set up a basic
> btrfs quota hierarchy when used on a btrfs file system with quota
> enabled."
> https://lukevizzicks.co.uk/systemd-228-system-and-service-manager-released/
> 
> But from github I'm not finding any indication that systemd enables
> quota. This issue suggests that quota disabled is tolerated.
> https://github.com/systemd/systemd/issues/1809
> 
> Questions:
> a. Quotas seem to be sufficiently in-flux, and with two (?) deprecated
> methods, and one new implementation that I don't think it's OK for
> anything to enable it by default. Are there different opinions on this?

Definitely no different here.  As with raid56 mode, I'd want quotas to
be stable, with no bugs reported for two kernel cycles minimum, before
I'd consider recommending them.  Since we had quota bugs in 4.3, that
means 4.5 at the earliest, and presumably the LTS after that for those
not keeping current, altho if the quota fixes are backported to LTS
when finally stable then possibly 4.4 and 4.1... after the backports,
of course.

Let's hope systemd's not auto-enabling quotas, but I'd not be surprised
if they are, despite intentions to the contrary, given the problems I
had when they first added the tmpfiles.d v=subvolume support, in 218
IIRC.  The fixes only made it into 221, tho patches were available on
the bug I filed (during 219) against 220.

I'm on 226 (gentoo's 226-r1) ATM.  I probably won't go out of my way to
grab newer just to test this, but if 228 appears unmasked to ~amd64 in
the gentoo tree, I'll upgrade and be on the lookout for this thanks to
this thread.  I know for sure I've never enabled quotas here, so if I
see that in dmesg, I'll be pretty irritated at systemd, and will be
either ccing a bug if already filed or filing my own ASAP, as well as
creating my own patch to disable the q/Q in its shipped tmpfiles.d
config in the mean time.

> b. For the OP, is it possible quotas was ever enabled on this file
> system?
> c. How can we determine if quotas are enabled on Btrfs? I don't see a
> command within btrfs-quota to determine quota status.

Very good question. =:^)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

