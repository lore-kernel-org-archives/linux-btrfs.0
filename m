Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A153DA7F9
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391713; cv=none; b=dtT95jwZg1miRvQYEiNmEt+I/db66WzERle8NAYMUoIo4Y18SrFyis/gllCm3TclfZgGz0wh5HEMaNn7B0YnSF22wMDp/vzqr5Hy3UTWqbhMeTG4d5xqZOGX8cNS7OyeW7b9pcJ581dLlXJNhIwSndkXA0QQUdReeiU3Ek+x3SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391713; c=relaxed/simple;
	bh=8ve6aQ0CXDttAuO/Cnbh7e6r/t/0cc/knwcnP9ufMR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHO9cQWb/tMbuglnCByrMp536EhjwLwkhgG1mWQ+DzjlXcJwayRwnii+lneLb0hG1Of2G/twRxX5606zc7cuT+Qm/JDDuSwC8HmnuYo9tOPg9pAyzRiHrLLt/tTm+XQuZ0HQl9Fi+HRR9gRg7CPZ7G3u+AjNBXaMG+hVcF9ivik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DH4zdrC3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qpr07dPm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ni79Uowr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q7cM7ghH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DH4zdrC3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qpr07dPm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ni79Uowr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q7cM7ghH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62B1421CAC;
	Mon, 14 Sep 2026 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789391705;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYn2QWuXIu/VVH/ilueBn1dBtk/8C+aM1fa5kDwi+wA=;
	b=DH4zdrC37e59kUAG2kzKJIcaUHDkedu9o4NLGjHYsLM9C/K3bTs70MMS9HDG1i3FpW1t3N
	miiRHYDeLb4jslZKimG8jjfEXAViZ4wR3qarp3NKF1XbAXdAmPzCYG724+y9lRc1fsJHLZ
	XsI+w9vMvpX0/GYLrv7HzoHoakCnLRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789391705;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYn2QWuXIu/VVH/ilueBn1dBtk/8C+aM1fa5kDwi+wA=;
	b=Qpr07dPmeWnG/2Ixmn2QSA/iK9171kBJBUNQhza4lKYQ8swhVZSlltSjF1Hk0GQLYJ4qLR
	RPE+Tq6M3GxQesDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ni79Uowr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q7cM7ghH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789391701;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYn2QWuXIu/VVH/ilueBn1dBtk/8C+aM1fa5kDwi+wA=;
	b=Ni79UowruH9959oVY+8Zbmyyp3enJfDSiM88G+n5qspbiDXWywgQ9skS2R3lMKduRpeIUK
	yYoczPefKmn55fAMr2YbBB2rzrH6+6DVWZdXxu1ppIPGnLAt3rbabvUovW8hsNP/nkgTC+
	M6azs0UFXEoCp3xiD/X3ybu8dFOfBPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789391701;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYn2QWuXIu/VVH/ilueBn1dBtk/8C+aM1fa5kDwi+wA=;
	b=q7cM7ghHi+wE55dh/pJ1QucAgdPFDDZxRYeSnQhmD3x7pZLsiWfGdpxn3PAX1VglsEIoSX
	ExK1dWr1U9SeyNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CFFC1368C;
	Mon, 14 Sep 2026 13:15:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HIjFClXzp2o/UAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 13:15:01 +0000
Date: Mon, 14 Sep 2026 15:14:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Suveer Jain <asj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
	linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	David Sterba <dsterba@suse.com>,
	"Macieira, Thiago" <thiago.macieira@intel.com>
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Message-ID: <20260914131455.GH54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <20260911172313.GA54722@twin.jikos.cz>
 <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 62B1421CAC
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sat, Sep 12, 2026 at 06:19:21PM +0800, Anand Suveer Jain wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1836,8 +1836,12 @@ static int btrfs_statfs(struct dentry *dentry,
> struct kstatfs *buf)
>         f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root)
> >> 32;
>         f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
> 
> -       /* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
> -       if (fs_info->fs_devices->total_devices == 1) {
> +       /*
> +        * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
> +        * Only do this when a clone is present so the original filesystem
> +        * (mounted first) maintains backward-compatible f_fsid behavior.
> +        */
> +       if (fs_info->fs_devices->temp_fsid) {
>                 __kernel_fsid_t dev_fsid =

This should fix the most common case where people don't have any cloned
filesystems at all, so I guess this is good as a fix. Please send it so
I can add it to this -rc pull request. We can try to catch next week's
release of stable trees.

Related to the cloned filesystems, it can get complicated if the
original filesystem gets unmounted and mounted again, now it would have
the temp_fsid set, right?

I don't see the temp_fsid documented (btrfs-progs) other than in the
changelogs and briefly in the sysfs file. This should be more visible as
a separate feature and with the known use cases.
