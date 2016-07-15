Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51136 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbcGOHEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 03:04:25 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6F73c6k008748
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 03:04:24 -0400
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
	by mx0a-001b2d01.pphosted.com with ESMTP id 246kcjkrv5-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 03:04:24 -0400
Received: from localhost
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 15 Jul 2016 17:04:22 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 7A32E2BB0059
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 17:04:13 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6F74DUm21692622
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 17:04:13 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6F74Cud030698
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 17:04:13 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on big-endian systems
Date: Fri, 15 Jul 2016 12:34:10 +0530
In-Reply-To: <7d7ada29-f53a-bcc8-9344-85733f030c4b@fb.com>
References: <cover.1468538030.git.osandov@fb.com> <7d7ada29-f53a-bcc8-9344-85733f030c4b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <48955009.Up9FeqXyzx@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
> On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> >
> > So it turns out that the free space tree bitmap handling has always been
> > broken on big-endian systems. Totally my bad.
> >
> > Patch 1 fixes this. Technically, it's a disk format change for
> > big-endian systems, but it never could have worked before, so I won't go
> > through the trouble of any incompat bits. If you've somehow been using
> > space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> > to want to mount with nospace_cache to clear it and wait for this to go
> > in.
> >
> > Patch 2 fixes a similar error in the sanity tests (it's the same as the
> > v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> > oversight that patch 1 fixes.
> >
> > Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> > pass on x86_64 and MIPS.
> 
> Thanks for fixing this up Omar.  Any big endian friends want to try this 
> out in extended testing and make sure we've nailed it down?
>

Hi Omar & Chris,

I will run fstests with this patchset applied on ppc64 BE and inform you about
the results.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
chandan

