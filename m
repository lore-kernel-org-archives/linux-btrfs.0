Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222983A7F51
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221889; cv=pass; b=c9pNk395Ig6t9e65nXVuI2CgLi+C5Nt9AQXcR2s5arsONvPs0j6+jvfoCb7oigxaIYMNvk8O1w9stNgfICrpllYJrABvlpQNld94e+8KhuWk0/VYZwr5rSwGp9NpyLaFWQvJbYJiG89l/b3wQ4JsB2qFuyhdGM0atOceVsO376s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221889; c=relaxed/simple;
	bh=XAo9vfAbN7W0cUc5rcT/TQJq2dzvk7LSDQr3E/oLmOw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=buROTQ/86e7nOkWzvs0HqX72b+fXol0VdvPH772z7pI0DxgtJSymNaIQQ58SiciAXRLoitss1rpXnHfsEgWwSaXH5jGIxGlvhJDMU3rmZcL6D2eW1F1BXzGa9dVyxd2l4p+ZsdP6dcGp7UltSiNI9s+5ihu3dbWjx+fMRyUkJV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=loXtKNgB; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="loXtKNgB"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b013084dc2so3039368e87.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 10:11:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784221884; cv=none;
        d=google.com; s=arc-20260327;
        b=FGe/sYyu5yZKTB1MEDBAiDRVm3JfN9Zdb9515iSn7qxIg7Ej4nY5LAxtpHqRNmPZfm
         RPHuxzInN4xz0Ic4TYBrTYgVo+LrmflT+pCWIRn/CKjkvDRQp38jHjqel0QQuIJ9bUDL
         DyorhjmpdjvwYQPR2GkoqXHOj83r31bLjxdJpqLjabWBaYXtU3PwTRMGTzyHZDj/uJW2
         XCl1MeWd7qKEeFU5qAyDw7bDQKvaMIyJpCD5iE+7PWp+v92iDBqHAqzAqT/L/Nn7pqaA
         ajyko0qGPDkQpKcoc92jh2Ur9nPH2O8UPgOUXBY5a9Kezm859IjXDKdaQ+C2dBGJCQmj
         0xXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QafzE1E5CSS3q3rQGn6jTvtg2tR0LheomrUdACA0pO4=;
        fh=0NpNUQ2Uz9fPpDJrD5vn/cV7qUXz4qZBahwbL8iw9e0=;
        b=r3yvqEo6yXR2paXSSdey4DY2uXTCX46B7CCi2soJ+eUXxBtLzii05LsAyZngVCH6E4
         ykBQAaRjrwpViASYkjYxztuDGCLjYkkMAUB2dZGNcuP9cqY47fgxDQmyiAk/317QTv9S
         g04PiubTl/M6hPfbFkuTcrAOAYjVPs9/tjwq7CUb5MPmNdqamyOCgwdVZIn2O9IuyNfg
         tbq+hsdUkjdIrZa/qPuyQ1CKTgFJVbDTIi7KpMNSsjYsmJZ/SVG+b5WLPD3hJ2jpEdyN
         Cz2AptHWvwQxZgz87cMpC0h29WGAwD4fAiXeDwSh6H8Z2gaGRDhc5Rm3ptP/WwaO6j1H
         wIZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784221884; x=1784826684; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QafzE1E5CSS3q3rQGn6jTvtg2tR0LheomrUdACA0pO4=;
        b=loXtKNgB6JrMbpJqo95wQ23lyAmGC6KA8/6d433zYccnSQBe5K0ftUVBgxyRDFQNku
         NOMjRd0HFmNV6S0WRS407j/rB2hK4kIbp/wHkbD5tZ+KilEdQw/M0smvGN1C6M8PMdZn
         uR3WwljtfKTU23C0U0RWjWI8A+dgUi+orOIvBo3J8MS0RDR2nuxheQmZoAQa48UPHn7+
         gU/X+/WHileJe8bixekszvlIelFKTkrOUbBys/ppna+S3bT3OdGoDtP62tvvDJYJf3q1
         RLkjVL4sACafJODqvMf5B2woGGKE6h1NOQi7cZabmed0kwrNqbJM1vGNbFJxQBriPK1h
         od0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784221884; x=1784826684;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QafzE1E5CSS3q3rQGn6jTvtg2tR0LheomrUdACA0pO4=;
        b=MUHiYLd0lYGVu0ntS3VVtbh0XNwubm7jXvQGV7VIPoyubcs6+GoknSYN7gbNcqYpZB
         HW686DtMbzFm9p1J48AOKBcE7gszx24PTDB91d+2OsfFqX1dsOSRqyMAhW+ncQha7qrW
         BwuBKiQkqTD0/Ej+YIDrAUjg+ZNGmfq/a9yJxIIznxLJpUmaNHBiQP56C936wvPUR8pV
         YAHknCKqMTmLO0xHemtWUoj1C6RkGEDE/bZaxLYnsJm3FQ654CO7eeNO563Wr0eeeYj+
         gZN3x2qzZq5l/daEcpJlRQqSfylL725UGvwOxX4Avoot2zdLh+KLJlghAGehOnHlAW0g
         YzAg==
X-Forwarded-Encrypted: i=1; AHgh+RrbB+9KklfrFMVOzUm1TtX90/gLV6TQ7LoWNn7uxaWkCAx5iRemDaQY+TESJdu2r2W1Fdp6YIloFpw2yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiHCYV75dSLT+eUP1+Zfhn2Ek/E09yXqG0j2x9QyjNsG4SInB8
	pHRysUpy+kmftnZ00Q/FIUCx/niNMPAuAE3o0g826dNRP86UPOOSgybTjeTEtJMVvO47YyzNqgv
	CtSVIIeScK7FNZnG8M3V5DP5oRlwLwbI=
X-Gm-Gg: AfdE7cm9nLo5CSHgcAXKiWktpMmJ0AACdAVyT3/la+sXvZAlmD4i2GBFLrq0l6+4Fa0
	6dTLfhaPw1RhlBUrAXreXYl2Q07IPHI5MuC3weC04E4W8bnCMVizqKOjLCl8ytoLJcH9TbP98jT
	szZ9aFM96v0Ev2y3Xcg3cQkeGe3DnbTF7r//oWa3hu7s8pHoE7Z5bmLlOo4VgQo1zYKUcmk4qnF
	E3p0avCsdLaJQjk7uI1Mh8PWifbQTGR66WyGG1uxFGnHpPI++oiOzZH+XqW
X-Received: by 2002:a05:6512:65d2:10b0:5b0:1dd0:f20b with SMTP id
 2adb3069b0e04-5b023561501mr3613763e87.6.1784221883351; Thu, 16 Jul 2026
 10:11:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Fri, 17 Jul 2026 01:11:11 +0800
X-Gm-Features: AUfX_mwNOWBcxm54equ_vRawnkvZnXXehNmEk3_wgj-yOseLVARzyxMqIWlyWkI
Message-ID: <CANGjgd=fQkHht2PdDi-+EAdzWH7UtxxWhhJ7b80Rr17PbpgxOw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: replace writeback inhibition xarray with a
 fixed inline buffer
To: Leo Martins <loemra.dev@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	Filipe Manana <fdmanana@kernel.org>, Boris Burkov <boris@bur.io>, Sun YangKai <sunk67188@gmail.com>, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi Leo,

I independently tested the exact v2 code diff on a physical x86-64 machine.
In this narrow synthetic Btrfs remap-range microbenchmark, it was consistently
faster than the unpatched xarray control.  This is not an application
workload.  It also differs from the LKP fio 4 KiB random-write case: this test
exercises the same Btrfs writeback-inhibition functions through 4 KiB clone
and dedupe ioctls.

I applied the code diff from this v2 message to a frozen Linux 7.1.0 source
snapshot containing the Btrfs change at
f9a48549a15aa369d42cebc08a6a72b71a53d547.  The exact saved diff used for the
build has SHA-256
5ec741be5a89d6dae0c0608cc036512770b55d6a49e9b576b4aa3115ebfdffd3.
Aside from the v2 diff, the control and patched kernels used the same base
source snapshot, normalized config, GCC 15.2.0 toolchain and Kbuild metadata,
with `CONFIG_PREEMPT_DYNAMIC=y` and `preempt=none`.

The machine was an Intel Core i7-12700KF system with 20 logical CPUs and
32 GiB RAM.  For each kernel point I created a fresh Btrfs filesystem on a
1 GiB RAM-backed brd device.  The timed process was pinned to P-core logical
CPU 2 with the `intel_pstate` `performance` governor.  Each point ran 15
rounds; each round performed 10,000 4 KiB FICLONERANGE operations and 10,000
4 KiB FIDEDUPERANGE operations.

In a control -> v2 -> control sandwich, the means across all 15 rounds were in
ns/op (lower is better):

  operation          control A   v2         control B   v2 vs control midpoint
  FICLONERANGE 4 KiB  2943.790    2159.123   2970.446    -26.986%
  FIDEDUPERANGE 4 KiB 3535.456    2762.835   3546.942    -21.980%

The two control points drifted by only 0.905% for clone and 0.325% for dedupe.
Dropping the first round from each point produced deltas of -27.178% and
-22.128%.

All 90 timing rows passed the semantic checks: expected_match_ratio=100 and
unexpected_results=0.  A separate ftrace direct-hit run on the v2 kernel with
1,000 clone plus 1,000 dedupe operations observed 2,000 calls to
btrfs_remap_file_range, 7,473 to btrfs_inhibit_eb_writeback, and 2,033 to
btrfs_uninhibit_all_eb_writeback.

For this specific brd-backed 4 KiB clone/dedupe workload, v2 reduced the
measured per-operation latency relative to the unpatched xarray control by
about 27% for clone and 22% for dedupe.  I have not tested application-level
impact, physical-storage impact, or a broad filesystem matrix.  The Tested-by
below applies to the v2 code diff identified by this message and the SHA-256
above.

Evidence bundle:

  https://github.com/lcf0399/linux-regression-evidence/tree/7e47ea94a4d151610f16e98429efc3c3b8865265/btrfs-remap-writeback-inhibition-v2

Standalone workload:

  https://github.com/lcf0399/linux-regression-evidence/tree/7e47ea94a4d151610f16e98429efc3c3b8865265/btrfs-remap-writeback-inhibition-v2/reproducer

Tested-by: Chengfeng Lin <lin2530632123@gmail.com>

Thanks,
Chengfeng
