Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKFll (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 01:41:41 -0400
Subject: Re: [PATCH 2/5] btrfs: Split btrfs_del_delalloc_inode into 2
 functions
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <1524820914-30864-3-git-send-email-nborisov@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7f535049-9127-7acc-f49c-4fa0b2e50919@oracle.com>
Date: Fri, 11 May 2018 13:44:02 +0800
MIME-Version: 1.0
In-Reply-To: <1524820914-30864-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/27/2018 05:21 PM, Nikolay Borisov wrote:
> This is in preparation of fixing delalloc inodes leakage on transaction
> abort. Also export the new function.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

  nit: I think we are reserving function prefix __ for some special
  functions. I am not sure if the function name should prefix with __
  here.

Reviewed-by: Anand Jain <anand.jain@orcle.com>

Thanks, Anand
