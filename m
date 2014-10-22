Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49913 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaJVHM6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 03:12:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xgq6H-0006xy-MH
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 09:12:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 09:12:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 09:12:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Wed, 22 Oct 2014 07:12:42 +0000 (UTC)
Message-ID: <pan$6e690$48fa582b$d4144853$c0bf65f3@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
	<54454858.8010802@pobox.com> <54456EB0.9020503@inwind.it>
	<pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net> <54468C73.1070108@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Tue, 21 Oct 2014 18:40:19 +0200 as
excerpted:

> On 10/21/2014 11:50 AM, Duncan wrote:
>> Goffredo Baroncelli posted on Mon, 20 Oct 2014 22:21:04 +0200 as
>> excerpted:
>> 
> [...]
>>> > 
>>> > Could this be related to the inode overflow in 32 bit system (see
>>> > inode_cache options) ? If so running a 64bit "ls -i" should work....
>> Good point.  Russell might just owe you a beverage of choice.  =:^)
>> 
>> The inode_cache mount option isn't recommended for any bitness.
> 
> 
> Hi Ducan,
> could you elaborate this sentence ? From my understanding inode_cache is
> *needed* on 32bit system in order to avoid inode number overflow. Why
> are you saying that it is not recommended ?

My understanding of this is limited as I'm a sysadmin and list regular, 
not a dev let alone a btrfs dev, but see the btrfs (5) manpage (aka btrfs-
mount), under mount options:

"""""

inode_cache: Enable free inode number caching. Defaults to off due to an 
overflow problem when the free space crcs don’t fit inside a single page.

"""""

As I understand it based on developer comments to this effect, 64-bit 
doesn't need it at all, and on 32-bit, in theory there are cases where 
it'd be useful, but in practice, this overflow problem, among others (see 
the discussion below), limits its usefulness to such an extent that it's 
not recommended for use, even on 32-bit where in theory it could be of 
use.

That's the extent of the theory I know on the subject.

Then there's the real-world reports and their effect on things:

* In part because inode_cache is pretty well universally negative-
recommended when it is seen, it's a poorly tested feature, and reported 
bugs never get traced to it because as soon as people see it, they say 
turn it off as its problems are worse than the problem it's trying to 
cure, so it's turned off and the bugs disappear and everbody's happy, 
without tracing down the problem.

One solid example of that was a report that btrfs was consistently taking 
an unreasonably long time (five minutes plus) to mount, making it 
unworkable as a filesystem mounted at boot from fstab.  (I believe that 
user was on systemd and systemd was timing out the localmount service, 
but it would have been similar on any other init system, as very few will 
by default let anything but fsck go for five minutes without timing it 
out.)  inode_cache was apparently reinitializing at every mount, instead 
of just once.  Were that space_cache, the bug would have almost certainly 
been traced and ultimately fixed.  But being inode_cache which isn't 
recommended anyway, we recommended that he turn inode_cache off, and he 
did, and btrfs suddenly behaved itself, effectively confirming opinions 
that inode_cache isn't worth the trouble.

I believe I've also seen failure to boot due to inode_cache corruption 
issues reported, very similar to the ones that used to plague space_cache 
and that hit me at one point so I know how bad they were, as nospace_cache 
and/or clear_cache could fix the space_cache problem, but back then it 
was a manual fix so you had to know about it.  But the space_cache issues 
were traced and fixed since it's the default and detection and recovery 
for space_cache corruption is normally automatic these days, while who 
knows _what_ happened to the same sorts of issues with inode_cache, 
because the recommendation is simply to turn it off and be done with the 
problem, instead.  However, I'm not as sure on this one as on the long-
mount-time issue, I believe because I was still getting my own btrfs 
bearings at the time, and the link wasn't as strong to me as it got lost 
in the blur of everything else I was learning about btrfs at the same 
time.

I guess I just changed my own mind a bit on it as I wrote that, but the 
end-user effect is almost the same, except there's an exception now.  
Basically, the situation is still the same for ordinary users, don't 
touch it as it's likely to result in needless problems.  But for that 
stubborn but tech inclined user willing to be a guinea pig, particularly 
if they're a dev that can actively help trace down bugs in the code as 
well as usefully write up in sysadmin's or plainer English exactly where 
it makes sense to use this option and what its real problems are, there's 
definitely an opening to help make this a (hopefully much, but just about 
anything would be an improvement) better documented and less buggy mount 
option. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

