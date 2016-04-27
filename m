Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41312 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbcD0PMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 11:12:34 -0400
Subject: Re: [PATCH V18 01/18] Btrfs: subpage-blocksize: Fix whole page read.
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1461677237-7703-2-git-send-email-chandan@linux.vnet.ibm.com>
 <63a690f0-20c4-f816-d9ff-0550306a97a1@fb.com>
 <2431208.c5R5KJEcxa@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <clm@fb.com>,
        <chandan@mykolab.com>, Filipe Manana <fdmanana@gmail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6f130dd2-a59a-bd46-ca37-16ab28b8955d@fb.com>
Date: Wed, 27 Apr 2016 11:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <2431208.c5R5KJEcxa@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2016 01:24 AM, Chandan Rajendra wrote:
> On Tuesday 26 Apr 2016 11:51:22 Josef Bacik wrote:
>>> +int set_page_extent_mapped(struct page *page)
>>>
>>>  {
>>>
>>> +	struct btrfs_page_private *pg_private;
>>> +
>>>
>>>  	if (!PagePrivate(page)) {
>>>
>>> +		pg_private = kzalloc(sizeof(*pg_private), GFP_NOFS);
>>> +		if (!pg_private)
>>> +			return -ENOMEM;
>>
>> So I would like to avoid the per-page allocation in the case that
>> sectorsize == pagesize.  Also this is going to be pretty heavily used,
>> so a separate slab should be used.
>
> Ok. I will revise this patch and other dependent patches to determine the
> block states (dirty, uptodate, etc) from either page flags (for sectorsize ==
> pagesize) or from the per-page bitmap (for sectorsize < pagesize).
>
>>
>> In fact, couldn't we just use the extent io tree to deal with this?  It
>> would be kind of heavy handed to have to look up in the io tree for
>> every sub page range I suppose, but we could probably avoid doing it in
>> most cases and only in the case that we know we're only doing the sub
>> page IO.  Thanks,
>>
>
> Commit 1edbb734b4e010974c41d2859d22a43d04f5f1cf (Btrfs: reduce CPU usage in
> the extent_state tree) dropped support for tracking block states using extent
> io tree citing performance reasons. The initial versions of subpage-blocksize
> patchset did bring back this feature. However during Btrfs BoF meetup during
> 2015 Vault conference, we decided to go with the per-page bitmap to track the
> block states.

Lol ok carry on then.  Thanks,

Josef

