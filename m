Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52185 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbcGPANn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 20:13:43 -0400
Date: Sat, 16 Jul 2016 02:13:36 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Eric Wheeler <btrfs@lists.ewheeler.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How can I get blockdev offsets of btrfs chunks for a file?
Message-ID: <20160716001336.GA10651@angband.pl>
References: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 04:21:31PM -0700, Eric Wheeler wrote:
> We do btrfs subvolume snapshots over time for backups.  I would like to 
> traverse the files in the subvolumes and find the total unique chunk count 
> to calculate total space for a set of subvolumes.
> 
> This sounds kind of like the beginning of what a deduplicator would do, 
> but I just want to count the blocks, so no submission for deduplication.  
> I started looking at bedup and other deduplicator code, but the answer to 
> this question wasn't obvious (to me, anyway).
> 
> Questions:
> 
> Is there an ioctl (or some other way) to get the block device offset for a 
> file (or file offset) so I can count the unique occurances?

Yes, FIEMAP.

You can play with it via "/usr/sbin/filefrag -v".  That /usr/sbin is
misleading -- FIEMAP doesn't require root, although its predecessor did need
that, https://bugs.debian.org/819923

> What API documentation should I review?

In kernel sources, Documentation/filesystems/fiemap.txt


Meow!
-- 
An imaginary friend squared is a real enemy.
