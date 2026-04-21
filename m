Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C58A2EBB84
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 03:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776741267; cv=none; b=YKbNRC5X+f59yWXqPZDp3PPj4rq/pjYVkW7WDqC1Nh3qTH5Tl8qGs4qPB0/unvU8hmuJcgYREq4YLDWITogvTlEeM7k/8DGsynzqUmFWBRSNvxqKTdelRNWdBZXd5BKOMn+OA3zfuHo0tAkyWDa8gDR/IezZEKZYPtg0Hdh9lrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776741267; c=relaxed/simple;
	bh=i5rdr1ba0Ka/BatLmUvEosP5D2xQVFpQNvN6SvJczz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeY5oOLQhKINdMEQVf1mvACIViMxAbArzsRGMIj8hj+jwJDPGI39kD7jAVA7NSS1K4xT4mvngbvgmPksV2vosKm6e46SLtWyoVPbysKJQbUUfrvujn49+edqMagO7eZFDVvB/dNlIhRzPZehsPg/O5kVrrZ5n3aZVR9x5ctDhUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OtTXpsGl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fTNcSwKp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nscjaAOX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c4+AiBwa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OtTXpsGl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fTNcSwKp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nscjaAOX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c4+AiBwa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBF0E6A7DB;
	Tue, 21 Apr 2026 03:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741265;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/NtNQfm2H1rqIImCh/g0ZbwA5Yf7jIUFiLT2HuZhgtY=;
	b=OtTXpsGlBvLVAOzy4OtVajktQr7YQs2lRfCpo5HKo7QQHqQxm9YhtOkXW72PgSq/TXInBn
	M81nZdLE5sWnDD/X6xhgbNbiT8fE1G1hvW9d55TouJW3iGGMuN7H3NhvjfG4wb/0u7IGLW
	C6hdJi9bcH3BvTJr5WCe/dDfdZnblog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741265;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/NtNQfm2H1rqIImCh/g0ZbwA5Yf7jIUFiLT2HuZhgtY=;
	b=fTNcSwKpLCahWvbALjpnTLDN1+QorkUC7WEFmmTYMd7CGOo/zfy49WqihYUxfJOk++tqfr
	0OksupCybsdMelDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741264;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/NtNQfm2H1rqIImCh/g0ZbwA5Yf7jIUFiLT2HuZhgtY=;
	b=nscjaAOXPKFeQon0FmOkNq+gmcIC9MqiXsDnb6uf7opqLXDJ/DmsTbW/B4Ep8IUHlIhfnI
	0OTKh3bFFnWQI92VvRclwjq6QsuQ8yUzwC8PS0dlm5O00j+Ja3viRwveXyn6lcGN2WvFNC
	7UXT1lLPc/FBrhCvxPHdpT9wj5kVktM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741264;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/NtNQfm2H1rqIImCh/g0ZbwA5Yf7jIUFiLT2HuZhgtY=;
	b=c4+AiBwaAI+el8/mptl7NCjmqKk4bxdsFuYiGA89SOl8oCXD7Ubv5bOh5Q+5mC4go1FHrx
	LQaDKSvrK/Ua//Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2163593AF;
	Tue, 21 Apr 2026 03:14:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VkEcM5Dr5mlpOgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 03:14:24 +0000
Date: Tue, 21 Apr 2026 05:14:23 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use min_size variable to setup block rsv in
 btrfs_replace_file_extents()
Message-ID: <20260421031423.GC12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <efc156002e21e5453d58c2c0856f605575f27642.1776693213.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc156002e21e5453d58c2c0856f605575f27642.1776693213.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Apr 20, 2026 at 02:53:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no need to calculate again the size for the temporary block
> reserve in btrfs_replace_file_extents() - we have already calculated it
> and stored it in the 'min_size' variable.
> 
> So use the variable to make it more clear and also make the variable const
> since it's not supposed to change during the whole function.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
