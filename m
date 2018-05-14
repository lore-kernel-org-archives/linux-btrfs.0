Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54683 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751855AbeENIYb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 04:24:31 -0400
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180514070210.27047-1-wqu@suse.com>
 <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <71cdf169-8cf9-1550-5dda-92768c822aa3@gmx.com>
Date: Mon, 14 May 2018 16:24:18 +0800
MIME-Version: 1.0
In-Reply-To: <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月14日 16:10, Nikolay Borisov wrote:
> 
> 
> On 14.05.2018 10:02, Qu Wenruo wrote:
>> As btrfs(5) specified:
>>
>> 	Note
>> 	If nodatacow or nodatasum are enabled, compression is disabled.
>>
>> If NODATASUM or NODATACOW set, we should not compress the extent.
>>
>> And in fact, we have bug report about corrupted compressed extent
>> leading to memory corruption in mail list.
>> Although it's mostly buggy lzo implementation causing the problem, btrfs
> 
> What does it mean "it's mostly buggy lzo implementation"? If we have bug
> in the LZO implementation that btrfs uses shouldn't it be fixed as well ?

It looks like buggy lzo decompress code which can't handle corrupted
data and results some random kernel memory corruption.
It's also possible that some incorrect function call in btrfs that
caused the problem.

It needs to be fixed of course, but right now, no binary dump of the
offending data, so we can't verify or further investigate the root cause.

Thanks,
Qu

> 
>> still needs to be fixed to meet the specification.
>>
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/inode.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index d241285a0d2a..dbef3f404559 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>>  {
>>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>  
>> +	/*
>> +	 * Btrfs doesn't support compression without csum or CoW.
>> +	 * This should have the highest priority.
>> +	 */
>> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
>> +	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
>> +		return 0;
>> +
>>  	/* force compress */
>>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>>  		return 1;
> 
> But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
> the inode flags,

I'm afraid not.
AFAIK the purpose of force compress is to bypass the compression ratio
detection, other than generating compressed extent for NODATASUM use case.

Thanks,
Qu

> presumably the admin knows what he is doing? Won't it
> be better if somewhere further in the call chain we check if
> FORCE_COMPRESS is set and if so override any inode flags. This can be
> implemented by _always_ calling inode_need_compress to decide if we
> should compress or not?
> 
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
