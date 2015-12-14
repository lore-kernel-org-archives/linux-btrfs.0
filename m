Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([125.16.236.6]:59359 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbLNH72 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 02:59:28 -0500
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 13:29:25 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id ABAD11258064
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:29:48 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBE7xK9i2556214
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:29:20 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBE7xGEK012190
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:29:16 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, chandan@mykolab.com
Subject: Re: [PATCH V2] Btrfs: find_free_extent: Do not erroneously skip LOOP_CACHING_WAIT state
Date: Mon, 14 Dec 2015 13:29:15 +0530
Message-ID: <2164241.X0NHPVhvOH@localhost.localdomain>
In-Reply-To: <CAOcd+r0ffSmVzEyZZHttJBEW6t+rRHr3N6W-=6SwuV3amq1Uqg@mail.gmail.com>
References: <1446318664-26750-1-git-send-email-chandan@linux.vnet.ibm.com> <CAOcd+r3ku8mhfK_ZvZRL2pRSZ=Y1Q2maNF_ob+8fEA=2Etm1Lg@mail.gmail.com> <CAOcd+r0ffSmVzEyZZHttJBEW6t+rRHr3N6W-=6SwuV3amq1Uqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 13 Dec 2015 12:18:55 Alex Lyakas wrote:
> [Resending in plain text, apologies.]
> 
> Hi Chandan, Josef, Chris,
> 
> I am not sure I understand the fix to the problem.
> 
> It may happen that when updating the device tree, we need to allocate a new
> chunk via do_chunk_alloc (while we are holding the device tree root node
> locked). This is a legitimate thing for find_free_extent() to do. And
> do_chunk_alloc() call may lead to call to
> btrfs_create_pending_block_groups(), which will try to update the device
> tree. This may happen due to direct call to
> btrfs_create_pending_block_groups() that exists in do_chunk_alloc(), or
> perhaps by __btrfs_end_transaction() that find_free_extent() does after it
> completed chunk allocation (although in this case it will use the
> transaction that already exists in current->journal_info).
> So the deadlock still may happen?

Hello Alex,

The "global block reservation" (see btrfs_fs_info->global_block_rsv) aims to
solve this problem. I don't claim to have understood the behaviour of
global_block_rsv completely. However, Global block reservation makes sure that
we have enough free space reserved (see update_global_block_rsv()) for future
operations on,
- Extent tree
- Checksum tree
- Device tree 
- Tree root tree and
- Quota tree.

Tasks changing the device tree should get their space requirements satisfied
from the global block reservation. Hence such changes to the device tree
should not end up forcing find_free_extent() to allocate a new chunk.

-- 
chandan

