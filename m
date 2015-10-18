Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62909 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbbJRWV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 18:21:56 -0400
Date: Mon, 19 Oct 2015 09:21:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: PaX Team <pageexec@freemail.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        spender@grsecurity.net, re.emese@gmail.com
Subject: Re: potential integer truncation issues on 32 bit archs
Message-ID: <20151018222140.GB2786@dastard>
References: <5623A3D7.2704.C319A60F@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5623A3D7.2704.C319A60F@pageexec.freemail.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 18, 2015 at 03:51:19PM +0200, PaX Team wrote:
> Hi everyone,
> 
> while investigating some integer related error reports we got, i ran across
> some code in both the VFS/MM and btrfs that i think raise a more generic problem.
> 
> in particular, when converting a file offset to a page cache index, the canonical
> type of the latter is usually pgoff_t, typedef'ed to unsigned long (but i saw
> unsigned long used directly as well). this can be problematic if the VFS or any
> file system wants to support files over 16TB (say on i386) since after a shift
> by PAGE_CACHE_SHIFT some MSBs will be lost on 32 bit archs (now this may not be
> a supported use case but at least btrfs doesn't seem to exclude it). another
> trigger seems to be vfs_fsync that passes LLONG_MAX and which can end up converted
> to a page cache index (truncated on 32 bit archs).

Files larger than 16TB are not supported on 32 bit arches. Most
filesystems limit fil size to 8TB (MAX_LFS_FILESIZE), though some
(e.g. XFS) limit it to (16TB - 1 byte).  Filesystems currently
enforce the 8/16TB file size limit on 32bit systems through
sb->s_maxbytes.

I very much doubt we'll ever change this because of all the
infrastructure changes needed. e.g.  radix trees need to be
converted to 64 bit indexes on 32 bit platforms. It's far easier for
people to use a 64 bit CPU than it is for use to extend 32 bit
system support....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
