Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32587 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbbJ3On7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 10:43:59 -0400
Subject: Re: [PATCH V8 01/13] Btrfs: __btrfs_buffered_write: Reserve/release
 extents aligned to block size
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1446019827-685-2-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <5633821D.6010903@fb.com>
Date: Fri, 30 Oct 2015 10:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <1446019827-685-2-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2015 04:10 AM, Chandan Rajendra wrote:
> Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
> units. Fix this by doing reservation/releases in block size units.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
