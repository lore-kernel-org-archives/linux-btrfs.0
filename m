Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52422 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276AbbJAObb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:31:31 -0400
Subject: Re: [RFC PATCH V4 01/13] Btrfs: __btrfs_buffered_write:
 Reserve/release extents aligned to block size
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608309-30154-2-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D43A9.3090505@fb.com>
Date: Thu, 1 Oct 2015 10:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <1443608309-30154-2-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:18 AM, Chandan Rajendra wrote:
> Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
> units. Fix this by doing reservation/releases in block size units.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
