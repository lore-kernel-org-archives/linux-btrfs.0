Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:52525 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbeGaRom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 13:44:42 -0400
Received: by mail-it0-f66.google.com with SMTP id d9-v6so5226839itf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 09:03:43 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <80e77411-2905-46a9-a5b1-fbbbb824dbf5@gmail.com>
Date: Tue, 31 Jul 2018 12:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-31 10:32, Qu Wenruo wrote:
> 
> 
> On 2018年07月31日 21:49, Thomas Leister wrote:
>> Dear David,
>> hello everyone,
>>
>> during a recent project of mine involving LXD and BTRFS I found out that
>> quotas on BTRFS subvolumes are enforced, but file system usage and
>> limits set via quotas are not reported correctly in LXC containers.
>>
>> I've found this discussion regarding my problem:
>> https://github.com/lxc/lxd/issues/2180
> 
> That's not the expected usage of btrfs qgroup/quota.
> 
> Quota only accounts how many bytes are used exclusively or shared
> between subvolumes at extent level.
> 
>>
>> There was already a proposal to introduce subvolume quota support some
>> time ago:
>> https://marc.info/?l=linux-btrfs&m=147576434114415&w=2
> 
> It's in fact impossible if I didn't miss something.
> 
> There are several technical problems in the proposal:
> 
> 1) Multi-level qgroups
>     The real limit is limited by all related qgroups, including higher
>     level qgroup.
>     Such design makes it pretty hard to calculation the real limit.
> 
> 2) Different limitations on exclusive/shared bytes
>     Btrfs can set different limit on exclusive/shared bytes, further
>     complicating the problem.
> 
> 3) Btrfs quota only accounts data/metadata used by the subvolume
>     It lacks all the shared trees (mentioned below), and in fact such
>     shared tree can be pretty large (especially for extent tree and csum
>     tree).
>     Only accounting quota limit would hit real ENOSPC easily IMHO.
> 
>>
>> @David as I've seen your response on that topic on the mailing list,
>> maybe you can tell me if there are any plans to support correct
>> subvolume quota reporting e.g. for "df -h" calls from within a
>> container? Maybe there's already something on your / SUSE's roadmap? :-)
>>
>> As more and more container environments spin up these days, there might
>> be a growing demand on that :-) Personally I'd really appreciate if I
>> could read the current file system usage and limit from within a
>> container using BTRFS as storage backend.
> 
> For current btrfs design, I think it's skeptical to implement such design.
> The main problem here is, btrfs doesn't do the full LVM work. (unlike
> ZFS IIRC)
> It doesn't really manage multiple volumes, that's why it's called
> subvolume in btrfs.
ZFS quotas work the way they do not because it's trivial to implement 
them that way due to the underlying implementation, but because they 
provide the functionality that people actually want.  Being able to put 
proper hard limits on space usage for a given volume/subvolume/dataset 
is _critical_ for a large number of enterprise deployment scenarios. 
Same goes for being able to put a fixed space reservation for a given 
volume/subvolume/dataset.  If we want to even remotely compete (and it 
sure seems like we do), we need equivalent features that work 
intuitively for _regular_ people (not those who have intimate 
understandings of the internal workings of BTRFS).

> A subvolume is not a fully usable fs, it's just a subset of a full fs.
> It relies on all the other trees (root tree, extent tree, chunk tree,
> csum tree, and quota tree in this case) to do all the work.
A ZFS dataset isn't a fully usable FS either.  It's still dependent on 
all the underlying infrastructure from the zpool itself (and so are 
zvols), which, in fact, does a vast majority of the work.  The 
difference here is that a ZFS dataset is far more self-contained than a 
BTRFS subvolume.  If we ever want sane per-subvolume storage profiles or 
mount options, we're going to need to get a lot closer to that anyway.

> Thus it's pretty hard to implement such special purposed df call.
To implement it perfectly maybe.  Except most applications don't need it 
to be perfect, they want to know how much space they can actually use. 
Even a trivial blatantly imperfect implementation that just shows you 
the total space that can be used and how much is used based on quotas 
will give better behavior that the current case of just hiding the 
quotas behind a root-only call.  Pretty much anything which does it's 
own disk usage management is currently broken on BTRFS when quotas are 
being used.  Just reporting the quota for the total space, and the space 
accounted to the subvolume by the quota would fix almost all such 
applications.
> 
> On the other hand, isn't easier to implement special interface for
> container to get real disk usage/limit other than using the old vanilla
> df interface?
This isn't just an issue for containers.  Anybody who is using quotas 
like they are typically used in ZFS deployments has the same issue, and 
there _ARE_ people doing that (see for example OpenSUSE, where they are 
using quotas (if they are enabled because of snapshot support) to limit 
space consumption of paths like /tmp).
