Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367790;
	b=bvija18eti93eY/bpYoekrTNw0CqS1wW1Qv8Tbkn+k4tFc3DregbpCq5KAdczoDHFIPQ
	 AfWfNnAd5x8Zicb5jWcoLkApDLtUxtN9dzv4/iyHiiCp7RVD3VbSNl4vFV/yl9DnaWmf8
	 x4isnfUr8bQYU++pjJ+StovUaLLn8WjVJLtrfh7QhyH22Vn/FLxBFYomSz2ymeNo43kcf
	 Qm6jaaVoqRubItstcJXGS9PMd7tjGMXSS6f0BrEtcPQG/eQZs7zrc8Z0gvSfylpwFSAek
	 tlppgG4GRyAVAk3+ryxDX1o/jc8KLefoJbYmXsgzVfBS8N62R1tAyKTQiiJCnsG7jIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367790;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=8U1bFnTXuoJQsqWekFfKi+X2o/ZJhZ4F/U+nC/6Gs+0=;
	b=ATx83teeEcpbvVkccJTntGGlwfnHL6kzXbup0gZWZUXMH4P2DscuzhXb9dDIW9utGyDl
	 zb9LIL6OVYa44f85Oq4b8W6lo/0Anat1PCcbRIjs6pWBR1Zo+b/lECVruS+G+rP5UL8X0
	 7WYxjS49j0TDjktmFXAkBgnR3Pa7aLsrcLTj+XflcdqtBcap9T/Sz7nqfk8Eilwyd5Rrx
	 CyKg/dpkGBdvmMjABO630rW5jYeBgBIgY59anaqLCdjWwH7yc30Anmqe7BUjJdwurbO/5
	 g6Tuly34mEZLr2rYEEi18/Ve1c/3B8Gk0GRLc2pafbOhy6+0Qd47KV7LcqMa1Nwn61w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=RzaeP9QG;
	arc=none smtp.remote-ip=79.135.106.105
Received: from mail-106105.protonmail.ch (mail-106105.protonmail.ch [79.135.106.105])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45644606A32C
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 17:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45644606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=RzaeP9QG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795367786; x=1795626986;
	bh=8U1bFnTXuoJQsqWekFfKi+X2o/ZJhZ4F/U+nC/6Gs+0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RzaeP9QGXINabKpuBuVOYYZrLOcCkDmifkK2PITQiW/9AGuzfSuzstUUSTusoPgXm
	 QAh1K3Ct4uWvuOK75ssSNwYkaKgsSBH74W0m9IyG4SSx1kvLs69XktcyATVeoW7RFG
	 fX/numcrBRXD+4K967hWMslFCg3HaxY17EE4PuXRXLK3KeYWW19dfhbG/newEXcKBh
	 dzDCK+T5zbV7xbvmDtXyHGaquoE2JnM3EY0m++dTulXeuAQfqRu6o5odB6C4nMIYvB
	 JScyAReanQuTXc/FpGq9fTqfS6fHfUHCnN5nsZxqiud4DHwN21sGfLF/R9o9tC3Od8
	 /6gfC98mqzXJw==
Date: Sun, 22 Nov 2026 17:16:23 +0000
To: linux-btrfs@vger.kernel.org
From: Miroslav Cimerman <mc@raidlab.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: activate RAID1 data block groups on degraded mounts
Message-ID: <foe6F1aU4e8wzAQ9xutXb9e9aI54SvpmBRPq-wMsmOGq-QvfrROq0xD0dkgCzGqKd0nChQHuZdQ7n8xUfdH6uzBVi9Lg1YMsWDh1BiaaZ_w=@raidlab.org>
In-Reply-To: <20261121205657.1108500-1-mc@raidlab.org>
References: <20261121205657.1108500-1-mc@raidlab.org>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 4105ca408a15a6f809241b5d4e84395802daa46b
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Miroslav Cimerman <mc@raidlab.org> wrote:
> The last copy of a
> mirrored write is a zone append write. On for-next, the other copies are
> regular writes: btrfs_submit_mirrored_bio() sets them up with
> btrfs_bio_init(), which clears can_use_append.
[...]
> I will send a fix for that separately.

The fix for the regular writes is patch 1/2 of this series:
https://lore.kernel.org/linux-btrfs/20261122034826.2333981-1-mc@raidlab.org=
/

Miroslav
