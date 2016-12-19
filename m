Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28369 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755141AbcLSLII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 06:08:08 -0500
Subject: Re: [PATCH 3/3] btrfs: consolidate auto defrag kick off policies
To: dsterba@suse.cz
References: <20161206044309.3450-1-anand.jain@oracle.com>
 <20161206044309.3450-4-anand.jain@oracle.com>
 <20161212141204.GR12522@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <53820526-8974-ae63-dcbe-ec21e9254b2e@oracle.com>
Date: Mon, 19 Dec 2016 19:11:38 +0800
MIME-Version: 1.0
In-Reply-To: <20161212141204.GR12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


(sorry for the delay due to my vacation).

On 12/12/16 22:12, David Sterba wrote:
> On Tue, Dec 06, 2016 at 12:43:09PM +0800, Anand Jain wrote:
>> As of now writes smaller than 64k for non compressed extents and 16k
>> for compressed extents inside eof are considered as candidate
>> for auto defrag, put them together at a place.
>
> Missing sign-off.
sorry will fix.

>> ---
>>  fs/btrfs/inode.c | 27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 79f073e94f2d..b157575166c6 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -388,6 +388,22 @@ static inline int inode_need_compress(struct inode *inode)
>>  	return 0;
>>  }
>>
>> +static inline void inode_should_defrag(struct inode *inode,
>> +		u64 start, u64 end, u64 num_bytes, int comp_type)
>> +{
>> +	u64 small_write = SZ_64K;
>> +	if (comp_type)
>> +		small_write = SZ_16K;
>
> I think the small_write value should be passed directly, not the
> compression type.

  Will do.

>> +
>> +	if (!num_bytes)
>> +		num_bytes = end - start + 1;
>
> And the callers should pass the range length. Calculating inside the
> function makes it less clear. One of the callers passes an blocksize
> aligned value and the other doest not, so both know what's the right
> value.

  agreed. I have sent out v2. Kindly find it.

Thanks, Anand



> Otherwise the cleanup is good. I'll merge the other two patches, please
> update and resend this one. Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
