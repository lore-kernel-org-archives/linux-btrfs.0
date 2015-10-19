Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56760 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbbJSMip (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 08:38:45 -0400
Subject: Re: [devel branch]Btrfs-convert assert at volumes.c:1846
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <5624B828.80405@cn.fujitsu.com> <20151019112108.GU27761@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5624E445.3040203@gmx.com>
Date: Mon, 19 Oct 2015 20:38:29 +0800
MIME-Version: 1.0
In-Reply-To: <20151019112108.GU27761@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

在 2015年10月19日 19:21, David Sterba 写道:
> On Mon, Oct 19, 2015 at 05:30:16PM +0800, Qu Wenruo wrote:
>> Recently I'm reworking the btrfs-convert chunk allocater to make it able
>> to separate data and meta chunk.
>>
>> But when I was testing, I found that, your devel branch, with the
>> following commit just fails to convert an empty ext4 filesystem:
>>
>> commit 0002085c53a5ac9ad1c538bfc3e39c80891c4a1a
>> Author: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Date:   Mon Oct 12 21:23:04 2015 +0800
>>
>>       btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command
>
> That's the top commit, but it's not causing the breakage. I've bisected
> the breakage to the patch
>
> commit 893b7a6815a735449613afbb4040f486a4a4e1d0
> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date:   Wed May 13 17:15:34 2015 +0800
>
>      btrfs-progs: Read the whole superblock instead of struct btrfs_super_block.
>
> Looks familiar? :)
>
> The patch caused some trouble in the past (on ppc64 machines) and I've
> been holding it back due to that. The plan is to add it to 4.3 devel
> branch and get it fixed before the final release, so the convert could
> fail in the meantime. I'm trying to put together all pending branches
> for the next release so I can't say when the convert will be fixed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Thanks for the bisect, David.

Very interesting, I'll try to fix it in recent days at least to make 
sure that btrfs-convert can be executed without assert.

Hopes the convert rework for separated chunk profile will arrive in time.

Thanks,
Qu
