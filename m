Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21233 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbbK3GM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 01:12:59 -0500
Subject: Re: potential btrfs-progs clean up
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <565BE23C.3010400@oracle.com>
CC: <dsterba@suse.cz>, <calestyo@scientia.net>, <ahferroin7@gmail.com>,
        <1i5t5.duncan@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565BE8D9.3000708@cn.fujitsu.com>
Date: Mon, 30 Nov 2015 14:12:41 +0800
MIME-Version: 1.0
In-Reply-To: <565BE23C.3010400@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/11/30 13:44 +0800:
>
>
> (this is a different topic, updated the subject)
>
>> Totally agree with this point. Too many non-sense in btrfs-progs codes
>> copied from kernel, and due to lack of update, it's very buggy now.
>> Just check volume.c for allocating data chunk.
>
>    Which functions in volume.c in particular ?

btrfs_alloc_chunk().

1) Fixed SINGLE DATA chunk size
The point is very easy, for SINGLE and DATA chunk, its size is always 
fixed to 8M. (below minimal data chunk size already)
Normally it's OK, but not the normal 10% of filesystem.

The bug is hidden by the complicated PROFILE if sentences.

2) Not that clear chunk size limitation.
And the logical of btrfs_alloc_chunk() is not that clear to for the 
minimal *stripe* size(which is physical) and minimal *chunk* size(which 
is logical).

Not a real problem yet.

3) Duplicated chunk allocation functions
Btrfs_alloc_chunk(), btrfs_alloc_data_chunk().

But don't cleanup the latter one yet, as btrfs-convert rework still 
needs it to avoid some chunk allocation check.

Thanks,
Qu


>
> Thanks, Anand
>
>


