Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF1471404
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398321; cv=none; b=Jq7KykoMieAIICM1tZ6IQt2KZnVlJ28slMxT1nk1a3dZ9pBR3QACBdXRr0KgETHi2Xb9Fj9n3HKC57KeqgKUAtMIIjQvD3Au3EI0zGltY2bzc05h1Nin3uja1Porks3di0mOPenlfosjn/5R+HxNIld7vL/5PjeYm3Lw5YZ8doM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398321; c=relaxed/simple;
	bh=vqs4/WR2OqNJ6q1IiIzpHPo57zXwM5p6WTU5OxqTlwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2xg6BoUOJIBQgAui7szDdoA/KybzLzieSuCAwfvW/dbqVv52urPZ+chDd6CH8w60FQaslFsH6ywephY5JFFT/Cn4l9bQrgvceFHRhu5LfrC+UZ0yjm0VUSdH3IZqulpKquQjMeNaPlX3BnQ378iv+WBbddlXfnXzE6l8Rw0Uxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nA2E7iA+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OjWcH7Vg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CU5bXxgo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=05aNinKO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nA2E7iA+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OjWcH7Vg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CU5bXxgo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="05aNinKO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B804B21A42;
	Mon, 14 Sep 2026 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789398312;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JA8OCn/NHUy8dAcQnRFESQKtAgsf7kuaVScSO0djq6w=;
	b=nA2E7iA+k9nA23D5QXdylHYMykXNSWlL0iFc5lGqOXdylp5Fw3YN7+ET1Hz4hFUH3zOG7k
	1mBSJu/zvoBzccOeLwcoLm0SxcUzWlgk1glgxCoNMabiUDqXqDsd5NVbEYgdLvxnCCHf4A
	8bbKB3irNHEBqLl/ae9Qxk9il2fGL8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789398312;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JA8OCn/NHUy8dAcQnRFESQKtAgsf7kuaVScSO0djq6w=;
	b=OjWcH7Vg5LxA2suVh6x1E+pq5lzelM046oIsOq2SI2z1GKh2n5V/wHzLjzwQu4n4MnJobx
	kzuTewL5weoUr9BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CU5bXxgo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=05aNinKO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789398308;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JA8OCn/NHUy8dAcQnRFESQKtAgsf7kuaVScSO0djq6w=;
	b=CU5bXxgout5ZD+7kxWKIupdunOZgD7jbkJCAy0EFYV+j/2nsjoPllZpfW7Z7kHPfrMBPDb
	Wa3iT0MHMLMmWmWcgnHNZSEUMIzz4C5cgpxgMKXNrP+zqw0e9ibUu/MVxIwbbwBfgfynZ/
	IqS1osT3+tT/uhv9VhUiQP0YQJ8IUgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789398308;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JA8OCn/NHUy8dAcQnRFESQKtAgsf7kuaVScSO0djq6w=;
	b=05aNinKOMVGO5cFawmMFVXpZKEDm0cw0I14WIhzSwC9qry5ccl8irc4EFELKUontLdsb6+
	G4U4hXUDJNsyESAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A3261368C;
	Mon, 14 Sep 2026 15:05:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lZWEISQNqGqFSwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 15:05:08 +0000
Date: Mon, 14 Sep 2026 17:05:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 2/4] btrfs: zoned: fix possible UAF in wait_eb_writebacks
Message-ID: <20260914150503.GI54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
 <20260914085248.347198-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914085248.347198-3-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B804B21A42
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:replyto,wdc.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Sep 14, 2026 at 10:52:46AM +0200, Johannes Thumshirn wrote:
> wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
> for the writeback of these extent-buffers. Waiting for writeback needs
> to be done without the rcu_read_lock() held (because it can sleep) and
> thus the loop drops the rcu_read_lock() before calling into
> wait_on_extent_buffer_writeback(). But extent_buffers are freed through
> RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
> still waiting on the writeback, the extent_buffer will be freed causing
> a use-after-free.
> 
> Similar to what is done in find_extent_buffer_nolock(), get a reference
> to the extent_buffer before calling into
> wait_on_extent_buffer_writeback() so a sucessfull writeback does not
> free the extent_buffer while we still have a reference to it.
> 
> Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 12391063304b..c09e32904caf 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2511,8 +2511,11 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
>  			continue;
>  		if (eb->start >= end)
>  			break;
> +		if (!refcount_inc_not_zero(&eb->refs))

Please add a comment with the reason for that, several other uses of
inc-not-zero also have it. It makes it more visible and noticeable, also
a disappearing eb during some operation is disasterous.

Unrelated to this patch, the LLM reviews take the comments into account
and sometimes point out a pattern that is not followed in some case. It
can be either valid or a false positive, we can verify that. For humans
reading the code it's also useful as a drive-by knowledge.

> +			continue;
>  		rcu_read_unlock();
>  		wait_on_extent_buffer_writeback(eb);
> +		free_extent_buffer(eb);
>  		rcu_read_lock();
>  	}
>  	rcu_read_unlock();
> -- 
> 2.55.0
> 
