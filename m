Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752472AbeEKIj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 04:39:59 -0400
Subject: Re: [PATCH 2/5] btrfs: Split btrfs_del_delalloc_inode into 2
 functions
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <1524820914-30864-3-git-send-email-nborisov@suse.com>
 <7f535049-9127-7acc-f49c-4fa0b2e50919@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <841661a5-0380-7e93-3e0a-5926a8a921b8@suse.com>
Date: Fri, 11 May 2018 11:39:56 +0300
MIME-Version: 1.0
In-Reply-To: <7f535049-9127-7acc-f49c-4fa0b2e50919@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.05.2018 08:44, Anand Jain wrote:
> 
> 
> On 04/27/2018 05:21 PM, Nikolay Borisov wrote:
>> This is in preparation of fixing delalloc inodes leakage on transaction
>> abort. Also export the new function.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
>  nit: I think we are reserving function prefix __ for some special
>  functions. I am not sure if the function name should prefix with __
>  here.

Generally __ prefix is used for some internal function. In this case the
gist of the function (with no locking) is behind the __ prefixed
function, whereas the non __ version adds the necessary locking. I think
this is a fairly well-established pattern in the kernel.
> 
> Reviewed-by: Anand Jain <anand.jain@orcle.com>
> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
