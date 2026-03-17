Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299FA29D273
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764215; cv=none; b=FRAiFY457tgMRphTJoj4Hgk4XhUahE8KAKsap+0Wfvt6CMCEmC2IQiPlMyhumQ23Ikv5q+jhB/RsrK7LY2so2cvj51IXy6XnZj5E7SIQdQPf+xd7U+yObGllbLfL3FKHZfprv5GgoVjekniAKK4pxZEgU8aDXZA4GZ5kkl82wHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764215; c=relaxed/simple;
	bh=i9WJidorIM8nGjBFS/q4hFn/fW4fsJ3kQMjQXQ77LEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZlIS1jMWJ3FRenS263ThqszoMuupuU+SvQYAzi26MlOtslitdD+7hPm24bN5eeR8G/7A11C8vz2tlMaVX0O64Ljqss08jphpEuofnTvxA7HaIsuMfHvnvu0vbVYICXbKvPjJFWwTmbnxB2MLMSZF0aDlG0IOA3LmUFJ5okmBmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gvKDOdcB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kh9zOhKE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gvKDOdcB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kh9zOhKE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gvKDOdcB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kh9zOhKE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gvKDOdcB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kh9zOhKE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54E074D37D;
	Tue, 17 Mar 2026 16:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jgPvul/UVbZusAUJxiEsmfcslqHHzKzH8MrIn2PIR8=;
	b=gvKDOdcBXhNWppH1pXyaXV6I7yFOH/OxEt/VfskL2zSU2/AnRKLCosanmOTM/Lse1dNkyQ
	5Egth5De3oA7pUkgN8snbGqNtqm6r7Vr3khfBEl0KBSNnpYOx2vI/B7Ne26qcYjpkrWvoP
	FJvs9z/jPQtS/JtK2ZjsGaLmRxmW+ZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jgPvul/UVbZusAUJxiEsmfcslqHHzKzH8MrIn2PIR8=;
	b=Kh9zOhKERKvIh1AyPvHAl8MOogxIP6xGD+8JKUol8eei9wV4uQQrq8fNQvsJsxQtJs3X34
	0zFAvyfQ7sMbj5Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jgPvul/UVbZusAUJxiEsmfcslqHHzKzH8MrIn2PIR8=;
	b=gvKDOdcBXhNWppH1pXyaXV6I7yFOH/OxEt/VfskL2zSU2/AnRKLCosanmOTM/Lse1dNkyQ
	5Egth5De3oA7pUkgN8snbGqNtqm6r7Vr3khfBEl0KBSNnpYOx2vI/B7Ne26qcYjpkrWvoP
	FJvs9z/jPQtS/JtK2ZjsGaLmRxmW+ZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jgPvul/UVbZusAUJxiEsmfcslqHHzKzH8MrIn2PIR8=;
	b=Kh9zOhKERKvIh1AyPvHAl8MOogxIP6xGD+8JKUol8eei9wV4uQQrq8fNQvsJsxQtJs3X34
	0zFAvyfQ7sMbj5Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 330804273B;
	Tue, 17 Mar 2026 16:16:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kb9RDHR+uWnTcgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:16:52 +0000
Date: Tue, 17 Mar 2026 17:16:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix and prevent off-by-one bug when calling
 strncpy_null()
Message-ID: <20260317161650.GU5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <de4239be029b274e2d6a8e0035afc66e81333ad7.1771280483.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4239be029b274e2d6a8e0035afc66e81333ad7.1771280483.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Feb 17, 2026 at 08:51:37AM +1030, Qu Wenruo wrote:
> [BUG]
> There is a bug report that with asan enabled, "btrfs device stat
> --offline" will trigger the following out-of-boundary write error:
> 
> =================================================================
> ==4929==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7da0fd9e6100 at pc 0x7f90ff11ae55 bp 0x7ffcd98b97f0 sp 0x7ffcd98b8f98
> WRITE of size 1025 at 0x7da0fd9e6100 thread T0
>     #0 0x7f90ff11ae54 in strncpy /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_interceptors.cpp:628
>     #1 0x55ed2020e8ab in strncpy_null common/string-utils.c:62
>     #2 0x55ed202ad500 in get_fs_info_offline cmds/device.c:798
>     #3 0x55ed202ade4a in cmd_device_stats cmds/device.c:895
>     #4 0x55ed2011a4fb in cmd_execute cmds/commands.h:126
>     #5 0x55ed2011ae55 in handle_command_group /home/adam/btrfs-progs/btrfs.c:184
>     #6 0x55ed2011a4fb in cmd_execute cmds/commands.h:126
>     #7 0x55ed2011bc61 in main /home/adam/btrfs-progs/btrfs.c:469
>     #8 0x7f90fec27634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
>     #9 0x7f90fec276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
>     #10 0x55ed2011a3d4 in _start (/home/adam/btrfs-progs/btrfs+0x873d4) (BuildId: 3a69cb43ff4e39c3dbc079d8086fb9082f21490a)
> 
> 0x7da0fd9e6100 is located 0 bytes after 4096-byte region [0x7da0fd9e5100,0x7da0fd9e6100)
> allocated by thread T0 here:
>     #0 0x7f90ff120cb5 in malloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:67
>     #1 0x55ed202ad012 in get_fs_info_offline cmds/device.c:777
>     #2 0x55ed202ade4a in cmd_device_stats cmds/device.c:895
>     #3 0x55ed2011a4fb in cmd_execute cmds/commands.h:126
>     #4 0x55ed2011ae55 in handle_command_group /home/adam/btrfs-progs/btrfs.c:184
>     #5 0x55ed2011a4fb in cmd_execute cmds/commands.h:126
>     #6 0x55ed2011bc61 in main /home/adam/btrfs-progs/btrfs.c:469
>     #7 0x7f90fec27634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
>     #8 0x7f90fec276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
>     #9 0x55ed2011a3d4 in _start (/home/adam/btrfs-progs/btrfs+0x873d4) (BuildId: 3a69cb43ff4e39c3dbc079d8086fb9082f21490a)
> 
> SUMMARY: AddressSanitizer: heap-buffer-overflow common/string-utils.c:62 in strncpy_null
> Shadow bytes around the buggy address:
>   0x7da0fd9e5e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x7da0fd9e5f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x7da0fd9e5f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x7da0fd9e6000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0x7da0fd9e6080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> =>0x7da0fd9e6100:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x7da0fd9e6180: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x7da0fd9e6200: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x7da0fd9e6280: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x7da0fd9e6300: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
>   0x7da0fd9e6380: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
> ==4929==ABORTING
> 
> [CAUSE]
> Inside get_fs_info_offline(), we call strncpy_null() to fill
> di_args[i].path, but that path array is only BTRFS_DEVICE_PATH_NAME_MAX
> sized, and we're passing "BTRFS_DEVICE_PATH_NAME_MAX + 1" as size.
> 
> This will make strncpy_null() to always set the last byte to 0, which
> triggers the above access beyond boundary.
> 
> [FIX]
> For that specific caller, just use the size of that array.
> We can not change the definition of btrfs_ioctl_dev_info_args, as that
> is part of the user API.
> But most other structures have already include one extra byte to handle
> the terminating zero.
> 
> And since we're here, replace all strncpy_null() to use sizeof() as its
> size parameter when the target is a fixed size array, to prevent similar
> problems from happening.
> 
> Most call sites are already doing that, but there are still several
> sites using open-coded sizes.
> 
> Issue: #1088
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.
