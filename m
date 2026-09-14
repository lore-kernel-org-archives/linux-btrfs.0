Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE457481FCA
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406180; cv=none; b=MYyjBTZGLEDCGIWADnALwGPyYxqAifqu9LrvcQVdGg375ZSMt2Ze1SGxU7RtSoXcZN9vH4rVWx+jnqAvKpFzQffZokv9TRGWVS6zjEwkykUrT27jSvIc9P7aN5NEAkp7aRY0ldnkIZv/7odIKp/RUw5ha4BNKTB7mbyNZgPI9kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406180; c=relaxed/simple;
	bh=FbSR7BNIMpLuzCtvW/xo1OdNcSgQnSgX5aapBDr0Yp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnmSyTFGb65whRjJnQwABD1fvI4GNaVZbhmWHWUjYIEvD0sSLrF/iOOHvP9YAaXB10kix1RWGZnHgJrMEQ2tx96xGp1FxacTDaTZFPq9HUrzHOjtfJaeKBjrXNZaqu2WT7U+i8NxbR6NhUI8afmsVSR4jpmkIDHirawYzLKkXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y2863RVS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fAbdnOcH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fEqNMsot; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X47zjpQg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y2863RVS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fAbdnOcH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fEqNMsot";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X47zjpQg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84EE21FF25;
	Mon, 14 Sep 2026 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406171;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KfRGnpeD9VCpfkMaeOSCxpjCFBvjvC2f5CNPFhE/AFM=;
	b=Y2863RVStzWeH6yoM84bWVre/rgLFt706kzoZQiHIdICYBKwvCJSpuPIwcXpxsVAtR8mDI
	y8qPiBCxVQ3l5ie2PCecqeIlOArbxpBRM7TkEiX6SwsVP0TlG2Uit0A2ItJN+Ivap2gWqw
	RTNbD5P5egafLeQ6EU5/kY0WURfLXto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406171;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KfRGnpeD9VCpfkMaeOSCxpjCFBvjvC2f5CNPFhE/AFM=;
	b=fAbdnOcHt5JGx3qhJxRANkJlhFwlkL++rhzQz+pmMQ8BQjkEGa+eg3m2v6IcTUDwgqjsI+
	NkFFAEWGExAOAJCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fEqNMsot;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X47zjpQg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KfRGnpeD9VCpfkMaeOSCxpjCFBvjvC2f5CNPFhE/AFM=;
	b=fEqNMsot6udWUYDr6WZduunOiQGyS76JWBhPCV7Iu8jyyMRPj78TruGy2N9CfhBGZcpmEG
	ibYP6gpsho/pcncf/yZp8Yfxm2VbZMs+wiRH+yEXOpF3phasnt0Q39qQnkD7hSCyqeVAVl
	8VUtVKxKUpJ7bOW2jVAKUs3xcn5XUFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KfRGnpeD9VCpfkMaeOSCxpjCFBvjvC2f5CNPFhE/AFM=;
	b=X47zjpQg4dYudKL5sEfw9gKKbiH3TidQkyjCJ2H1HxqfT1pNF8DIq6tWplQX7d1XTuw90g
	mVytk0kF1cxBw0Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52DD313693;
	Mon, 14 Sep 2026 17:16:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h/X8E9crqGrKXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 17:16:07 +0000
Date: Mon, 14 Sep 2026 19:16:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
Message-ID: <20260914171602.GO54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 84EE21FF25
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sat, Sep 12, 2026 at 06:12:06PM +0930, Qu Wenruo wrote:
> [BEHAVIOR CHANGE]
> Since commit 108cc8733989 ("btrfs: fix a lockdep caused by path
> resolution during device scan"), users with btrfs rootfs but without an
> initramfs are complaining that grub2 can no longer detect the rootfs
> device:
> 
>  /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
> 
> [CAUSE]
> Although using btrfs without an initramfs is not recommended (if a new
> device is added to the rootfs, the system can no longer boot, as there
> is no way to register all devices), there is still a minority of users
> doing this.

To avoid scanning there's the -o device=/path mount option, passed as
"rootflags=" kernel parameter.

The initrd-less systems exist, I think most users are in embedded space
and there the multi-device root filesystem is not expected. For quick
boot VMs it's orders of magnitude faster than e.g. systemd. It's
probably a minority compared to the number of systems with initrd, but
still it's a valid use case.

> If there is no initramfs but the rootfs is on a block-device-based
> filesystem, the kernel boot sequence initializes a minimal ramfs/tmpfs,
> creates "/dev/root" with the proper device number for the rootfs, and
> then invokes mount using "/dev/root".
> 
> That's why the end user will get the mount output:
> 
>  /dev/root on / rw
> 
> To be honest, this is a user space problem: no one should trust the
> device path shown in mount, only the device number.
> 
> E.g. one can even use "/proc/self/fd/*" to mount an fs, and that proc
> path will be registered, and no one else can mount that fs using that
> path.
> 
> Before commit 108cc8733989 ("btrfs: fix a lockdep caused by path
> resolution during device scan"), btrfs had an internal path lookup
> workaround to address such weird paths, it works by checking if the
> existing device path can still resolve to the device number.
> 
> But that path resolution is deadlock prone, thus it's replaced by a
> simple devt check.
> 
> This works fine in most cases, as a btrfs device is registered by udev at
> boot time, thus all paths are sane.
> 
> However this will not work for systems without an initramfs, causing the
> unreachable "/dev/root" path to exist forever without a way to rename
> it.
> 
> [WORKAROUND]
> Despite updating the docs to discourage root btrfs without an initramfs,
> add an exception to the device path rename requirement.
> 
> If the device has the name "/dev/root", we know it's booted without
> an initramfs, and only for that case we allow device path update.
> 
> And if someone intentionally created "/dev/root" after boot, the
> existing devt checks will reject that weird name as usual.
> 
> This should satisfy the minority of users, and still keep most of the
> existing guards preventing unexpected/unnecessary device path updates.
> 
> But still, I prefer grub2 to implement a more robust device
> number based probing, and no one should use btrfs as rootfs without an
> initramfs.
> 
> Fixes: 108cc8733989 ("btrfs: fix a lockdep caused by path resolution during device scan")
> Link: https://lore.kernel.org/linux-btrfs/CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com/
> Link: https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4ddabadc9188..b61c68871c0b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -749,6 +749,36 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super_block *sb)
>  	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
>  }
>  
> +static bool should_rename_device(const struct btrfs_device *dev)
> +{
> +	bool ret;
> +	const char *old_name;
> +
> +	rcu_read_lock();
> +	old_name = rcu_dereference(dev->name);
> +	/*
> +	 * For systems booted without an initramfs, the rootfs has the device
> +	 * name "/dev/root".
> +	 *
> +	 * Although using btrfs without an initramfs is not recommended (if a
> +	 * new device is added to the rootfs, the system can no longer boot, as
> +	 * there is no way to register all devices), there is still a minority
> +	 * of users doing this.
> +	 *
> +	 * And after the system is up, a later device scan on the real block
> +	 * device file will never get this device's name updated, as the
> +	 * device->devt is still the same.
> +	 *
> +	 * Here we add one and only one exception for "/dev/root", to allow
> +	 * the device name to be updated even if the new path points to the
> +	 * same block device.
> +	 */
> +	ret = !strcmp(old_name, "/dev/root");

That's probably a sane workaround, the "/dev/root" has been part of the
ABI, nothing needs the exception.

> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  /*
>   * Add new device to list of registered devices
>   *
