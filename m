Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250045;
	b=ko4HVy7eGzTlpeqsL51ozQIyNGTvqo8BdDzMbHvXJ4d4A6FyR6iMN1FnkYXxJOktN9qf
	 OaDrDERjAINyUCGJ285vJ09FmL0s1h7dnGvS9we4CRAJCwXu04RRgyXB30Mb+LoJBTygH
	 yGOqN8zcAQ5dq8hh+Eg6s1AaouKpV24knuOc/VOiQcIfVzFnfxMKWRZQ0R3saMx/KT15F
	 GPD9l5H32ukjag0x6e2uz/fzJUIDybZ6MzWqW87aeSkWmKzb8Rxl8ntV/OOztvx4qaD4N
	 XpwmxFZQ3jUvjoBMjiAoBvQgmEl0Y6Yp6w9c+kBGrGEX+eF5KuLPf1SenqWDEspPGew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250045;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=1Fcu2VoL77tv3mf2pdNZfBai2zm4zZNuFOBfr4cLEyU=;
	b=MzeMXEX4qp6Ut699bz0QBjhTFqX1i9Kb3tug0s8/rYLGBqOGuN3T+yAlo7ZYgP3dE335
	 mGNbhgZHg76GU4eNCK38/oO54252WVPxgOIgs/ABfUSQHuRas6uloZn1Tk1CQqISERE3S
	 /Dc5k1qO5fLdMN3pP3WX5sbhhEFZW6GPYtpjufd8lGCZTbgsdMHZ2RrJRLr/mTuG8G+on
	 LT4x3gMNnNlnPcCwa/7UxGiBJZpwjxVV/galJg9eJGPETnP8gNviiFDnvgwdopcdb0MQC
	 1qTTg0xqd6zgacUbzL6xcd0KRwMOWWVmrNPq2bp+/wIg0BOZsNsOEVwBwSeWalGZSqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dIsP7uXX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="QCod/i9t";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DmK6Hn0T;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bY5NhOFP;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143D606A321;
	Mon,  9 Nov 2026 18:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2143D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dIsP7uXX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QCod/i9t;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DmK6Hn0T;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bY5NhOFP
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBA8A2212E;
	Mon,  9 Nov 2026 18:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794250043;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Fcu2VoL77tv3mf2pdNZfBai2zm4zZNuFOBfr4cLEyU=;
	b=dIsP7uXXZSKjcDGp/ONH/7HHA6led28nIXDXSWXnwwYqof6KD9m8MQFsPfEhqmohcVxrPc
	MMNg5/iWyIYkrFLhipHCrLKzl4CmuM3ZFJdLvvae2qDklK8qxdX+kfJ83uE8y/Rbnazed1
	sVr4juSwHVjj9f3R1UM5oN3e0yhzVkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794250043;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Fcu2VoL77tv3mf2pdNZfBai2zm4zZNuFOBfr4cLEyU=;
	b=QCod/i9tGKv/ZlL3xdWkzrAdu9WgI8lfwKW/mdpupWBg0znRRPqheNncj4r+BBvy9L4gJ7
	UB9/KmXZ7odQwyCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DmK6Hn0T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bY5NhOFP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794250041;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Fcu2VoL77tv3mf2pdNZfBai2zm4zZNuFOBfr4cLEyU=;
	b=DmK6Hn0TTZ92OIRTFZKTfL5l5T+XtyBNVgqs85VnPBaUhADpT6cptPQ9OHjJOnpGlAGW4S
	cGmdHi1chV73U7CwnIe3Da1b6stPx+y6qxR5nFL9862n9dWZPjO+iYLs+1u0TijzURPVcd
	Hx/Q8QjGFiPXqJtetySnKt9b9Oe1oSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794250041;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Fcu2VoL77tv3mf2pdNZfBai2zm4zZNuFOBfr4cLEyU=;
	b=bY5NhOFPTzQYOX+KOt4c6z9OOc5NY4q2Iswqj3WyyBwJRiW+XzWIlVWcXpWgWjmP48w7o0
	QQXS5GpLe/S0kYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A85713302;
	Mon,  9 Nov 2026 18:47:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R38wFDkV8mrldAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 09 Nov 2026 18:47:21 +0000
Date: Mon, 9 Nov 2026 19:47:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
Message-ID: <20261109184712.GF4186782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261101062539.1744605-1-teel4res@gmail.com>
 <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
 <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
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
In-Reply-To: <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-13.21 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
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
	FREEMAIL_CC(0.00)[gmail.com,suse.com,kernel.org,vger.kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.21
X-Spam-Level: 
X-Rspamd-Queue-Id: CBA8A2212E

On Sun, Nov 01, 2026 at 05:48:21PM +1030, Qu Wenruo wrote:
> With that said, there are more problems with the ioctl.
> 
> - No real user
>    No one is utilizing BTRFS_SUBVOL_SYNC* flags. Btrfs-progs itself
>    doesn't even bother it.
> 
>    So all these fixes are very low priority, unless there are some wild
>    programs utilizing this.
> 
>    But even btrfs-progs doesn't utilize them, the possibility are very
>    low.

Obviously the ioctl was added so progs 'subvol sync' can use it for
non-root users. I started working on it but there's a problem with the
behaviour change between the user types. Root has full access and
reports the progress while with this ioctl there were some problems I
don't remember. The ioctl was designed to emulate all modes that root
can do so it should be possible to get 1:1 output.
