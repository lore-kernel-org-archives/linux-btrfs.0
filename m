Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:53771 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753612AbbIOOrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 10:47:06 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id 6B0C9391
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 16:47:00 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 15 Sep 2015 16:47:00 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
Message-ID: <2c00c4b7c15e424659fb2e810170e32e@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I've been experiencing repetitive "kernel BUG" occurences in the past
> few days trying to balance a raid5 filesystem after adding a new drive.
> It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.

I've ran a scrub on this filesystem after the crash happened twice, and 
if found no errors.

The BUG_ON() condition that my filesystem triggers is the following :

BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
// in insert_inline_extent_backref() of extent-tree.c.

I've compiled a fresh 4.3.0-rc1 with a couple added printk's just before 
the BUG_ON(), to dump the parameters passed to 
insert_inline_extent_backref() when the problem occurs.
Here is an excerpt of the resulting dmesg :

{btrfs} in insert_inline_extent_backref, got owner < 
BTRFS_FIRST_FREE_OBJECTID
{btrfs} with bytenr=4557830635520 num_bytes=16384 parent=4558111506432 
root_objectid=3339 owner=1 offset=0 refs_to_add=1 
BTRFS_FIRST_FREE_OBJECTID=256
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1837!

I'll retry with the exact same kernel once I get the machine back up, 
and see if the the bug happens again at the same filesystem spot or a 
different one.
The variable amount of time after a balance start elapsed before I get 
the bug suggests that this would be a different one.

-- 
Stéphane.
