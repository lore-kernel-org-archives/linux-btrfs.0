Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57551 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab3J2RaY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 13:30:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbD7V-0005M5-BC
	for linux-btrfs@vger.kernel.org; Tue, 29 Oct 2013 18:30:21 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 18:30:21 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 18:30:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving over to use BTRFS - first time, needs encryption
Date: Tue, 29 Oct 2013 17:29:58 +0000 (UTC)
Message-ID: <pan$472ba$575e62e7$beccb4bb$dd94e1e8@cox.net>
References: <CAOKNOqAv5yGNY3S77CO2w5Hk8wDZ2b9YTjSt_kc_-8TDkNnmKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs.nrb posted on Tue, 29 Oct 2013 15:19:19 +0000 as excerpted:

> Hi,  I would be pleased to get some help after I have looked and not
> figured out how this should work:
> 
> Summary =======
> btrfs device add <LUKS encrypted container> <path>
> Returns - Inappropriate ioctl for device

> # btrfs --version
> Btrfs Btrfs v0.19
> # uname -a
> Linux 874-deb 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux

[I've no particular personal knowledge on encrypted filesystem usage, but 
this is a general reply...]

First, are you aware of the btrfs wiki and have you read its encryption 
discussion (among other things)?

https://btrfs.wiki.kernel.org


Second, if you've read the wiki you know this already, but it's worth 
repeating...

btrfs is still under heavy development and still labeled experimental.  
As such, if you're running btrfs you are by definition testing an 
experimental filesystem and should consider data reliability in that 
regard.  IOW, KEEP TESTED BACKUPS AND BE PREPARED TO USE THEM should your 
btrfs tests go badly!

Further, every new kernel brings important fixes to known issues, and 
anything older than two kernel series old is ANCIENT.  Ideally, you're on 
the latest stable kernel release at the OLDEST, and may well be running 
mainline kernel rcs if not even the btrfs-next patch-set.  (Personally, I 
run a mainline git kernel, but don't normally update to the development 
kernel until after rc1, but try to get to it before rc3, so if I notice 
any regressions I can file bugs with time to have them fixed before 
release.)  Run anything older and not only are you very literally 
needlessly risking your data on known bugs that are already fixed, but if 
you do catch a bug and report it, your reports will be less useful 
because your kernel is so old.

For btrfs testers, kernel 3.2 is "ancient as the hills!"  There are 
reasons people might want to be conservative and run older kernels, but 
they really aren't compatible with the reasons people would want to test 
new and potentially unstable filesystems such as btrfs.  Please choose 
one or the other, and if you're going to test btrfs, do so with a current 
kernel, currently meaning a post-3.11.5 stable series kernel at the 
oldest as I believe it had some critical btrfs patches, or 3.12 release 
cadidates or live-git, since 3.12 is very close to release now.

Similarly but not /quite/ as critical, btrfs-progs v0.19 is /old/.  Even 
v0.20-rc1 is from late last year, IIRC, and according to the version 
string I have here[1], 358 commits behind current.  btrfs-progs 
development policy is to keep the git master branch "release ready" and 
do actual development in other branches which are only merged when 
they're considered ready, so running "git-master" of btrfs-progs, updated 
weekly or no less than monthly, should be your best and safest option.

---
[1] Btrfs-progs here, live-git updated less than a week ago, tho from 
memory the latest commit was back in July or so:

btrfs --version
Btrfs v0.20-rc1-358-g194aa4a


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

