Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718336;
	b=lMBtC41BkKpMWTcQhlCreoenGV6OTmwWIJxnT9Ie1bQNlOfBtD9WDEUEn1AqSAMdQg/O
	 FCg8VF5cJnvidvRJ+lisUHORvYN3xzMHOUDYLRoxpxshGUYn9RkL3PKp5+vN2VMuY91BH
	 ii82RqbO8jEUPCFmMPM0HilY07EP6U7t83Neq9K/6W+y9elHOWroqUG6N9x2PcxwxYHZW
	 VPXbbvBmwMx7uwU4ZH8tMBG/qZoB1wg8fvzqzK0Gf7WbXyX5YtMt6cl8bFlJL1aCU2LcX
	 qZZRwX7wJEdr9Z0ad4aXZC/d7Ypgvmjd16idsiTy7dOFvgITn525lhfK4Km2Th1fDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=CAcBNNgtM+ZvWYSpLVQ97i1PIWmRHPAQ5ZZNdGofiV8=;
	b=eQRtl6dWuQ683X+JK9M4RXyVBLM36HFnKiC8mXQ+ABi7Au09F4FI8iPmvHOrZCB/wECq
	 QaLt53q2NC/CDoae8x+r8Hfdb/et6MiEzYd1bxPyuACxMvoOzVJGc3P+vMz7z0J99CoI3
	 5al1crhwEee00XMFlLy/dJWhecnODzCyGLKZh7Fu+o5hZmHXZR+KI5ckSCJzaD4a3S6pk
	 A8o7LYUPjt64aWkwa1ZBP5L2q/uVRr/N0hD707b8oQr7i01j/ZUNXRPzACCkjHAPnmGo8
	 2NHVrjBn2AmTGBBI6LpOKA3+NhoJaCvz0M0EkQMPU7BMsCTLlzuh7cmKuIHTCz5rrTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Njrm1HjP;
	arc=none smtp.remote-ip=209.85.160.51
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D6606A326
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE7D6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Njrm1HjP
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4a77dcc4ca0so2334771fac.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793718335; x=1794323135; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CAcBNNgtM+ZvWYSpLVQ97i1PIWmRHPAQ5ZZNdGofiV8=;
        b=Njrm1HjPUTcNgAw03tqAI/HECLjGLvEaKlDNPg7QY8qXqj2NqRlLs6JW3z+MM5Y+H9
         bEevl7SMVamQjPNGz4jNzvK8wOeT2s9YiRiIAQvFWebSznRH7i45SHxK82aMzWt7q7XQ
         AJwxn02fcuJdNKnAO0tunrff8wXoEqtTPqvahYpFvvD7F+KdEbLsTpoml0fJrvkoCmIU
         AI4kIJ+MQkWbYVPwwJCqlJstndAweGD4/0pQRSj3Jf64/Lh8jSmOGqVRJSklECU3CuZQ
         +/je9xDNp6EhIFWCAiE1p7e9/1puFemv6SSKfU/tj6mmHhWq8j7OrzgtPIB7SGQDomZz
         2T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718335; x=1794323135;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CAcBNNgtM+ZvWYSpLVQ97i1PIWmRHPAQ5ZZNdGofiV8=;
        b=NrLo0deeRZ5SGRqRwwv8fFBItVpzd5+1/Hel3Zdm6hfkaAs2Jd6m0vJGhHqNwg3Csi
         RYYErPhpZEeNHau5deIqVSr9puQhI9yllXRg46S/YJwdsQQqRgvcAgWPcEKFCuK3JX14
         xIzd+QxluYqJN00A/vF2Nk7kWD254v3Z7wPxJMFZiSRJBOtbwuFNqeLKMK8ys8eFnBcP
         cycJJc6Nzq5nWktu628+xFVA5LfGDC1xSBt6zqkl5EqQ+wwFZKAK6mZrTQul7qGxp6/h
         M6zdsfG+goL2nPklAr/odiAuw4SM9QI6QwGutG+fR5+qahGbnbOtSs7rHaTmAovNRrbw
         lP/A==
X-Gm-Message-State: APuU4Z+kAcci+qtf58UZjrYohckwTgvVYshtbjxKRVj1taFXUXHEdDZd
	9qCXih0/ouKZlLbBRy8B1xFu/pLQ8BRmp6bMn4ry5Bz5m+GinhkJmV7MBtjtSSCs/yw=
X-Gm-Gg: AYBFou2YhBL5XkIgn7GvGr/2ZfsrNqJtfEyPglmnDGHjZtWo0u06l0O8/EdftzJfWHE
	TeqNmPzzJLFM26sv5I0W27R3q4iE48IPlD1RI8VvtjVz4Genv9NAMfpF2Zg6IVEUewCOK4K0l2z
	j5/aBCs3xrmC+Y1wHkcoVmxBH0teepRszeL3QS7uLYd2rnjqSHCglHZnvmK9H5fs2ueuVAxj0Ym
	8P+YUVNrixeaODakaujKRB/OpffqOG393hUpYduJD8P+9DJQY4iH+uXuZ7C7hh0Tbt+wK3gy+A4
	58kGyit8hA7G5wh0Pd5DCGivMMAr/ph7Z1DVdJnCzhGrRQvJLT+OTRCancXgCyeGNNFqa2VaL5Q
	f6f1XXw2Hr/8J+ARP2rr8OKgpmejFPN/K7Ol6sbRu0jPqs4xCbAa5+ikVcwQybPE5QSgZILAhF+
	IrFl+/mYQeCT+Th6OtuTmVEKFj2AZvuL2HuBth3ZtOYbetTyLV4AiuegL+YnQD+LZDSP1ocrfz/
	i/P4RnaKToz9TCkSNvv83N8hyXkuI+dhFxYZeT+tZRIwOgmvHqNkhcMA7P3QdBgGWOj+P8UzqL7
	TLEabjHtuHIqvcKUUs7Kl6OcBYBmPdD9un9Ps50maxXf
X-Received: by 2002:a05:6871:384e:b0:4a7:41a2:c208 with SMTP id 586e51a60fabf-4a9072d3f12mr8058700fac.8.1793718334420;
        Tue, 03 Nov 2026 07:05:34 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.245])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a92196578fsm9899101fac.7.2026.11.03.07.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:05:32 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 0/5] btrfs: data integrity fixes
Date: Tue, 03 Nov 2026 15:05:15 +0000
Message-Id: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
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
X-B4-Tracking: v=1; b=H4sIACz46WoC/3WOQQ6CMBBFr2K6drQtCMGV9zAs2jKFMdqSthKM4
 e5SdOvyTf68vDeLGAgjO+/eLOBEkbxbQe53zAzK9QjUrcwkl5XgsgFdgk7BRuhUUkAuYR8ovQB
 1fSr0qS44t2z9HgNamjfztf1yfOobmpR1eaFVRNBBOTPk0308buKj9QEczilvBorJh9eWN4ns+
 pUU/G/JJICDLbtSNFVdCKwuyc9kRuU6dTD+wdplWT4Nbzu2+QAAAA==
X-Change-ID: 20261029-b4-btrfs-data-integrity-eb753b57300f
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793718330; l=3538;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=XlDEGHFbM49KCz7ZH+2JAfrfaW5E0Kl2m6LDPE2cOv4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDBdeCJ5kN9b7GPhOgBvlbx7ZT05gucHigMMiLz1iq5s6z4hsdFt63nsVxU4P8awUt/3yLbztVQ
 bU8fipRM1SQk=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

v1: https://lore.kernel.org/all/20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com/

v1->v2:
- Rework patch 3, now "btrfs: wait for ordered extent IO in fast fsync".
  BTRFS_INODE_COW_WRITE_ERROR is set after the end IO handler clears
  writeback, so a fast fsync could still miss it, for plain write errors
  as well.  Fast fsync now waits for BTRFS_ORDERED_IO_DONE on the ordered
  extents it collected and checks BTRFS_ORDERED_IOERR, and the inode flag
  is gone (Sashiko, Qu, Filipe).
- Patch 4: use DEBUG_WARN() instead of ASSERT() for the check that can no
  longer be true (Filipe).
- Collect tags.

--- Original email (v1) ---

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
Changes in v2:
- Link to v1: https://patch.msgid.link/20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com

---
Josef Bacik (5):
      btrfs: don't drop the error of the last split bio
      btrfs: clear dirty blocks after a delalloc failure
      btrfs: wait for ordered extent IO in fast fsync
      btrfs: don't report success for a skipped log sync
      btrfs: don't trim the target of a device replace

 fs/btrfs/bio.c          |  9 ++++++---
 fs/btrfs/btrfs_inode.h  | 10 ----------
 fs/btrfs/extent-tree.c  |  8 ++++++++
 fs/btrfs/extent_io.c    | 10 ++++++++++
 fs/btrfs/file.c         | 52 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/ordered-data.c | 31 -----------------------------
 fs/btrfs/tree-log.c     | 20 +++++++++++++++++--
 7 files changed, 84 insertions(+), 56 deletions(-)
---
base-commit: 2789b2c034d7c0c8687355921a38c5ac41a565fa
change-id: 20261029-b4-btrfs-data-integrity-eb753b57300f

