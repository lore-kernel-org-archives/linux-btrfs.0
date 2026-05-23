Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD0234964
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779554817; cv=none; b=KjKV3Rzj1GjeE+yeMtS+y3BwMONstFGGchzfLVhxgb2OWaric/fgRD4sCdzkuyJJPAbJlZsqeYyOpkENRtvmnkq3NjKUvqHa8WDhLbm3sp3j9ohuD6hAFvIXuW7cmUpNYog0hFhIZLVGURpFr5pUcQ65KvK6GzamgYyjLeTIRM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779554817; c=relaxed/simple;
	bh=1gJm20W3U9muLL8l9yPAmrOOuqsyaLxMKWDlfM7HgQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V81ayJek+JyBLMJ3ksIaQGGmonx1GjqV7SQbKcwW19o43juUnv3vIAclvK2D1B3QArXBObk15rZkWR1P4iVCtgxQCjC9amP42yK9/vCl5r4lYUTxpokDZEG2Gi3HqX24ZnojH0Fk+Z0kJaOuu4EuPz5YqYtWnpnDSvJ7t/ks87U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wa7hYV/x; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MIlBNIUm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mt8+f8vq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Of2t1Lyt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wa7hYV/x";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MIlBNIUm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mt8+f8vq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Of2t1Lyt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BABB96756C;
	Sat, 23 May 2026 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779554814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHLX3S5Qv2O7d8/QIJ75FpkwVAZO1fM6JhpZGN8aYDY=;
	b=wa7hYV/xLcHioQzNuKUW1HHbouPr8zHtO9aMP3t7erImEHzi4T/VoNK5juGvqzSrddmTBU
	SB+7LPM8+qN3SoqIMeie1AuSOURJ7XtcLCOSi3Q4SBop/PafLc/v25ay3jH5vOzi+rCBFT
	f1jqR2cPWiPORSQV87XwNj9voLKMYGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779554814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHLX3S5Qv2O7d8/QIJ75FpkwVAZO1fM6JhpZGN8aYDY=;
	b=MIlBNIUm6YwqhFWvOfW/AtVGd6kWA4qoM5CNnt0zgda/XWZ552HuHlFWu4gWniRPEY3vHI
	fmoxrwv+ivRsm7AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mt8+f8vq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Of2t1Lyt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779554813;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHLX3S5Qv2O7d8/QIJ75FpkwVAZO1fM6JhpZGN8aYDY=;
	b=mt8+f8vqNFMMQ8zPwUk5xis1XmQ1n/qtFxiXthuRIgmF5nxydPga9rMjoaazXkm/1WREWW
	u6wAeGeh0tb7LhqV65OUv6yOKXFv3U5pmczPFPn+ORG6Rai6qUnIFm1prWIyl1dEzdIlh9
	kV7DoTjPge8+3vVtHaIBrRU68qcS5p4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779554813;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHLX3S5Qv2O7d8/QIJ75FpkwVAZO1fM6JhpZGN8aYDY=;
	b=Of2t1LytY5rqgYTMYmijkGtjBkKT0QTWvccwJJSptdxSy2Ief081ffXGdmMISAdXMUdws0
	btqc6iaoqfu5UWCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F3C3593A8;
	Sat, 23 May 2026 16:46:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gc48Jv3ZEWp5MgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 16:46:53 +0000
Date: Sat, 23 May 2026 18:46:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Daan De Meyer <daan@amutable.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: add 32-bit compat ioctl for
 BTRFS_IOC_GET_SUBVOL_INFO
Message-ID: <20260523164648.GG183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260521075113.1079519-1-daan@amutable.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521075113.1079519-1-daan@amutable.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: BABB96756C
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
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email,amutable.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:replyto];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Thu, May 21, 2026 at 07:51:13AM +0000, Daan De Meyer wrote:
> On 64-bit kernels with 32-bit userspace, > struct btrfs_ioctl_timespec is
> laid out as 16 bytes (8B sec + 4B nsec + 4B trailing padding) instead of
> the 12 bytes a 32-bit userspace expects, because the surrounding struct
> is not packed. As a result, struct btrfs_ioctl_get_subvol_info_args has
> a different size and layout in 32-bit userspace than in the 64-bit
> kernel, and BTRFS_IOC_GET_SUBVOL_INFO returns garbage to 32-bit callers.
> 
> Mirror what was done for BTRFS_IOC_SET_RECEIVED_SUBVOL: add a packed
> btrfs_ioctl_get_subvol_info_args_32 with btrfs_ioctl_timespec_32 fields,
> define BTRFS_IOC_GET_SUBVOL_INFO_32 with that struct as the size
> argument, factor the existing handler into a shared _btrfs_ioctl_get_
> subvol_info() helper, and add btrfs_ioctl_get_subvol_info_32() which
> fills the kernel struct and translates field-by-field into the 32-bit
> struct before copy_to_user().
> 
> Signed-off-by: Daan De Meyer <daan@amutable.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Looks like the 64/32 combination is not much used (and not tested during
development) as the ioctl has been there for a long time and nobody
complained. The compat workaround is straightforward though. Thanks.
