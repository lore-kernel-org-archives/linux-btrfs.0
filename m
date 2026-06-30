Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F9032FA29
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 20:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849907; cv=none; b=RNr4Bfb+0Z+Pi2xnBsrzfmLe0QR0ZGz2S5V6YCwiuYQjjcEczl018w6rAN4Rtv1VnNSo9TF1z36kkliTxE6P650tIriROQUv3u3hcidn6YkJlL4bm+XGh+19hDAlwZ3aSlFxMkjeyvOAC4kbD3VTXRrJLLOeZMRiqzEfa+26mUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849907; c=relaxed/simple;
	bh=WX/rakNg99ceKdS0+n2DcHZuOpV80iNP8u2pggP0xDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ediquJccN5+tC1PnE7FX93XwJuLZv/SE3So5zU4uabyNG4nNuo8s25ESbqTTDWqdMNEq/lGPZauEFSTNs/sgw+JnfFs2uu9vZAy1Xsw+J27yhaWNKdZrrW+OsC/4Jvz14GPMF45xiKfZPFUfogB3jVoPwCzKWEodByCRU/Qmxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EgUAfYRF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LpKRET6z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EgUAfYRF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LpKRET6z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EgUAfYRF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LpKRET6z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EgUAfYRF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LpKRET6z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09C6C75F09;
	Tue, 30 Jun 2026 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782849904;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FySk1zVUE+buclvEy+Fe3jvgEv5GPKkzfGtk5qvgjMw=;
	b=EgUAfYRFGmdZrESKLxMNMs+rlPDj003tJA2uEkmRkBKN1SeE04IemAZBPvYrDqOD8RFlJU
	13qKBSqQEBXGHPZxk72BoM+0icvHa1bp0dwYRTdG2niaFk0SnOc19hQknOByufcAFelEP9
	8E5XzdkZGJbUisaU58DLTPdHV21Y1zo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782849904;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FySk1zVUE+buclvEy+Fe3jvgEv5GPKkzfGtk5qvgjMw=;
	b=LpKRET6z74qJNcbS0EoK6KspgMoq+oaJKECeCgTGnWqXyX3tpyezBZWsCnYurip3/jhPt+
	mjqMWjAbuUBI1ICA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EgUAfYRF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LpKRET6z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782849904;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FySk1zVUE+buclvEy+Fe3jvgEv5GPKkzfGtk5qvgjMw=;
	b=EgUAfYRFGmdZrESKLxMNMs+rlPDj003tJA2uEkmRkBKN1SeE04IemAZBPvYrDqOD8RFlJU
	13qKBSqQEBXGHPZxk72BoM+0icvHa1bp0dwYRTdG2niaFk0SnOc19hQknOByufcAFelEP9
	8E5XzdkZGJbUisaU58DLTPdHV21Y1zo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782849904;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FySk1zVUE+buclvEy+Fe3jvgEv5GPKkzfGtk5qvgjMw=;
	b=LpKRET6z74qJNcbS0EoK6KspgMoq+oaJKECeCgTGnWqXyX3tpyezBZWsCnYurip3/jhPt+
	mjqMWjAbuUBI1ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DFC30779A8;
	Tue, 30 Jun 2026 20:05:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R1neNW8hRGpESwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 20:05:03 +0000
Date: Tue, 30 Jun 2026 22:05:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: defrag: use auto kfree in defrag_one_range()
 for folios array
Message-ID: <20260630200502.GB2907432@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1782321584.git.fdmanana@suse.com>
 <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
 <20260629225508.GA2398896@twin.jikos.cz>
 <CAL3q7H6MEAeoCf+n7wT_823vUX5JuDYXFPiU_3fiauZiK6Sdiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6MEAeoCf+n7wT_823vUX5JuDYXFPiU_3fiauZiK6Sdiw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 09C6C75F09
X-Spam-Score: -4.21

On Tue, Jun 30, 2026 at 10:53:54AM +0100, Filipe Manana wrote:
> On Mon, Jun 29, 2026 at 11:55 PM David Sterba <dsterba@suse.cz> wrote:
> > > @@ -1251,7 +1249,6 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
> > >               folio_unlock(folios[i]);
> > >               folio_put(folios[i]);
> > >       }
> > > -     kfree(folios);
> >
> > There's non-trivial work following this freeing, down from
> 
> I'd rather disagree it's non-trivial work.
> Everything below kfree() is trivial, and it was placed there in patch
> 1 by chance.

See a rough call graph of functions below the removed kfree, that's far
beyond trivial. We follow the principle of not holding resources for
longer than necessary, this applies to memory too.

What I count as trivial is:

- several asignments of local variables, ponter dererences are ok
- one shallow function call
- called functions do simple expressions only

Indicators of what's not trivial:

- spin locks
- structure traversal
- unbounded calls like waiting
- more allocations
- nesting deeper than 2 calls


defrag_one_range:

  btrfs_delalloc_release_extents
    spin_lock inode
      btrfs_mod_outstanding_extents - minor things, trace point call
      btrfs_calculate_inode_block_rsv_size
        - several clculations
        - block rsv spin lock
    spin_unlock
    btrfs_inode_rsv_release (1)
      btrfs_block_rsv_release
        block_rsv_release_bytes
          spin lock block group
          spin lock space info
          - lots of assignments, pointer derefs, calculations
      btrfs_qgroup_free_meta_prealloc (branched on qgroups)
        - qgroup calculations, spin locks taken
        btrfs_qgroup_free_refroot (2)
          - spin locks for qgroups
          find_qgroup_rb
          - qgroup list traversal
      btrfs_qgroup_convert_reserved_meta
        - spin locks for qgroups
        qgroup_convert_meta
          - spin locks for qgroups
          - qgroup iteration
          - resource releases
        add_root_meta_rsv
          - spin lock for reservations

  btrfs_delalloc_release_space
    btrfs_delalloc_release_metadata
      - spin lock of inode
      btrfs_calculate_inode_block_rsv_size
        - calculations, spin locks
      btrfs_inode_rsv_release
        - see (1)
    btrfs_free_reserved_data_space
      btrfs_free_reserved_data_space_noquota
        btrfs_space_info_free_bytes_may_use
          - spin lock for space info
          btrfs_try_granting_tickets
            - reservation processing
      btrfs_qgroup_free_data
        __btrfs_qgroup_release_data
          btrfs_clear_record_extent_bits (no qgroups) (3)
            btrfs_clear_extent_bit_changeset
              - tree traversal
          qgroup_free_reserved_data
            - ulist traversal
            btrfs_clear_record_extent_bits
	      - see (3)
            btrfs_qgroup_free_refroot
              - see (2)
          btrfs_clear_record_extent_bits (qgroups)
	    - see (3)
            btrfs_clear_extent_bit_changeset
              - tree traversal
          btrfs_qgroup_free_refroot
            - see (2)

  extent_changeset_free
    ulist_release
      - enumerate nodes, kfree
    kfree

