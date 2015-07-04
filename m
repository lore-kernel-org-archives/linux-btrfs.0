Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:51927 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbGEIcZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jul 2015 04:32:25 -0400
Date: Sat, 4 Jul 2015 13:22:49 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: NULL pointer dereference during snapshot removal
Message-ID: <1436008460@msgid.manchmal.in-ulm.de>
References: <1434811494@msgid.manchmal.in-ulm.de>
 <20150623031036.GB14577@localhost.localdomain>
 <20150625172137.GO726@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150625172137.GO726@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote...

> so bdev or bdev->bd_disk might be NULL, but according to the offsets it seems to
> be 'bdev->bd_disk'.

My analysis led to the same result.

> Anyawy, this is below btrfs layer.

Well, at least it's a regression introduced by a rework[1] in the fs
layer. So it's obvious to assume either btrfs should have been
considered in that commit, or this uncovered an API usage by btrfs in
an unsupported way.

To bring all parties involved together I've created
https://bugzilla.kernel.org/show_bug.cgi?id=100911

    Christoph

[1]
| commit de1414a654e66b81b5348dbc5259ecf2fb61655e
| Author: Christoph Hellwig <hch@lst.de>
| Date:   Wed Jan 14 10:42:36 2015 +0100
|
|     fs: export inode_to_bdi and use it in favor of
|     mapping->backing_dev_info
|
|     Now that we got rid of the bdi abuse on character devices we can
|     always use
|     sb->s_bdi to get at the backing_dev_info for a file, except for
|     the block
|     device special case.  Export inode_to_bdi and replace uses of
|     mapping->backing_dev_info with it to prepare for the removal of
|     mapping->backing_dev_info.

