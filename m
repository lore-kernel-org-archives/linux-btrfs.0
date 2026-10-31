Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793427962;
	b=FybZAHG6oUfw//KZTI0gLuw7AbN8lJ3WEjH1WG5XhmcltysqMzpwRVImUFfDNXVglXpo
	 6b54oQiq5z/AK0p+jKuJmK56XEJcOJ2wU+p7l3GTrTg5YgcPqS90Mk+CfRrou4e3mTiy0
	 kOQUvQUFP6cWChOjwxkt8yMvH73NHss6WfRVHQH/tBXaMJ0F6K1A8MHOKatDq3AKjM6mN
	 vchAOK0r4Co+CFX+zz4BC0Au6TVezuwEAwM035wvux9e6NCNpaBzRCOAlDa6JO7+7D1tq
	 0EzluEayxlcSsKsXH0MXPRwpTTHs6hs8ieBTWmATNqqal36SAXgSgYxLV6cH3oq5KZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793427962;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=AYsdxtDJthB5ib0a7kKnP9nb3/+JQ3Un5A615Q9Q14Y=;
	b=YsunmBhDEVt9IrUsXOg8DLv1KoIVcIJ/loaDw1OEKswOcuocK3CIy4sFZfrEnDkYZwEU
	 FGebhnRrr7MEg75VIftcK3FPFms958hFLENMKmeoJE8hGlijWQZV8yNBD8VDiPwlkw5MQ
	 dB6vgnXuntrZ1LKH/XcI8a4OCpddh8ufb1NMN3y7ske8UpMPUv/CV+tUO5KpzBdusAHHR
	 SOY392uXLO5EQjpuUGtKRcGA7Dy3lyGN2tzp3ktWNDAlWeIqlY1UZf1NwF7P7nBP6MtHz
	 RJH2xYVNhe/fQJk1NW0FydslCX8h6E+uSvNAecSjmkAKm1qKVGskZNBFv+TsWOBr3og==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iGWJuMib;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0766C606A31A
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 06:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0766C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iGWJuMib
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c40e30c26a4so510980466b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 23:26:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793427960; cv=none;
        d=google.com; s=arc-20260327;
        b=kiIR6V7t1RaIZoiEaILvTG6TtX/j4StHRa3JnZ2YJYuFKhXgZdZ3/DippLJ8C1FyFA
         0Qad9I8YvvZnTgEvJ4aH0VyhiJZ4fzUBx9dnwchMUIcoNdmpiJSSCuEXa7w8DmeoJZaY
         YhmpROHgxJoxX/IdE7KT8G/3k055wNySVVed322TNH3mzniZ/BGxQP+1gAAAmUNxXJze
         CBLHvZ3GyNAOXmeJE6eDkxVY6BzA3SmBpb2X77AlEg782/YiJn+HylkmEEhcLpMTeNoc
         A0Vy+5L127E2a772pDdqyfzfywCsAkaCYD+nugzwPnftMakQ9S8JJnrAJrvEGQwuCDtD
         foWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=AYsdxtDJthB5ib0a7kKnP9nb3/+JQ3Un5A615Q9Q14Y=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=UTswAuThTCmHPnP1WEHgrVhoYJDUgNWmxZQLpeMWnUNoo82zK+qsZB0RxQ9Gqbu/Zm
         nUP3Yb1sL8iQQ4ojZasozzBRayKBW9hP3PLmcYioXTZhe0oJ0z687MNK45DRwMK6dINU
         gSMqWDQxtq/agq4YDUAXNvOSgkDVyTlxtRSKep+v6aAw17W+T+Jv9p1DOb6m0l9nQHA6
         bplBTIPDb9Lkzv3Dy1WeX8ZAcoN4FLHjtO27pBZRAgJ2Sk0eWByzlEtDrKq7ccEW5nc3
         rNUn0FVBfvOPsUVpIhB+dg57rNlz7jl4ojgHwlHE1j/opG1qRMYRuGobSf2Xg1iE9tk/
         lp9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793427960; x=1794032760; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AYsdxtDJthB5ib0a7kKnP9nb3/+JQ3Un5A615Q9Q14Y=;
        b=iGWJuMibJPBsN/o+YRMP11+Xq77MQbHi02aEi5VRKxs0vAc5x5TfuqV9J7XlmPwrBm
         3k4WPoaV9joDIjAm4JNb4oQ4u7Kfdtc6lNPZBwOwHdAMMhSbOi/WcikM1IdKWP893dY9
         a/W3H3MSUXe98ySFYjSAr6PS8ROqnvUAicCP3Vy4de4aBs40jUirNUPKs+kpI159jKfs
         OljzmhTD3T2wY1ea5/vT4HtK/qnLo3rajzvWNneUc23C25zRP4JHII7iOt+BxWILTxAS
         OAqA5l8NhR6khO8/nDGqJSpzvxHvQlgaXtqOk1k5qXevyW3jrwo3loaS5gxXp/vh3KpG
         NHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793427960; x=1794032760;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AYsdxtDJthB5ib0a7kKnP9nb3/+JQ3Un5A615Q9Q14Y=;
        b=MXzZmKswOMlhryS7AEoKZ1e7FpllxQb/FdC0ecCEBjUTRgnkoZZWWM62rB1kMxPTz1
         Ec2x01/lAQk1/QHRoKaukTub0AKzl0LZHUJEiMlppME+Ahx+gQ7/Y6XE2MfGGnwIt05Q
         FK9ofot5IJxhhnnZSWNyG8IlEKBD8ekRTVXHXVv+Cd75flOCAh6RQZ0Yt3YDxeoMdUI1
         mCWJcO6dESX59dsLOrOCdfd9DdfO0hde+s8cMCHbMhR1CjVq0VdOT4PExeIv2u7kbgTS
         +FkbdDhFjmU8X6VyKqCF++JMmbXU4Fu32J/zgnvvriRzq+NYRmMMjDoyGl+/JluGHSNb
         QEcg==
X-Gm-Message-State: AFq9FYKIMXVCOPP7oC2cBfawMBAeEdlgG5sRGl/oFXwXEjCGbdSvQQGe
	KnXXGVl2B6kShmlVBt09z0jgU+eAEkWtjsfXXNAU3IiyanzsTe/35dcSfGLrjpNCIswnf9gnLlr
	RN5/rRa3rjFBNLtJNOn2rxlRS2WsYAEQUa7e2
X-Gm-Gg: AYBFou2S6XtBQ79cKDJwr6pq5gDEpX0MU/dAVZHVHT8VsizcryWBmePO/20j/Jk7Ai9
	RdjLIUwgOOkIX5G9GsUOkiTSauHxPy11SNEhs2MXxlzMIIkoTAFlbkpzsSMwNGUZjwemY4+rzh4
	/2tUyp0IJ3ZS+YsCaEX3AnxvkWUfFzz13hYLC22f2WkXyty2xifpMK7sB16uYaPAhi2nuuPNgNw
	x+xMrZbfp9tQelLM/luYWQpjT3YKX+bcoHU9H9cJ3hJxGw7OMeRXKfamMYxT9wW5kisEkvDO1kH
	2VC9kTkH3xatdrWjOAA6xo45/Zt2ceJt9NGD8qxsCRNKZEafYt7hGReSH6o0B6CxeAgZxIFG2vl
	S+ZIlGlFUuHGyHfWE5HY6pjSGo0NB0vpxiuyK/8bX69um6R/0jhh5Jbi9zdglOqN+4WN2Hmsm+P
	akvT6pGyctMa1rOJJCfMk1yvkYJJuGPywP16EsCPBqCtArwXRBCiZDT1kzLUVvcwSvY6vRGfnG5
	/NTjngJKAabFVxFSYP2PGf1ZPHdn+N+CkvGCw==
X-Received: by 2002:a17:906:eec1:b0:c31:5918:86d1 with SMTP id
 a640c23a62f3a-c4ca7a6a5c2mr394332166b.10.1793427960018; Fri, 30 Oct 2026
 23:26:00 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Aaron Bohenick <bohenick@gmail.com>
Date: Sat, 31 Oct 2026 02:25:22 -0400
X-Gm-Features: AclHuK_nuye2XzuL2OD0T_7DvnHrSU8rxmW8bqAIU2XhUqxMkteGHsEOHxBqtwQ
Message-ID: <CAAhqjAK5mOJrgZqG-ZrgKt12Dm4AFJeapiFbBNpRv+qUns_d-A@mail.gmail.com>
Subject: Parent transid failures in extent/dev/free-space trees after lost
 writes; open_ctree -5, restore works - advice before repair?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I have a single-device Btrfs volume (25.45 TiB, 15.19 TiB used) that no
longer mounts after a series of unclean shutdowns. btrfs restore can read
almost everything, and file data verifies against torrent piece hashes, so
the damage looks confined to metadata. I would like advice on whether the
filesystem can be repaired before anything is written to it.

Setup
-----
- TerraMaster F4-424 Pro (TOS 7.0.1341), kernel 6.12.63+
- 4 x 14 TB HDD, md RAID6 (4/4, resync completed clean, no bitmap)
  -> LVM vg0/lv0 -> Btrfs. Profiles: data single, metadata DUP, system DUP
- Until the incident, lv0 had a dm-cache (lvmcache) on an NVMe in
  writethrough mode. The NVMe's array was last updated ~7 hours before the
  boot failures; after an OS reinstall the cache was no longer attached.
  NVMe SMART is clean.
- Features: compat_ro 0x7 (free space tree), incompat 0x361, no
  block-group-tree
- btrfs-progs 5.16.2 (vendor) and 7.1 (static release binary)

Superblock: generation 918517. All four backup roots are gens
918514-918517; all point to dev root 17014757720064 gen 917953.

Kernel mount (plain ro, ro,rescue=usebackuproot, ro,rescue=all)
------------------------------------------------------------------
parent transid verify failed on logical 26935296 mirror 1 wanted
917953 found 910413
parent transid verify failed on logical 13608045117440 mirror 1 wanted
918517 found 879195
parent transid verify failed on logical 13608045117440 mirror 2 wanted
918517 found 879195
parent transid verify failed on logical 15797806039040 mirror 1 wanted
917945 found 917909
parent transid verify failed on logical 15797806039040 mirror 2 wanted
917945 found 917909
failed to verify dev extents against chunks: -5 (plain ro)
failed to init dev_stats: -5 (rescue=all)
open_ctree failed: -5

15797806039040 is the DEV_STATS item's block in the dev tree.

btrfs check --readonly (7.1, also with -b)
------------------------------------------
parent transid verify failed on 12777307766784 wanted 918507 found 610497
parent transid verify failed on 12777308094464 wanted 918507 found 608008
parent transid verify failed on 12777309929472 wanted 918507 found 917901
ERROR: child eb corrupted: parent bytenr=13608033124352 item=939 parent level=1
       child bytenr=12777309929472 child level=1
ERROR: failed to read block groups: Input/output error
ERROR: cannot open file system

What works
----------
- btrfs restore -i reads 11 of 13 subvolumes (~208,000 files). Two
  subvolume roots are bad: 258 (child eb corrupted) and 260 ("root [260 0]
  level 0 does not match 2"). A raw scan found intact level-2 roots for
  both at gens 918513-918517, but their children are stale too.
- Some fs tree roots are stale in mirror 1 but good in mirror 2, which is
  why restore succeeds where dump-tree -t shows the wrong block.
- I restored sample files from 2023 through the day of the incident and
  verified 5,687/5,687 torrent pieces, so data extents look intact.

What I tried (on a dm-snapshot overlay only; origin is blockdev --setro)
-------------------------------------------------------------------------
- btrfs check --repair --init-extent-tree (7.1): "Creating a new extent
  tree", then repeated "unable to find ref byte nr ... parent 0 root 10"
  (free space tree blocks) and one for root 1, then "failed to commit
  transaction: Read-only file system" (transaction aborted).
- btrfs rescue clear-space-cache v2: fails to open (failed to read block
  groups).
(Progs was run in a private mount namespace exposing only the overlay, to
avoid it selecting the origin with the duplicate fsid.)

Questions
---------
1. Is there a sequence that can get past the stale extent tree / free
   space tree / dev tree blocks, e.g. dropping the free space tree root and
   the DEV_STATS item before --init-extent-tree, or rebuilding the dev tree
   from the chunk tree? I can test anything on the overlay first.
2. Does the pattern (blocks hundreds of thousands of generations stale in
   both DUP copies, plus mirror-1-only staleness elsewhere) point to lost
   writes below Btrfs, e.g. the dm-cache being detached?
3. If repair is not realistic, is btrfs restore the right way to copy out
   ~15 TiB, or is there a better option?

I can provide full dump-super -f output, dump-tree of the chunk/root/dev
trees, the restore logs, or try a btrfs-image if that is useful.

Thanks,
Aaron
