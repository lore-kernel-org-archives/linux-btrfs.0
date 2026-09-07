Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACE1456E0F
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 09:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775121; cv=pass; b=jCAVxiydml6tk8JU/X93ur1Dns9gKNMbBEORpVmWfGaXCrYH2utXEC0w2eiH0CFOjOReS2zJIQkFjU/rhXAZqKT7V0Fp5LEFECrv5hYOO0bWQUNzCVU3lAcs0XrJg5IUq/gDk4lVAQ0F1Q1EZxRr3r2XQ2DfcDv2e3kdjbXKozo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775121; c=relaxed/simple;
	bh=vFc5gFFLnSdg3AHEZ9ahwwZhUTlpVkHewZfnMYHb78Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkXFs4pXpajoBekVkh1rHGx3WmsHf1sFJXVFs+pcvYxaoiBmeQ6t6PXnnuFQtIAGbDmk58KQaH29Ab9o68rJkFTE+kVsRw2sJ233uNDkjrw3qjHTV2OrrKjVak2XuMEeod7ukk+u3YYO8vKAQ/9c3tSvkPS7hi4O4j2CHL+2aTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eIe2kkLG; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eIe2kkLG"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48436251906so3818679f8f.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 02:58:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788775118; cv=none;
        d=google.com; s=arc-20260327;
        b=gRB/Ue+M8ntbZ0WpcvVyVxan0mSZFqbYITLvu9PyTgvT8Zr0aHSPxYf9CLKurEnnEr
         ZxrePAP+u7F+i1UvhUJaeMcNQyQZAFUVVP9tzTF74ebOdW0E4tT5SF6p5qvNqWlbkH8w
         U1T8SWD+ku2s7iUqUQOqioBLPonjfHPBRVpdSU+HKt9t50Ke8HenWScc2DxacWzReIgG
         wsdJRM4681Jbr6vVXwrhwgQVlYdi6PaPeYLf0PbTj0JPiT6RYaRk5vc/D3hHMEQwK3Pk
         VVeiHqgC4XSeAcfRrt1zzkM3XxWyhAf/vqh4e43CHUtFJLTlog/aFGeHmrxDU6HG/8oH
         m9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IOR22vO2buc95ubW6uNPity+sc86JUX58sOwMSCA/sM=;
        fh=Ia1vuqSz5oOBMw2aj2MAvgv4GZkr6QcC5BviMIMYc1w=;
        b=bVZkhXJ/ARCGoNUNvezinh8Bav3aQpm/s1KdCDC1tG9C30qnAsHVeemK39FAxredH6
         Pj8TjYNIKaVAtj8ggr252duL3LWXOWjy3UQIHgvmbZ1JHjBcmXO8yhusBfq3h3I/QsLm
         mFCEr0jfpXvKZrD8z1r1RzYKiBXkl45HS5rwotXthdoNLfHZW9e+W5PP8KjGhjOQvW+8
         SFGBCtBoE/LuteWfC0zWlJmcKs2m9G8qMKbZWMonBWqG6S0QpDrvCgP99+iQKniRVabB
         7OlMeAKOYzxmZPZX60fclN2SPW1wVydN1g6XZjWhRXze4r24XLpLdp8jkwhzenSd+qVx
         6lHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788775118; x=1789379918; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IOR22vO2buc95ubW6uNPity+sc86JUX58sOwMSCA/sM=;
        b=eIe2kkLGwC5S6RZiJ34kzVZEPTvciowqzfElkw7LPg3yeCwAWM5Szl5ppK2rh6PCkZ
         4VCdcHSc9blH5eorHCHmguejQyEYz7gRECoV8/4ySgz+hnKVGQMm/wkrbwQ73JfG0B1R
         gl0fCeZztgSMyPNIXiBRrUZi6uPb8tNKiZ79qvBiatUoBuPjMAKQ5N1pdoW6OXaIpKt0
         AUpaDc3A2Dy2KGHxS0u3b8sh3/Pw0opc/GkW+lRdeMqtC/J3jwXWbmHX80bPWoyGhIzD
         5Q0TH6Zwuov613iTytJetsCcDDcodmmTTj5DnNV12J+I5rdIc42d+YfT+DvqYy0RYMeK
         WFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788775118; x=1789379918;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IOR22vO2buc95ubW6uNPity+sc86JUX58sOwMSCA/sM=;
        b=G/LSSIRspC3P8DaS+XzmyIbC2D0CJ6is2gFWwkFOQdfBLsttJm4QCQzjmKrZrWgFLX
         7xk1c9XLK6/g/PBqKfn1jXpd1GP+vHAUVjMVSKU8ZgwbFbYC/qt8gUhYT56GMq9ocnqO
         EVw3lOuM3QdUZHFxlNw7bSgmXznDuLnwPAFM6/Md+BnsUjPVKDyJqbQEIUHphLFoMNJX
         xfuMdRwx3pwFotmyPMmnmM/LYkn9vRSTDB0vq8f7QdJr7E3v31L+tRgyexM3vGGOA4JT
         my8VL0XvYGFOF5cEkWABUIw+ll5Rky5wl6mX8dbuUPyv5x55WFIJ98yjj5rQqrtiI0yH
         S5Uw==
X-Forwarded-Encrypted: i=1; AKwUvBwt2boZ8bGdhtfUSBf/rziffcLYuHqV6gL3Y99XgGGWRjerjD+RVE75WluVn81kn5QUlx7NwRk3Atk+nw==@vger.kernel.org
X-Gm-Message-State: AFuF++min9AmgDquNacCXxydcuV7Pn3uuYDIga2ADOmfLj7RPQWpIfhN
	u6rSfNr1kZzoqScejqPuxT2JLeR4qXErXMHQlLIDXbuK0s9PoOzgLRCcEdRQPYhZvK42TaZLCNh
	Za6opiiZqVVFkHi2bzeHn/4ZQNa8rdg0ZbjyWvcgrfA==
X-Gm-Gg: AYBFou2L/7PCvbtvtmLB3oVOacl3QaxT/jSt4GTax9T90TcFSUbazmcf/D3YyMSh2Om
	Q6G18ZVo0kpW5zVXrYyiZw3Ct9urskk12e2F3Ea61LVWzGiw2V0jhDQYKiTkzoGu6/6c3wP1KLA
	rqlXC32BcmIt+F9BGyAvjs0F1DEQjv++349HQQ8RkBaOyID7LP9QzAAZKiRFKvFM0L8bzAAODZA
	+pYXMExxnOBrBA5lRhiRCvyi+tGnnns2c1JovmG5hD34eYQhMY3ycTwuuwQ8cTE+osEfsBmEQHL
	1hgrsCfPRcOu83tI+7k/ZgF4aG8zPeCaFPqe3SEFaXv2iewJsUitdXHWOyMKoQxYZ2CjAxgWPY7
	tgjjbkKrfCrd3xuc3ry1259diNugqkLoGPBNK0WMrnw==
X-Received: by 2002:a05:6000:41d4:b0:484:3310:c4fc with SMTP id
 ffacd0b85a97d-48587090793mr45075973f8f.23.1788775118342; Mon, 07 Sep 2026
 02:58:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907044801.9088-1-hemanth.selam@gmail.com>
 <CAPjX3FfQ4X4Bd-1-_Q3h4azLM98vnJLfZ8TvduPK6zf=y==Z2g@mail.gmail.com> <20260907092247.GP9053@suse.cz>
In-Reply-To: <20260907092247.GP9053@suse.cz>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 7 Sep 2026 11:58:27 +0200
X-Gm-Features: AcwNN1WxUpd2kv3I_DLYS1Vwd5ZUE28k_Gsdkb8CO7N5z5kgblu69R3OgC2-Lkc
Message-ID: <CAPjX3FcQ4qELwCKdfvrP5F=tiDu9zLztfgF2JGoAuc=HoK_k_Q@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix typos and repeated words in comments
To: dsterba@suse.cz
Cc: Hemanth Selam <hemanth.selam@gmail.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 11:22, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Sep 07, 2026 at 11:15:33AM +0200, Daniel Vacek wrote:
> > > --- a/fs/btrfs/raid56.c
> > > +++ b/fs/btrfs/raid56.c
> > > @@ -953,7 +953,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
> > >
> > >         /*
> > >          * Clear the data bitmap, as the rbio may be cached for later usage.
> > > -        * do this before before unlock_stripe() so there will be no new bio
> > > +        * do this before unlock_stripe() so there will be no new bio
> > >          * for this bio.
> >
> > The sentence should start with a capital. Perhaps it would also fit
> > into two lines?
>
> Reformatting whole lines makes the typos harder to spot, so it's fine to
> leave it like that and reformat at commit time eventually.

Right, I see. Sorry about the noise then.
