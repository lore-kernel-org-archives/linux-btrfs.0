Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898F03DE45C
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 09:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777366908; cv=none; b=ts9ZKnf/6wKJYusqwJCidXnYgX/F5gDwfM3fjBgsEYldYFSr0qkVTx/qYZXoClEg1BP1xmDFhMFVRLPaLEWIncSQWz8jb0Z01UQeKVPlsDBHoRe2ECilNN76MCAatUd6hKKvxJruG//tASNlCxIIj7PVZEJ3NP5AOGF14CcCqaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777366908; c=relaxed/simple;
	bh=ATUenrdzdsDDv4xgzHDKlg/UvSRIgGxAyNelp6VoFFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slLizNljl5EI4s1nMBPeKngfWHjhxMImaCpoRB4zESFHuG55rAGS5F46kfdtvV7fJ5J6iQOWPA4V/MtyhFbxkoMOucw5JVib6TE2urLO20f+o8FIS5F4B6ThQLx1oA6w4JWBRNtbTSafAmklBX85+jUoJYJ28YyVBaP7r57mamQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yz9rCny9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pft3EcBR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vANvwuqa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hMzBpiJs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yz9rCny9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pft3EcBR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vANvwuqa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hMzBpiJs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 70C1A5BCD7;
	Tue, 28 Apr 2026 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777366894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FQ2RmcYF2LrTI2o3E9qwBujLOrqeLOmvV233NPHpGg=;
	b=Yz9rCny9upbQrt+juwW/hSmwBpggFDhWzW776/YWFIQsfp57BLHzSczbchuaASH0aupYR5
	3GQfX/wZDZBt3XSiIQ2Rm9tQTbT99Vpaol16WabzkZ7dr211U44xhg0AM+isnSXPbAz9To
	Vev2tYTWsEa/rQ2w/KcDEH6hpDZBZDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777366894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FQ2RmcYF2LrTI2o3E9qwBujLOrqeLOmvV233NPHpGg=;
	b=Pft3EcBRkF0AoTRRTVDCIUa47gUrEXObSCGN2iTrdJUbs1SHuWeu86n8PHU3TKo2FplLCw
	sAtkrk5HkSitUxBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vANvwuqa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hMzBpiJs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777366889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FQ2RmcYF2LrTI2o3E9qwBujLOrqeLOmvV233NPHpGg=;
	b=vANvwuqa9o6+vc+SjTx1/i5/tBjG7YLP9z6Dc38KRbEjRBgTBleEevD65Z7DPBwureVIHX
	otav2ibohS2IVrokrdtrG4TogHWVJZJ1aXlBWFgWBYhrXK2fejUOPglyqRVIzJMkXkaze5
	1ouJIWqtYlO3bvbCaQjz0XxWCJtenms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777366889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FQ2RmcYF2LrTI2o3E9qwBujLOrqeLOmvV233NPHpGg=;
	b=hMzBpiJswQYqQcMRUH+S3QT8lX7sHT7Oqm1Dh9gDGJCODC1CnyrdSx5UamoeL0WJTJNA8l
	G3QTrUNL4gDlCfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 684F2593B0;
	Tue, 28 Apr 2026 09:01:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6Z9xGWl38GmgVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Apr 2026 09:01:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1C059A0B62; Tue, 28 Apr 2026 11:01:29 +0200 (CEST)
Date: Tue, 28 Apr 2026 11:01:29 +0200
From: Jan Kara <jack@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Jan Kara <jack@suse.cz>, Qu Wenruo <wqu@suse.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Limit size of bios submitted from writeback
Message-ID: <z3wl4vw2jjaamcaebienk2qnln3crn466uhuxmtm5s2ttjwwgv@vr7trdd2kzfr>
References: <20260423093052.13219-2-jack@suse.cz>
 <5e19c224-b007-43f9-aa73-3016b5e8ce2c@suse.com>
 <jfq3okghxlwr2ppqtrfold2emgqu3ermkgs2jwoiig4hivtpwo@s2wxyvncqpw4>
 <50baea0e-fed6-4d7e-a9d5-d67ac67a7926@gmx.com>
 <0fd4ea4b-8f8a-4f0a-8923-17b038fe2745@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0fd4ea4b-8f8a-4f0a-8923-17b038fe2745@gmx.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmx.com];
	RSPAMD_URIBL_FAIL(0.00)[suse.com:server fail];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 70C1A5BCD7
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Tue 28-04-26 09:18:38, Qu Wenruo wrote:
> 
> 
> 在 2026/4/27 19:20, Qu Wenruo 写道:
> [...]
> > > Yeah, at this point I'm not sure the complexity is worth it.
> > > Normally added
> > > disks have very similar parameters as existing ones, also even if
> > > they are
> > > somewhat different, it will cost you a few percent of writeback speed at
> > > worst which doesn't seem too bad and it will "fix" itself on next mount.
> > 
> > Thanks, we're on the same page.
> > 
> > Now the patch is pushed to for-next branch, with one typo "miliseconds"
> > fixed.
> > 
> > Thanks,
> > Qu
> 
> Just a minor update.
> 
> The existing check is considering device->bdev always exists, but we can
> have missing devices which doesn't have device->bdev, and this will cause
> NULL pointer dereference during test cases like btrfs/027.
> 
> Fixed in for-next branch with the following small diff:

Thanks for the fixup!

								Honza

> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8d36e8a9f0d9..93a923e4ecaf 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8224,6 +8224,8 @@ int btrfs_init_writeback_bio_size(struct btrfs_fs_info
> *fs_info)
>                 struct request_queue *queue;
>                 unsigned int io_opt;
> 
> +               if (!device->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
> &device->dev_state))
> +                       continue;
>                 queue = bdev_get_queue(device->bdev);
>                 io_opt = queue_io_opt(queue) ? :
>                                 queue_max_sectors(queue) << SECTOR_SHIFT;
> 
> Thanks,
> Qu
> > > 
> > >                                 Honza
> > 
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
