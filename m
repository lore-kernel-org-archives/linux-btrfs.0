Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E282C032E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025823; cv=none; b=Bv/7TeVQJlTbptUalDOcu4cW89LX/3xwLImksLbswfBhFWv4f1e+UfdUkRaV8lSsAkDgIpdR/btXvKvbdXHHEs2Wo3VA+c9qZK8s2LagpJz2tB9cvoJkhetE0qNgJvS8WmvmlbQriBVJeMv7juOVAy2k6oNkSrofdJwX6UslZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025823; c=relaxed/simple;
	bh=2NnC86hAGMZbjzHhD6uMyBacYdxFuId21Sclib5Rv+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbxLThEvQrVbueBzvr60YblHxfQ+HJtJSBNz4LKsm8o17dGoRCv1TzRayblqsAEpHmmvgNRm00OpwDSlNeeabIcgjsnnZgfzQddUJemIjqSUPOWbAzQybDMnfblZSNRJES4i+V/iTdxqUYwCZwJ+0UVNOkHY/V0tpWqxIhHP33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lQso66ok; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IrpUOy5d; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HK1CXjtH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R2nzr75z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lQso66ok";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IrpUOy5d";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HK1CXjtH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R2nzr75z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB2035BD7B;
	Fri, 24 Apr 2026 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777025821;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qpyFtGT1ibohMYsS2zl0eFpMxw7LHT3lr3O5tldAnmw=;
	b=lQso66okkAvFzcyAXWOxRqpM9cNwQhyjOvwTfNagOVvl9eK4KYcA2flNHoNeOVIAYGULRN
	V8x7BS+9b4XKJASlZs++VaDcFIdjckRpKJ/W9qrNGLU85Wleq/Whmtqo53OmAc8hIpJS+S
	PR4G0dGDvnu05djorcmfzfC4JFgS+ac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777025821;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qpyFtGT1ibohMYsS2zl0eFpMxw7LHT3lr3O5tldAnmw=;
	b=IrpUOy5d+wUEJwo07zRs2w5dKkw5F/5sojRoJfmTYSNQltunP2SSKadZASA0yl/YtgTeYY
	QR7WJvaJkMHKO9CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777025820;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qpyFtGT1ibohMYsS2zl0eFpMxw7LHT3lr3O5tldAnmw=;
	b=HK1CXjtHUd6Lb1oFzAYZMzH38YSYSfOubHnQTvxz6FJrVX3CDOKgnrIn3Kz83eV4rnm/xl
	Fs9nrYzK5dX9LOFSBxyRTg85E9zhI2+PHJUsKU2ynktt9N47P1kqk9MHQBV7UPTnTNNO/b
	HjaZXUE6unyf2enXIVCdcMw0JTz+bS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777025820;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qpyFtGT1ibohMYsS2zl0eFpMxw7LHT3lr3O5tldAnmw=;
	b=R2nzr75zFmsMTgxQwvOV+gLt4vweIgIz977z3JpkqXJFTdjMVmJfSQJtOy6f93XRZvNYlt
	zBQZEx3q7MXNp8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0AE9593A4;
	Fri, 24 Apr 2026 10:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q1zULhxD62kacwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 24 Apr 2026 10:17:00 +0000
Date: Fri, 24 Apr 2026 12:16:55 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add missing unlikely to if branches leading to a
 DEBUG_WARN()
Message-ID: <20260424101655.GB3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3eb99befd57ed1a4df3c6d52b426bed2c5b2f1c5.1776944354.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3eb99befd57ed1a4df3c6d52b426bed2c5b2f1c5.1776944354.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:replyto];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Thu, Apr 23, 2026 at 12:39:33PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If statement branches that lead to a DEBUG_WARN() are unexpected to happen
> and in most places we surround their expressions with the unlikely tag,
> however a few places are missing. Add the unlikely tag to those missing
> places to make it explicit to a reader that it's not expected and to allow
> a compiler to generate better code.

I've updated the coding style docs, DEBUG_WARN or other messages qualify
for the unlikely() annotation in the branch condition.
