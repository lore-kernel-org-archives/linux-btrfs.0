Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2F9386442
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776289193; cv=none; b=BNml8dQuMYWPecw57aWaaPNAlqo8U5ym2K4MOjOPzTHEC3KHA6Sq1ElclrNZxITbEo5UwvZEXrdkLfrH1fZIez/faxOKCoesl4rXtr9AkWpuKvUkLY80S2PU1Du9Om6iDsqY9lwd8As/fnTviTB1FbYY+bUYmrmwfMuAamwXLw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776289193; c=relaxed/simple;
	bh=3FdaUF37s0r43PgQvIeiXtgRKPpFXdDwqGZl78nbhjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RL9JXqPB7OdiCs7CRNK8+Pwzrk52WWNEiMBk3/kj2bo+cJVMJojrq9D1XS6um/hhD+Uw2ibz38AnTXD0D7RconaKIg1XvAm9DPU3lX0GRbi299BMfO67/uERNFxMu5XGDwrrw0G9F4r+O2vvKe2CWyHO0ApSUbxfnf6UEHIPVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/3hymtc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+jVHVzQi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BNLK61Xh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=utdNgpci; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/3hymtc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+jVHVzQi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BNLK61Xh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="utdNgpci"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7468F5BD39;
	Wed, 15 Apr 2026 21:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776289186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TESSBcY0KR6K374zstHKa2trPG8ls0j3QRAAWaKsAjA=;
	b=K/3hymtcPuz7BdmNe4aIiESceiaihf/LZm+a4mMYqmb3OXFGqhyH4nxoLkpgo5lHY/Ggbk
	zS3tCllV8FHFtZh1J8u3BjkL6YtTLtBjitJ2/98JI5jy3BNAck9fJrRWq0wyXgsyqQbRnX
	3GsGeR9AIZzPBc21UtjZzpP88KaEcVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776289186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TESSBcY0KR6K374zstHKa2trPG8ls0j3QRAAWaKsAjA=;
	b=+jVHVzQiYacaNWp4JkEcGhLngdMOg7masGngzYoaqdvlzvyJxlI4X2Eo7F0bEwy8ZZwwNV
	CSnobuYvrOlYe+DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNLK61Xh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=utdNgpci
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776289182;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TESSBcY0KR6K374zstHKa2trPG8ls0j3QRAAWaKsAjA=;
	b=BNLK61XhWuOrysiARM1IUHmEuOwSXqJozAZUTUSl7HOanvLaqWCL9yI6SAOS/wF5AUfwpl
	SDM4dGyTU3WP56Jynh9BFocNCCtbsfGsrp7MhBrMfIkQW4NrZIIgDr5kofSEI3KYEP1Whw
	LLrVXQOZJ9l//ZbIDkOg/pzX9x619kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776289182;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TESSBcY0KR6K374zstHKa2trPG8ls0j3QRAAWaKsAjA=;
	b=utdNgpci8U5R43TqNfMdDo2dT48DQuQDRIU848iW0NjrDcaq7ldSoBLSki1prKm40iApKF
	3ejuIwWL2ktewWBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52CA14BC0C;
	Wed, 15 Apr 2026 21:39:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hfP4E54F4GkIQAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 15 Apr 2026 21:39:42 +0000
Date: Wed, 15 Apr 2026 23:39:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
	wqu@suse.com, boris@bur.io, dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260415213941.GS12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260415170001.109723-1-mark@harmstone.com>
 <CAL3q7H5UYpm5rc2xU2H2oKjuZ3NjWcq9QL647QsSgBCd3oEY_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H5UYpm5rc2xU2H2oKjuZ3NjWcq9QL647QsSgBCd3oEY_g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Queue-Id: 7468F5BD39
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Apr 15, 2026 at 06:46:46PM +0100, Filipe Manana wrote:
> > @@ -5140,6 +5141,344 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
> >         return ret;
> >  }
> >
> > +#define GET_CSUMS_BUF_MAX      SZ_16M
> > +
> > +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_bytenr,
> > +                             u64 len, u8 __user *buf)
> > +{
> > +       struct btrfs_root *csum_root;
> > +       struct btrfs_ordered_sum *sums;
> > +       LIST_HEAD(list);
> > +       const u32 csum_size = fs_info->csum_size;
> > +       int ret;
> > +
> > +       csum_root = btrfs_csum_root(fs_info, disk_bytenr);
> 
> Please, check that the root is not null; if it is null, log an error
> message and return an error.
> We found many missing instances that sometimes triggered null pointer
> dereferences when the file system was corrupted or mounted with the
> rescue option, among other issues.

We can start adding the __must_check annotations.
