Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248951;
	b=MEjzUi8FA/JeepJt8xDrT5FoTAjrudqKfPZ6fpKo8uSZbApZnCp7MmgnBSGO97gkyXuu
	 +SW660xXw1WbbaQD7JQeB2A4oBp27k5M3U5qjSM/qqP4boNCaGonf8tCtFolZ0rbglJL2
	 mynhY3CF0sELWHtPsKelPwvz+qq8z1+yvNJ3F+TeGpKpmHF6f7F9MNN8QSsGkQISOFVn/
	 CGJr0x5GbtrMb/leA8lJb8DoSR0avJPSwLVs6YqEAn+uKK133TYZXEBluAcRbq7pw1NgO
	 CcO2AXrB2/2m9x3HVS7JAQ4O8z8LK//fsQTQ/L0K2oSvbbffyN+snrBEVKUVVFJIzAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248951;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=j/rqMDkpryJ1eCnTsX/6MF/f5Bnp2y7lhdg0C1NBVPU=;
	b=1Vtwga3dcp2DsLl1sGRknlntCCGDTMfuJU7YmYOo4j2+p8SjjPbQ/lDOJ9swuhHpfxlH
	 Vkbhwmr7OZEeeODNxopoIAsyhkcuRnwzYSZDAeNqPIucmjh5sgkdcKWboNkS8WywhuqIB
	 lGqSymtsRrQaojqiM1Rtrk1clnRm8IE+eM4wuz9qi7Nb8DTUaYmhR86MYTq+rOlEbnJc5
	 DGnbUaQrUuoUEnBzpGCDnbKT5tQyQcCRUA0zsfxTUv+vzC3eiCunpQpnkxzA+w5DNprRF
	 XYRJ5W1iPOyMtr6m2DqOUV91EayaLlIDKalIRejIBo279chQXnh5MhjnKjLeTQszo1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LHjl2iXz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=o0v1NX6k;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WwA5fcj+;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="xt3/JeYE";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E487E606A321
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 18:29:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E487E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LHjl2iXz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=o0v1NX6k;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WwA5fcj+;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xt3/JeYE
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9CF922084;
	Mon,  9 Nov 2026 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794248949;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/rqMDkpryJ1eCnTsX/6MF/f5Bnp2y7lhdg0C1NBVPU=;
	b=LHjl2iXzb7rOcfk2YdMc63YR2VuHEHdEa/lkPATOzh6ODypvtKXM7V+PJaesl65npzzsrX
	drF7O4j+z1tokbmfVXNwChvoiVcnz1Xu7sEssnlSelhDskedn7i6ufeFbDJJmdgYxss923
	nUpMmIjVHApLZhT1S6O2peeobwXY8Ds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794248949;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/rqMDkpryJ1eCnTsX/6MF/f5Bnp2y7lhdg0C1NBVPU=;
	b=o0v1NX6k0YEYQpHf+Y14VswJBX7BF8BW2ZLAhmwbx9e0WgalD8FkxoSJCrTXe9P9q8gJXX
	nEhRa9moHGTxjZCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WwA5fcj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xt3/JeYE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794248947;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/rqMDkpryJ1eCnTsX/6MF/f5Bnp2y7lhdg0C1NBVPU=;
	b=WwA5fcj+lmYnacUQxWNW8uNhGJfbKoqzA4tJMB6RBGgppv6xwZvWcS2+dO4X2DlUXl+Jsj
	qZdXzJ9VRBy2v1xKg5lJxzRCnPHVeIZg7QTN4xGiTngOJS7z5MH2SttgpIMFd+7IxEE8lr
	DiVv4onD27ldBolooqumDi5zpyuVkcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794248947;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/rqMDkpryJ1eCnTsX/6MF/f5Bnp2y7lhdg0C1NBVPU=;
	b=xt3/JeYEjE3tTN3wQTG+ayPf43E5/5zauyy85ggrBtTCC6DY1qKFEQSz3pQ5VRcS5i3+bY
	aH+/uwCO/EX+iKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C77613319;
	Mon,  9 Nov 2026 18:29:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LeJuGfMQ8mo3YwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 09 Nov 2026 18:29:07 +0000
Date: Mon, 9 Nov 2026 19:29:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, =?utf-8?B?6ZOu?= <fengaojigui88@gmail.com>
Subject: Re: [PATCH] btrfs: make sure the eb debug info is before the
 WARN_ON_ONCE()
Message-ID: <20261109182902.GE4186782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <080655ad6734a27e70f3699abe97ae46d63f690c.1793860606.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <080655ad6734a27e70f3699abe97ae46d63f690c.1793860606.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-13.21 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.21
X-Spam-Level: 
X-Rspamd-Queue-Id: B9CF922084

On Thu, Nov 05, 2026 at 05:07:16PM +1030, Qu Wenruo wrote:
> Inside invalidate_and_check_btree_folios() if we found some unrelated
> extent buffers, we trigger WARN_ON_ONCE() first, then output the extent
> buffer info.
> 
> However for a lot of fuzzing setups, kernel.panic_on_warn is set, so
> that WARN_ON_ONCE() will immediately cause a panic, skipping the important
> eb debug info.
> 
> Change the order so that WARN_ON_ONCE() is only triggered after all eb
> debug info is outputted.
> 
> Reported-by: 铮 <fengaojigui88@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAO-4RZ0mqFEU8z44B+biaMw5Ee4ogCjs80Uws9YY8LMV7J685w@mail.gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
