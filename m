Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4B33EAEB
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773851732; cv=none; b=IA/+ED1uLXjwBWZYG5u2G0idNdUgAP7Lwz6Oei7bUTIp4GC5A3RMzsB5+4Fbns3jZOSs9Q2SzqB22f21IwTATmJTZWLUF1j2M2E0tEXFQ6PZFk+Xau1+i/3hlm3D/UCVMZfzLiMZjG0puIwzmqZetDMWe0CP5dOfxqr2ikHWkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773851732; c=relaxed/simple;
	bh=bZLBblemA+Mki3wPx/7+AbG8DpFQZqqKkjWcYFGqnMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5VlgjNxjH4qtRio22ES1yCAo1AKhKi/kRfPkOidfrGz44oEowC/tzNuvRvY08QPJovw8009iqEsRPZoowfbGUfHyz8N51zPadj15zFUzfRc3zXw1KymeXdviM3dHnrH+A0DIJ5e8y2sJ89+EyOpbzsOmv6ygs2ZOzs8o5Czgeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a5OqacaF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=us4w2Wkp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yUzrdIFq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VLEFXz+5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a5OqacaF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="us4w2Wkp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yUzrdIFq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VLEFXz+5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A5DD54D429;
	Wed, 18 Mar 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773851727;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C35Ic6GUhAGueVVmVxBvv8ErmbDlqEHLoDkeE//qxLY=;
	b=a5OqacaF8UzcXHOtOd1pgY9ARIWNPpyEAfC6sVZOU7VA3lL+UAJFAX1f3u9a/hk6d9ApfZ
	r4wLGY5rNCxZeMYqPz7q4VJ+zqIZImaXuogCWiRTGVEUnffXNIjynIehEbzMXKNHs0Dy25
	clB6GRoy3l5FN+de3uyEjiSkSSFsuP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773851727;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C35Ic6GUhAGueVVmVxBvv8ErmbDlqEHLoDkeE//qxLY=;
	b=us4w2Wkpk1651TcPT6cDErBm843btyH+GqxkPo96IbQHoPFM7+Fx/cnDgVmPBhuuubkCZ1
	N1TI2TKXaZpxHnDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yUzrdIFq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VLEFXz+5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773851726;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C35Ic6GUhAGueVVmVxBvv8ErmbDlqEHLoDkeE//qxLY=;
	b=yUzrdIFq4R8yhso8Vys/RdFeBiu+ERAIElwBHBfs9MX+IRdK2euNIMaWqeg9AMDz+E2qRp
	wRTRjdSlol2GJLF+G+P1rX6Sz4Cd8HltH1eMpm27UPb9yC3XiHzhsiKQUDoNnaWjvZTua/
	2ICk57gi9D558CSy5IckB2NHgH59KTQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773851726;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C35Ic6GUhAGueVVmVxBvv8ErmbDlqEHLoDkeE//qxLY=;
	b=VLEFXz+58ydBbgOnbrEmuT3cKHU2fXMzBVMmutzNw+XkaBbgnhWZWJZl7vj/JPPdnNwrJg
	1cjYbq4Mjpr/cHBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BA3C4273B;
	Wed, 18 Mar 2026 16:35:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xE3eIU7UumlyaQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 18 Mar 2026 16:35:26 +0000
Date: Wed, 18 Mar 2026 17:35:10 +0100
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [btrfs?] BUG: corrupted list in btrfs_free_compr_folio
Message-ID: <20260318163510.GE5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <69b8084c.050a0220.248e02.0115.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b8084c.050a0220.248e02.0115.GAE@google.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-1.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[3c4d8371d65230f852a2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.71
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A5DD54D429

On Mon, Mar 16, 2026 at 06:40:28AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f338e7738378 Linux 7.0-rc4
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15265602580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
> dashboard link: https://syzkaller.appspot.com/bug?extid=3c4d8371d65230f852a2
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f338e773.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2567fb35ebfb/vmlinux-f338e773.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f9124de81ddb/bzImage-f338e773.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com

syz: fix: btrfs: zlib: handle page aligned compressed size correctly
