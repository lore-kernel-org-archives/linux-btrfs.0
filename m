Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3A4348C78
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781805758; cv=none; b=LR4L7liR6B4lpeMYL2Fga0DqWB72x559t0hMvS5iSSMR9xa/mPKc17pJ6YGnadEPB23PsKku32Q6RO5Mvti81BlrhUangux6ySgXRMSIIyafgOhc7EHw+OI7EjIFm69ctSLcn0zBj8MXcDrDxNQx/mV/m40Da4iCJYFbiuMpK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781805758; c=relaxed/simple;
	bh=MkO4dW5p+OFyIs+t6wez/HZLj/Jb8jQ7RBE/u/yP9IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KoKRFFsonU2bYeZqesE02ftiMJI2qrs8hGrXfoYDEhlIcn1XXr1jdoVuQ4tGebTjLOULmJqg+MTyJ1pTelpeAN+JE16TMTF91Zj0LQBe5+JFV4+I3fZgvEg9b1OWX3cbaul8XH8mCen6hb/0u+joui8up90jEdISF/MxqQinwv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EIW5MMqj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wk+hzjj7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VKGuQcMt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4YdTBV91; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EIW5MMqj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wk+hzjj7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VKGuQcMt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4YdTBV91"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 436A96C307;
	Thu, 18 Jun 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781805755;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdXESHCgZAhGFOQTYmHRBhB7f3tDOurtpB7l0YhvKhg=;
	b=EIW5MMqjOeXK7xIaMxAVVDGlB32Oyb+VGJQDnPAXMvUcZ81ks7InMWMPqsHVaFSffNIi3i
	RK0X0s9QFKrnc1U/x/9ZOcYgn/I+eA1oEADfsu6r99zLmpVAcTEM7SmuUMJ5jQDB0CJCH9
	dzpexlsszJdjutPzd0no2zneAVxEzsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781805755;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdXESHCgZAhGFOQTYmHRBhB7f3tDOurtpB7l0YhvKhg=;
	b=Wk+hzjj7nnJ08Ls8vhW+b7ntfUCUBUDrhHhwPZrcdNEi8/eKF3KGMmu2GL39jDXCRflEUU
	n260LWZG0RR/1nAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VKGuQcMt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4YdTBV91
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781805754;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdXESHCgZAhGFOQTYmHRBhB7f3tDOurtpB7l0YhvKhg=;
	b=VKGuQcMt5BfCiVmKZfBcb036G1q7De1fGyukb3ZSGoYyXMvd1bjrwjaxkdWFm1rOueUp4G
	e/BBxET2tW9SxPZiYINduAfRMvyYPD8QLSb657Udt3yymjLYm+P8ImCNeIV7Q6VbRSs6o4
	pL+kBuWFrpFztsiH4YUamWr99zzVpCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781805754;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdXESHCgZAhGFOQTYmHRBhB7f3tDOurtpB7l0YhvKhg=;
	b=4YdTBV91oUfL9YUiMTUYGKBTRb9KXff/QQshwvtGeSZz0pYMy12t0diLBu2ArtrLSP0VJN
	GEwiVfsE+6wh+XCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29996779A8;
	Thu, 18 Jun 2026 18:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uMXiCboyNGocbQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 18 Jun 2026 18:02:34 +0000
Date: Thu, 18 Jun 2026 20:02:29 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix memory barrier order in
 reloc_root_is_dead()
Message-ID: <20260618180228.GB1049224@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1781263239.git.fdmanana@suse.com>
 <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,sashiko.dev:url];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 436A96C307
X-Spam-Score: -4.21

On Fri, Jun 12, 2026 at 01:13:57PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we set a root's reloc_root to NULL, we do it like this:
> 
>    static void clear_reloc_root(struct btrfs_root *root)
>    {
>        root->reloc_root = NULL;
>        /*
>         * Need barrier to ensure clear_bit() only happens after
>         * root->reloc_root = NULL. Pairs with have_reloc_root().
>         */
>         smp_wmb();
>         clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>    }
> 
> So that a NULL reloc_root is always seen before seeing that the bit
> BTRFS_ROOT_DEAD_RELOC_TREE was cleared.
> 
> But on the read side we have:
> 
>    static bool reloc_root_is_dead(const struct btrfs_root *root)
>    {
>         smp_rmb();
>         if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
>             return true;
>         return false;
>    }
> 
> And then callers of reloc_root_is_dead() access root->reloc_root.
> 
> Because the read memory barrier is placed before testing the bit, the CPU
> is completely free to speculatively reorder those two loads. It can read
> root->reloc_root before it actually checks the dead tree bit.

The barrier placement was contentious back then when and I don't have
the capacity now to analyze it again. The point of placing the barrier
before the test_bit() is to have up-to-date value for the check. It does
not make sense to place it after, because the test can have stale data
and other CPU could have changed the related state, the reloc_root in this
case.

As there's part with set bit and clear bit, and using the split
read/write barriers it's not the easy case I could have missed
something.

> Sashiko reported this as an existing problem in another patch review, see
> the link in the Link tag below.
> 
> Fix this by moving the read memory barrier to happen after testing the bit
> and update the comment to reflect current reality.
> 
> Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/relocation.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 6b5a59cb21bb..00993505c9c3 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -339,14 +339,15 @@ static struct btrfs_backref_node *walk_down_backref(
>  
>  static bool reloc_root_is_dead(const struct btrfs_root *root)
>  {
> +	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
> +		return true;
>  	/*
> -	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
> -	 * btrfs_update_reloc_root. We need to see the updated bit before
> -	 * trying to access reloc_root
> +	 * Pairs with set_bit/clear_bit in clear_reloc_root() and
> +	 * btrfs_update_reloc_root(). We need to see the updated bit before
> +	 * trying to access root->reloc_root in our callers.

The part "we need to see the updated bit" refers to the original logic
where 'updated bit == 'smp_rmb; if (test_bit())' and making sure it's
consistent with reloc root. So the meaning of the comment hasn't changed
apart from the fixups (Pairs, clear_reloc_root, root->reloc_root).

As your patch changes the logic the comment should be also updated, but
then I argue the resulting code is wrong, or at least not entierly
correct.

Alternatively we can drop the barriers completely for the
'dead_reloc_tree' bit and reloc_root synchronization, because we've spent
too much time in total on that one.

>  	 */
>  	smp_rmb();
> -	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
> -		return true;
> +
>  	return false;
>  }
