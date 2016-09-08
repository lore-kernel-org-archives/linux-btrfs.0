Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5702 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932252AbcIHE6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2016 00:58:23 -0400
Subject: Re: [PATCH] btrfs: fix false enospc error when truncating heavily
 reflinked file
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20160907121738.23713-1-wangxg.fnst@cn.fujitsu.com>
 <20160907155635.GA9301@birch.djwong.org>
CC: <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57D0EEDA.5070204@cn.fujitsu.com>
Date: Thu, 8 Sep 2016 12:53:46 +0800
MIME-Version: 1.0
In-Reply-To: <20160907155635.GA9301@birch.djwong.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/07/2016 11:56 PM, Darrick J. Wong wrote:
> On Wed, Sep 07, 2016 at 08:17:38PM +0800, Wang Xiaoguang wrote:
>> Below test script can reveal this bug:
>>      dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=100
>>      dev=$(losetup --show -f fs.img)
>>      mkdir -p /mnt/mntpoint
>>      mkfs.btrfs  -f $dev
>>      mount $dev /mnt/mntpoint
>>      cd /mnt/mntpoint
>>
>>      echo "workdir is: /mnt/mntpoint"
>>      blocksize=$((128 * 1024))
>>      dd if=/dev/zero of=testfile bs=$blocksize count=1
>>      sync
>>      count=$((17*1024*1024*1024/blocksize))
>>      echo "file size is:" $((count*blocksize))
>>      for ((i = 1; i <= $count; i++)); do
>>          dst_offset=$((blocksize * i))
>>          xfs_io -f -c "reflink testfile 0 $dst_offset $blocksize"\
>>                  testfile > /dev/null
>>      done
>>      sync
>>      truncate --size 0 testfile
>>
>> The last truncate operation will fail for ENOSPC reason, but indeed
>> it should not fail.
> Could you make this into an xfstest so we can avoid future regressions, please?
OK.

Regards,
Xiaoguang Wang
>
> --D
>
>> In btrfs_truncate(), we use a temporary block_rsv to do truncate
>> operation. With every btrfs_truncate_inode_items() call, we migrate space
>> to this block_rsv, but forget to cleanup previous reservation, which
>> will make this block_rsv's reserved bytes keep growing, and this reserved
>> space will only be released in the end of btrfs_truncate(), this metadata
>> leak will impact other's metadata reservation. In this case, it's
>> "btrfs_start_transaction(root, 2);" fails for enospc error, which make
>> this truncate operation fail.
>>
>> Call btrfs_block_rsv_release() to fix this bug.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/inode.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index e6811c4..40f0762 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -9206,6 +9206,7 @@ static int btrfs_truncate(struct inode *inode)
>>   			break;
>>   		}
>>   
>> +		btrfs_block_rsv_release(root, rsv, -1);
>>   		ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
>>   					      rsv, min_size, 0);
>>   		BUG_ON(ret);	/* shouldn't happen */
>> -- 
>> 2.9.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



