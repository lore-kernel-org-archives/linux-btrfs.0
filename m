Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaHSRSo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 13:18:44 -0400
Date: Tue, 19 Aug 2014 19:18:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum
 mismatches even generation is less than 10.
Message-ID: <20140819171842.GC1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com>
 <53E2E9A3.6060206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E2E9A3.6060206@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 07, 2014 at 10:51:15AM +0800, Qu Wenruo wrote:
> It seems that the patch is rejected in patchwork,

It was not me :)

> Could any one tell me the reason?

I'd understand that the patch is no longer needed after the original
problem went away, but it's not what you describe in your changelog.
>From that point the reason might not be compelling.

> >Above commit will cause disaster if someone try to mount a newly created but
> >later corrupted btrfs filesystem.

The generation after mkfs is something like 4 or 5, this means that the
corruption would have to happen in the first few transaction commits,
this is unlikely and the filesystem will be probably fairly empty at
that time.

If the concern is about corrupted generation counter itself in the
superblock, then yes this could hurt.

It's still possible to compare the 1st superblock with the copies, the
one at offset 64M is available in 99%, there are enough data to make a
decision what's actually corrupted. This could catch more corruption
than just the generation counter.

>From the output of btrfs-show-super:

generation              56392
chunk_root_generation   56392
cache_generation        56392
uuid_tree_generation    56392

the generation is duplicated several times, so a minimal patch could be
to do additional comparison with the others.

> >And before btrfs entered mainline, btrfs-progs has already superblock
> >checksum. See btrfs-progs commit: 5ccd1715fa2eaad0b26037bb53706779c8c93b5f
> >(superblock duplication by Yan Zheng).

The superblock checksum was not calculated the same way as in kernel,
but with the missing check this was not detected.

> >Before commit 5ccd17, mkfs.btrfs uses 16K as super offset, while current btrfs
> >uses 64K super offset, anyway old btrfs without super csum will not be
> >mountable due to the change of super offset.
> >
> >So backward compatibility is not a problem.

Superblocks at offset 16k are not supported anymore AFAICT.
