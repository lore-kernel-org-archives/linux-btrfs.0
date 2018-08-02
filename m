Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732651AbeHBQ6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 12:58:06 -0400
Date: Thu, 2 Aug 2018 17:06:27 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix mount failure after fsync due to hard link
 recreation
Message-ID: <20180802150626.GP3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719180154.20125-1-fdmanana@kernel.org>
 <20180720095906.3675-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180720095906.3675-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 10:59:06AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we end up with logging an inode reference item which has the same name
> but different index from the one we have persisted, we end up failing when
> replaying the log with an errno value of -EEXIST. The error comes from
> btrfs_add_link(), which is called from add_inode_ref(), when we are
> replaying an inode reference item.
> 
> Example scenario where this happens:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ touch /mnt/foo
>   $ ln /mnt/foo /mnt/bar
> 
>   $ sync
> 
>   # Rename the first hard link (foo) to a new name and rename the second
>   # hard link (bar) to the old name of the first hard link (foo).
>   $ mv /mnt/foo /mnt/qwerty
>   $ mv /mnt/bar /mnt/foo
> 
>   # Create a new file, in the same parent directory, with the old name of
>   # the second hard link (bar) and fsync this new file.
>   # We do this instead of calling fsync on foo/qwerty because if we did
>   # that the fsync resulted in a full transaction commit, not triggering
>   # the problem.
>   $ touch /mnt/bar
>   $ xfs_io -c "fsync" /mnt/bar
> 
>   <power fail>
> 
>   $ mount /dev/sdb /mnt
>   mount: mount /dev/sdb on /mnt failed: File exists
> 
> So fix this by checking if a conflicting inode reference exists (same
> name, same parent but different index), removing it (and the associated
> dir index entries from the parent inode) if it exists, before attempting
> to add the new reference.
> 
> A test case for fstests follows soon.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

The patch has been in misc-next for more than a weak but I probably did
not let you know, so here goes. Thanks.
