Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC1D2DECBF
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 09:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791623437; cv=none; b=fhTN53iu75lK8Y7d5sJdfeL1A+xJ7UtVmVkxBwCBfE3mQB5NOX7+DZf83VmCEz6HYS8aBxpD9NAcX9Yx+y2iNcBmlYuqOjA8iATbwA+L7G4EixlNfteRylz131lVrNZjUBxehwnk0o527pdjwmdOTxakezo+xNIq3AwuzxuHgbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791623437; c=relaxed/simple;
	bh=wSKi6gZX9Pbj2TkdKWCzVAat1mvcc1tUgaLMYNNccRY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQtkD69CtSm8Iw1tUCNHnrBAuEKfw8TprcCWQjRfwCokAn3gLq6pK7zkg05hKqI7xz8CWTZQEj8PlTLN1niH2hUvHoK+DnHgknI1HYEfx0rDaMnKTUI3qqfIhpV2tLmp4hhDBp5pGFuppeHVAHO3gW0kpdg9jsHvGwkcxX39nag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2C6SOaS; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2C6SOaS"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so2907165e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791623434; x=1792228234; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NxZS7crcJhSd2qjR9sZhtM5Y0kmcp5e+rvpK7gfXJgI=;
        b=j2C6SOaS/XNDOQi0sQlzrpRxs95nzQYH9YoM0nCMq1eF0gm9B4vbbmLtFaxp1Mf5p4
         DZ98B145dHYqQ9ml1Wgj7qC8VSkZsqNYv6YVVFoW0QWbNIZJkAayLQeUwY+Ec+0YICol
         MpW72sCnjJGvIJUOCnaTtbsylpPmz8A99ec03l2S+JLUgc71S/AAsdmxQidDQJi5nYlw
         nWmZYzNjYqafoyqGIrX7BX8kdpvc8J1UINSWCGEW0ANnl42iz5TeEsLYJI82enNH1oyT
         N70n8hj5IP4pnokFPZK96gmmndZ4NFR0KKn3vz5c5EDIn9ajellqPCWHvLFEvGG1e6eu
         u6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791623434; x=1792228234;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NxZS7crcJhSd2qjR9sZhtM5Y0kmcp5e+rvpK7gfXJgI=;
        b=GeEqc++MzZtxvpMjN9AkejFwiyOxXfwhmTOWYAhBQWzDhdj8Oj+erwaGL9ZtdfoFvc
         B7RxrPerLFwL4ypw+HSp3PdG+mgEBV9e2etemPijDDLz8zzy2fZYBNOuzthONGbhvf/C
         532uHdmCqYNJxmn49+31p8mCsWfINkfDNAtYewlXn5OiK7T164fuFtm1K20OTwBcNGCp
         RssK8+A019tzi1Uu9EDvDkz1+4DhgA9KsGFXru+D135ECHCVjFO6kcVJFJGn3pRxIbgU
         89m0DIDmBTZOoJojv4UAxgZvznMhTD7OVNx3i37n0cYc0jm/IlDtX8gmEGQL7L90Vg37
         uCAw==
X-Gm-Message-State: AFq9FYLZMuHUg5CIMRptnUf39tOMoELNyq/1vumcehiHyyWegmq+F4Rl
	Im2C9IqPzo0k6GeFr3ZfM1bDSRT35vMv45VU9jUzPxmVB4YvGvfgCK3m
X-Gm-Gg: AYBFou3TZcz/6G/UakbEmhtuoFBEQkhUqRF4boeMVWezQEFsF4E0GGDIFa8glOysBBB
	qdNZBE1XRKrBldvq1VmvCjK5BRwkzZVG1Q60em4348C+tSfPFN66pdSOG8XkVPgOivdPiNOis9a
	HHao/DMdApJN4Ntl6wp9iDC9vgthEAviSKriiE7nCDKTZcg/LIRcgYJxUGIjUqAaf1bz1AUgHtn
	SUPoOl66CeFAU/6sD6Q9/We+HHG3gN2haXWGSGK7QXf0iBDl/poFU7cP9bmudgeSz9Vl/vjofhp
	xlFSPM1qmYp3oxMqw+TY1pU7Z84DN5V2wVBOmGJ9sd6x79l5ZWoGsZjZiII+VZ0xOLjTEeni2a6
	ElnYvTXqh+9JzIoXnZAZMqTqNnX0Ws68bqvg73uD1K43nLgzNSLfzyaBZbHo1MACZSmP7aXZZJL
	NUTCeGr1mPqZKeb7jr1VeaQ6Eu80mVXpqwNwGkKb+/htnMu+sEWkx0ONLIIa0H4FMNlcGnI+VUN
	VklKzo9wAZVFQ8o0JXFg/dIvUy265zPEtppIzuH89Au+Lafg2Knl/D4+Ea9juiQkA==
X-Received: by 2002:a05:600c:3e0a:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-4a18e49c52bmr77420555e9.15.1791623434169;
        Sat, 10 Oct 2026 02:10:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:8a0:dd02:d000:99f:cbbb:1e16:ca53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19471edd5sm70865545e9.11.2026.10.10.02.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 02:10:33 -0700 (PDT)
From: Tito Duarte <duartito@gmail.com>
To: wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	ebiggers@kernel.org,
	vonbloom@gmail.com
Subject: Re: [PATCH v2] btrfs: fix the fsverity callback where unexpected range is verified
Date: Sat, 10 Oct 2026 10:10:31 +0100
Message-Id: <20261010091031.41686-1-duartito@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com>
References: <15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, Oct 10, 2026 at 04:59:49PM +1030, Qu Wenruo wrote:
> [FIX]
> Instead of calling fsverity_verify_folio(), call
> fsverity_verify_blocks() to verify only the read range.

Tested on Debian's 7.2.8-1 kernel with this change applied, 4K pages:

- arm64 VM (virtio-blk), the reproducer from my report [1]: from 10
  spurious "FILE CORRUPTED" reports per 30 mount/read cycles to 0
  (0 in 120 cycles over four runs)
- boots from a composefs root with overlayfs verity=require on btrfs:
  arm64 previously 7-10 reports per test run (three boots), now none;
  x86_64 with Secure Boot and lockdown also clean

Sorry for the duplicate report, I had missed your patch.

Tested-by: Tito Duarte <duartito@gmail.com>

[1] https://lore.kernel.org/linux-btrfs/20261010083827.27604-1-duartito@gmail.com/
