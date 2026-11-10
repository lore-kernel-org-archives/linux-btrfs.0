Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272333;
	b=s18frIZupHHFQDU111uKXG82V5QVQKwmmWhiAF+C/0bqVTXzf3JhrV8IWCYb62BFp58z
	 IaHcIsUCqr6ylwaSsG9ebNIQc9zzMKAjm0y372FkUDBoMiGEERTziLedaImvherrct7J0
	 yp/saClqyF3IZtauQ98cqwMa0nlurZp2xvJuxUr9ilXsqH8VrIyjIHzVUB5Em5JW3tbdl
	 MzlPChAFqTon/hUK20+EkagLcQOd9atHenldOX8MWEmVaTz9/qKB3tJkEGAZijXx/B473
	 El7dRZopto8FcCaslr70lJcnKRuO6NPeTiyWvH7bpBglBbUz3Wn9nKwoIW41gGU6g3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272333;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=9lqqwcZ9XnbvHpSrJpxapi5L34S1YmBQvqDv/pgHJfs=;
	b=l23cjbwVcCKJ65lvW327USbOAGDvmkeTLE8R1Moa3wHr4OK+Z2iakd3GtqKeAkoa/dyr
	 Zb3gDNIMjpFngG0DvrF9aXMlcrAAD1xEPw6Wshm7P9vZYs35kLqn9sqp+jwUEYkbqFDGn
	 vxljam/VGUK89CgM6/HNkKUACi7wiMBITcKBvJ58Z5XodKvqzgr5GYJyPCS2kMSfjYEEM
	 ZVGZ1DhQsHVyr2QTseRH6+iHCaiV9+FGZ81gK0VF3F5EOlBmeI0g9R01Ye5LGq9W5MXer
	 aN4cn4Rv6mTdy8dkuG1M1pC9OeX2zYYAN2ync8TUjnh4jSGn3EfICaU9M8y1Teji1nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zHAludM1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BkUepYyq;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zHAludM1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BkUepYyq;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68878606A31C;
	Tue, 10 Nov 2026 00:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68878606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zHAludM1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BkUepYyq;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zHAludM1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BkUepYyq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3CE9D21FAE;
	Tue, 10 Nov 2026 00:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794272330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lqqwcZ9XnbvHpSrJpxapi5L34S1YmBQvqDv/pgHJfs=;
	b=zHAludM15y7EIEkCCM4s/AFQypniYwUdp9QWZWwgq3mjCCAP/O2DZHRoad1CT/vvAGv2FD
	sC8zDlLboI16Ex8/g8h7mVNZCDYqSzg3f6dOC/IFIlkhMULih69lDQs/1ri9xxMmRd2OdR
	AX39BGYrQHmGX6zWFeryAAWzG6GaPsE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794272330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lqqwcZ9XnbvHpSrJpxapi5L34S1YmBQvqDv/pgHJfs=;
	b=BkUepYyq4mmHQ223mOTu0lGKVytiV1RyCaDgqEgMEJmlPmYeBGJmx+Ps3KN48lSXap93X3
	hjOLXxw7ine2yvAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794272330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lqqwcZ9XnbvHpSrJpxapi5L34S1YmBQvqDv/pgHJfs=;
	b=zHAludM15y7EIEkCCM4s/AFQypniYwUdp9QWZWwgq3mjCCAP/O2DZHRoad1CT/vvAGv2FD
	sC8zDlLboI16Ex8/g8h7mVNZCDYqSzg3f6dOC/IFIlkhMULih69lDQs/1ri9xxMmRd2OdR
	AX39BGYrQHmGX6zWFeryAAWzG6GaPsE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794272330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lqqwcZ9XnbvHpSrJpxapi5L34S1YmBQvqDv/pgHJfs=;
	b=BkUepYyq4mmHQ223mOTu0lGKVytiV1RyCaDgqEgMEJmlPmYeBGJmx+Ps3KN48lSXap93X3
	hjOLXxw7ine2yvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E2B01339F;
	Tue, 10 Nov 2026 00:58:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5lr1Nkls8mrlagAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 10 Nov 2026 00:58:50 +0000
Date: Tue, 10 Nov 2026 01:58:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH v2] btrfs: remove devid kobject when deleting a missing
 device
Message-ID: <20261110005848.GG4186782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261026105109.1148939-1-teel4res@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026105109.1148939-1-teel4res@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.00

On Mon, Oct 26, 2026 at 03:51:09AM -0700, Cheng Yongkang wrote:
> btrfs_rm_device() removes the sysfs device entry only when
> device->bdev_file is non-NULL.  A missing device (created by
> add_missing_dev() for an absent disk) has bdev_file == NULL, but
> btrfs_sysfs_add_device() still registers its devid kobject under
> /sys/fs/btrfs/<uuid>/devinfo/<devid>.
> 
> When such a device is deleted, btrfs_free_device() frees the
> btrfs_device while the devid kobject remains registered.  The kobject
> is embedded in the freed btrfs_device and its show functions use
> container_of() to reach it, so reading any devinfo attribute is a
> use-after-free:
> 
>   BUG: KASAN: slab-use-after-free in sysfs_kf_seq_show+0x157/0x490
>   Read of size 8 at addr ffff88801d8172a8 by task poc/9385
>   ...
>   Freed by task 9385:
>    kfree
>    btrfs_rm_device+0x11ee/0x17b0
>    btrfs_ioctl_rm_dev+0x265/0x400
>   Allocated by task 9390:
>    btrfs_alloc_device+0x7e/0x400
>    device_list_add
>    btrfs_scan_one_device
>    btrfs_control_ioctl
> 
> The freed object is kmalloc-1k and the faulting access is 680 bytes
> inside it (offsetof(struct btrfs_device, devid_kobj) = 640 plus
> offsetof(struct kobject, ktype) = 40), confirming the embedded
> devid_kobj.
> 
> btrfs_sysfs_remove_device() already skips the block-device link when
> device->bdev is NULL and only touches the devid kobject when it is
> initialized.  Call it for missing devices too.
> 
> Link: https://lore.kernel.org/all/20261025180252.349049-1-teel4res@gmail.com/
> Fixes: 668e48af7a94 ("btrfs: sysfs, add devid/dev_state kobject and device attributes")
> Cc: stable@vger.kernel.org
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
> v2: add Link, Fixes and stable tags, keep the Reviewed-by because the code is
> unchanged, and remove local validation details from the commit message.

Added to for-next, thanks.
