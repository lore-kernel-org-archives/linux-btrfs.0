Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53189 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3FULan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 07:30:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3760B9A0699
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 05:30:43 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
CC: Jon Nelson <jnelson+btrfs@jamponi.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
 <loom.20130618T190955-784@post.gmane.org>
 <20130621011137.4477.1347@localhost.localdomain>
 <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
Message-ID: <20130621113040.4477.83994@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Fri, 21 Jun 2013 07:30:40 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Jon Nelson (2013-06-20 21:46:46)
> Is this what you are looking for?
> After this, the CPU gets "stuck" and I have to reboot.
> 
> 
> [360491.932226] ------------[ cut here ]------------
> [360491.932261] kernel BUG at
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.9.6/linux-3.9/fs/btrfs/ctree.c:1144!

Aha, this is not a hang but a crash.  I know the end result is the same
(you push the reset button) but for a crash we always want to see this
oops message.

I'll try to reproduce (and check out the bugzilla too).  Do you have
compression on?

-chris
