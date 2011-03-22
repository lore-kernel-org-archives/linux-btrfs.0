From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 v2] Btrfs: Per file/directory controls for COW and
 compression
Date: Tue, 22 Mar 2011 10:06:50 +0800
Message-ID: <4D88043A.6030002@cn.fujitsu.com>
References: <4D8712E9.108@cn.fujitsu.com> <20110321174348.GC8235@granier.hd.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110321174348.GC8235@granier.hd.free.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/22/2011 01:43 AM, Johann Lombardi wrote:
> On Mon, Mar 21, 2011 at 04:57:13PM +0800, liubo wrote:
>> @@ -4581,8 +4583,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>>  	location->offset = 0;
>>  	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
>>  
>> -	btrfs_inherit_iflags(inode, dir);
>> -
>>  	if ((mode & S_IFREG)) {
>>  		if (btrfs_test_opt(root, NODATASUM))
>>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>> @@ -4590,6 +4590,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
>>  	}
>>  
>> +	btrfs_inherit_iflags(inode, dir);
> 
> The problem is that btrfs_inherit_iflags() overwrites BTRFS_I(inode)->flags with the parent's flags, so you lose BTRFS_INODE_NODATA{SUM|COW}.
> 

Thanks for pointing this, will fix it.

thanks,
liubo

> Johann
> 

