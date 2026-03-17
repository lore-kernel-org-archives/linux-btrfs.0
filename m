Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E33EF64D
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765802; cv=none; b=r6mAcJjpIQKK+DbMoMj6BR6IMwEqPI4H8nQAmm+ZiEiZYA0adpGqg1rZyhBSvxVWbtjfD0dERMuQR66xLWlGer48E61EpoCwfEvqaAQtbmz+6Z+6KzcVt0870Pslf8XgSQcP/nClQXIBqWffB5t/VfqzSmvUOQVDKGEGqO9Tfuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765802; c=relaxed/simple;
	bh=ZXhY6cUSQwgP8H3BOpR9P+D5/7zR6q8zB94SMbFrNUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2pymThj4Tc7KON/3VdsvkwaUsfWqZOEgJYKB+yQy0BOo2SkWyhNSR5QOc69isXJ7TMAeIoxriufh2N15LQLkzwTlI+c7IzT5vlvXF6DZagLgcl9h/6vUY2Vwys26Kx1cCPbi1vaP4MZgwPpejQ/RzuIYFOPPcnBNyn9yUIaLIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KpmGgDcN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0VpLgLz0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KpmGgDcN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0VpLgLz0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KpmGgDcN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0VpLgLz0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KpmGgDcN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0VpLgLz0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BB135BDAC;
	Tue, 17 Mar 2026 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765798;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vz/Zlz+QDkMxIm/xjEdIGVw7zg7jXnVstfH7pADBA4=;
	b=KpmGgDcNs5ZnTHRLpb+LwUdoVSukq/tNjUEMZU1iC1lixg0cHjYK1rCo2ahyekW0Y0fRnR
	XpYK8R6yhZR4xgFeD+N95PPu2y2joakBHEp9Qiskzdi2Uoe6tOqr+5HinMeTR6/vPM0bJm
	ngrWr2QP0k8oa04zM2xjrJuB/PXt0Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765798;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vz/Zlz+QDkMxIm/xjEdIGVw7zg7jXnVstfH7pADBA4=;
	b=0VpLgLz0Iu2Tr5BQG0gizIMRTPQUJ35D92SlfO6og6bHFuJXyWr+Kcgkk4eDoMDO9bVSJy
	Zxw3DGhOIhNRAbAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KpmGgDcN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0VpLgLz0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765798;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vz/Zlz+QDkMxIm/xjEdIGVw7zg7jXnVstfH7pADBA4=;
	b=KpmGgDcNs5ZnTHRLpb+LwUdoVSukq/tNjUEMZU1iC1lixg0cHjYK1rCo2ahyekW0Y0fRnR
	XpYK8R6yhZR4xgFeD+N95PPu2y2joakBHEp9Qiskzdi2Uoe6tOqr+5HinMeTR6/vPM0bJm
	ngrWr2QP0k8oa04zM2xjrJuB/PXt0Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765798;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vz/Zlz+QDkMxIm/xjEdIGVw7zg7jXnVstfH7pADBA4=;
	b=0VpLgLz0Iu2Tr5BQG0gizIMRTPQUJ35D92SlfO6og6bHFuJXyWr+Kcgkk4eDoMDO9bVSJy
	Zxw3DGhOIhNRAbAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 622E24273B;
	Tue, 17 Mar 2026 16:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UTbMF6aEuWmSDwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:43:18 +0000
Date: Tue, 17 Mar 2026 17:43:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: fix dropped 'const' qualifiers exposed
 by the latest GCC (15.2.1)
Message-ID: <20260317164317.GA5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1771801832.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1771801832.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7BB135BDAC

On Mon, Feb 23, 2026 at 09:42:57AM +1030, Qu Wenruo wrote:
> It looks lile the latest gcc has taken the 'const' qualifier checks one
> step further, a char pointer that points into a string that has 'const'
> qualifier should also has 'const'.
> 
> This will expose unexpected modification like the following:
> 
>  void my_func(const char *options)
>  {
>          char *dot;
> 
>          dot = strchr(options, '.');
>          if (!dot)
>                  *dot = '\0';
>  }
> 
> In above example, @dot is either NULL or points to a location inside
> @options. For the later case, since @dot itself is not const, we can
> modify the content, resulting modification of the content of @options.
> The latest GCC is able to detect such proxy modification and gives us
> warning on them.
> 
> And in fact, btrfs-progs has exactly such proxied modification in
> bconf_save_param(), fixed in the last patch by dropping the 'const'
> quailifer.
> 
> Other than that, most are just false alerts and we can fix them by
> adding a const quailifer.
> 
> Qu Wenruo (3):
>   btrfs-progs: enhance find_option()
>   btrfs-progs: constify the @dots variable inside parse_range_u64()
>   btrfs-progs: drop the 'const' qualifier from bconf_save_param()

Added to devel, thanks.
