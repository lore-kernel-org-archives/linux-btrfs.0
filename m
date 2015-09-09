Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27868 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752623AbbIIDYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 23:24:25 -0400
Subject: Re: Btrfs progs release 4.1
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <20150622150023.GX6761@twin.jikos.cz>
 <55EF8CBD.3020105@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55EFA661.2050102@cn.fujitsu.com>
Date: Wed, 9 Sep 2015 11:24:17 +0800
MIME-Version: 1.0
In-Reply-To: <55EF8CBD.3020105@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/09/09 09:34 +0800:
> Hi David,
>
> Sorry for the late reply, but I noticed something interesting.
>
> David Sterba wrote on 2015/06/22 17:00 +0200:
>> Hi,
>>
>> btrfs-progs 4.1 have been released (in time with kernel 4.1). Unusual
>> load of
>> changes.
>>
>> Fixed since rc1:
>>    - uuid rewrite prints the correct original UUID
>>    - map-logical updated
>>    - fi show size units
>>    - typos
>>
>> * bugfixes
>>    - fsck.btrfs: no bash-isms
>>    - bugzilla 97171: invalid memory access (with tests)
>>    - receive:
>>      - cloning works with --chroot
>>      - capabilities not lost
>>    - mkfs: do not try to register bare file images
>>    - option --help accepted by the standalone utilities
>>
>> * enhancements
>>    - corrupt block: ability to remove csums
>>    - mkfs:
>>      - warn if metadata redundancy is lower than for data
>>      - options to make the output quiet (only errors)
>>      - mixed case names of raid profiles accepted
>>      - rework the output:
>>        - more comprehensive, 'key: value' format
>>    - subvol:
>>      - show:
>>        - print received uuid
>>        - update the output
>>        - new options to specify size units
>>      - sync:
>>        - grab all deleted ids and print them as they're removed,
>>     previous implementation only checked if there are any
>>     to be deleted - change in command semantics
>>    - scrub: print timestamps in days HMS format
>>    - receive:
>>      - can specify mount point, do not rely on /proc
>>      - can work inside subvolumes
>>    - send:
>>      - new option to send stream without data (NO_FILE_DATA)
>>    - convert:
>>      - specify incompat features on the new fs
>>    - qgroup:
>>      - show: distinguish no limits and 0 limit value
>>      - limit: ability to clear the limit
>>    - help for 'btrfs' is shorter, 1st level command overview
>>    - debug tree: print key names according to their C name
>>
>> * new
>>    - rescure zero-log
>>    - btrfsune:
>>      - rewrite uuid on a filesystem image
>>      - new option to turn on NO_HOLES incompat feature
>>
>> * deprecated
>>    - standalone btrfs-zero-log
>>
>> * other
>>    - testing framework updates
>>      - uuid rewrite test
>>      - btrfstune feature setting test
>>      - zero-log tests
>>      - more testing image formats
>>    - manual page updates
>>    - ioctl.h synced with current kernel uapi version
>>    - convert: preparatory works for more filesystems (reiserfs pending)
>>    - use static buffers for path handling where possible
>>    - add new helpers for send uilts that check memory allocations,
>>      switch all users, deprecate old helpers
>>    - Makefile: fix build dependency generation
>>    - map-logical: make it work again
>>
>> Tarballs:
>> https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
>> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>>
>> Shortlog:
>>
>> Anand Jain (2):
>>        btrfs-progs: add info about list-all to the help
>>        btrfs-progs: use function is_block_device() instead
>>
>> Dimitri John Ledkov (1):
>>        btrfs-progs: fsck.btrfs: Fix bashism and bad getopts processing
>>
>> Dongsheng Yang (4):
>>        btrfs-progs: qgroup: show 'none' when we did not limit it on
>> this qgroup
>>        btrfs-progs: qgroup: allow user to clear some limitation on
>> qgroup.
>>        btrfs-progs: qgroup limit: error out if input value is negative
>>        btrfs-progs: qgroup limit: add a check for invalid input of
>> 'T/G/M/K'
>>
>> Emil Karlson (1):
>>        btrfs-progs: use openat for process_clone in receive
>>
>> Goffredo Baroncelli (4):
>>        btrfs-progs: add strdup in btrfs_add_to_fsid() to track the
>> device path
>>        btrfs-progs: return the fsid from make_btrfs()
>>        btrfs-progs: mkfs: track sizes of created block groups
>>        btrfs-progs: mkfs: print the summary
>>
>> Jeff Mahoney (8):
>>        btrfs-progs: convert: clean up blk_iterate_data handling wrt
>> record_file_blocks
>>        btrfs-progs: convert: remove unused fs argument from
>> block_iterate_proc
>>        btrfs-progs: convert: remove unused inode_key in copy_single_inode
>>        btrfs-progs: convert: rename ext2_root to image_root
>>        btrfs-progs: compat: define DIV_ROUND_UP if not already defined
>>        btrfs-progs: convert: fix typo in btrfs_insert_dir_item call
>>        btrfs-progs: convert: factor out adding dirent into
>> convert_insert_dirent
>>        btrfs-progs: convert: factor out block iteration callback
>>
>> Josef Bacik (3):
>>        Btrfs-progs: corrupt-block: add the ability to remove csums
>>        btrfs-progs: specify mountpoint for recieve
>>        btrfs-progs: make receive work inside of subvolumes
>>
>> Qu Wenruo (13):
>>        btrfs-progs: Enhance read_tree_block to avoid memory corruption
>>        btrfs-progs: btrfstune: rework change_uuid
>>        btrfs-progs: btrfstune: add ability to restore unfinished fsid
>> change
>>        btrfs-progs: btrfstune: add '-U' and '-u' option to change fsid
>>        btrfs-progs: Documentation: uuid change
>>        btrfs-progs: btrfstune: fix a bug which makes unfinished fsid
>> change unrecoverable
>>        btrfs-progs: export read_extent_data function
>>        btrfs-progs: map-logical: introduce map_one_extent function
>>        Btrfs-progs: map-logical: introduce print_mapping_info function
>>        Btrfs-progs: map-logical: introduce write_extent_content function
>>        btrfs-progs: map-logical: Rework map-logical logics
>>        btrfs-progs: Allow "filesystem show" command to handle
>> different units
>>        btrfs-progs: docs: new size options for fi show
>>
>> Sam Tygier (1):
>>        btrfs-progs: mkfs: check metadata redundancy
>>
>> David Sterba (79):
>>        btrfs-progs: tests: log the test name in results file
>>        btrfs-progs: tests: support more formats of test images
>>        btrfs-progs: tests: use readlink -f to resolve path
>>        btrfs-progs: tests: sort image files
>>        btrfs-progs: test: 015-check-bad-memory-access
>>        btrfs-progs: tests: add script to clean intermediate images
>>        btrfs-progs: receive: restore capabilities after chown
>>        btrfs-progs: tests: add driver script for misc tests
>>        btrfs-progs: tests: common: add helper run_check_stdout
>>        btrfs-progs: tests: add misc test for fs features
>>        btrfs-progs: update .gitignore
>>        btrfs-progs: subvol show: print received uuid
>>        btrfs-progs: subvol show: tweak output
>>        btrfs-progs: btrfstune: rework option handling
>>        btrfs-progs: btrfstune: add option to enable NO_HOLES
>>        btrfs-progs: doc: update btrfstune manpage
>>        btrfs-progs: tests: add misc tests for uuid rewrite
>>        btrfs-progs: btrfstune: make uuid rewrite progress more verbose
>>        btrfs-progs: ioctl.h: reorder to match kernel uapi header
>>        btrfs-progs: ioctl.h: copy commented version of scrub_progress
>> structure
>>        btrfs-progs: ioctl.h: copy commented version of balance structures
>>        btrfs-progs: ioctl.h: add EXTENT_SAME ioctl and structures
>>        btrfs-progs: ioctl.h: add send flag mask
>>        btrfs-progs: ioctl.h: update type annotations
>>        btrfs-progs: ioctl.h: update btrfs_ioctl_fs_info_args
>>        btrfs-progs: ioctl.h: add btrfs_ioctl_feature_flags struct
>>        btrfs-progs: doc: update btrfs-rescue page and drop btrfs-zero-log
>>        btrfs-progs: scrub: more friendly duration format in status
>>        btrfs-progs: add function to stringify filesystem features
>>        btrfs-progs: convert: allow to set filesystem features
>
> Tons of new patches, but at least I didn't find the patch in mail list
> for the above convert patch, when I want to comment on it.
>
> So I can only comment here.
>
> [[Good fix even before we found the real bug]]
> This convert patch is quite good, as it in fact addressed the
> metadata-cross-map-boundary bug, even before we found it.
>
> For the metadata crossing map boundary bug, the root cause was, for old
> convert, we were using mixed block group by default but use wrong
> node/leaf size.
>
> For mixed block group case, node/leaf size must be the same with
> sectorsize(4K on x86/x86_64), but we were using 16K leaf/node size in
> that case. And causing tree blocks crossing map boundary.
>
> I'm a little surprised kernel can still mount such image without major
> bugs. But anyway, we still need to add new kernel check.
Sorry David, I found this explain is wrong, as kernel already has 
checked this case.

The problem is that, for converted image, it's quite possible that data 
and metadata extent are stored in one chunk even the chunk is not mixed.

I'll add fsck support for it soon.

BTW, the side effect still exists and may worth consideration.

Thanks,
Qu
>
> [[Side effect]]
> On the other hand, for convert case, unlike btrfs, ext2/3 is not extent
> based, and their data/metadata aren't batched together.
> Ext4 is a little better, but still not so extent-based like btrf.
>
> If not using mixed block group, even for a newly created ext4 image,
> btrfs-convert will create 13 block groups for the scattered ext4 data.
> And things will be even worse if the ext4 image contains some data.
>
> [[True fix]]
> IMHO, I still prefer to use mixed block group for btrfs-convert, as that
> fits better for the use case.
>
> And what we really need is, to keep fixing btrfs-convert and kernel.
> Banning mixed bg for convert case is just avoiding the real cause, and I
> think that should be the last method.
>
> Thanks,
> Qu
>
>>        btrfs-progs: tests: update convert tests to set fs features
>>        btrfs-progs: cleanup and deprecate btrfs-zero-log
>>        btrfs-progs: tests: add test for zero-log
>>        btrfs-progs: mkfs: add option to make it quiet
>>        btrfs-progs: mkfs: accept mixed case for profile names
>>        btrfs-progs: mkfs: move info message out of btrfs_add_to_fsid
>>        btrfs-progs: mkfs: do not try to register non-block-devices
>>        btrfs-progs: mkfs, move uuid to the end of device summary
>>        btrfs-progs: mkfs, drop UUID from device summary
>>        btrfs-progs: mkfs: drop mixed from summary
>>        btrfs-progs: mkfs: make the summary more compact
>>        btrfs-progs: remove stray deprecation notice
>>        btrfs-progs: fix argv0_buf handling
>>        btrfs-progs: add command group info strings
>>        btrfs-progs: print compact help for btrfs
>>        btrfs-progs: receive: fix minor resource leak
>>        btrfs-progs: cleanup after errors in open_file_or_dir3
>>        btrfs-progs: subvol: let sync check only current deletions
>>        btrfs-progs: add helper to wait for subvolume cleaning
>>        btrfs-progs: add missing includes to header files
>>        btrfs-progs: accept --help as option in the standalone utilities
>>        btrfs-progs: print error within test_dev_for_mkfs
>>        btrfs-progs: print error within test_num_disk_vs_raid
>>        btrfs-progs: use less memory for pretty_size_mode buffers
>>        btrfs-progs: receive: implement the update_extent callback
>>        btrfs-progs: send: add option to for the no-data mode
>>        btrfs-progs: use PATH_MAX instead of BTRFS_PATH_NAME_MAX
>>        btrfs-progs: properly set up ioctl arguments
>>        btrfs-progs: receive: use static buffer for cur_subvol
>>        btrfs-progs: add helper for copying paths
>>        btrfs-progs: receive: use static buffer for mount point option
>> argument
>>        btrfs-progs: receive: use static buffer for source file
>>        btrfs-progs: send: use static buffer for output file name
>>        btrfs-progs: and new path_cat helpers to send utils
>>        btrfs-progs: send utils: switch callbacks to new helpers
>>        btrfs-progs: unify naming of key types in print-tree
>>        btrfs-progs: receive: use static buffer for root_subvol_path
>>        btrfs-progs: receive: use static buffer for write_path
>>        btrfs-progs: send utils: switch callbacks to patch_cat3_out
>>        btrfs-progs: receive: use static buffer for cur_subvol path
>>        btrfs-progs: send utils: deprecate path_cat and path_cat3
>>        btrfs-progs: Makefile: fix typo, dependencies for cmds-* files
>>        Btrfs progs v4.1-rc1
>>        btrfs-progs: tests: verify btrfstune output during uuid-rewrite
>>        btrfs-progs: btrfstune: print lowercase uuid during uuid rewrite
>>        btrfs-progs: btrfstune: print correct current uuid during rewrite
>>        btrfs-progs: configure: fix typo in summary
>>        btrfs-progs: INSTALL: fix typos
>>        Btrfs progs v4.1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>
