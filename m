Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43160 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbbJ3OiZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 10:38:25 -0400
Subject: Re: [PATCH V8 02/13] Btrfs: Compute and look up csums based on
 sectorsized blocks
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1446019827-685-3-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <563380C3.6040502@fb.com>
Date: Fri, 30 Oct 2015 10:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <1446019827-685-3-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2015 04:10 AM, Chandan Rajendra wrote:
> Checksums are applicable to sectorsize units. The current code uses
> bio->bv_len units to compute and look up checksums. This works on machines
> where sectorsize == PAGE_SIZE. This patch makes the checksum computation and
> look up code to work with sectorsize units.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

