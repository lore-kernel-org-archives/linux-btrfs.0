Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35911 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbcEBVzE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 17:55:04 -0400
Received: by mail-pa0-f51.google.com with SMTP id bt5so574968pac.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 14:55:04 -0700 (PDT)
Date: Mon, 2 May 2016 14:55:01 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 6/9] Btrfs: implement the free space B-tree
Message-ID: <20160502215501.GA24432@vader.DHCP.thefacebook.com>
References: <cover.1443583874.git.osandov@osandov.com>
 <3319d371e22491b6901af33842b57db37b77c52c.1443583874.git.osandov@osandov.com>
 <20151229201907.rzbaxqiyjfwpqxwp@ret.masoncoding.com>
 <CAOcd+r2wCqcfbub6AKoDwyPB4XS7MDUuqeJOziw-g8vn+mM+gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r2wCqcfbub6AKoDwyPB4XS7MDUuqeJOziw-g8vn+mM+gw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 11:28:24AM +0300, Alex Lyakas wrote:
> Hi Omar, Chris,
> 
> I have reviewed the free-space-tree code. It is a very nice feature.
> 
> However, I have a basic understanding question.
> 
> Let's say we are running a delayed ref which inserts a new EXTENT_ITEM
> into the extent tree, e.g., we are in alloc_reserved_file_extent. At
> this point we call remove_from_free_space_tree(), which updates the
> free-space-tree about the allocated space. But this requires to COW
> the free-space-tree itself. So we allocate a new tree block for the
> free-space tree, and insert a new delayed ref, which will update the
> extent tree about the new tree block allocation. We also insert a
> delayed ref to free the previous copy of the free-space-tree block.
> 
> At some point we run these new delayed refs, so we insert/remove
> EXTENT_ITEMs from the extent tree, and this in turn requires us to
> update the free-space-tree again. So we need again to COW
> free-space-tree blocks, generating more delayed refs.
> 
> At which point this recursion stops?
> 
> Do we assume that at some point all needed free-space tree blocks have
> been COW'ed already, and we do not COW a tree block more than once per
> transaction (unless it was written to disk due to memory pressure)?
> 
> Thanks!
> Alex.

Hi, Alex,

Your understanding is correct, we'll only COW a tree block once during a
transaction, so the recursion stops once all of the free space items we
need to add/remove don't require rebalancing the tree or allocating or
freeing a block. Same thing goes for extent items in the extent tree.
Since the extent tree and free space tree items are much smaller than a
tree block, this doesn't turn out to be a problem in practice.

Thanks for taking a look :)

-- 
Omar
