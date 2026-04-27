Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE903ACF10
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280648; cv=none; b=NLxYeyHCIP7sj66b/yX+lTWBeLopZ1OokdihrWfNAkGVFIkEYcw+8vCG/WWuZeRdUlq8zTYBXco5Fs/QI4O2DSvadQeFC3FXZV962seTPpghaijcIw0O5NTtjYcVKdh0dEyL3fc5sjbuioMavi0cm5bPzI+yPiGDCq5224SQEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280648; c=relaxed/simple;
	bh=MdP27K6N5AiH7ngJDQg2JcNJo8TsKC2S7BnbLy2AD/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rw7636+4tjaRA94DoMccDmsqJsrCN6VEEXC8NPFOIrZZifLADNniVV8p4PM9NpA4bQEBiqMlglE494g9PaDrXzavsDcaA1Vlb4OZ7hESqBMCM0FaJiH5P7MYxSWzn5AFCFq+N9hHp1KrD4wr7vEfVoiqB0YMAHvsIhj8zmE+3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LEEc1V1v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QY+HLYdd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=svl5diNM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iE6d+4ZP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LEEc1V1v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QY+HLYdd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="svl5diNM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iE6d+4ZP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFC5F6A8EA;
	Mon, 27 Apr 2026 09:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777280645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbyDbXe46sVOroKCVaIYO9qf0abHvUSpTkHy2hABgUc=;
	b=LEEc1V1vWSQNlHybo3VtRHIFGeYPmRElEOOfSF/VW6o4w9tvsDpJ8kus+dh1QZl4AFdUuV
	M3EgRxRlqq17jV6vxMXqUWeGXcA24P9IzUjfEyiXQGdzeDzdRgkLAhRwdHBApkEhp4gxy8
	VpF8LuwyyvAvSwg+23y8Xe8KEWhO6Lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777280645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbyDbXe46sVOroKCVaIYO9qf0abHvUSpTkHy2hABgUc=;
	b=QY+HLYddVL+8VfiQFTVJzwZYm3v24+BxX1SYmBh6ytu79qjT3MvJNfFTCGDy6NoMXXin5D
	a8GJKqcCo+RzyIBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777280643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbyDbXe46sVOroKCVaIYO9qf0abHvUSpTkHy2hABgUc=;
	b=svl5diNMbZOpwWmBIiyUGQsrGgAKgIQfE+QPL4Aysbn/eUJAQMw0miDQ4iJ09j7yQE47Wc
	oDmvb2oM81qdKtbuL63fxIK+hBBPKfK56SHj50YwIWgGc5J4LF62KV0UEGT0QHCwoBafpT
	gucelXriG8Pokfi7lizHxITpX3E8erU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777280643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbyDbXe46sVOroKCVaIYO9qf0abHvUSpTkHy2hABgUc=;
	b=iE6d+4ZPUM4Q6zEsz7/Ph8gop/4yMo21qbZ164Sp68lFTCvnCI3QWM9/fusNORFyLZbtc0
	cPFhelB+6YkJq2CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7B3D593B0;
	Mon, 27 Apr 2026 09:04:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HBrSLIMm72lFPgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Apr 2026 09:04:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7494CA0B73; Mon, 27 Apr 2026 11:03:48 +0200 (CEST)
Date: Mon, 27 Apr 2026 11:03:48 +0200
From: Jan Kara <jack@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Limit size of bios submitted from writeback
Message-ID: <jfq3okghxlwr2ppqtrfold2emgqu3ermkgs2jwoiig4hivtpwo@s2wxyvncqpw4>
References: <20260423093052.13219-2-jack@suse.cz>
 <5e19c224-b007-43f9-aa73-3016b5e8ce2c@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e19c224-b007-43f9-aa73-3016b5e8ce2c@suse.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu 23-04-26 19:24:02, Qu Wenruo wrote:
> 
> 
> 在 2026/4/23 19:00, Jan Kara 写道:
> > Currently btrfs_writepages() just accumulates as large bio as possible
> > (within writeback_control constraints) and then submits it. This can
> > however lead to significant latency in writeback IO submission (I have
> > observed tens of miliseconds) because the submitted bio easily has over
> > hundred of megabytes. Consequently this leads to IO pipeline stalls and
> > reduced throughput.
> > 
> > At the same time beyond certain size submitting so large bio provides
> > diminishing returns because the bio is split by the block layer
> > immediately anyway. So compute (estimate of) bio size beyond which we
> > are unlikely to improve performance and just submit the bio for
> > writeback once we accumulate that much to keep the IO pipeline busy.
> > This improves writeback throughput for sequential writes by about 15% on
> > the test machine I was using.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks great!
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Just one minor question inlined below.

Thanks!

> > +int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
> > +{
> > +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> > +	struct btrfs_device *device;
> > +	u32 writeback_bio_size = fs_info->sectorsize;
> > +
> > +	mutex_lock(&fs_devices->device_list_mutex);
> > +	/*
> > +	 * Let's take maximum over optimal request sizes for all devices. For
> > +	 * RAID profiles writeback will submit stripe (64k) sized bios anyway
> > +	 * so our value doesn't matter and for simple profiles this is a good
> > +	 * approximation of sensible IO chunking.
> > +	 */
> > +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > +		struct request_queue *queue;
> > +		unsigned int io_opt;
> > +
> > +		queue = bdev_get_queue(device->bdev);
> > +		io_opt = queue_io_opt(queue) ? :
> > +				queue_max_sectors(queue) << SECTOR_SHIFT;
> > +		writeback_bio_size = max(writeback_bio_size, io_opt);
> > +	}
> > +	mutex_unlock(&fs_devices->device_list_mutex);
> > +
> > +	fs_info->writeback_bio_size = writeback_bio_size;
> 
> With this simplified version of optimal io size detection, do we want to
> hook dev add/removal/replace to update the calculation?
> 
> I guess in the real world, the added/removed/replaced disks should have all
> the same performance parameter for server usages, so no difference there.
> 
> And for personal/pro users, I doubt if the original performance problem is
> even noticeable for most end users.
> 
> So overall I'm fine either way.

Yeah, at this point I'm not sure the complexity is worth it. Normally added
disks have very similar parameters as existing ones, also even if they are
somewhat different, it will cost you a few percent of writeback speed at
worst which doesn't seem too bad and it will "fix" itself on next mount.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
