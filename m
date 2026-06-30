Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF42882B7
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 02:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782785431; cv=none; b=rVSWjdPCw63veu2NFIUt1l00V4wio1jZaq52FgnUClrm5vLCoAIPwSDtbGssB8/WV2Dbx9z8ohN+yfMG2EBdiHf0ru0ERWkHrDgLmswU73A+//z2Ck+2ZoYCxCyA8E28mSJvOShOv6VItN0cMexfr60SpifVRWtcQw8AL9xF/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782785431; c=relaxed/simple;
	bh=UTr5B8G0i/IwaZ5W5diHPReE2HcExPfd1qJT6/iAxsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M49Nm32y4vuLsbpLZnGGbYPZ+rAfmAPcPjyRXHHFQ4JLGhyStYl3ZcY2rYmzuecer9wxzPvi/4eG3S4Kw1N/Kmku9mXt6A6IlNomml9vxbeh86JGoEElfj4jJA7EoAsYAM8Wwu3gRbhNSgfFE5dJaFVv9GHFbjtrkUPyA4s3B6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PkHYIdbG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3dpC6jfx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O6stP7N1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M2l7A64K; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PkHYIdbG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3dpC6jfx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O6stP7N1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M2l7A64K"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 39A3E75E97;
	Tue, 30 Jun 2026 02:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782785428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjjb2gDhxnZ0F1HoGW8q9wxlo3OzgJtS/lpjiYO9rck=;
	b=PkHYIdbGEDeOH4KGOEsR1e2maEcq4ylkPn0/GQWAwakT40t1/wpTO2Pq5z9Ke2TubDB6uc
	7eBtnfXnGSunnhrBuIkQINFwJNwjpH9O77zW+zng1t6WBQX6mMantzZCcnh2ioN9t904qf
	b9M3j3iiZ/NgdQws6CYIP1BZf6GO5GI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782785428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjjb2gDhxnZ0F1HoGW8q9wxlo3OzgJtS/lpjiYO9rck=;
	b=3dpC6jfx98+ueBHUGmJGcUZH/erYK8Qp3vizFt5o2b/4IiEMy3M0a6CcXzCqGxvUtrJs/X
	aniFxQeKRaVtMODg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782785427;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjjb2gDhxnZ0F1HoGW8q9wxlo3OzgJtS/lpjiYO9rck=;
	b=O6stP7N1jSSsX2GPHpsyxAOl6x6iAGlg40orGyg418+9aDDy0WVR7N8oyM/RMIGIdDKUUr
	Fx+QD1577Tcs5+EPU0lOqXuCHcuoB/BbPkMQKKCJOHRjdMpN0ll92s7JbLytnxtqHxlbA1
	iJFl/tBjVM+Uy7v8pjOq68hX70uS0uI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782785427;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjjb2gDhxnZ0F1HoGW8q9wxlo3OzgJtS/lpjiYO9rck=;
	b=M2l7A64KcFCj6RcgcvEN8l0shrAqNXnIm1FTFBNGMgqY2s3mfgfxGAoDh23Hft6jCkAQ6N
	foiXQKCVdPLYDCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BB80779A8;
	Tue, 30 Jun 2026 02:10:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q2h8CpMlQ2reLAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 02:10:27 +0000
Date: Tue, 30 Jun 2026 04:10:26 +0200
From: David Sterba <dsterba@suse.cz>
To: sun k <sunk67188@gmail.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
Message-ID: <20260630021025.GH2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
 <CAAuSuOoNE4wgaqx-5MH_cqpeu0MyrUikrVS98K2H4xLnRW5mxA@mail.gmail.com>
 <20260623000756.GA150664@twin.jikos.cz>
 <CAAuSuOphPez=WPHA-r8oP7kXOffV8Z00YXscd0kUFZE9pAjUSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSuOphPez=WPHA-r8oP7kXOffV8Z00YXscd0kUFZE9pAjUSg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Tue, Jun 23, 2026 at 11:21:43AM +0800, sun k wrote:
> On Tue, Jun 23, 2026 at 8:08 AM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Mon, Jun 22, 2026 at 08:00:06PM +0800, sun k wrote:
> > > Looks good.
> > >
> > > Reviewed-by: Sun YangKai <sunk67188@gmail.com>
> > >
> > > BTW, this reminds me the print-tree result of dir items that points to a
> > > subvol, which currently looks like this:
> > >
> > > item 4 key (256 DIR_ITEM 224155391) itemoff 15967 itemsize 48
> > >                 location key (43123 ROOT_ITEM 18446744073709551615) type DIR
> > >                 transid 896627 data_len 0 name_len 18
> > >                 name: home.20260621T2000
> > >
> > > And I wonder if we can also print the location key's offset field as s64
> > > to make it easier to read.
> >
> > It should be consistent for the ROOT_ITEM and references and we can
> > actually print the name of the tree, as is done in dump-tree output.
> 
> Hi David,
> 
> I'm not sure if I follow you here. The offset field of a dir item
> which points to a subvol is
> a little special. Its offset field will always be `0` for subvolume or
> `-1` for snapshot instead
> of other values. While in root tree, the offset field will always be
> `0` for subvol and `generation`
> for snapshot. So take this as an example, when location key is (43123
> ROOT_ITEM -1) in dir item,
> there's no such an item in root tree, but something like (43123
> ROOT_ITEM 8750971) instead.
> 8750971 is the generation when the snapshot is created. So I'm not
> sure what is `the name of the tree`.

You're right, in this case it does not make sense, I though the huge
number was internl tree number but it's just -1.
