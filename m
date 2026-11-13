Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794581759;
	b=qVJkGyTO9hC6loHIJEMfKphW0F9Drah+R6h8/ZaZpNp9BSzOxGDw14bxrTKd4EDsbGiA
	 k9YrtMDLUXhRzoP+EMGpGmFxyH1fpeIu+q96sJbHV/zsV22JAPd+RVYcjIYPA+EdplZjo
	 rZb2ubsJfm6jCEKUhMWTRW33kRJun5L7HKaztkmmMqm4IeUWahl/HtopjR2xqGYxhUM+C
	 lkQhY2UG2qq456JgCTV3iptXDl1FT9Y2JMyyKC8OCm2+991DSiYbjojd4p3oeyiaDpNL9
	 zjpnqcX8f4fONhnCAExfi1a2U+6R+Z0HWHRouDc2drLq14GGif58It5suzhQrfF/UFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=AeY3b7kqhOBOdDA/zPjfjOGZlqRMWp1WHWEZNT0gXkU=;
	b=0tZmZ8lhNtBFsQR1572p/ZK1werc4yVjzC2r5Ts7fUjPNyZpiZBvQGSU7+o/jg2/7W5k
	 Vq0rh1NNlYaWoIPCqM4kvRgEkvZ380fZiQSAhoR2gdzYZg0wVwpX8kKjxBvdvC38cThgI
	 kGTS886rIBoEG8ApsdxMdCKuJybNEbmQs6rD5wCRHKfqFRqfidSRlXSHbC26aOpKVcZEU
	 3M7eIWJpqcfj4d38fyFFOaCct3eYGppiYruwv7Q6l8i/Fw9sTY1mWbctxF+KMp8mEZLbY
	 W3oTAbjUdnB2PGLz6Kr928GTFI4Iz2TLLqU777H5F1bhzz9wy7Q3be0XSwNLpIS/ihw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pB3VEWmD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C31606A32D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 14:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6C31606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pB3VEWmD
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14f3dab66so1859536e87.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 06:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794581757; cv=none;
        d=google.com; s=arc-20260327;
        b=eZChEVnYv5B0zBKrodC+BVj17vFxnL4/ErRUZsmLfUz//PptM3rT2/+WQV6YxptCJ7
         S5E1jIgqYBwqLSYocDx8hGlIiSmohiVnI2NfxepSmVpupJGl249lkfZtSFIwMP/AgyxS
         XzOV/fD26MRsfOxKBOkrCtUmQ3KWNGtXDpwhlaOAIbRJmb1ZDHOAff8l2IxXKNiwTzwX
         XO9lklwZ4FX9bZhFvZ0xYfbD0OAP8UrGkFLZaMXSr12WWY87c+T+/qLuYqhISVYRxsjV
         NTIRDSBm3DlmTsi8IZlNbYRjssVE1FM0COZA92wYkAHg2MbbegcdtmVcKT8dLijwl1OV
         /UWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AeY3b7kqhOBOdDA/zPjfjOGZlqRMWp1WHWEZNT0gXkU=;
        fh=tVZYIO/8FJs997M6liWKWyhVjpntYpBDBck5/HrxieU=;
        b=s0C1cOA7Ra+tgV4XkBnou1smQfTMBWDIvmR4fWmuttmwL+s1mv+DRYq5rxjAP7W4mj
         sQw2JVxOkAoEHZFvAqk20hgF50Jrv3JOx1+n/gGGjNQi411ZHt/PNBpbfflcqY08VAvG
         ilrZpejHD2sMLX2wWPeJK+HdFe3PACCzHLEsBLydY86ZYcJFF37DEx1gJm31veL6cR4O
         bCB9k4DPR6HR6U3EURokduIgq4iXoVQbIitmlh6nFJsm+kCY6Ld/bFgoz+tFtmW2176Q
         8DCLWo0fMzAZSgcTtOww7bH6wlxM8yvubdkXC3IYHGWKWvFZIFPnzkw2S2+rWrK6nTkb
         7UnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794581757; x=1795186557; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AeY3b7kqhOBOdDA/zPjfjOGZlqRMWp1WHWEZNT0gXkU=;
        b=pB3VEWmD2ydP/qAsrOQ6f+nIiMtZ7km2sr+D9bbmyODNDWxke58BhvF2/SSKqyQ6SO
         NqZPTmeqhVDvhUIpro1+Jyvd6WkPTxcrXf7jSzCX/xNflj6CE/ha7n5NjbAEUMNUvYK0
         eEu7lEl1BMtM3Ejm/kPRcMuiOsgaN3oAs4HVoweMPawhXlj0pY79uawXfIjRmJZ8WE7m
         jDYHd8SQWiEW1MXRCaUQx5kEbfj4HdHDj8yRszoszSv8jNoLbtRzymkN5JnnsVXzUs73
         zOTJ2eSdj+/Ek15oO8gL2kcwSrQVpg7zTVUQ0lJMue5dLMoxwgE28xxEQtUx0XtoXjic
         cf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794581757; x=1795186557;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AeY3b7kqhOBOdDA/zPjfjOGZlqRMWp1WHWEZNT0gXkU=;
        b=wecRAxsLGpBaAJE4xYlTeAgavlLs2tlysUiUBnpGerdOvGQPCBxyOuAbIEUVfizNEL
         uBlBatWGBlGcWeIEQJXVZ/7SZ9mECw5zIHUAVwLeU3C1IN3ZOSDceEiAMUZdrP3R7Yzt
         mnuObNwFXIlEgLOx6EoXD+u6TSfJb53IaSCvXVDxbyVKCb7WQ+vIxPYEJVG6iDbJcFtQ
         0FCz/W8CHT86GgeJ3XiT9sBjFRqslEN4fGEqgAkPBvs7O7yRKmqWXZtHqEKbsaz/A/fQ
         IVLOYgczRI2GJPHW0vz50pDLyLcdIm88/UjRExofwpOD8AmwvVUZsWiYZB56n27devSp
         I/Nw==
X-Forwarded-Encrypted: i=1; AL+hErFpTGU4inyry/EqBZ6WatfjrAFS7ewHq49lUcBh1sr7HW4DEiXEU5XraIb8wICWccq1A9cVae3ufbBoaA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/NSb8zlWFrdfeFVNIh3wWeY5WUSJs/9czg0FFEq2M5z1+RlI3x
	OJa2gL4wdRKlsCnR1GYn5qE4REHkHcK4GhXhbwGjRORJvA1lDFwK29HkukmSF7gG8dbg9PKKotT
	Zio1Zwz+PkqY/qPYSntI2JcKE0aYAs18=
X-Gm-Gg: AYBFou2Y++aYctcv0t+mjSUpShatIgV/hl4ULYwUm0o7RqEL5tXWYnQ1tu99ZdtVROi
	/wZnjN9eTEFrfVon+j32Rz0lUuSNZcjP8TsyLVi7eK8In38f2WeO/BRYRkeFlOHtd83PGbAAspq
	jBjsHt27133wMl+ZwRFCV1j7DbJJtTivLI7zovjUoed3TJo8sfVgqNXoNT7Bhq5BWV0zC4R/mPJ
	2RgiVglOHAmYQW7f2ghlWyrKpS9pZ70URVvHHjiR5iD6LHG39NIM5rIrNvUIqCc5rg8dFDJHzE+
	xahGrkInP89Ict8wsiCqmHnqR4Qz8YFhVp6+hOgnK+Yvtg1RVMRVTvST9Kq+c+MupwpnnaB4YTI
	8NtGiPhcOgqit/3FqVxSv35mWJfUlMyXaJ0gutPFOI2QtgUkFuo7P3p1pHiKcvSjX2vKQHMPMun
	MBccyeeaX7B9ztXdhyvADlqhp/Kyrk6BThlUHP16CH204RsuY6GHQPLTcOxiLhGM2XShAY9ff3Q
	CZYvPjZkkL7mMraZs+iZ2KGkso8tZ352KPzscSMzfZ0+Wpbloxc4Pk=
X-Received: by 2002:a05:6512:401a:b0:5c1:5d5f:b707 with SMTP id
 2adb3069b0e04-5c164df7c7emr2386241e87.6.1794581756866; Fri, 13 Nov 2026
 06:55:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
 <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com>
 <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io> <CAD=K2o-yjUDPKJ_kFUur62z-JsXdNhT6YnEUftgtgoCZ6qG-oQ@mail.gmail.com>
 <CAD=K2o8t1zO+-d0H093C6fEsD-tM6nDq5FRPadW8jjviuO6CSQ@mail.gmail.com>
 <CAD=K2o-ZYEY8dextmLedERe0kUxKCuvhcK2vVZeahB0VTKVCjw@mail.gmail.com> <387ec20e-1fe0-4aa5-86a5-fd51f9be0f80@wdc.com>
In-Reply-To: <387ec20e-1fe0-4aa5-86a5-fd51f9be0f80@wdc.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 13 Nov 2026 15:55:44 +0100
X-Gm-Features: AclHuK8vIXa9jwLsNNBcZD-vbnck1eVDrTA5zgoIHOEg_TsJqt0P_9AuZjjnddM
Message-ID: <CAD=K2o9DUgu568bhMv+_Mb9f8=vFRPfwdo4Od4T6FzWMLS-j8Q@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

thanks, happy to test your patches once they're out.

One note: Dongjiang's branch apparently recovered my fs on mount,
so the original broken on-disk state is gone now. I can't test
the fsck repair on it anymore, but I can run your prevention
patches on further writes on this drive if that helps.

A larger write test (~2.5 TB via rsync) with Dongjiang's branch
is running right now, I'll report back when it's done.

Thanks,
Jochen

Am Fr., 13. Nov. 2026 um 15:45 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> On 11/13/26 3:00 PM, Jochen Philipp wrote:
> > Hi Dongjiang,
> >
> > quick update after the first write test:
> >
> > - copied 57 GB via rsync, no errors in dmesg (only some
> >    correctable PCIe AER messages on the chipset link, unrelated
> >    to btrfs as far as I can tell)
> > - closed zones dropped from 124 to 5 after the copy + sync
> > - umount, btrfs check --readonly: no error found
> > - mounted again, transid 875, stays rw past the first commit
> >
> > Next I'll do a larger run (a few hundred GB, maybe overnight).
>
> I have two more patches that should prevent this and a 3rd refusing to
> mount such an FS RW. Additionally I have a series for fsck to repair it.
> And now that emails actually work again I can send it out once it's
> looking a bit more polished.
>
>
