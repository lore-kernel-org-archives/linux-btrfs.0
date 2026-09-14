Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4685E46D09A
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 13:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391098; cv=none; b=LVQPKYp4nVkQWh7A3zXxly2veqt/XRNw8aBx/JH2yvaqi/cQJOd9NMFjZXacJiFqm3GgiWaokOjVVoZvH/J9UASDRnhkem4xNsC0VXQplHVj/EIqDKWWwOVm3hvLqA/6i8xsrH4eUfvbPT1ItrANHkV7m/FByHKNka+cGVA4PAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391098; c=relaxed/simple;
	bh=tdaDxKSLdlauFw7TXVTCOwtRMnNMCjZ3+A0YXCSsOIo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iyrrkoC2EUdaNSxIau/jOxWWTdymIbQP/cUnbEqHIJzvgvG+q3v2rJzDG50UXNFZ9aGnvZCm/dxYBs7AT0IH52Qa3f/So8pFihu8jjcT8gd4khomWgo8FMber5d7gIWJQ/3BMdWlnMY+LqTg3alRp5Ry4naGd2NW06Hp9tN2BGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UxiJrETr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CrwQX/Gm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kQ66hW+E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8Big+1PC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UxiJrETr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CrwQX/Gm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kQ66hW+E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8Big+1PC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C56C51F8AF;
	Mon, 14 Sep 2026 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789391089;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OxZizH6loWZfh774+RtrtVXivrQNnQWCdSnAHPlGpqc=;
	b=UxiJrETroGhlUT7/Ooig8bayKEjSIVa69DEk+4gXiahqFhoN7SB11a6u4wXXq4aRGLwwhn
	GDWsM20+RY6bOr5yUQRC/qNC6ldawr4vW5KL2YT7RUHWrdkEBsOHMcmPwhVHLbwXMetacY
	HPsLGYPcSm1cSgxa31J6TDduSFtdGew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789391089;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OxZizH6loWZfh774+RtrtVXivrQNnQWCdSnAHPlGpqc=;
	b=CrwQX/GmNYw7CIIRGgD64/3yVOwAy5Ew6mM25IeDNPuFZH710zvSYD+/KBgVx4ZQJOaGuQ
	lRWCphBJEtJ3I4Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789391085;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OxZizH6loWZfh774+RtrtVXivrQNnQWCdSnAHPlGpqc=;
	b=kQ66hW+EtfAgPNTWe+TqBAC4fBQoUAqvIJ0oypMVnGbdhpBAowVEmjnjvxCuoFuLmB24P2
	PbRwhDwWRzi5wWI5ne0T75FpDRc1jOHpTFh3MJKoXa6tuGI64xy4wBb5vseD9rao1kRCFt
	ZvgROrGpOuTQUTqNIj96ukLdy05fZgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789391085;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OxZizH6loWZfh774+RtrtVXivrQNnQWCdSnAHPlGpqc=;
	b=8Big+1PCWgdg4gPE0G0p6RCjNgnFFk6LH0MYo+e0TEsY/IjUogRF9e2wg45LsqPYiqBktJ
	niw85nMWgZE4AQCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A44B13693;
	Mon, 14 Sep 2026 13:04:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VYd3Je3wp2qvRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 13:04:45 +0000
Date: Mon, 14 Sep 2026 15:04:36 +0200
From: David Sterba <dsterba@suse.cz>
To: tz2294@columbia.edu
Cc: linux-btrfs@vger.kernel.org
Subject: [sashiko-bot@kernel.org: Re: [PATCH v2 02/16] btrfs: remove the v1
 space cache writeout from the transaction commit]
Message-ID: <20260914130436.GG54722@suse.cz>
Reply-To: dsterba@suse.cz
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid,sashiko.dev:url];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

Previous verions o the space cache removal had no sashiko comments but
I've seen some reorganization of the patch review flow in their git so
it's possible that the problem reported here could have been there.

The review comment sounds serious by my quick look, regarding a mutex
and block group management, all after the v1 removal.

Link: https://sashiko.dev/#/patchset/20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu?part=2

----- Forwarded message from sashiko-bot@kernel.org -----

> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ee182369254c0..a04dd8244c814 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1194,36 +1194,15 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  		goto out;
>  	}
>  
> -	/*
> -	 * get the inode first so any iput calls done for the io_list
> -	 * aren't the final iput (no unlinks allowed now)
> -	 */
>  	inode = lookup_free_space_inode(block_group, path);
>  
> -	mutex_lock(&trans->transaction->cache_write_mutex);
> -	/*
> -	 * Make sure our free space cache IO is done before removing the
> -	 * free space inode
> -	 */
>  	spin_lock(&trans->transaction->dirty_bgs_lock);

[ ... ]

>  	if (!list_empty(&block_group->dirty_list)) {
>  		list_del_init(&block_group->dirty_list);
>  		remove_rsv = true;
>  		btrfs_put_block_group(block_group);
>  	}
>  	spin_unlock(&trans->transaction->dirty_bgs_lock);
> -	mutex_unlock(&trans->transaction->cache_write_mutex);
>  
>  	ret = btrfs_remove_free_space_inode(trans, inode, block_group);

[Severity: Critical]
Does the removal of cache_write_mutex expose a TOCTOU race condition between
btrfs_remove_block_group() and btrfs_start_dirty_block_groups()?

If btrfs_start_dirty_block_groups() has already popped the block group off
the dirty list, this check will pass and btrfs_remove_block_group() will
skip removing it from the list and proceed to delete the block group item
from the extent tree.

[ ... ]

> @@ -3608,34 +3394,13 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
>  		}
>  	}
>  
> -	/*
> -	 * cache_write_mutex is here only to save us from balance or automatic
> -	 * removal of empty block groups deleting this block group while we are
> -	 * writing out the cache
> -	 */
> -	mutex_lock(&trans->transaction->cache_write_mutex);
>  	while (!list_empty(&dirty)) {

[ ... ]

>  		/*
>  		 * Since we're not running in the commit critical section
>  		 * we need the dirty_bgs_lock to protect from update_block_group
>  		 */
>  		spin_lock(&cur_trans->dirty_bgs_lock);
>  		list_del_init(&cache->dirty_list);
>  		spin_unlock(&cur_trans->dirty_bgs_lock);
>  
> +		ret = update_block_group_item(trans, path, cache);

[Severity: Critical]
Without cache_write_mutex, is there any synchronization preventing
btrfs_remove_block_group() from deleting the block group item while this code
is executing? The dirty list lock was dropped just before calling
update_block_group_item(), exposing it to concurrent removal.

> +		/*
> +		 * Our block group might still be attached to the list of new
> +		 * block groups in the transaction handle of some other task
> +		 * (struct btrfs_trans_handle->new_bgs). This means its block
> +		 * group item isn't yet in the extent tree. If this happens
> +		 * ignore the error, as we will try again later in the critical
> +		 * section of the transaction commit.
> +		 */
> +		if (ret == -ENOENT) {
> +			ret = 0;
> +			spin_lock(&cur_trans->dirty_bgs_lock);
> +			if (list_empty(&cache->dirty_list)) {
> +				list_add_tail(&cache->dirty_list,
> +					      &cur_trans->dirty_bgs);

[Severity: Critical]
If a concurrent removal caused the -ENOENT, will this code misinterpret the
error as a pending new block group? It appears the deleted block group is
erroneously re-added to the dirty list to be processed during the commit
critical section.

[ ... ]

> @@ -3747,121 +3475,34 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
>  	struct btrfs_block_group *cache;
>  	struct btrfs_transaction *cur_trans = trans->transaction;

[ ... ]

>  	spin_lock(&cur_trans->dirty_bgs_lock);
>  	while (!list_empty(&cur_trans->dirty_bgs)) {
>  		cache = list_first_entry(&cur_trans->dirty_bgs,
>  					 struct btrfs_block_group,
>  					 dirty_list);
>  		list_del_init(&cache->dirty_list);
>  		spin_unlock(&cur_trans->dirty_bgs_lock);
>  
>  		if (!ret)
>  			ret = btrfs_run_delayed_refs(trans, U64_MAX);
>  		if (!ret) {
>  			ret = update_block_group_item(trans, path, cache);
> +			if (ret)
>  				btrfs_abort_transaction(trans, ret);
>  		}

[Severity: Critical]
Since the wait/retry logic for -ENOENT was also removed by this patch, will
the erroneously re-added block group fail again with -ENOENT here and trigger
a transaction abort, crashing the filesystem?

-- 
Sashiko AI review · https://sashiko.dev/#/patchset/20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu?part=2

----- End forwarded message -----
