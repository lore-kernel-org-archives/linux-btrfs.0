Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903B74611C6
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774995076; cv=pass; b=ggIfMttLTlNMBjDsfJQi3faZq8s9qkNdMRroBuhKBab/HynuXq79WhmVmjGFqopLQjcdpXGD08S1QLAKGwKe2ziwDQSnS+ma1v+GY1Aih3bt0VImzkK/ACuOycPbnmOCrzF6ng1Cq9QaNvJmVqxQJJ+RhuG7EeSsup/44QEL5bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774995076; c=relaxed/simple;
	bh=rbcK7U4deeKk/ZVFQfzqhYBTK6My62nih+XsFg5UK58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbujHZpzVRP+wm0oFuQATQnljkH4WJnrp2cev4XNCP9CGcKwEIadVSHV/QBJcfec4MAgnfc6bt/KcsQTNr5t+FfsL/FLjlRiIaiYeQLNk7vma/0i4vDVCkCL8fRli//cTpeE8RbUWNpI9YlBNTVrzaxgiY8bd4HxX3fOKsHRfnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=LQZtDLmI; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="LQZtDLmI"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7966d747c84so3863207b3.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 15:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774995074; cv=none;
        d=google.com; s=arc-20240605;
        b=L4PvCJLlCRm2xvZV2N2NR8J5bVofKB+m94l8jKbYnfbGFkRatcCre7/gWdwlYrH9st
         2srX8oyPSjDiWblhXbBZnRAU8kBJNrfssM28VoCIDxqpIbl3akkRBILhdjts1oWc51ZV
         vghqtiuvzXcgRJqKRhWc3SYz75wf4HWudyKOw6bObkbKCqcDsOI/duoZlKUIivn0B6xU
         60EMR08Z8vraw69U28LEJ5W7a0EMyuQx00Tg/YjcG+HDOWju+EZRoTIgrIHIF3JmSU6d
         TveyjuSs6+9/RSWJo5AKIMWr0Qg+cIYxSmq/UbbToxe8cWXQs5X7PyqM9yKlg5yCJ23W
         Phkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rbcK7U4deeKk/ZVFQfzqhYBTK6My62nih+XsFg5UK58=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=f5vGRU+QmVynHr/hqErfh7EhB0ZAgT8wFJIMyjTyvb5EG/295mMxgEJtWE+jagDEzs
         04fSWIZ/2mVF6+u1FrvhxedukvKluglHB0nqzLHpMQSbKxq67NyVtuu/vpH5ggWid+JD
         8ZLtXE3hlNQ5z0YES4+xrSJXvHKAiKw4Aqkx9+EcxqFJDZqnq6s9EIJbslW20M9bk05J
         +vCR6uerz0ib1ha5mwD5Sl1hMCt8r/gKCIX4Gutf1z8+oLT5m3xNKXjXjSllLN22facG
         hFADDjUGsF02luHyR+Qe3BG9oWGDvkq1lYmg4/EpLSMLdCEtT1o2rUfxrHYrlxPlwn5O
         slXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774995074; x=1775599874; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbcK7U4deeKk/ZVFQfzqhYBTK6My62nih+XsFg5UK58=;
        b=LQZtDLmISBaL5u05DXxCWG/BOnIFjJi2WcPrLC1rlCWnXGqjHzzkU+jiFhNbIG9G1U
         wt11C+gsjj7qnljCGK8UVskTlaZo1N8LanRr754tP0VLu6gC01ljOFbo99+dWX9BVizN
         WUGZZKOEig13wTpvAYM9CmXOthX1+hi+JbtojLu7dYzNliSSsRMrlcMM0H3WkXo3gWVH
         ZjNvS3rS3s7AZ4ApuTRTyFHDHUGAzLz2TzXP8LjIjNZu3wAoeINtsng9/IKDRN/wOoW0
         JKVQ5kdxJX9lsMV9AMOpNEexgIKaZPigYIMg/HsiI9jx/c3LTSSJBy/QDE8q8gvBLur6
         y+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774995074; x=1775599874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rbcK7U4deeKk/ZVFQfzqhYBTK6My62nih+XsFg5UK58=;
        b=htzpAl7JhOdlAQD2X/9BfLrlCcC1jwUjXO2Fch6rZV94b4LLUNj3Pd6nXca2iWPDZW
         a+E3vuRU2A/rPJQpDrC7P4xoirCt/SHhbTH+MAOB/FzXiIoqmhBWhSAyuhA7moV24Hy1
         wuW7y6C5tVz4meQo/7IXhxPgoaFoiFkB6r/ZPTN0IyyelKXu/YX7ebczLkB8Cd065GsH
         7Ws/nDFcP1H5UmfleMmcUKjdBHDbQ7f3i73z5EEAkCNjb/Eo4XKFCUX5xqaZiLck4n+a
         tlgxvrygBqAcEmgnnoA8uaoKn+td3m892iofOB4pyPAX5EpI2AQ4D1Bno5mMq5ZOFcmt
         FN4g==
X-Gm-Message-State: AOJu0YwLBBo7x8BIP+OLUHIKSV5Y+qFA32U79lS9UkFH5jBJhtZUZO4L
	ysARK7k+xKbzbT87wF0iQmOt+q2s+y7p39k3sqkg9vcGG3ABuQQ0UGct/JsRFe4qR/ozj08tq8F
	dPv1sQ9RxNaC+QG1GeiBXDDC5+4AxQAhEjnzGLWggMmrKbo0vo0sVyrQ=
X-Gm-Gg: ATEYQzymRSBadLxh873fVXUKCkzG/vRpMAf2bZ1NbYLOWj27Gausf0IM1JO5PlkZg5c
	fyl0TSXa8hEUzfLSsiJVmtaAj29krVNsthtjryqZl/8ztifbI2DHdhNdq8YoVZNIgx3E5o6ISHa
	nwhZReIh0OspWhwc12GZBfmLybocxjs6LLv++2szvvpjYkKmeutsmOcU3ZUj0VkrNlEQdcdWP9Z
	ZggbDwaNFl6bLRvrtuR0j9uZZad4E5RwMd3WmeHRF5RpUndwloPEstLhHqkKIFXisoFYYEl9DL9
	VFOBejuW5knq6TwHEJipqtf9Jd+AdezwCdM9SLC2iAs+ssSV
X-Received: by 2002:a05:690c:4a0b:b0:79c:adbd:4f15 with SMTP id
 00721157ae682-7a20f8f03cfmr10447967b3.2.1774995074381; Tue, 31 Mar 2026
 15:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com> <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com> <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
 <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com> <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
 <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com>
In-Reply-To: <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Wed, 1 Apr 2026 00:11:03 +0200
X-Gm-Features: AQROBzA_m_uv8YZLB9rJM8G8kYIE5srP__yt-labNTbqxzrbdwWpDvK7HYLdBZI
Message-ID: <CAF1bhLUGwb17jVD-7cVqA1OTRRRYbt_ow1+GZYbFgChN8mdKtA@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 12:07=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 08:31, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > On Tue, Mar 31, 2026 at 11:58=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote=
:
> [...]
> >> My bad, I forgot to ask for dump-tree of dev tree:
> >>
> >> # btrfs ins dump-tree -t dev <device>
> >>
> >> Again it's fine to dump it from any good device.
> >
> > No worries! Here it is: https://transfer.ddvtech.com/pY3LV9yw1L/dump_tr=
ee.txt
>
> And the last one, from chunk tree:
>
> # btrfs ins dump-tree -t chunk <device>

Here you go:
https://transfer.ddvtech.com/FAXxEEq71p/dump_tree_chunk.txt

>
> So far the result looks fine, nothing wrong so far.
> All device items looks correct, with unique uuid and correct devid.
> The dev-replace item in dev tree also looks sane.
>
> The only next item to check is the device items in chunk tree.
>
> Thanks,
> Qu
