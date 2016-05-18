Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbcERAkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 20:40:36 -0400
Subject: Re: [PATCH 2/4] btrfs-progs: ctree: return earlier for
 btrfs_previous_item
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463456878-17550-3-git-send-email-quwenruo@cn.fujitsu.com>
 <20160517125051.GL511@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2c29e7f4-1da8-f214-89bf-17a33bc7e4e0@cn.fujitsu.com>
Date: Wed, 18 May 2016 08:40:22 +0800
MIME-Version: 1.0
In-Reply-To: <20160517125051.GL511@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/17 14:50 +0200:
> On Tue, May 17, 2016 at 11:47:56AM +0800, Qu Wenruo wrote:
>> Btrfs_previous_item() has a parameter to specify minimal objectid to
>> return.
>>
>> But surprisingly it doesn't use it at all.
>> Although that's OK, but it would take years long for large tree, so
>> return it earlier.
>
> This makes it closer to the kernel implementation, but still not equal,
> there are some more shortcuts. Can you please port them as well? This
> patch is independent of the rest so I'd take it separatelly.
>
>
Thanks, I just forgot that we can refer to kernel implement.

I'll submit it as a separate patch soon.

Thanks,
Qu


