Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=104.30.16.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795135727;
	b=u9EUll8zT2+o/WUQ2HiAm+J1OeWzTKr9RiZPiufIMBsnTECm356hRiViCiifwMzBNCPU
	 DyhxYiyYP5zYvNSYgBBP2lUJEVUK3OiGqSH6ROE8dPJQZBhuUBdD8NC8PC8hLprzwrpUy
	 HDeLdhdX/2nY6uA2e69l9rsnykrjMetmdtpoEuhejXk9//T0Rp15FSb3gMmmaHjFXYjoW
	 7gLuM4+iA8RuGnpQNljpRUmBsPuUZFmVehIPAFOcw8KFPSWxCB8Z4t6ab4E5VYN/2jsHw
	 W8ZAZbWjqGkw7SvRakatsXnBb4IX9vtCTZV28MHkwswZmMPrjewctUQg8Jj+CLXuKOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795135727;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Feedback-ID:Received:
	 Message-ID:Content-Type:Date:To:Subject:Cc:From:
	 Content-Transfer-Encoding:Mime-Version:X-Mailer:References:
	 In-Reply-To;
	bh=lJKqDUp98SmSKHKD9/VCU8JlR0KHKYo0zsYch6uPCyA=;
	b=ZP8qZALckuiPlbtDSPPbkV/GKGq7gqZ8E/j2MkbSrHYK/TYC8887jMSwhFaTKmJ2GVBf
	 874NCw10OVoxJLNn2eKAwavwvs1PtaGIyq7EZz/vRWrWlLIy7sGWia66Na9Uvv1D2RYLB
	 E0qWsEIEt5T7BdlpTAxm0h0neYaaj32oZ77fV4XbbTH1s5BApMQNZ/Fj8xPYCvwrRhwmn
	 XNeD2VPiS/nLOFKy/xWhT5nyj/8uO0Z6CqvduI7FdNdGWZgvLrw7CY6TadhpVg20T97G+
	 TS47ramWVglKLN3cRPXWq0wXPTHMPrUJ8rSR/hfewZVJ287pt3W8tRqK5UXo4k2tmDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shangen.org;
	spf=pass smtp.mailfrom=cf-bounce.shangen.org;
	dkim=pass header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=cf-bounce header.b=CDTnRWys;
	dkim=pass header.d=cloudflare-smtp.net header.i=@cloudflare-smtp.net header.a=rsa-sha256 header.s=cf2024-1 header.b=Ambi+8PI;
	arc=none smtp.remote-ip=104.30.16.114
Received: from bg-bbe.cloudflare-smtp.net (bg-bbe.cloudflare-smtp.net [104.30.16.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF531606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 00:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF531606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shangen.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.shangen.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=cf-bounce header.b=CDTnRWys;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.net header.i=@cloudflare-smtp.net header.a=rsa-sha256 header.s=cf2024-1 header.b=Ambi+8PI
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=shangen.org; c=relaxed/relaxed;
	h=In-Reply-To:References:From:Cc:Subject:To:Date:Feedback-ID:from:reply-to
	:resent-date:resent-from:resent-to:resent-cc:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive:otp-token:otp-token; t=1795135725; x=1795740525; bh=
	lJKqDUp98SmSKHKD9/VCU8JlR0KHKYo0zsYch6uPCyA=; b=CDTnRWysidNsAZwwmcSFF23Uj23
	lVKMs9hB6V+ibU2ZTPXVlcr/jMVLYMhNI8utqEy8Wdnz/luZ4THOiwpJuSzExF6oGiNzkENUD4T
	qwH2dbsVF4ZElm/Dqo7uliVlCWiGQ1/oLdlDRPLeUtbb78YKZvHVnxU4RoNiWOoubDAOOgASMbL
	xeUBZP1ngRAz2NZloLcza19GTD5d71TduSo5bAMMEro5Lh3I5Bmz8FfkpC2jprKWvHTeCzuIusX
	F0psvO4iiZL6uw0PJwSimZYLgkhrByHxF7Wf/7KQFRXOZ5Raa285Z9MhczydPy27aiGL2YsVaWF
	+PFTNdcTiERZGuw==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.net; c=relaxed/relaxed;
	h=In-Reply-To:References:From:Cc:Subject:To:Date:Feedback-ID:from:reply-to
	:resent-date:resent-from:resent-to:resent-cc:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive:otp-token:otp-token; t=1795135725; x=1795740525; bh=
	lJKqDUp98SmSKHKD9/VCU8JlR0KHKYo0zsYch6uPCyA=; b=Ambi+8PI0CuTfcKJwzJwQe9cWiO
	ZPLxpbpvBGAy3LmUKm5Onzc+5tyVTnQhCTIyMCRqjW8CjfcYTryI7buG2E0E1XEhXqSrwe/hHCU
	qRLL0ZWPdeJWOh7EIEU4xKefGbu7BXjDTwceD34D0m6e9MWUpiBtI2j6oRWI8RvQC33/IicCSOV
	iTgKahJJ6e2RJEEXoeuwkwggI0dhqYp36Jz5LAI3rX92/M+qR54yPfWGhPnIIIqpTncqjfsvc4j
	FoXiV8Csm5+Q4m7KNzG/LJjw2kTjEbbZRgcsL1Qg0J060FniQ3O9UEM1Spwd9PgHjNdiUD9kCJB
	rH/+zU5Peh60shQ==;
Feedback-ID: shangen.org:5:5:Cloudflare
Received: from authenticated-submission.invalid
        by mx.cloudflare.net (Cloudflare Email Submission) with ESMTPSA id 7W2cHzDMzIUs; Fri, 20 Nov 2026 00:48:31 +0000
Message-ID: <YhW6lq8O4pm3D9oM5F5YIVpBGvPxrzy3vpbS@shangen.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 18:48:30 -0600
To: "Filipe Manana" <fdmanana@kernel.org>, "Shang En Sim" <sim@shangen.org>
Subject: Re: [PATCH] btrfs: pin folios before dropping the last extent
 buffer reference
Cc: "David Sterba" <dsterba@suse.com>, "Chris Mason" <mason@kernel.org>,
 "Boris Burkov" <boris@bur.io>, "Daniel Vacek" <neelx@suse.com>, "Filipe
 Manana" <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
From: "Shang En Sim" <sim@shangen.org>
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: aerc 0.22.0
References: <20261117-my-btrfs-patch-v1-1-4b934a7ff69a@shangen.org>
 <CAL3q7H6zzrx-oHoiXqMA6U=GoS8rZpWE7gjtZDkrA-87UycM-Q@mail.gmail.com>
In-Reply-To: <CAL3q7H6zzrx-oHoiXqMA6U=GoS8rZpWE7gjtZDkrA-87UycM-Q@mail.gmail.com>

On Thu Nov 19, 2026 at 11:24 AM CST, Filipe Manana wrote:
> On Wed, Nov 18, 2026 at 12:20 AM Shang En Sim <sim@shangen.org> wrote:
>>
>> release_extent_buffer() drops the last reference to a mapped extent
>> buffer (eb) before detaching its folios.
>
> To mapped and unmapped extent buffers, so remove the "mapped" part.

I will remove "mapped" in v2.

>>   task A                         task B                    task C
>>   release_extent_buffer(eb)
>>    refs: 1 -> 0
>>    remove eb from buffer_tree
>>                                  alloc_extent_buffer()
>>                                   attach_eb_folio_to_filemap()
>>                                    grab_extent_buffer()
>>                                     refs is 0, take over
>>                                     the folios
>>                                  ... new eb released ...
>
> It's not "new eb released", it's the new folio that is released and we
> take the existing folio into the new eb.

My bad, that diagram was misleading.=20

Inside attach_eb_folio_to_filemap(), task B drops its newly allocated
folio and reuses the existing folio for the new eb (eb2), attaching eb2
as folio->private after grab_extent_buffer() detaches eb1. After
alloc_extent_buffer() completes, task B finishes using eb2 and calls
free_extent_buffer(eb2), dropping eb2->refs from 2 to 1 (leaving only
EXTENT_BUFFER_TREE_REF).

>>                                                            drop_caches
>>                                                             folio->mappi=
ng
>>                                                             =3D NULL
>
> And where does this happens?
> Please be detailed, add the call chain triggered by drop_caches that
> results in setting the folio's mapping to NULL.
>
> I don't see how that is happening, because when we end up in
> try_release_extent_buffer(), eb->refs is 0 and that
> makes us return immediately with 0:
>
> spin_lock(&eb->refs_lock);
> if (refcount_read(&eb->refs) !=3D 1 || extent_buffer_under_io(eb)) {
>         spin_unlock(&eb->refs_lock);
>         spin_unlock(&folio->mapping->i_private_lock);
>         return 0;
> }
> spin_unlock(&folio->mapping->i_private_lock);

When task C enters try_release_extent_buffer(), folio->private no longer
points to task A's eb (eb1, with refs =3D=3D 0). Task B's
grab_extent_buffer() detached eb1 and attach_extent_buffer_folio()
attached eb2 to folio->private. Once task B drops its caller reference
on eb2, eb2->refs is 1 (with EXTENT_BUFFER_TREE_REF set), so
try_release_extent_buffer() inspects eb2, clears EXTENT_BUFFER_TREE_REF,
releases eb2 (detaching folio->private), and returns 1.
mapping_evict_folio() then calls remove_mapping() ->
__remove_mapping_unfreeze() -> __remove_mapping() ->
__filemap_remove_folio() -> page_cache_delete(), which sets
folio->mapping =3D NULL.

(If eb2 was already fully freed and detached before task C runs, e.g.
via free_extent_buffer_stale(), try_release_extent_buffer() sees
!folio_test_private(folio) and returns 1 immediately.)

Here is the full sequence, starting with a 0-order folio F in
btree_inode->i_mapping with F->private =3D=3D eb1, F refcount =3D=3D 2 (1 f=
or
the page cache, 1 for F->private), and eb1->refs =3D=3D 1:

1) Task A drops the last reference to eb1:

     release_extent_buffer(eb1)
      refcount_dec_and_test()         # eb1->refs: 1 -> 0
      spin_unlock(&eb1->refs_lock)
      xa_cmpxchg_irq()                # removes eb1 from buffer_tree
      <window before btrfs_release_extent_buffer_folios(eb1)>

2) Task B allocates eb2 for the same bytenr, takes over folio F, and
   drops its caller reference:

     alloc_extent_buffer()
      find_extent_buffer()            # NULL (eb1 removed from tree)
      btrfs_init_eb_prealloc()        # allocates eb2 and new folios
      init_extent_buffer()            # eb2->refs =3D 1
      attach_eb_folio_to_filemap()
       filemap_add_folio() -> -EEXIST
       filemap_lock_folio() -> F      # locks F; F refcnt: 2 -> 3
       grab_extent_buffer(F)
        folio_get_private(F) -> eb1
        refcount_inc_not_zero(&eb1->refs) -> false (eb1->refs =3D=3D 0)
        folio_detach_private(F)       # F->private =3D NULL; refcnt: 3->2
       folio_put(eb2->folios[i])      # drops eb2's unused new folio
       eb2->folios[i] =3D F             # reuses existing folio F
       attach_extent_buffer_folio(eb2, F)
        folio_attach_private(F, eb2)  # F->private =3D eb2; refcnt: 2->3
      __xa_cmpxchg()                  # inserts eb2 into buffer_tree
      check_buffer_tree_ref(eb2)      # sets TREE_REF; eb2->refs: 1 -> 2
      folio_unlock(F)
      folio_put(F)                    # drops lock ref; F refcnt: 3 -> 2
     free_extent_buffer(eb2)
      free_extent_buffer_clear_reading(eb2, false)
       release_extent_buffer(eb2)
        refcount_dec_and_test()       # eb2->refs: 2 -> 1 (TREE_REF)

3) Task C runs drop_caches, releases eb2, and evicts folio F:

     drop_caches_sysctl_handler()
      iterate_supers()
       __iterate_supers()
        drop_pagecache_sb()
         invalidate_mapping_pages()
          mapping_try_invalidate()
           find_lock_entries()        # locks F, fbatch ref: F refcnt 2->3
           mapping_evict_folio(mapping, F)
            folio_ref_count check     # 3 <=3D 1 + 1 + 1 (passes)
            filemap_release_folio(F, 0)
             btree_release_folio(F, 0)
              try_release_extent_buffer(F)
               folio_get_private(F) -> eb2
               eb2->refs =3D=3D 1         # check passes
               test_and_clear_bit(EXTENT_BUFFER_TREE_REF) -> true
               release_extent_buffer(eb2)
                refcount_dec_and_test()  # eb2->refs: 1 -> 0
                spin_unlock(&eb2->refs_lock)
                xa_cmpxchg_irq()         # removes eb2 from buffer_tree
                btrfs_release_extent_buffer_folios(eb2)
                 detach_extent_buffer_folio(eb2, F)
                  folio_detach_private(F) # F->private=3DNULL; refcnt 3->2
                returns 1
            remove_mapping(mapping, F)
             __remove_mapping_unfreeze()
              __remove_mapping()
               folio_ref_freeze(F, 2) # F refcnt: 2 -> 0 (eb1 holds no ref)
               __filemap_remove_folio(F, NULL)
                page_cache_delete()
                 xas_store(NULL)      # removes F from i_pages
                 F->mapping =3D NULL
               returns 1
              folio_ref_unfreeze(F, 1) # drops page cache ref; refcnt 0->1
           folio_unlock(F)
           folio_batch_release()      # drops fbatch ref; refcnt 1->0, free

4) Task A resumes and detaches eb1's folios:

     btrfs_release_extent_buffer_folios(eb1)
      detach_extent_buffer_folio(eb1, F)
       mapping =3D F->mapping           # NULL (F refcnt is 0, freed/reused=
)
       spin_lock(&mapping->i_private_lock)  # NULL dereference

I validated this exact sequence with bpftrace probes during the
reproducer run and observed try_release_extent_buffer() seeing
folio->private =3D=3D eb2 with refs =3D=3D 1, returning 1,
__filemap_remove_folio() running from drop_caches_sysctl_handler(), and
task A subsequently entering detach_extent_buffer_folio(eb1, F) with
F->mapping =3D=3D NULL and refcount =3D=3D 0.

I will replace the diagram with this fuller breakdown (and remove
"mapped") in v2 once you have had a chance to look at the rest of the
patch.

Thanks,
Shang En Sim
