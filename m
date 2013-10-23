Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45522 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab3JWAvM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 20:51:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VYmfH-00068F-Bf
	for linux-btrfs@vger.kernel.org; Wed, 23 Oct 2013 02:51:11 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 02:51:11 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 02:51:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid5
Date: Wed, 23 Oct 2013 00:50:51 +0000 (UTC)
Message-ID: <pan$8e391$f46eecbc$498ef5f9$8d48b882@cox.net>
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
	<pan$59a02$8231ca78$f5d54bfb$30812437@cox.net> <or7gd59qcf.fsf@livre.home>
	<5266B87D.9080202@swiftspirit.co.za> <ory55l85xm.fsf@livre.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexandre Oliva posted on Tue, 22 Oct 2013 17:24:37 -0200 as excerpted:

> On Oct 22, 2013, Brendan Hide <brendan@swiftspirit.co.za> wrote:
> 
>> On 2013/10/22 07:18 PM, Alexandre Oliva wrote:
>>> ... and it is surely an improvement over the current state of raid56
>>> in btrfs,
>>> so it might be a good idea to put it in.
>> I suspect the issue is that, while it sortof works, we don't really
>> want to push people to use it half-baked.
> 
> I don't think the current state of the implementation upstream is
> compatible with that statement ;-)
> 
> One can create and run a glorified raid0 that computes and updates
> parity blocks it won't use for anything, while the name gives the
> illusion of a more reliable filesystem than it actually is, and it will
> freeze when encountering any of the failures the name suggests it would
> protect from.
> 
> If we didn't have any raid56 support at all, or if it was configured
> separately and disabled by default, I'd concur with your statement.  But
> as things stand, any improvement to the raid56 implementation that
> brings at least some of the safety net raid56 are meant to provide makes
> things better, without giving users an idea that the implementation is
> any more full-featured than it currently is.

The thing is, btrfs /doesn't/ have any raid56 support at all, in the 
practical sense of the word.  There is a preliminary partial 
implementation, exactly as announced/warned when the feature went in, on 
a filesystem that itself is still experimental/testing status, so even 
for the features that are in general working, make and test your backups 
and keep 'em handy!

Anyone running btrfs at this point should know it's status and be keeping 
up with upstream /because/ of that status, or they shouldn't be testing/
using it at all as it's not yet considered a stable filesystem.  If 
they're already aware of upstream status and are deliberately testing, by 
definition they'll already know the preliminary/partial nature of the 
current raid56 implementation and there won't be an issue.  If they 
aren't already keeping up with developments on a declared experimental 
filesystem, that's the base problem right there, and the quick failure 
should they try raid56 in its current state simply alerts them to the 
problem they already had.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

