Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164122;
	b=Ed6pfZoq7/LNN5YCko6mOlX3RF8xXGxOAQ+HxglBlnJMHb0/xdmVl6vC4gfB8qPWUU/Z
	 4GVnLKIeQMo8ZYOQbdNwHpSoQtqmAWCXrYX2kOq9UPhWCBjZVcx0XCtQ12Le8mVV3QoCm
	 pK7zlCm87Ubr+Bc8ZsW0t8W4q40Gfm8g5HLMC18dVCI6QmYoNyPcxJH6tSORcLZ3takkR
	 T0j5PD1q4kObrNoHT1Niw0REnYkxFPA7Fw+HPKWRI7hfP6HISplkRY9p0tgZBgbfnsMys
	 hklTGSNG0vpDa2WelOckcNo/a7bot+mxLG2tF4tm2YTIrmwHMm+J7PEvugRaWi79GaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164122;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HyRgedXWRK1X79pl9N4lyhbrJKBVIREWWNT5T9g0XqE=;
	b=2wZG2EuR+3562hZezjAxCBGJuwKdwoMfEO9kz/kPggMrQb9WN4nTNHh65FDuxOnl6ND4
	 wNZlJCyHSZmJETxSMUKOJKi8b5hlYnv7cV9gX8W8/5uMobf+fMMFGg2D5BE0F6tiBxTen
	 bkHS1Muw3R+mnXiYQK1SskG7sO0qY4h1CtqOD6Esqll+hTDokWjmXPuFV3aCuEQKNVDOf
	 072QD2sV5/DKaixT8Ywsg6eOlrUsNVRa+xeI91R5VGhvG4uuDuZPSpUdbMXgg4pLxPibc
	 iPc5CRF+xkug68ImzLQvaAedQ0K8yPlhbVu6AoiC6QVDDRpU3HTlLejocK3xM5GAAdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=OVMe5WA4;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2116606A320;
	Fri, 20 Nov 2026 08:42:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2116606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=OVMe5WA4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HyRgedXWRK1X79pl9N4lyhbrJKBVIREWWNT5T9g0XqE=; b=OVMe5WA4iTacSoZNC6PRrwZnze
	t7vONmL3OUlXbdsOazQguE6XQY5qcoAJrodjBPcR8JwiQp/P/1PqksGPB0rwPyCcbeObYfHmQ+/mW
	RR+gfs5mF2rlvYU+RH9sq8qstQIp+1E/PqRueirVRTw1R8UM6atVvcuvRlxN43hXZHZ7/QuTaq4Ip
	xvlUVYQyLcHLJ/AVFKWRKaRaIEX0QC7aqF4tCcOvRz+bjzLbCh9xhKoYdKVmZ8WfwM4ydPS6Ih7EQ
	6UcJjoCl3pvMXf+LhsfFTDIVXOK5qBfzS6Eco/eWvGQugvk/t5PTemIxG1H/0Ezxfd1NCXWWW2+cG
	2vFQmt/Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUKBz-00000000YYx-2Hp9;
	Fri, 20 Nov 2026 08:41:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8255D300708; Fri, 20 Nov 2026 09:41:58 +0100 (CET)
Date: Fri, 20 Nov 2026 09:41:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org, ardb@kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C
 intrinsics
Message-ID: <20261120084158.GM2668564@noisy.programming.kicks-ass.net>
References: <cover.1795137348.git.wqu@suse.com>
 <20261120034220.GA11532@sol>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120034220.GA11532@sol>

On Thu, Nov 19, 2026 at 07:42:20PM -0800, Eric Biggers wrote:

> So if we're going to proceed, I'd at least like to see a version that
> compares a bit more favorably to the original.  But also I think before
> diving into this approach I'd like wider agreement in the Linux
> community (x86 maintainers, crypto, etc.) that the x86 intrinsics are
> the way to go, and for there to be a path forward for DOITM as well, and
> hopefully some interest in improving the compilers too.

My 2cents go towards keeping the asm. There is no point in fighting
compilers over this. The very same is true for atomics.
