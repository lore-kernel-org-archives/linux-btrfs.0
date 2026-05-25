Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B237DAA0
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779712300; cv=none; b=aiZroZeVxHqxTzpzzdzBBGBJ9ZK0g1I6MyUra1PLHkgMw5RC+kkJcxLNXiBApGg7NXFhGmmZJDPs18/qhHH/1TLJ5QG9BGDSXF6Ab0G8/qGatnJqaYk9HSblxayP6mjkLias+JNuoEz9ekUjDfrmAWAS1kGDeAyOJFinV0V0HZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779712300; c=relaxed/simple;
	bh=wyBWdPjTUPjoF+Q0TakJhH5JAZyB1kjLnSSqoQSn+aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdsQiRp2z2G3Ryq+YVnpX/UpQbwYeNM7lOaXTDl5B6xV9S9x1j5rWXl0LdOcQTwRaVBnOP3BbRK0TPV27enQ8o35DMVpYNDSAvZZF1vybwNKMH53tG/ktyB225tcDJuceY4hlFX/+Mgr9Dk+JsG4ILFwJeJgMf0BHIuD0OIP6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VTh31laP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=j+uSP2+a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FUsWgTLD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QpCOJ6uc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VTh31laP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="j+uSP2+a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FUsWgTLD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QpCOJ6uc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D68E7759B8;
	Mon, 25 May 2026 12:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779712297;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czsKC+AcEIW2WRwIZFCx4xpdnIlbDILEo06ESvoZE3Q=;
	b=VTh31laPpc1U2znzoK1YmEV+b7Um2sswd+SF2tWPeJgglwd+x4r7EJbHBa39tvFYfu05Fi
	p8zhWsElFzwp/LG9w+ksXnSeSszZGzqH2H47P90ymO45XO0SSuchsPvv3HEoz6hPbXi38S
	E9NFTG8JEuEFlc3+WITeAue5aaA+xuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779712297;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czsKC+AcEIW2WRwIZFCx4xpdnIlbDILEo06ESvoZE3Q=;
	b=j+uSP2+aQn0qXOsCtqng+Ya7T4uxypMSSfBDuIPNlLqxHn4De/o2CeOk898TYlfQLo/TxI
	x6T7AyiaiJ5/GpDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FUsWgTLD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QpCOJ6uc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779712296;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czsKC+AcEIW2WRwIZFCx4xpdnIlbDILEo06ESvoZE3Q=;
	b=FUsWgTLDfkthYZXF7DL+3/yCx7+Jr+LzP2r2EOqmULA4Ft/FcVMAxNVBlspH30x2MPli/B
	uz2vpGUaJO4GvDPxmsn7+ybnxGp/uIAREihRyXQilyRnK29/93YxfxK3fYnXNVACicOcY8
	1azk7LlFD11Wz5Qrl/ID3wXyHcdJpd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779712296;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czsKC+AcEIW2WRwIZFCx4xpdnIlbDILEo06ESvoZE3Q=;
	b=QpCOJ6ucFcb7ciqGUQ540mpqBTxu2AkftSKVtz/slM4qVV3V9uYnuFSUWjTitkjMyRn/+M
	E2l42MTmn8dLl4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACC7159C42;
	Mon, 25 May 2026 12:31:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3G/7KChBFGr/PQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 12:31:36 +0000
Date: Mon, 25 May 2026 14:31:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v4] btrfs: zoned: always set max_active_zones for zoned
 devices
Message-ID: <20260525123131.GA12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260522092212.31118-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522092212.31118-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: D68E7759B8
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri, May 22, 2026 at 11:22:12AM +0200, Johannes Thumshirn wrote:
> When a block device does not report a maximum number of open or active
> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
> zones.
> 
> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
> internal max_active_zones limit will stay at 0, even if the device has
> zone resource limits. Furthermore, if the device has a total number of
> zones that is less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones
> should be set to at most the the number of zones.
> 
> Also move the max_active_zone calculation and setting into a dedicated
> helper, to shrink btrfs_get_dev_zone_info().
> 
> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Added to for-next, with a minor fixup in the error message. Thanks.

> ---
> Changes to v2:
> - prefix error message with zoned, remove capitalisation and .
> 
> Changes to v2:
> - Remove the now pointless 'if (max_active_zones)' before validating
>   nr_active <= max_active_zones
> 
> Changes to v1:
> - Check if the device has enough zones to run BTRFS
> - Move all the setting to a seperate function
> - Never run with less than BTRFS_MIN_ACTIVE_ZONES
> ---
>  fs/btrfs/zoned.c | 63 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 38 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0b80b498fb85..1a8c1078fa0a 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -354,12 +354,32 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
>  	return ret;
>  }
>  
> +static int btrfs_get_max_active_zones(struct btrfs_device *device,
> +				       struct btrfs_zoned_device_info *zone_info)
> +{
> +	struct block_device *bdev = device->bdev;
> +	int max_active_zones;
> +
> +	if (zone_info->nr_zones < BTRFS_MIN_ACTIVE_ZONES) {
> +		btrfs_err(device->fs_info, "zoned: not enough zones to mount filesystem");

I've added the numbers from the condition so it's clear.

> +		return -EINVAL;
> +	}
> +
> +	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
> +					bdev_max_open_zones(bdev));
> +	if (!max_active_zones)
> +		max_active_zones = min(zone_info->nr_zones / 4,
> +				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
> +
> +	zone_info->max_active_zones = max(max_active_zones, BTRFS_MIN_ACTIVE_ZONES);
> +	return 0;
> +}
