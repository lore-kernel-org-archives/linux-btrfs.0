Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F84A8426;
	Fri, 11 Sep 2026 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150325; cv=none; b=dI8L/VnQBm+ZlhvNG6oVwjleRWIpRZC4fgUV26+L/Omh4fWqpjviwYrrytXBeGpipnHJZb3Al6D3e5MZEazcNZCZm3crYjfLTsXJMpgajUwLuf3YPFsP6Tb3yJemVsfDh5//GM9xnsMIY5BhXcGuoGEhDWI9p8YjtZWvNhsLlT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150325; c=relaxed/simple;
	bh=JftqGOaqgr7dU0x1t6YZMM5cyKQ5++aHATyFOl9v58c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/q8aY8TsJZeoLfYVyAXiOcyNDJDyNym+3hQJeTpYUu9JUtsSr4SWzuBnTbOtemgoJ7PhjYioGv9Ejuho0E7vRGvcUKkBFMlQVUgmE2TPznhuRSA5qc67dQ/8ZgXTvfFh0LAFGb8pKUqogkBIg7TO3kMsPzd+tAezMmkVmj7/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ORSKkg4g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qf8oeHsZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=phbCJ6de; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mb1IEYsc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ORSKkg4g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qf8oeHsZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="phbCJ6de";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mb1IEYsc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BCF41FB40;
	Fri, 11 Sep 2026 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789150312;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7D0fhQrwvyjSXWm8XugRBBmpPAvcOLfcr+xNLIXwyc=;
	b=ORSKkg4gqUfvZmNpLUe4eJN8t2KIOS5+HPOI44S1rZ9Kf67cLRMCDrNU7OzdWNSAI1BnS1
	auY0CRtVpOk4TLt6/qe9PG33FEd0dcxapReOmw2zxtYM6Pim3OhV+TCvbn8FvAgOeUqWaG
	rcAm+XXrbo5DP8MmQweg18VwQ80ZSx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789150312;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7D0fhQrwvyjSXWm8XugRBBmpPAvcOLfcr+xNLIXwyc=;
	b=qf8oeHsZuFBcfWNzSa6A+gyHjtSq4fpIrt5KkSj4j2Z2xpLk6uGHmoOWw4TUvK+xzbNBfd
	eALmz3AER9/TbAAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=phbCJ6de;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mb1IEYsc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789150308;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7D0fhQrwvyjSXWm8XugRBBmpPAvcOLfcr+xNLIXwyc=;
	b=phbCJ6de7JSJtb3W/RkKgtrP/WIe9OoVY1alX6RXEsPAEtMKsFUDAj2jkWDP8+TVq2wRue
	fpuQpYYjQQG3s+DLosJZA094nePBAEgq+BKfzb6aH2nu7yHqYBqt0TDAWtLb80noav6StU
	ulkC08RYYi1CYSt0wdFXkU4kJxHR8bs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789150308;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7D0fhQrwvyjSXWm8XugRBBmpPAvcOLfcr+xNLIXwyc=;
	b=Mb1IEYsck6/sD8GcsDycrajrnkoH2aBjWIPjbM0IPXla0siGqneo4IeZbNZdX5CWgwwwFz
	A2VvpW/dLQgnL0Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46EB5136ED;
	Fri, 11 Sep 2026 18:11:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jD8VEWREpGpPXwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 11 Sep 2026 18:11:48 +0000
Date: Fri, 11 Sep 2026 20:11:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>, dsterba@suse.cz,
	quwenruo.btrfs@gmx.com, linux-kernel@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
Message-ID: <20260911181146.GD54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
 <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Rspamd-Queue-Id: 7BCF41FB40
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.com];
	FREEMAIL_CC(0.00)[gmail.com,suse.cz,gmx.com,vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kernelorg];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid]
X-Spam-Flag: NO

On Thu, Sep 10, 2026 at 07:28:39AM +0930, Qu Wenruo wrote:
> 在 2026/9/9 23:48, Hanabishi 写道:
> > Hello.
> > 
> > May I ask why you guys keep ignoring me completely?
> 
> If you think we have time to reply every report, then just check how 
> many syzbot reports are not addressed.
> 
> > This is clearly a regression for userspace (see my previous reports).
> 
> Unfortunately it's not.

Are we looking at the same reports??? "My system does not boot after
update" is a regression.

> The problem is there no matter if you have that patch.
> 
> There are a lot of ways to make btrfs to report a weird device path even 
> before that commit.
> > If your answer is "won't fix", state it explicitly please.
> 
> Won't fix.

Can't be, for the same reason the bug 218353 was a regression and had to
be fixed.
