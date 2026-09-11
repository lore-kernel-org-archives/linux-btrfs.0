Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A1472091;
	Fri, 11 Sep 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150899; cv=none; b=O2wdTIt7yWw6BPfqc58ldwVUik0GZ4YJjEmxhXlTYq2smlRuW37uqq+BdVoTsey5jzGOi7NmR/xQ1ETw63zxcxUym2Aozhv5cg0Z4wXCpuf1gpy5Ayypun4i3ZMhjncEc3TpXMqaGk7jb6ujlV3RQXzcE1jG6P/RdXv9cVbNzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150899; c=relaxed/simple;
	bh=NUJW4vORTeWX4wf/BJdOZ6LKrbDPHstP98fAdSj66bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t080KzgV3p3GmDhfxu7bVqhcCr3EB3XKYQ5IosyId1oS3TyGuVQ5XibyVomDLCcNJ1qp7xlQkN+bNC/tyeGh9ctSNr87vkkAs57om1JUxZiNZseav0Fj00iDsmrNpULXw1q6W2hJvbPilKMmtQHhsdqxeh8BpqMz8LFaWk+3u+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ab8EM7SZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=K4sja29U; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lk7cO3cF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/rVCXvNo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ab8EM7SZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="K4sja29U";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lk7cO3cF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/rVCXvNo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4E0D721CC2;
	Fri, 11 Sep 2026 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789150891;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIe6DcAAeaYwD2iu1Pj1K/v+fGGKq2kbixn7Q9oIQFU=;
	b=ab8EM7SZRkLIO5GfIfAunkdoB/0Uv5maD5hlVzMof0xvV1JdS1PHZVl7BOqc2CRxwe1b2+
	p+U49nJHrOjMubjLAd64hu1CSMBTbKGKg97vo0c+sq20dvGEhlTgGfiujPM7qviwMHTl8/
	/fN6mVs9lYbF/XP7RHkwepsge6w6EZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789150891;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIe6DcAAeaYwD2iu1Pj1K/v+fGGKq2kbixn7Q9oIQFU=;
	b=K4sja29UXa5MY4MxeLGyam/Qnf7u+O8QgSIMaB/lCg/8tcjRLMR7ioTEodm++vYcKZVSwu
	6SSuRfXev4zOWKBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789150887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIe6DcAAeaYwD2iu1Pj1K/v+fGGKq2kbixn7Q9oIQFU=;
	b=Lk7cO3cFnw+24OcsB88SxhL8kDlEkQvPTEq3PaGb4gWsDijnXyhnmugb3Vpfu/I/L+UTKi
	M9AeCjqsSOWAKq/WKSID0BHJiP5XwF7BxPjfqgRZxHiufovc/D8gwoYC18lvRJwGvkXRIT
	E4Otbg7erEFJgixy2rX9EyFPzRegJFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789150887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIe6DcAAeaYwD2iu1Pj1K/v+fGGKq2kbixn7Q9oIQFU=;
	b=/rVCXvNodRCs6WQxHlXnhjX2UqZEgl/fQAcUNiJ7bMEHadzDMBGIIlvo+MOZXZTTLBAaal
	iOxcXYuSN01SXeDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E122713715;
	Fri, 11 Sep 2026 18:21:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2kDENqZGpGrraAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 11 Sep 2026 18:21:26 +0000
Date: Fri, 11 Sep 2026 20:21:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alex Romosan <aromosan@gmail.com>,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
Message-ID: <20260911182125.GE54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
 <4c5117f7-1ddd-4596-8917-da47379506fd@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c5117f7-1ddd-4596-8917-da47379506fd@leemhuis.info>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmx.com,suse.cz,vger.kernel.org,gmail.com,lists.linux.dev];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Thu, Sep 10, 2026 at 12:39:25PM +0200, Thorsten Leemhuis wrote:
> On 9/9/26 03:13, Qu Wenruo wrote:
> > 在 2026/9/9 09:55, David Sterba 写道:
> >> On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
> >>>
> >>> [...] Since version 7.3-rc1 i haven't been able to to a grub-update, 
> >>> instead i get this error:
> >>>
> >>> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev
> >>> mounted?).
> >>>
> >>> 7.2 is fine. a git-bisect identified commit
> >>> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
> >>> reverting this commit from 7.3-rc2 allowed me to run grub-update
> >>> again.
> >>>
> >>> this is not the first time i reported grub-update being broken on
> >>> btrfs. i reported exactly the same problem on jan 8, 2024
> >>> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
> >>> the discussion that followed would help come up with a fix that will
> >>> make everybody happy.
> >>
> >> I remember debugging that one, https://bugzilla.kernel.org/
> >> show_bug.cgi?id=218353
> >> Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolution
> >> during device scan") would bring back the lockdep warning and there is a
> >> locking problem.
> >>
> >> The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
> >> device path update for the same device"), the difference is in lines
> >>
> >> (https://bugzilla.suse.com/show_bug.cgi?id=1230641)
> >>
> >> -       } else if (!device->name || strcmp(device->name->str, path)) {
> >> +    } else if (!device->name || !is_same_device(device, path)) {
> >>
> >> Which gets changed to (by 108cc8733989):
> >>
> >> -       } else if (!device->name || !is_same_device(device, path)) {
> >> +       } else if (!device->name || device->devt != path_devt) {
> >>
> >> Each change is reaction to a bug, I don't see a clear fix which will
> >> make it work in all cases.
> > 
> > And I want to add that, the previous path based comparison is also
> > problematic for namespaces/weird block device names.
> > 
> > Although not common, it's definitely possible to map weird block file
> > name into a namespace.
> > 
> > Thus the path based comparison is not reliable in the first place, no to
> > mention the later lockdep problems.
> 
> Well, but our #1 is "no regressions". And the recent change while fixing
> bugs clearly causes one, as Alex's report is afaics at least the third
> about it; the two earlier ones can be found here:
> 
> https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
> https://lore.kernel.org/linux-btrfs/018a9738-1d4a-43a0-9352-a56d1e541364@gmail.com/
> Plus a repost of the latter here:
> https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/

I'm going to treat this as a regression. And for the record Qu and me
are in disagreement on that. My target is to make the systems boot again
first, the fix may leave some problematic case (like mentioned, devices
in namespaces), but that is probably a lesser problem.
