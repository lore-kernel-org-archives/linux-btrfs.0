Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7D50EC14
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788542059; cv=none; b=ssK2IrGXTvaYjhCNskqi512gi+CafCoTqnvcMz2pdu9TFWbRrCE51qCDZ08vLNc5FzfFYwquf+510eMwoc0Kmn8TriAcgR46AIHR9eY9bPW9BVqJ77UUETMSNfEupXnhOpgH/4bTw0UekdVXZknsNcEIile8xqLqFzaOQMIT2vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788542059; c=relaxed/simple;
	bh=glyoUekMev8ff49HA7LSC7dlRb2zM+4PJMisn7AH5b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Szt5nhV3Taqg/1oCs4hO7c8yTS5kG4yzqAeH/0VchcdjebwG0+Rnjj4ZWQn5qQcxLbCt1GB+XicjocU/dZX432hlqXP00KgBLhe1HWA9+c1BVMP2FE28wuM/gFCuxlBmRCL649M3fQqqXHreZBFgiC4mu1cvG/eAvkZneeNKrFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JVMIehE4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MPrSVROr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tTgqWIZE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0zn+c8ZI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JVMIehE4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MPrSVROr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tTgqWIZE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0zn+c8ZI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 94630220F0;
	Fri,  4 Sep 2026 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788542051;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJc1qA/d6vKoL81Qq67g7wkzditKZ3KBVVGpiMnrOQ4=;
	b=JVMIehE4GHvyfQL6hpP5xAT4rH2VKkkH0HL6Qe4b3I4DhXPVc7EnFFpH8X2INzjpAlPt+V
	frmuKApQWj2LGfynCDv7Kpa07Gunu4PYUxO2ct1EeUqraJQNKCswnoGpmwPLgxPbdtL1Q7
	RS1f1ljGWDjlU9PiYPZ6GOUXuPJGyqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788542051;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJc1qA/d6vKoL81Qq67g7wkzditKZ3KBVVGpiMnrOQ4=;
	b=MPrSVROrLZgGwQGw25h87nbt/Yk9PoqKcXADuOrZo3FAEUNgnXk3/tzgApQruNqfZmi/73
	Y0JKpDCiviap6VCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788542047;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJc1qA/d6vKoL81Qq67g7wkzditKZ3KBVVGpiMnrOQ4=;
	b=tTgqWIZE/oC6/HUtgGMGEHW3srKiEJCBc6qlPLkRGVQRM5npp84oOb+fTPdSO+9wIr23Kx
	hcUPj076Hm4RHlRndfBbDBVJbf89c8HtoUuDl/yXX1UEQVa35E4G4PI81eW5ehPgkADh19
	wGt3C1Dclbjd/X+KXSndJJcXu059Cb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788542047;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJc1qA/d6vKoL81Qq67g7wkzditKZ3KBVVGpiMnrOQ4=;
	b=0zn+c8ZIVHdzt2lwUJI/rGB2MrL8W6o1D0QDwk9sNBvE22l6rs2bsvIxn3YdHGlMggj+yu
	ABpUWQAESyML9VBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 682BB13726;
	Fri,  4 Sep 2026 17:14:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cHA8GV/8mmpJcAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 04 Sep 2026 17:14:07 +0000
Date: Fri, 4 Sep 2026 19:14:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: tree-checker: add qgroup status item check
Message-ID: <20260904171406.GO9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Aug 26, 2026 at 07:23:15PM +0930, Qu Wenruo wrote:
> This adds the following checks:
> 
> - Key check
> 
> - Item size check
>   Here we do not require completely matching the older or newer qgroup
>   status item size, this is to allow future structure expansion.
> 
> - Version check
>   Again it's not a strict requirement for the version to match the
>   support one, but to catch obvious bitflip.
> 
>   And the kernel will already reject unknown version by disabling qgroup.
> 
>   So we allow any version that is no larger than U8_MAX, which I believe
>   we won't reach in the next few decades.
> 
> - Flags check
>   Mostly to catch any unexpected RUNTIME flags.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Loosen the version check
> - Loosen the item size check
>   To allow older kernels to mount future newer qgroup expansions,
>   other than completely rejecting the qgroup tree and failing the mount.

I don't see this patch in for-next but it seems OK for merge.

> +	/*
> +	 * The version (1) hasn't changed for a long time, but even if we
> +	 * are going to support a newer version, it won't suddenly jump
> +	 * over 255 in the foreseeable future.
> +	 */
> +	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) > U8_MAX)) {

Why is it U8_MAX instead of 255 as said in the comment? I understand
that it is for one byte, although the structure has __le64 for it.

I also don't expect the version to reach any high number, the version
for such item is an outlier in the data structure format, we usually
guess the version from the raw item size. Keeping the version inside
without any reserved/unused filelds also make it pointless. The only
meaningful way I see is to split the u64 to 1+3 bytes with 1st byte to
be the version.

Actually, looking to the history, commit bd7c1ea3a302ab ("btrfs: qgroup:
check generation when recording simple quota delta") already increased
the structure size, so we don't even make use of the version.

As it is now it's basically wasting the 4 bytes and we won't increase it
anyway so can think about how to scrap it completely and make the test
stricter.

> +		generic_err(leaf, slot,
> +			    "suspicious qgroup status version, has %llu expect %u",
> +			    btrfs_qgroup_status_version(leaf, qsi),
> +			    BTRFS_QGROUP_STATUS_VERSION);
> +		return -EUCLEAN;
> +	}
> +	flags = btrfs_qgroup_status_flags(leaf, qsi);
> +	if (unlikely(flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK)) {
> +		generic_err(leaf, slot,
> +			    "unknown qgroup status flags, has 0x%llx unknown flags 0x%llx",
> +			    flags, flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK);
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE &&
> +		     item_size < sizeof(*qsi))) {
> +		generic_err(leaf, slot,
> +			    "invalid qgroup status item size, has %u expect at least %zu",
> +			    item_size, sizeof(*qsi));
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
