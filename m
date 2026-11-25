Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795608653;
	b=1hQJNoNEF6g29O58j4CA7deN+t4TetY19sJFf2ksNV/iHWO+iPGo5Labph1ObC7/Ljge
	 QFxpEJjnOgHLPXafs5Crqx8ZbrEh/LwMgQPicUp6ihRPV1t6s0fTm8nvaU1V7FuWJAb+K
	 ibM5jyu/m2E/SHLFYZ2K3UEy3oJXht+cpcJ+EbCb/rcPf584PORUenrEQ+dhdnmg1SFUm
	 fRQBQaL4ojakJDm7zOOvfoID15scGVR9w1Q5lbXW4tHvl3eFTLvqdNj6Cc3eINXGjSYQb
	 hDiYc0gcsREEkvE6d1YO0DyFrZ+YA4RqN4vykD3TBR4wTRzEqjf7Ld7sUEu8ALfXsqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795608653;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=LWb7x9EBTg0j/7GQyDH3uQu9AojkX1BlUOWBWzqCl+c=;
	b=rwkevLNVhu1KkGbyFLUKy+mXxhSPD8H7OGwgl3rKd7TWPO1YD17dBOS7XUW/y9g67PU5
	 n8s96e+3F2OdVvAcKEi2gHH+Ment/1ePKyOy+/P78y9SAGQ4kepOjveMffx89Zj3OadX9
	 JpflMDeoomixKelilCIhUy2KO6Cy6/N+CCX8+OoHzvKgzdfrGg9V3s0iXtI8waGO96Bhh
	 2T5qbz3yqrzzwIz1It3oLKlvl3S2uuseW2LJAh7YFZ6gO9nOFe+cup5HQxYfn7ZGnt0nF
	 hzxyF7TGuw+SQUWxYq7ML1z4HZHnhLmi40r+7Uu1FfC4uuMQor4Nycf6qixMfoWeRGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Hlrgd6M5;
	arc=none smtp.remote-ip=185.70.43.23
Received: from mail-4323.protonmail.ch (mail-4323.protonmail.ch [185.70.43.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE9606A33A;
	Wed, 25 Nov 2026 12:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAEE9606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Hlrgd6M5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795608649; x=1795867849;
	bh=LWb7x9EBTg0j/7GQyDH3uQu9AojkX1BlUOWBWzqCl+c=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Hlrgd6M5fWgdq2wZfvL0HISkaCESdVBnmvtv/mMV8DnAxDuE+UAARFiohhVdGAUF6
	 XkdXpy5zSw368pCo0QvUi4ePaiT41Oiz/pxDAcKxGkdp8Ct7emHoTZayOWqGI7VgNv
	 d1nRkj9XDARvsZPIuHmmHp+4tPS/ddYRoXp/0yka8auDGMC03ALA927mPKor79a/CE
	 fqEuqylENwpN8Cur76GP+2hX2zvu5TfzqoAbVAVuNgrA4e0QMADgBtJGyrYXSNE4D1
	 0/aJiG01fI7o3pJD7Nk3dqYSFMYhjhx0qBLQXLCHdCFrLxY1zjKht+3miE5jcE9qLi
	 mM6qbObQ+/Ccw==
Date: Wed, 25 Nov 2026 12:10:46 +0000
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
From: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix NULL end_io call when submitting a repair read fails
Message-ID: <pUOGik2ZGgsXZ6_xplgbkkSeKXQm1wwrx5BFw-xBu_N5bfp2uUF7CrWvIhwGmE0YP4Kh-ZxuUeTW8ank4aGU7RbokslJyXRy6O9gbl9-C3k=@raidlab.org>
In-Reply-To: <596650a4-62c3-4668-855c-3b503912e74a@wdc.com>
References: <20261123175633.2058431-1-mc@raidlab.org> <596650a4-62c3-4668-855c-3b503912e74a@wdc.com>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 5ec5a27ffd1e5eab557cba280be14e70cf8989b7
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

Johannes Thumshirn <johannes.thumshirn@wdc.com> wrote:
> Maybe I'm missing something (sorry wall of text in the commit message
> and 7am here), but isn't it enough to set a dummy endio (like Qu also
> suggested) and then bio_io_error() out?

btrfs_end_repair_bio() has to run for the failed repair bio. It
decrements repair_count of the original read. Without that, the original
read never completes and hangs. It also tries the next mirror. Without
that, the read is not repaired from the other copies.

I tried a dummy end_io with bio_io_error(): the read hung in 3 of 3
runs, and no repair read went to another mirror after the failure.

Miroslav
