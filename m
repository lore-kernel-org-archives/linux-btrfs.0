Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26820 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbcGZRVG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:21:06 -0400
Subject: Re: [PATCH V20 03/19] Btrfs: subpage-blocksize: Make sure delalloc
 range intersects with the locked page's range
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, <clm@fb.com>,
        <dsterba@suse.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1467606879-14181-4-git-send-email-chandan@linux.vnet.ibm.com>
CC: <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <ee4306ec-2ca7-387a-a61d-e3f5ca650be1@fb.com>
Date: Tue, 26 Jul 2016 13:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <1467606879-14181-4-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2016 12:34 AM, Chandan Rajendra wrote:
> find_delalloc_range indirectly depends on EXTENT_UPTODDATE to make sure that
> the delalloc range returned intersects with the file range mapped by the
> page. Since we now track "uptodate" state in a per-page
> bitmap (i.e. in btrfs_page_private->bstate), this commit makes an explicit
> check to make sure that the delalloc range starts from within the file range
> mapped by the page.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
