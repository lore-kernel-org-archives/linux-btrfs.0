Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795069283;
	b=JlXjBaixsNSpbQU0sk4lcGCEtMvLcOcJhfJ/5fuuVENvkHEj3KXKLTp0KsA6IF8VA/C1
	 /QLHaloBbVyclV5+gAr0SL6m2Awv6enWCZYRk3pc7w6HX9pmTDgFJOA+bqZI/AKVQLLxD
	 RpgYqcPLoMM0DgSKxBdYztOOi0q9D7ZVUP7s2EoLxAiQJQH6spbygq2xxuH6TSZdXG+V+
	 WdkMXUPJB71uB3+3ukxcaI8CcprAxpo8Imm79wd7fwjsWUNJdU0obfgTfuOtKxDUIomPa
	 1WQ6qkRYQH+MCENPng6CeQFz9x8VCn1LW2oWiuV9DEwBvrjenJkBDEjaOTofdlAtA5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795069283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=dw4sEEscOzdXh0Zd2TjfgHcpr97CB+RHTHfHcH2OFEY=;
	b=kuehChKIKqOEWeD1UDppX60JOXf0rHf8MNd+hjR+/uVdf0pltn0kixHuptjqcpCcj2SY
	 AL5V69Hb8bGuEkTQHk5OY3onETAIGixpGgqlq4kllBa/y/kh5t54UhsLA1LsveQLlO28q
	 8TblXo7I9rOScTrWYXwcOTDUgrgZTuGzcQxuhWUcpXP43ZgUZaCZLEQvi8mcOgJvIc2wg
	 sQ5r5lev9Yy/ms2pr7WGFXI07dWgAWx+ytjr/633MyPXR8gippL/LRMKuPtqLV5nnSAv6
	 QcTxEzXOcvBNtYi+VfCW2vOHOqjKZU53BHd9XgIZRghrhmqA6eoBxOQ7KwEL9615MhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Lc2q2E6a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C985606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 06:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C985606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Lc2q2E6a
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-92107df3f13so17019766d6.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 22:21:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795069281; cv=none;
        d=google.com; s=arc-20260327;
        b=dBZGLzORx5VMQhcHwdcR1TvA3wfaMJ+b3zFNN7CQuwtp4PJiCqZFg+peUjQPYIKafR
         xYfTe2Em3FWi3ShW3BNtKXeieTh4/Mu0lPa8qdTqcUbk07J4mKfI6SqFvmuSFFXRv61F
         n2bwLam44qs0IJh0j2Dw+wnuKoIOa46k3ZN1pxW9v5U1XYQqu25YVWfBB00gJ9NfFZ9i
         z5QemLr6H9V80rKXnLKuGHvI96wao4Q3knOGtGpRKWaJvxTakuLkMupGIiczwbaOtits
         x+XGFHNVp0inrDa3ap5Jl5R8Q3ZIkEvjS7lTZveIehpbHarIQtSv3evns2993kUEWt/E
         W4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dw4sEEscOzdXh0Zd2TjfgHcpr97CB+RHTHfHcH2OFEY=;
        fh=SHyGiWLQjfFtntLQotqzM0HFKLLG9tQHX1CFuYwAzOY=;
        b=k7v8jjCcqa67YdAfUwZacVaS2eHuDoR+vQ74NrzrlxvaIHAjumooMnVgVwIQ0jL08u
         +b0ZVEqT+qvFnbAGj084/vkkPKw2paz57z6HuB9N13IiHQvTopoQGF/MR/BUjyVWMCgO
         3OAi8Y73MxfvTaPMbu818Nd9wkI/wCTTPdeMXMptM5H8PnQMuvjKIl7hgViNftBs6aGJ
         AtnUO8Z305Ycy1Ck7q/UaFSQJnphTex+1UhJRh+rS4CerLfQ995gzTb1wuNlixL16nfO
         +9cM9NvMYRLdCMw3TCbFoGbry8kDQo/Jexj/MWxYnfqJVxBKtLGjWIjhy6ZyKfvyn6+n
         wcuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795069281; x=1795674081; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dw4sEEscOzdXh0Zd2TjfgHcpr97CB+RHTHfHcH2OFEY=;
        b=Lc2q2E6aq/619ivYO6N3rLuPF4GGpBYfUThFCLnXePbxSRg8VO6GmEpvXmwK3IB1H0
         EdQBzDmWmk0W+i06F7oQcBQUc6Nb9R6sf9NyPovrLi7PJpo59YUGRLnVoEiFmfDJE1eD
         znQZ94clOnQt09sBYjkAIKoibCtHSbm8FORWqeiPBdy7b2aYJ4rtVxT38BnMiZTJyE61
         ECcuTdghI2R9+T9DjSqp7TJwiuyy7cZECFRYrX3L0CEXZ80DgSCd0Da9i5dezHKbAK9m
         Sy9he5BQ5mpF68GITpvRHpHeQ3NJKgQhdy8iqXgtKdaGScMFryzv0jux06v6A8AfLEW7
         StmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795069281; x=1795674081;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dw4sEEscOzdXh0Zd2TjfgHcpr97CB+RHTHfHcH2OFEY=;
        b=i6u4l0mphH2j7WhJAtkJ4PDPqJk2gDjeEPxSteiEnSRkxM0GN9lRlOox6nwQFWaz+a
         tOkBBq6uOLvr1aTelWD713wgsc1HXs66oFyNySjALl4mJ2vIAtpcVp1XO6bndMS7jfnA
         Pg2fRFJZy35m3lNargQaBbODjf4esS4Af4NLhh7ZDlEngNs00cG0kRNccWNJm/gfi6ec
         LcqJnQMkJaioDKjynaCQGTnNMo5iVrscJ3NcYQO7VaS0VAlj8TrNhwlD29Fb16PvXWpD
         2JXpk08dFqoAqcscgCPtpzQYeER6Fka481hWBTeycQyN16meLmx9OD25cOmG0ZXE9AGQ
         l+uA==
X-Forwarded-Encrypted: i=1; AL+hErF6xv8tvgtdOkl0TZM0NCNRd2+C9+D7Qy9QyolNzte/KSG1YWgwzYI6Xd01i0z+COXQJBQj3i2qdx4k2g==@vger.kernel.org
X-Gm-Message-State: APuU4Z89LkPlxYkTeM2foc6HOohJFjdSSoRQiK+ZFQ0fVYYH7pRP/rrQ
	pmvEMOL0hsK77C+k1lRScBs9PEe4kolYnMsNgsPNV3UGxrly+MEcKtjBLbrQHj7Wiak1QC+HWCc
	fsYl2p5KoTuBNjCxG4fN0yfqdqds7zT0=
X-Gm-Gg: AZFdTZceXOD6o/k3jnSlhaiNduIC1wFtTAc6jSz0QndCR188WlplJMgAKug95FfLd2n
	3pQwgorIwrknFq6AQSECFcEj99lrCnZ06Zl5X3vAlNJQn9kY1Yq2t/9Q3E0wfzwof51Zzddg4bo
	uePSozG+RHafCC1gt+4Pfs9f7KHzmuGrnYtzijmTR+po2crJnVgj/tZyIBlHmD7dZ2C7X8w2Hbz
	wNTX9XLUC9HfJUsWJJVi05QsFAAJ1V+SwgKnMBrmi8cMq/dyTkbaDDWmrvzlLU/E+TKv9LrVKZ8
	ml5I7fTduLujgVyJkNbgC6G7fIiQNrm2dS2M14hz3f1BxPgzNL7xALjX/vT5rFlSmJ5CKgm+LAI
	SDS8NRyVGBcW1MHs7EEsK3OO0MBXiB9dKX9ZnaZbpuWP/FqcI7BsLrH9QvMRsMcdbTdtv8oO1RS
	MEgQsSo439MS9vSAG3xsQ=
X-Received: by 2002:a05:6214:8602:b0:921:117d:2e88 with SMTP id
 6a1803df08f44-92114f1258fmr78619116d6.28.1795069280925; Wed, 18 Nov 2026
 22:21:20 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?5qKT5bed5ZKy5aSq?= <inkxiao12@gmail.com>
Date: Thu, 19 Nov 2026 01:21:09 -0500
X-Gm-Features: Aa3M54rKctNstj-xAw2aIWk4fNeHbccByvy8aMtrRliTYHyg6gQPWk7NFTjZLmk
Message-ID: <CAMcAce918POMDvZtF6QbhZMzmf+m49jKGdBEKV2pUi_Y3nn-Ug@mail.gmail.com>
Subject: [PATCH bpf 3/3] bpf: Add missing raw_tp_null_args[] entries for fs tracepoints
To: bpf@vger.kernel.org
Cc: dsterba@suse.com, dhowells@redhat.com, pc@manguebit.org, 
	idryomov@gmail.com, linux-btrfs@vger.kernel.org, netfs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Four built-in filesystem tracepoints pass NULL pointer arguments without
corresponding PTR_MAYBE_NULL masks in raw_tp_null_args[]:

  1. btrfs_prelim_ref_insert (include/trace/events/btrfs.h:2878):
     fs/btrfs/backref.c:328 passes literal NULL for arg 2 (newref),
     and TP_fast_assign (:2856) checks newref ? newref->count : 0.
     Add { "btrfs_prelim_ref_insert", 0x100 }. (Also affects 6.12.y.)

  2. cachefiles_no_space (include/trace/events/cachefiles.h:718):
     fs/cachefiles/namei.c:122 passes literal NULL for arg 0 (obj),
     and TP_fast_assign (:729) checks obj ? obj->debug_id : 0.
     Add { "cachefiles_no_space", 0x1 }.

  3. netfs_failure (include/trace/events/netfs.h:413):
     raw_tp_null_args[] currently lists 0x10 (arg 1, sreq only), while
     fs/netfs/buffered_read.c:790 calls trace_netfs_failure(NULL, NULL,
     ret, netfs_fail_check_write_begin), passing literal NULL for arg 0
     (rreq) as well. Update mask to 0x11. (Also affects 6.12.y.)

  4. ceph_mdsc_suspend_request (include/trace/events/ceph.h:89):
     fs/ceph/mds_client.c:3691,3726,3749 invoke
     trace_ceph_mdsc_suspend_request(mdsc, session, req, ...) with
     session == NULL (arg 1), and TP_fast_assign (:107) checks
     session ? session->s_mds : -1. Add { "ceph_mdsc_suspend_request", 0x10 }.

Verified in QEMU on x86_64 7.4.0-rc3 (20eef29b7c84, all 4 tracepoints
flip LOADED -> REJECTED) and 6.12.118 (btrfs_prelim_ref_insert and
netfs_failure flip LOADED -> REJECTED; cachefiles_no_space and
ceph_mdsc_suspend_request are post-6.12 tracepoints).

Fixes: 838a10bd2ebf ("bpf: Augment raw_tp arguments with PTR_MAYBE_NULL")
Cc: stable@vger.kernel.org # 6.12+
Signed-off-by: BoBppy <inkxiao12@gmail.com>
---
 kernel/bpf/btf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ef10af2..30be05b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7274,6 +7274,8 @@ static const struct bpf_raw_tp_null_args
raw_tp_null_args[] = {
  { "afs_make_fs_call2", 0x10 },
  { "afs_protocol_error", 0x1 },
  { "afs_flock_ev", 0x10 },
+ /* btrfs */
+ { "btrfs_prelim_ref_insert", 0x100 },
  /* cachefiles */
  { "cachefiles_lookup", 0x1 | 0x200 },
  { "cachefiles_unlink", 0x1 },
@@ -7284,6 +7286,7 @@ static const struct bpf_raw_tp_null_args
raw_tp_null_args[] = {
  { "cachefiles_mark_inactive", 0x1 },
  { "cachefiles_vfs_error", 0x1 },
  { "cachefiles_io_error", 0x1 },
+ { "cachefiles_no_space", 0x1 },
  /* ext4, from ext4__mballoc event class */
  { "ext4_mballoc_discard", 0x10 },
  { "ext4_mballoc_free", 0x10 },
@@ -7314,7 +7317,7 @@ static const struct bpf_raw_tp_null_args
raw_tp_null_args[] = {
  /* .. from mm_page event class */
  { "mm_page_alloc_zone_locked", 0x1 },
  /* netfs */
- { "netfs_failure", 0x10 },
+ { "netfs_failure", 0x11 },
  /* power */
  { "device_pm_callback_start", 0x10 },
  /* qdisc */
@@ -7416,6 +7419,8 @@ static const struct bpf_raw_tp_null_args
raw_tp_null_args[] = {
  { "pnfs_mds_fallback_write_done", 0x10000 },
  { "pnfs_mds_fallback_read_pagelist", 0x10000 },
  { "pnfs_mds_fallback_write_pagelist", 0x10000 },
+ /* ceph */
+ { "ceph_mdsc_suspend_request", 0x10 },
  /* coda */
  { "coda_dec_pic_run", 0x10 },
  { "coda_dec_pic_done", 0x10 },
