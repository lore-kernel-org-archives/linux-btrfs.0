Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaCKTIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 15:08:12 -0400
Message-ID: <531F5F12.4080009@redhat.com>
Date: Tue, 11 Mar 2014 14:08:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Avi Miller <avi.miller@oracle.com>, Lists <lists@benjamindsmith.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Testing BTRFS
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net> <531E5B44.6030502@benjamindsmith.com> <DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com>
In-Reply-To: <DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/10/14, 8:02 PM, Avi Miller wrote:
> 
> On 11 Mar 2014, at 11:39 am, Lists <lists@benjamindsmith.com> wrote:
> 
>> Is there a "recommended way" to do this? Is it anywhere as easy as
>> ZFSonLinux yum install?
> 
> Oracle Linux 6 with the Unbreakable Enterprise Kernel Release 2 or
> Release 3 has production-ready btrfs support. You can even convert
> your existing CentOS6 boxes across to Oracle Linux 6 in-place without
> reinstalling:
> 
> http://linux.oracle.com/switch/centos/

If we're plugging distros... I can also tell you that you can install
upcoming RHEL7 on btrfs if you like, and it has a very up-to-date
btrfs codebase.  Of course Fedora and other "non-enterprise" distros
have btrfs support as well.

But we're keeping it "tech preview" in RHEL7 for now, because in our
testing, it does not yet reach the level of reliability that we
wish to provide to our customers.

Indeed, testing 3.8.13-26.2.1.el6uek.x86_64 (which is, I believe,
the kernel which Avi referred to) via xfstests, I saw
failures on btrfs/009 and btrfs/022; then the box deadlocked
on btrfs/024.  I rebooted & resumed, then deadlocked on btrfs/030.
Rebooted and resumed again, then panicked on btrfs/035.  At that
point I stopped.

Ben, the best advice I have for you is to test *your* workload
on btrfs with whatever qualification tests you have, and see how
things fare.  If you want to know the current state of btrfs,
test the upstream code as best you can; if you hope to deploy
on a distribution with a longer support window, test on that
distribution.

But I agree with Josef that for now, the fixes and changes are
still flying fast & furious, and except in limited use cases,
btrfs is not yet ready for general commercial deployment.

-Eric
