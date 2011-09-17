From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Sat, 17 Sep 2011 14:10:51 +0800
Message-ID: <4E7439EB.7080100@oracle.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110916154815.GA27150@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

I once posted a similar patch for this issue which can be found at:
http://www.spinics.net/lists/linux-btrfs/msg12169.html

with an additional improvement if the offset is larger or equal to the
file size, return -ENXIO in directly:

if (offset >= inode->i_size) {
                        mutex_unlock(&inode->i_mutex);
                        return -ENXIO;
                }


Thanks,
-Jeff
On 09/16/2011 11:48 PM, Christoph Hellwig wrote:

> On Thu, Sep 15, 2011 at 04:06:47PM -0700, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c
> 
> I think this should go to Chris/Linus ASAP.  But a slightly better
> patch description wouldn't hurt either.
> 
> Also any reason you captialize BTRFS?
> 
>>
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  fs/btrfs/file.c |   13 +++++++------
>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 3c3abff..7ec0a24 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1818,19 +1818,17 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
>>  	case SEEK_DATA:
>>  	case SEEK_HOLE:
>>  		ret = find_desired_extent(inode, &offset, origin);
>> -		if (ret) {
>> -			mutex_unlock(&inode->i_mutex);
>> -			return ret;
>> -		}
>> +		if (ret)
>> +			goto error;
>>  	}
>>  
>>  	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
>>  		ret = -EINVAL;
>> -		goto out;
>> +		goto error;
>>  	}
>>  	if (offset > inode->i_sb->s_maxbytes) {
>>  		ret = -EINVAL;
>> -		goto out;
>> +		goto error;
>>  	}
>>  
>>  	/* Special lock needed here? */
>> @@ -1841,6 +1839,9 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
>>  out:
>>  	mutex_unlock(&inode->i_mutex);
>>  	return offset;
>> +error:
>> +	mutex_unlock(&inode->i_mutex);
>> +	return ret;
>>  }
>>  
>>  const struct file_operations btrfs_file_operations = {
>> -- 
>> 1.7.4.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
