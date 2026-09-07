Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761451DB92C;
	Mon,  7 Sep 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788803729; cv=none; b=IfQymx+iuqNK1yyckmStysTNKrxYrbzF3U/Imzuqph58xN2A8XlyjIH4PBbMY0Io8sEQv48q12Vz1x/1oK6tZAw21ZBwBkn+gAgrmMISG0vvxtvWx/BdDFod/lE+gMpxYCkyC/yoXfBNr2an3dcQLTm/xjJ9biq2nONWn6KABTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788803729; c=relaxed/simple;
	bh=6jTBPYflqa1vQJOqwx2yKV2RJaT9JQdKeHZXgs+UPOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMRlyM5XnGlY/KZcNTSy0dGXT6LkgcCwumzszt4WowWEqaY3ls+CcEy4a+Qa8S5hV7gi2O/JHLOK26TJKkqEiovdp5kjZyqr/6ZwlpEJO5PkD9bySpukRFfUpKPh9wH7t2b6eeSsfDCqUyX0AVrUXvdnURxJbVeOtSUcPxJNexs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZasPcsQf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uY5m+261; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3DEMEvRj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q8bBMGvE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZasPcsQf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uY5m+261";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3DEMEvRj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q8bBMGvE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CB9D21A71;
	Mon,  7 Sep 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788803722;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNB42et+DrFCAGYzSNyzYY2C1hLrWEIuF5SqSH8bPV8=;
	b=ZasPcsQfY5WcJsSttjQUnQbtr2mDq1XJn0JZi9M+zD5OWhXww6GqLT5MKb9CLB8cgOv+vR
	UlCF2nPOaW5Lr+O4gIVm8mfuEc4pEfYeTxUtmmApx4AZHRMhTyQpfm+tg1iz3sHSkV/wmV
	5z70L5CmP9d2jY7Lr3Pc/qim5SzoRoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788803722;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNB42et+DrFCAGYzSNyzYY2C1hLrWEIuF5SqSH8bPV8=;
	b=uY5m+2614PexWWqYJxhb3C1FC9dtb2czdVQygWxIFLBUzKeO+0uagCsS+7jnXjEAY1YXpv
	VUPsTEHlpoZGx0DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788803718;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNB42et+DrFCAGYzSNyzYY2C1hLrWEIuF5SqSH8bPV8=;
	b=3DEMEvRjWwQr2+FA17lRa4o+R7irKG6md4c+K0K4Y9pvW36Aw/XIrhUbABeJxGVBmVqQtE
	jfs4YatkWhCejVy3qI0pIBuvo3x6cVStdftE7iSVqjAbX51xxRW3XVO9I+JRtRaot/prb3
	4BrPvBpnTyUUPhMxoIoA+IEFpZl0vMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788803718;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNB42et+DrFCAGYzSNyzYY2C1hLrWEIuF5SqSH8bPV8=;
	b=q8bBMGvEFBdbanz+DlOzxl07EIROrRfGU/Z+7lFIE/j4Iw0zozZtJjGXHWDOKLP45XVnis
	hxUBBPFzwmvZd6BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BFB81339B;
	Mon,  7 Sep 2026 17:55:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lEKJCob6nmqqbwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 17:55:18 +0000
Date: Mon, 7 Sep 2026 19:55:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: fix io_uring encoded IO cleanup
Message-ID: <20260907175512.GZ9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
 <20260901020921.3261749-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901020921.3261749-1-yangxiuwei@kylinos.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,gmx.com,vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Tue, Sep 01, 2026 at 10:09:21AM +0800, Yang Xiuwei wrote:
> Hi,
> 
> On Wed, Aug 19, 2026, Yang Xiuwei wrote:
> > Fixes for the io_uring ENCODED_READ / ENCODED_WRITE cleanup paths.
> 
> Gentle ping on this v3 series.

I did a quick review and added it to linux-next for testing. Sashiko
does not have comments to your patchset but still points out some
existing problems, but this should not block this patchset. I'll have
another look and add it to for-next soonish.
