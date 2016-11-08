Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61176 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751260AbcKHAnn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 19:43:43 -0500
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
To: Marc MERLIN <marc@merlins.org>
References: <20161107012009.xng7hyhoqwqres3u@merlins.org>
 <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
 <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
 <20161107053647.uj7df3ppve4pbfms@merlins.org>
 <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com>
 <20161107145502.7lahpm6smqsv6s2q@merlins.org>
 <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
 <20161108003950.GD13371@merlins.org>
CC: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
Date: Tue, 8 Nov 2016 08:43:34 +0800
MIME-Version: 1.0
In-Reply-To: <20161108003950.GD13371@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/08/2016 08:39 AM, Marc MERLIN wrote:
> On Tue, Nov 08, 2016 at 08:35:54AM +0800, Qu Wenruo wrote:
>>> Understood. One big thing (for me) I forgot to confirm:
>>> 1) btrfs receive
>>
>> Unfortunately, receive is completely done in userspace.
>> Only send works inside kernel.
>
> right, I've confirmed that btrfs receive fails.
> It looks like btrfs balance is also failing, which is more surprising.
> Isn't that one in the kernel?

That's strange, balance is done completely in kernel space.

Unless we're calling vfs_* function we won't go through the extra check.

What's the error reported?

Thanks,
Qu
>
> Marc
>


