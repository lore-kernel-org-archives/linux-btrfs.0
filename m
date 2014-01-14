Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaANQry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 11:47:54 -0500
Date: Tue, 14 Jan 2014 17:47:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs-progs: btrfsck operations should be exclusive
Message-ID: <20140114164753.GZ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389618895-24460-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389618895-24460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 09:14:55PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> this patch will make btrfsck operations to open disk in exclusive mode,
> so that mount will fail when btrfsck is running

Makes sense, especially if fsck is in the repair mode, mounting such fs
would be bad.

> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -32,6 +32,7 @@ enum btrfs_open_ctree_flags {
>  	OPEN_CTREE_RECOVER_SUPER	= 8,
>  	OPEN_CTREE_RESTORE		= 16,
>  	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
> +	OPEN_CTREE_O_EXCL		= 64,

I'd rather pick a more descriptive name, matching to the others, eg.
OPEN_CTREE_EXCLUSIVE, which would translate to the O_EXCL open mode.

As you've implemented it, the exclusive mode applies to both read-only
and write/repair modes, which is imho right and should prevent
accidental errors, ie. a safe default.


david
