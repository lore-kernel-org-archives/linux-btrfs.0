Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21836165E
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107217; cv=none; b=cbU6g7MGe3KY8kQd9dgvqqVRUVDjwX/FpD+k2HjfBA8hMc/ljrdVuFCEtRQ7/hcv2lwVelOKfFjSM1wpM00zGwbmtJlTOM+DEKgXt2C/35xO9lQFBb7awVGhtcLAW7nMYvKvexeddnP1VZiKS1k27e4DKAvMjviaL7AUYeuoSms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107217; c=relaxed/simple;
	bh=PrNGDMVIsIEoocKDjibQsQ+7ve8MGKFHDdqAIEQ/PlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/AKjVma+bCqrsCAw9vOvbyt28Uo3110rNOV1VsADI39zkJAro1WcA0aWJK/S8EYRtRZrzk1FsHLXwEJVt+abqsJcYkV1f0U5Xh//VQqOnsmBEIU2blZPT5G59grRkHby0aOpR5nJTicqmDJ8tG5rheNftBI2nWiSPGy64hKwW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IpgepdW0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OgVzTAr4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IpgepdW0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OgVzTAr4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IpgepdW0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OgVzTAr4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IpgepdW0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OgVzTAr4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 55C115BD94;
	Mon, 13 Apr 2026 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107214;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrNGDMVIsIEoocKDjibQsQ+7ve8MGKFHDdqAIEQ/PlQ=;
	b=IpgepdW0dO0tyhBlp1ONAz5HxQ7qormYb/Ab3J7MjHhOsl2Akwyt0EP3ERM1bcEQfFQEib
	IdoFB8D8xliaukwSOp2ZQTRbgXP6BxOJK537c1p8gDqbBir0rvWviBK6C52eQ8DB9gYTme
	sqbkaUsi3lSxfYo3NS1/CXLVPqVUDeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107214;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrNGDMVIsIEoocKDjibQsQ+7ve8MGKFHDdqAIEQ/PlQ=;
	b=OgVzTAr4upfmvGSbMPKWj6q0oBAJrzYlFMrVvcJJX6Vg6TV4wktXD8APTgkoSZ9vmhjLSN
	ycYJOnvG6vx/v8Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107214;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrNGDMVIsIEoocKDjibQsQ+7ve8MGKFHDdqAIEQ/PlQ=;
	b=IpgepdW0dO0tyhBlp1ONAz5HxQ7qormYb/Ab3J7MjHhOsl2Akwyt0EP3ERM1bcEQfFQEib
	IdoFB8D8xliaukwSOp2ZQTRbgXP6BxOJK537c1p8gDqbBir0rvWviBK6C52eQ8DB9gYTme
	sqbkaUsi3lSxfYo3NS1/CXLVPqVUDeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107214;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrNGDMVIsIEoocKDjibQsQ+7ve8MGKFHDdqAIEQ/PlQ=;
	b=OgVzTAr4upfmvGSbMPKWj6q0oBAJrzYlFMrVvcJJX6Vg6TV4wktXD8APTgkoSZ9vmhjLSN
	ycYJOnvG6vx/v8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3707E4B038;
	Mon, 13 Apr 2026 19:06:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KyiZDM4+3WnpDwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 19:06:54 +0000
Date: Mon, 13 Apr 2026 21:06:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: replace ASSERT with proper error handling in
 stripe lookup fallback
Message-ID: <20260413190648.GH12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-5-robbieko@synology.com>
 <b9ba7c62-8152-4d7d-857f-11b63c641f05@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ba7c62-8152-4d7d-857f-11b63c641f05@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Apr 13, 2026 at 11:49:39AM +0200, Johannes Thumshirn wrote:
> Not sure if ENOENT is the correct error here, wouldn't EUCLEAN fit better?

Depends on the semantics, if the caller cares about the code then it
should be specific. In this case I think it can be both and slightly
favoring ENOENT. btrfs_delete_raid_extent() returns EINVAL, ENOMEM and
others and the ENOENT for deleting something is understandable. The
caller also ends up aborting the transaction so the error will be
reported.
