Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:48157 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbeEOKs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 06:48:58 -0400
Subject: Re: [PATCH 1/2] btrfs: inode: Don't compress if NODATASUM or
 NODATACOW set
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180515073622.18732-1-wqu@suse.com>
 <20180515073622.18732-2-wqu@suse.com>
 <9c4e5071-d83b-01db-2c2f-518ee1650713@suse.com>
 <d49bc96a-2a15-b64e-eaa0-47e62ee57fa3@gmx.com>
 <9ff17ff6-2b1e-6207-ffdb-67b0fde56368@suse.com>
 <8d6a71d1-e134-7e9c-d81e-006f5c318e58@gmx.com>
 <ece1041d-ef2d-6856-c096-c9703fb19c4c@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9febdaad-b8fe-7404-d235-da905416d0ac@gmx.com>
Date: Tue, 15 May 2018 18:48:47 +0800
MIME-Version: 1.0
In-Reply-To: <ece1041d-ef2d-6856-c096-c9703fb19c4c@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月15日 18:36, Nikolay Borisov wrote:
> 
> 
> On 15.05.2018 11:48, Qu Wenruo wrote:
> <SNIP>
> 
>>>>>
>>>>>
>>>>> static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)  
>>>>> {                                                                               
>>>>>         struct btrfs_fs_info *fs_info =trfs_sb(inode->i_sb);                  
>>>>>                                                                                 
>>>>>         /* defrag ioctl */                                                      
>>>>>         if (BTRFS_I(inode)->defrag_compress)                                    
>>>>>                 return 1;                                                       
>>>>>         /* bad compression ratios */                                            
>>>>>         if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)                     
>>>>>                 return 0;                                                       
>>>>
>>>> Not exactly.
>>>> Force-compress should less us bypass bad compression ratio, so it should
>>>> be at least before ratio check.
> 
> Fair enough, what prompted me in suggesting this is that perhaps the
> check for BTRFS_INODE_NOCOMPRESS should be somwhere at the top of the
> function (alongside the newly added two checks for inode flags), no ?
> INODE_NOCOMPRESS can be set via icotl not necessarily only due to bad
> compression ratio.

This is much trickier than expected.

The point here is, what's the correct behavior for compress-force.
Should it override manually set NOCOMPRESS?

Unfortunately I have no idea at all.
So I can only leave it as is for now.

Thanks,
Qu

> 
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>         /* force compress */                                                    
>>>>>         if (btrfs_test_opt(fs_info, FORCE_COMPRESS))                            
>>>>>                 return 1;                                                       
>>>>>         if (btrfs_test_opt(fs_info, COMPRESS) ||                                
>>>>>             BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||                     
>>>>>             BTRFS_I(inode)->prop_compress)                                      
>>>>>                 return btrfs_compress_heuristic(inode, start, end);             
>>>>>         return 0;                                                               
>>>>> }             
> 
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
