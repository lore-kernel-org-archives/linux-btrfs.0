Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769769;
	b=GJZiVYoW72y5N6E8lo+mOfe8yEoq6mz7ppSyhv6sieJzNuYvzzivI12nPmywOhA8IedC
	 U7wnlsuYRE8s8FtapbaqqSnl3vLyQvsT4s+hQifAtsnMA8DtCWJigcqr9y8QP6VLHtyWR
	 OEIca7FTbnzg51PRCBAvvF4ieiYWkfMnGyzM1sHjc+4ACtWsJSOvirK76hgid/3ubCo9t
	 RKlMoFNfx5Wz7ifEC8tYWQUn1J3j7I35WXswKbONY7r1VKET/VtzLl79X7JE5ZorVpDo1
	 rtzsOPvFB/GttBjY8MzJvNe4L41K3eRS2PcccA5jKYtHTswPp9U97A1wsMeidr+YJTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769769;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=el/iNndBSWTdd+fmLuxFqV0bntRy08pW/ElsLqnixow=;
	b=uj7cUS7npPCmH6D3VozfYjb5wTsaCWlmvyNXFGnCWd+ty5s7eV5qoKuWepxDukYDUIDf
	 4gAxkZlgBs8kZPCMIa/lzF0LjvNQkw69LYvACXYOqATlr2ksAyw0fa+u7rfypwopdKe7G
	 iTU8xUC3Cxeo3PYX2fv4zuUfPR/GbBsVhGCqSLjxBQsqYiWZTufXjwG9U7z5ehIcj/6Rz
	 PkDlpMIw8ET/ZaMv8TnUAwc4d/G1cwiCTlKzs8wI4s70D9505HPkMbzIIp2jKn9zg7nff
	 TQ4dgmjOd0mq8N5LoweDDlJG0rJ1oAu+nYzuzIrHUUhKm8K9YNntqDsOvm6H7wDKaIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eiLrnyMU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hq9PwbUx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eiLrnyMU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hq9PwbUx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BD6606A31B;
	Wed,  4 Nov 2026 05:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30BD6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eiLrnyMU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hq9PwbUx;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eiLrnyMU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hq9PwbUx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DAF11FB22;
	Wed,  4 Nov 2026 05:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793769767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el/iNndBSWTdd+fmLuxFqV0bntRy08pW/ElsLqnixow=;
	b=eiLrnyMUH7kSFhWH1CZTGbjpHa3svzH/i3eHUJEHMoOTVn+uy2up2OG1k553zLpHO2yow/
	RST1OZIdlOApuFjfFufl9gnBcMU4S5VUmxWYDkTqp7p5Apy4TfkvSr3Rir8V/67YcgKxKe
	LH3Cu5GCe+tOTarSZ/DyBkGjqxWtNfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793769767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el/iNndBSWTdd+fmLuxFqV0bntRy08pW/ElsLqnixow=;
	b=Hq9PwbUxLZ6p/CnyKmMauJrIBJc7yrZYTcGLRXSRhD7IX+5CmX/hbVKUxLyYl3f0DvTiZC
	T9AvykRj/zohOPAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eiLrnyMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hq9PwbUx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793769767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el/iNndBSWTdd+fmLuxFqV0bntRy08pW/ElsLqnixow=;
	b=eiLrnyMUH7kSFhWH1CZTGbjpHa3svzH/i3eHUJEHMoOTVn+uy2up2OG1k553zLpHO2yow/
	RST1OZIdlOApuFjfFufl9gnBcMU4S5VUmxWYDkTqp7p5Apy4TfkvSr3Rir8V/67YcgKxKe
	LH3Cu5GCe+tOTarSZ/DyBkGjqxWtNfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793769767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el/iNndBSWTdd+fmLuxFqV0bntRy08pW/ElsLqnixow=;
	b=Hq9PwbUxLZ6p/CnyKmMauJrIBJc7yrZYTcGLRXSRhD7IX+5CmX/hbVKUxLyYl3f0DvTiZC
	T9AvykRj/zohOPAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 639AB134A5;
	Wed,  4 Nov 2026 05:22:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SP89MCTB6mq3OwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 04 Nov 2026 05:22:45 +0000
Date: Wed, 4 Nov 2026 16:22:35 +1100
From: David Disseldorp <ddiss@suse.de>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana
 <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test compression attribute on filesystems
 mounted with nodatacow
Message-ID: <20261104162235.3bb19a1e.ddiss@suse.de>
In-Reply-To: <19d06a11c66590ec2a053781c79bf00e39361a70.1793648537.git.fdmanana@suse.com>
References: <19d06a11c66590ec2a053781c79bf00e39361a70.1793648537.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 5DAF11FB22

Looks good.
Reviewed-by: David Disseldorp <ddiss@suse.de>

On Mon,  2 Nov 2026 19:57:17 +0000, fdmanana@kernel.org wrote:

...

> +_require_chattr c
> +_require_chattr A

Nit: this could be collapsed into "_require_chattr cA"
It's not worth a v2 respin though.
