Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589410;
	b=jKRQyzXr5bOvaeULFcUWbQDSkklN0mVIIqDcBRvQPbPwzaq90pdNIovjMFXvtpWwkWI3
	 k+4bGmZN5aGF62JLzn1DBlqmRSCjsEQaFISySIFBabxrYw5ti51uNHoCQTTZre2e4W4J6
	 ZXIWnQXDTUjwwf9v4VzPagP3D5hm3Bg1TNFZrtI2k09fsNj0o7iftZbML2QMGUu1paLw9
	 a3L1DcfZQfroGuxYoNHGJDdItbCUhyy2n/QO/XOfobBmXN4xCjtuZPjMUl28Yw4q7fTkf
	 NRUWJE9vZb5HEpP9WbvWq9Vib37zLs1iDvVV4w2cw44EyMRISJPPqYyKvb1iYIEWG4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589410;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=AfK72WhEOBzn3BoWfe/Pyz2BlBwexf2lHGktNF+Ga7E=;
	b=soNqWQ9UfZBEIyPDYJF9neVNheo+zU9ddIxDv9e0BYKeDjxNLiY0zCzGywUqsVkGRaPW
	 ohkYkZ32DOG+beWSzF4gOuoGTVFjg9i7dzqJRD63j9YEzyDmAvzJMUL3R8fKBDmU3KfDu
	 /CHvVlAEP5lz1m7LfnRjkjeXXnndjnAl/15nMmnHLEQc+Egu22BwDuFqE63RDv76qzy+K
	 kMmshqt3E78PBtyCOSDiZd5fK4Swuc6VoMmIqPSo7Vjq7ipPUQ/V8HHwZF5ZUmvERPvub
	 Ohz9sriIolZD5diga4H6opgFRfZ23WtdTet4SfUuT/tz+zgCFZpCgoey6Y9/fmgbTRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwPmuS6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9B0606A327
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwPmuS6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88801F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794589409;
	bh=AfK72WhEOBzn3BoWfe/Pyz2BlBwexf2lHGktNF+Ga7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AwPmuS6zGREbjnzY2h+u5QhMDzhoiD2sF+yp2lgjA/HRytn0JGQQSsXrLKZ5dXH1T
	 KWK2qQKDMyug4tLNT04NS/zUBE7bnxgB94kXEJi/gRJAv/lrruII/ozXSNxzfJTL0y
	 VA/9L/mZ41A//ub2dNF3GvtuTgWHXt4N+jKlu01Ocf8JDnipLSKyoa0qrLnjt2Q+bB
	 AeUfIa9/Z18LGAd2bXjnefycNXwY83FVumkTvhsdBvXkbnvC3w9gS+eYQ/a/ioMdJ2
	 7wv4pQXaKhIDD5+AZURElPW7VqUAw4EgNlrjO8rLK0BMMiswxz4Nd3OiWtnynq3qvn
	 EsiWxlqidbytA==
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eabf243d05so437266e0c.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 09:03:29 -0800 (PST)
X-Gm-Message-State: APuU4Z97hVFtnUczqulVTbMrw01oFtgvc2dnG+5JAzSg7ITlAqcF3IEd
	xUHGEChoI3ByQjLxdXGAsklTgS/okq778hu7cPl02ddhq2KR6fYCf/HzFoekN1/dHCd2HBnbCZJ
	8vEQWHoqw9ko9wu7rbcN25YzVXF8TStA=
X-Received: by 2002:a05:6122:1c0d:b0:5ea:c51a:37a1 with SMTP id
 71dfb90a1353d-5ee34a45534mr903717e0c.8.1794589409113; Fri, 13 Nov 2026
 09:03:29 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794461116.git.wqu@suse.com>
In-Reply-To: <cover.1794461116.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 17:02:52 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6-A-pPHz0e3urkGzNkOUVBg5poVnZh8Miw9MKG97gwjg@mail.gmail.com>
X-Gm-Features: AclHuK9zV1PsnilA9kc9abNLzw9CJLXrdpW3vsABAoWxn_c3COLWzqO46EvnTFU
Message-ID: <CAL3q7H6-A-pPHz0e3urkGzNkOUVBg5poVnZh8Miw9MKG97gwjg@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: anon_dev related fixes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 5:29=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The first one is a Sashiko bug report, that we have a very narrow window
> to hit an anon_dev ID leak.
>
> The second one is another small bug related to double freeing the same
> anon_dev ID, exposed by LLM.
>
> Qu Wenruo (2):
>   btrfs: fix anon_dev leak when snapshot creation races with a root read
>   btrfs: fix double free of anon_dev in btrfs_get_root_ref() on -EEXIST

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

>
>  fs/btrfs/disk-io.c | 13 +++++++++++++
>  fs/btrfs/ioctl.c   |  8 +-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> --
> 2.56.0
>
>
