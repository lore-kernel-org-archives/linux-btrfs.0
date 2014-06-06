Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40563 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbaFFFT3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 01:19:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WsmYp-00085G-Qd
	for linux-btrfs@vger.kernel.org; Fri, 06 Jun 2014 07:19:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 07:19:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 07:19:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Feature Question: stored mount options... is that in there?
Date: Fri, 6 Jun 2014 05:19:15 +0000 (UTC)
Message-ID: <pan$14eff$c78055ea$3ab41a67$e59f787e@cox.net>
References: <53913609.2010805@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Thu, 05 Jun 2014 20:31:21 -0700 as excerpted:

> Is there a way to store the default mount options in the file system a
> la ext4 and tune2fs?

Short answer, no, for most options at least.  It has been discussed and 
will probably appear in the future, most likely in the form of expanded 
btrfs properties.  (FWIW, there's limited property support in current 
btrfs-progs userspace.  It doesn't cover this use-case well, yet, 
however.)

> In particular my initrd mounts the file system and then the system
> remounts it using fstab, but this tends to lead to rebuilds of the inode
> cache. The initrd doesn't have the inode_cache option but the fstab
> does. This creates lots "meh" on occasion.

The fact that you didn't mention /why/ you've opted to use the 
inode_cache mount option suggests to me that you may not be aware of the 
fact that in general, it's not recommended for use and is generally 
"considered harmful" as the negatives (including this one, cache 
rebuilding) tend to outweigh the positives.  Inode_cache can be useful in 
certain specific circumstances on 32-bit kernels, but is extremely 
unlikely to be useful on 64-bit at all, and on 32-bit, there are general 
complications including an overflow possibility that mean it's definitely 
not a general-usage recommended option there either.

The special case where it /might/ be useful is busy 32-bit servers such 
as fileservers or mail machines with more or less constant create/delete 
file activity, due to the smaller inode space and possible saved time in 
searching for a free inode-number.  Such servers tend not to be rebooted 
too often either, so an at-mount inode-cache rebuild isn't as big an 
issue as it would be on for instance a typical desktop.

So unless you really can support your choice to enable that option, 
because you're on 32-bit and at least have a use-case where it should 
help, or better yet, have actually benchmarked your use-case and *KNOW* 
it helps, just disable inode_cache.

That said and applicable to this specific case, in the more general 
case...

> It Would Be Better™ if there were a way to store that sort of thing on
> the file system itself. Said feature was very easy to use on ext4 for
> dealing with xattr and such.

Definitely agreed, here.  As I said, it's likely to happen at some point, 
but it's not there now.

That said, a reasonable initr* should have multiple ways to provide mount 
options for the rootfs.  Among other possibilities, passing rootflags= on 
the kernel commandline should work[1] with a decent initr* as it does 
without an initr* at all -- a good initr* will pass them on to the mount 
command used to mount the rootfs.  In that case, you'd configure 
rootflags= to be passed to the kernel from the bootloader as you would 
any other kernel parameter.

Additionally, a good initr* builder should have some configuration option 
for passing additional mount-option flags, either by grabbing them from 
the system fstab directly, or configuration file option, or by initr* 
build program commandline option, if not all three.

(Dracut is one such "good" initr* builder.  Like many core Linux 
applications, it's Red Hat sponsored, but that doesn't mean it's limited 
to the Red Hat family of distros, and it is one recommended option for 
users who need an initr* solution on gentoo, my distribution, as well.  
But I'd be extremely surprised if any similar distro solution doesn't 
have at least ONE of these methods to pass rootfs mount options working, 
since it is after all relatively critical and basic functionality, 
without which many users may not be able to successfully mount their 
rootfs at all!)

But any such solution is ideally simply an alternative to being able to 
configure default mount options for the filesystem itself, and IMO, btrfs 
continues to remain broken as a mainline filesystem successor to the ext* 
series, until such time as it has some such filesystem default mount 
options configuration option, the more so because it has so many btrfs 
specific options one may actually wish to pass.

So I too consider btrfs currently broken in that regard, but I don't 
expect to see it stay that way forever.  After all, it's still under very 
active development, with both features and bugfixes very much still 
appearing in every kernel release cycle, and I expect that to continue to 
be the case for at least another year, as it continues to mature and 
fully stabilize. =:^)

---
[1] rootflags=:  There's one known exception that affects btrfs.  The 
btrfs device= mount option cannot be properly passed in rootflags=, 
apparently due to containing = as well.  Apparently the kernel parser 
splits at the last equals and parses the option to which parameters are 
appended as rootflags=device, instead of a base rootflags.  And since it 
doesn't recognize rootflags=device as rootflags, it doesn't pass the 
given options on as it should.  Unfortunately, that breaks initr*less 
direct-rootfs mount, for multi-device btrfs rootfs, so they require an 
initr* where they otherwise would not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

