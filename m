Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32300 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750703AbdAWHNk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 02:13:40 -0500
Subject: Re: [PATCH] btrfs: raid56: Remove unused variant in lock_stripe_add
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170116022306.32446-1-quwenruo@cn.fujitsu.com>
 <20170120182450.GG11951@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1d87f1fe-535f-ac9a-70de-7373d9ce2f77@cn.fujitsu.com>
Date: Mon, 23 Jan 2017 15:13:24 +0800
MIME-Version: 1.0
In-Reply-To: <20170120182450.GG11951@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/21/2017 02:24 AM, David Sterba wrote:
> On Mon, Jan 16, 2017 at 10:23:06AM +0800, Qu Wenruo wrote:
>> Variant 'walk' in lock_stripe_add() is never used.
>> Remove it.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Added to 4.11 queue, thaks. Changelog and subject edited.
>
>
Thanks for the kind info.
Qu


