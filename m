Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43929 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3I2Amz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 20:42:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6F1329A0697
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 18:42:55 -0600 (MDT)
Date: Sat, 28 Sep 2013 20:42:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Aastha Mehta <aasthakm@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions regarding logging upon fsync in btrfs
Message-ID: <20130929004252.GL18681@localhost.localdomain>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 29, 2013 at 01:35:15AM +0200, Aastha Mehta wrote:
> Hi,
> 
> I have few questions regarding logging triggered by calling fsync in BTRFS:
> 
> 1. If I understand correctly, fsync will call to log entire inode in
> the log tree. Does this mean that the data extents are also logged
> into the log tree? Are they copied into the log tree, or just
> referenced? Are they copied into the subvolume's extent tree again
> upon replay?
> 

The data extents are copied as well, as in the metadata that points to the data,
not the actual data itself.  For 3.1 it's all of the extents in the inode, in
3.8 on it's only the extents that have changed this transaction.

> 2. During replay, when the extents are added into the extent
> allocation tree, do they acquire the physical extent number during
> replay? Does they physical extent allocated to the data in the log
> tree differ from that in the subvolume?
> 

No the physical location was picked when we wrote the data out during fsync.  If
we crash and re-mount the replay will just insert the ref into the extent tree
for the disk offset as it replays the extents.

> 3. I see there is a mount option of notreelog available. After
> disabling tree logging, does fsync still lead to flushing of buffers
> to the disk directly?
> 

notreelog just means that we write the data and wait on the ordered data extents
and then commit the transaction.  So you get the data for the inode you are
fsycning and all of the metadata for the entire file system that has changed in
that transaction.

> 4. Is it possible to selectively identify certain files in the log
> tree and flush them to disk directly, without waiting for the replay
> to do it?
> 

I don't understand this question, replay only happens on mount after a
crash/power loss, and everything is replayed that is in the log, there is no way
to select which inode is replayed.  Thanks,

Josef
