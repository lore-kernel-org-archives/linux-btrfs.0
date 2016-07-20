Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:42736 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbcGTIqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 04:46:06 -0400
Subject: Re: [PATCH 0/4] update bytes_may_use timely to avoid false ENOSPC
 issue
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, jbacik@fb.com
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <578F3A4C.4040702@applied-asynchrony.com>
Date: Wed, 20 Jul 2016 10:46:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/16 07:56, Wang Xiaoguang wrote:
> Currently in btrfs, for data space reservation, it does not update
> bytes_may_use in btrfs_update_reserved_bytes() and the decrease operation
> will be delayed to be done in extent_clear_unlock_delalloc(), for
> fallocate(2), decrease operation is even delayed to be done in end
> of btrfs_fallocate(), which is too late. Obviously such delay will
> cause unnecessary pressure to enospc system, in [PATCH 4/4], there is
> a simpel test script that can reveal such false ENOSPC bug.
> 
> So in this patch set, it will remove RESERVE_FREE, RESERVE_ALLOC and
> RESERVE_ALLOC_NO_ACCOUNT, and we always update bytes_may_use timely.
> 
> I'll also commit a fstests test case for this issue.
> 
> Wang Xiaoguang (4):
>   btrfs: use correct offset for reloc_inode in
>     prealloc_file_extent_cluster()
>   btrfs: divide btrfs_update_reserved_bytes() into two functions
>   btrfs: introduce new EXTENT_CLEAR_DATA_RESV flag
>   btrfs: update btrfs_space_info's bytes_may_use timely
> 

Just like the previous version, for all 4 patches:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

via the reproducer script & some very large manual fallocates.

thanks!
Holger

