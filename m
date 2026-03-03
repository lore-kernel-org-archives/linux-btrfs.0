Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED54D8D84
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2026 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554700; cv=none; b=foRsuB4HqxIwy6CWcZVl4G7tq/iVxtBHR52ntE6kvhMsg0nnI7aOEgQnEibAhEUkkRsYtR55wGTeCuIytlCYy1N86Ev5qS0/TDFsiymmaCSdO34Z2e1Dz1ZaXmDTa+BBa4bygVRXfU4oYYrWoRnXVSy8F4FL245VAa/ufA9OR+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554700; c=relaxed/simple;
	bh=if/6yhMN+xsu9+hjA2dRL59fZjtSW5CwXKGRecxGVh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNxmUWC5KP0porSyjPYiPPsVoK6YHK/Qn3wDlXlnXj/N/YSNvfWyqydXcldceQi4p7HpgNraHpLUkvR6MhLsTQks31OokyKVvo0iu7KshKujq9Kkpm/WfOYjMWzGO14tEtI+RXMsSkbfct61UR8ogySXEamNjaZezSZ49q00eyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qYm8/E8y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=E0ASb3Z5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qYm8/E8y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=E0ASb3Z5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qYm8/E8y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="E0ASb3Z5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qYm8/E8y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="E0ASb3Z5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 270305BDE3;
	Tue,  3 Mar 2026 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772554697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcLjOZXBhV65T9Wj/cIU5C2doGWw+5V/fmzfa6VU1zo=;
	b=qYm8/E8yOHiM3gOriEfa1kG86M8Uu2jFtinUDObpNCF07IHswJp3B6PM2DjNHFwWZK+6o5
	FyzVs8+LwxXSwSOr0dfA94eqsllWTCVPyD65J/U8TtmX2aO0NWU4kchYg6gRl7uZ5Ln+KC
	EkDJi3x4FA9Dpkvjzf2rfISImfdUDto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772554697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcLjOZXBhV65T9Wj/cIU5C2doGWw+5V/fmzfa6VU1zo=;
	b=E0ASb3Z5ErgbW+Xi90HUs049fY5zc0zu5lpUnaYj9BRIMah1oXCIiKNFaVS2hgIc1nvCD3
	grdJDKXJj5DzL2Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772554697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcLjOZXBhV65T9Wj/cIU5C2doGWw+5V/fmzfa6VU1zo=;
	b=qYm8/E8yOHiM3gOriEfa1kG86M8Uu2jFtinUDObpNCF07IHswJp3B6PM2DjNHFwWZK+6o5
	FyzVs8+LwxXSwSOr0dfA94eqsllWTCVPyD65J/U8TtmX2aO0NWU4kchYg6gRl7uZ5Ln+KC
	EkDJi3x4FA9Dpkvjzf2rfISImfdUDto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772554697;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcLjOZXBhV65T9Wj/cIU5C2doGWw+5V/fmzfa6VU1zo=;
	b=E0ASb3Z5ErgbW+Xi90HUs049fY5zc0zu5lpUnaYj9BRIMah1oXCIiKNFaVS2hgIc1nvCD3
	grdJDKXJj5DzL2Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 045473EA69;
	Tue,  3 Mar 2026 16:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3uTjAMkJp2kRBAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 03 Mar 2026 16:18:17 +0000
Date: Tue, 3 Mar 2026 17:18:15 +0100
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+d4957dbe80e471232035@syzkaller.appspotmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [btrfs?] WARNING: suspicious RCU usage in
 btrfs_device_init_dev_stats
Message-ID: <20260303161815.GB8455@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <69a5dad5.a70a0220.b118c.0001.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69a5dad5.a70a0220.b118c.0001.GAE@google.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -1.50
X-Spam-Level: 
X-Spamd-Result: default: False [-1.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=98a1e192f758c1c1];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[d4957dbe80e471232035];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Flag: NO

On Mon, Mar 02, 2026 at 10:45:41AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7d6661873f6b Add linux-next specific files for 20260226
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=105ad1aa580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=98a1e192f758c1c1
> dashboard link: https://syzkaller.appspot.com/bug?extid=d4957dbe80e471232035
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4cd2824adb8a/disk-7d666187.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bbdd4a130d86/vmlinux-7d666187.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6e3bea3e96f8/bzImage-7d666187.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d4957dbe80e471232035@syzkaller.appspotmail.com
> 
> =============================
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> fs/btrfs/volumes.h:872 suspicious rcu_dereference_check() usage!

#syz invalid

Marking as invalid so it does not appear in the list of issues but
otherwise it's a valid report caused by patch that has been removed.

https://lore.kernel.org/linux-btrfs/20260205114546.210418-1-dsterba@suse.com/
