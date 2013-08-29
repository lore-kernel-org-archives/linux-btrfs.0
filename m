Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3H2QLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 12:11:55 -0400
Message-ID: <521F72C6.3040600@redhat.com>
Date: Thu, 29 Aug 2013 11:11:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 0/2] btrfs-progs: prevent mkfs from aborting with small
 volume
References: <52170114.7060604@jp.fujitsu.com> <521B64EA.2080106@redhat.com> <521D842D.6020100@jp.fujitsu.com>
In-Reply-To: <521D842D.6020100@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/28/13 12:01 AM, Hidetoshi Seto wrote:
> (2013/08/26 23:23), Eric Sandeen wrote:
>> Thanks for looking into this - how small of a device did you test?
>>
>> I tried a 2MB device w/ these 2 patches and still got:
>>
>> [btrfs-progs]# truncate --size=2m testfile
>> [btrfs-progs]# ./mkfs.btrfs testfile
>>
>> WARNING! - Btrfs v0.20-rc1-360-geeeb4e9 IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> SMALL VOLUME: forcing mixed metadata/data groups
>> mkfs.btrfs: volumes.c:857: btrfs_alloc_chunk: Assertion `!(ret)' failed.
>> Aborted (core dumped)
>>
>> which was at:
>>
>>                 ret = btrfs_alloc_dev_extent(trans, device,
>>                              info->chunk_root->root_key.objectid,
>>                              BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
>>                              calc_size, &dev_offset);
>>                 BUG_ON(ret);
>>
>> :(
> 
> Wow...
> It seems that this abort is different problem from the bug which
> my patches are going to fix.  I'll try to make new patch to fix this
> problem.
> 
>>
>> Also, I'm curious - I know the code existed before your patch 2/2,
>> but I don't understand why it reserves 1MB for the first superblock 
>> when the first superblock is actually at 64k.  Any idea?
>>
>> -Eric
> 
> I'm not sure... According to the git-log, this 1M trick is in 
> the following old commit by Chris:
> 
>   commit a6de0bd778475504f42a142c83b8077993cbddfe
>   Author: Chris Mason <chris.mason@oracle.com>
>   Date:   Thu Apr 3 16:35:48 2008 -0400
> 
>      Add mirroring support across multiple drives

Yep I saw that too.  Seemingly unrelated.  :(  Unless I'm missing
something (which I probably am).

-Eric

> 
> Thanks,
> H.Seto
> 

