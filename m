Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE334405C2C
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778957173; cv=pass; b=OgYKT0pD6gboUbB67u7Mnv8eQAjFSNujY+mw53NS1JoqC4hanN8o4y64MXe3oQ4cJ5jmjc+nwJlJRNIa3XQCbCQfb5zQsoQzYIJ1V1cSETN7g8L5sinn0/z4b8UfwH4erngWza4jfGKFcY8aivM+SR3RSN7IYYQQIefb3L6SVM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778957173; c=relaxed/simple;
	bh=2dDNZkyDgwe//IEN9bjah8avQ191HFHuLylPDv0rYfA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=W5lwKTScjpRtya/PxqscimKJjwa3ZEJ3+83CIuU5RT2DilFTG3SG4Su2yt+2p4jCK2VWnQwfMTK/FSbKab+VhnrgCJ8FY+BwCw0d0b+XJ9Rv9Iu8S3qNcPM8yqq9z+gRMDvkGqNZYVE95FOevaa/eKNIBnnMh/fXoaffvYO4cLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSjdI/Pn; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSjdI/Pn"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ba21d32776so6670565ad.2
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 11:46:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778957171; cv=none;
        d=google.com; s=arc-20240605;
        b=aMxFuO85nR0BWeKJhuDeXXnKUhv7asSw9q6dili2MFATZMmCgQaUOP4YDhDfmBqcOH
         XinIzjo20NWfITxZ3Oy3yhkcN2l0mkk9fUa6TeEpagpiJNsDwQV52hyF/Hb7zO0s5KyH
         wxfERS8ruENSpV7OVG907KY2ZVcyHoJs/WClLXIpu/U3RjVPb+4EUKttBAK6jDYoltYG
         U+bfcqXJB3lQgerS3FRpIBBNyPKYQw/qFyAptAAZe5GNDdIN7rQ//4Q355gUMPZvG/dR
         aiYw1MEe+80ZGc5X6Tg82FkGqlFGOWrqm/AzTOE6b62oKiQF0jSq1yyv8LzalMgyGJK/
         nxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2dDNZkyDgwe//IEN9bjah8avQ191HFHuLylPDv0rYfA=;
        fh=lx9gS7kMD/P3Wvg5P4HIaeQgG6FzkhWQD/iiV0iNz4Y=;
        b=IpSRHsSyI+pOifjwZ9tHKfA3MdhTC0bY/SY83flUZJO9Ga6YCgVQNXkwWt8pn2ltDP
         NmA8ShRZQySDA/PaMAm2p7q7RWmwfcApmE1vORNxMyH5L1sugQHSd0Jm72C9KyRt4C+2
         pgV0ZIRL4U4iAOGFiQSC0IPzTrN9MhY5mTRbC4DU+/mssg3BUlWyOA6FPiAVvjcNBUJ6
         4fgQMmkjINP62DFhGK0Wozo3FO/pQ0t3dVrtcDGboBa/5p8B/ez3OTRU4sYOUWVFUiNo
         fZXDn3wLrcGMcSJq1EQrKekXd/INInGPNHcglycCKpU8mFSvWfofNw1wlT2fzVg3rz1K
         /v1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778957171; x=1779561971; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2dDNZkyDgwe//IEN9bjah8avQ191HFHuLylPDv0rYfA=;
        b=JSjdI/PncCLm3eeci/CAez4XCijKb6x4vnWD+DWGMJg+xjLDYTcY19xH3BmqcOHLuv
         5T/+lfJ7DQMs7RRFOpOgBqa49Ol9l4w9LMLCCUnTE957wYAQKctTbtnEithpQWVv57Y7
         025GkAwmFyDDS4hMg5WROe4Yn6bIBuCsVozrTb6gSUwfpr9YiT59LHDTmR53ixFjwMxT
         H9pk6hAynC24lDJXsygoRXvRFw+SMSN8zsvjXGDaGyBzURaBvgM/6AHAySiMsbYa7+SC
         UQMteNsgHdmxCIs+COxPbk8/NoignGOgVHQzPHkFooATRZ7uPeRllBA5z+AOrRfPPme6
         RccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778957171; x=1779561971;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dDNZkyDgwe//IEN9bjah8avQ191HFHuLylPDv0rYfA=;
        b=XRkwjYK1ymCitpCIoPdVjiqKFfvTALc055CAhkpkuvEhxULrGxgSKe9z4nHRWlfd3n
         aAYpZJR+nG0URQD/hZZuIQvdbqSSq5iIx0r/sbIwm0UPpVqYDORXMqhWSW0zoL0HYTlH
         rmM0ZOd9M1jLX9vzjyX+gSq20jIzGi6w75yHZov2QMIXSvz1p6a5SacDr8iuiyfGDD8u
         WGHjV/fjKpSz/gyLxidr6+5SU6ICRUw+JalWU+eryWjEZ3FWfp9KDmVdfzKugGIZpZWb
         6rGeg0+DWNByJbrxgrAURlFMRG/pMu1q2qr06N0CbI/4Bff6vlewEj8VbK8zQ/1jzZiS
         /+lg==
X-Gm-Message-State: AOJu0YzGPJCFT1hWsb0S4yxPHxrpXxFsbqF52LV/soPMKgw8AoY5g1co
	orXp6DlN36b34rikNUCnT7H1out5LDyHvevrxGVT2NXLlC5IoGF7hEzgljTio1VCmQgeaAuAyEe
	D/79aLSDXk6/lDMJoS7RJiEXRwNDWrMENDpE3Mi0=
X-Gm-Gg: Acq92OHEph4THSfNb8CBImOVJpxRNbek6GIck6oA/jVJROj2XikEeP8TSG8dcdFTYWG
	vZTwGlYyYohS4TZ4ft9kEDfQGkrIH+AKE/UWhZlH0fQ+xYVF/xg0Dbr8Monn269xGls7TebzT94
	r6Y494WbjeTNQIrM7MtbpssDr1lawHv9YEg1aF+Z1BTrzk7tMtLP4UseO8w+i3paqbpG768Ywg4
	UJ3SukxiH4a07rWvp1dPJafhYn0jPw7/JOXbSPf4ur1/xfIx9FSiMmu5IUSe6sqDeDI7P99RM3G
	wI82dGA=
X-Received: by 2002:a17:902:c109:b0:2b7:ca38:975f with SMTP id
 d9443c01a7336-2bd7e88f544mr75478735ad.23.1778957170632; Sat, 16 May 2026
 11:46:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: coder mr <godhuanghs@gmail.com>
Date: Sun, 17 May 2026 02:45:59 +0800
X-Gm-Features: AVHnY4Km1Sje9IlkxdB5F4HXve6xsR_1iu0VcvcImiYPPTvpSSLMg7ye4iN0Xtw
Message-ID: <CAMTMgC7G6a6wG4UcjKx6ikB0aAs+64YGSvtoGS5CEuHdhvHNyw@mail.gmail.com>
Subject: [REGRESSION?] btrfs zoned forced readonly during heavy deletion
To: linux-btrfs@vger.kernel.org
Cc: naohiro.aota@wdc.com, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I have been observing a reproducible issue on a zoned Btrfs filesystem where
heavy file deletion eventually leads to a forced read-only transition.

The device is a HGST HSH721414ALE6M0(HC 620) host-managed zoned drive with
approximately 52k zones. The filesystem was created with zoned mode enabled
and has been used successfully for a long time on a 6.12-based kernel.

However, after upgrading to a 6.18-based kernel (6.18.18-trim, vendor kernel),
sustained deletion of a large amount of files (~120-~150GB spread
across many zones)
reliably triggers a failure where the filesystem eventually flips read-only.

The relevant dmesg section is:

BTRFS: error (device sdb) in btrfs_commit_transaction:2531:
errno=-11 (-EAGAIN) (Error while writing out transaction)

BTRFS info (device sdb state E): forced readonly

BTRFS: Transaction aborted (error -11)

From tracing the failure path, it appears the -EAGAIN may originate from
btrfs_check_meta_write_pointer() when metadata block group activation cannot
proceed during transaction commit.

What caught my attention is the kernel version behavior:

1. 6.12-based kernel: no issue under the same heavy delete workload
2. 6.18-based kernel: issue reproduces consistently
3. reverting back to 6.12 restores stable operation again

This reproducible version-dependent behavior led me to inspect recent zoned
Btrfs changes.

My current hypothesis is commit:

04147d8394e80acaaebf0365f112339e8b606c05
("btrfs: zoned: limit active zones to max_open_zones")

because the regression window appears to match the merge timing.

Specifically, on devices that do not report max_active_zones or
max_open_zones, this commit introduces the fallback limit:

BTRFS_DEFAULT_MAX_ACTIVE_ZONES = 128

which enables BTRFS_FS_ACTIVE_ZONE_TRACKING and effectively changes previous
behavior from "unlimited active zones" to a runtime cap of 128 active zones.

My device contains ~52k zones, and under sustained delete/reclaim workload,
I suspect this limit may become exhaustible, causing metadata block group
activation to fail and btrfs_check_meta_write_pointer() to return -EAGAIN.

I want to emphasize that this is currently only a hypothesis based on:

1.observed regression behavior
2.code path inspection
3.kernel version correlation

I do not yet have instrumentation confirming that the active zone limit is
actually exhausted at failure time.

I would be happy to provide:

1.exact kernel versions
2.mkfs/mount parameters
3.additional traces
4.reproduction details
5.test results with debugging patches

if that would help narrow this down further.

Thanks.
