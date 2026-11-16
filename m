Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841722;
	b=FC1FS/Re2mXNsdET5PkLxREW+CbClyR+98wIyNNqJxvbDxc+7yWyWwDnsWaHbrSt/629
	 7TM1uwIFdLddiWyuxOWQMOPV8reGt16kL0lIjriyD6uao5vbuNAyzTT7WMzma4u6hYvV2
	 s3CUbDT0PiNJdSkMrpwFxrW5w6JNVj4gocMNxOpF/pgUCI015i3BF76QJeBuRrLsuEODD
	 c6POJAvNyVBy1qBbTNppJWKcTNhegLzIrOSOeEqwh0XCe5oybs92TXzXSW5mHk/SXIces
	 vCBeCV9nk/h+ezySPtyA3Eu4SqRrFWRCdY3tgJNhzfCcjXarz5jl8mnnCCh+Qx04jBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841722;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ug5xDFYIkWGptx33tDEj6m7ef1KHZR3gigplh2zd0js=;
	b=ZYBULZYCy/ZLJ4VhxMeobavsFqDuquLHkqoAws1plHA0M96FFdsJyYeB3zpHwhfYRQUA
	 FrAg4yiCWKUbm67DhRpmdyHRn8RRJ5u44G2PaueWGt/1OO8L5i3kStp9ULKI78JaL1HPI
	 3pZcRfmpZRc52BQeepU6sZZCLOleG4rT0XlVCvVA6DIJfML5MS+CGDLbgdkkfjFUBRx40
	 qgj/VRrIL9/13omObw3F7sH9HLLtb4yZryVhb7Vz0L3UkT0p1TLHBAVqh8qzWhugrlmSh
	 SqkZQEX1nLoKDGGn4qU/Hg7BGkSbnckBNlaCeXAqsDQuvLdX0/DwB69S9ZqNJeAmWYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="b17TS/OL";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57C0606A323
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 15:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E57C0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b17TS/OL
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so8809585e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 07:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794841720; x=1795446520; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ug5xDFYIkWGptx33tDEj6m7ef1KHZR3gigplh2zd0js=;
        b=b17TS/OLhkVE03S1uoRWx4KJx4egoURpFsI+R1LzS4VgyzDayW79sYeUrNhU99VT61
         SElRwcQuEoVqmHmjNem7zEshJDbuNpb/fOrEmMc0L7B4lpXnJgqHyODEsHDo6+DMuR7f
         bXMJWvRS0iHClOEDE6yfwAa9985MDKOILDoc/DYr/0vXsSPgPF/2qygmT63T478knhGy
         +/wT+kCNTeDlf3KiMJ8yOui/7h6IKRlQhapai5hJhENTaA4y92I8zmufBNgnpN9JoK1c
         aw17E3cAN++FeiQ0BkkTO6pci/S0iODLl5OFUtGQoHkhMlyxKtaDBYzTMJlUfrtliXeb
         vPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794841720; x=1795446520;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ug5xDFYIkWGptx33tDEj6m7ef1KHZR3gigplh2zd0js=;
        b=FW+DFiRHKXzrqi0aMp59sxQCw+Rhatul7SpKndoZ1tuLkNA5ylrP/FgrB2D5q8Lh55
         avxtcpmf/1mqg6BWWnyQEr704NSS/DYmjJFZVlyxrmQbh5u5XjGFnRkFIaifE69DCcOv
         rkCq4MA+FJ2y+JenUTgqyLb1EwN+XF5XZdj98nquq/dwm7EqZsI+70EpwtPcpOKNS8f+
         mtqVWQA13Fgsi5cnyF3PVleSH90k/BPwTE+VcLFpyFWVcvK7iqx0oisDrQ6J9HOeHvbs
         aS1KSM79FWA7sf2xY4s5hZSSBkKQ8satRgnLyYmKPKr2Z17Bgg/qj7++s4g4sfc6cPnI
         GDIQ==
X-Forwarded-Encrypted: i=1; AL+hErEM9O4SCUtWjcFN+Tj7UOv9gQrCBvvpLWZdzSGdvN0qPWP5wK36tthroBWZM3YyA2rguDjj+WPGD84tSA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+aKaQ3XQrWIZa10vDZgLaW9dIx98Tc6BD3zWQkWRS33zFa1j06
	q9UjR91Sa75k3Q6oXb/EMSRPuiW+MBIFDqoa8mL0d5o6csvZzSYlSY37
X-Gm-Gg: AYBFou2j80yBVWrsE1ttpoMQlemn8b4wtn3Fc4eSQH0ezT1Z+jK67gSf4GFeocRnrnS
	bjgqM6c+GgzTCYEe2h47KhwJos2/uvtTArrOAfJi5IxufOEqjMZYOw9XcCc1OqGwxBqKG4MJZBT
	va17grLDrOr5TUy/yqv1smZLv4mKqNg1GQk91SkleHHkufyP9mybgIR9RnWgbRxYXwNddPGf2y2
	xRSAEk53v8mS4sZM0jTGXkCsz5lJfWASYC377cORtkSUwmHB60ELVtHkNZCXa/uWY5SoCJiEJU4
	OIaVyfPED68l8CVluxRhlTljABdnWALUWa0C5NbWaLYR0Jtb4wT+WahZCuxFqPqFXgzP3CCzP37
	IjzvwPHY8/yfnXMcI5IZbtsqDQns/JQTxTojEeIthhRMO5MXoYzqK8cCewHk0Ybm3JSmNyjQ3fe
	tBWyqmhnUrjlIAaTsoKtQtFnMn9G+CcvO9YXO/UC+g6c46M7fw14VMz1k6QHaBYoHnvVtlZE5bd
	jDa1aGLpRxvnSl+bQpkrTp5TY86z8bmU8sHUQ5kkKZxLvPDvdN3mB2il2Q8x+jcUfwjoCBnNwjj
	DYMPwSuJ707gc/Cd27csFBfYSt8zjz/IoSnggp0qcYberRxIKtM/OwEGCrNJ3ThJzoRmexIy5Vt
	MnyxKiOBKLY4MvunvRnS7Whv2AJLCnOQktgE=
X-Received: by 2002:a05:600c:46d5:b0:4a3:5991:718 with SMTP id 5b1f17b1804b1-4bb55a82b16mr230330235e9.16.1794841720043;
        Mon, 16 Nov 2026 07:08:40 -0800 (PST)
Received: from localhost ([46.36.23.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb62d5ec30sm316168175e9.15.2026.11.16.07.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 07:08:39 -0800 (PST)
Date: Mon, 16 Nov 2026 20:08:37 +0500
From: Mark Korenberg <socketpair@gmail.com>
To: =?utf-8?q?Martin_=C5=A0koda?= <mar.skoda@gmail.com>
Cc: johannes.thumshirn@wdc.com, a2jphilipp@gmail.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com, zhudongjiang@fygo.io
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations for conventional zones
In-Reply-To: <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com> <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
Message-ID: <d8a44fc376348da4febd9bef5d279fb1@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Nov 13, 2026 at 05:16:50PM +0100, Martin Škoda wrote:
> On kernel 7.0.0-42, writing large media files repeatedly produced:
>
> BTRFS error (device sdg): cow_file_range failed ...: -28
> BTRFS error (device sdg): failed to run delalloc range ...: -28
>
> These errors occurred despite several TiB of free space being
> reported.

Note that these two messages mean lost data, not just a failed write:
cow_file_range() ends the writeback of the range without writing it
and only sets an error on the mapping. write() and close() succeed,
and only the next fsync() or syncfs() returns -ENOSPC. Files written
around the time of the messages can differ on disk even if they read
back fine while their pages are still cached, so it is worth comparing
them with their sources after "echo 3 > /proc/sys/vm/drop_caches".

On zoned btrfs we hit exactly this when reserved_active_zones goes
negative. btrfs_can_activate_zone() then reports a free active zone
for data although none is left, so the allocator neither finishes a
zone nor waits for one, and find_free_extent() returns -ENOSPC. The
conventional zone accounting fixed by this patch and by Dongjiang's
series is one way for the reservation to go negative; relocating a
metadata or system block group with balance is another one.

I posted a series for this:

https://lore.kernel.org/r/20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com

Patch 2 treats a negative reservation as zero for data, so writeback
finishes a zone or waits instead of failing, whatever made the
reservation negative. Patch 1 fixes the leak by balance. Both are
marked for stable 7.0 and later. They apply without conflicts on
current for-next and on top of Dongjiang's zoned-fixes-testing branch;
that branch fixes other sources of the negative reservation, but not
the one from balance, and doesn't change the check for data.

> Could you confirm whether these symptoms match the active-zone
> reservation/accounting issue addressed by this patch series?

For the -ENOSPC in writeback I think so, but from here I can't tell
which of the sources above made the reservation negative on your
filesystem.

Thanks,
Mark
