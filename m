Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28027 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932571AbdC2Azq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 20:55:46 -0400
Subject: Re: How to test in-bound dedupe
To: Jitendra <jkhasdev@gmail.com>
References: <20170328175215.GA14991@jitendra-HP-ProBook>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <42e616fe-666b-ab97-06e7-849fbe5c7290@cn.fujitsu.com>
Date: Wed, 29 Mar 2017 08:55:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170328175215.GA14991@jitendra-HP-ProBook>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/29/2017 01:52 AM, Jitendra wrote:
> Hi Qu/All,
>
> I am looking into in-memory in-bound dedup. I have cloned your git tree
> from
> following urls.
>
> Linux Tree: https://github.com/adam900710/linux.git wang_dedupe_latest
> btrfs-progs: https://git@github.com:adam900710/btrfs-progs.git
> dedupe_20170316
>
> Then run the follwoing test
> https://btrfs.wiki.kernel.org/index.php/User_notes_on_dedupe.

Thanks for having interest in in-band dedupe.

>
> Is there any stuff that needs to be tested for it? if something, then
> please
> point out me.

Please note that, CONFIG_BTRFS_DEBUG must be set, or inband dedupe ioctl 
will still be hidden.

Basically, you could try all xfstests with inband dedupe enabled.
While it's not officially supported yet, you could modify _scratch_mount 
and _test_mount to always enable dedupe just after mount.

>
> My goal is to understand in-memory dedup and try to participate in on-disk
> de-dup.

On-disk dedupe backend is not provided yet, although planned and not 
hard to implement.

Our plan is to add on-disk dedupe backend after in-memory dedupe is 
merged and tested.


And about understanding current dedupe algorithm, it should not be that 
hard to understand, while the really hard part is from kernel itself.

Tons of facilities is involved in fs, from memory management to VFS to 
page cache to delayed allocation.

Thanks,
Qu
>
> ---
> Jitendra
>
>


