Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932004D1787
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 17:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666009; cv=none; b=BmyjpVJcq1rTeVMHUtDBwT66MKTOqIk+rrCAHinpFJFUqcF6iX2nHRuldE4DttnqdpHguDCL7JENT6IbxO9MuSo9hYsifOoCOg9s7arPCwiwUyJNAzJwhLxPCbBNr9aU/dUFSMHAWPw10h6PgjWYkTseFSjfJcdw67kt5SstSrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666009; c=relaxed/simple;
	bh=7xxjYhmHfXoCQrL4ZXVUDXfpy4WGeVRRJB0u6Lm8hkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hh681xFZHnQ7kGRLAzRAHPJMMgGOSb82oz1LwnEKp8utyBspL3KW3QBWIBuzhVhCdOq9BV79GDNyGlPjsLVuc9fvpuAb5SaclQ7Gi/nbYQqDqlcYGg/W0D66uA1i/dw+FcpYT/zWS/6u9B0A5UfPsoex4J6FW8qbzNhcFT7RKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nAiodbfS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yVjnv/un; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MpupYjwX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dhov2SCp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nAiodbfS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yVjnv/un";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MpupYjwX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dhov2SCp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51DAD21D6F;
	Thu, 17 Sep 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789666002;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KkPua3XrUVcad+2mynVamjByLBMePirBG8oSTVswMo4=;
	b=nAiodbfSz/PP+KAE46liVg/8rCQtJH9jZJFpaNv71A1oADDGloj/tpaZVqim4GtDris08v
	4qvaT8QH56UC6l2NmWr9O1hGG0nEiX9+94/dpLCHUn7jOj7vhIddun7UE/AnKDhYhXbcZP
	ltmIg2k/KBjz4TqWtokECczNXzD1ivo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789666002;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KkPua3XrUVcad+2mynVamjByLBMePirBG8oSTVswMo4=;
	b=yVjnv/unCP/yTHn6aQf9Wtilt4lkskw0q7uPXxaMN63mo7IPHqScP71/7xO+7Bkft/6qiE
	zB9Ho/ZJtwYuEGBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789665998;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KkPua3XrUVcad+2mynVamjByLBMePirBG8oSTVswMo4=;
	b=MpupYjwXNfx9ACrfsiTv508v7i0GogUd09+sTEVbafL6YxNxe/aEiJVAkoRPzJYSYGukls
	poJq7CekywHz9WMvVcwQqDxNFcA3QKR8Bh8zVwS/RHEdvu2gEVMxlreUxpdpaNnwmA8Dj0
	fnr7uTQTnw/EBFh9E8iwJw7ahhRNvrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789665998;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KkPua3XrUVcad+2mynVamjByLBMePirBG8oSTVswMo4=;
	b=Dhov2SCpw4rm+ODfGsgDk4a4DzX9iD3f2M3aTb8rHMjl/cj7tZKShysiJ3rsqGaw13H90K
	BHigBHlKwwTbiICw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 267B6134B3;
	Thu, 17 Sep 2026 17:26:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K71dAc4irGrQRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 17 Sep 2026 17:26:38 +0000
Date: Thu, 17 Sep 2026 19:26:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Suveer Jain <asj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
	linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	David Sterba <dsterba@suse.com>,
	"Macieira, Thiago" <thiago.macieira@intel.com>
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Message-ID: <20260917172636.GW54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <20260911172313.GA54722@twin.jikos.cz>
 <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
 <20260914131455.GH54722@suse.cz>
 <847b96c6-9e39-4eef-889c-3985f7eb4e3a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847b96c6-9e39-4eef-889c-3985f7eb4e3a@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Sep 16, 2026 at 12:11:01AM +0800, Anand Suveer Jain wrote:
> > I don't see the temp_fsid documented (btrfs-progs) other than in the
> > changelogs and briefly in the sysfs file. This should be more visible as
> > a separate feature and with the known use cases.
> 
> Agreed. Do you think btrfs(5) is a good place to document temp_fsid?

Yes, please add a section and also explain the other filesystem ids and
how they're related. We can add references from other places using it
(sysfs, mount and others).
