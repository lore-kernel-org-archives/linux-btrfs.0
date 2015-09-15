Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56907 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbbIOO4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 10:56:07 -0400
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
        <linux-btrfs@vger.kernel.org>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F83181.9010201@fb.com>
Date: Tue, 15 Sep 2015 10:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <2c00c4b7c15e424659fb2e810170e32e@all.all>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2015 10:47 AM, Stéphane Lesimple wrote:
>> I've been experiencing repetitive "kernel BUG" occurences in the past
>> few days trying to balance a raid5 filesystem after adding a new drive.
>> It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.
>
> I've ran a scrub on this filesystem after the crash happened twice, and
> if found no errors.
>
> The BUG_ON() condition that my filesystem triggers is the following :
>
> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
> // in insert_inline_extent_backref() of extent-tree.c.
>
> I've compiled a fresh 4.3.0-rc1 with a couple added printk's just before
> the BUG_ON(), to dump the parameters passed to
> insert_inline_extent_backref() when the problem occurs.
> Here is an excerpt of the resulting dmesg :
>
> {btrfs} in insert_inline_extent_backref, got owner <
> BTRFS_FIRST_FREE_OBJECTID
> {btrfs} with bytenr=4557830635520 num_bytes=16384 parent=4558111506432
> root_objectid=3339 owner=1 offset=0 refs_to_add=1
> BTRFS_FIRST_FREE_OBJECTID=256
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent-tree.c:1837!
>
> I'll retry with the exact same kernel once I get the machine back up,
> and see if the the bug happens again at the same filesystem spot or a
> different one.
> The variable amount of time after a balance start elapsed before I get
> the bug suggests that this would be a different one.
>

Does btrfsck complain at all?  Thanks,

Josef
