Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437023C198D
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996358; cv=none; b=giNnjT5+8aboKjEbCaKctxhKvPhD9joYNJY/faPD2irsifNmVUMkD7v7Y3gK4tU75CE8Ex6YashGOO1fbjmTNBHH1Qd0FdPn3qSI9wA9v44zQyCdWoDXbwGaslw0MqFBuvX0787ANuhD0aegGVXGJ2Ufd9SswPmug8bp07lLE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996358; c=relaxed/simple;
	bh=UJ9vjNqUOa+2OyW6BfhCpw2HNIMB+QwTKFeC7bA7BD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzHrrsEv2B8J5TQxxE2cew4ShUfBID45Mj1wfn93aWz+wPUntKnLr+E4mYthFiNHT82WqFsZcOgsHP7v4+NbDzUiJeUr1JnA8Wthp6N2yEKfoeQwbqhQ+4+RDwB1DdmLvtGvIMQa2AP0IPaEi+yy+eObxsPO07kTDecEyREdTdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DxhpWh06; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ucNXs/iE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DUMB3QJb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2GZfhiqa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DxhpWh06";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ucNXs/iE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DUMB3QJb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2GZfhiqa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 128B81FB0C;
	Mon, 21 Sep 2026 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789996351;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XV9d+N0hlGgweSYxn7f7rd+Yzj/SM35buaF67dwjXjc=;
	b=DxhpWh06bpAi5rvOPx6mS5ITjaB0hYS64G1/tJ9N7TVB+lKQbtedbfRH692puWE/r/ZBc+
	PRGFnpp6iQ7+GnT2W0PM4k/pgQ7xDJCyGP70DOEj/Udggy9TvJ8EDYAG5WpJyalnB6xZuL
	m1v7P/o6gMFyU0G17S0bVCRfE+VxwG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789996351;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XV9d+N0hlGgweSYxn7f7rd+Yzj/SM35buaF67dwjXjc=;
	b=ucNXs/iEH6mHqk4jsGyU44Ru8Hgl5aVyQc8V3RNPAeyS7ekZg8Oe0lQrnZlsNOjsyM5YA5
	Vcsipc7/6VSakZAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789996347;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XV9d+N0hlGgweSYxn7f7rd+Yzj/SM35buaF67dwjXjc=;
	b=DUMB3QJbXOUqVLhx+ewQfefZYZMpRUdmlqFbj5iApoRyFUlBR/4WY6LSjlWnY/SgRFMWRt
	twmovGL06rdqnxSehOd/AopzQpDzsmdb10Y/Svf612rhDDxfE85RZ/oMGJ+KIxIjj/BnWh
	x+9VFDnH7weO/fhcGd/1Y8aCoE0zc8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789996347;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XV9d+N0hlGgweSYxn7f7rd+Yzj/SM35buaF67dwjXjc=;
	b=2GZfhiqa37aFsZGPPnV/WTrnf8NrbOu419j6NzUcpQ1JMjBHR+8eX7udrZ2oQ+XxA7Ll4k
	C3PgcC+nGKMOeODw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 350761368D;
	Mon, 21 Sep 2026 13:12:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C0D/BDotsWoqbgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 13:12:26 +0000
Date: Mon, 21 Sep 2026 15:12:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
Message-ID: <20260921131220.GE54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
> 在 2026/9/21 15:03, Qu Wenruo 写道:
> > [BUG]
> > There is a bug report that a running qgroup rescan can fail a pm
> > suspension:
> > 
> >   [ T278489] Freezing remaining freezable tasks
> >   [ T278489] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
> >   [ T278489] Showing freezable workqueues that are still busy:
> >   [...]
> >   [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 active=1 refcnt=16
> >   [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
> > 
> > [CAUSE]
> > Btrfs qgroup rescan is running in a workqueue, and when the fs is
> > frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
> > 
> > But a sleeping workload still counts as active for the workqueue until
> > the workload exits.
> > 
> > So the qgroup rescan item will sleep on the frozen fs, and fail the pm
> > suspension.
> > 
> > [FIX]
> > I strongly doubt whether we should even use a workqueue for the qgroup
> > rescan workload, a kthread would be a more suitable choice and can handle
> > fs and process freezing way better.
> > But that will be a long term solution.
> 
> Hi Qu,
> 
> Thanks for working on this.
> 
> I recently posted an RFC series addressing qgroup rescan lifecycle
> issues around quota disable/enable, error cleanup, and remounts [1].
> 
>  From the recent discussion, I got the impression that full qgroups
> might be phased out or substantially reworked. Is that a fair
> understanding?

Do you have link to the dicussion? Phasing out current qgroups in the
full mode would be a functionality loss and we don't have a replacement.
On the design level, the qgroups are general enough to cover the COW
design, sharing. The compression was originally intended but IIRC we
don't account compressed extents separately.

Reworking could happen, the performance hit of qgroups in full mode has
been a problem since beginning, but I don't see any easy change there.
If the sematics change we'd need to add another mode, like we have the
simple quota mode.
