Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29336332EA0
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294955; cv=none; b=jYu9j2JOqZxiEQ82+eEozcjt75NYylmwqydmfjuyA94JrhzlfaRsrYzPGCiPtMf6Ks6yguSCmTMJo6Vcm9HrxUxKhU1RgdUXQaLANoucQ2zAs9fP9YuTJ3Jp/d/xek41zwgI1BnuvTESg4sdsGluschFTSgNxSYvsk/I9eJajYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294955; c=relaxed/simple;
	bh=lJs5mMiPdwgWvXt3NU6JdVWB04zGUyg3hgGHi8FsGVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIwyWfkXw+W/miOgC/DgPdZFcqCrLfRG0Oxw/17TcXt62R4WP0LbuS8cN9DhS2kY9mpRP1k/SQhFC2He2mWAXpV2rdFxjwp1Xi7nbv4NMpKPy1ZNubr5z7VrTF46djLz+V7wm0v297QGNX18PTYKecV875j7oB33cI3befn3M2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=19urVxMN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jzV5UfKV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=19urVxMN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jzV5UfKV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="19urVxMN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jzV5UfKV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="19urVxMN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jzV5UfKV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 146794D38C;
	Mon, 23 Mar 2026 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774294952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YP/vSdz2EgmrbXAtmFAlvNCKgoVWU7W77lboizZhX5U=;
	b=19urVxMNFMj5fMVA1PPIOvE1x1EIwmx2lJIh83LrSC0qoBYITc8f6fw6WRJPzWfpv1j84t
	4lZw0jkSq4JasIZV/1AN8EoRnjb9dBT+IIgDzGBAfgRyruz65hZK0MbD5D4l5BWzWQKKiA
	faAAbLIKUoKh7Q7i+o3rC+bbdm94txg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774294952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YP/vSdz2EgmrbXAtmFAlvNCKgoVWU7W77lboizZhX5U=;
	b=jzV5UfKVaF0qaFh4LocMZ8Pt8Iv33+2uNsbMdrpxTIp3oDAPQ4nC55ASg6jTMP95PjxWnV
	2xYTLGh6DGOujhAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=19urVxMN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jzV5UfKV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774294952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YP/vSdz2EgmrbXAtmFAlvNCKgoVWU7W77lboizZhX5U=;
	b=19urVxMNFMj5fMVA1PPIOvE1x1EIwmx2lJIh83LrSC0qoBYITc8f6fw6WRJPzWfpv1j84t
	4lZw0jkSq4JasIZV/1AN8EoRnjb9dBT+IIgDzGBAfgRyruz65hZK0MbD5D4l5BWzWQKKiA
	faAAbLIKUoKh7Q7i+o3rC+bbdm94txg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774294952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YP/vSdz2EgmrbXAtmFAlvNCKgoVWU7W77lboizZhX5U=;
	b=jzV5UfKVaF0qaFh4LocMZ8Pt8Iv33+2uNsbMdrpxTIp3oDAPQ4nC55ASg6jTMP95PjxWnV
	2xYTLGh6DGOujhAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4CF243A42;
	Mon, 23 Mar 2026 19:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SmE6N6eXwWlJZgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 19:42:31 +0000
Date: Mon, 23 Mar 2026 20:42:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add tree checker for items in remap tree
Message-ID: <20260323194222.GR5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323172552.151985-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323172552.151985-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto];
	URIBL_BLOCKED(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:replyto];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 146794D38C

The subject should be: "btrfs: tree-checker: ..."

On Mon, Mar 23, 2026 at 05:25:47PM +0000, Mark Harmstone wrote:
> Add write-time checking of items in the remap tree, to catch errors
> before they are written to disk.
> 
> We're checking:
> 
> * That remap items, remap backrefs, and identity remaps aren't written
>   unless the REMAP_TREE incompat flag is set
> * That identity remaps have a size of 0
> * That remap items and remap backrefs have a size of sizeof(struct
>   btrfs_remap_item)
> * That the objectid for these items is aligned to the sector size
> * That the offset for these items (i.e. the size of the remapping) isn't
>   0 and is aligned to the sector size
> * That objectid + offset doesn't overflow

Nice.

> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/tree-checker.c | 70 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 495d1dd61e66c2..b19066e8ef522c 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1879,6 +1879,71 @@ static int check_raid_stripe_extent(const struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static int check_remap_key(const struct extent_buffer *leaf,
> +			   const struct btrfs_key *key, int slot)
> +{
> +	u32 item_size = btrfs_item_size(leaf, slot);

This can be const as well.

> +	const u32 sectorsize = leaf->fs_info->sectorsize;
> +	u64 end;
