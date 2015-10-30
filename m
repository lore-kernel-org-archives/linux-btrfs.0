Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4309 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbbJ3Oks (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 10:40:48 -0400
Subject: Re: [PATCH V8 03/13] Btrfs: Direct I/O read: Work on sectorsized
 blocks
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1446019827-685-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1446019827-685-4-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56338151.4090800@fb.com>
Date: Fri, 30 Oct 2015 10:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <1446019827-685-4-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2015 04:10 AM, Chandan Rajendra wrote:
> The direct I/O read's endio and corresponding repair functions work on
> page sized blocks. This commit adds the ability for direct I/O read to work on
> subpagesized blocks.
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
