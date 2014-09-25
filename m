Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbaIYQav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 12:30:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EE833AD51
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 16:30:49 +0000 (UTC)
Date: Thu, 25 Sep 2014 18:30:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v10] Btrfs: be aware of btree inode write errors to
 avoid fs corruption
Message-ID: <20140925163049.GE9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411404065-767-2-git-send-email-fdmanana@suse.com>
 <1411663905-25543-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411663905-25543-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 25, 2014 at 05:51:45PM +0100, Filipe Manana wrote:
> +	switch (eb->log_index) {
> +	case -1:
> +		set_bit(BTRFS_INODE_BTREE_ERR, &btree_ino->runtime_flags);
> +		break;
> +	case 0:
> +		set_bit(BTRFS_INODE_BTREE_LOG1_ERR, &btree_ino->runtime_flags);
> +		break;
> +	case 1:
> +		set_bit(BTRFS_INODE_BTREE_LOG2_ERR, &btree_ino->runtime_flags);
> +		break;
> +	default:
> +		ASSERT(0); /* unexpected, logic error */

I think we can afford a BUG() here, preceded by a message. The logic is
pretty strict about the possible values so if we get here, something is
really bad and we don't want to make it silent.

This could happen if the memory modules are faulty and tripping over
random BUG_ONs is usually a sign of problems. I've seen that in the
past with certain CPU types during stresstests and it definetely was
worth knowing. (The BUG_ONs were in memory management, it's not a crime
to use them, only in place of proper error hanling.)

> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -141,7 +142,9 @@ struct extent_buffer {
>  	atomic_t blocking_readers;
>  	atomic_t spinning_readers;
>  	atomic_t spinning_writers;
> -	int lock_nested;
> +	unsigned int lock_nested:1;

Please do not use bitfields next to atomic_t or spin_lock (or kref_t),
this can lead to all sorts of funny problems on architectures that are
not able to do atomic bit operations and have to do read-modify-write
cycle. This leads to problems when it's on the same 8-byte word with an
atomic/... and can corrupt it if the timing is right.
