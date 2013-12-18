Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab3LRPOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 10:14:05 -0500
Date: Wed, 18 Dec 2013 16:14:02 +0100
From: David Sterba <dsterba@suse.cz>
To: stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        Liu Bo <bo.li.liu@oracle.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: Btrfs stable updates for 3.12
Message-ID: <20131218151402.GZ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please queue the following patches to 3.12 stable. They fix a few
crashes or lockups that were reported by users.

The patch "stop using vfs_read in send" may seem big for stable, but without it
the send/receive ioctl hits the global open file limit sooner or later,
depending on the ram size.

Subjects:
        Btrfs: do a full search everytime in btrfs_search_old_slot
        Btrfs: reset intwrite on transaction abort
        Btrfs: fix memory leak of chunks' extent map
        Btrfs: fix hole check in log_one_extent [bug 66661]
        Btrfs: fix incorrect inode acl reset
        Btrfs: stop using vfs_read in send
        Btrfs: take ordered root lock when removing ordered operations inode
        Btrfs: do not run snapshot-aware defragment on error
        Btrfs: fix a crash when running balance and defrag concurrently
        Btrfs: fix lockdep error in async commit
Commits:
        d4b4087c43cc00a196c5be57fac41f41309f1d56
        e0228285a8cad70e4b7b4833cc650e36ecd8de89
        7d3d1744f8a7d62e4875bd69cc2192a939813880
        ed9e8af88e2551aaa6bf51d8063a2493e2d71597
        8185554d3eb09d23a805456b6fa98dcbb34aa518
        ed2590953bd06b892f0411fc94e19175d32f197a
        93858769172c4e3678917810e9d5de360eb991cc
        6f519564d7d978c00351d9ab6abac3deeac31621
        48ec47364b6d493f0a9cdc116977bf3f34e5c3ec
        b1a06a4b574996692b72b742bf6e6aa0c711a948

all apply cleanly on top of 3.12.5.

Thanks,
david
