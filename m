Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39932 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbCLEkV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 00:40:21 -0400
Received: by pdbft15 with SMTP id ft15so16880982pdb.6
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2015 21:40:20 -0700 (PDT)
Date: Wed, 11 Mar 2015 21:40:17 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: ENOMEM bugfixes
Message-ID: <20150312044017.GA7693@mew>
References: <cover.1424773781.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2015 at 02:47:03AM -0800, Omar Sandoval wrote:
> Hi, everyone,
> 
> This patch series fixes a few bugs that occur under low memory conditions.
> These were exposed by a change in behavior of GFP_NOFS allocations in 3.19-rc7,
> by commit 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into
> allocation slowpath"). While the mm people sort that out, we can fix these
> issues, which are bugs no matter what the outcome there is.
> 
> Here's a quick script which reproduces these bugs. With the patches applied, the
> filesystem will drop into read-only mode instead of blowing up.
> 
> ----
> #!/bin/sh
> 
> cgcreate -g memory:enomem
> MEM=$((64 * 1024 * 1024))
> echo $MEM > /sys/fs/cgroup/memory/enomem/memory.limit_in_bytes
> 
> cgexec -g memory:enomem ~/xfstests/ltp/fsstress -p128 -n999999999 -d /mnt/test &
> trap "killall fsstress; exit 0" SIGINT SIGTERM
> 
> while true; do
> 	cgexec -g memory:enomem python -c '
> l = []
> while True:
>     l.append(0)'
> done
> ----
> 
> Version 2 rebases on top of 4.0-rc1, has a simpler fix for the
> alloc_extent_buffer race, expands the commit messages to mention changed
> comments, and adds Liu Bo's Reviewed-by.
> 
> Thanks!
> 
> Omar Sandoval (3):
>   btrfs: handle ENOMEM in btrfs_alloc_tree_block
>   btrfs: fix race on ENOMEM in alloc_extent_buffer
>   btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache
> 
>  fs/btrfs/extent-tree.c      | 41 ++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.c        |  3 ++-
>  fs/btrfs/free-space-cache.c | 10 ++++++----
>  3 files changed, 36 insertions(+), 18 deletions(-)
> -- 
> 2.3.0
> 

Ping. For anyone following along, it looks like commit cc87317726f8
("mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change")
reverted the commit that exposed these bugs. Josef said he was okay with
taking these, will they make it to an upcoming -rc soon?

Thanks!
-- 
Omar
