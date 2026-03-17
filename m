Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E007C3E5ED6
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765273; cv=none; b=Z03sikLRAldLEwEm4izfIsQwmWe/od5/ftbrN7xcj/oVdtGOTdgadqqSJthYCM7U5ZDHuhVNKmCYzADj8o+H6iF7+ehtW+iP7oq0ar5WlWNyS3W/OZHyem5M6l/vxSoLjany2JVZ3dYrsVDacsq3lVzJynF7NIoUHpXEjrkQfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765273; c=relaxed/simple;
	bh=GlE06TKs9RbDWNy0Sk4+l3d2oAqsAhKHXSYjB4MovJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6Wc32x6b4DP1npAyiFIfzpAt/m36G4wbHfqOqxzZ2F/unazS04ES56SYeFm6zYiWTCZHRtU1So7OoehsOycBS1OEMM214nQoyscYozeL9GNtLyM0bXSsBHVhd1EnUVix617dafS3kCpfrFnYU+5/2gj8LZ86PlmBp/GXKcZzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rfne/hnM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qz3r1WVC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rfne/hnM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qz3r1WVC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rfne/hnM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qz3r1WVC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rfne/hnM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qz3r1WVC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F4375BE01;
	Tue, 17 Mar 2026 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765270;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKMCDoNN4jb9CSi6NRsQWv/MWIuRrS+54sb5jX+8RRM=;
	b=rfne/hnMEpN/HwrPsbG4APjXq7zhLTsiq8ur8lItywNK3j/MqhotOsbUg70AAoYF029XJu
	d2Gm4A/3b2B7oA2x5UzDu3QlY+v7ZtryaxRffmyv0VANI/gce4Zqbgywb7Ec7730d2w9AB
	i7Ptf+/1qhVUhEUMdEk/6NVHG+6HIqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765270;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKMCDoNN4jb9CSi6NRsQWv/MWIuRrS+54sb5jX+8RRM=;
	b=Qz3r1WVCQw3RR5cfVBS1oWKDpE1dq85N15bH0vyi+jTBOq54ko3uvy95ymjbxYtKJPUWss
	sPpc2u+NNeY9owCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765270;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKMCDoNN4jb9CSi6NRsQWv/MWIuRrS+54sb5jX+8RRM=;
	b=rfne/hnMEpN/HwrPsbG4APjXq7zhLTsiq8ur8lItywNK3j/MqhotOsbUg70AAoYF029XJu
	d2Gm4A/3b2B7oA2x5UzDu3QlY+v7ZtryaxRffmyv0VANI/gce4Zqbgywb7Ec7730d2w9AB
	i7Ptf+/1qhVUhEUMdEk/6NVHG+6HIqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765270;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKMCDoNN4jb9CSi6NRsQWv/MWIuRrS+54sb5jX+8RRM=;
	b=Qz3r1WVCQw3RR5cfVBS1oWKDpE1dq85N15bH0vyi+jTBOq54ko3uvy95ymjbxYtKJPUWss
	sPpc2u+NNeY9owCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 292F44273C;
	Tue, 17 Mar 2026 16:34:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ibDmCZaCuWk5BgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:34:30 +0000
Date: Tue, 17 Mar 2026 17:34:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 6.19
Message-ID: <20260317163424.GY5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260213185647.21966-1-dsterba@suse.com>
 <ced007c60ff226a2988f388c9389c240c8057843.camel@scientia.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ced007c60ff226a2988f388c9389c240c8057843.camel@scientia.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Feb 14, 2026 at 03:18:51AM +0100, Christoph Anton Mitterer wrote:
> On Fri, 2026-02-13 at 19:56 +0100, David Sterba wrote:
> >   * make block-group-tree default (support since linux 6.1), use -O
> > ^bgt to
> >     unset it for backward compatibility
> 
> I guess that also mean that this is now considered stable and has been
> very well tested?

Yes, the bgt feature has been part of the fstests runs.

> How about migrating an existing fs to use the block-group-tree (with
> btrfstune --convert-to-block-group-tree)... has that also been well
> tested and is considered safe to be used on filesystems with precious
> data?

The in-place conversions are a bit more tricky as they start from an
existing filesystem and there's a possibility of finding some corner
case. Last time this was in 6.15.

It should be doable to test the conversion using device mapper snapshot
devices on an existing valuable filesystem without destroying it.
