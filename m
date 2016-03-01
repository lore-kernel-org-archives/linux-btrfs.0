Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40372 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbcCAVMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 16:12:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aaral-0003q8-Jl
	for linux-btrfs@vger.kernel.org; Tue, 01 Mar 2016 22:12:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 22:12:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 22:12:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lxc-ls --fancy
Date: Tue, 1 Mar 2016 21:12:17 +0000 (UTC)
Message-ID: <pan$a8f18$743979ec$3e5b7ac0$1ecfc7@cox.net>
References: <CAO2Nr8d5DzeJpoGUBGCeqwiwb16Q8h0qU4Rq4+_s=G-9aMphOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Carlos Ortega posted on Tue, 01 Mar 2016 14:11:32 -0500 as excerpted:

> am I going crazy or was the "--fancy" option introduced after
> btrfs-progs rev 3.19.1?  And if so, what rev?

lxc-ls in btrfs-progs?  Not in any btrfs-progs that I'm aware of.

Maybe in some lxc-progs package or the like.

An esearch lxc here on gentoo turns up app-emulation/lxc and sys-fs/lxcfs 
as possible candidates; I can't directly confirm as I don't use lxc and 
don't have either one installed.

And RPMFind, which I used to use back when I was on Mandrake (yes, that 
long ago, well over a decade) and which I still use occasionally to look 
up files I don't have installed, as here, says lxc-ls is part of the lxc 
package, so that esearch candidate was correct. =:^)

So, umm... while I'm not a doctor, perhaps making or keeping that 
appointment with your shrink might not be such a bad idea. =:^P

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

