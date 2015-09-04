Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21087 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756406AbbIDDVJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Sep 2015 23:21:09 -0400
Subject: Re: [PATCH] btrfs: scrub: set error stats when tree block spanning
 stripes
To: <dsterba@suse.cz>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com>
 <20150826171949.GA11834@twin.jikos.cz>
 <03b601d0e069$ddd50ee0$997f2ca0$@cn.fujitsu.com>
 <20150903131719.GR11834@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55E90E21.9020004@cn.fujitsu.com>
Date: Fri, 4 Sep 2015 11:21:05 +0800
MIME-Version: 1.0
In-Reply-To: <20150903131719.GR11834@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David and Zhao,

David Sterba wrote on 2015/09/03 15:17 +0200:
> On Thu, Aug 27, 2015 at 09:44:05AM +0800, Zhao Lei wrote:
> [...]
>
> Thanks for the links and summary!
>
>> But it is still uncorrectable because neither kernel nor btrfsck can fix
>> it(only can report).
>
> I'm curious if it' is possible to write code that would fix the problem,
> eg. te relocate or shift the blocks. The 'btrfs rescue' command group is
> meant for this type of targeted fixes, unless it's easy to integrate it
> to the check & repair itself.

I'm happy and willing to add the relocating ability for btrfs-progs.
As that will provide a lot of flexibility, while the code should be 
quite easy if I do it in a NOCOW method.
(Find a extent, copy it to other place, follow backref and modify)

The only concern is, does it mean that we need to implement all the 
features of btrfs kernel in user space tool?
And will it make the codes duplicated between kernel and progs?

Thanks,
Qu

>
>> In short, it is caused by old version of btrfs-convert, and already fixed,
>> and this patch is used to make scrub report it in output.
>
> I assume there are people affected by this problem so it would be good
> to have a repair tool.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
