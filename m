Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A96F3D171E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776862189; cv=none; b=fQJxb6WpRV+9I4p6eEEQOX7VrmstCRsE9HUDhntCWR8a0bSkyY5aSLVuqj6rkkFynuU9h5vRUfhsgOXHgKh+u8vJxKAMI1nC7xg/003MueW4PIv3L4C2JlCAg8VlJ6C2j6PTNiW7LDHDVt2Vdl2PshZVCtrPyd3RYmKblMqjEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776862189; c=relaxed/simple;
	bh=48RkodDZeAmHKucuWGLaWSnq3GseoQguAKT+EzJIUro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avpg1tWf+cAhaJrs/VX9p0mph7MuTizRpoxeNzaCuzN+55p4hTVKbkYP4HdNln8ON4O2oT3GNJWG24gYcaXfewnf0qjuBvRiKv/E+Na8AU5OBKgZiTkmbPJCvln61BC6FCtiyfbYk/rcnBbdHJqlHcv3y48p0FA6ZgQ/cFm6ZYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=URRnOt2Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4CLTCP26; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VitTVKnM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKU/8o5Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="URRnOt2Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4CLTCP26";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VitTVKnM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKU/8o5Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFC165BD56;
	Wed, 22 Apr 2026 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776862186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwZ7iUsDSxBJ6SaKp0yDR3NKE5yrCzqwYoDd1G0JSaE=;
	b=URRnOt2YuyvfGZlaztTAmUUjIAqVm3ytmsUGrTXceaKnXzCvrkNqUbQVJfY8c5hk6BW5FL
	Z9OPy8lHTrxs9Oa79/axUAlAnClAvw06igImnFQoFoekf7HQnX6Pgacf35Jr9g3AdOygdd
	D2gR5jrZo1aVOyn1qG2Ze05F86aRiZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776862186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwZ7iUsDSxBJ6SaKp0yDR3NKE5yrCzqwYoDd1G0JSaE=;
	b=4CLTCP26j3leRPflcv2AECUadg1w1unGPWLNL8hYsws5evF83foyVmMjynJfQSLG2Od8I9
	JOD037A98hlag5DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VitTVKnM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XKU/8o5Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776862185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwZ7iUsDSxBJ6SaKp0yDR3NKE5yrCzqwYoDd1G0JSaE=;
	b=VitTVKnM+3QBXQmvIY8cDy7h7+VQQqtZwvWt323itWwuIAz5D+hTm+2gR01Iwtn+AWvugN
	yJ+7dlZFk52MuTtVkYZiMRMfO2XBWnYoK5Ct5NlDqP86uzG5Fc43Mfmzht4HexonxC4O80
	IQ7Smxkkf/Pf+N2wPun0t5mIfjTmT1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776862185;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwZ7iUsDSxBJ6SaKp0yDR3NKE5yrCzqwYoDd1G0JSaE=;
	b=XKU/8o5Z0FA4NCY+sFgpmcwZkn59b//hhiT7+54IanCk7L/HW0OeM59/zPt9OAVTz5hYSN
	w600zGVpBRVaFkBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8210593AF;
	Wed, 22 Apr 2026 12:49:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 203VMOnD6Gn7fwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 12:49:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6D55EA0B44; Wed, 22 Apr 2026 14:49:45 +0200 (CEST)
Date: Wed, 22 Apr 2026 14:49:45 +0200
From: Jan Kara <jack@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Limit size of bios submitted from writeback
Message-ID: <kfksarpckjgqr52rk2p2uhabgb666rfrp2hewnra7mbzbcujqr@5pwsegezuzuf>
References: <20260422094255.12672-2-jack@suse.cz>
 <2f467264-0f15-4ced-858e-bbfdad4dcefa@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f467264-0f15-4ced-858e-bbfdad4dcefa@suse.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DFC165BD56

On Wed 22-04-26 19:59:38, Qu Wenruo wrote:
> 
> 
> 在 2026/4/22 19:12, Jan Kara 写道:
> [...]
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index ca3e4b99aec2..9c603d59a09b 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2555,6 +2555,16 @@ static int extent_write_cache_pages(struct address_space *mapping,
> >   				break;
> >   			}
> > +			/*
> > +			 * If we have accumulated decent amount of IO, send it
> > +			 * to the block layer so that IO can run while we are
> > +			 * accumulating more folios to write.
> > +			 */
> > +			if (bio_ctrl->bbio &&
> > +			    bio_ctrl->bbio->bio.bi_iter.bi_size >=
> > +			    inode_to_fs_info(inode)->writeback_bio_size)
> > +				submit_write_bio(bio_ctrl, 0);
> 
> I'd prefer to move the check a little earlier, better inside
> submit_extent_filio() where we already have a similar check for ordered
> extent boundaries.
> 
> One reason here is, we're considering huge folio support recently, and with
> huge folios on arm64, we can have a folio as large as 32MiB, thus for the
> worst case we can have a bio as large as 96MiB before submitting it.

Ok, done.


> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index a88e68f90564..cb654e990333 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -8179,6 +8179,60 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
> >   	return ret;
> >   }
> > +/*
> > + * At maximum we submit writeback bios 64MB in size to avoid too large
> > + * submission latencies
> > + */
> > +#define BTRFS_MAX_WB_BIO_SIZE (64 << 20)
> > +
> > +int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
> > +{
> > +	struct rb_node *node;
> > +	u32 writeback_bio_sectors = 1;
> > +
> > +	read_lock(&fs_info->mapping_tree_lock);
> > +	/*
> > +	 * For each data chunk compute the size of bio large enough to submit
> > +	 * optimum size request for each of chunk's disk and take maximum
> > +	 * over all data chunks.
> > +	 */
> > +	for (node = rb_first_cached(&fs_info->mapping_tree); node;
> > +	     node = rb_next(node)) {
> 
> Iterating through all chunk maps may take some time for huge filesystems.

Yeah, I was wondering a bit. But since this is done only on mount, I
figured it doesn't matter much.

> Meanwhile the device list is way smaller than the chunk maps, what about
> iterating through all devices instead?

I was thinking about that as well. But as you can see below, we also need
to know how the devices are put together in a raid and AFAIU that
information isn't there at the device level... If there's some better data
structure to iterate to get information about raid configurations of all
pieces of btrfs filesystem, I can certainly use that.

> Not to mention we are going to hit the same devices again and again through
> the chunk maps.
> 
> This may not handle all corner cases, e.g. a fs with new disks added, but
> should handle the most common cases pretty well.

Yeah, I decided not to care about device hotplug. But I still want to
pick bio size large enough to fill each data disk in a raid with at least
io_opt large request.

> > +		struct btrfs_chunk_map *map;
> > +		unsigned int data_stripes, opt_rq_size = fs_info->sectorsize;
> > +		int i;
> > +
> > +		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
> > +		if (!(map->type & BTRFS_BLOCK_GROUP_DATA))
> > +			continue;
> > +		data_stripes = calc_data_stripes(map->type, map->num_stripes);
> > +		for (i = 0; i < map->num_stripes; i++) {
> > +			struct request_queue *queue;
> > +			unsigned int io_opt;
> > +
> > +			if (!map->stripes[i].dev)
> > +				continue;
> > +			queue = bdev_get_queue(map->stripes[i].dev->bdev);
> > +			io_opt = queue_io_opt(queue) ? :
> > +				queue_max_sectors(queue) << SECTOR_SHIFT;
> > +			opt_rq_size = max(opt_rq_size, io_opt);
> 
> I'm wondering if we should use the minimal or maximum size.
> 
> If the optimal io sizes are very different, e.g. 512K vs 128M, the final
> result will be truncated to 64M, would a 64M io submission stall the
> pipeline for that 512K device?

So optimum IO sizes reported by devices are usually in 128k to 1m range,
the largest I've seen was 4m, so you usually won't get that large spread.
Also I don't think a setup which mixes wildly different disks in btrfs data
block groups is sensible and common enough to care about. In the worst case
such users won't get the performance boost offered by this optimization...

The trimming to 64m mostly happens to deal with situations where someone
has insane amount of drives striped together or some buggy device reports
some absurd value.

How large bio leads to IO stalls is impossible to say in general. It
depends on the speed of IO submission (including crc computation and all
the other stuff btrfs needs to do) compared to the disk throughput. 64m is
from my experiments enough to already cost say 5% of your writeback
throughput on the system I was testing with.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
