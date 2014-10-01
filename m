Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34268 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaJAXJi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 19:09:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XZT1d-0003KE-21
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 01:09:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:09:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:09:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH RFC] btrfs: introduce procfs interface for the device
 list
Date: Wed, 1 Oct 2014 23:09:21 +0000 (UTC)
Message-ID: <pan$56f59$ca416b0$a4aced24$3de99e6e@cox.net>
References: <542BB011.4000302@oracle.com>
	<1412172552.9583.0@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Wed, 01 Oct 2014 10:09:12 -0400 as excerpted:

>>> We're going to have a really hard time getting a new proc interface
>>> merged in, and after we've recently fixed up all (most?) of our sysfs
>>> races, I'd rather not have to do it all over again with /proc.
>> 
>>  This does not use fsid/devid based file-directory. So races as were in
>>  sysfs implementation does not apply here. (But there are
>> opportunity
>>  to optimize the code at the place mentioned in the code as todo).
> 
> Right, proc has different races ;)  Again the bar for new interfaces in
> proc is really very high.  It's not the direction the rest of the kernel
> is using.

Put differently...

Proc has fallen out of favor as an early experiment in virtual filesystem 
kernel interfaces that ran amok due to lack of governing rules at the 
time and is effectively legacy/deprecated.  From this viewpoint the most 
simple explanation for its continued existence is Linus' "prime 
directive" that you don't break userspace -- being the primary/only 
kernel/userspace virtual filesystem interface for quite some time, 
there's a *LOT* of stuff that depends on proc, and despite what many 
might want, it's not going to disappear overnight.

That's the kind of resistance you're looking at to get something new in 
proc.  Basically, it's not going to happen.

So as Chris recommends, go tilt at a different windmill.  Getting this 
one to move is going to require moving heaven and hell both, and it's 
just not worth it.

Sys does have stricter rules, but they are there for a reason, to ensure 
the mistakes that were made with proc don't get made with sys as well.  
That's the accepted place to put stuff that might have, in an earlier 
time, gone into proc, but now following the rules for sys, of course.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

