Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38698 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdGUEyN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 00:54:13 -0400
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
To: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
 <20170717183035.GR2866@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
Date: Fri, 21 Jul 2017 13:00:56 +0800
MIME-Version: 1.0
In-Reply-To: <20170717183035.GR2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/18/2017 02:30 AM, David Sterba wrote:
> So it basically looks good, I could not resist and rewrote the changelog
> and comments. There's one code fix:
> 
> On Mon, Jul 17, 2017 at 04:52:58PM +0300, Timofey Titovets wrote:
>> -static inline int inode_need_compress(struct inode *inode)
>> +static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>>   {
>>   	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>
>>   	/* force compress */
>>   	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>> -		return 1;
>> +		return btrfs_compress_heuristic(inode, start, end);



> This must stay 'return 1', if force-compress is on, so the change is
> reverted.

  Initially I thought 'return 1' is correct, but looking in depth,
  it is not correct as below..

  The biggest beneficiary of the estimating the compression ratio
  in advance (heuristic) is when customers are using the
  -o compress-force. But 'return 1' here is making them not to
  use heuristic. So definitely something is wrong.

  -o compress is about the whether each of the compression-granular bytes
  (BTRFS_MAX_UNCOMPRESSED) of the inode should be tried to compress OR
  just give up for the whole inode by looking at the compression ratio
  of the current compression-granular.
  This approach can be overridden by -o compress-force. So in
  -o compress-force there will be a lot more efforts in _trying_
  to compression than in -o compress. We must use heuristic for
  -o compress-force.

  btrfs_compress_heuristic is about the way of figuring out
  whether the current compression-granular is compression capable.
  Currently we are doing this part by trial-method (which is more
  accurate than the heuristic approach), in the function
  btrfs_compress_pages() and then we giving up in the function
  compress_file_range(). So IMO. btrfs_compress_heuristic() should
  be called at these functions.

  Further, heuristic is just estimating which may go wrong based
  on future compression algorithm ? (I am not sure).

  IMO. its a good idea to either add an option to enable/disable
  the heuristic.

Thanks, Anand



> I'm adding the patch to for-next.
> 
>>   	/* bad compression ratios */
>>   	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
>>   		return 0;
>>   	if (btrfs_test_opt(fs_info, COMPRESS) ||
>>   	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
>>   	    BTRFS_I(inode)->force_compress)
>> -		return 1;
>> +		return btrfs_compress_heuristic(inode, start, end);
>>   	return 0;
>>   }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
