Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA3741C312
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781808716; cv=none; b=WCq8kSFWURgty9L0PSzeDvByLTQF7R0Q81KayC9ppbwGkNrFp0rpCu/f0GAeNVSxZKtlhfUJMTMIpexLnh2uSH7Gw6AhVB1CHvIIN6gbp8NcfBEv73mvlNnGz/jb4yB5SNUhoQjUnRmbgB13P7aIqJAzJrlpBaylyNeNdX9yMRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781808716; c=relaxed/simple;
	bh=JeUCIZMwjnufJKgr/0tNSGtXTOIq+y19ay0lvOe95sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/4AYPLyEjrUic+yqYJ2nxj+fBsuset6F51u6Vx+SGAomt+ysxdDEb4z+Elke6V7zz4Q3KpnxGjJKUcmqv4sg/R73ujuQKw/Eio2l7R0xjQRkatS5Vjbj3XdroK2pJWUNOKicOIhFOjVUlrMy9Nre21Z4QxQTvgr8qeUMWUos3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xzlva/KE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OMMufSs6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f/CZzqMc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T0b3lFhc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xzlva/KE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OMMufSs6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f/CZzqMc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T0b3lFhc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C80E75C38;
	Thu, 18 Jun 2026 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781808713;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JVqWTWidsgjS1ZR55qKBHXrfR7o1QHnI/p9FiRRbYkI=;
	b=xzlva/KECNc6DCn7kAOU1AzXfzDvbQPNtl/yYEAL6ssEHhtfz09osi6TZ1pLDOpnSG1aip
	BVGwF7PIDFr4R2BfAKl8u6uUG3rVRjQ6JSFpX5YRzlS5UP9FboUNbv8uaV1lZ3buy9NN56
	mnVf+GIM4c2Sk0t/kZqhWvJw3RO2YU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781808713;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JVqWTWidsgjS1ZR55qKBHXrfR7o1QHnI/p9FiRRbYkI=;
	b=OMMufSs6URxLoFrxdPsuNXkrDR3Q32f2/GTuJNnjm8AP5pd0+ppg68FjXXg9w7qMM0gs7U
	Wza9qyD0YRICDqBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781808712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JVqWTWidsgjS1ZR55qKBHXrfR7o1QHnI/p9FiRRbYkI=;
	b=f/CZzqMcf+r8dLm2mgrxEHZSBe2WzOOAdMdcRVcZPdDJGF+S1AxaPVQKWvNlSxxSrYtMWn
	wzZbLd4bS7TyJGYqgEsAXswAswFKOinGaLTiuAUosekXoFw7TebOCaSbleE7R5tZPEqLfW
	j6JDid71MpGrrLGNYyg2+clfC8ts/54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781808712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JVqWTWidsgjS1ZR55qKBHXrfR7o1QHnI/p9FiRRbYkI=;
	b=T0b3lFhcknqii56ut8sUpbLQrXkq5JfatCtnDtWo49Cmt5w21RR1O/co8bNKmqKT8k5iE6
	9ElnFfl1nKoCWaDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0480B779A8;
	Thu, 18 Jun 2026 18:51:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RVThAEg+NGo1HQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 18 Jun 2026 18:51:52 +0000
Date: Thu, 18 Jun 2026 20:51:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: disable v1 space cache
Message-ID: <20260618185146.GD1049224@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0884d7707a725ce5a41ea3931d65dabc76a5c864.1780999298.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0884d7707a725ce5a41ea3931d65dabc76a5c864.1780999298.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -4.00

On Tue, Jun 09, 2026 at 07:31:44PM +0930, Qu Wenruo wrote:
> V2 space cache is already the default mkfs option since btrfs-progs
> v5.15, and commit 1e7bec1f7d65 ("btrfs: emit a warning about space cache
> v1 being deprecated") has already added a warning to show v1 space cache
> is already deprecated.
> 
> It has been long enough that we should remove v1 space cache completely.
> 
> As the first step, disable v1 space cache by:
> 
> - Make "space_cache" mount option fallback to "nospace_cache"
> - Make "space_cache=v1" to fallback to "nospace_cache"
>   Which is the safer than forcing "space_cache=v2", as forcing v2 cache
>   will require removal of v1 cache and regenerate v2 cache.
>   Such operation can be slow, and will take extra metadata space, thus
>   it is not always safe for existing filesystems.
> 
> With this done, v1 cache mount will always fallback to nospace cache,
> and mount option will not be able to force v1 space cache usage.
> 
> For example, even for a fs with v1 cache:
> 
>  # btrfs ins dump-super test.img
>  superblock: bytenr=65536, device=test.img
>  ---------------------------------------------------------
>  csum_type		0 (crc32c)
>  csum_size		4
>  csum			0xdce44b2c [match]
>  bytenr			65536
>  flags			0x1
>  			( WRITTEN )
>  magic			_BHRfS_M [match]
>  fsid			7d7c3bba-8211-4206-868d-10eedd5703f8
>  metadata_uuid		00000000-0000-0000-0000-000000000000
>  label
>  generation		9
>  root			30605312
>  [...]
>  compat_ro_flags		0x0 << No FST feature
>  incompat_flags		0x361
>  			( MIXED_BACKREF |
>  			  BIG_METADATA |
>  			  EXTENDED_IREF |
>  			  SKINNY_METADATA |
>  			  NO_HOLES )
>  cache_generation	9 <<< Matches generation
>  uuid_tree_generation	9
> 
> Mounting it will lead to no space cache other than v1 space cache:
> 
>  # mount test.img /mnt/btrfs
>  # dmesg -t | tail -n 5
>  BTRFS: device fsid 7d7c3bba-8211-4206-868d-10eedd5703f8 devid 1 transid 9 /dev/loop0 (7:0) scanned by mount (1264)
>  BTRFS info (device loop0): first mount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
>  BTRFS info (device loop0): using crc32c checksum algorithm
>  BTRFS info (device loop0): turning on async discard
>  BTRFS info (device loop0): last unmount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
> 
> Even forcing v1 cache will not work, but fallback to the usual
> nospace_cache:
> 
>  # mount test.img -o space_cache=v1 /mnt/btrfs
>  # dmesg -t | tail -n 6
>  BTRFS warning: v1 space cache is deprecated, fallback to no space cache
>  BTRFS: device fsid 7d7c3bba-8211-4206-868d-10eedd5703f8 devid 1 transid 9 /dev/loop0 (7:0) scanned by mount (1264)
>  BTRFS info (device loop0): first mount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
>  BTRFS info (device loop0): using crc32c checksum algorithm
>  BTRFS info (device loop0): turning on async discard
>  BTRFS info (device loop0): last unmount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
> 
> And there will be no way to force converting a v2 cache back to v1, such
> attempt will only clear free space tree and fallback to no space cache.
> 
>  # mkfs.btrfs -f -O fst,^bgt test.img
>  # mount -o clear_cache,space_cache=v1 test.img /mnt/btrfs
>  # dmesg -t | tail -n 11
>  BTRFS warning: v1 space cache is deprecated, fallback to no space cache
>  BTRFS: device fsid f59daad2-3ab5-4f33-b752-a36cfb09b674 devid 1 transid 8 /dev/loop0 (7:0) scanned by mount (1419)
>  BTRFS info (device loop0): first mount of filesystem f59daad2-3ab5-4f33-b752-a36cfb09b674
>  BTRFS info (device loop0): using crc32c checksum algorithm
>  BTRFS info (device loop0): rebuilding free space tree
>  BTRFS info (device loop0): disabling free space tree
>  BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
>  BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
>  BTRFS info (device loop0): checking UUID tree
>  BTRFS info (device loop0): turning on async discard
>  BTRFS info (device loop0): force clearing of disk cache
>  # mount | grep /mnt/btrfs
>  /home/adam/test.img on /mnt/btrfs type btrfs (rw,relatime,discard=async,nospace_cache,subvolid=5,subvol=/)
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Ok great, this should cover the remaining possibilities. Please add it
to for-next, we can start removing the rest of v1 code afterwards. The
linux-next will be updated after rc1 so this won't be exposed to testing
until after that.
