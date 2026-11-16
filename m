Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794843159;
	b=x0NSpCKsqh8IRqHu4/f0xAbs7b1g5sx2TPZxLgVLPkuYBANHDU4kzeB/MifAH/crlJVD
	 vtriXCv6wus4k3EFNJ0behgUP1SP9uT0WjpDvUCxd0PYijs4P2N4DSc9PHwTZ05tySy05
	 6JiIgBgGX5infQ8caMKVy1aPOW56u7pZ+MmEU2ED00elF3yDKnC3PVDlcval19rWHASvS
	 W9ad8FQYGpmVZ5EznIqmofn5TZcseHwb0owHFkDye6i6eulRx4GKYLNXme40uJbb712GH
	 XgQN8EoCJDPOBinuLKvLTchWYgFCTfONJ5r8AFYwvTbrZobN1+ShUp4n0BGPqCnkSSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794843159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
	b=e1CmmcmTxVpjmDTLl5GK8q9Is2HfyGfq+qFXLCsr+TYcccZ/IH0bJTqcnz+ysk+Ot5BO
	 0DUQ9pEAMITThNUs1iOA8jBtnJD01efsi4NoRuy5Aul8WOIt2jdInJHZAWDcEossgs2e1
	 1hDXne5KoCucxhFuWxRxB9hDYsCLdNbxb/JZuXLBIt62mbYmVdL0dFEtf3p13+wICk0PT
	 n9K9mX5Hi3gI+DtZ2Nh+BVE6+dAff73OensBWkarKn8YVenDjvY2pSFxYfbmvpoFVBliz
	 8nojUSXSsfnDMY4OKHRQqN1u4ywo44zk1i1POvmKUtbIvQBNIK9/NBmgGgWLAFZphcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJiYISSE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B07606A323
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 15:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0B07606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJiYISSE
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91eb449364cso54458806d6.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 07:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794843158; cv=none;
        d=google.com; s=arc-20260327;
        b=d0Piiz/gQLTTBD1zFWBVUjFoVQ5TMS0rcXkNvY31Z0mB8Q5asivejnM/ViKA7udjx6
         YontnSWI2DyeHmADoZ16qdkg89xJl3+6s83qwPvyi7fMHO8Ld/3xsqbd6edho+7zMgLz
         MQKiCcXtS2MNQ8rCf2hyGxjEfGGk0yVJ1BIfXTEBPX8RUh8dMHhZ5pTPwg9vF8dZxz6s
         vWQxmKGlKJ/bgWH7/6XcQxP7BCRjhf/iz7T5Fb7nwNHyw4FsqwbT5i4QarHrmpoE6kUJ
         UTovNry3DbaodZErAYGg703inerrvhWZbMjtDF7lBJZHYfv9wTgtSBLJB1z3IXa+bSpj
         OK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        fh=/2b45s7nlwFageWJU0cAbd2POIUeN71GraIEsBgXNMQ=;
        b=aeE78waGy18E/gGLsFYYRzE1XY7N1pnuJEVm4Avz8h753w2IPhwnOTbsgpqe2WU6LY
         IAerIFfQwioJOZJpaD2okuDvb31Gt2cR+qtkK4LwVwzNRiw0H/l8w8FXyhQoTWX1qBQe
         giPR0tJ4RwBOHfy0x4FWtO9VpzWNbLc+BOmMNA0ZepAKfZ3xvBKyY3XIGfAdIoFv2/m5
         Xlv1kxKY+7kAdAUymsyN3vxu/UQPScb79/OoXDaeLXfNy0riveAohZBNmdljWOtu9fa7
         iKssRm3iUijxe0HWZNWzR/62OF2+cy0QWiE3vOnA2tGlP9oDLDk0lTHNGy0+TMssqyNX
         /+PA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794843158; x=1795447958; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        b=vJiYISSEW85hJMCPpfsyCN3ZkSJKg0MWSYEXXGl1KGF8rw9JNmPK3TazqOtdRKHN5o
         LVaxVKgv8fFDR6iFvvanbAkKpFTnsG/f17IrYDvhp0N3oOsyOAj1D0EII5U1fMwXWvw+
         cFO2hOKT6kOyZ/buLAbuFZBU5eAHCZd4Pnk8mGb2QXHKBjXX4osgIvYSLSoq3HHBYKQU
         q2LSf2rGBAgADwC6pg/0gLDdyHv37OZ285IfJ7soH8NiE6Ij5SThvWgN91odFNR6dr9J
         Z7T8RJ+4EsCLA1Il9n85LOTVDE7kgahkDvvJ66NAUujuut7iVbpynvNz5r/zT8hXmbYp
         hjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794843158; x=1795447958;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        b=D4HD5BUt4x5ApYbQfgVk/5AEL7dbyssG6S1bsnufsXJJkLzGxlkscShsir/th16SBO
         Mx57RDX+38du0NelpbcM+ia77LnA6EX32E6KMZeJZJrRhHrW2e2ZDcF82RCncslIsJ+M
         D+HOXP2b/pE6Y/fx5p1k5prBJ5cr4zXB7tWMtJHPQlLoA+ZZ2iniHsdGmdJzgEMLULL0
         BGGS7B8OOXXZxHhv+rqQzGV36LfVgE78rGNmPvHAh4KNRNjr8H+qQflNRTX9e3ZVFnns
         uRw7HC3WfHkJ784ERtk4NgjXQmWiDeSQ5HjNz5eXmTnT8p+00Kr1Ph2yluVBDgq7Aovb
         8Rlg==
X-Gm-Message-State: APuU4Z8ORtkudNbTcpEVVoh8jYDsXva2p7ktdF15xOZSjJYk2AJCeGzW
	OhFrnbwqs88e4wC7zkG4U3prCDFY0DJ90r8GVlL9ZAnKrj1F/GqldDpzXWdHag4AhTmPrBo9OY+
	eQFeJFV7Vtvx9WPVOxgPuxNnuIUTEs295Po+B0F7P4g==
X-Gm-Gg: AZFdTZcmH52pnxwlvjmsL14pInSTx9EJzJA8aAuCJFABBf2mhQl8+0QAJk6bHBiONoK
	TtxiZH7hOHxLTpWZ/SrGul02Sjw6Q5Tqm3ALyLV0kvEEp2yqaPZNpmvqNzaX2C6gVzWj/Ro/Mh4
	OP2IggMbA3/5Aynpw2VJ5Iz9SLDeO7glsOaqXeYE4MLeLsvyVUnQzVZuVSuwPK7OHZmzkmkoyud
	jLHRsqP8ndQJDpZ7UPGu9PVgZC3miGYn47dVhcLI/GcR0CLK7gAiziiwYTBn32iqHpuJfQQIrb6
	Jy6MOiAUGYya9Tb/f/YQqQ/ktaMUqJegXa0Xvme6vqSMYJ2wy6ohyZxKLZ7k1tqWzphpoKqtpb0
	zr4V3eOeGoc0Jxc0LIA71LZwiumavodxxlXwHnsKp9q63oHhG6+xSB4g7K8V/pU4O3YhU43rmSw
	FjYQc=
X-Received: by 2002:a05:6214:c6f:b0:91c:133d:4916 with SMTP id
 6a1803df08f44-91f24258d3bmr175963246d6.57.1794843157790; Mon, 16 Nov 2026
 07:32:37 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112134703.38510-1-nondet@yandex.ru> <20261112134703.38510-2-nondet@yandex.ru>
 <avmLAy52vfyJ5qze@hungrycats.org>
In-Reply-To: <avmLAy52vfyJ5qze@hungrycats.org>
From: Alexey Kuznetsov <kuznetsov.alexey@gmail.com>
Date: Mon, 16 Nov 2026 15:31:59 +0000
X-Gm-Features: Aa3M54oeRpvY83d0nLazjOVqW7eXFFClTJV0uMrGDZK8xguOz0qojD8xIBRH0QU
Message-ID: <CAO1Zr+q5hhK5oPJtQu8v3oh=-AfB9FuPF2VQA=zpSGA0afB-FQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] btrfs: track physical bad extents, fast-fail,
 persist, and relocate
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Zygo,

Thanks for the detailed review. It changed the design, not just the patch.

I agree with the core point: physical bad-sector handling belongs below the
filesystem. A drive with spare sectors already does the useful part in
firmware: the filesystem sees EIO or a checksum mismatch, retries another
copy, and rewrites the good data to the failed LBA. That rewrite is what makes
the drive move the sector to a spare. We only need a block-layer replacement
when the drive can no longer remap, because the spares are exhausted or the
firmware refuses.

I also accept the consequences you spelled out: the remap unit has to be the
lower device's logical block size; reserve allocations must never move; and
the table has to be crash-consistent with the data, with FLUSH/FUA committing
table changes and two copies protecting the metadata. btrfs should not
intercept physical I/O for this.

Verified defects
----------------

I checked each point against 6.12 and I am not disputing any of them:

- the write redirect used the chunk/map length, not the bio length;
- repair writes went through the redirect as well;
- fast-fail after a split dropped the remainder;
- fast-fail inflated read_io_errs without doing I/O;
- device replace reused the old devid, so persisted ranges followed it;
- the incompat bit was cleared when one device's list emptied, not when the
  filesystem had no ranges left;
- the mirror-collapse test could pass from the page cache;
- dmq renumbered reserve offsets on every rebuild;
- dmq reloaded the table and only then installed the ranges, leaving a window
  with no remaps.

The last two are already fixed in the userspace side. The map schema now
stores a per-range reserve_start and the allocator cursor; reconciliation
keeps existing offsets and only allocates new gaps. Live updates diff the
target's range list and send incremental add_bad/remove_bad messages, so a
range-only change does not reload the table at all. Geometry changes are
refused while the mapped device is mounted. The userspace suite covers
add-below, remove-middle, idempotent re-apply, split boundaries,
poison-to-redirect, and reserve exhaustion.

Status of the btrfs patch
-------------------------

The btrfs patch is withdrawn from upstream consideration and kept as an
experiment in the branch. I will not resend it and I am not preparing a
btrfs v2. Scrub reporting and targeted relocation may still be useful, but as
filesystem features that feed the block layer, not as I/O interception.

Proposed dm-first staging
-------------------------

I am not claiming crash-safe redirect yet. For a first submission I would
like the target to do detection, keep a pending list, and poison confirmed
ranges (return EIO, never stale or zero data). The volatile table would be
restored by userspace before mount, but nothing would move data to a reserve,
so no acknowledged write can outlive a lost mapping. Redirect would arrive
with the persistent log: a small self-checksummed area at the end of the
device, two copies, a generation number, and the mapping committed before the
remapped write is reported durable.

Does that split make sense as a first submission, or would you rather see
redirect and the persistent table in one series?

Two smaller decisions:

- Geometry. I plan to require the lower device to be a partition by default.
  Whole-disk ownership, including LBA 0, becomes an explicit mode with a
  documented recovery path (initramfs or rescue media), because the target
  has to own the partition table and the boot loader's sectors too. Is the
  partition requirement reasonable, or is whole-disk the more useful default?
- Reserve. User-specified size with a documented default, not a hardcoded
  constant; new defects take the next free block and existing mappings never
  move. Any preference on the default or on whether the pool may grow?

I am rejecting zoned-device support for v1.

I will post the dm design and the on-disk format as a separate RFC once the
format and crash-ordering rules are written down. If you are willing to look
at the format before there is code, that is the review that would save the
most time.

Thanks again,
Alexey
