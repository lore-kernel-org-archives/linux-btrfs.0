Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:46528 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbbJROdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 10:33:53 -0400
From: "PaX Team" <pageexec@freemail.hu>
To: linux-fsdevel@vger.kernel.org
Date: Sun, 18 Oct 2015 15:51:19 +0200
MIME-Version: 1.0
Subject: potential integer truncation issues on 32 bit archs
Reply-to: pageexec@freemail.hu
CC: linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, spender@grsecurity.net,
        re.emese@gmail.com
Message-ID: <5623A3D7.2704.C319A60F@pageexec.freemail.hu>
Content-type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

while investigating some integer related error reports we got, i ran across
some code in both the VFS/MM and btrfs that i think raise a more generic problem.

in particular, when converting a file offset to a page cache index, the canonical
type of the latter is usually pgoff_t, typedef'ed to unsigned long (but i saw
unsigned long used directly as well). this can be problematic if the VFS or any
file system wants to support files over 16TB (say on i386) since after a shift
by PAGE_CACHE_SHIFT some MSBs will be lost on 32 bit archs (now this may not be
a supported use case but at least btrfs doesn't seem to exclude it). another
trigger seems to be vfs_fsync that passes LLONG_MAX and which can end up converted
to a page cache index (truncated on 32 bit archs).

my basic question is whether this is considered an actual problem and whether
there are already measures at some higher abstraction levels to prevent such
integer truncations and the use of incorrect page cache indices.

cheers,
 PaX Team

PS: two random examples:
    mm/filemap.c:filemap_fdatawait_range 
    fs/btrfs/extent_io.c:extent_range_clear_dirty_for_io

