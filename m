Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52756 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932139AbbFWJSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 05:18:31 -0400
Subject: Re: Btrfs progs release 4.1
To: Sjoerd <sjoerd@sjomar.eu>, <linux-btrfs@vger.kernel.org>
References: <20150622150023.GX6761@twin.jikos.cz> <7324923.Sa0lmcTP0G@hoefnix>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55892466.50107@cn.fujitsu.com>
Date: Tue, 23 Jun 2015 17:18:30 +0800
MIME-Version: 1.0
In-Reply-To: <7324923.Sa0lmcTP0G@hoefnix>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Sjoerd wrote on 2015/06/23 11:03 +0200:
> On Monday 22 June 2015 17:00:23 David Sterba wrote:
>> Hi,
>>
>> btrfs-progs 4.1 have been released (in time with kernel 4.1). Unusual load
>> of changes.
>
> Would it be beneficial to update when using older kernels (3.19.x in my case)?
Part(most) of.

Some one like qgroup limit needs kernel support.
UI and offline tools change won't depend on kernel version.
But the UI change is most obvious one, so upgrade user-tool should give 
your a quite fresh feel.

> I can't upgrade to kernel 4.1 since my nvidia (propriety) drivers won't
> support it (yet) :(

Same Nvidia binary driver here, but I just need to wait the kernel and 
nvidia package enter testing repo of Arch. :)

Thanks,
Qu

>
> Cheers,
> Sjoerd
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
