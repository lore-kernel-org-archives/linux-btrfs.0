Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18951 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbbJAOvH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:51:07 -0400
Subject: Re: [PATCH V5 12/13] Btrfs: prepare_pages: Retry adding a page to the
 page cache
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608912-31667-13-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D4836.8020301@fb.com>
Date: Thu, 1 Oct 2015 10:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <1443608912-31667-13-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> When reading the page from the disk, we can race with Direct I/O which can get
> the page lock (before prepare_uptodate_page() gets it) and can go ahead and
> invalidate the page. Hence if the page is not found in the inode's address
> space, retry the operation of getting a page.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---

Huh, how in the world did you make that happen?

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
