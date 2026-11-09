Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240628;
	b=jsBxoCtOpRKZb+B1Q0B7kbtyibae8BSroKa50hztBQPwCIQdxXI525yj56rvVM2jo3fp
	 39uYiv4XQ5sQWCOjrJ7Sf6RF7FYAqs+aKo6JWszPW0Oe7Nddd0nYqEA66P3v2HqciMEmk
	 maHE0AgaOeKkL0TJn6VSd6cyjLUiLgSa2YVHjBYqCB1XD0l5iewsqmu4M2xAClh9YRF6W
	 6nIJQvRCHlvt3k5M6C9yWTrE3vgRVI6M/dzM5kSRD+rV2OR6UQEWF+Wjhf0Pmtq9Sodch
	 L5jPmmJTLHm+oVmuviGXRyQVybfap9BDF6oxR7GzEKOeo9uIkHqVsjFikA72j5Zqlfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240628;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=Pr1xi1HH8uHC6edbp1hsKrezAH+AVkOPkCzG3pUfD0g=;
	b=aDEd6lKD7GyfoEhXMCfoWQbdwgCBJDaB28GKcrkv7bMYzI14YRTBEK981JUYUKZ6cSnb
	 GIBWyRgFkoPuDhxgZ0pzeLclXKNnkfU7zKCgAUpYVUQRNtteZacioi8/wL0jJ7Wytw8GS
	 ijvt3m+asMUcy9u0UM4W40gLhO8US7dpcXi9RVzO9j08oCmdFwgAm6eE7RCpIl4gYOiId
	 Vx1PGGeT+Oig2ZKo3OY6i5+rgOuDrG4H68wamFFycH21KzFf/QAGhDZEhTyleSmDxatWR
	 /B6L1AEFwEuXpq+i8g3yAZGRV0ypHe1afsgvIwIYKpnHy2tgVyLAQODWLOhWu0Gvk3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DI6YujNd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aZzApcgw;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mzRbj6SG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DlugkwaW;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CD7606A321;
	Mon,  9 Nov 2026 16:10:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25CD7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DI6YujNd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aZzApcgw;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mzRbj6SG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DlugkwaW
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A5A72219B;
	Mon,  9 Nov 2026 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794240626;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr1xi1HH8uHC6edbp1hsKrezAH+AVkOPkCzG3pUfD0g=;
	b=DI6YujNdSSKu3xxbPtJ+GcHiqPYCXu3h+Rd8zp0dVGabErVLhUufcwZ4u7Y7qezj6HJq55
	5WbcRKmgLupFLVHm/KCI0VmTNJY2g4obRXdSZ2S7Y+4epzMhChx/047ZY+IHeTiBBBDVk2
	yIDCQX3dguby/M352+f7vwygwQDJ05E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794240626;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr1xi1HH8uHC6edbp1hsKrezAH+AVkOPkCzG3pUfD0g=;
	b=aZzApcgwVsGppRpDJZ6H8PeiUWJ+qvZBOvTOMceC9LRPf6bSSYLWaLVVLF3uNpME02gXbd
	JfkTJX+ri7soyeDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794240625;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr1xi1HH8uHC6edbp1hsKrezAH+AVkOPkCzG3pUfD0g=;
	b=mzRbj6SG6DZ+nH/M9kh7e8ifFeBbJq+kJY2lBeQeveaNoA7ItFpX4sc+2yb9awl+jan8m2
	CiM3s0/MUh0SAim+F7ur6nCJ//OakZ/tR7xO4gtEvqkjc28zyZE4FTHMr+p9Fp2T7+4JWu
	9BP/8+bvt+iTK/h0wN3qDdkfiUlE7io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794240625;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr1xi1HH8uHC6edbp1hsKrezAH+AVkOPkCzG3pUfD0g=;
	b=DlugkwaWmYNVAl1UnKqMs0yv888xl3qbidfHDoHYI50We+NmW+hPGADNywLlDev1TR/KeO
	9ZEBoHQGljf8GJCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5FC513319;
	Mon,  9 Nov 2026 16:10:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Dvk2L3Dw8WoiVgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 09 Nov 2026 16:10:24 +0000
Date: Mon, 9 Nov 2026 17:10:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Chuck Lever <cel@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: fix FMODE_NOCMTIME handling in btrfs
Message-ID: <20261109161019.GC4186782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
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
In-Reply-To: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Score: -13.00

On Thu, Nov 05, 2026 at 03:07:41PM -0500, Jeff Layton wrote:
> I tested the delegated timestamp support in nfsd recently. That support
> relies heavily on FMODE_NOCMTIME, and I found several places where btrfs
> didn't handle that flag properly. This series seems to fix them for me.
> I tested mostly with the git regression testsuite, because it is very
> sensitive to subtle bugs in timestamp handling.
> 
> Please consider for v7.5.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> Jeff Layton (4):
>       btrfs: honor FMODE_NOCMTIME in btrfs_write_check()
>       btrfs: honor FMODE_NOCMTIME when punching holes
>       btrfs: honor FMODE_NOCMTIME in fallocate
>       btrfs: honor FMODE_NOCMTIME when cloning

There's a comment from sashiko for patch 4 regarding the unconditional
i_version update but this is mentioned in patch 3 as intentional. I
can't tell if it's a problem, it seems more like a suggestion for
cleanup. I'll add the series to for-next, please check if the question
is valid. Thanks.
