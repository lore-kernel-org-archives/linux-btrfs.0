Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46508 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbbLVJ23 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 04:28:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBJF5-0003FG-7O
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 10:28:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:28:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:28:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Ideas to do custom operation just after mount?
Date: Tue, 22 Dec 2015 09:28:15 +0000 (UTC)
Message-ID: <pan$a07c5$8ea63042$e035dc2a$bbe2f2c1@cox.net>
References: <56721602.5050204@cn.fujitsu.com>
	<20151221001654.GM19802@dastard> <56776330.1090500@cn.fujitsu.com>
	<5677662F.2060806@cn.fujitsu.com> <56778B9E.8050900@oracle.com>
	<20151222011424.03247982@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 22 Dec 2015 01:14:24 +0100 as excerpted:

> Am Mon, 21 Dec 2015 13:18:22 +0800 schrieb Anand Jain
> <anand.jain@oracle.com>:
> 
> 
>> 
>> > BTW, any good idea for btrfs to do such operation like
>> > enabling/disabling some minor features? Especially when it can be set
>> > on individual file/dirs.
>> >
>> > Features like incoming write time deduplication, is designed to be
>> > enabled/disabled for individual file/dirs, so it's not a quite good
>> > idea to use mount option to do it.
>> >
>> > Although some feature, like btrfs quota(qgroup), should be
>> > implemented by mount option though.
>> > I don't understand why qgroup is enabled/disabled by ioctl. :(
>> 
>> 
>> mount option won't persist across systems/computers unless remembered
>> by human.
> 
> Valid point, tho here's an counter-example: space-cache is persisted.
> Once enabled, it's always there until you clear AND disable it during
> initial mount.

Data point.  space_cache doesn't have to be manually enabled at all, 
unless it was turned off at some point; it's automatically enabled on 
mounting new btrfs.

At least, I've never specifically enabled (or disabled) space_cache on 
any of my btrfs here, yet they all have it enabled.

(Years ago, with my first btrfs experiments, a corrupted space_cache 
could cause the filesystem not to mount.  But then I left btrfs alone for 
awhile, and I guess in the mean time it learned to auto-correct such 
problems, as I've never had to worry about a bad space-cache failing a 
mount since I returned to using it, and that itself was two and a half 
years ago, now.  With the previous mount-blocker experience I was a 
rather nervous when I saw it enabled without me initially enabling it, 
but space_cache has basically "just worked" for me since then, tho I've 
had a few other mount-blocking bugs.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

