Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64179 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932595AbcGOL6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 07:58:52 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6FBs9kS125624
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 07:58:51 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
	by mx0b-001b2d01.pphosted.com with ESMTP id 246hekfea3-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 07:58:51 -0400
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 15 Jul 2016 21:58:48 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 158E72BB0057
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 21:58:46 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6FBwjF026411236
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 21:58:45 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6FBwjxh005412
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 21:58:45 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allocate exact page array size in extent_buffer
Date: Fri, 15 Jul 2016 17:28:42 +0530
In-Reply-To: <20160715094406.GR10595@twin.jikos.cz>
References: <1468499372-24687-1-git-send-email-dsterba@suse.com> <3567275.PIHfl50pLS@localhost.localdomain> <20160715094406.GR10595@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2207881.izrC6JhlLc@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, July 15, 2016 11:44:06 AM David Sterba wrote:
> On Fri, Jul 15, 2016 at 11:47:07AM +0530, Chandan Rajendra wrote:
> > On Thursday, July 14, 2016 02:29:32 PM David Sterba wrote:
> > > The calculation of extent_buffer::pages size was done for 4k PAGE_SIZE,
> > > but this wastes 15 unused pointers on arches with large page size. Eg.
> > > on ppc64 this gives 15 * 8 = 120 bytes.
> > >
> > 
> > The non PAGE_SIZE aligned extent buffer usage in page straddling tests in
> > test_eb_bitmaps() need atleast one more page. So how about the following ...
> > 
> > #define INLINE_EXTENT_BUFFER_PAGES    (BTRFS_MAX_METADATA_BLOCKSIZE / PAGE_SIZE + 1)
> 
> Could the extra page pointer be normally used? Ie. not just for the sake
> of the tests. I'd rather not waste the bytes. As a compromise, we can do +1
> only if the tests are compiled in.
> 

I don't see any other scenario where the extra page pointer gets used. Also, I
just executed fstests with your patch applied and disabling self-tests from
the kernel configuration. The tests ran fine.

-- 
chandan

