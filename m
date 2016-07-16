Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53532 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbcGPXyN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 19:54:13 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Christian Rohmann <crohmann@netcologne.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
 <55BB0A39.1050208@cn.fujitsu.com>
 <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
 <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
 <55C017E7.40704@cn.fujitsu.com>
 <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
 <55C02AF9.3070600@cn.fujitsu.com>
 <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
 <55C0A1ED.6020407@gmail.com>
 <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com>
 <CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
 <126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
 <d14c14d2-79d3-222b-59e2-ae8b38c7f2d4@netcologne.de>
Cc: btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c14cbb3a-7eb7-11de-e502-5e7d97719f3f@gmx.com>
Date: Sun, 17 Jul 2016 07:53:45 +0800
MIME-Version: 1.0
In-Reply-To: <d14c14d2-79d3-222b-59e2-ae8b38c7f2d4@netcologne.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/15/2016 07:29 PM, Christian Rohmann wrote:
> Hey Qu, all
>
> On 07/15/2016 05:56 AM, Qu Wenruo wrote:
>>
>> The good news is, we have patch to slightly speedup the mount, by
>> avoiding reading out unrelated tree blocks.
>>
>> In our test environment, it takes 15% less time to mount a fs filled
>> with 16K files(2T used space).
>>
>> https://patchwork.kernel.org/patch/9021421/
>
> I have a 30TB RAID6 filesystem with compression on and I've seen mount
> times of up to 20 minutes (!).
>
> I don't want to sound unfair, but 15% improvement is good, but not in
> the league where BTRFS needs to be.
> Do I understand you comments correctly that further improvement would
> result in a change of the on-disk format?

Yes, that's the case.

The problem is, we put BLOCK_GROUP_ITEM into extent tree, along with 
tons of EXTENT_ITEM/METADATA_ITEM.

This makes search for BLOCK_GROUP_ITEM very very very slow if extent 
tree is really big.

On the handle, we search CHUNK_ITEM very very fast, because CHUNK_ITEM 
are in their own tree.
(CHUNK_ITEM and BLOCK_GROUP_ITEM are 1:1 mapped)

So to completely fix it, btrfs needs on-disk format change to put 
BLOCK_GROUP_ITEM into their own tree.

IMHO there maybe be some objection from other devs though.

Anyway, I add the three maintainers to Cc, and hopes we can get a better 
idea to fix it.

Thanks,
Qu
>
>
>
> Thanks and with regards
>
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
