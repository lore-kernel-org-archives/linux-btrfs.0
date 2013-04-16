Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab3DPMdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 08:33:21 -0400
Date: Tue, 16 Apr 2013 14:33:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/17] Btrfs-progs: some receive related patches
Message-ID: <20130416123319.GL18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On Tue, Apr 09, 2013 at 07:08:28PM +0200, Stefan Behrens wrote:
> Alex Lyakas (1):
>   btrfs-progs: Fix the receive code pathing
> 
> Stefan Behrens (16):
>   Btrfs-progs: Use /proc/mounts instead of /etc/mtab
>   Btrfs-progs: ignore subvols above BTRFS_LAST_FREE_OBJECTID
>   Btrfs-progs: close file descriptor in cmds-send.c
>   Btrfs-progs: fix a small memory leak in btrfs-list.c
>   Btrfs-progs: add a function to free subvol_uuid_search memory
>   Btrfs-progs: cleanup subvol_uuid_search memory in btrfs send/receive
>   Btrfs-progs: free memory and close file descriptor in btrfs receive
>   Btrfs-progs: Set the root-id for received subvols in btrfs receive
>   Btrfs-progs: btrfs-receive: different levels (amount) of debug output
>   Btrfs-progs: small parent_subvol cleanup for cmds-receive.c
>   Btrfs-progs: fix bug in find_root_gen
>   Btrfs-progs: btrfs-receive optionally honors the end-cmd
>   Btrfs-progs: don't allocate one byte too much each time
>   Btrfs-progs: Fix that BTRFS_FSID_SIZE is used instead of
>     BTRFS_UUID_SIZE
>   Btrfs-progs: remove some unused code
>   Btrfs-progs: allow to receive to relative directories

All merged, thanks.

david
