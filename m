Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095F2147E5;
	Mon,  7 Sep 2026 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788804056; cv=none; b=io9I0Mj+3BU4Nm6S1OIN5WM0biNBPPhttaMcUejM30YP5aH0atk4tep0hWICVigBLkGoOWa3HIAcovoJAJvEVHjBZVYrdtegLD2DxS7FS+5DYmJKFS5mpXQ6E1jD4c1G0Yy7A0scpz/KR+G7m6cI8NTVhrrQ8n3H2UbhlDdPjzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788804056; c=relaxed/simple;
	bh=1G6K3vX6g3d/HeZt5z3XfWYYzSJK4SvRYkD67K3fOzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cK0Fndp1bFV6E7EFBLu/gd9bpYQyTjIMcqoEgASaSHxiiIF4Rq7/ZcF9g6b/3d0b2OicICDOYk25LnHySAYlXniNU4ljy1k6NMZZ0fiwc9POdIXKGg9hhEuwAkQzZdLoMjf0zp2NXXw5fRomFiMvhNejXyYcUPEjF94r/5izEsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jo7nkbVM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EWZrz23J; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BuUfHCkl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FGAKNb9E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jo7nkbVM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EWZrz23J";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BuUfHCkl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FGAKNb9E"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BF7A421AC9;
	Mon,  7 Sep 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788804048;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1G6K3vX6g3d/HeZt5z3XfWYYzSJK4SvRYkD67K3fOzc=;
	b=Jo7nkbVMn8VHZYjdjjcyi9t7HqYUk1xRM2CZfzTqyi/JvhT+4eFt75V+agQDnXXX/dpvff
	Z+bqSiaRAgP1j33vQQOmeYsc0uNcG0uKCkyS8/LI1IdNRI6BnZYFSbdyAmEiaLGBVJkWN0
	bDY4UEqvqK+44wnXeama0MJih4C+sXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788804048;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1G6K3vX6g3d/HeZt5z3XfWYYzSJK4SvRYkD67K3fOzc=;
	b=EWZrz23JNFHx39IMvrKFf9VA1gXWFXHxoXEttieaCheeNiWdORYidX7Y5HTqs0wwOoL728
	DNnRjNfhPzfVvmAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BuUfHCkl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FGAKNb9E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788804044;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1G6K3vX6g3d/HeZt5z3XfWYYzSJK4SvRYkD67K3fOzc=;
	b=BuUfHCklmdo01hJ4nenrj9SUpthHePhR++lYygDLBHgfY4GKl6WiwkmxQgxEqdq+WzzM6q
	EoTq+az3T33T80aLTG3TeuvHmDdyyX+LOZFRkHQf5gAijnZKSUaqk5qhy7rCY4Yaaxcuqd
	G4C5Wlbw++eVRjTLyvZR7YyA6xnOTI4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788804044;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1G6K3vX6g3d/HeZt5z3XfWYYzSJK4SvRYkD67K3fOzc=;
	b=FGAKNb9EFcUuJgM8cZnYHgow5QJGB+pMorvRH8HiEz1gygzd42TkepDC6RuEdJTR3lleBe
	ElDVPbV7lO/wGmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79C1113432;
	Mon,  7 Sep 2026 18:00:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kUh+Hcz7nmoldQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 18:00:44 +0000
Date: Mon, 7 Sep 2026 20:00:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Jiacheng Xu <stitch@zju.edu.cn>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2 0/2] btrfs: delay mounted sysfs attributes until
 mount is ready
Message-ID: <20260907180039.GA9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20b09e24.16b27.1a01f23ee08.Coremail.stitch@zju.edu.cn>
 <698e5039.16b92.1a0278ef67b.Coremail.stitch@zju.edu.cn>
 <ffae86d9-e2b3-4cf0-9f4f-3fcd412ed7e6@suse.com>
 <14a31d04.16c31.1a027fb3b71.Coremail.stitch@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14a31d04.16c31.1a027fb3b71.Coremail.stitch@zju.edu.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: BF7A421AC9
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sat, Aug 22, 2026 at 01:39:31PM +0800, Jiacheng Xu wrote:
> Great! Please let me know if the patch is finally merged.

The patch is now in our for-next branch, but will be merged to Linus'
tree in the next development cycle. Until then it will be in the
linux-next tree.
