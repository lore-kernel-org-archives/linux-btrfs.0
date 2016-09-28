Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:45522 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbcI1Mrd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 08:47:33 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57EBBBE1.8000309@applied-asynchrony.com>
Date: Wed, 28 Sep 2016 14:47:29 +0200
MIME-Version: 1.0
In-Reply-To: <57EBAAF5.10509@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/16 13:35, Wang Xiaoguang wrote:
> hello,
> 
> On 09/28/2016 07:15 PM, Stefan Priebe - Profihost AG wrote:
>> Dear list,
>>
>> is there any chance anybody wants to work with me on the following issue?
> Though I'm also somewhat new to btrfs, but I'd like to.
> 
>>
>> BTRFS: space_info 4 has 18446742286429913088 free, is not full
>> BTRFS: space_info total=98247376896, used=77036814336, pinned=0,
>> reserved=0, may_use=1808490201088, readonly=0
>>
>> i get this nearly every day.
>>
>> Here are some msg collected from today and yesterday from different servers:
>> | BTRFS: space_info 4 has 18446742182612910080 free, is not full |
>> | BTRFS: space_info 4 has 18446742254739439616 free, is not full |
>> | BTRFS: space_info 4 has 18446743980225085440 free, is not full |
>> | BTRFS: space_info 4 has 18446743619906420736 free, is not full |
>> | BTRFS: space_info 4 has 18446743647369576448 free, is not full |
>> | BTRFS: space_info 4 has 18446742286429913088 free, is not full
>>
>> What i tried so far without success:
>> - use vanilla 4.8-rc8 kernel
>> - use latest vanilla 4.4 kernel
>> - use latest 4.4 kernel + patches from holger hoffstaette

Was that 4.4.22? It contains a patch by Goldwyn Rodrigues called
"Prevent qgroup->reserved from going subzero" which should prevent
this from happening. This should only affect filesystems with enabled
quota; you said you didn't have quota enabled, yet some quota-only
patches caused problems on your system (despite being scheduled for
4.9 and apparently working fine everywhere else, even when I
specifically tested them *with* quota enabled).

So, long story short: something doesn't add up.

It means either:
- you tried my patchset for 4.4.21 (i.e. *without* the above patch)
  and should bump to .22 right away
- you _do_ have qgroups enabled for some reason (systemd?)
- your fs is corrupted and needs nuking
- you did something else entirely
- unknown unknowns aka. ¯\_(ツ)_/¯

There is also the chance that your use of compress-force (or rather
compression in general) causes leakage; compression runs asynchronously
and I wouldn't be surprised if that is still full of racy races..which
would be unfortunate, but you could try to disable compression for a
while and see what  happens, assuming the space requirements allow this
experiment.

You have also not told us whether this happens only on one (potentially
corrupted/confused) fs or on every one - my impression was that you have
several sharded backup filesystems/machines; not sure if that is still
the case. If it happens only on one specific fs chances are it's hosed.

> I also met enospc error in 4.8-rc6 when doing big files create and delete tests,
> for my cases, I have written some patches to fix it.
> Would you please apply my patches to have a try:
> btrfs: try to satisfy metadata requests when every flush_space() returns
> btrfs: try to write enough delalloc bytes when reclaiming metadata space
> btrfs: make shrink_delalloc() try harder to reclaim metadata space

These are all in my series for 4.4.22 and seem to work fine, however
Stefan's workload has nothing directly to do with big files; instead
it's the worst case scenario in terms of fragmentation (of huge files) and
a huge number of extents: incremental backups of VMs via rsync --inplace 
with forced compression.

IMHO this way of making backups is suboptimal in basically every possible
way, despite its convenience appeal. With such huge space requirements
it would be more effective to have a "current backup" to rsync into and
then take a snapshot (for fs consistency), pack the snapshot to a tar.gz
(massively better compression than with btrfs), dump them into your Ceph
cluster as objects with expiry (preferrably a separate EC pool) and then
immediately delete the snapshot from the local fs. That should relieve the
landing fs from getting overloaded by COWing and too many snapshots (approx.
#VMs * #versions). The obvious downside is that restoring an archived
snapshot would require some creative efforts.

Other alternatives exist, but are probably even more (too) expensive.

-h

