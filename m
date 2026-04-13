Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2FF370D54
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106114; cv=none; b=KI11xNxE1pJ83Ou75yv+YTez/1KAbC78OhHt6bPzYd5aKroT0yJNAfPIGjSidA+GoorqrDq3X/eVG2AJpawbVFye/WXk/z7G6jfoyoKjoPLQbZLJGEe7Rhjev+20T92HwC2SdT+Mbih68QYW2L9T/k91/EsLezDBHrqaxOscWuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106114; c=relaxed/simple;
	bh=X1jn2O4DCSqgcQOOAUtSvc4oVzdAeds40V9WurkBpHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fh62g67nRfLoIHdvvDDXhUOa7BtxJIEXOGjL0OufvL1ZvN9BQtZUjEbh101NMhY9WMgAS5VuuVBKmnyz+gVBG2NkME0JUEkvDCxEtVoRIz3+d1t7CC2GVx4MO70e86N6u67U9BhgegcHmwqrdWeUxCALMDo6t09WXiptwE+HOTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mENGRc46; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G0TKVGoV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mENGRc46; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G0TKVGoV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mENGRc46";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G0TKVGoV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mENGRc46";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G0TKVGoV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 49B585BD95;
	Mon, 13 Apr 2026 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776106110;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IbfseLa6Vu2gCBh3UNst00bKQOnqJpYr0uoUYpy8AHc=;
	b=mENGRc46GR1nKqbHT8fw8WwQWjU0zAUuCUJl9/7RExIHksjLStLHcSWiDz9TN0+rO0BFtq
	qoiuxTJUmrB9Z/ZVuXd0J8E2tT1i0vHe7iAtMTl+p5HyCsHzuj3WtQ/sZX3Ct9TyjuMTTj
	e/IJo9jEl10C6aA0xAI030WwT3LcK7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776106110;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IbfseLa6Vu2gCBh3UNst00bKQOnqJpYr0uoUYpy8AHc=;
	b=G0TKVGoVLJBJT86TGSMZA/JpS8NI9dMuZgkVMlZxQ36ZZrpB/KC44FiH+h0lwwUGV5ZyKj
	9YhmERZXvSl2FcDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mENGRc46;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G0TKVGoV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776106110;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IbfseLa6Vu2gCBh3UNst00bKQOnqJpYr0uoUYpy8AHc=;
	b=mENGRc46GR1nKqbHT8fw8WwQWjU0zAUuCUJl9/7RExIHksjLStLHcSWiDz9TN0+rO0BFtq
	qoiuxTJUmrB9Z/ZVuXd0J8E2tT1i0vHe7iAtMTl+p5HyCsHzuj3WtQ/sZX3Ct9TyjuMTTj
	e/IJo9jEl10C6aA0xAI030WwT3LcK7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776106110;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IbfseLa6Vu2gCBh3UNst00bKQOnqJpYr0uoUYpy8AHc=;
	b=G0TKVGoVLJBJT86TGSMZA/JpS8NI9dMuZgkVMlZxQ36ZZrpB/KC44FiH+h0lwwUGV5ZyKj
	9YhmERZXvSl2FcDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30BAD4B025;
	Mon, 13 Apr 2026 18:48:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WA24C3463WmwfAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 18:48:30 +0000
Date: Mon, 13 Apr 2026 20:48:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, Mark Harmstone <maharmstone@fb.com>
Subject: Re: [PATCH] btrfs: don't clobber errors in add_remap_tree_entries()
Message-ID: <20260413184829.GF12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260408131324.92442-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408131324.92442-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 49B585BD95

On Wed, Apr 08, 2026 at 02:13:20PM +0100, Mark Harmstone wrote:
> From: Mark Harmstone <maharmstone@fb.com>
> 
> In add_remap_tree_entries(), we only process a certain number of entries
> at a time, meaning we may need to loop.
> 
> But because we weren't checking the return value of btrfs_insert_empty_items()
> within the loop, this meant that if the last iteration of the loop
> succeeded but a previous iteration failed, we were erroneously returning
> 0.
> 
> Fix this by breaking the loop early if btrfs_insert_empty_items() fails.
> 
> Fixes: b56f35560b82 ("btrfs: handle setting up relocation of block group with remap-tree")
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Reviewed-by: David Sterba <dsterba@suse.com>
