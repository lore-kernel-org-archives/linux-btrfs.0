Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbcDVRqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 13:46:16 -0400
Date: Fri, 22 Apr 2016 10:46:13 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About fi du and reflink/dedupe
Message-ID: <20160422174613.GY2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <0e9b715e-0cb3-c7a3-e40e-36c9be1f53bd@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0e9b715e-0cb3-c7a3-e40e-36c9be1f53bd@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 10:57:29AM +0800, Qu Wenruo wrote:
> Hi Mark,
> 
> Thanks for your contribution to btrfs-filesystem-du command.
> 
> However there seems to be some strange behavior related to
> reflinke(and further in-band dedupe).
> (And the root cause is lying quite deep into kernel backref resolving codes)
> 
> ["Exclusive" value not really exclsuive]
> When a file with 2 file extents, and the 2nd file extent points to
> the 1st one, the fi du gives wrong answer
> 
> The following command can create such file easily.
> 
> # mkfs.btrfs -f /dev/sdb5
> # mount /dev/sdb5 /mnt/test
> # xfs_io -f -c "pwrite 0 128K" /mnt/test/tmp
> # xfs_io -c "reflink /mnt/test/tmp 0 128K 128K" /mnt/test/tmp
> # btrfs fi du /mnt/test
>      Total   Exclusive  Set shared  Filename
>  256.00KiB   256.00KiB           -  /mnt/test//tmp
>  256.00KiB   256.00KiB       0.00B  /mnt/test/
> 
> Total seems to be OK, while I am confused of the exclusive value.
> 
> As the above method will only create one real data extent, which
> takes 128K, and if following the qgroup definition, its exclusive
> should be 128K other than 256K.

Ok that's a bug in how we're counting these. We already record extent start
offsets so it's easy enough to see when we have the same extent in a file
while we fiemap it. Thanks for reporting this I'll take a look at a fix.


> And what's more, if we modify btrfs_check_shared() to return SHARED
> flag for such case, we will get 0 exclusive value for it.
> Which is quite strang. (I assume the exclusive should be 128K)
> 
> [Slow btrfs_check_shared() performance]
> In above case, btrfs fi du returns very fast.
> But when the file is in-band deduped and size goes to 1G.
> btrfs_check_shared() will take a lot of time to return, as it will
> do backref walk through.
> 
> This would be a super huge problem for inband dedupe.
> 
> 
> [Possible solution]
> Would you please consider to judge shared extent in user space?
> And don't rely on the SHARED flag from fiemap.

_Absoletely Not_

We don't ask userspace to modify their applications if there's a peformance
problem in fiemap, we fix the performance problem in fiemap. Off the top of
my head I can think of at least TWO other applications which rely on fiemap
heavily. You will have very little luck in asking them to modify their
applications.

If btrfs fiemap is broken, we fix that full stop.

More specifically, If in-band dedupe is causing fiemap to go out to lunch
'for a year', we need to address the core problem in in-band dedupe. If it's
a general problem in btrfs fiemap when we need to track it down before users
start yelling at us.
	--Mark

--
Mark Fasheh
