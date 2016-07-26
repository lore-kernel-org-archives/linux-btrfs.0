Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57948 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756874AbcGZRpu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:45:50 -0400
Subject: Re: [PATCH V20 04/19] Btrfs: subpage-blocksize: Define
 extent_buffer_head
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, <clm@fb.com>,
        <dsterba@suse.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1467606879-14181-5-git-send-email-chandan@linux.vnet.ibm.com>
CC: <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <99c633e7-38b8-3147-aca8-3be34dd32295@fb.com>
Date: Tue, 26 Jul 2016 13:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <1467606879-14181-5-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2016 12:34 AM, Chandan Rajendra wrote:
> In order to handle multiple extent buffers per page, first we need to create a
> way to handle all the extent buffers that are attached to a page.
>
> This patch creates a new data structure 'struct extent_buffer_head', and moves
> fields that are common to all extent buffers from 'struct extent_buffer' to
> 'struct extent_buffer_head'
>
> Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
> EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
> extent_buffer_head->bflags.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

I'm sorry Chandan I'm still having problems with this one.  XFS kmalloc()'s its 
sub pagesize ranges for it's metadata buffers, how about we do that instead of 
doing the extent_buffer_head.  Look at xfs_buf_allocate_memory() for what I'm 
thinking.  Thanks,

Josef
