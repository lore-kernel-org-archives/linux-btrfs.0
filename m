Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05E4FECF9
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 13:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789566774; cv=none; b=Os4oifP3eEK3vgbsX3XvrWhHjlzgJzeao2Wiedl1tci7pW/81MozEPDQ/sDxwBTEAMvnyXO3TU9H1GqrWCeicaB8/6/qs89prB4TCK6Tb+Mlz6YXGNsKWQ2mXEMZdeqtZ339KvuuKiiHuC8NeejpcXnMM7t+vGyuHEtxA+NIhfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789566774; c=relaxed/simple;
	bh=bU1AXnE7C+3sl00tGzuZIXLJOBd9m0HjPzALaj2PYKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvY4PHsowVL1QQ7zG+23Kv/RtO/VWiv69AU2rDS5Xcyljh1XSd4ClDD75K+x+AKGoRgOD8m3HL6BnoOaOHI/2JMEJhg9oJitbzCTNWKSf9e4nDEYCx6EZegokfgUuVFnhJ2CgCN0oYnt23xhnTUnjmvzf2HlycOkXslsQiAAmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RTqFHGUe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YfhLeMTe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t4ZoQ+tu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=koyJxGbD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RTqFHGUe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YfhLeMTe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t4ZoQ+tu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="koyJxGbD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC23D21D80;
	Wed, 16 Sep 2026 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789566762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kV/XRO0a8S5ZTud6UkyyjGjjkh9LbfqQ63gVtApcUh4=;
	b=RTqFHGUeBMZNf5Kt11USEwDlSFJB3HztUcjAs8QgIr2D2/EQJUTdwyabzqNtRgbeMs0TOq
	CtgSxfU46vAdYIYhWxbiAhE3Zd4F8B+uBqbbetypmPJfgn8lHmgzK8/nKkJv0u4Ca0tuCT
	zj7rDKMwtRddCv3YJ/hUGPEOhOyT1i8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789566762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kV/XRO0a8S5ZTud6UkyyjGjjkh9LbfqQ63gVtApcUh4=;
	b=YfhLeMTefJulXjtakW948KT7GizQGvrsfFwG5EcM2pfX2Z8vJF6poWhYgMjmFpjYi1PDE3
	VOI3FHjWlygFMICQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789566757;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kV/XRO0a8S5ZTud6UkyyjGjjkh9LbfqQ63gVtApcUh4=;
	b=t4ZoQ+tuFTSXbcyrUqpWL1Yc13WCYSPGiQxR70OGGNG8Ce2GEAmMhJtf+PI+Dfd3XOTlXw
	59MQ0pkkTXeHETzhVKsypCgX3OS9o+eneOIkSNXwJu6E3DQTsp68eAXzJ2KDuWW0liL0QT
	2Nj5iHiF8njv63HHN6TKUBeLX/t9JjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789566757;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kV/XRO0a8S5ZTud6UkyyjGjjkh9LbfqQ63gVtApcUh4=;
	b=koyJxGbDl8muDCami+G4aVJ3Zv8s+f0PDBxY8aOFyfBCng7yNvOtyNyHf/fZLGqFUjHZtH
	sYNlg2SeXuemMRBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B13031348F;
	Wed, 16 Sep 2026 13:52:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R3jzJCWfqmrYOAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 16 Sep 2026 13:52:37 +0000
Date: Wed, 16 Sep 2026 15:52:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
Message-ID: <20260916135232.GV54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
 <20260914171602.GO54722@twin.jikos.cz>
 <f6f95c21-da42-45b0-9fd4-4c855e677b1c@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6f95c21-da42-45b0-9fd4-4c855e677b1c@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmx.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Sep 15, 2026 at 06:58:48AM +0930, Qu Wenruo wrote:
> >> [CAUSE]
> >> Although using btrfs without an initramfs is not recommended (if a new
> >> device is added to the rootfs, the system can no longer boot, as there
> >> is no way to register all devices), there is still a minority of users
> >> doing this.
> > 
> > To avoid scanning there's the -o device=/path mount option, passed as
> > "rootflags=" kernel parameter.
> 
> That won't work. At that time there is no full "/dev/", those 
> bdev_open_file() call will just fail.

I've researched if it's possible to have multi-device root in this case
and with some effort it is. The early block device lookup used for the
root= parameter can be used too, but has some limitations due to the
__init section and usage from a module. But DM and MD do that lookup or
auto detection. I'm not going to implement this unless there's user
demand though.

One prominent user of initramfs-less systems is virtme-ng, it's not
affected by this bug because it does various tricks with the host system
to share and virtualize what is possible.
