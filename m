Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45581 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbbBTVUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 16:20:09 -0500
Received: by pdjz10 with SMTP id z10so10214237pdj.12
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 13:20:09 -0800 (PST)
Date: Fri, 20 Feb 2015 13:20:07 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: ENOMEM bugfixes
Message-ID: <20150220212007.GA27049@mew.dhcp4.washington.edu>
References: <cover.1424168589.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 17, 2015 at 02:51:06AM -0800, Omar Sandoval wrote:
> Hi,
> 
> As it turns out, running with low memory is a really easy way to shake
> out undesirable behavior in Btrfs. This can be especially bad when
> considering that a memory limit is really easy to hit in a container
> (e.g., by using cgroup memory.limit_in_bytes). Here's a simple script
> that can hit several problems:
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
> 	l.append(0)'
> done
> ----
> 
> Ignoring for now the cases that drop the filesystem into read-only mode
> with relatively little fuss, here are a few patches that fix some of the
> low-hanging fruit. They apply to Linus' tree as of today.
> 
So I didn't realize this until I saw Tetsuo Handa's email to the ext4
list (http://thread.gmane.org/gmane.comp.file-systems.ext4/47855), but
it looks like this behavior was exposed by a change to the kernel memory
allocator related to the too-small-to-fail allocation fiasco. To
summarize, Commit 9879de7373fc (mm: page_alloc: embed OOM killing
naturally into allocation slowpath), merged for v3.19-rc7, changed the
behavior of GFP_NOFS allocations which makes it much easier to trigger
allocation failures in filesystems.

This means that Btrfs falls over under memory pressure pretty easily
now, so it might be a good idea to follow the conversation over at
linux-mm (http://thread.gmane.org/gmane.linux.kernel.mm/126398).

These are bugs regardless of the outcome there, however, so I'd like to
see this patch series merged.

Thanks again!
> Thanks!
> 
> Omar Sandoval (3):
>   btrfs: handle ENOMEM in btrfs_alloc_tree_block
>   btrfs: handle race on ENOMEM in alloc_extent_buffer
>   btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache
> 
>  fs/btrfs/extent-tree.c      | 41 ++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.c        | 20 ++++++++++++++++----
>  fs/btrfs/free-space-cache.c | 10 ++++++----
>  3 files changed, 50 insertions(+), 21 deletions(-)
> 
> -- 
> 2.3.0
> 

-- 
Omar
