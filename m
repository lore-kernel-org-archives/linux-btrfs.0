Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795449006;
	b=p8Ta01mgA+wKJqn166dovI2QYDWHdIFCWTn6X4l0ob0gXR8RkeTtYceo7OA/zG8taI7m
	 qW5hWrxV0RU8XdNKSHfvbYHmgf/PSwLmwUzubDDfFupqZGJiwKVaPedautuw8rLX+QQwP
	 unttm7d/wOleXLM7Ha+Wq+Zm4QdSwpqcXw8X3Sa3H1Z42255X/k8Jw/gck6d0B9TGyiqJ
	 2YDJemRrSbuXOmHCnYpAMY8wpSm+sP4Z91o/mTRSJ9QjTQCPG3EY6DFjQNthcYCemu3mW
	 ugN24twOeddGr3lUCI4XZYNrCEIeoaxtub5aBMm2xOvGXeyCHCJsuXsG80gWRNOZ4ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795449006;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=9fQwK+m5oIZXc7dkmlCcc1qaYi/2c14b1ccawdvINFI=;
	b=qJ8xk1b8OzaTGpWT1DZ+H3vG+BrWvmHGwl0IRQ4iLaVqt+AAqtyDmRadj9AJU0jTZT8S
	 9qDxHSrkp9NYlwS9Qkk2yen5rnWpKtVY4JGy+NGChyYAp01PtpuxZE1JqF09IXQ72AR6t
	 kI3j7jEEkwjRQf+KYyRi0wUtZmp7Ek7tMrXuZnB9lYURD91NbrTC6gsAQFMAAbLgT2ebO
	 WsdiBivzjkVggofs6oSur3crBlvvZTzSx1yCnsKXFCbasBjddnjAON950Gd3y4LgiTZsB
	 x6oMFNJhwEDDpR0+UGJbTnY3LlBO5YgrWfGTMiK1nRY8SvjSczhodn7BsBdRNDUXmLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=byOhV21B;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zzfa44qb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YQIKeht4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cYKRx+3a;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21250606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 15:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21250606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=byOhV21B;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zzfa44qb;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YQIKeht4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cYKRx+3a
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2366322001;
	Mon, 23 Nov 2026 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795449004;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fQwK+m5oIZXc7dkmlCcc1qaYi/2c14b1ccawdvINFI=;
	b=byOhV21BrnrggkFLYCbFoBdXl6saXPUUxu56yI+o2XDgourrWU46BkNxsw4kpIKAZIxSL0
	uGFYJTsCunXH9n+CzUbZPv1zJEPloXfMJryrx7Y2q1NK/BoDeJYxQr1Ve9N6EjUB6cO/HC
	4WONJQNZi62CzCkHtgzTZx+XVfa2j4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795449004;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fQwK+m5oIZXc7dkmlCcc1qaYi/2c14b1ccawdvINFI=;
	b=zzfa44qb0f1pw6oeoy8oRxZuXJUxNMESV0ag4eop2ofMO+mKx6aREW5WIE5MtERJrusScB
	sjAH1wQ2JCo8vaDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795449003;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fQwK+m5oIZXc7dkmlCcc1qaYi/2c14b1ccawdvINFI=;
	b=YQIKeht4srR5znrkeIttrh5yoU+Fc7LTJA1vi1z+xKp1IBOS/xUqDTnNyMsJP0HKq60uhf
	/tgm0lI5/c0yXxFnHSHoKS2WYw2itG9nRlwUTZNTOxLOVnFkoKjm5NC/5b9X1jQ5PtoBvn
	bTKDS9BWTWDFEX5x8FKTkLfamdq1stc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795449003;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fQwK+m5oIZXc7dkmlCcc1qaYi/2c14b1ccawdvINFI=;
	b=cYKRx+3ajNALi0VY6DDdb97/09T2PtArsv9B9tg2rvVkef9zfNmwWOq6oCykj3Ahp3yJDw
	NcXmPeDVRU3WUOCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED5E51352B;
	Mon, 23 Nov 2026 15:50:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kyRjMapgBGucLwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Nov 2026 15:50:02 +0000
Date: Mon, 23 Nov 2026 16:50:01 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: cleanup some use of boolean struct members
Message-ID: <20261123155001.GB3245297@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1795433118.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795433118.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.00

On Mon, Nov 23, 2026 at 11:27:23AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Trivial, details in the change logs.
> 
> Filipe Manana (3):
>   btrfs: assign boolean literals to fragmented field of btrfs_free_cluster
>   btrfs: use boolean types in struct btrfs_dev_replace
>   btrfs: use boolean type for struct btrfs_device::dev_stats_valid

Reviewed-by: David Sterba <dsterba@suse.com>
