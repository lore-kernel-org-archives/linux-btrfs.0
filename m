Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08E827703
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 12:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266014; cv=pass; b=V7qJ7wdnl6luMXmkBIR3SdvW4vp9xZzEXpv9nwdmaPpKQHq0w/L1+fEBsGcMYLUpt+GIv40V+mOSyg5yi9XX/+rUCQb0EtY0TLQGt7bx62QfZ+5Mq1S1u6rTxfjo1sQIH/e6EkoAqX5APZGs7y824lQzbOhGpA23kCugC93Cj9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266014; c=relaxed/simple;
	bh=tTilPEePkpjTFCruJKJ/IvVnzIPmWB7ZxbAkmTpfbLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PwM+yfWb215etYJOdftaqXjO9X4GuXF5sws+nR8/oFPJQX93XhGm9dAPLGp+XWuXCwXcG41crPmAYBWgeboEW0fueGwFDDb+Sev/EbtemnYWxn8uZNCy4xdSXhOqA450og8D147z/J7mJ49f8/9E8lWyqBigRkHaftwVceJ+60g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LwULko2B; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LwULko2B"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso37016185e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2026 05:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788266011; cv=none;
        d=google.com; s=arc-20260327;
        b=PeZSEXGUcrCt+symB+iya74slTS5il2VinNBwEhpFaggGU4ptr4nWuSewrru6izwjW
         4uKrMfTt2p/+eB85/c5p8N4bnJuYb6thBZSnUAlBtCO0YUnWstKsLOIMwo9KeJNHzfnD
         OZ7pMRN+gUM9wi1nOLay4PsTSxM4QGYlKpI2EfJdK4SD5vpHKmgBj1//Ap8/L2OkI7VK
         RttEpU7uk8C42bKSuf4bCSy6R4T+Q8GFdNJVpJ1NspqrzALJ9ct8EJBI9lVDFLagDdIx
         dhTOCrQBMs+OpQCw/FEXl4Rd+dxOSxN02yTixCqJiTgFmm1kj3So1KEfd2rJsBviy+89
         KEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cfOC0PiJENFhgp3GUEin/fTduYk5GNhKZ1VkMcNkAxk=;
        fh=NOk1bsEuCLNwsTLvoNVSqLGxKpx2I/cUDB7QedQ2DLs=;
        b=TNaw5mZv/V47GdSF4HZeOULH818A6GEYIYpxwZIi8Uxz4fb2mTKZeTh7dlY+oTiEwZ
         SdBYFZYZLS8ME2ooDcw3iQvk35sq+CvuBTTrGcPSNgEsKMu0oLGiqqKCTK+GgLpQjydL
         6BEPt5tPrZffjyq1X7PMz/5XZnXgtTujXmUteOjh9lCn/SD1gxCRyF/CrSxzPNxCqB1r
         ksnvO9iJsjtO6F5ao8N8KqcxGOYJjGFkznwwYPpsYZv88Fb3F0Rf1+Y1GYwehb1ZRyz+
         gtkEMmWj2SLe8W3CBAQ2sIn5Emg3UDIgUz2THCDHfHTNZUCMhWYcNYynifjycDAHBmIZ
         c83w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788266011; x=1788870811; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cfOC0PiJENFhgp3GUEin/fTduYk5GNhKZ1VkMcNkAxk=;
        b=LwULko2Bs2/mrcLVVTaUXuF8PSdjkYkM7/aT0kj3uLwex+mk+2tR4S+4gfN0f9f81f
         y0tITeUFsvdVAIOSundN4TaLgBLXIklaAiLC9FCYq/6oVyvNBCOATTVCaKQgmmkq5g91
         sVSJbFUHpl1v++n4aVhRL0t+np6VpsuFHXngdlrNwy1liHtUPiTZvsjdVx5oxjrzmVAc
         iIgvUafOTrGYjXM+hG8UghqxdwaEi4zYMeWAjKmGSl6/AcwLQ8ywIkVNCj0F8yv5XiOJ
         z6heTKm6E1Ho28SNQcNkp1eU/9ja4Q9ZgktC9cZXnzagpNWsy44ijRIIC9dlo5G9EXWJ
         qViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788266011; x=1788870811;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cfOC0PiJENFhgp3GUEin/fTduYk5GNhKZ1VkMcNkAxk=;
        b=nRFOdo8lnhXJj/DqmsDYJwLaQaX9PlqYjfkr+Oz4g124tx3bPCQIrHlMkrDL3yfIjH
         7OF9AaQ7RrjhNTo3hVJf6CViqShK7QPwolSi6ftRA13NXbwuOlrTxRJekZtTeALDpwB3
         2O4zdhzqnCPfFCiAc8kQt6WiS5OuXqk3g5iTcIKKM9InO0joLi2XukEmcG6qESWsM6uh
         gko7osTEJGidjhPGYTQAG8BwUDiUVHri6TlsbYM1B+dbkRpwaUWEpprLVZtCI0RkvWTZ
         HPaJmRd+T4HLAgBn4QVJDB/+dZQdeV6IDUGF3ffoNqtPgIsiLoLBXHvE9e0qObZ7ry5w
         b4CQ==
X-Forwarded-Encrypted: i=1; AHgh+RoBoo6v0cBr5KTCnppixrX021m3TOjE7TzIjyVdQeVzXt35t7SDA+CbH6yRvklLL6/wgwEVPJGMxzq/zg==@vger.kernel.org
X-Gm-Message-State: AFuF++nMjd9ITgWJgmkK3ypWZpX1Efvuau2jEvvKeVoUshlafjN8mKcE
	v5m9F2vQQvhRFZ6jVME2c9kzlAE7Pd5+Ke/Gvn/jSJURio+0ETe1lY22FtHkCER3YDxIfkg/pSj
	qScJXLSIpKAaXtgdzzBbaK5A8mEAHfHBD0CSs8WlG5g==
X-Gm-Gg: AR+sD100KPLUOI5X2tNj5SRkQtysGqia1/S2Xr+Bir1sDGfyrjEnpeKjH2gqVsq2i2l
	FK4kX9j7GJxp8yWCrzFV/dHiXuZ6hud9Ftu+k/HsVOeHjNqDl7xKJ1q1qcAPuqVOTkodtgVVVET
	FQdvqXeqi1Y/+T3nRbRfwxlWGdVMuGJbffKVP5v8BBwW7bPuWXHuEKjt1w3RRVyi+N6iyd4SqHT
	M2Lf7oxiPFeLgOr4AKyp+QXKVUe8bo7SNdSMoGARmkw975xot0+tH9Bv5ppX/Xp8sC38wn61Gim
	e747Le/xyfdiAjq8z86ebfojUCvaTSmbs8dcZ0LAW40yvVgoObP11nOoqQ0cNc2TBcG5x3noqiv
	vJB/fjzeDOcEAtvpHRerZVhhoInpqfQAqE1OxEoY2rQ==
X-Received: by 2002:a05:600c:4f92:b0:49b:90cc:3c87 with SMTP id
 5b1f17b1804b1-49b91c487b2mr523873155e9.13.1788266010932; Tue, 01 Sep 2026
 05:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-6-neelx@suse.com>
 <20260602024849.GE2295@sol>
In-Reply-To: <20260602024849.GE2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 1 Sep 2026 14:33:18 +0200
X-Gm-Features: AcwNN1X9FeJn91s56e1qLRSgSxckd0pjW883fuhQnYtX531oivm_yi3cZJJZjtc
Message-ID: <CAPjX3FeiYo3XZUuO5qpNaOavwxsVuM_qgs=zRNuNe=bh_cGerQ@mail.gmail.com>
Subject: Re: [PATCH v7 05/43] blk-crypto: add a process bio callback
To: Eric Biggers <ebiggers@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 04:50, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:39AM +0200, Daniel Vacek wrote:
> >  /*
> >   * Supported types of keys.  Must be bitflags due to their use in
> >   * blk_crypto_profile::key_types_supported.
> > @@ -77,12 +85,14 @@ enum blk_crypto_key_type {
> >   *   filesystem block size or the disk sector size.
> >   * @dun_bytes: the maximum number of bytes of DUN used when using this key
> >   * @key_type: the type of this key -- either raw or hardware-wrapped
> > + * @proces_bio: optional callback to process encrypted bios.
> >   */
> >  struct blk_crypto_config {
> >       enum blk_crypto_mode_num crypto_mode;
> >       unsigned int data_unit_size;
> >       unsigned int dun_bytes;
> >       enum blk_crypto_key_type key_type;
> > +     blk_crypto_process_bio_t process_bio;
> >  };
>
> This new field needs to be initialized in
> fscrypt_select_encryption_impl().  Otherwise it breaks native inline
> encryption for ext4 and f2fs.

Ouch, sorry. I should do regression testing on at least one of these.

Thanks.

--nX

> - Eric
