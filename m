From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: rewrite btrfs_trim_block_group()
Date: Thu, 24 Nov 2011 10:49:51 +0800
Message-ID: <4ECDB0CF.6020507@cn.fujitsu.com>
References: <4EC4B719.30007@cn.fujitsu.com> <20111123154657.GD12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111123154657.GD12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Thu, Nov 17, 2011 at 03:26:17PM +0800, Li Zefan wrote:
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index 8c32434..89cc54e 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> +static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
>> +			  u64 *total_trimmed, u64 start, u64 end, u64 minlen)
>> +{
>> +	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
>> +	struct btrfs_free_space *entry;
>> +	struct rb_node *node;
>> +	int ret;
>         int ret = 0;
> 
>   CC [M]  fs/btrfs/free-space-cache.o
> fs/btrfs/free-space-cache.c: In function trim_no_bitmap:
> fs/btrfs/free-space-cache.c:2636: warning: ret may be used uninitialized in this function
> 
> Although it seems the uninitialized value could never be returned.
> 

Actually it's possible. The odd thing is my gcc doesn't complain about this.

Will fix. Thanks!

--
Li Zefan
