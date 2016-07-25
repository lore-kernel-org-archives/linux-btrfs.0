Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9019 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbcGYNib (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 09:38:31 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Christian Rohmann <crohmann@netcologne.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
References: <55C02AF9.3070600@cn.fujitsu.com>
 <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
 <55C0A1ED.6020407@gmail.com>
 <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com>
 <CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
 <126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
 <d14c14d2-79d3-222b-59e2-ae8b38c7f2d4@netcologne.de>
 <c14cbb3a-7eb7-11de-e502-5e7d97719f3f@gmx.com>
 <0ac17bdc-64eb-bbbd-ae90-61cfdc16660d@fb.com>
 <20160725130117.GB30795@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <0291c034-0514-8788-1bf8-3c6a3b86954c@fb.com>
Date: Mon, 25 Jul 2016 09:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <20160725130117.GB30795@suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/25/2016 09:01 AM, David Sterba wrote:
> On Mon, Jul 18, 2016 at 09:42:50AM -0400, Josef Bacik wrote:
>>>
>>> This makes search for BLOCK_GROUP_ITEM very very very slow if extent tree is
>>> really big.
>>>
>>> On the handle, we search CHUNK_ITEM very very fast, because CHUNK_ITEM are in
>>> their own tree.
>>> (CHUNK_ITEM and BLOCK_GROUP_ITEM are 1:1 mapped)
>>>
>>> So to completely fix it, btrfs needs on-disk format change to put
>>> BLOCK_GROUP_ITEM into their own tree.
>>>
>>> IMHO there maybe be some objection from other devs though.
>>>
>>> Anyway, I add the three maintainers to Cc, and hopes we can get a better idea to
>>> fix it.
>>
>> Yeah I'm going to fix this when I do the per-block group extent tree thing.  Thanks,
>
> Will it be capable of "per- subvolume set" extent trees? IOW, a set of
> subvolumes will could share extents only among the members of the same
> group. The usecase is to start an isolate subvolume and allow snapshots
> (and obviously forbid reflinks outside of the group).
>

I suppose.   The problem is the btrfs_header doesn't have much room for verbose 
descriptions of which root owns it.  We have objectid since it was always 
unique, but in the case of per bg extents we can't use that anymore, so we have 
to abuse flags to say this is an extent root block, and then we know that 
btrfs_header_owner(eb) is really the offset of the root and not the objectid. 
Doing something like having it per subvolume would mean having another flag that 
says this block belongs to a subvolume root, and then have the 
btrfs_header_owner(eb) set to the new offset.

The point I'm making is we can do whatever we want here, but it'll be a little 
strange since we have to use flag bits to indicate what type of root the owner 
points to, so any future modifications will also be format changes.  At least 
once I get this work done we'll be able to more easily add new variations on the 
per-whatever setup.  Thanks,

Josef
