Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E53A63E8
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779546229; cv=none; b=fxSHR2KsKnERUGRhGPaLwcDoK3mFFvLVRhRjm26SSP0/qrn44xXm6kPj5wLAtxQYVsrL01CklIYMOfUPVOWFvfRBqK6WL6cWgvr03yfY50VmzF8es4+HlER504/YC0Hlb0RurUP2/fxuzWhiRrieCt9cUww8TDYAk/kW8OTzdoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779546229; c=relaxed/simple;
	bh=lFtgVx+wwbwYLCj0QlJQ6NEwiNgXqzdehOO4MLBZAEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqsLP0LL/FIgGjMeJw6BSjWPPNJldFo1HgKKWENSCpXq99NVql7hu4WfTTpjaiyvt9DHsFCtjV+zZvks1kj3fZRkD9KbeTd566eZiH4/LGdEoNhldLL02bG/1DH0C2+QtfTvH1KiJ1UrUpFuWYPNw5UychGc72zTZGzW7Y7Jw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TIwDO4PU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CBu6SuFO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gAiGFxzW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hRcQbg3Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TIwDO4PU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CBu6SuFO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gAiGFxzW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hRcQbg3Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F45B6AA39;
	Sat, 23 May 2026 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779546226;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ZNvb8RVD/E5U7E3XBWXnJGGsVuQxOqNMEQE51MkUg=;
	b=TIwDO4PUKDPvzHk4ToWdpolRdU/Qd/wGYJJA75q3qR6c7JS5lQILLzdRtI5XHuZaB2qGu+
	4vkR1I0wN0iwZvKOh8PwhpYZLOs8bYH/5w/pbEP5eqUZqYATWuKEOfZQMp5gSeux8E4yAY
	YmShM39GlO/8RYNmSgYOQOr64YBwtQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779546226;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ZNvb8RVD/E5U7E3XBWXnJGGsVuQxOqNMEQE51MkUg=;
	b=CBu6SuFOjOyQ0uvCUXmA7zSlhEs5PCTiouXaYWuTQdaE3q05+dD+/LPIcog1zDaxCY+w+O
	sQSW7JTUBFE9TmCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779546225;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ZNvb8RVD/E5U7E3XBWXnJGGsVuQxOqNMEQE51MkUg=;
	b=gAiGFxzWXDryPmXB+xSDVqN/Ejx+d4suOU9FeGgjngOd1RQzfN69G21C5yJugOeG5/sgnz
	voQ7RtSv0OD6zypKYYW0IDgfxb7YwxrBRFJ5Ro0UubBgd2aExlhtnLD7LtVkKPO7mGZXX/
	lFPr3Eg/bAATG4C04eSdmlK/GtfDCkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779546225;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ZNvb8RVD/E5U7E3XBWXnJGGsVuQxOqNMEQE51MkUg=;
	b=hRcQbg3ZmwQcB07aMKqKU++01wjZj9x0eFqTXQ8345sMf+4eQj0ubsa0lrTFe+d+1DPfRr
	Hlswk7//t3zZulBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C347593A8;
	Sat, 23 May 2026 14:23:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dJu5FXG4EWr9LQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 14:23:45 +0000
Date: Sat, 23 May 2026 16:23:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260523142344.GC183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
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
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
> Recently kernel RAID56 lib is trying to remove the unexpected
> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
> btrfs still supports such setup, which means in the long run btrfs has
> to handle such corner case by ourselves.
> 
> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
> P/Q stripes all match each other, rotation also makes no difference.
> 
> This patch will disguise those single-data-RAID56 chunks as
> RAID1/RAID1C3 chunks.

I don't think this is the right way to fix it. Calculations are an
implementation detail and should be done at the time of the xor_gen or
raid6_call, not touching the upper level structures related to format.

Instead, please add helpers that take the same parameters and do the
switch if there's the edge case of raid5 or raid6, using memcpy. Thanks.
