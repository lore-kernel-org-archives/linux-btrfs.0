Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933613AbcATDKZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 22:10:25 -0500
Subject: Re: Btrfs progs release 4.4
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <20160118130626.GK4227@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <569EFA89.7080600@cn.fujitsu.com>
Date: Wed, 20 Jan 2016 11:10:01 +0800
MIME-Version: 1.0
In-Reply-To: <20160118130626.GK4227@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/01/18 14:06 +0100:
> Hi,
>
> btrfs-progs 4.4 have been released.
>
> User visible changes
> --------------------
>
> * mkfs.btrfs --data dup
>
>    People asked about duplicating data on a single device for a long time. There
>    are no technical obstacles preventing that, so it got enabled with a warning
>    about potential dangers when the device will not do the duplicated copies.
>    See mkfs.btrfs section 'DUP PROFILES ON A SINGLE DEVICE'.
>
> * support balance filters added/enhanced in linux 4.4
>
>    * usage=min..max	-- enhanced to take range
>    * stripes=min..max	-- new, filter by stripes for raid0/10/5/6
>    * limit=min..max	-- enhanced to take range
>
>    Due to backward compatibility, the range maximum for 'usage' is not inclusive
>    as for the others, to keep the same behaviour as usage=N .
>
> * manual pages enhanced (btrfs, mkfs, mount, filesystem, balance)
>
> * error messages updates, rewordings -- some fstests may break due to that
>
> * added support for free-space-tree implementation of space cache
>
>    this requires kernel 4.5 and is not recommended for non-developers yet

Hi David,

Not sure if it's intended or just a small miss, in btrfs-progs ctree.h,
there is BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE, but
BTRFS_FEATURE_COMPAT_RO_SUPP is still 0, not including FREE_SPACE_TREE.

Is it intended as current btrfsck doesn't support to modify fs with new 
free space cache tree?

Thanks,
Qu

>
> * 'btrfs filesystem usage' works with mixed blockgroups
>
> Other:
>
> * installation to /usr/local -- this has unintentionally changed during
>    conversion to autotools in 3.19
> * check: fix a false alert where extent record has wrong metadata flag
> * improved stability on fuzzed/crafted images when reading sys array in
>    superblock
> * build: the 'ar' tool is properly deteced during cross-compilation
> * debug-tree: option -t understands ids for tree root and chnuk tree
> * preparatory work for btrfs-convert rewrite
> * sparse, gcc warning fixes
> * more memory allocation failure handling
> * cleanups ...
> * more tests
>
> Bugfixes:
>
> * chunk recovery: fix floating point exception
> * chunk recovery: endianity bugfix during rebuild
> * mkfs with 64K pages and nodesize reported superblock checksum mismatch
> * check: properly reset nlink of multi-linked file
>
>
> Development cycle for 4.5
> -------------------------
>
> There are a few patchsets that did not make it to 4.4 and are currently
> at the top of my list.
>
> * feature compatibility of mkfs and kernel (Anand)
>
> * convert rework (Qu) -- more reivew needed, the pending patches are
>    in branch foreign/qu/convert-rework
>
> * delete device by id (Anand) -- the kernel support is required, I need
>    to look at the patches again
>
> * improved btrfs check progress
>
> There are a few more and I hope I'll get to them eventually. The bi-weekly
> stable releases are supposed to be resumed with bugfixes or docs updates.
>
>
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>
> Byongho Lee (6):
>        btrfs-progs: get sparse checking working
>        btrfs-progs: use NULL instead of 0
>        btrfs-progs: make private symbols to static
>        btrfs-progs: fix endian bugs in chunk rebuilding
>        btrfs-progs: fix endian bug in update_super()
>        btrfs-progs: fix using on-disk structure to store in memory data
>
> Chandan Rajendra (1):
>        btrfs-progs: ftw_add_entry_size: Round up file size to sectorsize
>
> Christoph Anton Mitterer (1):
>        btrfs-progs: document snapshot unaware defrag
>
> David Sterba (79):
>        btrfs-progs: mkfs: use correct size for superblock csum and writeout
>        btrfs-progs: tests: add 007-mix-nodesize-sectorsize
>        btrfs-progs: docs: update raid table in mkfs manpage
>        btrfs-progs: tests: add 019-non-skinny-false-alert
>        btrfs-progs: tests: enhance 001-basic-profiles with --data DUP
>        btrfs-progs: docs: mkfs, implications of DUP on devices
>        btrfs-progs: install to /usr/local by default again
>        btrfs-progs: update btrfs_read_sys_array to match kernel implementation
>        btrfs-progs: cleanup, rename a few variables in btrfs_read_sys_array
>        btrfs-progs: add more checks to btrfs_read_sys_array
>        btrfs-progs: handle invalid num_stripes in sys_array
>        btrfs-progs: verbose error when we find an unexpected item in sys_array
>        btrfs-progs: tests: add sys-array-num-stripes-0.raw.xz
>        btrfs-progs: show-super: copy implementation of btrfs_read_sys_array
>        btrfs-progs: tests: print test type
>        btrfs-progs: extend balance args to take min/max limit filter
>        btrfs-progs: balance: enhance the limit fiter with range
>        btrfs-progs: extend balance args to take min/max usage filter
>        btrfs-progs: balance: enhance the usage filter with range
>        btrfs-progs: use on-stack buffer in add_symbolic_link
>        btrfs-progs: docs, update btrfs(8) manual page
>        btrfs-progs: docs, btrfs-mount: unindent descriptions
>        btrfs-progs: docs, btrfs-mount: put NOTE tag to new paragraph
>        btrfs-progs: docs, btrfs-mount: enhance fatal_erros
>        btrfs-progs: docs, enhance the mount option manual page
>        btrfs-progs: return errors from get_inode_rec, fail in callers
>        btrfs-progs: return errors from clone_inode_rec, fail in callers
>        btrfs-progs: handle errors in add_shared_node and fail in the caller
>        btrfs-progs: return errors from get_root_rec, fail in callers
>        btrfs-progs: handle errors in get_root_backref and fail in the caller
>        btrfs-progs: handle errors in get_inode_backref and fail in the caller
>        btrfs-progs: catch memory allocation failure in splice_shared_node
>        btrfs-progs: catch memory allocation failure from alloc_tree_backref
>        btrfs-progs: catch memory allocation failure from alloc_data_backref
>        btrfs-progs: handler memory allocation failure in add_extent_rec
>        btrfs-progs: catch memory allocation failure in btrfs_split_item
>        btrfs-progs: cmd rescue: switch to common error message wrapper
>        btrfs-progs: cmd quota: switch to common error message wrapper
>        btrfs-progs: cmd balance: switch to common error message wrapper
>        btrfs-progs: cmd property: switch to common error message wrapper
>        btrfs-progs: cmd qgroup: switch to common error message wrapper
>        btrfs-progs: cmd receive: switch to common error message wrapper
>        btrfs-progs: cmd send: switch to common error message wrapper
>        btrfs-progs: cmd subvolume: switch to common error message wrapper
>        btrfs-progs: cmd replace: switch to common error message wrapper
>        btrfs-progs: cmd filesystem: switch to common error message wrapper
>        btrfs-progs: cmd fi usage: switch to common error message wrapper
>        btrfs-progs: cmd property: use correct usage strings
>        btrfs-progs: cleanup, move usage help strings closer to the command callbacks
>        btrfs-progs: docs, btrfs-mount: enhance file attributes section
>        btrfs-progs: docs: rename btrfs-mount to btrfs-man5
>        btrfs-progs: docs: sort mount options alphabetically
>        btrfs-progs: docs: document new mount option fragment
>        btrfs-progs: free-space-tree: minor message adjustments
>        btrfs-progs: remove unnecessary errno temp variables
>        btrfs-progs: check for negative return value from ioctl
>        btrfs-progs: build: fix builds with extra warnings, W=1
>        btrfs-progs: add function attributes for the printf-like
>        btrfs-porgs: qgroup: rename variable to avoid shadowing
>        btrfs-porgs: check: rename variable to avoid shadowing
>        btrfs-porgs: fi usage: rename variable to avoid shadowing
>        btrfs-progs: tests: add missing prerequisites
>        btrfs-progs: docs: enhance btrfs-filesystem manual page
>        btrfs-progs: fi usage: support mixed blockgroups
>        btrfs-progs: subvol show: handle options by getopt
>        btrfs-progs: debug-tree: teach -t option about the chunk and root trees
>        btrfs-progs: let test_isdir return the exact error
>        btrfs-progs: handle errors from test_isdir
>        btrfs-progs: use symbolic name for subvolume inode number in test_issubvolume
>        btrfs-progs: let test_issubvolume return the exact error
>        btrfs-progs: more verbose errors from test_issubvolume
>        btrfs-progs: also check filesystem type in test_issubvolume
>        btrfs-progs: receive: don't leak open find handle
>        btrfs-progs: move prefixcmp to utils
>        btrfs-progs: introduce helper for parsing args without options
>        btrfs-progs: subvol show: use clean_args_no_options instead of opencoding
>        Btrfs progs v4.4-rc1
>        btrfs-progs: debug-tree: tweak tree node checks
>        btrfs-progs: docs: update balance manual page
>
> Gabríel Arthúr Pétursson (1):
>        btrfs-progs: balance: add stripes filter
>
> Jeff Mahoney (1):
>        btrfs-progs: convert: add context and operations struct to allow different file systems
>
> Jeffrey Schiller (1):
>        btrfs-progs: docs: fix typo in balance man page
>
> Khem Raj (1):
>        btrfsprogs: corrupt-blocks: include limits.h to define PATH_MAX
>
> Liu Bo (1):
>        Btrfs-progs: fix typo in parse_range
>
> Mike Gilbert (1):
>        btrfs-progs: Use AC_CHECK_TOOL to find AR
>
> Naohiro Aota (2):
>        btrfs-progs: check, properly reset nlink of multi-linked file
>        btrfs-progs: tests: test multiple-linked file corruption
>
> Neil Horman (1):
>        btrfs: only free root_path if it was allocated from the heap
>
> Noah Massey (1):
>        btrfs-progs: fix static build
>
> Omar Sandoval (2):
>        btrfs-progs: add basic awareness of the free space tree
>        btrfs-progs: check the free space tree in btrfsck
>
> Qu Wenruo (7):
>        btrfs-progs: chunk-recovery: Fix a float point error
>        btrfs-progs: fsck: Fix a false alert where extent record has wrong metadata flag
>        btrfs-progs: tests: mkfs, check sectorsize and nodesize combinations
>        btrfs-progs: extent-cache: Add comments for search/lookup functions
>        btrfs-progs: extent-tree: Add add_merge_cache_extent function
>        btrfs-progs: Introduce new members for btrfs_convert_context
>        btrfs-progs: Enhance chunk validation check
>
> Zhao Lei (1):
>        btrfs-progs: mkfs: allow --data DUP for single device
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


