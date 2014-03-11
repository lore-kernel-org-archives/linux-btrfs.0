Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20566 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaCKUaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 16:30:18 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Testing BTRFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <531F5F12.4080009@redhat.com>
Date: Wed, 12 Mar 2014 07:30:02 +1100
Cc: Lists <lists@benjamindsmith.com>, linux-btrfs@vger.kernel.org
Message-Id: <DEADBD75-7026-4C5F-89D4-E1074F2AC95E@oracle.com>
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net> <531E5B44.6030502@benjamindsmith.com> <DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com> <531F5F12.4080009@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On 12 Mar 2014, at 6:08 am, Eric Sandeen <sandeen@redhat.com> wrote:

> If we're plugging distros... I can also tell you that you can install
> upcoming RHEL7 on btrfs if you like, and it has a very up-to-date
> btrfs codebase.

Ditto for OL7, for obvious reasons. :)

> Indeed, testing 3.8.13-26.2.1.el6uek.x86_64 (which is, I believe,
> the kernel which Avi referred to) via xfstests, I saw
> failures on btrfs/009 and btrfs/022; then the box deadlocked
> on btrfs/024.  I rebooted & resumed, then deadlocked on btrfs/030.
> Rebooted and resumed again, then panicked on btrfs/035.  At that
> point I stopped.

We have a bunch of btrfs fixes queued for UEK3-QU2 which is in alpha build internally at the moment. We do run the full xfstests against our UEK3 releases and are working with Liu Bo to backport fixes from mainline which should resolve some (hopefully all) of the failing xfstests. It’s also worth ensuring that you’re upgrading the userspace btrfs-progs package that ships with the updated UEK3 kernels, if applicable.

> Ben, the best advice I have for you is to test *your* workload
> on btrfs with whatever qualification tests you have, and see how
> things fare.  If you want to know the current state of btrfs,
> test the upstream code as best you can; if you hope to deploy
> on a distribution with a longer support window, test on that
> distribution.

Agreed.

> But I agree with Josef that for now, the fixes and changes are
> still flying fast & furious, and except in limited use cases,
> btrfs is not yet ready for general commercial deployment.

Obviously, we disagree (somewhat) here. We’re happy with the status of btrfs functionality in UEK3 to provide limited production support, but this is just from the Oracle Linux team. The other product teams within Oracle (RDBMS, Java, middleware, etc) obviously have to do their own validation and testing and are responsible for their own support. As above, I agree with Eric that you should test your own workloads and requirements and make your own judgement call.

Cheers,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

