Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD426299
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773370184; cv=pass; b=Z/z4+0BgX697u5mFocyulYdyQHQe5t0iGx1+DYCNvFpvbfjBp+vI6PBLtBqrLHU70TjX720aPjKuA2cD05oUBobaBNaxnPBS7yGSWVBVeM2/OK7Fsk2FxgzbJtmT1yIslecUk0DvOq0HUs0fvqajf9Mhkhfjr3C340QVh1aixQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773370184; c=relaxed/simple;
	bh=2nl6Q1hAD/NF4AgH7AUp+8dC+dI+oJz0xmvRpiUcjpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElUEqvWTgI1ZXjOTDYHA5FDNXxVuxi7Ft6BqYTc5KeV9oGU9jKWSN5deMNM97sa/yfvoNKPi3i3Omc/R0BkfcgNcikbNS723G+MlhLnrhaUfCszjux2DIrKgqw8doRuxFRaZQUNcV1KWjLXct4pdxl7isqgKnduzhyw69mLqdpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXGpWvaa; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXGpWvaa"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-663a60768f2so1811801a12.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 19:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773370181; cv=none;
        d=google.com; s=arc-20240605;
        b=F44bt8HJVPJscIt7I70hNCXKU8CXshbTBxMF+6p4Wod4+wJvFUhzZt1EgLKK1TXW8k
         Nq7UnlPLqVsdvrazJ5UEmK/L8c28OFHC2H+CzNYgXkzUVjqKJIRaYQgVuwJYioAKvGoP
         j4BckpgT3wMdJqzxcpDL/gzYggWVrZFN6RgzCtcDIBWS4AMOdpHxPW0fcGpL79W2cFN4
         dmMCsME+24r3pV5wgMDsh5gCqLe3tGq0HEuH1A4qCCyCFYa2bBCOzMI5ms4G+OnXpYHe
         lGo8Dsfq8yXeuyO1a2mwJh4ln7grZvbCFP7t8iSi2tTTOCU0UU5CHOrrfvWQHA6IySZ1
         gRLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r86hWZiRENffSA3Lk94ABHfCxhUdSSg3UrcQ6cLP5Ik=;
        fh=OOLt7MUUPfSB78avQARkYtUbX4+LFFu0cUMGUD/Yvoo=;
        b=EILeaPdJtxFWZUD32aP2y6rrXnxqQg7AhoGGWAOZoNy7SMHYj9icJoWFI3hxE4abYR
         7Th0yZgy91tKo+joU9Dk0bH9YTG490R44ztJbLgItH5sdzMZXwgpkSttQaKg4t78mGjv
         dPt9/xw0rpt5kvP0cteAnyJbsmrtMwgJnI+Dh3paHWBCMHORb6U0sbZsd/A0yUvC/JOx
         513v7QA/qxy+dnFLNjutnxoMW8+zokJe21/T3v08j4EzR50hJG9JdXNy9oaZwJPOjsj0
         BFcl0GJ50G940v4ScaHj4LdfnYJpkY92uivRqty3agnZ0dIfPz2dFZaM40xpMecbwXe/
         h5UQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773370181; x=1773974981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r86hWZiRENffSA3Lk94ABHfCxhUdSSg3UrcQ6cLP5Ik=;
        b=dXGpWvaal/41N1hsQig3qpYJ0hYYnas85SR5LBAIGiN8GhGdcBlMyYL1HRUfa9HP6f
         5kEZNAnUr00khW3rJpr9xad/uzb4SUZD6+xGlbBer2ucd/hdSVYneqvoiMt84m0V4G3g
         qSG0c/VrZ0ZevE+JuQa6tQrgpeLrsQFV76MO1vSx7TascQFx7WPEnLy4ok0nHkKdLijM
         RBrGHWT/4gTsWVqtequepxI+hdYysqnAoADJosOujWLj/+k3T7CujlqDTz8Z6tZ1LELy
         b0wvni0Dq+yT/AkOf3QDKYzXZ+zB3Phh/hXRQTCUTE5p6/TR9WQnm1hwZKXkoAB2VNRk
         wsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773370181; x=1773974981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r86hWZiRENffSA3Lk94ABHfCxhUdSSg3UrcQ6cLP5Ik=;
        b=jjv3Ilzhlxof9mcW6axKKk4O0+l+8A4K+vw7+XWZY+yzu0ZWKf/EzuKUCWKWuF8yg3
         p8LIOoTKZVtpPxMWikz3J404+AkWZBjQPRT5JNNw+hDPBZDT/cksegfkwBThQMclJB8r
         yf9p5YScPaobgzqZNzVBp2Tb9qppCWLW92k5/NptGFaa66wcMvrPdPmzeC3b9pYcaUhM
         tt0iiWIhBaiGkA4H48tC08m9J4cdouAI8sRZTVFdenUDuycdq74VW00QXatmRM5IblRK
         jlHRMvW70MZNPCWbzbp6AgkucIlaFHlx6DL9fsWhHZLWhppcXJZqXZYsjqb1buQxt7oB
         pwMw==
X-Forwarded-Encrypted: i=1; AJvYcCUGN1cBlYP119+wnFrUUuob2+x0khhsgp3hqVFkNaKgXukZPgz9zSQzxF1ZUkEuhDG+dIstnMGW+19wQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbSRhmXGvi+FfPO7Hi+UhNgyaUuuqCNl+YwYzSbtt0L99A1S+k
	h79YUydJ2ZsuR7C6icWUqpAewwswQemA2eI5pRzume/nNtI9HXRqa9lE9c8clzlIT+idvqgJYsr
	dips0ON1sfFMaZ7VPrm6oGimZKS+a5qU=
X-Gm-Gg: ATEYQzzmDlVcwZba0F7qcbwv4NeB3SGVzTa9QJWQegmR5Evi3wZEj9mDbwG/U0HPJ+o
	Nz1V+s6B352CRq6ZKC+f7XNOPCPvsH67kjsh2dwbkweKSTTs0AjdEH+VzQUNw0ORGcWZxbptxkc
	iDqRhGAKWDqsGqiIMj0Fa31ITBdRI3RaNx4VELgGbhk4DOJdsKNvX1x8znVDSEFW5thwr6HToOb
	EsQY5dQXiJbmbA8Cg4nhqZOQQzjvZur+BIGa4X+iLx4+B8EzoSs9oHUP+NsxpCdC47H9ZXCOJjd
	eUeM3Ni9/Gdk2F85lccbYTR8lPoCHovBr++q0cKP0SCrUymXWRMtq3Y=
X-Received: by 2002:a17:907:94d4:b0:b97:464:9553 with SMTP id
 a640c23a62f3a-b97650d8e72mr106309066b.17.1773370180764; Thu, 12 Mar 2026
 19:49:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312102229.220570-1-gality369@gmail.com> <ac5058d0-ba4e-4de6-b231-64a29ee2d5e3@suse.com>
In-Reply-To: <ac5058d0-ba4e-4de6-b231-64a29ee2d5e3@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Fri, 13 Mar 2026 10:49:29 +0800
X-Gm-Features: AaiRm531rVJ_2xHaAm0NHTetiWgLQdV_9Auq70c0Sq-wIfwHjIrPtOP0PGgjGBc
Message-ID: <CAOmEq9U14a=pwN_dw2M70gfujhMKki434cfmegoxcyUpkYs5bQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: reject root with mismatched level between
 root_item and node header
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 5:29=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> Nope, we have btrfs_tree_parent_check structure, which has all the
> needed checks at read time.
>
> The point of using that other than doing it manually here is, if one
> mirror is bad, but the other mirror is good, then we can still grab the
> good copy, but checking it here means if we got the bad mirror first, we
> have no more chance.
>
> And during read of root-node, we have already passed the proper level
> into it.
>
> So the only possibility is, your fuzzing tool is modifying the memory
> after the read check.
>
> If so, it's impossible to fix.

Thanks for the review and for pointing this out.

I agree that btrfs_tree_parent_check is the intended read-time
verifier, but the crash path here relies on a cache-hit bypass where
that verification is not re-run.

My earlier description may have been misleading, or at least not clear
enough, so let me clarify the exact trigger path in more detail below.

Two different metadata blocks are involved:
- Block A: a root-tree leaf containing root_item for tree 265 (this
field is corrupted: root_item.level =3D 1)
  item 11 key (265 ROOT_ITEM 0) itemoff 13489 itemsize 439
      generation 4255 root_dirid 256 bytenr 18787663872 level 1 refs 1
      lastsnap 4214 byte_limit 0 bytes_used 16384 flags 0x0(none)
      uuid 4cc4bc58-9708-2848-a264-19b95269f104
      ctransid 13 otransid 13 stransid 0 rtransid 0
      ctime 1766050670.362764444 (2025-12-18 09:37:50)
      otime 1766050670.362000000 (2025-12-18 09:37:50)
      drop key (0 UNKNOWN.0 0) level 0

- Block B: the actual tree-265 root block at bytenr 18787663872
(header.level =3D 0, otherwise valid)
    item 57 key (18787663872 METADATA_ITEM 0) itemoff 14198 itemsize 33
      refs 1 gen 4255 flags TREE_BLOCK
      tree block skinny level 0
      tree block backref root 265

In relocate_tree_blocks phase 1 (get_tree_block_key), block B is read
with check.level =3D block->level =3D 0 (from extent-tree metadata for
that extent item).
This I/O path runs btrfs_validate_extent_buffer, and level check
passes (found 0, expected 0).
So block B becomes EXTENT_BUFFER_UPTODATE.

In phase 2 (build_backref_tree -> handle_indirect_tree_backref ->
btrfs_get_fs_root -> read_tree_root_path), level is taken from
root_item in block A via btrfs_root_level, so expected level becomes 1
(corrupt value).
Then read_tree_block is called for the same bytenr (block B), but now
it hits EXTENT_BUFFER_UPTODATE and returns from
read_extent_buffer_pages_nowait early.

On that cache-hit path, btrfs_validate_extent_buffer is not executed
again, so no level mismatch check occurs for expected=3D1 vs actual=3D0.

Because no read error is returned on cache hit, mirror retry logic is
never entered. So this is not a =E2=80=9Cbad mirror first, good mirror late=
r=E2=80=9D
case: there is no second mirror attempt because the read already
succeeded from cache.

read_tree_root_path then builds an inconsistent root object:
  - root->root_item.level =3D 1 (from block A)
  - root->node/commit_root level =3D 0 (from cached block B)

handle_indirect_tree_backref computes level =3D cur->level + 1 =3D 1,
searches commit_root (actual level 0), path->nodes[1] remains NULL,
and btrfs_node_blockptr(NULL, ...) crashes. So the issue is a
cross-block consistency gap at root construction time, not post-read
memory corruption by the fuzzer.

That is why the fix in read_tree_root_path (checking
btrfs_header_level(root->node) =3D=3D btrfs_root_level(&root->root_item))
is needed even with btrfs_tree_parent_check in place.

To clarify, our fuzzing tool does not perform any in-memory
modification during testing. In fact, this bug is not caused by memory
corruption at all; it is triggered entirely by corrupted on-disk
metadata together with a cache-hit path that skips re-validation of
the root block. I have also uploaded the reproduction script to
https://drive.google.com/drive/folders/1BPXcgVI4DLzDcufNyynOakKD4EKnfVCg.

To reproduce the issue:
1. Build the PoC program: gcc repro.c -o poc
2. Build the ublk helper program from the ublk codebase, which is
used to provide the runtime corruption capability:
g++ -std=3Dc++20 -fcoroutines -O2 -o standalone_replay \
standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
-I. -Iinclude -Itargets/include \
-L./lib/.libs -lublksrv -luring -lpthread
3. Attach the crafted image through ublk:
./standalone_replay add -t loop -f /path/to/image
4. Run the PoC: ./poc
This reliably reproduces the bug.

Thanks,
ZhengYuan Huang
