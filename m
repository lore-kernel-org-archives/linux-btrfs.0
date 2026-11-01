Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793555488;
	b=pyQhIGz35zLc3KgdAeLJoVdwFthr5/pplkxOCqx6zhux1jDmpIMdpqbjU3Hb9QAS1Ada
	 zs2rnrL8VpZ3+8C8Ls1E615anc/LKzBcLbK8Ryv0gDKLVdkaaDaQade+Lke8DSuKwUuKY
	 zmdOqEsj1QZj9/+x4ndZKMAXMLT9C/+C6ZvGFS7vjgxL7ZSdnYY2r3F3OONLyEmhLTCHj
	 c2k1Miz+dCY08z7O5oLslVCvH6b7bczz41+lSyny3Xk3If2sfyiBTYm5SV9sZy5ttgeLq
	 nqZkfL6FDhXQ/qNZpSvX+7mSK87FSiioEILEpac1kFLJ4bMlgsBQDpNXoF94u+VDt5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793555488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=zl1fIl+7FV4ZWuMW+PAm0oF9ePIX2ra02I20JxGd9yc=;
	b=XnQssbEWatPdFsTzG7sYI3d+sO22jMarQ+EIH7lVCUqh6y2KyNGQ/rZx7y33w3qsH3VY
	 F7H6WB00ZSR+6VRFJkYxV6qoRMz2jtRZTKqvioq8+mn810S06oSQGJGl+oWMvB8qEoU+K
	 vARX711Dc5aWEBVchhdXTReCHkpLplI/EMwoChqqCC3KrXHneEfMWkd05vBhbEWWfB72x
	 Unimgs90fkmMzPXnqFnrr5Q+Ov7cTp+qBVgdc9MGBvEWTqCaTf6X/xzR5Sja9WbKHY2L/
	 Y+nE07021miLyk0Ajgmk8IlTAQoQsBv3KG7RFvVXtBnnmRzdN5nMvCnEcN/nTHX4jGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="iZ04HX/e";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D293606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 17:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D293606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iZ04HX/e
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso4589672a12.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 09:51:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793555486; cv=none;
        d=google.com; s=arc-20260327;
        b=KlvRYdnCAwtC887u1YQBfIPeaYxRc4IouNlYC4Nh3058yEvwlNe8mPsu33nQDwvdIY
         b4JbCaVLp2MMrqHR1DJa8/5x+u7q4HGx9rH+O82LPhDQUALlxpbTXVU28S7MIm3jW73+
         nlvj+SUsiR25250wwIZJgVR46B6cvgUx8ekjxGhb+75TwzUamon4mwSEnVnqUogCHyye
         lzcvXm+508s88lGk2Kc6XZxHa1kjAPZVJHqlM1LNYkQdcMUe2l5hOEUaMJm2XfTwUHhu
         uMJYtCc2EUYUZqS8geBB1ClONLOi25y7uim4GuRUVQSug1/SRSmWA46hrrOKHUha0Q83
         DD8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zl1fIl+7FV4ZWuMW+PAm0oF9ePIX2ra02I20JxGd9yc=;
        fh=L86tz5PVGv5SLsfJa604pXoHsKf9HQIDvm2UhW00vIA=;
        b=WbpiZ27siwn4wJ5ZhDTiUYMSRkUzPdFGCFkP5O08gVG6ExSzbgCfqcIgB+tzmYjSO1
         V6DbgxSL57C/iVn4EB1nV+Zu2pfQzujdQvnuuO4JOO176hDA5fbQNgS8YowxnxPwI49J
         9QEYJvN6YWp5bFnirpWKG1D9kLBSI26gVCxAx1038evJsO6n15FxfAoR4veZIXG/Twnj
         kbhXlBZml5L4sIWwKcfEjN9AVkDL47joy73TRxLjP/2HPwRti1eiGtX734ulPFi52EXk
         cbqLFLgvsSqVx3MpRzg3tW2uHohh/ErQCcVlyD1Sumt1nz3Wliu1GpHjae3y94bi9/ZN
         gT7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793555486; x=1794160286; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zl1fIl+7FV4ZWuMW+PAm0oF9ePIX2ra02I20JxGd9yc=;
        b=iZ04HX/e5taGs/9HHCvDR42lZtdAclO1Bkp40rJTdB/C+oTm67KFjiawJWH3Ouq9+u
         C+12ntkxo9pFRvwIMrWPdoiZ7okeoCbMKwFKWgEQaH+De3aXBQgHTTJC8LKcK+yc4pHt
         L3UJUZSsRsSMH0s3PiN+Wado8lMHzroMGXy/WC/NDDnzzEmpZBzRfG0PL09ulBulHzVc
         sZT8jF/vQ1NZ6AHPU3i4evRgKpey6pCdtRdstpMiye+2hWpNOAkjmstGSA0V14k/vJrX
         xXd7FxUGOQHU1aJLEjPrgjCq4GX4nKQ3uXT2Y5N4XH3wHmvflE21IdzXyBoQ/VRN5WuC
         c3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793555486; x=1794160286;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zl1fIl+7FV4ZWuMW+PAm0oF9ePIX2ra02I20JxGd9yc=;
        b=kB20zcBSIRLx1JVBLjmSkY6GSjo3OxbKTwUME/Y71mjUikQ1UGf2ISkR/zTC4fz9ZT
         wyWhG7IiIG/r02hKAzh4+ejrdVcf7S6NywB/qJYsbBUgbF5XcbWG5v1CMvwHwwPy8/lo
         ApV5PgSxl3sO+r+8aRge7bTR+kvhI4BiR6U2vPjHcHrtC+qwFLf/6jS9JyjKBjLo4yD7
         lf1u7GRVWbppBKWL6pf2kP1ZCF2ImFMaRQLzXvcTrGx2YEyirShETmVJgoAbREiCvo5H
         N/EM2+suA4pleSwKDwlR5drRfgl0WutEZSzJY9cdkIpcm+6i9+Kb63pqcCkmysJkMVt8
         XOPg==
X-Gm-Message-State: APuU4Z+o0fvlvjD5sQC/nzPKGss4QlVLFxD3BPoIxsjCVyE3TKpKZD43
	Cdyq6wflUPF8BGSofEgYYn6GN0g5kaJ7SOuOkClKAPOnbwWH+n5YVhJ+v+Z2Ny6FlagH9vLjKCr
	WehfTQD5A6v2VAGHfvXT3AgwYWx0ItEM69c3F
X-Gm-Gg: AYBFou1zTrEGx7oUcWbI1Z0saufUsgZajKG+sBswqeTLYdDFj1eDJc3rUWeGTAzXykK
	1FVzRs9ROe2Bbv2vIZkPCbpaVRR7xfoOLQHp1Mvht8LxVIzNvETRcf4YAG3kXY6JoTg2oG4/YXU
	QvFAAsWqvV35LYvAmG6LoAjQsmnMqSbFOm4AK0xOhUSnsvpzubsApGEfThY6UezE7KV+L2Bv11t
	u0W0Ny1+W1sIzffucaN+XcZPWqoUpT4Q0VyAEg44NagjjX1MctkCAUBVtvXJ8+INC4dwUOy+nB2
	ntmlFsc6rAOU69hrcKp7098Lokq0E4GoQ8RjoqLMsMQUQm/cWhY5360kKJ4KlJK9ig5NHM86qdO
	V/sm/wVyePhdsF/YVyUgodFeXLa9KsWf/AbmfkEu8nDjzQzF1duPABjwAr5aHKCVzj9CTGJwWWD
	R/+l1ecewOnP/XCzdShW8u9xjP91kA/CrLDPN1Y7p0V2F7JGpTnx8/1rp1V8ZonSR/92qen2kr6
	Ryy8g8z/68fdeIqym5d6oZH2qLO+nObhTbpqA==
X-Received: by 2002:a05:6402:c4d3:20b0:6b3:cbdb:bd93 with SMTP id
 4fb4d7f45d1cf-6b4d49800b8mr3779497a12.29.1793555486101; Sun, 01 Nov 2026
 09:51:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAhqjAK5mOJrgZqG-ZrgKt12Dm4AFJeapiFbBNpRv+qUns_d-A@mail.gmail.com>
In-Reply-To: <CAAhqjAK5mOJrgZqG-ZrgKt12Dm4AFJeapiFbBNpRv+qUns_d-A@mail.gmail.com>
From: Aaron Bohenick <bohenick@gmail.com>
Date: Sun, 1 Nov 2026 12:50:49 -0500
X-Gm-Features: AclHuK-Qb1mTOwOB5XWKmezEa_FvJZmvYAsx-Jcbthu5-N5mRUj8EZpErMfWzgs
Message-ID: <CAAhqjALj6mq=wx43sshav-uOxei2nXeMu4nfmQmu_az7Nbig=g@mail.gmail.com>
Subject: Re: Parent transid failures in extent/dev/free-space trees after lost
 writes; open_ctree -5, restore works - advice before repair?
To: linux-btrfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Follow-up to my report below, with new findings that change the
question. Cc'ing dm-devel because this now looks like a dm-cache
(lvmcache) issue underneath Btrfs. Everything below was read-only; the
origin LV and the cache SSD are both blockdev --setro and nothing has
been written to either. The NAS vendor's (TerraMaster) support is also
involved.

Short version: the detached cache SSD holds the current, checksum-valid
copy of every Btrfs metadata block that is stale on the origin, but the
cache metadata marks every cached block clean (0 dirty), so a forced
uncache dropped them.

How the cache was detached
--------------------------
LVM metadata history on the origin PV (vg0 on md RAID6), times EDT:
- seqno 23, 2026-10-29 21:31:53: "lvconvert --uncache -y --force vg0/lv0"
- seqno 24, 2026-10-29 21:31:55: "vgreduce vg0 --removemissing"
The cache PV (an md RAID1 on one NVMe) was not assembled after a vendor
OS update/restart, and the vendor OS forced the uncache. Cache mode in
the LVM metadata: writethrough.

Cache metadata (cache_check passes on an image of the cmeta LV)
---------------------------------------------------------------
block_size=3D2048 sectors (1 MiB), nr_cache_blocks=3D953640, policy=3Dsmq,
hint_width=3D4; 953634 mappings, 0 dirty.

Damaged Btrfs blocks: origin copy vs cached copy
------------------------------------------------
64 KiB nodes read from the origin LV and from the cdata area on the SSD
(cache block N at cdata + N MiB). crc32c and bytenr checked for every
copy. Format gen/owner; both DUP copies agree unless noted.

logical wanted origin cached
26935296 917953 910413/3 (copy0) 917953/3
13608045117440 918517 879195/7 918517/8
15797806039040 917945 917909/2 917945/4 (dev tree)
12777307766784 918507 610497/258 918507/2 (extent tree)
12777308094464 918507 608008/258 918507/2 (extent tree)
12777309929472 918507 917901/7 lvl 1 918507/2 lvl 0
13607943929856 918513 604537/260 918513/258
13608042430464 918517 610816/258 918517/260 lvl 2 (subvol root)

Every cached copy has a valid checksum and exactly the generation Btrfs
expects. The origin copies are valid but much older blocks from other
trees. All 20 damaged copies (10 blocks x DUP) are inside cached origin
blocks, while overall only 51.4% of metadata blocks (23181/45056) and
5.8% of data blocks were cached. The cache also holds blocks from the
final transaction (918517), so it was in use until the end.

So for some hot metadata blocks, writes stopped reaching the origin
(some since around generation 604537, weeks to months earlier) while
reads were served from the cache, and the cache never considered those
blocks dirty.

Questions
---------
1. For dm-cache: is there a known way a writethrough cache can end up
   with cached blocks that are newer than the origin but marked clean?
   (Kernel 6.12.63+ on a TerraMaster F4-424 Pro, TOS 7.0.1341.)
2. Safest recovery: re-create the cache mapping by hand (origin lv0,
   cmeta, cdata, block size 2048, smq) over dm-snapshot overlays and
   test a read-only Btrfs mount; or copy the cached metadata blocks onto
   the origin after testing on an overlay? Anything to watch for, e.g.
   policy hints, or LVM auto-cleaning the outdated cache PV's metadata
   if its md/GPT labels are restored (they are currently erased, so LVM
   cannot see it)?
3. For Btrfs: if the cached versions are put back, is a full
   btrfs check --readonly plus scrub enough to trust the filesystem, or
   should I still plan to copy everything off and recreate it?

I can provide the cache_dump, the comparison script and output, the
LVM metadata text from both PVs and the 97 MiB cmeta/LVM image.

Thanks,
Aaron

On Sat, Oct 31, 2026 at 2:25=E2=80=AFAM Aaron Bohenick <bohenick@gmail.com>=
 wrote:
>
> Hi,
>
> I have a single-device Btrfs volume (25.45 TiB, 15.19 TiB used) that no
> longer mounts after a series of unclean shutdowns. btrfs restore can read
> almost everything, and file data verifies against torrent piece hashes, s=
o
> the damage looks confined to metadata. I would like advice on whether the
> filesystem can be repaired before anything is written to it.
>
> Setup
> -----
> - TerraMaster F4-424 Pro (TOS 7.0.1341), kernel 6.12.63+
> - 4 x 14 TB HDD, md RAID6 (4/4, resync completed clean, no bitmap)
>   -> LVM vg0/lv0 -> Btrfs. Profiles: data single, metadata DUP, system DU=
P
> - Until the incident, lv0 had a dm-cache (lvmcache) on an NVMe in
>   writethrough mode. The NVMe's array was last updated ~7 hours before th=
e
>   boot failures; after an OS reinstall the cache was no longer attached.
>   NVMe SMART is clean.
> - Features: compat_ro 0x7 (free space tree), incompat 0x361, no
>   block-group-tree
> - btrfs-progs 5.16.2 (vendor) and 7.1 (static release binary)
>
> Superblock: generation 918517. All four backup roots are gens
> 918514-918517; all point to dev root 17014757720064 gen 917953.
>
> Kernel mount (plain ro, ro,rescue=3Dusebackuproot, ro,rescue=3Dall)
> ------------------------------------------------------------------
> parent transid verify failed on logical 26935296 mirror 1 wanted
> 917953 found 910413
> parent transid verify failed on logical 13608045117440 mirror 1 wanted
> 918517 found 879195
> parent transid verify failed on logical 13608045117440 mirror 2 wanted
> 918517 found 879195
> parent transid verify failed on logical 15797806039040 mirror 1 wanted
> 917945 found 917909
> parent transid verify failed on logical 15797806039040 mirror 2 wanted
> 917945 found 917909
> failed to verify dev extents against chunks: -5 (plain ro)
> failed to init dev_stats: -5 (rescue=3Dall)
> open_ctree failed: -5
>
> 15797806039040 is the DEV_STATS item's block in the dev tree.
>
> btrfs check --readonly (7.1, also with -b)
> ------------------------------------------
> parent transid verify failed on 12777307766784 wanted 918507 found 610497
> parent transid verify failed on 12777308094464 wanted 918507 found 608008
> parent transid verify failed on 12777309929472 wanted 918507 found 917901
> ERROR: child eb corrupted: parent bytenr=3D13608033124352 item=3D939 pare=
nt level=3D1
>        child bytenr=3D12777309929472 child level=3D1
> ERROR: failed to read block groups: Input/output error
> ERROR: cannot open file system
>
> What works
> ----------
> - btrfs restore -i reads 11 of 13 subvolumes (~208,000 files). Two
>   subvolume roots are bad: 258 (child eb corrupted) and 260 ("root [260 0=
]
>   level 0 does not match 2"). A raw scan found intact level-2 roots for
>   both at gens 918513-918517, but their children are stale too.
> - Some fs tree roots are stale in mirror 1 but good in mirror 2, which is
>   why restore succeeds where dump-tree -t shows the wrong block.
> - I restored sample files from 2023 through the day of the incident and
>   verified 5,687/5,687 torrent pieces, so data extents look intact.
>
> What I tried (on a dm-snapshot overlay only; origin is blockdev --setro)
> -------------------------------------------------------------------------
> - btrfs check --repair --init-extent-tree (7.1): "Creating a new extent
>   tree", then repeated "unable to find ref byte nr ... parent 0 root 10"
>   (free space tree blocks) and one for root 1, then "failed to commit
>   transaction: Read-only file system" (transaction aborted).
> - btrfs rescue clear-space-cache v2: fails to open (failed to read block
>   groups).
> (Progs was run in a private mount namespace exposing only the overlay, to
> avoid it selecting the origin with the duplicate fsid.)
>
> Questions
> ---------
> 1. Is there a sequence that can get past the stale extent tree / free
>    space tree / dev tree blocks, e.g. dropping the free space tree root a=
nd
>    the DEV_STATS item before --init-extent-tree, or rebuilding the dev tr=
ee
>    from the chunk tree? I can test anything on the overlay first.
> 2. Does the pattern (blocks hundreds of thousands of generations stale in
>    both DUP copies, plus mirror-1-only staleness elsewhere) point to lost
>    writes below Btrfs, e.g. the dm-cache being detached?
> 3. If repair is not realistic, is btrfs restore the right way to copy out
>    ~15 TiB, or is there a better option?
>
> I can provide full dump-super -f output, dump-tree of the chunk/root/dev
> trees, the restore logs, or try a btrfs-image if that is useful.
>
> Thanks,
> Aaron
