Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBFC36F433
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778272974; cv=none; b=gqWs89YixXF8miNJxVPSpdJIRviaW1rA7InNOa2o6hRsA//aYNjyifOb+q3qXXnq06evj0jfKYOMrAaP9i9yD0mm/1rmXDcr8OfwDRngIpHvf+YVLBnYCi5Rc9+SciaEql5v6l/ZQdx0sePDvU6+PtkVUXINWoU5LvulLFzwxuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778272974; c=relaxed/simple;
	bh=pkaU+CcRoG2dEIu+Lx66AxtFq4PMpmt4O6HcA0FdWKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiUSSS2khcdtTCApy9/q12hpvl8l+NIZ2eepU08oV2bxDGLQEd9wj4sIaGqPWhOMZKiJrDviG+CzhnieGasq7G0/iM8irsko2VQb0SvP1d0lvwDEyPAAFE6GY3QSUOARn5iof2Pp9EUrTprM9TytctkZ2knMOzJKOU+o753ZnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uGMHlLbx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ilmIVrRl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uGMHlLbx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ilmIVrRl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uGMHlLbx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ilmIVrRl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uGMHlLbx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ilmIVrRl"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6E7A5D58D;
	Fri,  8 May 2026 20:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778272971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YNPgp45ne+68uUWc7ApJSpgr+QTvtVnC0vzMnndu5Ug=;
	b=uGMHlLbxxhA3zv2vJ3DtX6oWc/EONKcAsumiMAG5r8S6X33nC4uwyVLCKbyDLmA/o7GYJp
	u0vAnJvyndT1G8gbb19mCnxF2ugb54qXKdb42zL2aU2PJtZtF9s60AMMKASfuWib3R93Nr
	J+DmU39es5Ubjn/zBIdzp2SXS6V33Zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778272971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YNPgp45ne+68uUWc7ApJSpgr+QTvtVnC0vzMnndu5Ug=;
	b=ilmIVrRl6Xm3MJR4DTp4Ay1dtCMSPNfcks0gFiOd5TbaA96D9bOHR6WUru+DWLPmyPpilv
	cfwF3B5kAlgNH/CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778272971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YNPgp45ne+68uUWc7ApJSpgr+QTvtVnC0vzMnndu5Ug=;
	b=uGMHlLbxxhA3zv2vJ3DtX6oWc/EONKcAsumiMAG5r8S6X33nC4uwyVLCKbyDLmA/o7GYJp
	u0vAnJvyndT1G8gbb19mCnxF2ugb54qXKdb42zL2aU2PJtZtF9s60AMMKASfuWib3R93Nr
	J+DmU39es5Ubjn/zBIdzp2SXS6V33Zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778272971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YNPgp45ne+68uUWc7ApJSpgr+QTvtVnC0vzMnndu5Ug=;
	b=ilmIVrRl6Xm3MJR4DTp4Ay1dtCMSPNfcks0gFiOd5TbaA96D9bOHR6WUru+DWLPmyPpilv
	cfwF3B5kAlgNH/CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9BF45593A7;
	Fri,  8 May 2026 20:42:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W/dfJctK/mlDOQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 08 May 2026 20:42:51 +0000
Date: Fri, 8 May 2026 22:42:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Illia Bobyr <illia.bobyr@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: balance: most filters can only be specified
 once
Message-ID: <20260508204246.GF2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260408082200.788451-1-illia.bobyr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408082200.788451-1-illia.bobyr@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Wed, Apr 08, 2026 at 01:21:53AM -0700, Illia Bobyr wrote:
> Clarify in the documentation that only one occurrence of most filters is
> actually processed.  Add a warning when more than one filter of the same
> type is specified.
> 
> It would be better to show an error when the same filter is specified
> more than once.  The first filter is ignore in this case, and this is
> not an expected behavior - nor from the existing documentation, nor from
> a "naive" understand of the filter syntax.  But as there could be
> existing scripts that may be specifying the same filter more than once,
> it is probably safer to show a warning and turn this into an error at a
> later point in time.  Giving everyone time to update their scripts.
> 
> Signed-off-by: Illia Bobyr <illia.bobyr@gmail.com>

Added to devel, thanks.
