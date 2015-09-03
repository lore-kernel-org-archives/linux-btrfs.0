Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:37678 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbbICSZj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Sep 2015 14:25:39 -0400
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com [209.85.213.41])
	(authenticated bits=0)
	by c.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id t83IPZq2025792
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Sep 2015 11:25:36 -0700
Received: by vkhf67 with SMTP id f67so29573217vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2015 11:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150903123917.GQ11834@suse.cz>
References: <20150903123917.GQ11834@suse.cz>
Date: Thu, 3 Sep 2015 11:25:35 -0700
Message-ID: <CAPF83mspr2b+jWcZPmGsNjNzNc0FCWvS=VMiCXVp5h6yuDjupQ@mail.gmail.com>
Subject: Re: Btrfs progs release 4.2
From: Suman Chakravartula <suman@rockstor.com>
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you! I see a lot of really useful changes. I've just updated
Rockstor testing repo to use 4.2.

On Thu, Sep 3, 2015 at 5:39 AM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> here goes anoher release. There are many cleanups/bugfixes and just a handful
> of user-visible improvements.
>
> Thanks to all contributors!
>
> enhancements:
>   * mkfs: do not create extra single chunks on multiple devices
>   * resize: try to guess the minimal size, 'inspect min-dev-size'
>   * qgroup assign: add option to schedule rescan
>   * chunk-recover: be more verbose about the scanning process
>
> fixes:
>   * check:
>     * find stripes crossing stripe boundary -- created by convert
>     * print correct range for file hole when there are no extents
>       and learn how to fix it
>   * replace: more sanity checks
>   * convert: concurrency fixes related to reporting progress
>   * find-root: option -a will not skip the current root anymore
>   * subvol list: fix occasional crash
>   * do not create stripes crossing stripe boundary
>
> build:
>  * fixes for musl libc
>  * preliminary support for android (not working yet, more code changes needed)
>  * new EXTRA_CFLAGS and EXTRA_LDFLAGS
>
> other:
>  * lots of cleanups
>  * tests: lots of updates, new tests, framework improvements
>  * documentation updates
>  * debugging: print-tree shows stripe length
>
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>
>
> Shortlog:
>
> Adam Borowski (1):
>       btrfs-progs: doc: document btrfs-select-super(8)
>
> Brendan Heading (1):
>       btrfs-progs: compilation errors when using musl libc
>
> Byongho Lee (4):
>       btrfs-progs: fix memory leaks in error path
>       btrfs-progs: fix memory leak in btrfs-map-logical main()
>       btrfs-progs: add memory allocation fail check in btrfs_add_to_fsid()
>       btrfs-progs: fix memory leak in btrfs-convert main()
>
> David Sterba (25):
>       btrfs-progs: utils: missing newline in error messages when checking dup
>       btrfs-progs: move min-resize implementation to inspect-internal
>       btrfs-progs: inspect: add command min-dev-size
>       btrfs-progs: unify naming of command handlers
>       btrfs-progs: prop: use macro terminator for command list
>       btrfs-progs: fsck tests: move code to a function
>       btrfs-progs: tests: support testname glob
>       btrfs-progs: mkfs: catch errors after transaction start
>       btrfs-progs: qgroup assign: set path after checking argument count
>       btrfs-progs: qgroup assign: add option to schedule rescan
>       btrfs-progs: doc: update qgroup docs
>       btrfs-progs: do not install static binaries over non-static
>       btrfs-progs: update help for device stats
>       btrfs-progs: tests, add more common helpers
>       btrfs-progs: tests, verify that btrfs-image works on a missing device
>       btrfs-progs: fix use after free in replace start
>       btrfs-progs: add compat header for android
>       btrfs-progs: use android compat header
>       btrfs-progs: makefile: add support for additional build flags
>       btrfs-progs: image: better error handling in update_disk_super_on_device
>       btrfs-progs: use on-stack buffer for superblock
>       btrfs-progs: handle errors in btrfs_wipe_existing_sb
>       btrfs-progs: convert: rework checks of label size
>       btrfs-progs: btrfstune: remove unnecessary fsid checks
>       Btrfs progs v4.2
>
> Filipe Manana (1):
>       Btrfs-progs: add feature to get mininum size for resizing a fs/device
>
> Goffredo Baroncelli (1):
>       btrfs-progs: Add further checks to btrfs replace start command
>
> Patrik Lundquist (2):
>       btrfs-progs: defrag: fix threshold overflow again
>       btrfs-progs: defrag: remove unused variable
>
> Qu Wenruo (14):
>       btrfs-progs: mkfs: Cleanup temporary chunk to avoid strange balance behavior.
>       btrfs-progs: print-tree: print stripe len of a chunk
>       btrfs-progs: fsck: Check if a metadata tree block crossing stripe boundary
>       btrfs-progs: extent-tree: avoid allocating tree block that crosses stripe boundary
>       btrfs-progs: convert: Avoid allocating metadata extent crossing stripe boundary
>       btrfs-progs: Schedule quota rescan if qgroup assign caused inconsistence.
>       btrfs-progs: Add missing exit for parse_profile function
>       btrfs-progs: fsck: print correct file hole
>       btrfs-progs: fsck: fix a infinite loop on discount file extent repair
>       btrfs-progs: fsck-tests: add case for inode losing all its extents
>       btrfs-progs: Avoid reading bad fd in case of missing device.
>       btrfs-progs: Use existing facility to replace read_data_extent function
>       btrfs-progs: find-root: Output matched root when searching all roots
>       btrfs-progs: find-root: fix a bug that will cause wrong result
>
> Tsutomu Itoh (2):
>       btrfs-progs: cleanup: remove unnecessary check before btrfs_free_path is called
>       btrfs-progs: add newline to some error messages
>
> Wang Yanfeng (1):
>       Documentation: update btrfs-replace manual to support RAID5/6
>
> Zhao Lei (37):
>       btrfs-progs: Accurate errormsg for resize operation on no-enouth-free-space case
>       btrfs-progs: tests: Add -o loop to fsck-tests/012-leaf-corruption
>       btrfs-progs: Fix wrong address accessing by subthread in btrfs-convert
>       btrfs-progs: Move close timer handle code to line after sub process exit
>       btrfs-progs: Remove cleanup-timer code for btrfs-convert
>       btrfs-progs: resst info->periodic.timer_fd's value after free
>       btrfs-progs: Set info->periodic.timer_fd to 0 in init-fail
>       btrfs-progs: tests: Move code to create loop device to common
>       btrfs-progs: Introduce a misc test for thread conflict in btrfs-convert
>       btrfs-progs: Add initialztion of rec->crossing_stripes
>       btrfs-progs: add missing free operation of raid_map for raid56
>       btrfs-progs: unified error handling in print_replace_status
>       btrfs-progs: Introduce btrfs_close_all_devices helper
>       btrfs-progs: close all fs_devices before exit in some commands
>       btrfs-progs: remove code for setup mntid in cmd_subvol_show
>       btrfs-progs: Introduce btrfs_open_dir wrapper
>       btrfs-progs: use btrfs_open_dir for btrfs device command
>       btrfs-progs: tests: Introduce subvolume sync test
>       btrfs-progs: Introduce get_unit_mode_from_arg for common use
>       btrfs-progs: Use common unit parser for btrfs device command
>       btrfs-progs: Use common unit parser for btrfs qgroup command
>       btrfs-progs: Use common unit parser for btrfs filesystem command
>       btrfs-progs: tests: Introduce init_env to initialize common env variant
>       btrfs-progs: tests: umount TEST_MNT in clean-tests.sh
>       btrfs-progs: Fix infinite loop of btrfs subvolumn sync
>       btrfs-progs: Fix wrong return value of wait_for_subvolume_cleaning()
>       btrfs-progs: Simplify memory allocation for enumerate_dead_subvols
>       btrfs-progs: Simplify all-subvolumn-clean condition for wait_for_subvolume_cleaning
>       btrfs-progs: tests: Use --no-same-owner option for tar
>       btrfs-progs: tests: introduce test dev mount helpers
>       btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
>       btrfs-progs: tests: Use mount_test_dev for misc-tests/007-subvolume-sync
>       btrfs-progs: use for loop for scan_devices
>       btrfs-progs: Use long type to get thread's return value
>       btrfs-progs: stat info for btrfs rescue chunk-recover
>       btrfs-progs: Fix some spelling typos in chunk-recover.c
>       btrfs-progs: remove unused argument from block_group_free_all_extent
>
> kenneth.kang (1):
>       btrfs-progs: Add Android build mk file
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Suman Chakravartula
Founder @ Rockstor

http://rockstor.com
http://rockstor.com/blog
http://forum.rockstor.com
