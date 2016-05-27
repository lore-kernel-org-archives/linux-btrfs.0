Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62484 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbcE0LFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 07:05:07 -0400
Subject: Re: [PATCH 1/2] Btrfs-progs: make convert to allocate space from the
 desired type of block group
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
 <7cdcb731-ef9a-a967-0218-31476d40c8d3@cn.fujitsu.com>
 <20160527105502.GT29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <357a411f-e4b5-0f1d-5ee9-6074acdd5b87@gmx.com>
Date: Fri, 27 May 2016 19:04:42 +0800
MIME-Version: 1.0
In-Reply-To: <20160527105502.GT29147@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/27/2016 06:55 PM, David Sterba wrote:
> On Fri, May 27, 2016 at 09:38:09AM +0800, Qu Wenruo wrote:
>> Since btrfs-convert has been reworked to use a completely new method to
>> do such allocation, now it doesn't need any custom_alloc_extent() function.
>>
>> And its new chunk lay out is designed to only put metadata chunk into
>> large enough unused space, and data chunks will cover all used space.
>>
>> So there is no need for such patch AFAIK.
>
> I agree, and I think that the motivation for the convert rewrite was the
> same problem that these patches address.
>
>> And the new convert is already in devel branch.
>
> The plan is to release 4.6 with this patchset, I'm still not decided
> about the low-mem mode for checker.

For low memory mode, at least we're not that eager to see it merged into 
4.6.

Although if it could be merged, it would make us free from rebasing it 
again and again.

But the problem is, for end-user, we are cheating them, as the low 
memory mode is not really that low memory.
Since fs tree is still eating tons of memory.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
