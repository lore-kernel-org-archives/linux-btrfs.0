Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC27425CF2
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902440; cv=none; b=mYKO4J0beMJoQQ4/Kh0E/NpH3KzKrdqVbQkZSE8c7aUi7duQVnrwXAOh+TynsTAtqljW6wMTLKdpmn8d32Cg9oNrPSIPyIrO6luJS8XFGZvUvX+m99wNi8XAlJDrkF5RlQ6/XebKq35qJQWFUn7yBRSfB7WeO9gxVZKdzy0MlOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902440; c=relaxed/simple;
	bh=q4G9nZoVGdeBNwsNf+dy+lNmlmLtH0UmYqysuExNd6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VcjItOZVxxoEcI1/tg8EF05Y9HKapiNU87jikS1X8PI1opBfYWI6yToGvegHfAqW7OuJDCKrbE8pOggleRmWpWGt7HQ4GgKhsaXL+T3ZBk1jk84NJMZLt8J9XYiQaJOF44G20bpYnvtSKnXBfG1fTGQUQhVvAPm9pz/gTIS/Lpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxRa7Y5U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxRa7Y5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3326D1F000E9
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782902437;
	bh=zANGzgvDSurY5Ule1rJg5xg2d/BqXkL2d2H5K/7QZDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nxRa7Y5UBB1blf7u0x0Ds+Uq1KXQ6ENdgEP/JwB4iYuD/WbcmQ0/oCt9BWbqlEO+C
	 NB4GNqYMuPKGseKiCwwEVqVUQ3h7mUUPX9N8uJM4D+0N4lUKgcTFfgtxkfi+BMKE7Q
	 X3GfAjxpkmrpzTcalQlo9cb7bECaFL+K6dS2kvNuIDUAGRbARUo6kBVLSYLiaGKGub
	 qEIuN6CA8emFnC3cALvisI18bpg61jw2aJsGyydljaPsoZdyO4RwyZl7wDIKzvZnKE
	 LyutW0xcQl1cyrzUI8m6VRfV/Z/R4+wovHUkRxGP7KXstuPl4Sh29ICaIyL0lp+WOC
	 UgrLaD5mk4xGw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c128cc012b4so82212966b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 03:40:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YwxBUJpUHgfrxguH8wcxdc+EUlnoJ1EqZUZVO8Hxk9TVJeXQ3jb
	5WntWWu9C6yTWydJBjoioWHzIvAfyVEm0Ve1NtEePpduGQX3Apq2fZW8oIJnFJ/DyDX+pFEFj/s
	PHRxShGWYMgLFkzpymqmsXYR1as71s0U=
X-Received: by 2002:a17:906:c147:b0:c12:5dca:864a with SMTP id
 a640c23a62f3a-c12a79b5269mr67915166b.5.1782902435847; Wed, 01 Jul 2026
 03:40:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782321584.git.fdmanana@suse.com> <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
 <20260629225508.GA2398896@twin.jikos.cz> <CAL3q7H6MEAeoCf+n7wT_823vUX5JuDYXFPiU_3fiauZiK6Sdiw@mail.gmail.com>
 <20260630200502.GB2907432@twin.jikos.cz>
In-Reply-To: <20260630200502.GB2907432@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 1 Jul 2026 11:39:57 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4NKQgF2rn==D+828EM=cLzRFCj19Zx=GiaLh=7S9DiKQ@mail.gmail.com>
X-Gm-Features: AVVi8CecRmoqLxSuqJfLvLS2rYvwNqcjZzoFLyDm5G4j6a_UScvM2qUyvJlLwRw
Message-ID: <CAL3q7H4NKQgF2rn==D+828EM=cLzRFCj19Zx=GiaLh=7S9DiKQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] btrfs: defrag: use auto kfree in defrag_one_range()
 for folios array
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 9:05=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Tue, Jun 30, 2026 at 10:53:54AM +0100, Filipe Manana wrote:
> > On Mon, Jun 29, 2026 at 11:55=E2=80=AFPM David Sterba <dsterba@suse.cz>=
 wrote:
> > > > @@ -1251,7 +1249,6 @@ static int defrag_one_range(struct btrfs_inod=
e *inode, u64 start, u32 len,
> > > >               folio_unlock(folios[i]);
> > > >               folio_put(folios[i]);
> > > >       }
> > > > -     kfree(folios);
> > >
> > > There's non-trivial work following this freeing, down from
> >
> > I'd rather disagree it's non-trivial work.
> > Everything below kfree() is trivial, and it was placed there in patch
> > 1 by chance.
>
> See a rough call graph of functions below the removed kfree, that's far
> beyond trivial. We follow the principle of not holding resources for
> longer than necessary, this applies to memory too.

It's still fast stuff. We hold the inode's vfs lock higher up the call
chain, so the inode's block reserve spinlocks are very unlikely to be
busy.

Also, you are concerned about slightly delayed memory release, but why
is that more important than releasing excess space first? Holding
excess space for longer can have an heavy impact - blocking tasks and
triggering async reclaim (running delayed refs, delayed items, commit
transactions, etc).

If it were a path-freeing operation, I could agree, since we would be
holding locks on a btree and impacting concurrency.
But in this case, deciding between releasing memory first or releasing
excess space (and most of the time we won't have excess space to
release, as we checked for holes before locking the extent range,
etc), it's not clear what is most beneficial.

>
> What I count as trivial is:
>
> - several asignments of local variables, ponter dererences are ok
> - one shallow function call
> - called functions do simple expressions only
>
> Indicators of what's not trivial:
>
> - spin locks
> - structure traversal
> - unbounded calls like waiting
> - more allocations
> - nesting deeper than 2 calls
>
>
> defrag_one_range:
>
>   btrfs_delalloc_release_extents
>     spin_lock inode
>       btrfs_mod_outstanding_extents - minor things, trace point call
>       btrfs_calculate_inode_block_rsv_size
>         - several clculations
>         - block rsv spin lock
>     spin_unlock
>     btrfs_inode_rsv_release (1)
>       btrfs_block_rsv_release
>         block_rsv_release_bytes
>           spin lock block group
>           spin lock space info
>           - lots of assignments, pointer derefs, calculations
>       btrfs_qgroup_free_meta_prealloc (branched on qgroups)
>         - qgroup calculations, spin locks taken
>         btrfs_qgroup_free_refroot (2)
>           - spin locks for qgroups
>           find_qgroup_rb
>           - qgroup list traversal
>       btrfs_qgroup_convert_reserved_meta
>         - spin locks for qgroups
>         qgroup_convert_meta
>           - spin locks for qgroups
>           - qgroup iteration
>           - resource releases
>         add_root_meta_rsv
>           - spin lock for reservations
>
>   btrfs_delalloc_release_space
>     btrfs_delalloc_release_metadata
>       - spin lock of inode
>       btrfs_calculate_inode_block_rsv_size
>         - calculations, spin locks
>       btrfs_inode_rsv_release
>         - see (1)
>     btrfs_free_reserved_data_space
>       btrfs_free_reserved_data_space_noquota
>         btrfs_space_info_free_bytes_may_use
>           - spin lock for space info
>           btrfs_try_granting_tickets
>             - reservation processing
>       btrfs_qgroup_free_data
>         __btrfs_qgroup_release_data
>           btrfs_clear_record_extent_bits (no qgroups) (3)
>             btrfs_clear_extent_bit_changeset
>               - tree traversal
>           qgroup_free_reserved_data
>             - ulist traversal
>             btrfs_clear_record_extent_bits
>               - see (3)
>             btrfs_qgroup_free_refroot
>               - see (2)
>           btrfs_clear_record_extent_bits (qgroups)
>             - see (3)
>             btrfs_clear_extent_bit_changeset
>               - tree traversal
>           btrfs_qgroup_free_refroot
>             - see (2)
>
>   extent_changeset_free
>     ulist_release
>       - enumerate nodes, kfree
>     kfree
>
