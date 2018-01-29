Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751604AbeA2UEB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 15:04:01 -0500
Subject: Re: [PATCH] btrfs: btrfs_evict_inode must clear all inodes
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>
References: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
 <20180129195806.GA6535@dhcp-10-159-251-27.vpn.oracle.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <322a2cba-7c1c-2ef7-9ca9-936c36f43103@suse.com>
Date: Mon, 29 Jan 2018 15:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <20180129195806.GA6535@dhcp-10-159-251-27.vpn.oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/29/18 2:58 PM, Liu Bo wrote:
> On Mon, Jan 29, 2018 at 11:46:28AM -0500, Jeff Mahoney wrote:
>> btrfs_evict_inode must clear all inodes or we'll hit a BUG_ON in evict().
>>
>> Fixes: 3d48d9810de (btrfs: Handle uninitialised inode eviction)
>> Cc: Nikolay Borisov <nborisov@suse.com>
>> Cc: <stable@vger.kernel.org> # v4.8+
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/inode.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -5282,6 +5282,7 @@ void btrfs_evict_inode(struct inode *ino
>>  	trace_btrfs_inode_evict(inode);
>>  
>>  	if (!root) {
>> +		clear_inode(inode);
>>  		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
> 
> I had a patch for this, and also kmem_cache_free() is not supposed to
> be called here, but in ->destroy_inode().

Yep, that too.

Thanks,

-Jeff

-- 
Jeff Mahoney
SUSE Labs
