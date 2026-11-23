Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795449741;
	b=kLlFzAYFQhYm2pMOs0WnQ7V9ys6lq13C0/YRgidF7pY6m+sJ7DA8X/sHJrkxmiNW6xD1
	 OSaGxnKcklNhbXJbaAUh9xcWN/dB/p54jSMbOrekJVmHbqSDF6pqSD2OMxB8hvO/0JLQ7
	 bUxVyB4x4H2lXAY+GmrH1GIs48X9kyFM1gx2wwaHwV2rDUAKEcvEXLAQuFK06SuCn5taP
	 WKdhlMo1nN/vcVFDu0KrwPiJclNon8PvTEo9KNlUZJQg147epQnyk2SIMS5BezqrzdZsy
	 2nf7X90fys4kelW311wfKeAKh/8pYUhB1LlykTXpJaI3qaT/Z/KFhExLJ6drOxq8TuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795449741;
	h=DMARC-Filter:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:User-Agent:X-Rspamd-Pre-Result:
	 X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:X-Rspamd-Action:X-Rspamd-Server:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=wnGk+sZoRKJBsZVbSz7KhojmbFgQwaEfgMYM64LhpV4=;
	b=ROg81a1CupZceuSIr9Wz72H30Voh+W+eaw0AXFZGmUZv/P7H3Rc9w9qzoyWX4MALzNk0
	 3sze+s7iOQ5tiOCXf8jBUISdbxyWBRxNav3maVD7+Pcw3TQikrYxKmB/XYwP/J0STEkAF
	 SxIl0L7dqP7KK5O0wWMtP9YSGgnCTTplNkP+v/e1B3nkiAnHdg/ve9PysZdsncLsEdypo
	 dyjQDLycQ2kycaVUUE1FK1Fpw6JYYiCItwdI+GiyRlzYoArd/ABFYN/NikupHSr5MQt4z
	 FBkko58atW+u+XuggaCWHX2mIulNkgJZ3JHskXNifomm2fDNR+OBDQ+gOzpWHGvrkVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D2606A31F
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 16:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 418D2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 83AEE1F390;
	Mon, 23 Nov 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 522C51352B;
	Mon, 23 Nov 2026 16:02:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6dKWC4tjBGs7PAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Nov 2026 16:02:19 +0000
Date: Mon, 23 Nov 2026 17:02:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: reject too high tree level during backref walk
Message-ID: <20261123160218.GC3245297@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1795388358.git.wqu@suse.com>
 <95c15a8e7aaff788ba9582186c2345db7cd52dfe.1795388358.git.wqu@suse.com>
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
In-Reply-To: <95c15a8e7aaff788ba9582186c2345db7cd52dfe.1795388358.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 83AEE1F390
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Mon, Nov 23, 2026 at 09:29:58AM +1030, Qu Wenruo wrote:
> In handle_indirect_tree_backref(), if we got @cur->level set to 7
> (the max level valid), @level will be 8, then later path->slots[level]
> and path->nodes[level] will all go beyond the array boundary.
> 
> Fix it by rejecting such high level before calling btrfs_search_slot().
> 
> Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652f
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index a0fb90b7a9ed..d56476b21fe8 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
>  	}
>  
>  	level = cur->level + 1;
> +	if (level >= BTRFS_MAX_LEVEL) {

For EUCLEAN conditions you can add unlikely()
