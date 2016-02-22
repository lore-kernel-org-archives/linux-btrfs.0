Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbcBVR6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 12:58:46 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 22A51AAB4
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 17:58:45 +0000 (UTC)
Date: Mon, 22 Feb 2016 18:58:37 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use proper type for failrec in extent_state
Message-ID: <20160222175837.GH4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455193453-14837-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1455193453-14837-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 01:24:13PM +0100, David Sterba wrote:
> We use the private member of extent_state to store the failrec and play
> pointless pointer games.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

I'm not sure why, but my gcc 5.3.1 think's that a member of failrec can
be used uninitialized:

  CC [M]  fs/btrfs/extent_io.o
fs/btrfs/extent_io.c: In function ‘clean_io_failure’:
fs/btrfs/extent_io.c:2133:4: warning: ‘failrec’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    repair_io_failure(inode, start, failrec->len,
    ^

which points to:

2126         if (state && state->start <= failrec->start &&
2127             state->end >= failrec->start + failrec->len - 1) {
2128                 num_copies = btrfs_num_copies(fs_info, failrec->logical,
2129                                               failrec->len);
2130                 if (num_copies > 1)  {
2131                         repair_io_failure(inode, start, failrec->len,
2132                                           failrec->logical, page,
2133                                           pg_offset, failrec->failed_mirror);
2134                 }
2135         }

After separating all members to local varaibles, it points to ->len. Which is
used several times in code above.
