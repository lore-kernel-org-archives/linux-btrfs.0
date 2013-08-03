Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab3HCAeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 20:34:21 -0400
Message-ID: <51FC5005.20101@redhat.com>
Date: Fri, 02 Aug 2013 19:34:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: remove duplicated code in cmds-restore.c
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com> <1373395794-29140-2-git-send-email-fdmanana@gmail.com> <20130710161255.GD25386@twin.jikos.cz>
In-Reply-To: <20130710161255.GD25386@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/13 11:12 AM, David Sterba wrote:
> On Tue, Jul 09, 2013 at 07:49:53PM +0100, Filipe David Borba Manana wrote:
>> The module cmds-restore.c was defining its own next_leaf()
>> function, which did exactly the same as btrfs_next_leaf()
>> from ctree.c.
> 
> This has been removed by Eric's patch present in the integration
> branches:
>  Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
> http://www.spinics.net/lists/linux-btrfs/msg24477.html
> 
> but now Chris has a fix in the master branch,
>  btrfs-restore: deal with NULL returns from read_node_slot
> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=194aa4a1bd6447bb545286d0bcb0b0be8204d79f

Just noticed this.  :(

Is there some reason that kernelspace should not also get Chris' fix, though?

> the code of updated next_leaf is not identical to btrfs_next_leaf and I
> think 'restore' could be more tolerant to partially corrupted
> structures, so both functions could make sense in the end.

Surely kernelspace should be at least as tolerant as userspace; it
it seems like Chris's BUG_ON removal patch could benefit kernelspace too, no?

And then we could take one more baby step towards a cleaner, non-
cut-and-pasted codebase.

-Eric

