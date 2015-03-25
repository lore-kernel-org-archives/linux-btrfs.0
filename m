Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33309 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbCYKzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 06:55:52 -0400
Received: by wgbcc7 with SMTP id cc7so22707594wgb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 03:55:51 -0700 (PDT)
Message-ID: <55129428.7090508@gmail.com>
Date: Wed, 25 Mar 2015 11:55:36 +0100
From: Marc Cousin <cousinmarc@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
References: <550E7917.5030602@gmail.com> <20150325011937.GB20767@twin.jikos.cz>
In-Reply-To: <20150325011937.GB20767@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/03/2015 02:19, David Sterba wrote:
> 
> The snapshots get cleaned in the background, which usuall touches lots
> of data (depending on the "age" of the extents, IOW the level of sharing
> among the live and deleted snapshots).
> 
> The slowdown is caused due to contention on the metadata (locking,
> readig from disk, scattered blocks, lots of seeking).
> 
> Snapper might add to that if you have
> 
> EMPTY_PRE_POST_CLEANUP="yes"
> 
> as it reads the pre/post snapshots and deletes them if the diff is
> empty. This adds some IO stress.

I couldn't find a clear explanation in the documentation. Does it mean
that when there is absolutely no difference between two snapshots, one
of them is deleted ? And that snapper does a diff between them to
determine that ?

If so, yes, I can remove it, I don't care about that :)

> 
>> The btrfs cleaner is 100% active:
>>
>>  1501 root      20   0       0      0      0 R 100,0  0,0   9:10.40 [btrfs-cleaner]    
> 
> That points to the snapshot cleaning, but the cleaner thread does more
> than that. It may also process delayed file deletion and work scheduled
> if 'autodefrag' is on.

autodefrag is activated. These are mechanical drives, so I'd rather keep
it on, shouldn't I ?

> 
>> What is "funny" is that the filesystem seems to be working again when
>> there is some IO activity and btrfs-cleaner gets to a lower cpu usage
>> (around 70%).
> 
> Possibly a behaviour caused by scheduling (both cpu and io), the other
> process gets a slice and slows down cleaner that hogs the system.

I have almost no IO on these disks during the problem (I had put an
iostat on the first email). Only one CPU core at 100% load. That's why I
felt it looked more like a locking or serialization issue.

> 
>> By the way, there are quite a few snapshots there:
>>
>> # btrfs subvolume  list /mnt/btrfs | wc -l
>> 142
>>
>> and I think snapper tries to destroy around 10 of them on one go.
> 
> The snapshots get cleaned in the order of deletion, and if there is some
> amount of sharing, the metadata blocks are probably cached. So it may
> actually help to delete them in a group.

There is a lot of sharing between the snapshots. Only a few files are
altered between them. I think I only have the slowdown while the kernel
thread is at 100%. When it is lower (and I have disk activity), I have a
slight slowdown, but it is completely bearable.

> 
>> I can do whatever test you want, as long as I keep the data on my disks :)
> 
> So far it looks like effects of filesystem aging in the presence of
> snapshots. Right now, I think we could try to somehow adjust the io
> scheduling priority in case the cleaner processes the deleted
> subvolumes, but this is unfortunatelly done in an asynchronous manner
> and the metadata are read by other threads so this could be fairly
> intrusive patch.
I have almost no IO when the problem occurs.


Regards
