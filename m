Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DA3323417;
	Mon, 12 Oct 2026 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821787; cv=none; b=IaJuCEepUMnw1KC2oORJIqoSzjlrn0HUOdsjIweKWf/u4/7UMRdm4OvaMvecd2Y8P3rLBNw1i+i6oTIR1dZdM2VVuH3h4zmAZksBofBS4ZhqYd48p4vKiVQiLpZzFAd27sJv6LKOZDc6OTapvo+JHXpSI8UX6xXerepIyV7E3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821787; c=relaxed/simple;
	bh=qBrdL8hEuh98hB+ggHumK7J1HmTMTV6ELoUi707lFy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=md1nRWkMmYsAkkWvZ+9Rz/+HKhnDyZPojMGDn+2JtRdCR8r6yzX9pUqhK9d44UCBIIKthhrh+i7dNaQmOR/i5skpAIUCj9yPCAmN0s6GaQOmAxeLWsccpHgzX2LO/+LPrardUOCEF0aVo64OSIhm3hGY/aGMXzYny6ri/+Tii1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HZBxeKPa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nB2BgqZG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WWceGWDJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vmVhSmWs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HZBxeKPa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nB2BgqZG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WWceGWDJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vmVhSmWs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0DA251F452;
	Mon, 12 Oct 2026 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791821783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oaw6+PiVA44MtmvW5kOItUHWl2YymffwUEd7qORDt1s=;
	b=HZBxeKPaSuJuHrua6pwIjLUgJu7T8+o5x6pGbu6VrVxgW0pontpG7mgvSCW985lvQXCm6k
	ENiCBzHr7vZPPzUN+RDzVpK2ajEGkHlPIrKXbI8outUnK98NY01XNWN8P7ybGirsg5L0xU
	cAeLEvs1yYOuf1+uuzrOORr9psx1yyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791821783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oaw6+PiVA44MtmvW5kOItUHWl2YymffwUEd7qORDt1s=;
	b=nB2BgqZGXtqQFEj9bmWRZS5HMKJiCm9+NCbifhOmi85FkwuCll0g+y7M86ZJW+N+n6N4ef
	O1eu+fHbxoQNPmDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791821782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oaw6+PiVA44MtmvW5kOItUHWl2YymffwUEd7qORDt1s=;
	b=WWceGWDJWbWyp+tSjWUuIl96+47XetoM8UQ5ojGWu22vW0tpHkFlS58u3gADcp3WGRybpY
	qS3B6aHa+hxemG1ZzhjBHcnsecTmHO+ZY/eGbSw6pzWcsS8Ap7IBbkaMiEzTet+7DasyLX
	71l8j1AG3D7WgTfNDdqv3TOGdTkgfEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791821782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oaw6+PiVA44MtmvW5kOItUHWl2YymffwUEd7qORDt1s=;
	b=vmVhSmWsRel2xmyiBhPqbV+Ka6fqG4q5r0ToTPQ8GhzafF+ptviSJpOif87jnc7//+DvbD
	/re/ZAjGcxA9wmAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA73B13314;
	Mon, 12 Oct 2026 16:16:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SixCKdUHzWqqJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 16:16:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5D46EA1405; Mon, 12 Oct 2026 18:16:17 +0200 (CEST)
Date: Mon, 12 Oct 2026 18:16:17 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] super: convert to plain hashtable
Message-ID: <skrqaeb7xlz5cjge27i7rsvv47jrfmgur3ugypy24mfvx6rndi@cvqtng3snniy>
References: <20261012-work-super-dev_hash-v1-0-305cf71cd334@kernel.org>
 <20261012-work-super-dev_hash-v1-2-305cf71cd334@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-super-dev_hash-v1-2-305cf71cd334@kernel.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 12-10-26 14:31:19, Christian Brauner wrote:
> Convert the rhltable to a plain hashtable under a spinlock. The walks
> keep their place with a cursor entry in the chain. A claim is unhashed
> the moment it's dropped and a walk that finds a superblock that isn't
> born yet waits for it to be born or to die and looks again. Since
> hashing can't fail anymore the entry for the superblock's own s_dev is
> embedded in struct super_block and the preallocation in alloc_super()
> goes away. This all simplifies things quite a lot.
> 
> It also fixes a btrfs bug where fs_bdev_freeze() ended up freezing a
> btrfs filesystem through a stale member that open_ctree() had already
> released while the freeze was waiting for SB_BORN. The resume doesn't
> find a holder for that device anymore so the filesystem stays frozen
> for good.
> 
> The walks return superblocks instead of table entries now and
> user_get_super() hands out the passive reference the walk took.
> 
> Reproducer, a three device btrfs with a stale copy of a removed member.
> dm-delay under the remaining members stretches the window between
> btrfs_open_devices() and btrfs_free_extra_devids():
> 
>   truncate -s 1G a1 a2 b
>   A1=$(losetup -f --show a1); A2=$(losetup -f --show a2); B=$(losetup -f --show b)
>   mkfs.btrfs -f -d single -m single $A1 $A2 $B
>   cp b b.old
>   mount $A1 /mnt && btrfs device remove 3 /mnt && umount /mnt
>   OLD=$(losetup -f --show b.old)
>   dmsetup create d1 --table "0 $(blockdev --getsz $A1) delay $A1 0 200"
>   dmsetup create d2 --table "0 $(blockdev --getsz $A2) delay $A2 0 200"
>   dmsetup create old --table "0 $(blockdev --getsz $OLD) linear $OLD 0"
>   mount -o device=/dev/mapper/d2,device=/dev/mapper/old /dev/mapper/d1 /mnt &
>   sleep 1; dmsetup suspend old; wait
>   dmsetup resume old
>   touch /mnt/foo     # hangs until fsfreeze -u /mnt
> 
> That left btrfs frozen in 5 of 5 rounds with the same tables issued
> through raw dm ioctls. The -o degraded variant needs the mount held
> between the insertion and the bd_fsfreeze_count check in
> fs_bdev_register() with a kprobe.
> 
> Fixes: cdb5146f8d5f ("fs: look up superblocks via the device table in fs_holder_ops")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Overall looks good to me and indeed the code looks simpler. One suggestion
below:

> +/* Unhash the cursor of a walk that stops early. */
> +static void super_dev_walk_end(struct super_dev *cursor)
>  {
> -	struct super_dev *sb_dev;
> -
> -	rcu_read_lock();
> -	sb_dev = super_dev_get(rhltable_lookup(&super_dev_table, &dev, super_dev_params));
> -	rcu_read_unlock();
> -	return sb_dev;
> +	guard(spinlock)(&super_dev_lock);
> +	hash_del(&cursor->sd_hash);
>  }
>
> +#define for_each_dev_super(sb, cursor) \
> +	for (sb = super_dev_next(cursor, NULL); sb; sb = super_dev_next(cursor, sb))

So the 'cursor' is unused by the users of for_each_dev_super() except for
calling super_dev_walk_end() when they abort the loop. So why not pass just
'dev' into the macro where 'cursor' will be internal to for() loop and
setup __cleanup to call super_dev_walk_end() when the cursor goes out of
scope? It will require a bit of a macro magic but should be more ergonomic
to use and no chance to forget calling super_dev_walk_end() at appropriate
places.

								Honza

>  
>  static void kill_super_notify(struct super_block *sb)
>  {
> @@ -548,11 +523,8 @@ static void kill_super_notify(struct super_block *sb)
>  	if (sb->s_flags & SB_DEAD)
>  		return;
>  
> -	/* Drop sget_fc()'s claim; a never-registered entry stays with the sb. */
> -	if (sb->s_super_dev->sd_dev) {
> -		super_dev_put(sb->s_super_dev);
> -		sb->s_super_dev = NULL;
> -	}
> +	/* Drop sget_fc()'s claim on s_dev. */
> +	super_dev_put(&sb->s_super_dev);
>  
>  	/*
>  	 * Let concurrent mounts know that this thing is really dead.
> @@ -880,13 +852,12 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	s->s_fs_info = fc->s_fs_info;
>  	err = set(s, fc);
>  	if (err) {
> -		VFS_WARN_ON_ONCE(s->s_super_dev->sd_dev);
>  		s->s_fs_info = NULL;
>  		spin_unlock(&sb_lock);
>  		destroy_unused_super(s);
>  		return ERR_PTR(err);
>  	}
> -	VFS_WARN_ON_ONCE(!s->s_super_dev->sd_dev);
> +	VFS_WARN_ON_ONCE(!s->s_dev);
>  	fc->s_fs_info = NULL;
>  	s->s_type = fc->fs_type;
>  	s->s_iflags |= fc->s_iflags;
> @@ -899,6 +870,8 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	list_add_tail(&s->s_list, &super_blocks);
>  	hlist_add_head(&s->s_instances, &s->s_type->fs_supers);
>  	spin_unlock(&sb_lock);
> +	scoped_guard(spinlock, &super_dev_lock)
> +		super_dev_add(&s->s_super_dev, s, s->s_dev);
>  	get_filesystem(s->s_type);
>  	shrinker_register(s->s_shrink);
>  	return s;
> @@ -1040,18 +1013,14 @@ EXPORT_SYMBOL(iterate_supers_type);
>  
>  struct super_block *user_get_super(dev_t dev, bool excl)
>  {
> -	struct super_dev *sb_dev;
> -
> -	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> -		struct super_block *sb = sb_dev->sd_sb;
> -
> -		if (!super_lock(sb, excl))
> -			continue;
> +	struct super_dev cursor = { .sd_dev = dev };
> +	struct super_block *sb;
>  
> -		/* The pinned entry holds a passive reference, take our own. */
> -		refcount_inc(&sb->s_passive);
> -		super_dev_put(sb_dev);
> -		return sb;
> +	for_each_dev_super(sb, &cursor) {
> +		if (super_lock(sb, excl)) {
> +			super_dev_walk_end(&cursor);
> +			return sb;
> +		}
>  	}
>  	return NULL;
>  }
> @@ -1353,16 +1322,7 @@ EXPORT_SYMBOL(free_anon_bdev);
>  
>  int set_anon_super(struct super_block *s, void *data)
>  {
> -	int error;
> -
> -	error = get_anon_bdev(&s->s_dev);
> -	if (error)
> -		return error;
> -
> -	error = super_dev_register(s);
> -	if (error)
> -		free_anon_bdev(s->s_dev);
> -	return error;
> +	return get_anon_bdev(&s->s_dev);
>  }
>  EXPORT_SYMBOL(set_anon_super);
>  
> @@ -1448,7 +1408,7 @@ EXPORT_SYMBOL(get_tree_keyed);
>  static int set_bdev_super(struct super_block *s, void *data)
>  {
>  	s->s_dev = *(dev_t *)data;
> -	return super_dev_register(s);
> +	return 0;
>  }
>  
>  static int super_s_dev_set(struct super_block *s, struct fs_context *fc)
> @@ -1527,14 +1487,12 @@ static int fs_super_thaw(struct super_block *sb)
>  
>  static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
>  {
> -	struct super_dev *sb_dev;
> -	dev_t dev = bdev->bd_dev;
> +	struct super_dev cursor = { .sd_dev = bdev->bd_dev };
> +	struct super_block *sb;
>  
>  	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> -		struct super_block *sb = sb_dev->sd_sb;
> -
> +	for_each_dev_super(sb, &cursor) {
>  		if (!super_lock_shared(sb))
>  			continue;
>  		if (sb->s_root && (sb->s_flags & SB_ACTIVE)) {
> @@ -1554,14 +1512,12 @@ static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
>  
>  static void fs_bdev_sync(struct block_device *bdev)
>  {
> -	struct super_dev *sb_dev;
> -	dev_t dev = bdev->bd_dev;
> +	struct super_dev cursor = { .sd_dev = bdev->bd_dev };
> +	struct super_block *sb;
>  
>  	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> -		struct super_block *sb = sb_dev->sd_sb;
> -
> +	for_each_dev_super(sb, &cursor) {
>  		if (!super_lock_shared(sb))
>  			continue;
>  		if (sb->s_root && (sb->s_flags & SB_ACTIVE))
> @@ -1585,8 +1541,8 @@ static void fs_bdev_sync(struct block_device *bdev)
>   */
>  static int fs_bdev_freeze(struct block_device *bdev)
>  {
> -	dev_t dev = bdev->bd_dev;
> -	struct super_dev *sb_dev;
> +	struct super_dev cursor = { .sd_dev = bdev->bd_dev };
> +	struct super_block *sb;
>  	unsigned int count = 0;
>  	int error = 0, err;
>  
> @@ -1594,13 +1550,13 @@ static int fs_bdev_freeze(struct block_device *bdev)
>  
>  	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> -		if (!get_active_super(sb_dev->sd_sb))
> +	for_each_dev_super(sb, &cursor) {
> +		if (!get_active_super(sb))
>  			continue;
> -		err = fs_super_freeze(sb_dev->sd_sb);
> +		err = fs_super_freeze(sb);
>  		if (err && !error)
>  			error = err;
> -		deactivate_super(sb_dev->sd_sb);
> +		deactivate_super(sb);
>  		count++;
>  	}
>  
> @@ -1640,8 +1596,8 @@ static int fs_bdev_freeze(struct block_device *bdev)
>   */
>  static int fs_bdev_thaw(struct block_device *bdev)
>  {
> -	dev_t dev = bdev->bd_dev;
> -	struct super_dev *sb_dev;
> +	struct super_dev cursor = { .sd_dev = bdev->bd_dev };
> +	struct super_block *sb;
>  	unsigned int count = 0;
>  	int error = 0, err;
>  
> @@ -1649,13 +1605,13 @@ static int fs_bdev_thaw(struct block_device *bdev)
>  
>  	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> -		if (!get_active_super(sb_dev->sd_sb))
> +	for_each_dev_super(sb, &cursor) {
> +		if (!get_active_super(sb))
>  			continue;
> -		err = fs_super_thaw(sb_dev->sd_sb);
> +		err = fs_super_thaw(sb);
>  		if (err && !error)
>  			error = err;
> -		deactivate_super(sb_dev->sd_sb);
> +		deactivate_super(sb);
>  		count++;
>  	}
>  
> @@ -1672,55 +1628,39 @@ static const struct blk_holder_ops fs_holder_ops = {
>  	.thaw			= fs_bdev_thaw,
>  };
>  
> -static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
> +static struct super_dev *super_dev_find(dev_t dev, const struct super_block *sb)
>  {
> -	struct super_dev *it;
> -	struct rhlist_head *list, *pos;
> +	struct super_dev *sd;
>  
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "suspicious super_dev_lookup() usage");
> -	VFS_WARN_ON_ONCE(!dev);
> -	VFS_WARN_ON_ONCE(!sb);
> +	lockdep_assert_held(&super_dev_lock);
>  
> -	list = rhltable_lookup(&super_dev_table, &dev, super_dev_params);
> -	rhl_for_each_entry_rcu(it, pos, list, sd_node) {
> -		if (it->sd_sb == sb)
> -			return it;
> +	hash_for_each_possible(super_dev_hash, sd, sd_hash, dev) {
> +		if (sd->sd_dev == dev && sd->sd_sb == sb)
> +			return sd;
>  	}
> -
>  	return NULL;
>  }
>  
> -static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
> +static int fs_bdev_register(struct block_device *bdev, struct super_block *sb)
>  {
> -	struct super_dev *sb_dev __free(kfree) = NULL;
> -	dev_t dev = file_bdev(bdev_file)->bd_dev;
> -	int err;
> -
> -	scoped_guard(rcu) {
> -		sb_dev = super_dev_lookup(dev, sb);
> -		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
> -			retain_and_null_ptr(sb_dev);
> -			return 0;
> -		}
> -	}
> -
> -	sb_dev = super_dev_alloc(dev, sb);
> -	if (!sb_dev)
> -		return -ENOMEM;
> +	struct super_dev *new __free(kfree) = NULL;
> +	struct super_dev *sd;
>  
> -	err = super_dev_insert(sb_dev);
> -	if (err)
> -		return err;
> +	new = kzalloc_obj(*new);
>  
> -	/* Publish the entry before reading the count; pairs with bdev_freeze(). */
> -	smp_mb();
> -	if (atomic_read(&file_bdev(bdev_file)->bd_fsfreeze_count) > 0) {
> -		err = -EBUSY;
> -		super_dev_put(sb_dev);
> +	guard(spinlock)(&super_dev_lock);
> +	sd = super_dev_find(bdev->bd_dev, sb);
> +	if (sd) {
> +		sd->sd_claims++;
> +		return 0;
>  	}
> -
> -	retain_and_null_ptr(sb_dev);
> -	return err;
> +	/* bdev_freeze() raises the count before its walk takes the lock. */
> +	if (atomic_read(&bdev->bd_fsfreeze_count) > 0)
> +		return -EBUSY;
> +	if (!new)
> +		return -ENOMEM;
> +	super_dev_add(no_free_ptr(new), sb, bdev->bd_dev);
> +	return 0;
>  }
>  
>  /**
> @@ -1747,7 +1687,7 @@ struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
>  	if (IS_ERR(bdev_file))
>  		return bdev_file;
>  
> -	err = fs_bdev_register(bdev_file, sb);
> +	err = fs_bdev_register(file_bdev(bdev_file), sb);
>  	if (err) {
>  		bdev_fput(bdev_file);
>  		return ERR_PTR(err);
> @@ -1781,7 +1721,7 @@ struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
>  	if (IS_ERR(bdev_file))
>  		return bdev_file;
>  
> -	err = fs_bdev_register(bdev_file, sb);
> +	err = fs_bdev_register(file_bdev(bdev_file), sb);
>  	if (err) {
>  		bdev_fput(bdev_file);
>  		return ERR_PTR(err);
> @@ -1796,21 +1736,20 @@ EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_path);
>   * @sb: superblock the device was claimed for
>   *
>   * The inverse of fs_bdev_register(): drop one claim on the {dev, @sb} entry
> - * (the last claim unregisters it; a pinning cursor defers the actual unlink)
> - * without closing the device.  A caller that must act on the still-open device
> - * between unregistering and closing - e.g. re-allow freezing one denied for a
> - * membership change - pairs this with bdev_fput().  fs_bdev_file_release() is
> - * the common unregister-and-close.
> + * (the last claim unregisters it) without closing the device.  A caller that
> + * must act on the still-open device between unregistering and closing - e.g.
> + * re-allow freezing one denied for a membership change - pairs this with
> + * bdev_fput().  fs_bdev_file_release() is the common unregister-and-close.
>   */
>  void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
>  {
> -	dev_t dev = file_bdev(bdev_file)->bd_dev;
> -	struct super_dev *sb_dev;
> +	struct super_dev *sd;
>  
> -	rcu_read_lock();
> -	sb_dev = super_dev_lookup(dev, sb);
> -	rcu_read_unlock();
> -	super_dev_put(sb_dev);
> +	/* The claim we're dropping keeps the entry hashed. */
> +	scoped_guard(spinlock, &super_dev_lock)
> +		sd = super_dev_find(file_bdev(bdev_file)->bd_dev, sb);
> +	if (sd)
> +		super_dev_put(sd);
>  }
>  EXPORT_SYMBOL_GPL(fs_bdev_unregister);
>  
> @@ -1853,8 +1792,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  		return -EACCES;
>  	}
>  
> -	/* The sget_fc() entry is already published; pairs with bdev_freeze(). */
> -	smp_mb();
> +	/* sget_fc() hashed @sb, super_dev_lock orders that against bdev_freeze(). */
>  	if (atomic_read(&bdev->bd_fsfreeze_count) > 0) {
>  		if (fc)
>  			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index ecd96aeb1cee..72f4288e16c5 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -30,7 +30,6 @@ struct mount;
>  struct mtd_info;
>  struct quotactl_ops;
>  struct shrinker;
> -struct super_dev;
>  struct unicode_map;
>  struct user_namespace;
>  struct workqueue_struct;
> @@ -132,10 +131,18 @@ struct super_operations {
>  	void (*report_error)(const struct fserror_event *event);
>  };
>  
> +/* A superblock's claim on a device, see fs/super.c. */
> +struct super_dev {
> +	struct hlist_node			sd_hash;
> +	struct super_block			*sd_sb;
> +	dev_t					sd_dev;
> +	unsigned int				sd_claims;
> +};
> +
>  struct super_block {
>  	struct list_head			s_list;		/* Keep this first */
>  	dev_t					s_dev;		/* search index; _not_ kdev_t */
> -	struct super_dev			*s_super_dev;	/* sget_fc()'s device table claim */
> +	struct super_dev			s_super_dev;	/* claim on s_dev */
>  	unsigned char				s_blocksize_bits;
>  	unsigned long				s_blocksize;
>  	loff_t					s_maxbytes;	/* Max file size */
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
