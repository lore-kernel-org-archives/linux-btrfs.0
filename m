Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27498 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbbJAPAe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 11:00:34 -0400
Subject: Re: [PATCH V5 10/13] Btrfs: Fix block size returned to user space
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608912-31667-11-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D4A12.1000108@fb.com>
Date: Thu, 1 Oct 2015 10:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <1443608912-31667-11-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> btrfs_getattr() returns PAGE_CACHE_SIZE as the block size. Since
> generic_fillattr() already does the right thing (by obtaining block size
> from inode->i_blkbits), just remove the statement from btrfs_getattr.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
