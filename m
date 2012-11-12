Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fredda.webgods.de ([192.166.196.83]:35708 "EHLO
	fredda.webgods.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2KLGub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 01:50:31 -0500
Message-ID: <50A09644.1010507@jan-o-sch.net>
Date: Mon, 12 Nov 2012 07:25:08 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Chris Samuel <chris@csamuel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>,
        wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Btrfs-progs: disable qgroupid 0 for quota_tree
References: <509B8053.3080509@cn.fujitsu.com> <509B8197.2090601@cn.fujitsu.com> <509C4160.2050900@csamuel.org> <50A05D18.7080503@cn.fujitsu.com>
In-Reply-To: <50A05D18.7080503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On Mon, November 12, 2012 at 03:21 (+0100), Miao Xie wrote:
> On fri, 09 Nov 2012 10:33:52 +1100, Chris Samuel wrote:
>> On 08/11/12 20:55, Miao Xie wrote:
>>
>>> In kernel, qgroupid 0 is a special number when we run the quota group
>>> limit command.
>>>
>>> So, we should not be able to create a quota group whose id is 0,
>>> otherwise the kernel can't deal with it. Fix it.
>>
>> This is probably a stupid question - but if its not meant to be possible
>> to create such a thing shouldn't this be fixed in the kernel (as well as
>> here) to reject attempts from user space to create it?
>>
>> Otherwise it's possible for a non-aware program (or a user who is
>> playing) to still create it.
> 
> Right. It also should be fixed in the kernel side, the patch is coming.
> 
> But since we know which number is valid or not, it is better that we also check
> the arguments in the user tool before they are passed into the kernel. So, we
> can avoid trapping into the kernel, which will waste time, and output the error
> information as soon as possible.

Have the kernel return with errno EINVAL is the way everyone else (I know about)
does this.

I would avoid doing a check more than once where ever possible. Primarily,
because duplicating checks is error prone and in case of a kernel interface it
complicates future changes.

-Jan
