Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59383 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbbIZH4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 03:56:53 -0400
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150911145638.GP8891@twin.jikos.cz> <56034F7B.5050107@cn.fujitsu.com>
 <20150925151951.GI11442@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56064FBA.4000809@gmx.com>
Date: Sat, 26 Sep 2015 15:56:42 +0800
MIME-Version: 1.0
In-Reply-To: <20150925151951.GI11442@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月25日 23:19, David Sterba 写道:
> On Thu, Sep 24, 2015 at 09:18:51AM +0800, Qu Wenruo wrote:
>> After some ext* lecture given by my teammate, Wang Xiaoguang, I'm more
>> convinced that, at least for convert from ext*, separate chunk type will
>> not be a good idea.
>
> Thanks for the additional research.
>
>> For above almost empty ext4 case, it will cause less problem, as
>> we can batch several groups and put a large data chunk to cover them,
>> then allocate a 100+M metadata chunk.
>
>> But if the filesystem is used and most group only has scattered
>> available space, we may ended up unable to alloc any metadata chunk.
>
> I think this is the price we pay for the in-place conversion, we can
> safely use only the free space and respect the constraints it gives.
> As long as the ext2_subvol exists, ie. the original data and metadata
> are pinned, we don't have much choice. Rebalancing is possible but given
> the remaining space may fail to allocate block groups of desired size.
>
>> This will make the usage of limited block group quite limited.
>> Although I'll continue add such support for btrfs-convert, I'm quite
>> concerned about the usage...
>
> So can we do it like this:
>
> 1) enable support for mixed bg in convert
> 2) implement mixed -> split conversion in balance
> 3) force convert to do mixed bgs by default
>
> The conversion from/to mixed would be good on it's own but may not be
> trivial to implement.

Agreed, and consider it is kernel code, it will be much harder to 
code/debug.

> If the main concern about result of conversion is
> bad bg layout, I'd say that we rely on balance to reshuffle the bgs to
> make the filesystem more up to the desired layout.

That's OK.
At least we don't need to implement kernel convert support for mixed bg.

I'll implement both mixed bg and separate one and allow user to choose.

And for extreme case, if we can't allocate any metadata chunk larger 
than 16M, either info user and exit or do automatic mixed-bg conversion 
if no conflicting options.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
