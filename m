Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54168 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3KPWgb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 17:36:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhoTa-0008SK-QI
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 23:36:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 23:36:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 23:36:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi show
Date: Sat, 16 Nov 2013 22:36:04 +0000 (UTC)
Message-ID: <pan$bc3ea$b72d6510$8665f627$6082e213@cox.net>
References: <528787FB.4040100@czarc.net>
	<8A471BDA-8355-4267-BA6F-44046F6422BD@colorremedies.com>
	<pan$daf92$6b3b3c71$c97cb6b7$f9d238aa@cox.net>
	<74A706D5-8983-43D3-A21A-5C577E4ED695@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 16 Nov 2013 14:50:00 -0700 as excerpted:

> On Nov 16, 2013, at 1:33 PM, Duncan <1i5t5.duncan@cox.net> wrote:

>> 1) If you run a generic btrfs filesystem show (without options or
>> path), you *WILL* likely get the same base filesystem listed multiple
>> times, as the default lookup appears to get the info from at least two
>> different places, one appearing right away that only appears to include
>> currently mounted filesystems, then a pause, then a more complete
>> listing that includes currently unmounted btrfs volumes as well.
> 
> Thanks for the explanation. I'm still considering it a bug though.
> Duplicates of the same UUID should be filtered out.

Reasonable point, and I /guess/ (not being a coder) it shouldn't take 
much to do that directly in the btrfs filesystem show code itself.

> In my case, there's no pause. Two identical listings are instantly
> produced for one btrfs volume.

Probably because you just have that one volume, and it's mounted.

I have something like eleven separate btrfs filesystems, mostly two-
component-device raid1 mode btrfs, with some of them being primary 
backups of others and thus not mounted by default, and others being stuff 
like /boot and my packages tree, that are only mounted when I'm doing 
updates.

The mounted ones show up instantly (with dups in at least some cases), 
but then it pauses, presumably because it's scanning and then parsing 
devices and matching up components for each unmounted filesystem before 
displaying it.  But if you had no such unmounted btrfs and/or if they 
were only single device (I'm not sure which bit triggers the pause), 
you'll probably not see the pause I see here.

>> 3) If you use -d, you'll get a different list, based on devices in /dev
>> so it includes unmounted filesystems (and thus the pause), but at least
>> here, this list is BOTH comprehensive AND avoids dups!
> 
> This does show me a single instance of the singular volume I have.

=:^)

If they don't decide to do the filtering, perhaps the current -d can 
become the default.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

