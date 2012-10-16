Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2JPULg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 16:11:36 -0400
Date: Tue, 16 Oct 2012 13:11:34 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        alex.btrfs@zadarastorage.com
Subject: Re: [PATCH v2] Btrfs: extended inode refs support for send
	mechanism
Message-ID: <20121016201134.GZ8097@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1350289845-18604-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1350289845-18604-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 15, 2012 at 10:30:45AM +0200, Jan Schmidt wrote:
> This adds support for the new extended inode refs to btrfs send.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/backref.c |   22 ++++-----
>  fs/btrfs/backref.h |    4 ++
>  fs/btrfs/send.c    |  126 +++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 94 insertions(+), 58 deletions(-)
> ---
> Changes for v2:
> - Re-understood how btrfs_search_slot_for_read works (3 places, reported
>   by Alex Lyakas)
> - Fixed extref handling in get_first_ref (reported by Mark Fasheh)

Looks good to my eyes.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
