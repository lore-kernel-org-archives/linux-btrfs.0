Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbcCaN7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 09:59:48 -0400
Date: Thu, 31 Mar 2016 15:59:11 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on
 blocks whose size is less than page size
Message-ID: <20160331135911.GA6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20160322110423.GI8095@twin.jikos.cz>
 <2160706.r0KK2PuPMm@localhost.localdomain>
 <20160331093106.GF27917@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160331093106.GF27917@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 11:31:06AM +0200, David Sterba wrote:
> On Tue, Mar 22, 2016 at 06:50:32PM +0530, Chandan Rajendra wrote:
> > On Tuesday 22 Mar 2016 12:04:23 David Sterba wrote:
> > > On Thu, Feb 11, 2016 at 11:17:38PM +0530, Chandan Rajendra wrote:
> > > > this patchset temporarily disables the commit
> > > > f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> > > > 
> > > > The commits for the Btrfs kernel module can be found at
> > > > https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> > > 
> > > The branch does not apply cleanly to at least 4.5, I've tried to rebase
> > > it but there are conflicts that are not simple. Please update it on top
> > > of current master, ie. with the preparatory patchset merged.
> > 
> > I will rebase the branch and post the patchset soon.
> 
> JFYI, I've seen some minor compilation failures:
> - __do_readpage: unused variable cached
> - end_bio_extent_buffer_readpage: btree_readahead_hook must tak fs_info
> - fails build with (config) sanity checks enabled, the fs_info moved
>   from eb to eb head

And the tests crash with my quick fixes, so I'll move the branch out of
next for now. Please fix it and let me know. My fixes are on top of your
lastest branch, chandan-subpage-latest in my development gits.
