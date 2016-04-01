Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39370 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbcDADWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 23:22:32 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 1 Apr 2016 13:22:29 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id F2CA62CE8054
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 14:22:24 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u313MGlQ3014984
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Apr 2016 14:22:24 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u313LqBA010717
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Apr 2016 14:21:52 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size
Date: Fri, 01 Apr 2016 08:51:32 +0530
Message-ID: <2002224.hLXqi7HKi6@localhost.localdomain>
In-Reply-To: <20160331135911.GA6230@twin.jikos.cz>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com> <20160331093106.GF27917@twin.jikos.cz> <20160331135911.GA6230@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 31 Mar 2016 15:59:11 David Sterba wrote:
> On Thu, Mar 31, 2016 at 11:31:06AM +0200, David Sterba wrote:
> > On Tue, Mar 22, 2016 at 06:50:32PM +0530, Chandan Rajendra wrote:
> > > On Tuesday 22 Mar 2016 12:04:23 David Sterba wrote:
> > > > On Thu, Feb 11, 2016 at 11:17:38PM +0530, Chandan Rajendra wrote:
> > > > > this patchset temporarily disables the commit
> > > > > f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> > > > > 
> > > > > The commits for the Btrfs kernel module can be found at
> > > > > https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> > > > 
> > > > The branch does not apply cleanly to at least 4.5, I've tried to
> > > > rebase
> > > > it but there are conflicts that are not simple. Please update it on
> > > > top
> > > > of current master, ie. with the preparatory patchset merged.
> > > 
> > > I will rebase the branch and post the patchset soon.
> > 
> > JFYI, I've seen some minor compilation failures:
> > - __do_readpage: unused variable cached
> > - end_bio_extent_buffer_readpage: btree_readahead_hook must tak fs_info
> > - fails build with (config) sanity checks enabled, the fs_info moved
> > 
> >   from eb to eb head
> 
> And the tests crash with my quick fixes, so I'll move the branch out of
> next for now. Please fix it and let me know. My fixes are on top of your
> lastest branch, chandan-subpage-latest in my development gits.

Hi David,

After rebasing the patchset, I found a 'hard to reproduce' space
accounting bug. I am currently figuring out the root cause of the bug. I will
post the patchset once the issue is fixed.

-- 
chandan

