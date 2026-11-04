Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834186;
	b=Yj0ILVHvMpBDl0a9xB83+a47nD+DQYt550FThBWSkqRvgoiYBKnOjE3REWlFxU072AnG
	 JNAZbi8TZ8xD7SdpXd05ik8I76X66qjQRVlb0xa3LZDiyeD6FmeJ7SKHu7pKFDJxU3ZF4
	 fMUAZEtxw5AgU9UwBQwEpLRf0QAoCoJPaKyZA2/qs6SesrrSyhABU8Ym6Gt79Rd+r6HUq
	 k38QzwTW/UCwI8gz4VKwN6/ghHlzkbInDJIMkJJo74IxmwU25dSRbyt9tSGBYLuD1WsII
	 8FeG1E5M54mdkaClmdXedU5cxuOJjb2Tqb8ZPJzMdl1GwwTawcAdW8Wm5XNtJGyT0tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ue6ML+1SvncZBAJ+sN2E+IJ82CpxtcWqGNhb7YHpnH8=;
	b=NK93jHMiC/0Eqoe2khA6egF/mQyQyXMhDyi4dhjDmLbaNCC7VVujbqI37iA0KyFUVbL6
	 89MJ9yviTP4ahgHrE3WEx8YKMwwsJPficIJMrwyaZ7zv0VLNo42Ujbw3cR+sf+LVVAQiW
	 G4X1RdsqQZZbzxujUL90UDna6UZGznjQb2qXC4WH5h0oGThA2wATMUE+5lVt246VrtJ1i
	 FCEEcuOPO+9Zvl94C8e9Qih5IuG0Ha29flwBMFTXZj4Qs/FVFh6x5eCLZOdE1X3/XLxxf
	 DjGRWbmJ9C3Gz9EdvpQvfeOBrf3tk6VyZC1r0sfW71+8zb87NZ2tkNQZHm2gIKPguwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=r16oclpY;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10907606A332
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 23:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10907606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=r16oclpY
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3550c917fd3so1870010eec.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 15:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793834185; x=1794438985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ue6ML+1SvncZBAJ+sN2E+IJ82CpxtcWqGNhb7YHpnH8=;
        b=r16oclpYEo6XTfbnRu7h/BXhJwPzxPpPQO3jSOGl+p5eik8iE5oyAaaA7QfvUO9rNP
         Rjauqa+gpyyzC4Nf9ys1iBfYNr2WDF+aJS4rO3jUy373VBCcKL13RFLY7Dj8P7nrdDL6
         S5xdY3f+evirG1owUtJfUYuPms+Hc5hUsdF+EDG1VqCCWo4ILhWkrGQumGE/FA/2RB8O
         EC0BHOIyAsjRQ+/mM7ei3iNmapc1Macoq8ZfIg5j17KlezcldjuPSdo5tbm3q+EjE1mI
         iP47D1jYAUp5oMd8/l8kUz6z/vmdBHUSt7fLvs0kAQaLTrWmqJTJr5e2OMbZBlIsPLMQ
         B5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793834185; x=1794438985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ue6ML+1SvncZBAJ+sN2E+IJ82CpxtcWqGNhb7YHpnH8=;
        b=fwJtuZLlfz6GwkIf3+AHQfSxNhj7snOJCe2u6W4i7lXU6GwNaEfJRorRuqfDZwa/R3
         lPquzbtYRDLbL0Uj+4w+QacsuOlTkavdr0KagzhTD4P30Vcxs27NZaZh6bWBUvmMxsJD
         JD2R0gdnlSsyDwDjhIGAWIpAAmrB/4vGh6VkDKKgMpbXbWWce0Jm0lvNSkqEyov94yCh
         OVsbS+vQiExXfgEo/HCDpHZj70bIX6pW/G8sPFeB1b9AZDRpC8YH9dZrf04FBuhWQzkq
         iPXxKMpGR9Z+7ifLajIH1F6FawqVQMyW+PAjRTeXIOe4i/EcoPZCQcLFSd3urWVW7q0Q
         Bxxw==
X-Forwarded-Encrypted: i=1; AKwUvBzb7jdHWUPtmzMem3wxj/76TMfZ1Ux/uv5G2oC+ozzf4dob4uvVvsZMEY/kSwliNtWcsunD78a88Mw6qQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/0HhxuSNdCiP44NxnQmCzXibA/jzuVuTC5BbOrXiTPX/dOwvdD
	e8t/+oCKzRzsnryUUcz8FHggJkODplSKdQBa2SDYhx4bfRfM2WU8r1gwHvgUxu6+jA==
X-Gm-Gg: AYBFou0kMW0thoOX+qe68cculn1CUJaEFMBZJ0KBsuq8diosFhZZxH9aFFc0sXX77I/
	t5u36K2YilkTC7447DLamTJ5EAeYW5GNSTl4KQPM5U78TVds5e6gdDPs0gp+/zCQFyQTmA518u0
	XbZTI9nUtyYbF6QcVCeLQDyZSH+nM6LqatKdTshUz/8GeLyj52U0pirY+n59yhHoIAYDfFhFymK
	VFbaqENoYR5KWC3Xuvi+0rOUNEeTlLI6znL4R9t073rTxgz7SqYGf7zqRY+przuRkIpXix9D+RT
	8CjtpJ8ViUmo/wpWvl0HTOFeP/KcKX2LDvZ6cnrX7Y+sVPE2Ny2N+3Xg1gO/bTnY72zH70Bgigg
	qBngJHni8kRMXM98pFYiSXPT6Cs57Cfh1AIi1LWIwGmv8S7XEQ75jMDwwX+DlTTqiG3GRkmmFr9
	tq4OXfuGeHXlz75r59Ru5N1W9F0O20X9AxP71K1wdM7eYwKytzN7g7bT8l7RoEnEJxy8HpZlTs8
	TpKAuBO2M6WTg/TKbwiTKxO8sfB43gJDiovvJ3msD0Ac+zyABWT/4O3venKy08Bvt774o9yTRcX
	ZZmrDVn/Mna18V1Swbx/Ot8NWwvvyOHgr8Jr
X-Received: by 2002:a05:7022:eb42:20b0:190:3950:43e2 with SMTP id a92af1059eb24-1ac5a0b8867mr26010887c88.8.1793834184834;
        Wed, 04 Nov 2026 15:16:24 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fe477sm9667826eec.17.2026.11.04.15.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:16:24 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com,
	wqu@suse.com,
	boris@bur.io,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] btrfs: owner refs and tree blocks
Date: Wed,  4 Nov 2026 16:16:22 -0700
Message-ID: <20261104231622.3492838-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <9de049c9-429b-46f8-90e7-02b30d2e91ee@gmx.com>
References: <20261104102323.4090290-1-smish149@asu.edu> <9de049c9-429b-46f8-90e7-02b30d2e91ee@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 05, 2026 at 09:20:51AM +1030, Qu Wenruo wrote:
> > Siddharth Mishra (5):
> >    btrfs: skip tree blocks in btrfs_get_extent_owner_root()
> >    btrfs: tree-checker: reject inline refs not matching the extent type
> >    btrfs: tree-checker: reject keyed refs not matching the extent type
> >    btrfs-progs: check: count non-skinny tree blocks in simple quotas
> >    btrfs-progs: tune: do not remove owner refs from tree blocks
>
> Please, never mixed progs and kernel patches in one series.
>
> Send them out separately.

Noted, I will send kernel and btrfs-progs patches in separate series
from next time.

Should I resend the two btrfs-progs patches as a separate series now?
