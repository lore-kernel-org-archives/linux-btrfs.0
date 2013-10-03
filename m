Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33076 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab3JCXIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Oct 2013 19:08:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VRs03-0007dv-OU
	for linux-btrfs@vger.kernel.org; Fri, 04 Oct 2013 01:08:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 01:08:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 01:08:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Should I worry about this kernel opps ?
Date: Thu, 3 Oct 2013 23:07:45 +0000 (UTC)
Message-ID: <pan$c2b03$c36c2f10$d8b15b06$b54f27f6@cox.net>
References: <CAEqknOOCsRPe30M0AdJcSNNz4vnaq=0sc+V9zksorLOJUBiukg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jerome Haynes-Smith posted on Thu, 03 Oct 2013 18:28:51 +0100 as
excerpted:

> Hi folks
> 
> I am using btrfs in openSUSE 12.3 and I have seen several of these
> recently:
> 
> 2013-10-03 10:04:27]  ------------[ cut here ]------------
> [2013-10-03 10:04:27]  WARNING: at
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.10/linux-3.7/fs/btrfs/
extent_map.c:258
> unpin_extent_cache+0x65/0x140 [btrfs]()

While I'm not a dev, just a list regular and btrfs user myself...

The BIG thing I notice here is that kernel version.  Both here on the 
list and on the btrfs wiki ( https://btrfs.wiki.kernel.org ), running a 
current kernel is REPEATEDLY stressed.  Btrfs is still under development 
and every kernel series there are bug fixes that you don't have if you're 
running an old kernel.  Running AT LEAST the second latest stable kernel 
series is EXTREMELY STRONGLY RECOMMENDED, with latest stable RECOMMENDED, 
and latest development kernel or even the btrfs-next patches also 
options.  If you're running older than that, you're both missing fixes 
that could prevent problems, and as a tester of still under development 
btrfs, the reports for problems you do have and report will be less 
useful, since you're so far behind current code.

Current dev kernel is 3.12 series, with 3.12-rc3 out now.  That means 
btrfs testers should be running NO OLDER THAN 3.10, and preferably the 
latest stable 3.11 if not the 3.12-rcs or btrfs-next.  (Tho due to some 
crossed signals 3.11.4 stable doesn't have the queued btrfs-stable 
patches, but 3.11.5 should, see earlier list threads.  Of course queued 
for stable means corresponding commits are already in dev, so 3.12 has 
those fixes already.)

That log says kernel 3.7, which is **OLD**, at least for btrfs testing 
purposes.  People do have reasons not to run the latest kernel, but 
running an older kernel is really at odds with the whole idea of being a 
tester for a kernel system like btrfs that's still under development, so 
choosing one or the other would be wise.

FWIW, personally I run the current dev-kernel built direct from git, but 
don't switch to a new kernel until after rc2 or so, when any real system-
killer issues should be fixed or at least warned about for those 
following kernel development, but it's still early enough in the cycle to 
get any bugs I find and report fixed before general 3.x.0 release.  As it 
happens I built my first 3.12 series kernel right at 3.12-rc2 and am 
actually still running it as I haven't pulled and rebuilt since, tho rc2 
is actually stale now as rc3 is out and I think we're already half way 
thru the week to rc4.

> [2013-10-03 10:04:27]  Pid: 22467, comm: btrfs-endio-wri Tainted: G
>     W  O 3.7.10-1.16-desktop #1

That taint is all GPL modules (G, not the P you'd get if you had loaded 
anything not GPL), but with an out-of-tree modules (O) and a previous 
warning, probably an earlier instance of what you're posting about...

> I see no symptoms of a problem at this time. (Disks seem a bit busy,
> but I think that's the snapperd)

It's reasonably common knowledge, but just in case... Note that 
especially if you're taking regular snapshots as the snapperd mention 
indicates you probably are... check that you're mounting with the noatime 
option, as atime updates aren't needed on most modern systems (mutt users 
being a possible exception, since it depends on atimes unless it's 
configured to use mbox format), and atime updates and COW snapshotting 
such as btrfs uses "fight with each other", generally needlessly 
increasing writes and the unique-(meta)data size of each snapshot.  (The 
kernel's current relatime default is compromise between atime legacy 
compatibility and noatime efficiency, but relatime still updates once a 
day on access, which if you're keeping daily snapshots for any length of 
time can still add up rather fast.  So while relatime's a good compromise 
default for ext* filesystems, not so much for btrfs with regular 
snapshotting.)

> I don't seem to find many matches for 'unpin_extent_cache+0x65/0x140
> [btrfs]' which I believe is the actual point that the system decided to
> do the 'opps'.. but I may be wrong.
> 
> Is this something I need to do something about ?
> I can send a siga output if it will help. (I tried to attach it as a
> compressed text file, but the email bounced previously)

Yeah, AFAIK the various kernel lists bounce most binary attachments as 
spam/malware control, and there's a limit on text attachment size.  
Sending a link to a (preferably non-expiring, so people researching a 
similar problem later can still get it) pastebin posted somewhere is one 
common workaround, while sending the big stuff only on request and 
generally directly to the dev requesting it, for special cases that need 
detail debugging, is another.

I'd definitely recommend a newer kernel.  That may well fix the problem 
right there.  And your btrfs-tools package should be similarly current; 
anything 0.19 era is OLD, with current git (as of a few days ago anyway) 
being (IIRC) 358 commits beyond 0.20-rc1.  If you're still seeing those 
warnings with something current /then/ you can investigate further, but 
I'm guessing you won't, as IIRC at least one fix since 3.7 has been 
related to unpin bugs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

