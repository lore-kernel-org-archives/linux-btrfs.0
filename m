Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:45207 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823AbbIOVrE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 17:47:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 15 Sep 2015 23:47:01 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55F83181.9010201@fb.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
Message-ID: <532aadf0f92d08d3d2b274173548aee1@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-15 16:56, Josef Bacik a écrit :
> On 09/15/2015 10:47 AM, Stéphane Lesimple wrote:
>>> I've been experiencing repetitive "kernel BUG" occurences in the past
>>> few days trying to balance a raid5 filesystem after adding a new 
>>> drive.
>>> It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.
>> 
>> I've ran a scrub on this filesystem after the crash happened twice, 
>> and
>> if found no errors.
>> 
>> The BUG_ON() condition that my filesystem triggers is the following :
>> 
>> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
>> // in insert_inline_extent_backref() of extent-tree.c.
>> 
>> I've compiled a fresh 4.3.0-rc1 with a couple added printk's just 
>> before
>> the BUG_ON(), to dump the parameters passed to
>> insert_inline_extent_backref() when the problem occurs.
>> Here is an excerpt of the resulting dmesg :
>> 
>> {btrfs} in insert_inline_extent_backref, got owner <
>> BTRFS_FIRST_FREE_OBJECTID
>> {btrfs} with bytenr=4557830635520 num_bytes=16384 parent=4558111506432
>> root_objectid=3339 owner=1 offset=0 refs_to_add=1
>> BTRFS_FIRST_FREE_OBJECTID=256
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/extent-tree.c:1837!
>> 
>> I'll retry with the exact same kernel once I get the machine back up,
>> and see if the the bug happens again at the same filesystem spot or a
>> different one.
>> The variable amount of time after a balance start elapsed before I get
>> the bug suggests that this would be a different one.
>> 
> 
> Does btrfsck complain at all?

Thanks for your suggestion.
You're right, even if btrfs scrub didn't complain, btrfsck does :

checking extents
bad metadata [4179166806016, 4179166822400) crossing stripe boundary
bad metadata [4179166871552, 4179166887936) crossing stripe boundary
bad metadata [4179166937088, 4179166953472) crossing stripe boundary
[... some more ...]
extent buffer leak: start 4561066901504 len 16384
extent buffer leak: start 4561078812672 len 16384
extent buffer leak: start 4561078861824 len 16384
[... some more ...]
then some complains about mismatched counts for qgroups.

I can see from tbe btrfsck source code that the --repair will not work 
here, so I didn't try.

I'm not sure if those errors would be a cause or a consequence of the 
bug. As the filesystem was only a few days old and as there was always a 
balance running during the crashes, I would be tempted to think it might 
actually be a consequence, but I can't be sure.
In your experience, could these inconsistencies cause the crash ?

If you think so, then I'll btrfs dev del the 3rd device, then remount 
the array degraded with just 1 disk and create a new btrfs system from 
scratch on the second, then copy the data in single redundancy, then 
re-add the 2 disks and balance convert in raid5.

If you think not, then this array could still help you debug a corner 
case, and I can keep it that way for a couple days if more testing/debug 
is needed.

Thanks,

-- 
Stéphane
