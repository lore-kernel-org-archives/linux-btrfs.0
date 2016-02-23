Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47725 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754275AbcBWCHF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 21:07:05 -0500
Subject: Re: [PATCH] btrfs: use proper type for failrec in extent_state
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <1455193453-14837-1-git-send-email-dsterba@suse.com>
 <20160222175837.GH4374@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CBBEC3.8040106@cn.fujitsu.com>
Date: Tue, 23 Feb 2016 10:06:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160222175837.GH4374@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/02/22 18:58 +0100:
> On Thu, Feb 11, 2016 at 01:24:13PM +0100, David Sterba wrote:
>> We use the private member of extent_state to store the failrec and play
>> pointless pointer games.
>>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>
> I'm not sure why, but my gcc 5.3.1 think's that a member of failrec can
> be used uninitialized:
>
>    CC [M]  fs/btrfs/extent_io.o
> fs/btrfs/extent_io.c: In function ‘clean_io_failure’:
> fs/btrfs/extent_io.c:2133:4: warning: ‘failrec’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      repair_io_failure(inode, start, failrec->len,
>      ^
>
After applying your patch on integration-4.6, and compiling, my gcc 
5.3.0 didn't give such warning though.

And I didn't see an official 5.3.1, but only 5.3 so I assume maybe it's 
related to the .1 from your distribution?
(As my gcc is from Archlinux, I assume minimally patched)

Thanks,
Qu

> which points to:
>
> 2126         if (state && state->start <= failrec->start &&
> 2127             state->end >= failrec->start + failrec->len - 1) {
> 2128                 num_copies = btrfs_num_copies(fs_info, failrec->logical,
> 2129                                               failrec->len);
> 2130                 if (num_copies > 1)  {
> 2131                         repair_io_failure(inode, start, failrec->len,
> 2132                                           failrec->logical, page,
> 2133                                           pg_offset, failrec->failed_mirror);
> 2134                 }
> 2135         }
>
> After separating all members to local varaibles, it points to ->len. Which is
> used several times in code above.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


