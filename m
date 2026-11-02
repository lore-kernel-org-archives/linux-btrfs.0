Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636952;
	b=mdJdbaFouCraPKWxJMY2vUowQ4vKfSasRCe/KQRqwnC65z/aEVfZU3UlzaJQx9zkAm6b
	 F0RLz57Ds2eHNkcTzaxLo5cdLYEeXfNFji4lP+vrwEPGJMPXcUMNyhZNKWoCqwOK3JXD3
	 SEJIJHioHyuRKQn/UwJCIIvqwlCpctYzO1s8l4Wwqi9grZWGHX1DFKfY8uOc67k6rh1BX
	 +jjmlKsk5So2Ze5J3seWIo2dpGxiWEDu8Ttse8N24vovDDYw8izNCOnddGqHUnPO7IC59
	 D9uAwvfLgyNijINXaeJqsOtArKiPcQtHImweHJkjeWGmVcVzNaV35OAwlHjVO3fIbag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636952;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IOiMng9RZC5ZsHueklZu31oTVbf21Mt0IXmlLvcfDKU=;
	b=RZ9l8BTNbtm9234FQ24REXvMkK6A5m0DQVhh6fchw32c+WEe/NQ9rG4rCZeaKmxYbF3B
	 RqgZzkeaLk/8I+xwmJ8qaXVMLpp7GzSTJO6ND+w67opaaJd3Rr7B6cpafk1BAoNj5Eyl3
	 EcO5CepTwK4l9Omt4wErJAVGbi+bOOUnLqqTZJTNc+nilfgO4cLkiHsQs2ABEtcFNN4dj
	 3w4BftJz4ssl+uUU0jsB9Re0NZh2rQ8qNIDtxbnWIZy9MO3OqBMG2nLLgdkE9N0CC8ji1
	 2Rt4YGrrZ0VpFPQY9ZnybhGUw3XhDkS3VX//CNyxk4tSpOUOMDu6ZKc60LKBkLsuArw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jhgj9Hsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8249C606ABB9
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jhgj9Hsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B121F00A22
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793636952;
	bh=IOiMng9RZC5ZsHueklZu31oTVbf21Mt0IXmlLvcfDKU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jhgj9Hsk/pWSW0JNuD8gX/AgK/d+vsH0olhOBy3YqsDBZ9idYURMpqnvEsCav1U6C
	 QWZAe/Pzj860mO0lbTSotZe3R+0hAZ6cjmDnypZfNBm2xFK93vvSgiNAweLNopRkoX
	 9j+ORfW0JF2G6hIHU1eFQwgZDY//chJvsYJt91S+0Hkacmo0TXfo+lH1Aw4/zlYQMD
	 zpgsj0Ric1+KOK1XeMU9Xc2tKo4rexzRCIHN86Ucbr2s2qNqo7Sirj59Ap/xoYCi8f
	 sMijI6YGlbBe/SCyYwVgJyYYJh5O7AUWMI4pV2/OpM6SgXY0sKqaD9wfdlvBYyJA+h
	 R4MS4Y2tFa+kw==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eac3b6b2ceso700751e0c.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 08:29:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwd8b9+2TW0pfDcGiTGEF6baTdSprCubSz6jvXS6M1lMcp4oRyu8B1+XH112Nr+Qo8oTCRqFHQTwM/0rw==@vger.kernel.org
X-Gm-Message-State: APuU4Z946SaEzP5q7h3LMeCRUutloZeAJerGVon1SVKWFhbYlDAzabe8
	CXiqvzRv6oG4dDoJ/kzBPLnf5htF2zLjXLmaCXSkmkstaRGz4ENsx8909OaYrsWHxgTKUG28fSo
	9b75vKXbJ8QkZrFgjI+E1JLC7y5KVHuo=
X-Received: by 2002:a05:6102:50a8:b0:7cc:2bb7:1321 with SMTP id
 ada2fe7eead31-7d072715882mr3923901137.31.1793636951321; Mon, 02 Nov 2026
 08:29:11 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-5-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-5-f4d4196731e6@toxicpanda.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 16:28:35 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6vCcysZasPMMgLyuCDU2ejCV4PwbEDn_oN-eNdePU_UQ@mail.gmail.com>
X-Gm-Features: AclHuK_9b2GWogEgG12V-2vwKZf19vf23a3IVQXLAo9Or9iJQQ38_LkwhNYOFCQ
Message-ID: <CAL3q7H6vCcysZasPMMgLyuCDU2ejCV4PwbEDn_oN-eNdePU_UQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] btrfs: don't trim the target of a device replace
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 2:40=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> FITRIM also discards the space of every device that is not allocated to a
> chunk. btrfs_trim_free_extents() goes over fs_devices->devices and, for
> each device that is writeable, discards the ranges that have neither
> CHUNK_ALLOCATED nor CHUNK_TRIMMED set in device->alloc_state.
>
> The target device of a running replace operation is on that list and it i=
s
> writeable. But its alloc_state is empty. The allocated ranges of the
> source device are only copied to it by btrfs_set_target_alloc_state(),
> when the replace finishes. Until then the whole device looks unallocated,
> so an fstrim discards everything that was copied to it so far, and what i=
s
> being written to it in parallel to the source device.
>
> The replace finishes without any error and the source device is dropped.
> With a single device filesystem, 700M of data and fstrim called in a loop
> while the replace runs:
>
>   BTRFS info: dev_replace from /dev/vdb (devid 1) to /dev/vdc finished
>   BTRFS error: bad tree block start, mirror 1 want 30638080 have 0
>   BTRFS error: bad tree block start, mirror 2 want 30638080 have 0
>   BTRFS info: scrub: not finished on devid 1 with status: -5
>
> Skip the target device. The flag is cleared with the device list mutex
> held, after the alloc_state was set up, and the trimming code holds that
> mutex while it works on a device.
>
> Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
> CC: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/extent-tree.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3..22155507f905 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6641,6 +6641,14 @@ static int btrfs_trim_free_extents_throttle(struct=
 btrfs_device *device,
>         if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) || !=
device->bdev)
>                 return 0;
>
> +       /*
> +        * The target of a running device replace has nothing in its allo=
c_state
> +        * until the replace finishes, all of it would look unallocated a=
nd we
> +        * would discard what was already copied to it.
> +        */
> +       if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
> +               return 0;
> +
>         /* Discard not supported =3D nothing to do. */
>         if (!bdev_max_discard_sectors(device->bdev))
>                 return 0;
>
> --
> 2.55.0
>
>
