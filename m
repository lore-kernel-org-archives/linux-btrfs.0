Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39631 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756424AbeDZNom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 09:44:42 -0400
Date: Thu, 26 Apr 2018 15:42:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] [RESEND] Btrfs: reduce size of struct btrfs_inode
Message-ID: <20180426134206.GV21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424233717.31283-1-nefelim4ag@gmail.com>
 <20180424233717.31283-5-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424233717.31283-5-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 02:37:17AM +0300, Timofey Titovets wrote:
> Currently btrfs_inode have size equal 1136 bytes. (On x86_64).
> 
> struct btrfs_inode store several vars releated to compression code,
> all states use 1 or 2 bits.
> 
> Lets declare bitfields for compression releated vars, to reduce
> sizeof btrfs_inode to 1128 bytes.

Unfortunatelly, this has no big effect. The inodes are allocated from a
slab page, that's 4k and there are at most 3 inodes there. Snippet from
/proc/slabinfo:

# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>
btrfs_inode       256043 278943   1096    3    1

The size on my box is 1096 as it's 4.14, but this should not matter to
demonstrate the idea.

objperslab is 3 here, ie. there are 3 btrfs_inode in the page, and
there's 4096 - 3 * 1096 = 808 of slack space. In order to pack 4 inodes
per page, we'd have to squeeze the inode size to 1024 bytes. I've looked
into that and did not see enough members to remove or substitute. IIRC
there were like 24-32 bytes possible to shave, but that was it.

Once we'd get to 1024, adding anything new to btrfs_inode would be quite
difficult and as it goes, there's always something to add to the inode.

So I'd take a different approach, to regroup items and decide by
cacheline access patterns what to put together and what to separate.

The maximum size of inode before going to 2 objects per page is 1365, so
there's enough space for cacheline alignments.
