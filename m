Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC01C13B7AE
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779556534; cv=none; b=mzAdWd8iydojpm0c+7yzfZoJKBqgDBXkn77pjRNBh/XxIn5IKIhVaIAmPgIwgHPwK39N8mPiiI6u7xgrnBUrMMkD4f8VZFkPPqGMTEBO1YInf6bHaPEnb0As9hWd1411mpjUOisVxgJ+cBlWGuOhD0cCgg/F0oB/KWrtftuhhqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779556534; c=relaxed/simple;
	bh=4Jk1zYbZWYgq+dBy8p1r7f3mhJTPOu5yZBUptSL975s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/Dmh/7tdxg+nj4t6dE6wLnQQoICA1Pchuhx6vAUWTNkCTfU4XC8bY5gJqqN7P+lKLlFzHiDN/mRgQ4UnmnrYcfbk4cJBOvPmI3J0pU+pamB+djwNLlBTnRjPo8dY7U6r3PbDXsnjT28D9B5ryavBvNo6FPGgcz2SkDPyVNIyxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MD0/jkfq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n7cmcls0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uV+/apSO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kNgVW5rA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MD0/jkfq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n7cmcls0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uV+/apSO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kNgVW5rA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8FF76B209;
	Sat, 23 May 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779556530;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sjvplRMC+Ol5QSNGMZ9PUj8oejXdybaonAY3KcIZ2s=;
	b=MD0/jkfqFqdQNGZF0LxrLpFenBxvEdOeXkueMoDBWBi3BveNu0ME041OYMavNnsOliSpnM
	d8wv75cDcLZZYnwICGavB+WZCF35YWSje0BpA6q0VtxDGs8hXvqKWcHtQ0ZoAeZtIhF8ij
	a3iAnaAusgfbvSufKj9xg7Mggvd7iMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779556530;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sjvplRMC+Ol5QSNGMZ9PUj8oejXdybaonAY3KcIZ2s=;
	b=n7cmcls0hCtmqwKxk4YiFYG9MnCybQ7Q1ivIGikzEsU8bWR/6RHIKuAm6nvYqE06H/z6F9
	1MC6t16SkOq3enAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uV+/apSO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kNgVW5rA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779556529;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sjvplRMC+Ol5QSNGMZ9PUj8oejXdybaonAY3KcIZ2s=;
	b=uV+/apSOEmfvZRCNrqd6bSC4HH7CFZNHRMALiLHywBtRowgBDZkU6bOitoSxFqkd5Npqff
	2aa4a0p+EJRttrpUzWmJtqVejNLXFHx4kjihVOwtCArpV2pDJEzFdmdL1U2bIip8c03eFz
	5HWR6+RjLbrUHVerTd7zXTt0mbmZ+5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779556529;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sjvplRMC+Ol5QSNGMZ9PUj8oejXdybaonAY3KcIZ2s=;
	b=kNgVW5rADtIgOckATPsOqRhdQZNYiyiAyRNn+HjXuWmLITd6ecnOM9ZaT8pWpBufYNdFQm
	2Qyxil5ILRHNvEDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD069593A8;
	Sat, 23 May 2026 17:15:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rZrRMbHgEWocTAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 17:15:29 +0000
Date: Sat, 23 May 2026 19:15:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Filipe Manana <fdmanana@kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/28] btrfs: add trace events for fsync and inode logging
Message-ID: <20260523171528.GI183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778776706.git.fdmanana@suse.com>
 <7244807c-dc19-4b24-bdf0-ea9853641c44@wdc.com>
 <CAL3q7H6kzbbbrN-C5_v2_rjeOVFS3=nW5gM2urXsRJKtHx7-_Q@mail.gmail.com>
 <42fef513-7db0-428e-8a07-642514cf0abb@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42fef513-7db0-428e-8a07-642514cf0abb@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: D8FF76B209
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Tue, May 19, 2026 at 05:48:46PM +0200, Johannes Thumshirn wrote:
> On 5/19/26 12:13 PM, Filipe Manana wrote:
> > On Tue, May 19, 2026 at 10:59 AM Johannes Thumshirn
> > <johannes.thumshirn@wdc.com> wrote:
> >> Are we considering tracepoints an ABI? I hope not, but if we do patch
> >> 2/28 won't work.
> > They are not:
> >
> > https://www.kernel.org/doc/html/v5.17/bpf/bpf_design_QA.html#q-are-tracepoints-part-of-the-stable-abi
> 
> 
> I know that, but some subsystems do (I think VFS).

For btrfs we've tried to keep the tracepoints stable if possible but it's
not guaranteed to never change. Some people have complained in the past though.
