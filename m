Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12779 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaACJ0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 04:26:30 -0500
Message-ID: <52C68297.80707@cn.fujitsu.com>
Date: Fri, 03 Jan 2014 17:27:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Btrfs: use flags instead of the bool variants
 in delayed node
References: <1388034426-4935-1-git-send-email-miaox@cn.fujitsu.com> <1388034426-4935-5-git-send-email-miaox@cn.fujitsu.com> <20140102174955.GO6498@twin.jikos.cz>
In-Reply-To: <20140102174955.GO6498@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2 Jan 2014 18:49:55 +0100, David Sterba wrote:
> On Thu, Dec 26, 2013 at 01:07:05PM +0800, Miao Xie wrote:
>> +#define BTRFS_DELAYED_NODE_IN_LIST	0
>> +#define BTRFS_DELAYED_NODE_INODE_DIRTY	1
>> +
>>  struct btrfs_delayed_node {
>>  	u64 inode_id;
>>  	u64 bytes_reserved;
>> @@ -65,8 +68,7 @@ struct btrfs_delayed_node {
>>  	struct btrfs_inode_item inode_item;
>>  	atomic_t refs;
>>  	u64 index_cnt;
>> -	bool in_list;
>> -	bool inode_dirty;
>> +	unsigned long flags;
>>  	int count;
>>  };
> 
> What's the reason to do that? Replacing 2 bools with a bitfield
> does not seem justified, not from saving memory, nor from a performance
> gain side.  Also some of the bit operations imply the lock instruction
> prefix so this affects the surrounding items as well.
> 
> I don't think this is needed, unless you have further plans with the
> flags item.

Yes, I introduced a flag in the next patch.

And we can not common bit operation here because we hold different locks when we change
those bits, we have to use the bit operations which implies the lock instruction.

Thanks
Miao
