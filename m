Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbbIINUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 09:20:11 -0400
Date: Wed, 9 Sep 2015 15:19:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150909131925.GG8891@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <55EF8CBD.3020105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55EF8CBD.3020105@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 09:34:53AM +0800, Qu Wenruo wrote:
> > David Sterba (79):
> >        btrfs-progs: tests: log the test name in results file
> >        btrfs-progs: tests: support more formats of test images
> >        btrfs-progs: tests: use readlink -f to resolve path
> >        btrfs-progs: tests: sort image files
> >        btrfs-progs: test: 015-check-bad-memory-access
> >        btrfs-progs: tests: add script to clean intermediate images
> >        btrfs-progs: receive: restore capabilities after chown
> >        btrfs-progs: tests: add driver script for misc tests
> >        btrfs-progs: tests: common: add helper run_check_stdout
> >        btrfs-progs: tests: add misc test for fs features
> >        btrfs-progs: update .gitignore
> >        btrfs-progs: subvol show: print received uuid
> >        btrfs-progs: subvol show: tweak output
> >        btrfs-progs: btrfstune: rework option handling
> >        btrfs-progs: btrfstune: add option to enable NO_HOLES
> >        btrfs-progs: doc: update btrfstune manpage
> >        btrfs-progs: tests: add misc tests for uuid rewrite
> >        btrfs-progs: btrfstune: make uuid rewrite progress more verbose
> >        btrfs-progs: ioctl.h: reorder to match kernel uapi header
> >        btrfs-progs: ioctl.h: copy commented version of scrub_progress structure
> >        btrfs-progs: ioctl.h: copy commented version of balance structures
> >        btrfs-progs: ioctl.h: add EXTENT_SAME ioctl and structures
> >        btrfs-progs: ioctl.h: add send flag mask
> >        btrfs-progs: ioctl.h: update type annotations
> >        btrfs-progs: ioctl.h: update btrfs_ioctl_fs_info_args
> >        btrfs-progs: ioctl.h: add btrfs_ioctl_feature_flags struct
> >        btrfs-progs: doc: update btrfs-rescue page and drop btrfs-zero-log
> >        btrfs-progs: scrub: more friendly duration format in status
> >        btrfs-progs: add function to stringify filesystem features
> >        btrfs-progs: convert: allow to set filesystem features
> 
> Tons of new patches, but at least I didn't find the patch in mail list 
> for the above convert patch, when I want to comment on it.

Well, I'm doing lots of small and boring patches that I consider noisy
for the mailinglist, OTOH I introduced some bugs that would be caught by
reviews.

> So I can only comment here.
> 
> [[Good fix even before we found the real bug]]
> This convert patch is quite good, as it in fact addressed the 
> metadata-cross-map-boundary bug, even before we found it.

I was totally unaware of this consequence. So this narrows the bug to

* introduced: 3.19.1 (16k nodesize for convert)
* last not fixed: 4.0.1

So anything 4.1+ should be fine.

> [[True fix]]
> IMHO, I still prefer to use mixed block group for btrfs-convert, as that 
> fits better for the use case.

While I don't mind adding mixed-bg support to convert options, I think
we first need to add support to mixed bg balance filters. The typical
filesystem size being converted from extN to btrfs is much larger than
the forced mixed-bg flag (1G nowadays).

> And what we really need is, to keep fixing btrfs-convert and kernel.
> Banning mixed bg for convert case is just avoiding the real cause, and I 
> think that should be the last method.

The allowed convert features were added to the mask if they looked safe
to me at the time.
