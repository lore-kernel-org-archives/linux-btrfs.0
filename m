Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58703 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089AbcGQMTf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 08:19:35 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6HCEHEf133418
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 08:19:34 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2482dyr4y7-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 08:19:34 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 17 Jul 2016 22:19:31 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 5E38B2BB0045
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 22:19:28 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6HCJSE522872168
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 22:19:28 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6HCJRG0007296
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 22:19:28 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on big-endian systems
Date: Sun, 17 Jul 2016 17:49:24 +0530
In-Reply-To: <20160715191515.GA13357@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com> <48955009.Up9FeqXyzx@localhost.localdomain> <20160715191515.GA13357@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3006396.dOAW6WHiJC@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, July 15, 2016 12:15:15 PM Omar Sandoval wrote:
> On Fri, Jul 15, 2016 at 12:34:10PM +0530, Chandan Rajendra wrote:
> > On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
> > > On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > >
> > > > So it turns out that the free space tree bitmap handling has always been
> > > > broken on big-endian systems. Totally my bad.
> > > >
> > > > Patch 1 fixes this. Technically, it's a disk format change for
> > > > big-endian systems, but it never could have worked before, so I won't go
> > > > through the trouble of any incompat bits. If you've somehow been using
> > > > space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> > > > to want to mount with nospace_cache to clear it and wait for this to go
> > > > in.
> > > >
> > > > Patch 2 fixes a similar error in the sanity tests (it's the same as the
> > > > v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> > > > oversight that patch 1 fixes.
> > > >
> > > > Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> > > > pass on x86_64 and MIPS.
> > > 
> > > Thanks for fixing this up Omar.  Any big endian friends want to try this 
> > > out in extended testing and make sure we've nailed it down?
> > >
> > 
> > Hi Omar & Chris,
> > 
> > I will run fstests with this patchset applied on ppc64 BE and inform you about
> > the results.
> > 
> 
> Thanks, Chandan! I set up my xfstests for space_cache=v2 by doing:
> 
>     mkfs.btrfs "$TEST_DEV"
>     mount -o space_cache=v2 "$TEST_DEV" "$TEST_DIR"
>     umount "$TEST_DEV"
> 
> and adding
> 
>     export MOUNT_OPTIONS="-o space_cache=v2"
> 
> to local.config. btrfsck also needs the patch here [1].
> 
> 

Hi,

I did execute the fstests tests suite on ppc64 BE as per above configuration
and there were no new regressions. Also, I did execute fsx (via generic/127)
thrice on the same filesystem instance,
1. With the unpatched kernel and later
2. With the patched kernel and again
3. With the unpatched kernel
... there were no new regressions when executing the above steps.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

