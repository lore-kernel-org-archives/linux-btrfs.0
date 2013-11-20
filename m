Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59291 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3KTRaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 12:30:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjBbY-0002Ua-Af
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 18:30:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 18:30:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 18:30:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfsck complains about "fs tree 264 refs 1 not found"
Date: Wed, 20 Nov 2013 17:29:58 +0000 (UTC)
Message-ID: <pan$33b87$4dfcbafb$85d1ab72$59ca0c2@cox.net>
References: <528CD3AA.9040205@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pedro Fonseca posted on Wed, 20 Nov 2013 16:22:18 +0100 as excerpted:

> I've been getting the error message "fs tree 264 refs 1 not found" when
> running btrfsck (v0.19) after a test case. The test case creates and
> then deletes a subvolume while concurrently creating a snapshot of the
> parent directory. This situation occurred with kernel version 3.11.1.

Well, at least you're running a reasonably current kernel (tho 3.12 is 
out and IIRC it was 3.11.5 that contained some critical btrfs patches 
that 3.11.1 is missing), but quoting the wiki FAQ on btrfs 0.19:

https://btrfs.wiki.kernel.org/index.php/FAQ#I.27m_running_btrfs_0.19...

>>>>

I'm running btrfs 0.19...

This is, unfortunately, almost meaningless. Almost all of the 
"interesting" code in btrfs is in the kernel, so the main thing you 
should be reporting is the version of the kernel you're running.

Even if you want to report a problem with the btrfs userspace tools, the 
main version number (which is usually 0.19) is useless, because it hasn't 
been updated in at least 18 months. If you have installed from your 
distribution's package manager, then the version number of the package 
will usually include a date that will indicate when your btrfs tools were 
compiled; it is this package version that you should tell people about if 
you have a problem. If you have built your btrfs-progs tools from git, 
please tell us what git commit ID was the head when you built your tools. 
A recent version of the btrfs-progs tools should report the commit ID as 
part of the version number when you run them:

hrm@ruthven:~ $ btrfs --help
Usage:
[...]
Btrfs v0.19-116-g13eced9
                ^^^^^^^^ this is the git commit ID

<<<<

Further, quoting the getting started page:

https://btrfs.wiki.kernel.org/index.php/Getting_started

>>>>

btrfs is a fast-moving target. There are typically a great many bug fixes 
and enhancements between one kernel release and the next. Therefore:
If you have btrfs filesystems, run the latest kernel.

If you are running a kernel two or more versions behind the latest one 
available from kernel.org, the first thing you will be asked to when you 
report a problem is to upgrade to the latest kernel. Some distributions 
keep backports of recent kernels to earlier releases -- see the page 
below for details.

Having the latest user-space tools are also useful, as they contain 
additional features and tools which may be of use in debugging or 
recovering your filesystem if something goes wrong.

Note also that btrfs is still considered experimental. While many people 
use it reliably, there are still problems being found.
You should keep and test backups of your data, and be prepared to use 
them.

<<<<

FWIW, my btrfs-progs version built from git a few days ago:

Btrfs v0.20-rc1-596-ge9ac73b

Basically, btrfs-progs development happens in branches, with branches 
pulled to master only when they're considered ready, so master branch 
head is considered the reference for btrfs testing.  If you're behind 
that and can't name a specific bug regression as your reason, you're 
behind.

And as I said, kernel 3.11.1 is not only behind in general (tho still 
within the two releases guideline above so it's not /horribly/ behind 
yet), it's known to be lacking a couple critical patches found in 3.12 
and later 3.11.x stable series.

So testing is good, but please update to current and see if the problem 
remains. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

