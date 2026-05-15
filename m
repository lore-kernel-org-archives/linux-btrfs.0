Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E973F9276
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862701; cv=none; b=KYB42HK53Peyl5SYniBTNAvs2Pe4d6VoPKp7ODus2uNLd3W1nMFMDUsKCe+G0Jp9melMsYYxIGwk+eHLZcQlZbV7usgZiM169yRLIYh9p4ytsnCZoj4FRvvUz6kVCs1IXvZY7xR9c5ZGdBshXJfoDH6ultduoDoyIMuNPJtl1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862701; c=relaxed/simple;
	bh=Gi3ZUmLKOE4MPHblY8hcXciQyXrZ8dXZroHT+aRXjSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyL2+pxzKDuiNUz40aEhkVbh4MzFvq8HRYXcyx74JjhKPA1YzkfWzNBn8muv8o1VQeNR9sjbmXFd9yiyFvPTtLzK0q1/wA0KJtiObuuk1NWSt6NRAgHOLUhGfSKOnCirm05+a3iBMIa0JisA0NmJYmRelurPGqGM2JwolttuaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JSndbIcW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aZSwHS5P; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q9AMNhPm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VL/m1gAs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JSndbIcW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aZSwHS5P";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q9AMNhPm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VL/m1gAs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1383C5BD8B;
	Fri, 15 May 2026 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778862698;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkQMwNtcL1HaN1zcMxN7mBj03t4jNODYRd9Z3WjCr6k=;
	b=JSndbIcWAV0EpPWvfCWWGYmxwMwAHMSnNhHtRe3ttM3kAjoxUQh5ISS8LAY5YQHEIV+7kk
	OBBEj4tUacwscedpyhagzI+DDigYtY9xBPpEZu3PbR8HeX2tKjwEfF3y0/a0anovWgPct3
	yurV1vibh1IDUvAghyhHcD+Azz+FyTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778862698;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkQMwNtcL1HaN1zcMxN7mBj03t4jNODYRd9Z3WjCr6k=;
	b=aZSwHS5PbMVdI3WQTlw+5WmNK9Dw3lbfSPMvfqb+SUVIaBn7eeLKPolQvPBNJrDhmMjbmk
	HGymQikIwLhjnwAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778862697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkQMwNtcL1HaN1zcMxN7mBj03t4jNODYRd9Z3WjCr6k=;
	b=q9AMNhPmasTeU0Q01v7Cbcit70is7PiSDeoC5eH8bxMBnSxo6dxdNBfGgeqXJRrCeIuru6
	MllewcfaIMBnri6JEgymVgSxDZFbW5CP5Zw/4YehFajSW1+ndg6uF3n+F6D8qO3ya9aUdJ
	HifaL8uEpMzp+JdcBnYAVHIRgCbcs7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778862697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkQMwNtcL1HaN1zcMxN7mBj03t4jNODYRd9Z3WjCr6k=;
	b=VL/m1gAsPHDbtVbqtS+BbELdzKxN6BhSzhnssLNJOP5yBdbUfPghlqn2lLdH0ebTDWvDQN
	PaQicFsGlysyXLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F247D593A9;
	Fri, 15 May 2026 16:31:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mBHqOmhKB2prIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 15 May 2026 16:31:36 +0000
Date: Fri, 15 May 2026 18:31:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: tree-checker: enhanced fst extent/bitmap
 checks
Message-ID: <20260515163135.GT2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778460959.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778460959.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Mon, May 11, 2026 at 10:26:48AM +0930, Qu Wenruo wrote:
> The first patch is a small cleanup to share more code and remove
> duplications.
> 
> The second one is to avoid u64 overflow for the extent/bitmap/space info,
> mostly to catch obviously corruptedd size.
> 
> The last one is the main part, introducing cross-key checks.
> 
> If the previous key is FREE_SPACE_INFO, make sure the current key is
> inside the bg range, and matches the type the free space info is using.
> 
> If the previous key is FREE_SPACE_EXTENT/BITMAP, make sure the current
> key doesn't overlap with the previous one, and type matches the previous
> one. This will allow tree-checker to catch most (but not all) bad key
> type flipping.
> 
> Qu Wenruo (3):
>   btrfs: tree-checker: extract the shared key check for free space
>     entries
>   btrfs: tree-checker: ensure free space tree entries won't overflow
>   btrfs: tree-checker: add more cross checks for free space tree

Reviewed-by: David Sterba <dsterba@suse.com>
