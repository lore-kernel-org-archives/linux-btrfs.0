Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610862D7DF1
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789147411; cv=none; b=cFbv09dDWsiDom+xm0jBwMvEH051NO6ZZhGmyPX/BTZ3H+zq5vZ5Te6syS4mUIIUDwZYjtStVntPs961qHyYSRpU35mOdCsEYlf45cjQPdMCxIE03VSevYIw639i5y6GZTbf9JE3E0mJiCHsS97LeHElzMNjetSczHUSmu4CfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789147411; c=relaxed/simple;
	bh=5sU/KFAM734nVB9zcNa8p+ynyXyD2H651PgMfhR7PeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/QTZXh2Lf3bl5hd78LRcRLwzSvDiedTZpswC+6D5xwof7yDVEGZBKCC9YqSvLPVR+4uOjYwef3uXlVyfUXQCliTqdHkTjRns8Z1HvSSfCukDTZgrQcKuGAK+LfiNj6CLhvqiTezDFG1KZ4G+ZY5Ad0/UuO8TcBkoB7BcRUnG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jfYkZPNE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wXr/nwbI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fg8k0G18; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SsYmRo1+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jfYkZPNE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wXr/nwbI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fg8k0G18";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SsYmRo1+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15B241FEFC;
	Fri, 11 Sep 2026 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789147403;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bREBVn367CpTALbyrss+hQ81afbIEgQDnIL9eeMEQBk=;
	b=jfYkZPNEuuIjRtNYKYGKUqty71Wnwk600osb7Joz2cYuRG8Xs6HVVXyNV3qY6sjO5Z16Qq
	DrHthoyiJbLREwR8oTRKOKrqGoI7ejDg9DmU175RPCPyxMgWn0nJSyqS2AMlrJaFUifESQ
	MaZ3t/Ja/9J3E1ru3o+Qf+mc9/dXUQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789147403;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bREBVn367CpTALbyrss+hQ81afbIEgQDnIL9eeMEQBk=;
	b=wXr/nwbIZTVUSX5nEEMKKn8QtP8TcmKVkQPHSZ9h62uprPn29OT/F7cfBWGeeVf/1l27aq
	3nvTqAEimrPfY6Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789147399;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bREBVn367CpTALbyrss+hQ81afbIEgQDnIL9eeMEQBk=;
	b=fg8k0G18a15N0gES91GNwRY7ZU16L4qrwuuTi51CarGGzB86cMe5m+Sc5rMosfx7CtPRwL
	nbAg6Lz1ReEztNNkMWRvtMvyphmiQpYBin44hGM4TnKW1BiZFGw1MHpN3f/B8upC3EL/pd
	1qgsS7gAP9u6cEhF6hQEuxkFTiJT7/U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789147399;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bREBVn367CpTALbyrss+hQ81afbIEgQDnIL9eeMEQBk=;
	b=SsYmRo1+0eQXawxbUkCzP/n1xtfO/x9i+pHrFxuEEMGL9O0xaNC8RAu6Vwg3CdyE/QYNOj
	BkiRcptYbvvPXXCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCB34132D3;
	Fri, 11 Sep 2026 17:23:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FfGkNQY5pGqSLgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 11 Sep 2026 17:23:18 +0000
Date: Fri, 11 Sep 2026 19:23:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Suveer Jain <asj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
	linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	David Sterba <dsterba@suse.com>,
	"Macieira, Thiago" <thiago.macieira@intel.com>
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Message-ID: <20260911172313.GA54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, Sep 11, 2026 at 10:51:16PM +0800, Anand Suveer Jain wrote:
> On 11/9/26 20:32, Dave Hansen wrote:
> > On 2/26/26 06:27, Anand Jain wrote:
> >> Currently, f_fsid depends on fs_devices->fsid. For cloned devices, this
> >> value is dynamic and fluctuates across mount cycles. This inconsistency
> >> breaks persistence for subsystems like IMA.
> >>
> >> Switch to a stable derivation using the persistent on-disk fsuuid +
> >> root id + devt of the block device for the single device filesystem.
> >> This is consistent as long as the device remains unchanged/replace
> >> (excludes btrfs device replace secnario for now).
> > 
> > This commit evidently hit 7.2 and is causing end users some real pain.
> > Real software uses the FSID to encrypt/decrypt their VPN key files:
> > 
> >    https://github.com/NetworkManager/NetworkManager-openconnect/
> > 
> > When this gets applied, those users suddenly can't connect to their VPN
> > any more. Having a stable derivation does seem like a good idea, of
> > course. Is there any way to make this transition without breaking
> > existing userspace and existing users?
> > 
> > It looks like this is also getting -stable backports.
> 
> I wish I had more clarity on how OpenConnect uses the FSID before I
> comment. Do you know? Can you shed some light on this?
> 
> 
> Also, a couple of quick checks:
> 
>  Is the underlying device MAJ:MIN changing before and after the upgrade?
> 
>  Are the original and cloned Btrfs filesystems mounted simultaneously?
> 
> Patch v3 (1/2) keeps the FSID persistent from the on-disk superblock and
> stops exposing the internal random FSID. However, if OpenConnect relies
> on statfs.f_fsid, patch v3 (2/2) now derives f_fsid from the underlying
> MAJ:MIN.

You've sent the fsid patches [1] to fix some IMA and fanotify problems,
so I guess there's a use case. This report shows a clear breakage in a
different use case, I'm thinking about a quick revert as it seems to
have worse consequences. A fix to make both work would be good but I
can't estimate when it'll be ready so for now I'd go for a revert and
then forward it to 7.2 stable tree.

[1] https://lore.kernel.org/linux-btrfs/cover.1772095546.git.asj@kernel.org/
