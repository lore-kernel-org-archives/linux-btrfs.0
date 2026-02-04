Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4014274FC1
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770215473; cv=none; b=KBSv/zDS2woYnNKfuQQWPDdaAb9aOneY/PahqTPWCPSq2Zoc4P6oCrjbI0xE+hpt231cONeKu5MLD0T28WweWbyCf1UOJFjJ1Q/hgq8VBooPFvj9kmsJahDd9Ez8mf1jZ1aOOUQhJg+uEIPlaKB4AFn9M5K/K+rxby3cMsj2yMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770215473; c=relaxed/simple;
	bh=Y8AouwK9zlzjrIVImuW44nyoX81qDQp2LQ9mkor965o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGTLF7y2gxlMdXpBi56brVKZSbTw8Ns5Is7Iip+Jr4WSU201t2LUG0nzey30y1c0kAHUcEU5lbdYnYe5Da1V0Xx5K9PcaBZDyyQtAPaMwR+Eja597zCQLK58W1oDEWt7XrXRafOe4D1b40X/9meQ4FPjQxlv3A7O3jDdRB8IJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g6jt0Fqa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oPjXXQJ8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g6jt0Fqa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oPjXXQJ8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g6jt0Fqa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oPjXXQJ8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g6jt0Fqa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oPjXXQJ8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C4A35BD3F;
	Wed,  4 Feb 2026 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770215471;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7S65865Z93CiY0+tSEAhtbLqOpDw/VQ1gH3OCXLXs=;
	b=g6jt0FqaH7IZ8dftiCjtm8TJlDhjI4xvQkaIfwyqvXUPTPWeyfy3B44nBS/TkNM7wA/WC1
	TQ2BO+9uvBhTJzi/knHyEVr1PgQ0zJfTa/h/knt/9/DLNU60VaesYsO36GT8ImOVxlHUj9
	dUgamNllzjTYpZvVHpr0d00MA2hChZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770215471;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7S65865Z93CiY0+tSEAhtbLqOpDw/VQ1gH3OCXLXs=;
	b=oPjXXQJ8FY2MbCDYKS25wKm2T5FzdsK1MnCsuFG/Be1EA/pICd8SgWABVR71Bd8AqpjSiu
	VciUOrBa/lpbElDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770215471;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7S65865Z93CiY0+tSEAhtbLqOpDw/VQ1gH3OCXLXs=;
	b=g6jt0FqaH7IZ8dftiCjtm8TJlDhjI4xvQkaIfwyqvXUPTPWeyfy3B44nBS/TkNM7wA/WC1
	TQ2BO+9uvBhTJzi/knHyEVr1PgQ0zJfTa/h/knt/9/DLNU60VaesYsO36GT8ImOVxlHUj9
	dUgamNllzjTYpZvVHpr0d00MA2hChZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770215471;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7S65865Z93CiY0+tSEAhtbLqOpDw/VQ1gH3OCXLXs=;
	b=oPjXXQJ8FY2MbCDYKS25wKm2T5FzdsK1MnCsuFG/Be1EA/pICd8SgWABVR71Bd8AqpjSiu
	VciUOrBa/lpbElDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 173E33EA63;
	Wed,  4 Feb 2026 14:31:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hFWIBS9Yg2mPZQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 04 Feb 2026 14:31:11 +0000
Date: Wed, 4 Feb 2026 15:31:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Jingkai Tan <contact@jingk.ai>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: handle return value assignment in
 btrfs_finish_extent_commit()
Message-ID: <20260204143105.GS26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3de1ff71-2c74-4dd8-a69f-25c80a313425@suse.com>
 <20260122212244.19518-1-contact@jingk.ai>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122212244.19518-1-contact@jingk.ai>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Thu, Jan 22, 2026 at 09:14:10PM +0000, Jingkai Tan wrote:
> Coverity (ID: 1226842) reported that the return value of
> btrfs_discard_extent() is assigned to ret but is immediately
> overwritten by unpin_extent_range() without being checked.
> 
> Use the same error handling that is used for btrfs_discard_extent
> in extent-tree.c
> 
> Signed-off-by: Jingkai Tan <contact@jingk.ai>
> ---
>  Thanks for the feedback Wenruo. Updated to use the same error handling
>  as the call to btrfs_discard_extent further down in
>  btrfs_finish_extent_commit.

Added to for-next, thanks. I was thinking if we want to report the error
at all, ie. not checking the error value at all but a report seems
better also because it's done in the other part of the function.

>  Apologies as I have just started learning how to contribute to the linux
>  kernel and am looking for relatively simple low hanging fruits to
>  familarize myself with the process.

I did a minor simplification to your patch, the errstr variable is not
needed. You can send a separate patch to do the same in the other loop
in btrfs_finish_extent_commit() for consistency. Thanks.
