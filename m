Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52836 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbcFXELJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 00:11:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5O48t5J073954
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 00:11:08 -0400
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23qq3mxhyu-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 00:11:07 -0400
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 24 Jun 2016 14:11:05 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 5E9222CE8057
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:11:02 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5O4B2Ke10813872
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:11:02 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5O4B1Dt012351
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:11:02 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Date: Fri, 24 Jun 2016 09:40:58 +0530
In-Reply-To: <20160623121738.GZ4915@twin.jikos.cz>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com> <1580932.8KuVbA1pQp@localhost.localdomain> <20160623121738.GZ4915@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3861702.Xcdtfm9iJz@reserved-192-168-1-6.rchland.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, June 23, 2016 02:17:38 PM David Sterba wrote:
> On Tue, Jun 21, 2016 at 10:25:19PM +0530, Chandan Rajendra wrote:
> > > > I'm completely OK to do the rebase, but since I don't have 64K page size 
> > > > machine to test the rebase, we can only test if 4K system is unaffected.
> > > > 
> > > > Although not much help, at least it would be better than making it compile.
> > > > 
> > > > Also such rebase may help us to expose bad design/unexpected corner case 
> > > > in dedupe.
> > > > So if it's OK, please let me try to do the rebase.
> > > 
> > > Well, if you base dedupe on subpage, then it could be hard to find the
> > > patchset that introduces bugs, or combination of both. We should be able
> > > to test the features independently, and thus I'm proposing to first find
> > > some common patchset that makes that possible.
> > 
> > I am not sure if I understood the above statement correctly. Do you mean to
> > commit the 'common/simple' patches from both the subpage-blocksize & dedupe
> > patchset first and then bring in the complicated ones later?
> 
> That would be great yes, but ...
> 
> > If yes, then we have a problem doing that w.r.t subpage-blocksize
> > patchset. The first few patches bring in the core changes necessary for the
> > other remaining patches.
> 
> ... not easily possible. I looked again for common functions that change
> the singature and found only cow_file_range and run_delalloc_nocow. The
> plan:
> 
> - separate patch that adds new parameters required by both patches to
>   the functions
> - update all call sites, add 0/NULL as defaults for the new unused
>   parameters
> - rebase both patches on top of this patch
> 
> How does this help: if a patch starts to use the new parameter, it
> changes only the value at all call sites. This is much easier to verify
> and merge manually compared to adding a new parameter to the middle of
> the list, namely when the functions take 6+.

David, I can implement it. In my next post of the subpage-blocksize patchset, I
will bring in this change.


-- 
chandan

