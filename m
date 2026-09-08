Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B7F5650E5;
	Tue,  8 Sep 2026 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882161; cv=none; b=YSsHD2XFN/aCEK1vB+FU0Z6tpHigzU+Myt/aCdetSiUAnmUc06JAYLHhYXA6oewdkGkUKVix70GlpwOhpOIiIs95Yku/dYyCsbP3gb4uwrlZQvJsOc/K17mhaSSqkNqvaoRTnLW/D21R/oHQzuFRXpYJEfr20f1Laf8/SvN98ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882161; c=relaxed/simple;
	bh=/WVmqUiXs8TRw4/8cQhpTrglQGUYAQYyK0ggqBZ89g0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHhRB5Wur3whaPUxGi6PoSKArRjvd8gMXTEzDwKx1xjV4xJS4W/MtOFP78Qx1NEdWo/sZci4x2XDMyHqQnXEBNMwL6tsVhwp5o0xjZ+puXus4JcISQaTnHUbBi7klWwbxwNyQ5CB8J3omLva5akvCI0prT71VPN3rSv+IuHeILk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sPVV8By1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QfJqMzDq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FQeV+JAz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gebdxQxj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sPVV8By1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QfJqMzDq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FQeV+JAz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gebdxQxj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA85F21ABA;
	Tue,  8 Sep 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788882158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvX/JgxO9fhyIDFoKbQezQkA6uxMS4QHCS2Ux2s9rm8=;
	b=sPVV8By1t+5w3EtMZxSi3H6dNh9swpuICu/QQO+CqJSgEXeAGhKZFEGFmNKr/pIp5uNN1o
	XCpuX6xNGUrFyaoHQpvrEIFXlBKcf1Fs1g/D/0YxroL2l51+N8nYhIXsJwmQgNj+KXSjKE
	dJebGBV+fADsGBh54F8ZpCmAU/PpLC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788882158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvX/JgxO9fhyIDFoKbQezQkA6uxMS4QHCS2Ux2s9rm8=;
	b=QfJqMzDqQt4XJRKXXec7rB/khB35NMe9JWk6LAh5m+Pbhron33h/mc9U56ysUZpHx6ITEH
	ou/9nuj0KWCMbHAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788882157;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvX/JgxO9fhyIDFoKbQezQkA6uxMS4QHCS2Ux2s9rm8=;
	b=FQeV+JAz6orONhAvkovfGbmQsjDuZl/BWGuwlsBbw08sQP50Jc/W8w/FZrnak7W3c36KpJ
	grBO2HksPQuxoZUHxCxH+jjMpAr+iCqprUvnRxnVjhvBIH0UVjiDUyAXVXmcdt1oRs8JFx
	TVbh0X9p3KF+UnrANKPGwYShswJUhBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788882157;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvX/JgxO9fhyIDFoKbQezQkA6uxMS4QHCS2Ux2s9rm8=;
	b=gebdxQxjKKK3Eg2FmdvHfomNYQsSDV+xqhYT6yZn+wLnrWrEMp4A689kwwp8hw4PaOWmwX
	XTzW2mo6qhplQQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AF7313332;
	Tue,  8 Sep 2026 15:42:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zdS7De0soGocVAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 08 Sep 2026 15:42:37 +0000
Date: Tue, 8 Sep 2026 17:42:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] btrfs: remove the free space inode ordered extent
 special cases
Message-ID: <20260908154231.GE9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
 <20260907-btrfs-remove-v1-space-cache-v1-12-5f9a5ba352a7@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-12-5f9a5ba352a7@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 07, 2026 at 09:19:27PM -0400, Tal Zussman wrote:
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -125,17 +125,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
>  	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
>  					   __TRANS_ATTACH |
>  					   __TRANS_JOIN |
> -					   __TRANS_JOIN_NOLOCK |
>  					   __TRANS_JOIN_NOSTART),
>  	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
>  					   __TRANS_ATTACH |
>  					   __TRANS_JOIN |
> -					   __TRANS_JOIN_NOLOCK |
>  					   __TRANS_JOIN_NOSTART),
>  	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
>  					   __TRANS_ATTACH |
>  					   __TRANS_JOIN |
> -					   __TRANS_JOIN_NOLOCK |
>  					   __TRANS_JOIN_NOSTART),
>  };

This touches the transaction engine, there was exception for the space
cache, I'm not sure if we want to remove it completely. At least it
would be good to separate the space cache usage and the the API in case
we'd want to restore it some day.
