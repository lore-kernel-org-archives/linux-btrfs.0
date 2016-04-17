Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([125.16.236.3]:33824 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbcDQMc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 08:32:57 -0400
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 17 Apr 2016 18:02:55 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay08.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3HCWqu821299382
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 18:02:52 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3HCWo3K032276
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 18:02:52 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com, jbacik@fb.com, chandan@mykolab.com,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH V17 00/18] Allow I/O on blocks whose size is less than page size
Date: Sun, 17 Apr 2016 18:02:40 +0530
Message-ID: <1895026.yWZ6EYWqV5@localhost.localdomain>
In-Reply-To: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 14 Apr 2016 19:08:09 Chandan Rajendra wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
> 
> This patchset continues with the work posted previously at
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/53073.
> 
> I have reverted the upstream commit "btrfs: fix lockups from
> btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
> since this led to soft-lockups when the patch "Btrfs:
> subpagesize-blocksize: Prevent writes to an extent buffer when
> PG_writeback flag is set" is applied. During 2015's Vault Conference
> Btrfs meetup, Chris Mason had suggested that he will write up a
> suitable locking function to be used when writing dirty pages that map
> metadata blocks. Until we have a suitable locking function available,
> this patchset temporarily disables the commit
> f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
> 
> The commits for the Btrfs kernel module can be found at
> https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> 
> To create a filesystem with block size < page size, a patched version
> of the Btrfs-progs package is required. The corresponding fixes for
> Btrfs-progs can be found at
> https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.
> 
> Fstests run status:
> 1. x86_64
>    - With 4k sectorsize, all the tests that succeed with the master
>      branch at git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
> branch also do so with the patches applied.
> 2. ppc64
>    - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
>      option, except for scrub and compression tests, all the tests
>      that succeed with the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
>    - With 64k sectorsize & nodesize, all the tests that succeed with
>      the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
> 
> TODO:
> 1. The selftests code needs to be fixed to work in subpage-blocksize
>    scenario.
> 2. I am planning to fix Scrub & Compression via a separate patchset.
>

Hi,

I had messed up the following four patches during rebase operations.
[PATCH] Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
[PATCH] Btrfs: subpage-blocksize: Define extent_buffer_head.
[PATCH] Btrfs: subpage-blocksize: Make sure delalloc range intersects with the
locked page's range 
[PATCH] Btrfs: subpage-blocksize: Prevent writes to an extent buffer when
PG_writeback flag is set

Instead of sending the complete patchset once again, I have resent only the
above listed patches as replies to the corresponding mails. Please use the
new patches instead of the corresponding old ones.

-- 
chandan

