Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AD3E3DA0
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776269692; cv=none; b=PhjHUUQefYEqpqSmAZJ5hkjcfVbYMwIijFApBmAXqcqTwf8GBWFPLSy8QZnjNhDa/dtvn6ENfZjyUSIQLQBZsEgqJWGNjrKrsTdd+QLJrGa3hUvqS8TPSAr5ctrc3M2b9zAtBWIjH5ZZJ8y8wezHD1o8usx0mV5cz6n3RWiIilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776269692; c=relaxed/simple;
	bh=zEIqEVeFdbp5cdVytP5PhMgI2XrZWlrsLIsY0HOjoZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8vn1MAjB1piiX1dCOaieQVMKYI0dTY4sxMiy1hxwHfDfOq0xP/sE3yEz/aAAY5E2MYe1ur6rJ6mlq6w3ydoiTUWhSGZEdJdlpM5jsT2ctqdMZ5GVKT2aySyuXIBHouHOFIQiJy4KrM4yP5PU6Fhr2PVsmi1LBoxg8jGqtRU/n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1p0WU2MY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4QDrFCeZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1p0WU2MY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4QDrFCeZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1p0WU2MY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4QDrFCeZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1p0WU2MY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4QDrFCeZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1651D5BDFC;
	Wed, 15 Apr 2026 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776269687;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok7s71e0vnApnuxionFO7BcC7ZeC8M6P3cGk3GZltVU=;
	b=1p0WU2MY0GpTQ2af77nGq9/gjdPgXQNWyVNbdh6PCNCXkl6dUWr0E2i/w7cV2zrQnsjmK8
	YIanJKJiD3d8f10NZ1KpmoW4gh8lr4ZpBVzAroNyn9q/Tz+CsbWjV0Cxvp7bfNNIPqvxt1
	OYqimCREHi1441bo/C87RZ9KVZtwThA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776269687;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok7s71e0vnApnuxionFO7BcC7ZeC8M6P3cGk3GZltVU=;
	b=4QDrFCeZSYJtDLfT4JxUD9FTEBHm7Lzb6kWBVrM+20JozWrORrOArlKOjTNaQYkgfsCemF
	S1dov426gTmoYpAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776269687;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok7s71e0vnApnuxionFO7BcC7ZeC8M6P3cGk3GZltVU=;
	b=1p0WU2MY0GpTQ2af77nGq9/gjdPgXQNWyVNbdh6PCNCXkl6dUWr0E2i/w7cV2zrQnsjmK8
	YIanJKJiD3d8f10NZ1KpmoW4gh8lr4ZpBVzAroNyn9q/Tz+CsbWjV0Cxvp7bfNNIPqvxt1
	OYqimCREHi1441bo/C87RZ9KVZtwThA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776269687;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok7s71e0vnApnuxionFO7BcC7ZeC8M6P3cGk3GZltVU=;
	b=4QDrFCeZSYJtDLfT4JxUD9FTEBHm7Lzb6kWBVrM+20JozWrORrOArlKOjTNaQYkgfsCemF
	S1dov426gTmoYpAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAE734BAC8;
	Wed, 15 Apr 2026 16:14:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CIvOXa532m9CQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 15 Apr 2026 16:14:46 +0000
Date: Wed, 15 Apr 2026 18:14:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: convert ioctl handlers to AUTO_KFREE
Message-ID: <20260415161445.GQ12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260414211231.2890720-1-dsterba@suse.com>
 <c095e782-8755-491f-b49a-d69ff387b8c2@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c095e782-8755-491f-b49a-d69ff387b8c2@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bootlin.com:url,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 15, 2026 at 09:59:46AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/15 06:42, David Sterba 写道:
> > Many ioctl handlers are suitable for the AUTO_KFREE conversions as the
> > data are temporary and short lived. The conversions are trivial or the
> > collateral changes are straightforward.
> > 
> > A kfree() preceding mnt_drop_write_file() is slightly more efficient but
> > in the reverse order (i.e. the automatic kfree) does not cause any
> > significant change as the write drop does only a few simple operations.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/ioctl.c | 289 +++++++++++++++++------------------------------
> >   1 file changed, 104 insertions(+), 185 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index b2e447f5005c16..17f72b3a1c43d6 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -707,7 +707,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
> >   {
> >   	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
> >   	struct inode *inode;
> > -	struct btrfs_pending_snapshot *pending_snapshot;
> > +	struct btrfs_pending_snapshot AUTO_KFREE(pending_snapshot);
> 
> Checkpatch is reporting warnings about it;
> 
> WARNING:FUNCTION_ARGUMENTS: function definition argument 
> 'pending_snapshot' should also have an identifier name
> 
> It doesn't recognize the expanded macro here.
> 
> Not sure if the plain __free() method will solve the false alerts.

Maybe it does but I don't run checkpatch.

> >   	unsigned int trans_num_items;
> >   	struct btrfs_trans_handle *trans;
> >   	struct btrfs_block_rsv *block_rsv;
> > @@ -816,7 +816,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
> >   		free_anon_bdev(pending_snapshot->anon_dev);
> >   	kfree(pending_snapshot->root_item);
> >   	btrfs_free_path(pending_snapshot->path);
> > -	kfree(pending_snapshot);
> >   
> >   	return ret;
> >   }
> > @@ -961,7 +960,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
> >   	u64 new_size;
> >   	u64 old_size;
> >   	u64 devid = 1;
> > -	struct btrfs_ioctl_vol_args *vol_args;
> > +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
> 
> @vol_args is later called with memdup_user(), which can return error 
> pointers, and unfortunately kfree() doesn't have any special checks on 
> error pointer.

kfree() does not but the __free() callback does:

https://elixir.bootlin.com/linux/v7.0/source/include/linux/slab.h#L517
DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))

I will mention it in the changelog.

> [...]
> >   static noinline int btrfs_ioctl_subvol_getflags(struct btrfs_inode *inode,
> > @@ -1895,10 +1876,9 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
> >   
> >   out:
> >   	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
> > -		ret = -EFAULT;
> > +		return -EFAULT;
> >   
> > -	kfree(args);
> > -	return ret;
> > +	return 0;
> 
> The original error is now discarded.

Right, there are still paths that set 'ret'.
