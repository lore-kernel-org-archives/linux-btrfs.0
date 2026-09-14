Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AD5497B61
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406890; cv=none; b=Qyb8CERzCE5XtZ83RvOH5QLqQlgMSq+f8htEtuTewoq/CtGUjCixOmj9AEr/A04N0AmNDRK+cFSWM+lgAGFeP7IvF4wuruSnQkz6GCG3I395BWRr+FPY6XiMlP22XDli908ov2InsXzBB9VgN32HaYuzcX3B0c3Ksg474m1xbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406890; c=relaxed/simple;
	bh=7JYmd0UI1ocRAdPLxPTpUJR/Wt3tINaj/k21mdIzpwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKRREtenYYHGStsqNiZNv7TNlevnD9VX6YqGBh053WmZyOBuJsrhutfsxy1q662Qqcx6z7JUPoXvpSrGeuiQYI35qRnqpx6Bgnc0Xhx/5CABUb47mKGjxiFGM/bpKOnD3q3OoSFU8UNPZQSFPqFN9LhR8VhIsQhMIG7/S8skcBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ruEDXT/e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DnDGsNoi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g4S5EtaD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iKMO1eXT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ruEDXT/e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DnDGsNoi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g4S5EtaD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iKMO1eXT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D7F71FF18;
	Mon, 14 Sep 2026 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406882;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AnQemuye24Xbh9Fi684Z7TD3r+WVovAlzDQFhNpALfg=;
	b=ruEDXT/ec0W1y6KHBB2b1tuFq5B4UxCvL7rKZoG1HB7FtYR0H+8nJrfMAL12EJq1v47RqA
	iSBxpLVwcYkVxKWYVsfzQrqUTtMsOXciKwRG8r43wsIzzzMsI7tV6/AkcSSJtXoUtWo9zw
	RxAeIS3X7KzwoB/iJ3CDDx+J5FJjYW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406882;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AnQemuye24Xbh9Fi684Z7TD3r+WVovAlzDQFhNpALfg=;
	b=DnDGsNoiBVZ2cOarkhRYpwSGM/dOIxUDOHXUm3ERmN0oxeiHR4M5D+Uvd7vJcZX/hY6TU0
	ocN3ttktJJGuLbAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406878;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AnQemuye24Xbh9Fi684Z7TD3r+WVovAlzDQFhNpALfg=;
	b=g4S5EtaDLMDUiobeERA5RV3/P40FtEbJPDj/pKBS+WQ2Gyiwo0m26Zoc8c9ssHAv80eex1
	Wkd2GAUVVxfgclEl58S99zZ9Yb+zDN9o0XoTApow39PeYeNUGCGyb0DtI8vPB6F9Jiluu4
	7DQ/raBWiwECpkyaB5ZrJt9sz5f7glQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406878;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AnQemuye24Xbh9Fi684Z7TD3r+WVovAlzDQFhNpALfg=;
	b=iKMO1eXTgEgHcXlwB5d367PwiPyG0mXmN0SCwMM3E6FWx+0WQHUOxr8xpgP9Y7QUBs3GKq
	nxd2typTsmejq1CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E587F136A1;
	Mon, 14 Sep 2026 17:27:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FePIN50uqGpIawAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 17:27:57 +0000
Date: Mon, 14 Sep 2026 19:27:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: fix stale active zone after mkfs
Message-ID: <20260914172748.GQ54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, Sep 04, 2026 at 08:24:42AM +0200, Johannes Thumshirn wrote:
> On zoned devices, mkfs can leave a stale zone behind that is used as a
> staging area but never reset. This zone is not backed by a chunk or
> device extent, so the FS itself does not account it as used. On devices
> that have a limitied active zone budget this can lead to premature
> ENOSPC and/or an exhaustion of active zones.
> 
> Fix it in mkfs for new file-systems and also add a check to fsck to find
> such zones and repair them with '--repair'.
> 
> Changes to v1:
> - fix a bug in fsck where it had a stale return value propagated.
> 
> Johannes Thumshirn (2):
>   btrfs-progs: zoned: refresh stale cached zone state in
>     btrfs_reset_dev_zone()
>   btrfs-progs: check: detect leaked active zones on zoned devices

Added to devel, thanks.
