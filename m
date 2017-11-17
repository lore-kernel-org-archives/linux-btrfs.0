Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752888AbdKQRpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:00 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1FB3DABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:44:59 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 0/8] btrfs iomap support
Date: Fri, 17 Nov 2017 11:44:46 -0600
Message-Id: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series attempts to use kernels iomap for btrfs. Currently,
it covers buffered writes only, but I intend to add some other iomap
uses once this gets through. I am sending this as an RFC because I
would like to find ways to improve the solution since some changes
require adding more functions to the iomap infrastructure which I
would try to avoid. I still have to remove some kinks as well such
as -o compress. I have posted some questions in the individual
patches and would appreciate some input to those.

Some of the problems I faced is:

1. extent locking: While we perform the extent locking for writes,
we need to perform any reads because of non-page-aligned calls before
locking can be done. This requires reading the page, increasing their
pagecount and "letting it go". The iomap infrastructure uses
buffer_heads wheras btrfs uses bio and hence needs to call readpage
exclusively. The "letting it go" part makes me somewhat nervous of
conflicting reads/writes, even though we are protected under i_rwsem.
Is readpage_nolock() a good idea? The extent locking sequence is a
bit weird, with locks and unlock happening in different functions.

2. btrfs pages use PagePrivate to store EXTENT_PAGE_PRIVATE which is not used anywhere.
However, a PagePrivate flag is used for try_to_release_buffers(). Can
we do away with PagePrivate for data pages? The same with PageChecked.
How and why is it used (I guess -o compress)

3. I had to stick information which will be required from iomap_begin()
to iomap_end() in btrfs_iomap which is a pointer in btrfs_inode. Is
there any other place/way we can transmit this information. XFS only
performs allocations and deallocations so it just relies of bmap code
for it.

Suggestions/Criticism welcome.

-- 
Goldwyn


