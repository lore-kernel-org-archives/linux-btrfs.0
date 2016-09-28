Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13119 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753103AbcI1Lkt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 07:40:49 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57EBAAF5.10509@cn.fujitsu.com>
Date: Wed, 28 Sep 2016 19:35:17 +0800
MIME-Version: 1.0
In-Reply-To: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 09/28/2016 07:15 PM, Stefan Priebe - Profihost AG wrote:
> Dear list,
>
> is there any chance anybody wants to work with me on the following issue?
Though I'm also somewhat new to btrfs, but I'd like to.

>
> BTRFS: space_info 4 has 18446742286429913088 free, is not full
> BTRFS: space_info total=98247376896, used=77036814336, pinned=0,
> reserved=0, may_use=1808490201088, readonly=0
>
> i get this nearly every day.
>
> Here are some msg collected from today and yesterday from different servers:
> | BTRFS: space_info 4 has 18446742182612910080 free, is not full |
> | BTRFS: space_info 4 has 18446742254739439616 free, is not full |
> | BTRFS: space_info 4 has 18446743980225085440 free, is not full |
> | BTRFS: space_info 4 has 18446743619906420736 free, is not full |
> | BTRFS: space_info 4 has 18446743647369576448 free, is not full |
> | BTRFS: space_info 4 has 18446742286429913088 free, is not full
>
> What i tried so far without success:
> - use vanilla 4.8-rc8 kernel
> - use latest vanilla 4.4 kernel
> - use latest 4.4 kernel + patches from holger hoffstaette
> - use clear_cache,space_cache=v2
> - use clear_cache,space_cache=v1
>
> But all tries result in ENOSPC after a short period of time doing backups.
I also met enospc error in 4.8-rc6 when doing big files create and 
delete tests,
for my cases, I have written some patches to fix it.
Would you please apply my patches to have a try:
btrfs: try to satisfy metadata requests when every flush_space() returns
btrfs: try to write enough delalloc bytes when reclaiming metadata space
btrfs: make shrink_delalloc() try harder to reclaim metadata space
You can find them in btrfs mail list.

Regards,
Xiaoguang Wang
>
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



