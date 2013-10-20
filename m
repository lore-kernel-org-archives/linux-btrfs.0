Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49764 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3JTMUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 08:20:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3D5DB7C0653
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Oct 2013 06:20:07 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1377901546-22434-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>, Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
References: <1377901546-22434-1-git-send-email-dsterba@suse.cz>
Message-ID: <20131020121959.4917.92120@localhost.localdomain>
Subject: Re: [PATCH] btrfs: commit transaction after deleting a subvolume
Date: Sun, 20 Oct 2013 08:19:59 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-08-30 18:25:46)
> Alex pointed out the consequences after a transaction is not committed
> when a subvolume is deleted, so in case of a crash before an actual
> commit happens will let the subvolume reappear.
> 
> Original post:
> http://www.spinics.net/lists/linux-btrfs/msg22088.html
> 
> Josef's objections:
> http://www.spinics.net/lists/linux-btrfs/msg22256.html
> 
> While there's no need to do a full commit for regular files, a subvolume
> may get a different treatment.
> 
> http://www.spinics.net/lists/linux-btrfs/msg23087.html:
> 
> "That a subvol/snapshot may appear after crash if transation commit did
> not happen does not feel so good. We know that the subvol is only
> scheduled for deletion and needs to be processed by cleaner.
> 
> From that point I'd rather see the commit to happen to avoid any
> unexpected surprises.  A subvolume that re-appears still holds the data
> references and consumes space although the user does not assume that.
> 
> Automated snapshotting and deleting needs some guarantees about the
> behaviour and what to do after a crash. So now it has to process the
> backlog of previously deleted snapshots and verify that they're not
> there, compared to "deleted -> will never appear, can forget about it".
> "

My objections are pretty similar to Josef's.  But, there's no reason we
can't change the progs to optionally trigger a commit.

What I want to avoid is bulk snapshot deletion triggering a commit for
each individual snapshot.  

-chris
