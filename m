Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbeEKFgT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 01:36:19 -0400
Subject: Re: [PATCH v2] btrfs: Unexport and rename btrfs_invalidate_inodes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1524820914-30864-6-git-send-email-nborisov@suse.com>
 <1524828984-2797-1-git-send-email-nborisov@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4a4d8705-2a30-e7d3-bfa0-ef46bdc8666b@oracle.com>
Date: Fri, 11 May 2018 13:38:38 +0800
MIME-Version: 1.0
In-Reply-To: <1524828984-2797-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/27/2018 07:36 PM, Nikolay Borisov wrote:
> This function is no longer used outside of inode.c so just make it
> static. At the same time give a more becoming name, since it's not
> really invalidating the inodes but just calling d_prune_alias. Last,
> but not least - move the function above the sole caller to avoid
> introducing yet-another-pointless forward declaration.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
