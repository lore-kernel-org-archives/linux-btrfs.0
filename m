Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55562 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753639AbaA0So3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:44:29 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52E664E0.5070909@gmail.com>
Date: Mon, 27 Jan 2014 11:44:24 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
References: <52E664E0.5070909@gmail.com>
To: KC <impactoria@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
> 
> 3. If I make a snapshot of / and there are some separate partitions mounted under /mnt/ or /home/, will snapshot skip them?

A snapshot of a subvolume only snapshots that subvolume, not other subvolumes contained in it or other partitions/file systems.


> 
> 4. If I have a snapshot of  /, can I completely erase this partition and later restore it in full form that snapshot, or do snapshots work only if a limited number of files has been changed?
> If the former, then does it mean that snapshot size will be comparable to the original data size?

I'm confused by what you mean by completely erase this partitions and later restore it. What do you mean by partition? Taken literally I'd say no because a snapshot is a subvolume, it's a function of a Btrfs file system, and if you erase the partition you've erased the file system and everything on it.

Otherwise, either the snapshot or its parent subvolume can be deleted at any time. At the moment the snapshot is taken, they are clones, but they behave as completely separate file systems. Any changes to one do not affect the other.

> 5. Can a snapshot be stored on a different partition?

Yes Btrfs send/receive.

> And if so, does that partition have to be BTRFS too?

You can send a snapshot with -f <filename> to a non-Btrfs file system. But it's a file. You can't interact with it, you can only restore it using btrfs receive, to another Btrfs file system.

> I ask, because I would also want to store snapshots in a cloud storage.

Yes although a possible drawback is that I think the resulting snapshot as a file, doesn't contain checksums. So silent data corruption detection isn't possible. Yes you can and should shasum the resulting file but if the sums don't match you don't necessarily know what files are affected.


Chris Murphy

