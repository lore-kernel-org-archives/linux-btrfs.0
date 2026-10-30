Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371110;
	b=d4SpGvThLqwjZkPmtU90v8kI32X4IkEf7DQoYiX5nbH/EloewGvyztLHTo54i2/8bSIf
	 +PcFMxKAdYhfD7/C0Q+re7Bp5MGHgN1Kilb8d4ucHyR+e4lk/PzNKPn7JLivbcSKXEoyw
	 +nzX9GPmJY2A0IrFxKadDVG54i7GQvZXS8r9NuxXvnEmpG/D+Jp/5j1Ruc3Ip2QWGYojj
	 kK0RTs1z0QthGC9LxJj+3zXcJZzUNJFLsA/mNDH2wrYdVd779p/oh7LZ55nY7hW5LmQcC
	 AQ8Y9nbWrRjUB6ikJLmVhphgjtT9oG+UTTNmjnwMLURYcxnVfzabBoE7sMoJOLrtqhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=Lw2XTa0UHLp5uC9FUZa5RGPGrr4tiBPXeAThucLJkgo=;
	b=OdrN0iDJCKKMTgeQ3bxmaB9y547g7CqgH2qtLjnfrtFAqNWuUMHzIzDjl/eoxcieZMZz
	 48PBLko3zzGjMc71jduJk5uz36r9bqsEPKhEFGd1ntAoNdzUWe/3EPZMy9uFLvS78Rl2s
	 1MUXjsC0hVB/zHYXOgHxm2wAJ1S8FPNm43O9K3H3rmntSu3silWaUPk6/p+pTFXQWDqzp
	 s5wnhgAbx5mJb2XNUKYWFnsjbrkVxyzKFKHJoQsPkcrXZ9+Q3TcBOorIiXLaiBJJTMpzo
	 8oz0Y3bDhe0mH3k0yeqGbvQX0Dv12Les+YbuqkWWbwpTEQv2gvEMBlLEhS7bcs/B2nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=f4Oxqytp;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3189606A322
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3189606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=f4Oxqytp
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f3c89594cso49096585a.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 07:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371108; x=1793975908; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Lw2XTa0UHLp5uC9FUZa5RGPGrr4tiBPXeAThucLJkgo=;
        b=f4Oxqytp3QWZ8rkKm7Zakqilbipdp4cRSVRQyeZ7T/X+ekYhph4OPeKmzKK9hJADW7
         Mk9LhZfE8Vk0i9cVnh0j0qE14D7+07VEfzkYULnm6heiFkQl8aYPsGi5PMpNAJedwGKs
         I+EhFx8t61+b6IJQgrmOvGEigVJTlyTdl0XsFLDDq+hA8Ihf6kgq2mdch5nQkNRmI67x
         WAGZKLneKwbs3xuXEJR2nSPOJ0pZcO415sO3O/z8jKYCc6eNh2MEZ8aH4CnUfgOb3Qwu
         kKCgMEq9k0RlqD+5zX1zkIyYK6caNXNIw8N0t8xyjTHdLR9E8Af9uEHrKXRnPLrYrmB0
         FP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371108; x=1793975908;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Lw2XTa0UHLp5uC9FUZa5RGPGrr4tiBPXeAThucLJkgo=;
        b=ZH9iU7l93nyx6fD4RUM84jEk5yYeSuwFTvW+juMOK+a8W5g48oK68kXnLyq7B42/u8
         VnShL6m+LVxYGN+OJYQOWexYV3u3RMFZlU1IlMVduPBh6TGjtAuC0F/zI99N0A6AMMru
         /YO+VidKf47sSq8d4jp6jfjY8e/L9vUgVAxrLQZxDB4aPLCy0K1NagUXLOO33C8S9nMS
         mNHj454guaQW3/zPlo6LWT0jjbO8PHSvakBqbSey6jLcn5oszpJpKsFG4yBtGxT5R/Ht
         fUP/7I8dm2CgTqu1w7aESJ64qn+DyaFazUveexJz3nWbCXwxJjf9x8zNMTYwZt+Y7egX
         4JYw==
X-Gm-Message-State: AFq9FYI0oT0snrih4Emn0cyDxY2hqIVmX3CHli4dARQGrlruv3yxVr2n
	kxhH3gPi9KNFSfu4+vm+1bgh9BHDcchiu45/zx9NsgAE17LsIEPe4Um8rMnHUx2iazA=
X-Gm-Gg: AYBFou3u6ZL158PiAo/CP8/etJxSn4wA3u8DFXy8qbMqzCIhRl8FdZYhgiD0MHSTByy
	PQVKLZ1wEH0xCv/J+L8k3TaX6snymuaDYyUVZ8XJDyMLrX2i1QiOE4B0Z+6h4uFHgR6s9FPW59M
	/rl37eIu1Mk1Dj2JEuOs7BupNOEB4/Zs8vKufOrW5pjM5a/EoVLGGTw38Y1Cn2FUf+lDLbPw2qn
	ZuPmsIN0F3IZNr6+B9uG9tboCOnC5B1ASZqw7lBowVORvQid7B3K4TS40buDUU22aw5Pbv+pSkp
	QKMPQJAotgcrDGkSRBrNEdmvnwY911hV+++V1XWDYpI337Y1NAGfFe9dtvqGsR2a/LNN1ckV2gd
	w8q3juADjfDNLbEfcBDCwETtVnOPoOO1OoS42yg+gETbtpEJ+uNC44GHBdXNY7RM6U2yLnRlVxU
	x8tI11lTnqdM6KlSyGVgZFGyaMZWvrYmrEFBwPXbyG/JYC71RM6gYaBNY/x4B/noltTZjOKZR18
	cJDPZZkv8QR9Ybat01bclX8wwAztmCKWY+BQDAemiVvTKlg6PJ+zGAPh6K6+7dhzWwmSZpStB3q
	6yd5R0tWw5hW0qBngSPUOQLmLaa92LaY0t9zy0BvgIsA
X-Received: by 2002:a05:620a:8907:b0:939:6de6:9518 with SMTP id af79cd13be357-944216ed973mr439727385a.47.1793371108304;
        Fri, 30 Oct 2026 07:38:28 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425ac6bddsm155612385a.37.2026.10.30.07.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:38:27 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 0/5] btrfs: data integrity fixes
Date: Fri, 30 Oct 2026 14:38:06 +0000
Message-Id: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM+r5GoC/yWMQQ6CMBBFr0Jm7YRSRKJXMS46MIUxppBpNRjC3
 aW4fD//vRUiq3CEW7GC8keiTGGH6lRAN7owMEq/M1hjL5WxV6QzUlIfsXfJoYTEg0r6IlPb1NS
 0tTEedntW9rIc5fvjz/FNT+5SzuUHuchI6kI35uk1l0e49JNi4CXBtv0AMY9XBZ8AAAA=
X-Change-ID: 20261029-b4-btrfs-data-integrity-eb753b57300f
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371105; l=2635;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=YMEJ1FGA0t74fOXTrNLI1MmSNUL5joiB2lJWMWavJzo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB4FPscSuuXStZNYYoP94AQtart+lZVJkTi0PEYHBO5lthR/+x60yAWTI5WRWLxqncxocpaCo8K
 2txIaK+CpUgQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Hello,

I've been doing some model checking of our trickier paths with Claude's
help, and these are the fixes for the bugs it turned up that actually
lose data, or tell userspace that something is safe when it isn't.
Every one of them was reproduced in a VM on an unpatched kernel and goes
away with the fix, though the fsync and log sync ones needed a delay
injected to hit the window.

The worst one is the fstrim one.  If you run fstrim while a device
replace is running we'll discard everything that has already been copied
to the target device, because the target's alloc_state is empty until
the replace finishes, so the whole device looks unallocated.  The
replace then finishes happily, the source device goes away, and you're
left with zeroes where your metadata used to be.  This has been around
since FITRIM learned to trim unallocated space back in 4.3.

The split bio one is similarly nasty.  If the last piece of a split bio
to complete is one of the split bios and it failed, we drop the error on
the floor, and a buffered read returns success with whatever was sitting
in the page.

The rest are in our error handling.  A delalloc failure in the middle of
a folio leaves blocks dirty that no longer have an ordered extent, a
fast fsync after an error that happened before we submitted the bio can
log extents that were never written (which log replay then happily puts
in place of the data that was there before), and btrfs_sync_log() can
return success for a log transaction that never got committed.

I have a cleanup series for btrfs_sync_log coming, as I had to spend a
lot of time grokking that fix, which is a good indication that the code
is too complicated.

They're all independent of each other and tagged for stable.  This is
against for-next, and it also applies cleanly on top of Qu's
extent-by-extent writeback series.  Thanks,

Josef

---
Josef Bacik (5):
      btrfs: don't drop the error of the last split bio
      btrfs: clear dirty blocks after a delalloc failure
      btrfs: make fsync wait after pre-submission errors
      btrfs: don't report success for a skipped log sync
      btrfs: don't trim the target of a device replace

 fs/btrfs/bio.c          |  9 ++++---
 fs/btrfs/extent-tree.c  |  8 +++++++
 fs/btrfs/extent_io.c    | 10 ++++++++
 fs/btrfs/ordered-data.c | 62 ++++++++++++++++++++++++-------------------------
 fs/btrfs/tree-log.c     | 20 ++++++++++++++--
 5 files changed, 73 insertions(+), 36 deletions(-)
---
base-commit: 2789b2c034d7c0c8687355921a38c5ac41a565fa
change-id: 20261029-b4-btrfs-data-integrity-eb753b57300f

