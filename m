Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36613 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcDZNyr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:54:47 -0400
Received: by mail-io0-f193.google.com with SMTP id k129so2186668iof.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 06:54:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Date: Tue, 26 Apr 2016 14:54:46 +0100
Message-ID: <CAL3q7H4+SOxG88RAGAdt+npPJ6nhehwmVySGdGD-dVv9u-h_zQ@mail.gmail.com>
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than
 page size
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 2:26 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
>
> This patchset continues with the work posted previously at
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/55257.
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
>      branch also do so with the patches applied.
> 2. ppc64
>    - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
>      option, except for scrub and compression tests, all the tests
>      that succeed with the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.

Hi Chandan,

What does it mean the tests don't pass? Is there absolutely no code
changes for scrub and compression, or there is but still needs more
working, or what?

What happens if, when one is using block size < page size, and enables
compression on a single file (i.e. fs not mounted with -o compress or
force-compress), we start writing and read to the file? Does it result
in the syscalls failing with -EIO or some other error, does it result
in crashes (BUG_ON(), etc), dues it result in transparently falling
back to non compression mode, or what happens exactly?

Same kind of question regarding scrub.

thanks


>    - With 64k sectorsize & nodesize, all the tests that succeed with
>      the master branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>      branch also do so with the patches applied.
>
> TODO:
> 1. The selftests code needs to be fixed to work in subpage-blocksize
>    scenario. I have currently disabled self-tests from my kernel
>    configuration. We can expect an mail from kbuild indicating a
>    build failure for self-tests code.
> 2. I am planning to fix Scrub & Compression via a separate patchset.
>
> Changes from V17:
> 1. Due to mistakes made during git rebase operations, fixes ended up
>    in incorrect patches. This patchset gets the fixes in the right
>    patches.
>
> Changes from V16:
> 1. The V15 patchset consisted of patches obtained from an incorrect
>    git branch. Apologies for the mistake. All the entries listed under
>    "Changes from V15" hold good for V16.
>
> Changes from V15:
> 1. The invocation of cleancache_get_page() in __do_readpage() assumed
>    blocksize to be same as PAGE_SIZE. We now invoke cleancache_get_page()
>    only if blocksize is same as PAGE_SIZE. Thanks to David Sterba for
>    pointing this out.
> 2. In __extent_writepage_io() we used to accumulate all the contiguous
>    dirty blocks within the page before submitting the file offset range
>    for I/O. In some cases this caused the bio to span across more than
>    a stripe. For example, With 4k block size, 64K stripe size
>    and 64K page size, assume
>    - All the blocks mapped by the page are contiguous on the logical
>      address space.
>    - The first block of the page is mapped to the second block of the
>      stripe.
>    In such a scenario, we would add all the blocks of the page to
>    bio. This would mean that we would overflow the stripe by one 4K
>    block. Hence this patchset removes the optimization and invokes
>    submit_extent_page() for every dirty 4K block.
> 3. The following patches are newly added:
>    - Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset
>      when moving to a new bio_vec
>    - Btrfs: subpage-blocksize: Make file extent relocate code subpage
>      blocksize aware
>    - Btrfs: btrfs_clone: Flush dirty blocks of a page that do not map
>      the clone range
>
> Changes from V14:
> 1. Fix usage of cleancache_get_page() in __do_readpage().
>    In filesystems which support subpage-blocksize scenario, a page can
>    map one or more blocks. Hence cleancache_get_page() should be
>    invoked only when the page maps a non-hole extent and block size
>    being used is equal to the page size. Thanks to David Sterba for
>    pointing this out.
> 2. Replace page_read_complete() and page_write_complete() functions
>    with page_io_complete().
> 3. Provide more documentation (as part of both commit message and code
>    comments) about the usage of the per-page
>    btrfs_page_private->io_lock.
>
> Changes from V13:
> 1. Enable dedup ioctl to work in subpagesize-blocksize scenario.
>
> Changes from V12:
> 1. The logic in the function btrfs_punch_hole() has been fixed to
>    check for the presence of BLK_STATE_UPTODATE flags for blocks in
>    pages which partially map the file range being punched.
>
> Changes from V11:
> 1. Addressed the review comments provided by Liu Bo for version V11.
> 2. Fixed file defragmentation code to work in subpagesize-blocksize
>    scenario.
> 3. Many "hard to reproduce" bugs were fixed.
>
> Chandan Rajendra (18):
>   Btrfs: subpage-blocksize: Fix whole page read.
>   Btrfs: subpage-blocksize: Fix whole page write
>   Btrfs: subpage-blocksize: Make sure delalloc range intersects with the
>     locked page's range
>   Btrfs: subpage-blocksize: Define extent_buffer_head.
>   Btrfs: subpage-blocksize: Read tree blocks whose size is < PAGE_SIZE
>   Btrfs: subpage-blocksize: Write only dirty extent buffers belonging to
>     a page
>   Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize
>     < PAGE_SIZE
>   Btrfs: subpage-blocksize: Deal with partial ordered extent
>     allocations.
>   Btrfs: subpage-blocksize: Explicitly track I/O status of blocks of an
>     ordered extent.
>   Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
>   Btrfs: subpage-blocksize: Prevent writes to an extent buffer when
>     PG_writeback flag is set
>   Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
>   Btrfs: subpage-blocksize: Fix file defragmentation code
>   Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page
>     from being unlocked more than once
>   Btrfs: subpage-blocksize: Enable dedupe ioctl
>   Btrfs: btrfs_clone: Flush dirty blocks of a page that do not map the
>     clone range
>   Btrfs: subpage-blocksize: Make file extent relocate code subpage
>     blocksize aware
>   Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when
>     moving to a new bio_vec
>
>  fs/btrfs/ctree.c             |   37 +-
>  fs/btrfs/ctree.h             |    6 +-
>  fs/btrfs/disk-io.c           |  156 ++--
>  fs/btrfs/disk-io.h           |    3 +
>  fs/btrfs/extent-tree.c       |   17 +-
>  fs/btrfs/extent_io.c         | 1611 +++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.h         |  145 +++-
>  fs/btrfs/file-item.c         |    7 +-
>  fs/btrfs/file.c              |   82 ++-
>  fs/btrfs/inode.c             |  491 +++++++++----
>  fs/btrfs/ioctl.c             |  219 ++++--
>  fs/btrfs/locking.c           |   24 +-
>  fs/btrfs/locking.h           |    2 -
>  fs/btrfs/ordered-data.c      |   19 +
>  fs/btrfs/ordered-data.h      |    4 +
>  fs/btrfs/relocation.c        |   70 +-
>  fs/btrfs/root-tree.c         |    2 +-
>  fs/btrfs/volumes.c           |    2 +-
>  include/trace/events/btrfs.h |    2 +-
>  19 files changed, 2050 insertions(+), 849 deletions(-)
>
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
