Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31274 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbcFDA7O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 20:59:14 -0400
Subject: Re: [PATCH] Btrfs: clear uptodate flags of pages in sys_array eb
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1465000902-3205-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <e51d5b12-44f5-0d21-7a99-ad3ea13b034c@fb.com>
Date: Fri, 3 Jun 2016 20:58:55 -0400
MIME-Version: 1.0
In-Reply-To: <1465000902-3205-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2016 08:41 PM, Liu Bo wrote:
> We set uptodate flag to pages in the temporary sys_array eb,
> but do not clear the flag after free eb.  As the special
> btree inode may still hold a reference on those pages, the
> uptodate flag can remain alive in them.
>
> If btrfs_super_chunk_root has been intentionally changed to the
> offset of this sys_array eb, reading chunk_root will read content
> of sys_array and it will pass our beautiful checks in
> btree_readpage_end_io_hook() because of
> "pages of eb are uptodate => eb is uptodate"
>
> This adds the 'clear uptodate' part to force it to read from disk.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
