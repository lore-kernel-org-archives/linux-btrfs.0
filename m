Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02659382363
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102664; cv=none; b=FIvUJ2B9m6ZzaPXIu8FdGpHlje8ZLDMSEC3i6o4S51t+B+pJL+nXJCLdoSTSg/4o2Re+osb+xcb0qy6kgydKnrvzUn07x3sHhYRbH0WagXbZHAplFsA/37UiHM1xt5fYApNqmpFqh2hotcO6LaxgSy3NXJJXysJapMIDUkfxpHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102664; c=relaxed/simple;
	bh=Tc+CPY9tImgd1pi+4Jzgesdv/6pEKDjZSYkyNxpjnRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXP13JVNH1385fuTXF9/erun60OvmXPBrY6UtplY7fQnNJRkoeAlJ1ftnRXRCGszMEw1bfqArpbWUghwTJf5TV86/1R2uK8HHip7W9w/mRa9NGKWy3lGs+JAh0yIoF3ECNoOluF9/BjTVtgJ4wxyYovkhCfKpM5N0/1MWx96EPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xYnDUCM3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3qpCnjz/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xYnDUCM3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3qpCnjz/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xYnDUCM3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3qpCnjz/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xYnDUCM3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3qpCnjz/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 38BE96A960;
	Mon, 13 Apr 2026 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102660;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bXkp5ZtFOl2xuDgOUHSx4XP2kgb5o4hL+EkHLiO6oG8=;
	b=xYnDUCM3ofjPe/PKAxgoF9wzuksrK5LRtQB+3KU14W0XksUlmUnTmQD5vieBoH6hAGSnVo
	WZhcEc6V8bSmE5hteKmnewag8KQsNXX2sERzUYNQyHG0MK52OeD8iwonsOsARbwLvKNHq/
	cOV/VSLZul0RS2v4wL3Kb/q/GPOaSpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102660;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bXkp5ZtFOl2xuDgOUHSx4XP2kgb5o4hL+EkHLiO6oG8=;
	b=3qpCnjz/8TFfbI4q+/Bqp/6uubgjbyjk+sTAvn/EQZ9CQddWtnHdxD8StIX+LpIaaM5CbZ
	+C8nx6R2YNk0K3Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102660;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bXkp5ZtFOl2xuDgOUHSx4XP2kgb5o4hL+EkHLiO6oG8=;
	b=xYnDUCM3ofjPe/PKAxgoF9wzuksrK5LRtQB+3KU14W0XksUlmUnTmQD5vieBoH6hAGSnVo
	WZhcEc6V8bSmE5hteKmnewag8KQsNXX2sERzUYNQyHG0MK52OeD8iwonsOsARbwLvKNHq/
	cOV/VSLZul0RS2v4wL3Kb/q/GPOaSpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102660;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bXkp5ZtFOl2xuDgOUHSx4XP2kgb5o4hL+EkHLiO6oG8=;
	b=3qpCnjz/8TFfbI4q+/Bqp/6uubgjbyjk+sTAvn/EQZ9CQddWtnHdxD8StIX+LpIaaM5CbZ
	+C8nx6R2YNk0K3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2556D4AFEC;
	Mon, 13 Apr 2026 17:51:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nLnyCAQt3WkpRwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 17:51:00 +0000
Date: Mon, 13 Apr 2026 19:50:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: remove the COW fixup mechanism
Message-ID: <20260413175058.GB12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775621833.git.wqu@suse.com>
 <c3f440e920f5a82ed5f4dbd839c9a8843d971043.1775621833.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3f440e920f5a82ed5f4dbd839c9a8843d971043.1775621833.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
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
X-Spam-Score: -4.00
X-Spam-Level: 

On Wed, Apr 08, 2026 at 01:55:31PM +0930, Qu Wenruo wrote:
> -	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);

The fs_info->fixup_workers workqueue is still left, please remove it too.
