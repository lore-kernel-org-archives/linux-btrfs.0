Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303A33F8886
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787591510; cv=none; b=dbzwEP0nDl8RomJZPQ0QGTSVShAvF8DmEmLRA7tQjGr7nLgjRd+yPl9rD8W46Tt1dLqTEHzNmooAGDuC843AV1LSxisA75c3vHmoZ/7tcVt/qoSzs2LrVXYKzxj6bJ4XgsGONZEGOV6rE7Hzxjz0KMX3mptNPFr4eN1z7Z4r3OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787591510; c=relaxed/simple;
	bh=dp0a81LFMMhoi6z7314F4kOu+8cVW0NavoIzj6h6Yfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=An8Knc/VjYUd1i5IfAGYIZYTIheJejUgx2VFpx2n2gWkvfff8z8n+xrV71D75qGKxRByYr8oYg2LGvlk37egXwFIdAH8R/KqYQkGi3asPTP8zK0Stu6djYw/cuamHilwGXXySRhfeVd32DgySQl6MkPpJhPny/tScmOtVsfP9Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YP6gqjir; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=E4GuunWk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ibxXsjK3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ApS6mJbV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YP6gqjir";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="E4GuunWk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ibxXsjK3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ApS6mJbV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6A51866C5;
	Mon, 24 Aug 2026 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787591502;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iua8vWm/691bFhi6aCw/FzNX4elJ0SUnv+L6rqVGR7A=;
	b=YP6gqjirVm169VSNLYmybdR95j720ec19CnyVNAhW1iUQvGEG1KoF54/LM5yV7w6WftibU
	e/7/G4ZxD4slDAtYAPhQnCNJZs4N0/9on1UVC+qmF8hcMtuHDcyZ3bJpaTH8qJ61vVeLzJ
	SOzRWxZnZQZDcDE+YB/32aJDsM6DA7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787591502;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iua8vWm/691bFhi6aCw/FzNX4elJ0SUnv+L6rqVGR7A=;
	b=E4GuunWkud9QiIMjoRIbhphULbWyhbzf7a1xR+CBvItMM0ncQw0uqM79/WrOPDGG0lqwo7
	aH11748MwocUlVCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787591497;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iua8vWm/691bFhi6aCw/FzNX4elJ0SUnv+L6rqVGR7A=;
	b=ibxXsjK3ZKqKPR/Uhgh7jC4SBGIP999oT/QWk0Br9vNMvSVb3IIuYmi9CiTcbsBeg10n5E
	VklnzKpFVwDtEIRt89H51JReVxnV8Y/5BlMa7ok3m/+Rq+jgtnhgfj+N7FL/MOAufyS3Fd
	J/YSQgPl9fyO6cNeYB9sqffF1znE8ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787591497;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iua8vWm/691bFhi6aCw/FzNX4elJ0SUnv+L6rqVGR7A=;
	b=ApS6mJbVNkDxbAts3prU+Fvki2haBpWRGjOKIh8jZrSIahuNwxRfXxKaVvOQwYy/hSUJAH
	4FukDx3o9AUjEhBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFE4C13335;
	Mon, 24 Aug 2026 17:11:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W0OjLkl7jGozNgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 24 Aug 2026 17:11:37 +0000
Date: Mon, 24 Aug 2026 19:11:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] btrfs: dev-replace: fix the error handling in
 btrfs_dev_replace_finishing()
Message-ID: <20260824171132.GG9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1787545216.git.wqu@suse.com>
 <d1e76ae13f52a03bb4625d8b8034f443e27f8919.1787545216.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1e76ae13f52a03bb4625d8b8034f443e27f8919.1787545216.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -8.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-8.00 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Mon, Aug 24, 2026 at 02:04:07PM +0930, Qu Wenruo wrote:
> In btrfs_dev_replace_finishing(), we have the following error paths that
> do not do any cleanup:
> 
> - btrfs_start_delalloc_roots() error
> - btrfs_start_transaction() error
> 
> Both will error out directly, leaving the existing dev_replace
> untouched, meaning the dev-replace will still be treated as running,
> blocking future dev_replace.
> 
> Fix the problem by letting the above errors to go to a new out label,
> which will do the common dev_replace cleanup, with an error message
> showing that dev-replace has failed.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/dev-replace.c | 39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index be4031a6ce1d..df048cf69621 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -893,8 +893,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	 */
>  	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
>  	if (ret) {
> -		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> -		return ret;
> +		mutex_lock(&fs_devices->device_list_mutex);
> +		mutex_lock(&fs_info->chunk_mutex);

The conditional locking inside an 'if' is not common, I don't see a
better way how to do it so suggestion below

> +		goto out;
>  	}
>  	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
>  
> @@ -906,8 +907,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	while (1) {
>  		trans = btrfs_start_transaction(root, 0);
>  		if (IS_ERR(trans)) {
> -			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> -			return PTR_ERR(trans);
> +			ret = PTR_ERR(trans);
> +			mutex_lock(&fs_devices->device_list_mutex);
> +			mutex_lock(&fs_info->chunk_mutex);
> +			goto out;
>  		}
>  		ret = btrfs_commit_transaction(trans);
>  		WARN_ON(ret);
> @@ -925,10 +928,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  		}
>  	}
>  
> +out:

Add lockdep_assert_held() so it's clear that all paths leading here will
have the mutexes taken.

>  	down_write(&dev_replace->rwsem);
> -	dev_replace->replace_state =
> -		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
> -			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
>  	dev_replace->tgtdev = NULL;
>  	dev_replace->srcdev = NULL;
>  	dev_replace->time_stopped = ktime_get_real_seconds();
> @@ -938,14 +939,17 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	 * Update allocation state in the new device and replace the old device
>  	 * with the new one in the mapping tree.
>  	 */
> -	if (!scrub_ret) {
> -		scrub_ret = btrfs_set_target_alloc_state(src_device, tgt_device);
> -		if (scrub_ret)
> -			goto error;
> -		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
> -								src_device,
> -								tgt_device);
> -	} else {
> +	if (!scrub_ret && !ret) {
> +		ret = btrfs_set_target_alloc_state(src_device, tgt_device);
> +		if (!ret)
> +			btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
> +									src_device,
> +									tgt_device);
> +	}
> +	dev_replace->replace_state =
> +		(scrub_ret || ret) ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
> +				   : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
> +	if (scrub_ret || ret) {
>  		if (scrub_ret == -ECANCELED)
>  			btrfs_info(fs_info,
>  				"dev_replace from %s (devid %llu) to %s canceled",
> @@ -956,8 +960,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  				 "dev_replace from %s (devid %llu) to %s failed %d",
>  				 btrfs_dev_name(src_device),
>  				 src_device->devid,
> -				 btrfs_dev_name(tgt_device), scrub_ret);
> -error:
> +				 btrfs_dev_name(tgt_device), scrub_ret ? scrub_ret : ret);
>  		up_write(&dev_replace->rwsem);
>  		mutex_unlock(&fs_info->chunk_mutex);
>  		mutex_unlock(&fs_devices->device_list_mutex);
> @@ -967,7 +970,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  		btrfs_rm_dev_replace_unblocked(fs_info);
>  		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>  
> -		return scrub_ret;
> +		return scrub_ret ? scrub_ret : ret;

You can use the short form 'return scrub_ret ?: ret'

>  	}
>  
>  	btrfs_info(fs_info,
> -- 
> 2.55.0
> 
