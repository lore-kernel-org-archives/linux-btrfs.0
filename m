Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59352 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751137AbdAYEQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 23:16:55 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
 <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
 <1485305208.12065.9.camel@scientia.net>
CC: <chris@colorremedies.com>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
Date: Wed, 25 Jan 2017 12:16:42 +0800
MIME-Version: 1.0
In-Reply-To: <1485305208.12065.9.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/25/2017 08:46 AM, Christoph Anton Mitterer wrote:
> On Wed, 2017-01-25 at 08:44 +0800, Qu Wenruo wrote:
>> Thanks for the test,
>
> You're welcome... I'm happy if I can help :)
>
> Just tell me once you think you found something, and I'll repeat the
> testing.
>
>
> Cheers,
> Chr
> is.

New patches are out now.

Although I just updated 
0001-btrfs-progs-lowmem-check-Fix-wrong-block-group-check.patch to fix 
all similar bugs.

You could get it from github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes

Unfortunately, I didn't find the cause of the remaining error of that 
missing csum.
And considering the size of your fs, btrfs-image is not possible, so I'm 
afraid you need to test the patches every time it updates.

Sorry for that,
Qu


