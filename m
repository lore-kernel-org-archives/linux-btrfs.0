Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52267 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbcCVNV2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 09:21:28 -0400
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 22 Mar 2016 23:21:25 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 643DA357805A
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 00:21:23 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2MDLFvV9371910
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 00:21:23 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2MDKoZA015430
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 00:20:50 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size
Date: Tue, 22 Mar 2016 18:50:32 +0530
Message-ID: <2160706.r0KK2PuPMm@localhost.localdomain>
In-Reply-To: <20160322110423.GI8095@twin.jikos.cz>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com> <20160322110423.GI8095@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 Mar 2016 12:04:23 David Sterba wrote:
> On Thu, Feb 11, 2016 at 11:17:38PM +0530, Chandan Rajendra wrote:
> > this patchset temporarily disables the commit
> > f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> > 
> > The commits for the Btrfs kernel module can be found at
> > https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> 
> The branch does not apply cleanly to at least 4.5, I've tried to rebase
> it but there are conflicts that are not simple. Please update it on top
> of current master, ie. with the preparatory patchset merged.

Hi David,

I will rebase the branch and post the patchset soon.

-- 
chandan

