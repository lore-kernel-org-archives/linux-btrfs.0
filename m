Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41695 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbeBTSxH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 13:53:07 -0500
Date: Tue, 20 Feb 2018 19:50:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/27] btrfs-progs: introduce libbtrfsutil,
 "btrfs-progs as a library"
Message-ID: <20180220185048.GR10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 11:04:45AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> This is v2 of "btrfs-progs as a library".
> 
> Most of the changes since v1 are small:
> 
> - Rebased onto v4.15
> - Split up btrfs_util_subvolume_path() which was accidentally squashed together
>   with the commit adding btrfs_util_create_subvolume()
> - Renamed btrfs_util_f_* functions to btrfs_util_*_fd for clarity

I like this naming scheme.

> - Added -fvisibility=hidden and a macro for
>   __attribute__((visibility("default")))
> - Changed to use semantic versioning
> - Fixed missing install of btrfsutil.h
> - Documented functions which require root or are non-atomic
> - Added a missing license to setup.py
> 
> The bigger change is in the last two patches. Dave requested that I get
> rid of the runtime dependency of libbtrfsutil from libbtrfs. The easiest
> way to do this was to remove the btrfs_list_subvols_print()
> implementation from libbtrfs and put it in cmds-subvolume.c (details in
> patch 26). I'm open to alternatives.

This should be ok as a temporary fix to get the library going. The
column printing helpers will be replaced by libsmartcols (I have a
prototype for that but there are still some issues to fix).

> Omar Sandoval (27):
>   btrfs-progs: get rid of undocumented qgroup inheritance options

For initial merge I'll skip this patch (and what depends on it), as the
functionality is not yet out of krenel. I looked at the patch and am not
yet convinced to merge it, more time needed, but the library should not
be blocked by it.

>   Add libbtrfsutil
>   libbtrfsutil: add Python bindings
>   libbtrfsutil: add btrfs_util_is_subvolume() and
>     btrfs_util_subvolume_id()
>   libbtrfsutil: add qgroup inheritance helpers
>   libbtrfsutil: add btrfs_util_create_subvolume()
>   libbtrfsutil: add btrfs_util_subvolume_path()
>   libbtrfsutil: add btrfs_util_subvolume_info()
>   libbtrfsutil: add btrfs_util_[gs]et_read_only()
>   libbtrfsutil: add btrfs_util_[gs]et_default_subvolume()
>   libbtrfsutil: add subvolume iterator helpers
>   libbtrfsutil: add btrfs_util_create_snapshot()
>   libbtrfsutil: add btrfs_util_delete_subvolume()
>   libbtrfsutil: add btrfs_util_deleted_subvolumes()
>   libbtrfsutil: add filesystem sync helpers

I'm going to add the above to devel now.

>   btrfs-progs: use libbtrfsutil for read-only property
>   btrfs-progs: use libbtrfsutil for sync ioctls
>   btrfs-progs: use libbtrfsutil for set-default
>   btrfs-progs: use libbtrfsutil for get-default
>   btrfs-progs: use libbtrfsutil for subvol create and snapshot
>   btrfs-progs: use libbtrfsutil for subvol delete
>   btrfs-progs: use libbtrfsutil for subvol show
>   btrfs-progs: use libbtrfsutil for subvol sync
>   btrfs-progs: replace test_issubvolume() with btrfs_util_is_subvolume()
>   btrfs-progs: add recursive snapshot/delete using libbtrfsutil
>   btrfs-progs: use libbtrfsutil for subvolume list
>   btrfs-progs: deprecate libbtrfs helpers

Besides the subvol and qgroup inheritance, all of the above look good,
but I'd like to spend more time merging them and we should also add
commandline tests for coverage.

I have more comments or maybe questions about the future development
workflow, but at this point the patchset is in a good shape for
incremental merge.
