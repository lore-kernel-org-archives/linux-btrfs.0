Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D81F16B;
	Wed,  9 Sep 2026 00:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788913528; cv=none; b=YR2y1aOYz1LdD7CZoaV/T8KKLUS7qYdo7+svLKUWUsLbqmXY4c9ZN13OEutamu+szQO70+TQaZs1lg+xv5KN+FKhdaaRsc6Z9+26gqmS44RHyk2/1cYI5B5FnLc+VivkCTcZF8SZGEbMqpcAOU6B9jfLfPq4wfNbVjGK4tK/NgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788913528; c=relaxed/simple;
	bh=7w+aLP9GxKpSZ5Hud12Wkv8BfWqYjAe+WIUt/+HMdnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgFjsVduEoqhHYP9tSMkdgJu3NsEpBLSGch1MwyrpiuubiG2n2hqSYkcYt9DH/F8MVSnFZ3Xb5AzPS4fEa6YQHPpRdOf6seRBPEvU4sPxbna4ZOUhXlpe1y8uX0jw5BoslbYZT63HaRv35siEplydrdh2foA7v3mo2K7X77RKgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1P1Z7n/8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXPvRxOa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fpGTkZS3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ffbI9gxR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1P1Z7n/8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXPvRxOa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fpGTkZS3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ffbI9gxR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1777621A0A;
	Wed,  9 Sep 2026 00:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788913520;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4onBu054LSY/uF7WM8nXm9GLARR1Lx+akTHTwT/AQhI=;
	b=1P1Z7n/811kTFms4O4+Ykcqf5oceHryqrZS8HKs+zGz3M6OviTMs/jzUtcPBsAjunaQDEs
	prNNPXO94axrFu0WEUBoqESe1cnNrVk19iF6t2LqSXG40RLKG0Orwmafk+6mMeG4cAQN/Y
	m3WgNqRsvUxCsckzWXXbnS2RR82jPBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788913520;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4onBu054LSY/uF7WM8nXm9GLARR1Lx+akTHTwT/AQhI=;
	b=MXPvRxOaLgeIwgrQzwUmlV5vtZgXiwByTzMkvi1O1GkJPWjjOYIBpCpe29uzbqLKscypsm
	WOZDjuIz8Q6iNEAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788913516;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4onBu054LSY/uF7WM8nXm9GLARR1Lx+akTHTwT/AQhI=;
	b=fpGTkZS3PjC443zgnw+SovyduUVJcDACqbwzTXDD846pcyWsmVC88mOMvWnDQISvPTy/qC
	m+dtRtcGfGwBr0O27blYcDVu/3II/WZSQx1ascJjr6c/wOQwWaIuUOdXEW40TVKSxaXFE2
	wE+QJ/UQQpOas4bh91tizAljLmCZ2xA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788913516;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4onBu054LSY/uF7WM8nXm9GLARR1Lx+akTHTwT/AQhI=;
	b=ffbI9gxRVcXRhP8nKQj5jF4QWEzKDGdecaPEj9/8KaHUfcmJYb05yaWkYAIXqzBCIzEc0j
	T/xS31bsMPyzlvAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF3F813354;
	Wed,  9 Sep 2026 00:25:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SjBKNmunoGpGQgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 00:25:15 +0000
Date: Wed, 9 Sep 2026 02:25:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Alex Romosan <aromosan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
Message-ID: <20260909002506.GF9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:url];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
> Please Cc me as I am not subscribed to the list.
> 
> Running my own compiled kernel without initramfs on a lenovo thinkpad
> x1 carbon gen 7.  The linux disk is the only disk on the system. Since
> version 7.3-rc1 i haven't been able to to a grub-update, instead i get
> this error:
> 
> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
> 
> 7.2 is fine. a git-bisect identified commit
> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
> reverting this commit from 7.3-rc2 allowed me to run grub-update
> again.
> 
> this is not the first time i reported grub-update being broken on
> btrfs. i reported exactly the same problem on jan 8, 2024
> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
> the discussion that followed would help come up with a fix that will
> make everybody happy.

I remember debugging that one, https://bugzilla.kernel.org/show_bug.cgi?id=218353
Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolution
during device scan") would bring back the lockdep warning and there is a
locking problem.

The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
device path update for the same device"), the difference is in lines

(https://bugzilla.suse.com/show_bug.cgi?id=1230641)

-       } else if (!device->name || strcmp(device->name->str, path)) {
+	} else if (!device->name || !is_same_device(device, path)) {

Which gets changed to (by 108cc8733989):

-       } else if (!device->name || !is_same_device(device, path)) {
+       } else if (!device->name || device->devt != path_devt) {

Each change is reaction to a bug, I don't see a clear fix which will
make it work in all cases.
