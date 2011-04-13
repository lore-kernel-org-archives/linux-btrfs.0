From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't reserve metadata when we're using the delalloc
 reserve
Date: Wed, 13 Apr 2011 12:41:54 -0400
Message-ID: <4DA5D252.5070103@redhat.com>
References: <1302710775-29602-1-git-send-email-josef@redhat.com> <4DA5D081.4070108@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA5D081.4070108@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/13/2011 12:34 PM, Arne Jansen wrote:
> On 13.04.2011 18:06, Josef Bacik wrote:
>> There are a bunch of places where we do btrfs_join_transaction(root, 1), but
>> really we set the block_rsv to the delalloc reserve because our metadata was
>> reserved at delalloc time.  This means we don't need to reserve space at all,
>> and can just join the transaction and go.  This patch also fixes a few places
>> where we weren't actually setting the block_rsv to the delalloc reserve.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik<josef@redhat.com>
>> ---
>>   fs/btrfs/inode.c |   27 +++++++++++++++++----------
>>   1 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index c4b914e..e9bda50 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -420,7 +420,7 @@ again:
>>   		}
>>   	}
>>   	if (start == 0) {
>> -		trans = btrfs_join_transaction(root, 1);
>> +		trans = btrfs_join_transaction(root, 0);
>
> btrfs_join_transaction ignores the num_blocks parameter, so this
> shouldn't change anything. Maybe it's cleaner to just eradicate
> the parameter.
>

Balls I forgot about that, though we should still be using the delalloc 
block reserve in the places that I put it.  I'll just fix that up.  Thanks,

Josef
