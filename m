Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([125.16.236.3]:33710 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcD1Ebr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 00:31:47 -0400
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 28 Apr 2016 10:01:44 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 1C7BB125804F
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:03:40 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3S4Vheq18153848
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:01:43 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3S4Vcvk000430
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:01:39 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        chandan@mykolab.com
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than page size
Date: Thu, 28 Apr 2016 10:01:22 +0530
Message-ID: <11247830.uhZQD9UGL6@localhost.localdomain>
In-Reply-To: <20160427171534.GL29353@twin.jikos.cz>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com> <1812092.vCqY3YhCNW@localhost.localdomain> <20160427171534.GL29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 27 Apr 2016 19:15:34 David Sterba wrote:
> On Tue, Apr 26, 2016 at 08:48:49PM +0530, Chandan Rajendra wrote:
> > On Tuesday 26 Apr 2016 14:54:46 Filipe Manana wrote:
> > > Hi Chandan,
> > > 
> > > What does it mean the tests don't pass? Is there absolutely no code
> > > changes for scrub and compression, or there is but still needs more
> > > working, or what?
> > 
> > Hi Filipe,
> > 
> > The patches that have been sent have no changes made with respect to
> > either
> > scrub or compression.
> > 
> > > What happens if, when one is using block size < page size, and enables
> > > compression on a single file (i.e. fs not mounted with -o compress or
> > > force-compress), we start writing and read to the file? Does it result
> > > in the syscalls failing with -EIO or some other error, does it result
> > > in crashes (BUG_ON(), etc), dues it result in transparently falling
> > > back to non compression mode, or what happens exactly?
> > 
> > With the current patchset, reading/writing to a compressed file in
> > (block size == page size) scenario works fine. However reading/writing to
> > a
> > compressed file in (block size < page size) results in crashes.
> 
> Lack of support for compression was pre-agreed but chrashes do not seem
> ok to me, if there are EINVAL or EOPNOTSUPP erros that would be
> acceptable for the first version I think. We will run fstests with this
> patchset so if a test fails then we can see if it was due to
> compression, but a crash would make testing tedious, manual test
> exception needed etc.

In the next revision of the patchset, I will make sure the code returns
EINVAL or EOPNOTSUPP in case I/O is performed on compressed files in
subpage-blocksize scenario.

-- 
chandan

