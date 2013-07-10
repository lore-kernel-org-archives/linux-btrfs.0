Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3GJQM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 12:12:57 -0400
Date: Wed, 10 Jul 2013 18:12:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs-progs: remove duplicated code in cmds-restore.c
Message-ID: <20130710161255.GD25386@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
 <1373395794-29140-2-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373395794-29140-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 09, 2013 at 07:49:53PM +0100, Filipe David Borba Manana wrote:
> The module cmds-restore.c was defining its own next_leaf()
> function, which did exactly the same as btrfs_next_leaf()
> from ctree.c.

This has been removed by Eric's patch present in the integration
branches:
 Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
http://www.spinics.net/lists/linux-btrfs/msg24477.html

but now Chris has a fix in the master branch,
 btrfs-restore: deal with NULL returns from read_node_slot
https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=194aa4a1bd6447bb545286d0bcb0b0be8204d79f

the code of updated next_leaf is not identical to btrfs_next_leaf and I
think 'restore' could be more tolerant to partially corrupted
structures, so both functions could make sense in the end.

david
