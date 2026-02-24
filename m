Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EED3A7F54
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771953234; cv=none; b=MSo/X2HdU83QNLgN+xXGDTrILySsOD73vjxKdHhjlBCmkX/9j8bd5UiaM3dgn8FS1laSE3ih8Uomw2oVuq+E4Wxeye6nHMNOM64ky9nLLCxV05uXUZ960NEl9agNjkDLij2Z+odWb1No/WZ2sLYtG75HZlxGwBqWuRkkTgSYAbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771953234; c=relaxed/simple;
	bh=fOtM1NYpyPNpefFjnIL3j5uZCoFDWZ49WhpBjZtjzXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGg7/kpgVmas/N0kzbs6aaPVPikXX11z9JRgqfEvE9nE7y1dVREAIdgW6bhQGv5lBjizkN1417bE744pC3L3ml+rkutuLs0gbqdak9h8mYnry7C3jhdoL1jebKgjF59DBlckSbRQlRGpHu/Z6miUa+7xkpz2o7f39TpwGhTEOwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a8WnBQC7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pnSjwS+T; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a8WnBQC7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pnSjwS+T; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a8WnBQC7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pnSjwS+T";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a8WnBQC7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pnSjwS+T"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 881C95BCEC;
	Tue, 24 Feb 2026 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771953231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjECYfIh5yVaR0adKHPTl9qZ/X0plvwkWpHbKNt1m8Y=;
	b=a8WnBQC7kF36bXLqjFllLb5p8sUx65trIVClm/ec84A+Ec9/TxCJByOJxmogLKWK3shq8D
	a4nRrVh3foDct0gM2+ESovR8vFU6DOaiF6k3dqZuK4l1LyEzBNC8aTMFdO+2w8U/7hf0ua
	LIQRaMCB4QLKoNBFQKQQGJ0/hvceMBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771953231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjECYfIh5yVaR0adKHPTl9qZ/X0plvwkWpHbKNt1m8Y=;
	b=pnSjwS+T2WeqZUGy9fnZh/x4U+Wbv1VgJ6sDGV9kmiDB5+hn01zAIP8rXxaNY15wE2zYuH
	NOWaaGDODzGEbQCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771953231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjECYfIh5yVaR0adKHPTl9qZ/X0plvwkWpHbKNt1m8Y=;
	b=a8WnBQC7kF36bXLqjFllLb5p8sUx65trIVClm/ec84A+Ec9/TxCJByOJxmogLKWK3shq8D
	a4nRrVh3foDct0gM2+ESovR8vFU6DOaiF6k3dqZuK4l1LyEzBNC8aTMFdO+2w8U/7hf0ua
	LIQRaMCB4QLKoNBFQKQQGJ0/hvceMBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771953231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjECYfIh5yVaR0adKHPTl9qZ/X0plvwkWpHbKNt1m8Y=;
	b=pnSjwS+T2WeqZUGy9fnZh/x4U+Wbv1VgJ6sDGV9kmiDB5+hn01zAIP8rXxaNY15wE2zYuH
	NOWaaGDODzGEbQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 659693EA68;
	Tue, 24 Feb 2026 17:13:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pPOdGE/cnWmRfAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 24 Feb 2026 17:13:51 +0000
Date: Tue, 24 Feb 2026 18:13:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use inode->i_sb to calculate fs_info
Message-ID: <20260224171346.GA26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <djynzzkwdfzqq6rks5njvhjexmje2zoofffkx2qtectxlyv53f@r54cgbf5l2b3>
 <20260224165704.GY26902@twin.jikos.cz>
 <CAL3q7H4HZ1wJ_YHpPXcZOJ=UVSoKqncbkS+3e1D6PhMpzTpTJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4HZ1wJ_YHpPXcZOJ=UVSoKqncbkS+3e1D6PhMpzTpTJw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Feb 24, 2026 at 05:01:43PM +0000, Filipe Manana wrote:
> On Tue, Feb 24, 2026 at 4:57 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Mon, Feb 09, 2026 at 02:11:37PM -0500, Goldwyn Rodrigues wrote:
> > > If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
> > > super block and fsid assignment will lead to a crash.
> > >
> > > Use inode->i_sb to calculate btrfs_sb.
> > >
> > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >
> > Added to for-next, thanks.
> 
> There are review comments in v2:
> 
> https://lore.kernel.org/linux-btrfs/apsgauiwdj2exslcb7wmy2womtf6suyzfwatnxk75tzseivm4q@e7wktzgzxmsd/

My oversight, sorry, I'll remove the patch from for-next.
