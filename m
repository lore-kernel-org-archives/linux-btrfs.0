Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB306424D4A
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325257; cv=none; b=PjFYAeqLQd2313EazG9DtFl/WXJQyyoHITkaR3bbKUZbwfWrCthP5awoNsO2j1Ei91irOGuYEOhwwo8zbvSGwUx2C86xOP+eQ6b/PGh1NSUZa2r+sGViK9D1cmuKJGMVFdQFrVdtt+iwZwMj3SOY2P5R8+vnFieOFhaUTciP8L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325257; c=relaxed/simple;
	bh=C5LY9FjMi2zsflTtZHZwrpI132+nK80GWqlixZOJ5lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8qMlJ7Dtxp67Ya8ODGsPnwKxAJlhvZBJ122Ky8atwyHsKrtDa0rMmYAyNoEGc4nZ9sxNmBcTFcg4VJHh8r7Hv7c/bBa4/agAewvUXAqhzH9diyO/TVrXeLqHJhEyyvVgB8HCca2Ww6yzwDK7ae8de8q96/omm5LD2fkh9wIDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DUqRLMnH; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUqRLMnH"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c214e625259so159739466b.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 08:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787325252; x=1787930052; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mn9lRbANx31lOFTfJvuMeFsBgMBo4q0tBnz3CC8cGcM=;
        b=DUqRLMnHaYCtAixdI6R+emicDmkXZTuivS7Wbb5vsooIYH8wn7ujuvEk3CHQszbGDZ
         Gdu4CQM/q/Bb8Nt3RxLz1A5Es2OGwCiIZjfAP1VxubF6/nfuR0ARm/ZT2/IX0P/Iiip3
         gz/jPX3x4anmizBxBUexyzSa28e5T2FRLfzAViTQSLCjgYG5tsTvObLPRirHZ1KSTLc9
         NhqmNnVpr8tx42HeoVWy49jMB0ckVvGe0BEKzVqMTa/uwi++595pSBHv1DTCw2jRKtBN
         OgSm8Tc1bQ+o5lmHP8FgOUuszYRAz1ia3KU+cCNpvWfQG/dmLYZmN5c2gZWMwBpP38SS
         mxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787325252; x=1787930052;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mn9lRbANx31lOFTfJvuMeFsBgMBo4q0tBnz3CC8cGcM=;
        b=SK0lfSEhDXXo8xV2hZ/omxnnvGjMiMZYI1yHnE02rmRwD9jKuxVk9v4k5e8lmgLO2f
         Pp0HPM0XbvAVbfBzjZHVxYlvlTO5/f2tFZFB5sYm3n3vngG3ShXE+LXayYlElU134IhW
         ttCRrHgzSbqajy0neCh9O5d5hQIeRqP5QXAhud3HqSDlSfu09iGTbrJIkDrpok5fVbL3
         DVjt+rINa0GxGzw3qn9LywFcV3WQj6bGTQwE9xeL6whuQCr9lQVi+RSXKEs4kJvM7HgX
         deZgDdwM+QUz1umePk57yfeedY4dhs8RwtAeUKzgRCrKrAlspXAKhT+jW+zy9c7P8dPa
         Y1Bg==
X-Gm-Message-State: AFuF++m8dprOXWdFVSY9yWNnpNMU5yinT07ZFzwAL2BJnwq28JGTo4Tv
	5AKiVpFfJulSrKXFJ99ORWI1raSqNGvSagGcAT17sVNhCgVOHnvuv1+nQlg8cOTvX7WEGQ==
X-Gm-Gg: AR+sD12PHXvuJ9Gi7WmGqAp8qy7wSeN0leAqTAhBcFI7tqWGuQPWTdZcaa0hSfZMeia
	MgcIE4klVq1Sd7mElTVASkmlFK6w0Bqne4v7lwA/cFhELRJnIwHlnopVJCLqb6NGzLFQfv0Ce6X
	3X3fUEvXXtxa2vkPWob6ztcB6KHPU5f/WkPbxFhsz5oKSWJiAWDgQpJV2oBMB+y/RW27tpc/S8L
	4B/kPbBmYWCtAIICDRRVTJZ2oVitmrZNbteyXliKu5g4I2Sgyv4+KglsI9hKc/WoLTZHxvc2amC
	Xe6R4e7RWvuwmA36dMqy/gOI59qMTlmMQDFqSgTMYnVheM1bw0nd8PVqAVNF4K8bL3hxMxK7Gvk
	APQIWVeUfQmfH2wp2pC+A6GcW9vzly0tY8MIXlMPyjay1IS4EvBDWDYaSdDgkEn0JcnVNxjONPL
	jKrze/eodllldQWOJjeLpISGc/MBhSfbxDEnfTn2p6Xno+cAeLH3cid7Fa2LXot70gCsG/dyV7M
	WBL1J2ITo4lK1U=
X-Received: by 2002:a17:907:9628:b0:c16:13e7:fd63 with SMTP id a640c23a62f3a-c2469f94a1bmr743269266b.0.1787325251513;
        Fri, 21 Aug 2026 08:14:11 -0700 (PDT)
Received: from localhost ([37.30.50.77])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c245921e461sm565258466b.54.2026.08.21.08.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:14:10 -0700 (PDT)
Date: Fri, 21 Aug 2026 17:14:09 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, "Yan, Zheng" <zheng.yan@oracle.com>, 
	linux-kernel@vger.kernel.org, syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Subject: Re: [PATCH RFC v2] btrfs: keep mixed block group writable for
 relocation setup commit
Message-ID: <gqqzjkrwq3hksoxjz2lfb3l7d3lciayrxwkhhhgxle2pzselbx@lny2omldw43q>
References: <vu6cjfyamplqqiy4hbu5eobbp65cy4fzv2jci4n5lfalanvmlp@pf5bfsi33gl7>
 <8120fe88-3b71-4e0c-aeb1-11a2c5726ddb@suse.com>
 <7095ff94-609d-4b0c-b425-37e652b3ea17@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <7095ff94-609d-4b0c-b425-37e652b3ea17@suse.com>

On Fri, Aug 14, 2026 at 08:04:13AM +0930, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/8/14 08:01, Qu Wenruo =E5=86=99=E9=81=93:
> >=20
> >=20
> > =E5=9C=A8 2026/8/13 20:47, Bartosz Chronowski =E5=86=99=E9=81=93:
> >> Relocating a nearly full mixed block group can abort the filesystem
> >> transaction with -ENOSPC and trigger a warning in cleanup_transaction(=
).
> >>
> >> Making the mixed target read-only can lead to a condition where
> >> metadata COW cannot use its free space. In particular,
> >> btrfs_relocate_block_group() marks the mixed target read-only before
> >> prepare_to_relocate() commits the setup transaction. find_free_extent()
> >> then skips all free extents in the target. Commit-time COW still needs
> >> new tree blocks, so the transaction can fail with -ENOSPC when no
> >> suitable extent remains in another block group.
> >=20
> > Then why things like btrfs_inc_block_group_ro() fail with ENOSPC in the=
=20
> > first place?
>=20
> Sorry, missing the important word "not".
>=20
> Why that function did *not* fail with ENOSPC in the first place?
>=20
> >=20
> > I believe that's the root problem that your agent never explained.

Because when it ran, it still showed enough space during the check.

The check in inc_block_group_ro() only compares the counters of that
moment. For a mixed group it takes the data branch and tests:

    space_info_used + target_available <=3D total_bytes

The reproduction path showed values `3170304 + 122880 <=3D 9895936`.=20
The check had 6602752 bytes to spare, so `btrfs_inc_block_group_ro()`
returned 0. It reserved no physical metadata extent for the later setup wor=
k.

The shortage appears after the switch. In a mixed group, data and
metadata share the same space, so the read-only target also stops
serving metadata. The setup commit in prepare_to_relocate() still has
to COW tree blocks; its reservation is satisfied from the global
block reserve, so nothing really fails until the physical allocation runs
inside the commit.=20
By then the rest of the pool was gone: the abort-time dump in the=20
syzbot report shows used + pinned + reserved +
readonly equal to the total, to the byte, with reservations still
outstanding. find_free_extent() skipped the read-only target, found
no usable extent elsewhere and no room for a new chunk, and a failed
allocation inside a commit is a transaction abort.

So btrfs_inc_block_group_ro() cannot report this ENOSPC: when it
runs, the shortage does not exist yet. It is created between that
check and the setup commit's first allocation, and nothing ties the
early success to the later obligation.

The expectation for the cleanest solution would be to that the function
should simply have rejected this state.=20
I looked for a condition-only change that does that, and
I do not see a correct one - the recorded numbers rule it out. The
failing admission had two thirds of the filesystem free. A
condition strict enough to reject that state would reject
practically every balance (!) of a small mixed filesystem,
and any condition that accepts it leaves the bug, because the
reservations that later consume the margin happen after the
spinlocks drop. No formula evaluated at that moment can see them. A
stricter formula stays an unowned snapshot unless it also reserves
the capacity, and that is an ownership/serialization change, not minor=20
condition in the existing btrfs flow.

> >=20
> >>
> >> Committing before the read-only transition does not fix the bug.
> >> Another workload can reserve space or start transaction N+1 between the
> >> commit and btrfs_inc_block_group_ro().
> >>
> >> Keep a non-zoned, non-remap mixed target writable until its relocation
> >> setup transaction finishes. Fence data, tree-log and NOCOW admission
> >> while ordinary metadata COW remains allowed. Drain operations that
> >> crossed the fence before committing the setup transaction with
> >> reloc_ctl unpublished.
> >>
> >> Implement the boundary at the source files that own each state:
> >>
> >> - block-group.c owns the setup fence and final read-only transition,
> >> =C2=A0=C2=A0 treats the fence as read-only for NOCOW and swap-extents =
admission,
> >> =C2=A0=C2=A0 and makes other read-only holders wait for setup completi=
on;
> >> - extent-tree.c rejects data and tree-log allocation into the fenced
> >> =C2=A0=C2=A0 target, allows ordinary metadata COW, and keeps block gro=
up
> >> =C2=A0=C2=A0 reservations only for data allocations until ordered exte=
nt
> >> =C2=A0=C2=A0 registration;
> >> - inode.c treats the fenced target as read-only during NOCOW checks;
> >> - relocation.c drains each pass, binds setup to the running transaction
> >> =C2=A0=C2=A0 and owns the read-only and reloc_ctl lifecycle;
> >> - transaction.c completes setup after switching commit roots and before
> >> =C2=A0=C2=A0 transaction N+1 can start;
> >> - disk-io.c cancels a pending setup when its transaction is cleaned up.
> >>
> >> At the transaction tail, either mark the target read-only and publish
> >> reloc_ctl, or return the read-only transition error to relocation while
> >> the transaction completes and the target stays writable. Apply this
> >> boundary to every non-remap mixed relocation pass. Keep the existing
> >> paths unchanged for zoned, remap-tree and non-mixed block groups.
> >=20
> > It's overly complex for a not-so-common feature.
> >=20
> > Remember mixed block groups are mostly for small fses, which also=20
> > matches the syzbot test environment.
> >=20
> > There are mixed-bg users but very few, and even for that case I believe=
=20
> > they have a much larger fs, thus should have more buffer room.

Yes, thats a good point.=20

On the small-fs point: yes, this needs a nearly full small mixed
filesystem, and a larger one makes it practically unreachable.=20

It still might be worth fixing because of the failure mode: one
balance and the filesystem is read-only from a transaction abort,
instead of the balance returning an error.

> >=20
> > I do not think this is the correct way to go,=20

Regarding the RFC v2 approach, I checked four smaller candidate fixes
against the error path:

1. Commit the running transaction first, then set read-only (my v1).
   The window you named in the v1 review ("another workload triggered=20
   space reservation between the just committed transaction and=20
   btrfs_inc_block_group_ro()?") is real, and it is not the
   only one: the setup commit allocates after the group is already
   read-only, so even a perfectly placed pre-commit does not protect
   it. It can hide the reproducer, but the bug is present. =20

2. Make the admission stricter, e.g. restore the 1 MiB slack that
   commit f8935566372c ("btrfs: kill min_allocable_bytes in
   inc_block_group_ro") removed. The failing admission above passed
   with 6602752 bytes of margin, so the old 1 MiB margin would not have
   changed that decision. A fixed margin remains unowned after the
   check and cannot guarantee capacity for the later setup work.

3. Fill rc->block_rsv before the read-only switch. In the traced
   failing run the setup commit's 4 KiB request was satisfied from
   the global block reserve while rc->block_rsv was full. A logical
   reserve does not own a physical extent, so a fuller or earlier
   reserve changes nothing here.=20

4. Send mixed groups through the metadata overcommit logic instead:
   not available, btrfs_can_overcommit() refuses any space info with
   the DATA bit set.

Error-path analysis, runtime debugging and reproduction with syz-crush
all showed that none of these four candidates is a correct fix.

That leaves changing when the condition runs, not what it computes.
This is where v2 does what your question expects from the check: the
same inequality, evaluated again at the tail of the setup commit,
does return -ENOSPC there, because at that point nothing can
invalidate the answer anymore. In the patched trace the inequality
would still have passed before setup (2818048 <=3D 3276800), and at
the tail it failed (3731456 > 3276800), so balance got a plain
-ENOSPC and the filesystem stayed writable. The defect was the
lifetime of the early answer, not its formula. v2 applies this only
to non-zoned, non-remap mixed groups; everything else keeps the
current path.

On the approach:
What I can defend is the boundary - decide read-only at the tail of the=20
setup commit, where the answer cannot go stale.=20
Like mentioned above, I did not find a condition-only fix or an existing=20
smaller serialization point that keeps an early result valid through setup.
The remaining question from your review, as I understand it,
is whether that same boundary can be implemented with less state and
fewer touched files. If you see an existing serialization or
ownership mechanism that can host the late decision, point me at it
and I will rework the patch around it.

For the:
>> nor even properly=20
> > explained the bug in the first place.

I rewrote the commit message from scratch:

Proposed v3 commit message below (code unchanged). Once the approach
question is settled I can send it as a proper v3 respin, with the
version changelog after the --- marker.

 btrfs: keep mixed block group writable through relocation setup =20
 =20
=C2=A0Balancing a nearly full filesystem with mixed block groups can run ou=
t =20
=C2=A0of space while committing relocation setup. The commit failure aborts=
 =20
=C2=A0the transaction, triggers the WARNING in  cleanup_transaction(), and=
=20
 leaves the filesystem read-only instead of failing only the balance=20
 with -ENOSPC.
 =20
=C2=A0btrfs_inc_block_group_ro() does not reject the transition because it =
=20
=C2=A0checks space before prepare_to_relocate() commits the setup transacti=
on. =20
=C2=A0In the reproduced run, the mixed-space check evaluated: =20
=C2=A0
   space_info_used + target_available <=3D total_bytes=20
  =20
   which in the reproduced failure evaluated to
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03170304 + 122880 <=3D 9895936 =20
 =20
 The success is a point-in-time snapshot: it moves the target's free =20
 bytes to bytes_readonly, but it reserves no physical extent for the =20
 setup work that follows. The shortage is created after that check.
 =20
=C2=A0After the target becomes read-only, prepare_to_relocate() still commi=
ts =20
=C2=A0metadata COW. The first 4 KiB tree-block request used the global bloc=
k =20
=C2=A0reserve while rc->block_rsv remained full. That logical reservation d=
id =20
=C2=A0not bind a physical extent. find_free_extent() skipped the read-only =
=20
=C2=A0target and found neither another suitable extent nor space for a new =
=20
=C2=A0chunk, so allocation returned -ENOSPC inside the transaction commit. =
=20
 =20
=C2=A0The predicate is not wrong. The bug is using its early result as =20
=C2=A0permission for a later setup commit after the target has stopped serv=
ing =20
=C2=A0allocations. Restoring the old 1 MiB margin would not change the obse=
rved =20
=C2=A0decision, which had 6602752 bytes of accounting headroom. Committing =
a =20
=C2=A0transaction before the read-only transition would still leave setup =
=20
=C2=A0allocating after the target becomes read-only. =20
 =20
=C2=A0Keep a non-zoned, non-remap mixed target writable through relocation =
=20
=C2=A0setup so metadata COW can use its free extents. Fence new data, tree-=
log, =20
=C2=A0NOCOW and swap users, drain users that crossed the fence, and bind se=
tup =20
=C2=A0to the running transaction. At the transaction tail, repeat the locke=
d =20
=C2=A0read-only check before another transaction can start. On success, mar=
k =20
=C2=A0the target read-only and publish reloc_ctl. On failure, clear the set=
up =20
=C2=A0state and return -ENOSPC to balance without aborting the transaction.=
 =20
 =20
=C2=A0Leave zoned, remap-tree and non-mixed relocation paths unchanged. =20
 =20
=C2=A0The syzbot C reproducer triggered the warning without this change and=
 no =20
=C2=A0longer triggered it with the change applied. Tests also covered the l=
ate =20
=C2=A0read-only failure and setup-abort cleanup paths. =20
 =20
=C2=A0Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance") =
=20
=C2=A0Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com =
=20
=C2=A0Closes: https://syzkaller.appspot.com/bug?extid=3D021d10c4d4edc87daa0=
3 =20
=C2=A0Link: https://lore.kernel.org/r/7095ff94-609d-4b0c-b425-37e652b3ea17@=
suse.com =20
=C2=A0Assisted-by: Codex:gpt-5.6-sol syzkaller =20
=C2=A0Signed-off-by: Bart Chronowski <immersa.bartosz.chronowski@gmail.com>

As always, I=E2=80=99m open to feedback.

Best,
Bartosz


> >>
> >> Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
> >> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> >> Closes: https://syzkaller.appspot.com/bug?extid=3D021d10c4d4edc87daa03
> >> Link: https://lore.kernel.org/r/9d9d207e-=20
> >> ad2a-4af6-9d0b-9a2bfc61d442@suse.com
> >> Assisted-by: Codex:gpt-5.6-sol syzkaller
> >> Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.co=
m>
> >> ---
> >> Changes in v2:
> >> - Drop the pre-commit-only approach because it leaves an admission win=
dow
> >> =C2=A0=C2=A0 before the block group becomes read-only.
> >> - Keep the mixed target writable for setup metadata COW while fencing=
=20
> >> data,
> >> =C2=A0=C2=A0 tree-log and NOCOW admission.
> >> - Bind setup to the exact transaction and publish the read-only state =
and
> >> =C2=A0=C2=A0 reloc_ctl before transaction N+1 can start.
> >> - Apply the same boundary to every non-remap relocation pass and handle
> >> =C2=A0=C2=A0 abort cleanup explicitly.
> >>
> >> Tested:
> >> - Focused and full x86_64 builds.
> >> - The syzbot C reproducer completed 16 independent runs without a cras=
h.
> >>
> >> v1: https://lore.kernel.org/r/a06b5077-baa5-473f-9c65-=20
> >> bf72ac651b14@mail.kernel.org
> >>
> >> =C2=A0 fs/btrfs/block-group.c | 128 ++++++++++++++++---
> >> =C2=A0 fs/btrfs/block-group.h |=C2=A0=C2=A0 8 +-
> >> =C2=A0 fs/btrfs/disk-io.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> >> =C2=A0 fs/btrfs/extent-tree.c |=C2=A0 19 ++-
> >> =C2=A0 fs/btrfs/extent-tree.h |=C2=A0=C2=A0 1 +
> >> =C2=A0 fs/btrfs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 4 +-
> >> =C2=A0 fs/btrfs/relocation.c=C2=A0 | 280 +++++++++++++++++++++++++++++=
+++++++-----
> >> =C2=A0 fs/btrfs/relocation.h=C2=A0 |=C2=A0=C2=A0 4 +
> >> =C2=A0 fs/btrfs/transaction.c |=C2=A0=C2=A0 4 +
> >> =C2=A0 fs/btrfs/transaction.h |=C2=A0=C2=A0 3 +
> >> =C2=A0 10 files changed, 395 insertions(+), 57 deletions(-)
> >>
> >> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> >> index 8def7abb728f..332fc2721e01 100644
> >> --- a/fs/btrfs/block-group.c
> >> +++ b/fs/btrfs/block-group.c
> >> @@ -21,6 +21,7 @@
> >> =C2=A0 #include "fs.h"
> >> =C2=A0 #include "accessors.h"
> >> =C2=A0 #include "extent-tree.h"
> >> +#include "relocation.h"
> >> =C2=A0 static struct kmem_cache *block_group_cache;
> >> =C2=A0 static struct kmem_cache *free_space_ctl_cache;
> >> @@ -363,7 +364,8 @@ struct btrfs_block_group=20
> >> *btrfs_inc_nocow_writers(struct btrfs_fs_info *fs_info,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&bg->lock);
> >> -=C2=A0=C2=A0=C2=A0 if (bg->ro)
> >> +=C2=A0=C2=A0=C2=A0 if (bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_SETU=
P,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &bg->runtime_flags))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 can_nocow =3D f=
alse;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&bg-=
>nocow_writers);
> >> @@ -419,7 +421,8 @@ void btrfs_wait_block_group_reservations(struct=20
> >> btrfs_block_group *bg)
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_space_info *space_info =3D=
 bg->space_info;
> >> -=C2=A0=C2=A0=C2=A0 ASSERT(bg->ro);
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_S=
ETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &bg->runtime_flags));
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(bg->flags & BTRFS_BLOCK_GROUP_DAT=
A))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> >> @@ -1434,7 +1437,8 @@ struct btrfs_trans_handle=20
> >> *btrfs_start_trans_remove_block_group(
> >> =C2=A0=C2=A0 * data in this block group. That check should be done by =
relocation=20
> >> routine,
> >> =C2=A0=C2=A0 * not this function.
> >> =C2=A0=C2=A0 */
> >> -static int inc_block_group_ro(struct btrfs_block_group *cache, bool=
=20
> >> force)
> >> +static int __inc_block_group_ro(struct btrfs_block_group *cache, bool=
=20
> >> force,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 bool reloc_setup)
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_space_info *sinfo =3D cach=
e->space_info;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 num_bytes;
> >> @@ -1442,6 +1446,11 @@ static int inc_block_group_ro(struct=20
> >> btrfs_block_group *cache, bool force)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&sinfo->lock);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&cache->lock);
> >> +=C2=A0=C2=A0=C2=A0 if (!reloc_setup && test_bit(BLOCK_GROUP_FLAG_RELO=
C_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cache->runtime_flags))=
 {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EAGAIN;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cache->swap_extents) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ETXTBS=
Y;
> >> @@ -1504,6 +1513,54 @@ static int inc_block_group_ro(struct=20
> >> btrfs_block_group *cache, bool force)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0 }
> >> +static int inc_block_group_ro(struct btrfs_block_group *cache, bool=
=20
> >> force)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 return __inc_block_group_ro(cache, force, false);
> >> +}
> >> +
> >> +int btrfs_bg_reloc_setup_start(struct btrfs_block_group *cache, bool=
=20
> >> drop_ro)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D cache->fs_info;
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_space_info *sinfo =3D cache->space_in=
fo;
> >> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(!btrfs_is_zoned(fs_info));
> >> +
> >> +=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&sinfo->lock);
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&cache->lock);
> >> +=C2=A0=C2=A0=C2=A0 if (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache-=
>runtime_flags) ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->ro !=3D (drop_ro ? =
1 : 0)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EAGAIN;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +
> >> +=C2=A0=C2=A0=C2=A0 set_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cache->runt=
ime_flags);
> >> +=C2=A0=C2=A0=C2=A0 if (drop_ro) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->ro =3D 0;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sinfo->bytes_readonly -=3D=
=20
> >> btrfs_block_group_available_space(cache);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&cache->ro_l=
ist);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +out:
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&cache->lock);
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&sinfo->lock);
> >> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0 return ret;
> >> +}
> >> +
> >> +int btrfs_bg_reloc_setup_finish(struct btrfs_block_group *cache)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cac=
he-=20
> >> >runtime_flags));
> >> +=C2=A0=C2=A0=C2=A0 return __inc_block_group_ro(cache, false, true);
> >> +}
> >> +
> >> +void btrfs_bg_reloc_setup_abort(struct btrfs_block_group *cache)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP, &cac=
he-=20
> >> >runtime_flags));
> >> +=C2=A0=C2=A0=C2=A0 clear_and_wake_up_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cache->runtime_flags);
> >> +}
> >> +
> >> =C2=A0 static bool clean_pinned_extents(struct btrfs_trans_handle *tra=
ns,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct btrfs_block_group *bg)
> >> =C2=A0 {
> >> @@ -1945,6 +2002,7 @@ static int btrfs_reclaim_block_group(struct=20
> >> btrfs_block_group *bg, int *reclaime
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 reserved;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 old_total;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
> >> +=C2=A0=C2=A0=C2=A0 bool marked_ro =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Don't race with allocators so take t=
he groups_sem */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_write(&space_info->groups_sem);
> >> @@ -2018,15 +2076,19 @@ static int btrfs_reclaim_block_group(struct=20
> >> btrfs_block_group *bg, int *reclaime
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> -=C2=A0=C2=A0=C2=A0 ret =3D inc_block_group_ro(bg, false);
> >> +=C2=A0=C2=A0=C2=A0 if (!btrfs_relocation_uses_fenced_setup(bg)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D inc_block_group_ro=
(bg, false);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ma=
rked_ro =3D true;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&space_info->groups_sem);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * The amount of bytes reclaimed c=
orresponds to the sum of the
> >> -=C2=A0=C2=A0=C2=A0=C2=A0 * "used" and "reserved" counters. We have se=
t the block group
> >> -=C2=A0=C2=A0=C2=A0=C2=A0 * to RO above, which prevents reservations f=
rom happening but
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * "used" and "reserved" counters. Relocation=
 prevents new data
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * reservations before it drains existing res=
ervations, but
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * we may have existing reservatio=
ns for which allocation has
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * not yet been done - btrfs_updat=
e_block_group() was not yet
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * called, which is where we will =
transfer a reserved extent's
> >> @@ -2048,7 +2110,8 @@ static int btrfs_reclaim_block_group(struct=20
> >> btrfs_block_group *bg, int *reclaime
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace_btrfs_reclaim_block_group(bg);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_relocate_chunk(fs_info, b=
g->start, false);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_dec_block_group_ro(b=
g);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (marked_ro)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_dec_block_group_ro(bg);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_in=
fo, "error relocating chunk %llu",
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 bg->start);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 used =3D 0;
> >> @@ -3131,7 +3194,7 @@ int btrfs_inc_block_group_ro(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D btrfs_block=
_group_root(fs_info);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 alloc_flags;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >> -=C2=A0=C2=A0=C2=A0 bool dirty_bg_running;
> >> +=C2=A0=C2=A0=C2=A0 bool retry;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!root)) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_in=
fo, "missing block group root");
> >> @@ -3145,9 +3208,18 @@ int btrfs_inc_block_group_ro(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Thus here we skip all chunk all=
ocations.
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sb_rdonly(fs_info->sb)) {
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->ro_bl=
ock_group_mutex);
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D inc_block_group_ro=
(cache, false);
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->ro_=
block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mu=
tex_lock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
try =3D test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cache->runtime_flags);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!retry)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D inc_block_group_ro(cache, false);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mu=
tex_unlock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (retry)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D wait_on_bit(&cache->runtime_flags,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 TASK_INTERRUPTIBLE);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (retry && !ret);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> @@ -3156,7 +3228,7 @@ int btrfs_inc_block_group_ro(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(tran=
s))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return PTR_ERR(trans);
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dirty_bg_running =3D false;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retry =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We're n=
ot allowed to set block groups readonly after the=20
> >> dirty
> >> @@ -3164,7 +3236,19 @@ int btrfs_inc_block_group_ro(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * back of=
f and let this transaction commit.
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_=
info->ro_block_group_mutex);
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BTRFS_TRANS_D=
IRTY_BG_RUN, &trans->transaction-=20
> >> >flags)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BLOCK_GROUP_F=
LAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cache->runtime_flags)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mu=
tex_unlock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_end_transaction(trans);
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D wait_on_bit(&cache->runtime_flags,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_=
RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TASK_INTERRUPTIBL=
E);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
try =3D true;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (test_bit(BTRFS_=
TRANS_DIRTY_BG_RUN,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &trans->transaction->flags)) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 u64 transid =3D trans->transid;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 mutex_unlock(&fs_info->ro_block_group_mutex);
> >> @@ -3173,9 +3257,9 @@ int btrfs_inc_block_group_ro(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D btrfs_wait_for_commit(fs_info, transid);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ret)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 di=
rty_bg_running =3D true;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
try =3D true;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> -=C2=A0=C2=A0=C2=A0 } while (dirty_bg_running);
> >> +=C2=A0=C2=A0=C2=A0 } while (retry);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (do_chunk_alloc) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> @@ -3411,7 +3495,9 @@ static void cache_save_setup(struct=20
> >> btrfs_block_group *block_group,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retries++;
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (block_group->ro)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (block_group->ro ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 te=
st_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 &block_group->runtime_flags))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto out_free;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D create_=
free_space_inode(trans, block_group, path);
> >> @@ -3981,6 +4067,7 @@ int btrfs_update_block_group(struct=20
> >> btrfs_trans_handle *trans,
> >> =C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 @num_bytes except for the compress path.
> >> =C2=A0=C2=A0 * @num_bytes:=C2=A0=C2=A0=C2=A0 The number of bytes in qu=
estion
> >> =C2=A0=C2=A0 * @delalloc:=C2=A0=C2=A0 The blocks are allocated for the=
 delalloc write
> >> + * @allow_reloc_setup: Allow ordinary metadata into a relocation=20
> >> setup target.
> >> =C2=A0=C2=A0 *
> >> =C2=A0=C2=A0 * This is called by the allocator when it reserves space.=
 If this is a
> >> =C2=A0=C2=A0 * reservation and the block group has become read only we=
 cannot=20
> >> make the
> >> @@ -3988,7 +4075,8 @@ int btrfs_update_block_group(struct=20
> >> btrfs_trans_handle *trans,
> >> =C2=A0=C2=A0 */
> >> =C2=A0 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ram_bytes, u64 num_bytes, bool =
delalloc,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_wrong_size_class)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_wrong_size_class,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool allow_reloc_setup)
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_space_info *space_info =3D=
 cache->space_info;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum btrfs_block_group_size_class size_=
class;
> >> @@ -3996,7 +4084,9 @@ int btrfs_add_reserved_bytes(struct=20
> >> btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&space_info->lock);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&cache->lock);
> >> -=C2=A0=C2=A0=C2=A0 if (cache->ro) {
> >> +=C2=A0=C2=A0=C2=A0 if (cache->ro ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (!allow_reloc_setup &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(BLOCK_GROUP=
_FLAG_RELOC_SETUP, &cache-=20
> >> >runtime_flags))) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EAGAIN;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_error;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> @@ -4832,7 +4922,7 @@ bool btrfs_inc_block_group_swap_extents(struct=
=20
> >> btrfs_block_group *bg)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ret =3D true;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&bg->lock);
> >> -=C2=A0=C2=A0=C2=A0 if (bg->ro)
> >> +=C2=A0=C2=A0=C2=A0 if (bg->ro || test_bit(BLOCK_GROUP_FLAG_RELOC_SETU=
P, &bg-=20
> >> >runtime_flags))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bg->swap_extent=
s++;
> >> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> >> index 790c2d467af5..d2b1dd01b45e 100644
> >> --- a/fs/btrfs/block-group.h
> >> +++ b/fs/btrfs/block-group.h
> >> @@ -95,6 +95,8 @@ enum btrfs_block_group_flags {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_NEW,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_FULLY_REMAPPED,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
> >> +=C2=A0=C2=A0=C2=A0 /* Block data, tree-log and NOCOW admission during=
 relocation=20
> >> setup. */
> >> +=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> =C2=A0 };
> >> =C2=A0 enum btrfs_caching_type {
> >> @@ -364,6 +366,9 @@ void btrfs_create_pending_block_groups(struct=20
> >> btrfs_trans_handle *trans);
> >> =C2=A0 int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool do_chunk_alloc);
> >> =C2=A0 void btrfs_dec_block_group_ro(struct btrfs_block_group *cache);
> >> +int btrfs_bg_reloc_setup_start(struct btrfs_block_group *cache, bool=
=20
> >> drop_ro);
> >> +int btrfs_bg_reloc_setup_finish(struct btrfs_block_group *cache);
> >> +void btrfs_bg_reloc_setup_abort(struct btrfs_block_group *cache);
> >> =C2=A0 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *t=
rans);
> >> =C2=A0 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *t=
rans);
> >> =C2=A0 int btrfs_setup_space_cache(struct btrfs_trans_handle *trans);
> >> @@ -371,7 +376,8 @@ int btrfs_update_block_group(struct=20
> >> btrfs_trans_handle *trans,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 bytenr, u64 num_bytes, bool all=
oc);
> >> =C2=A0 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ram_bytes, u64 num_bytes, bool =
delalloc,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_wrong_size_class);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_wrong_size_class,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool allow_reloc_setup);
> >> =C2=A0 void btrfs_free_reserved_bytes(struct btrfs_block_group *cache,=
 u64=20
> >> num_bytes,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool is_delalloc);
> >> =C2=A0 int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 2f1666d9544e..eab2fc5bf8b9 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -4936,6 +4936,7 @@ void btrfs_cleanup_one_transaction(struct=20
> >> btrfs_transaction *cur_trans)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_destroy_delayed_refs(cur_trans);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_abort_relocation_setup(cur_trans, cur_trans-=
>aborted);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_trans->state =3D TRANS_STATE_COMMIT=
_START;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wake_up(&fs_info->transaction_blocked_w=
ait);
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index 624d76e0ca01..962af1840781 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -4639,6 +4639,9 @@ static noinline int find_free_extent(struct=20
> >> btrfs_root *root,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 down_read(&space_info->groups_sem);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (list_empty(&block_group->list) ||
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_group->ro ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &block_group->run=
time_flags) &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 (ffe_ctl->is_data || ffe_ctl->for_treelog)) ||
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (block_group->flags & BTRFS_BLOCK_GROUP_R=
EMAPPED)) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * someone is removing this block gr=
oup,
> >> @@ -4674,7 +4677,10 @@ static noinline int find_free_extent(struct=20
> >> btrfs_root *root,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl->hinted=
 =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* If the block=
 group is read-only, we can skip it entirely. */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(bl=
ock_group->ro ||
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPE=
D))) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 (test_bit(BLOCK_GROUP_FLAG_RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &block_group->runtime_flags) &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (ffe_ctl->is_data || ffe_ctl->for_treelog)) ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ffe_ctl->for_treelog)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_clear_treelog_bg(block_group);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ffe_ctl->for_data_reloc)
> >> @@ -4776,14 +4782,16 @@ static noinline int find_free_extent(struct=20
> >> btrfs_root *root,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_a=
dd_reserved_bytes(block_group, ffe_ctl->ram_bytes,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl->num_bytes,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl->delalloc,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ffe_ctl->loop >=3D LOOP_WRONG_SIZE_CLASS);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ffe_ctl->loop >=3D LOOP_WRONG_SIZE_CLASS,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 !ffe_ctl->is_data && !ffe_ctl->for_treelog);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D =
-EAGAIN) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_add_free_space_unused(block_group,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl->found_of=
fset,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl->num_byte=
s);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto loop;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_inc_block_group_rese=
rvations(block_group);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ffe_ctl->is_data)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_inc_block_group_reservations(block_group);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* we are all g=
ood, lets return */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ins->objectid =
=3D ffe_ctl->search_start;
> >> @@ -4897,14 +4905,13 @@ int btrfs_reserve_extent(struct btrfs_root=20
> >> *root, u64 ram_bytes,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.empty_size =3D empty_size;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.flags =3D flags;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.delalloc =3D delalloc;
> >> +=C2=A0=C2=A0=C2=A0 ffe_ctl.is_data =3D is_data;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.hint_byte =3D hint_byte;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.for_treelog =3D for_treelog;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ffe_ctl.for_data_reloc =3D for_data_rel=
oc;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_free_extent(root, ins, &ff=
e_ctl);
> >> -=C2=A0=C2=A0=C2=A0 if (!ret && !is_data) {
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_dec_block_group_rese=
rvations(fs_info, ins->objectid);
> >> -=C2=A0=C2=A0=C2=A0 } else if (ret =3D=3D -ENOSPC) {
> >> +=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -ENOSPC) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!final_trie=
d && ins->offset) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 num_bytes =3D min(num_bytes >> 1, ins->offset);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 num_bytes =3D round_down(num_bytes,
> >> diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
> >> index ff330d4896d6..74ba10a46951 100644
> >> --- a/fs/btrfs/extent-tree.h
> >> +++ b/fs/btrfs/extent-tree.h
> >> @@ -40,6 +40,7 @@ struct find_free_extent_ctl {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool use_cluster;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool delalloc;
> >> +=C2=A0=C2=A0=C2=A0 bool is_data;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool have_caching_bg;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool orig_have_caching_bg;
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index 2534cd9284d5..28c5902636d3 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -7398,7 +7398,9 @@ static bool btrfs_extent_readonly(struct=20
> >> btrfs_fs_info *fs_info, u64 bytenr)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool readonly =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_group =3D btrfs_lookup_block_grou=
p(fs_info, bytenr);
> >> -=C2=A0=C2=A0=C2=A0 if (!block_group || block_group->ro)
> >> +=C2=A0=C2=A0=C2=A0 if (!block_group || block_group->ro ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit(BLOCK_GROUP_FLAG_=
RELOC_SETUP,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 &block_group->runtime_flags))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 readonly =3D tr=
ue;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (block_group)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_put_block=
_group(block_group);
> >> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> >> index fc5c14b5adad..92059ebc8345 100644
> >> --- a/fs/btrfs/relocation.c
> >> +++ b/fs/btrfs/relocation.c
> >> @@ -173,11 +173,16 @@ struct reloc_control {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 search_start;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 extents_found;
> >> +=C2=A0=C2=A0=C2=A0 int setup_result;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum reloc_stage stage;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool create_reloc_tree;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool merge_reloc_tree;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool found_file_extent;
> >> +=C2=A0=C2=A0=C2=A0 bool fenced_setup;
> >> +=C2=A0=C2=A0=C2=A0 bool setup_pending;
> >> +=C2=A0=C2=A0=C2=A0 bool block_group_ro;
> >> +=C2=A0=C2=A0=C2=A0 bool reloc_ctl_set;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_t refs;
> >> =C2=A0 };
> >> @@ -3507,14 +3512,24 @@ int find_next_extent(struct reloc_control *rc,=
=20
> >> struct btrfs_path *path,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0 }
> >> -static void set_reloc_control(struct reloc_control *rc)
> >> +static void __set_reloc_control(struct reloc_control *rc)
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D rc->e=
xtent_root->fs_info;
> >> -=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->reloc_mutex);
> >> +=C2=A0=C2=A0=C2=A0 lockdep_assert_held(&fs_info->reloc_mutex);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->reloc_ctl_lock);
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(!fs_info->reloc_ctl || fs_info->reloc_ctl =
=3D=3D rc);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->reloc_ctl =3D rc;
> >> +=C2=A0=C2=A0=C2=A0 rc->reloc_ctl_set =3D true;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->reloc_ctl_lock);
> >> +}
> >> +
> >> +static void set_reloc_control(struct reloc_control *rc)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D rc->extent_root-=
>fs_info;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->reloc_mutex);
> >> +=C2=A0=C2=A0=C2=A0 __set_reloc_control(rc);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->reloc_mutex);
> >> =C2=A0 }
> >> @@ -3524,18 +3539,137 @@ static void unset_reloc_control(struct=20
> >> reloc_control *rc)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->reloc_mutex);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->reloc_ctl_lock);
> >> -=C2=A0=C2=A0=C2=A0 fs_info->reloc_ctl =3D NULL;
> >> +=C2=A0=C2=A0=C2=A0 if (rc->reloc_ctl_set) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(fs_info->reloc_ctl =
=3D=3D rc);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->reloc_ctl =3D NUL=
L;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->reloc_ctl_set =3D fals=
e;
> >> +=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(fs_info->reloc_ctl =
!=3D rc);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->reloc_ctl_lock);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->reloc_mutex);
> >> =C2=A0 }
> >> +static void complete_relocation_setup(struct reloc_control *rc, int=
=20
> >> result)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(rc->setup_pending);
> >> +=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_result, result);
> >> +=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_pending, false);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_bg_reloc_setup_abort(rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0 put_reloc_control(rc);
> >> +}
> >> +
> >> +void btrfs_finish_relocation_setup(struct btrfs_transaction *trans)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
> >> +=C2=A0=C2=A0=C2=A0 struct reloc_control *rc;
> >> +=C2=A0=C2=A0=C2=A0 int ret;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 lockdep_assert_held(&fs_info->reloc_mutex);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 rc =3D trans->reloc_setup;
> >> +=C2=A0=C2=A0=C2=A0 trans->reloc_setup =3D NULL;
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 if (!rc)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_bg_reloc_setup_finish(rc->block_grou=
p);
> >> +=C2=A0=C2=A0=C2=A0 if (!ret) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->block_group=
_ro, true);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __set_reloc_control(rc);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0 complete_relocation_setup(rc, ret);
> >> +}
> >> +
> >> +void btrfs_abort_relocation_setup(struct btrfs_transaction *trans,=20
> >> int error)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
> >> +=C2=A0=C2=A0=C2=A0 struct reloc_control *rc;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 rc =3D trans->reloc_setup;
> >> +=C2=A0=C2=A0=C2=A0 trans->reloc_setup =3D NULL;
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 if (!rc)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 complete_relocation_setup(rc, error ?: -EIO);
> >> +}
> >> +
> >> +static int bind_relocation_setup(struct btrfs_trans_handle *trans,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct reloc_control *rc,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_transaction **transaction)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_transaction *cur_trans =3D trans->tra=
nsaction;
> >> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->ro_block_group_mutex);
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 if (TRANS_ABORTED(cur_trans)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D cur_trans->aborted;
> >> +=C2=A0=C2=A0=C2=A0 } else if (cur_trans !=3D fs_info->running_transac=
tion ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_tran=
s->state !=3D TRANS_STATE_RUNNING ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 test_bit=
(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EAGAIN;
> >> +=C2=A0=C2=A0=C2=A0 } else if (cur_trans->reloc_setup) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EBUSY;
> >> +=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(rc->setup_pending);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_resul=
t, -EINPROGRESS);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_inc(&rc->refs);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_trans->reloc_setup =3D=
 rc;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_inc(&cur_trans->u=
se_count);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *transaction =3D cur_trans;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->ro_block_group_mutex);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 return ret;
> >> +}
> >> +
> >> +static int reconcile_relocation_setup(struct btrfs_transaction *trans,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct reloc_cont=
rol *rc,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int commit_ret)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
> >> +=C2=A0=C2=A0=C2=A0 bool cancel =3D false;
> >> +=C2=A0=C2=A0=C2=A0 bool wait =3D false;
> >> +=C2=A0=C2=A0=C2=A0 int setup_ret;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 spin_lock(&fs_info->trans_lock);
> >> +=C2=A0=C2=A0=C2=A0 if (trans->reloc_setup =3D=3D rc &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans->state < TRANS_STATE=
_COMMIT_PREP) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans->reloc_setup =3D NUL=
L;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cancel =3D true;
> >> +=C2=A0=C2=A0=C2=A0 } else if (READ_ONCE(rc->setup_result) =3D=3D -EIN=
PROGRESS) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait =3D true;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0 spin_unlock(&fs_info->trans_lock);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (cancel)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 complete_relocation_setup(=
rc, commit_ret ?: -EIO);
> >> +=C2=A0=C2=A0=C2=A0 else if (wait)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_event(trans->commit_w=
ait,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 READ_ONCE(trans->state) >=3D TRANS_STATE_COMPLETED);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 setup_ret =3D READ_ONCE(rc->setup_result);
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(setup_ret !=3D -EINPROGRESS);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_put_transaction(trans);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 return commit_ret ?: setup_ret;
> >> +}
> >> +
> >> =C2=A0 static noinline_for_stack
> >> =C2=A0 int prepare_to_relocate(struct reloc_control *rc)
> >> =C2=A0 {
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D rc->extent_root-=
>fs_info;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
> >> +=C2=A0=C2=A0=C2=A0 struct btrfs_transaction *transaction =3D NULL;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >> -=C2=A0=C2=A0=C2=A0 rc->block_rsv =3D btrfs_alloc_block_rsv(rc->extent=
_root->fs_info,
> >> +=C2=A0=C2=A0=C2=A0 rc->block_rsv =3D btrfs_alloc_block_rsv(fs_info,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_RSV_TEMP);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc->block_rsv)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
> >> @@ -3546,32 +3680,93 @@ int prepare_to_relocate(struct reloc_control *=
rc)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->nodes_relocated =3D 0;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->merging_rsv_size =3D 0;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->reserved_bytes =3D 0;
> >> -=C2=A0=C2=A0=C2=A0 rc->block_rsv->size =3D rc->extent_root->fs_info->=
nodesize *
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 RELOCATION_RESERVED_NODES;
> >> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_block_rsv_refill(rc->extent_root->fs=
_info,
> >> +=C2=A0=C2=A0=C2=A0 rc->block_rsv->size =3D fs_info->nodesize * RELOCA=
TION_RESERVED_NODES;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (!rc->fenced_setup) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_block_rsv_re=
fill(fs_info,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 rc->block_rsv, rc->block_rsv->size,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 BTRFS_RESERVE_FLUSH_ALL);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->create_reloc_tree =3D =
true;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_reloc_control(rc);
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =3D btrfs_join_trans=
action(rc->extent_root);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 un=
set_reloc_control(rc);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * The extent tree is not a ref-cow tree and has no reloc
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * root to clean up. Callers free the block reserve.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn PTR_ERR(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_commit_trans=
action(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 un=
set_reloc_control(rc);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +
> >> +=C2=A0=C2=A0=C2=A0 if (!rc->setup_pending) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_bg_reloc_set=
up_start(rc->block_group,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 rc->block_group_ro);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_pendi=
ng, true);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->block_group=
_ro, false);
> >> +=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(!rc->block_group_ro=
);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +
> >> +=C2=A0=C2=A0=C2=A0 btrfs_wait_block_group_reservations(rc->block_grou=
p);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_wait_nocow_writers(rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->blo=
ck_group);
> >> +
> >> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_block_rsv_refill(fs_info,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->block_r=
sv, rc->block_rsv->size,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_RESER=
VE_FLUSH_ALL);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto abort_setup;
> >> +=C2=A0=C2=A0=C2=A0 /* The transaction tail publishes reloc_ctl with t=
he new commit=20
> >> roots. */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->create_reloc_tree =3D true;
> >> -=C2=A0=C2=A0=C2=A0 set_reloc_control(rc);
> >> +=C2=A0=C2=A0=C2=A0 for (;;) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
> >> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_join_transaction(rc->extent_root);
> >> -=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unset_reloc_control(rc);
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * extent tree is not=
 a ref_cow tree and has no reloc_root to
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * cleanup.=C2=A0 And=
 callers are responsible to free the above
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * block rsv.
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR_ERR(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =3D btrfs_join_trans=
action(rc->extent_root);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D PTR_ERR(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to abort_setup;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D trans->transid;
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D bind_relocation_se=
tup(trans, rc, &transaction);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EAGAIN) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_end_transaction(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_wait_for_commit(fs_info, transid);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto abort_setup;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
ntinue;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_end_transaction(trans);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to abort_setup;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_commit_transaction(trans);
> >> -=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0 ret =3D reconcile_relocation_setup(transaction, rc=
, ret);
> >> +=C2=A0=C2=A0=C2=A0 if (ret && rc->reloc_ctl_set)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unset_reloc_con=
trol(rc);
> >> +=C2=A0=C2=A0=C2=A0 return ret;
> >> +abort_setup:
> >> +=C2=A0=C2=A0=C2=A0 ASSERT(rc->setup_pending);
> >> +=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_result, ret);
> >> +=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_pending, false);
> >> +=C2=A0=C2=A0=C2=A0 btrfs_bg_reloc_setup_abort(rc->block_group);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0 }
> >> @@ -3937,6 +4132,14 @@ static const char *stage_to_string(enum=20
> >> reloc_stage stage)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return "unknown";
> >> =C2=A0 }
> >> +bool btrfs_relocation_uses_fenced_setup(const struct=20
> >> btrfs_block_group *bg)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 const u64 mixed =3D BTRFS_BLOCK_GROUP_DATA |=20
> >> BTRFS_BLOCK_GROUP_METADATA;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 return (bg->flags & mixed) =3D=3D mixed && !btrfs_=
is_zoned(bg-=20
> >> >fs_info) &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !should_=
relocate_using_remap_tree(bg);
> >> +}
> >> +
> >> =C2=A0 static int add_remap_tree_entries(struct btrfs_trans_handle *tr=
ans,=20
> >> struct btrfs_path *path,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key *entries, un=
signed int num_entries)
> >> =C2=A0 {
> >> @@ -5404,7 +5607,6 @@ int btrfs_relocate_block_group(struct=20
> >> btrfs_fs_info *fs_info, u64 group_start,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_path *path =3D NULL;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >> -=C2=A0=C2=A0=C2=A0 bool bg_is_ro =3D false;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!extent_root)) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_in=
fo,
> >> @@ -5455,15 +5657,24 @@ int btrfs_relocate_block_group(struct=20
> >> btrfs_fs_info *fs_info, u64 group_start,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->extent_root =3D extent_root;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Block group ref now owned by rc, put=
_reloc_control() will=20
> >> drop it. */
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->block_group =3D bg;
> >> +=C2=A0=C2=A0=C2=A0 rc->fenced_setup =3D btrfs_relocation_uses_fenced_=
setup(bg);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D reloc_chunk_start(fs_info);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_put_rc;
> >> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_inc_block_group_ro(rc->block_group, =
true);
> >> -=C2=A0=C2=A0=C2=A0 if (ret)
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> >> -=C2=A0=C2=A0=C2=A0 bg_is_ro =3D true;
> >> +=C2=A0=C2=A0=C2=A0 if (rc->fenced_setup) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Keep non-metadata write=
rs out until the setup tail marks=20
> >> RO. */
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_bg_reloc_set=
up_start(rc->block_group, false);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_pendi=
ng, true);
> >> +=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_inc_block_gr=
oup_ro(rc->block_group, true);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->block_group_ro =3D tru=
e;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!path) {
> >> @@ -5494,12 +5705,14 @@ int btrfs_relocate_block_group(struct=20
> >> btrfs_fs_info *fs_info, u64 group_start,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (verbose)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 describe_reloca=
tion(rc->block_group);
> >> -=C2=A0=C2=A0=C2=A0 btrfs_wait_block_group_reservations(rc->block_grou=
p);
> >> -=C2=A0=C2=A0=C2=A0 btrfs_wait_nocow_writers(rc->block_group);
> >> -=C2=A0=C2=A0=C2=A0 btrfs_wait_ordered_roots(fs_info, U64_MAX, rc->blo=
ck_group);
> >> +=C2=A0=C2=A0=C2=A0 if (!rc->fenced_setup) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_wait_block_group_res=
ervations(rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_wait_nocow_writers(r=
c->block_group);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_wait_ordered_roots(f=
s_info, U64_MAX, rc->block_group);
> >> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_zone_finish(rc->block_group);
> >> -=C2=A0=C2=A0=C2=A0 WARN_ON(ret && ret !=3D -EAGAIN);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_zone_finish(=
rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(ret && ret !=3D -E=
AGAIN);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (should_relocate_using_remap_tree(bg=
)) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bg->remap_b=
ytes !=3D 0) {
> >> @@ -5521,8 +5734,15 @@ int btrfs_relocate_block_group(struct=20
> >> btrfs_fs_info *fs_info, u64 group_start,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0 out:
> >> -=C2=A0=C2=A0=C2=A0 if (ret && bg_is_ro)
> >> +=C2=A0=C2=A0=C2=A0 if (rc->setup_pending) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(ret);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(rc->setup_pendi=
ng, false);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_bg_reloc_setup_abort=
(rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0 }
> >> +=C2=A0=C2=A0=C2=A0 if (ret && rc->block_group_ro) {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_dec_block=
_group_ro(rc->block_group);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc->block_group_ro =3D fal=
se;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!btrfs_fs_incompat(fs_info, REMAP_T=
REE))
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iput(rc->data_i=
node);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_free_path(path);
> >> diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
> >> index bb7a86e7dbe3..210d0bbd7d48 100644
> >> --- a/fs/btrfs/relocation.h
> >> +++ b/fs/btrfs/relocation.h
> >> @@ -11,6 +11,7 @@ struct btrfs_root;
> >> =C2=A0 struct btrfs_trans_handle;
> >> =C2=A0 struct btrfs_ordered_extent;
> >> =C2=A0 struct btrfs_pending_snapshot;
> >> +struct btrfs_transaction;
> >> =C2=A0 static inline bool should_relocate_using_remap_tree(const struc=
t=20
> >> btrfs_block_group *bg)
> >> =C2=A0 {
> >> @@ -25,6 +26,9 @@ static inline bool=20
> >> should_relocate_using_remap_tree(const struct btrfs_block_gro
> >> =C2=A0 int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u=
64=20
> >> group_start,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool verbose);
> >> +bool btrfs_relocation_uses_fenced_setup(const struct=20
> >> btrfs_block_group *bg);
> >> +void btrfs_finish_relocation_setup(struct btrfs_transaction *trans);
> >> +void btrfs_abort_relocation_setup(struct btrfs_transaction *trans,=20
> >> int error);
> >> =C2=A0 int btrfs_init_reloc_root(struct btrfs_trans_handle *trans, str=
uct=20
> >> btrfs_root *root);
> >> =C2=A0 int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root);
> >> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> >> index 8f9419728100..97556bdfdead 100644
> >> --- a/fs/btrfs/transaction.c
> >> +++ b/fs/btrfs/transaction.c
> >> @@ -173,6 +173,7 @@ void btrfs_put_transaction(struct=20
> >> btrfs_transaction *transaction)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_put_block_group(cache);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(!list_e=
mpty(&transaction->dev_update_list));
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(transaction->reloc=
_setup);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(transacti=
on);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0 }
> >> @@ -379,6 +380,7 @@ static noinline int join_transaction(struct=20
> >> btrfs_fs_info *fs_info,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&cur_trans->dev_update_l=
ist);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&cur_trans->switch_commi=
ts);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&cur_trans->dirty_bgs);
> >> +=C2=A0=C2=A0=C2=A0 cur_trans->reloc_setup =3D NULL;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&cur_trans->io_bgs);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&cur_trans->dropped_root=
s);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&cur_trans->cache_write_mute=
x);
> >> @@ -2552,6 +2554,8 @@ int btrfs_commit_transaction(struct=20
> >> btrfs_trans_handle *trans)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->=
flags);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_trans_release_chunk_metadata(tran=
s);
> >> +=C2=A0=C2=A0=C2=A0 /* Resolve the relocation setup before transaction=
 N+1 can start. */
> >> +=C2=A0=C2=A0=C2=A0 btrfs_finish_relocation_setup(cur_trans);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Before changing the transaction=
 state to=20
> >> TRANS_STATE_UNBLOCKED and
> >> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> >> index 5e4b1106fd90..bbf3c2b78ce1 100644
> >> --- a/fs/btrfs/transaction.h
> >> +++ b/fs/btrfs/transaction.h
> >> @@ -23,6 +23,7 @@ struct btrfs_fs_info;
> >> =C2=A0 struct btrfs_root_item;
> >> =C2=A0 struct btrfs_root;
> >> =C2=A0 struct btrfs_path;
> >> +struct reloc_control;
> >> =C2=A0 /*
> >> =C2=A0=C2=A0 * Signal that a direct IO write is in progress, to avoid =
deadlock=20
> >> for sync
> >> @@ -77,6 +78,8 @@ struct btrfs_transaction {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head dev_update_list;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head switch_commits;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head dirty_bgs;
> >> +=C2=A0=C2=A0=C2=A0 /* Protected by fs_info->trans_lock. */
> >> +=C2=A0=C2=A0=C2=A0 struct reloc_control *reloc_setup;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * There is no explicit lock which=
 protects io_bgs, rather its
> >>
> >> base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
> >=20
> >=20
>=20
