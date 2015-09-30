Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34940 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbbI3KYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:24:38 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:24:36 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id CF59F2CE8052
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:24:33 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UAOE2v54919392
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:24:23 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UAO0Hu016417
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:24:00 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz,
        quwenruo@cn.fujitsu.com, chandan@mykolab.com
Subject: Re: [RFC PATCH V4 00/13] Btrfs: Pre subpagesize-blocksize cleanups
Date: Wed, 30 Sep 2015 15:53:36 +0530
Message-ID: <3010241.PlIdyOUHyB@localhost.localdomain>
In-Reply-To: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 30 Sep 2015 15:48:16 Chandan Rajendra wrote:
> The patches posted along with this cover letter are cleanups made
> during the developement of subpagesize-blocksize patchset. I believe
> that they can be integrated with the mainline kernel. Hence I have
> posted them separately from the subpagesize-blocksize patchset.
> 
> I have testsed the patchset by running xfstests on ppc64 and
> x86_64. On ppc64, some of the Btrfs specific tests and generic/255
> fail because they assume 4K as the filesystem's block size. I have
> fixed some of the test cases. I will fix the rest and mail them to the
> fstests mailing list in the near future.
> 
> Changes from V3:
> Two new issues have been been fixed by the patches,
> 1. Btrfs: prepare_pages: Retry adding a page to the page cache.
> 2. Btrfs: Return valid delalloc range when the page does not have
>    PG_Dirty flag set or has been invalidated.
> IMHO, The above issues are also applicable to the "page size == block
> size" scenario but for reasons unknown to me they aren't seen even
> when the tests are run for a long time.
> 

I accidently added the RFC tag to the patchset. Please ignore the V4
patchset. I will post the V5 without the RFC tag.

-- 
chandan

