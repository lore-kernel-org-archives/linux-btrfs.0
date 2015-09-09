Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44611 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbbIILZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 07:25:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZZdVI-0001ON-8P
	for linux-btrfs@vger.kernel.org; Wed, 09 Sep 2015 13:25:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 13:25:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 13:25:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs progs release 4.1
Date: Wed, 9 Sep 2015 11:25:11 +0000 (UTC)
Message-ID: <pan$13b5d$e35e55fd$97aa970a$5853fbee@cox.net>
References: <20150622150023.GX6761@twin.jikos.cz>
	<55EF8CBD.3020105@cn.fujitsu.com> <55EFA661.2050102@cn.fujitsu.com>
	<CAO5K3Oemuice_3RMxsdQVOxWv+izVAFNN0p_shcbD=ONdrWGOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vytautas D posted on Wed, 09 Sep 2015 11:35:50 +0100 as excerpted:

> sorry for side question - but does this mean that btrfs-convert issues
> others were having on kernel 4.0+ on this mailing list is now addressed
> ?

AFAIK they've not yet been entirely fixed, no.  There's still active 
(within the day) discussion on further patches.  Based on that discussion 
(I'm not a dev) the root problem is that ext* doesn't cleanly separate 
data and metadata (tho ext4 does better than ext2/3) like btrfs does, and 
both can end up in the same chunk on btrfs.  That would require btrfs 
mixed-bg mode (which is otherwise for small filesystems, the default at 1 
GiB or smaller but often useful to say 32 GiB), but there were various 
problems with that (possibly including chunks of the wrong size for mixed-
bg) and currently, convert apparently tries to do separate data and 
metadata chunks.  But because they're so mixed on ext*, that many small 
chunks instead of the fewer large chunks btrfs would normally have.  So 
they're still debating mixed-bg or not.

So currently, the best recommendation is to simply create a brand new 
btrfs, and copy to it from the existing ext*.  That also has the benefit 
of keeping the ext* as a backup of what is presumably the btrfs working 
copy, and of course, as any good sysadmin has already integrated but 
unfortunately we keep getting reports of people figuring out the hard 
way, if it's not backed up, by definition of your lack of backup action, 
you don't care about it, any post-loss claims to the contrary not 
withstanding.  So encouraging people to have at least the backup made as 
a result of copying the old ext* to the new btrfs, instead of trying to 
convert in place and finding out the hard way that lack of a backup means 
the lost data wasn't of value, can be seen as a good thing. =:^)

Actually, even in the absence of known convert bugs I'd recommend a clean 
mkfs, simply because that way you /know/ you start out with a clean 
filesystem, and you end up with better btrfs defaults that way too.  I 
know that's the reason I steered clear of convert here.  I simply don't 
trust it, and wanted to start clean in any case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

