Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD06375F9F
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 02:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773281431; cv=pass; b=SwUfa+8vzkzlYDKmtD/NtTHIBgoYwwu3uA0Cc+XwBNH6rMO8SOpYZHbiJ3USrKEbGCeKw1HzryL9AImc/PXg0WGrjSjgX1DgmRG0zIa7mlDoYkJ1DgeVAJ06AeBY0N6Q+7Kk7v1KBgpo1OmjxtWny1vVNWfCE6l2dbCnRqivAUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773281431; c=relaxed/simple;
	bh=uAOVhNzDH+nb9Kc/yjaQMWFh3tidbWM9bwHFzGealYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yr4T/ZIG6Q7UGSWK4ePV8tW1ohGoP9JplvAsZUABpnFtES/H9TcnDVKrg/BuK4VMUaJNtewZDJ1NjshaDapnPfoYlnQdLED8qX3M/mnv56D8NvpH+qpi/RprYvmzq+9YLi7eGY18Pwzl7P6Kvv9UuIDUTQ7PxmABwnHsFBvjT8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gp8i8SMR; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gp8i8SMR"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9704cd6951so45980666b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 19:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773281428; cv=none;
        d=google.com; s=arc-20240605;
        b=C+7lzTeCXgTTKmoiqHKcBKXM1j5SINDoEXgSzHaojQeudB+G9BV3tsJcVv46F6XAc5
         FzyP2g+vpayr+H6VF43jV0bQ0WSUXmKf9ZxlZ4C5HVMgZGcrj2KWZpgMvdo8Hufw3jDU
         47LAhuzAhkMWbe+fmBRFVjgKHCe85/GRYEbIn9YpbFqJ+5D2fGiXuIK0Y8+DrBpOR4YP
         lIocWbOSr68LQn1gPX6EFno3lRD8msaRK4n5kBZM/6uFGa/QcYcWWOeutGq/vGZYhG52
         5El3GsF+EXC5DF8avsd5jqAGBHxY9WKpCS+7Ji5MLD0Mt2Em7BtZxuZ+MXZYSkuxnBrY
         2z2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uAOVhNzDH+nb9Kc/yjaQMWFh3tidbWM9bwHFzGealYc=;
        fh=mg5IWP7ByR4Q4SPvowez3LPjctggNktyeXlLczXlEUc=;
        b=Wkpyy+NlAmrNGkcdFrACwsw0Fuhr/I+tmAv8fnS+/4BeOf+zj0v6jjEzQc9880S27F
         XxOsH8JcC/5YNv8TxuFmNOXg46vICQ4SAO4iht9p3BBFOzaN+OY+Tn7pPJhiD9U7ipAA
         HN0MvmIULmYBqVSyaWK2c5hs0FnjsmHgTcP5vuJBmjc9kfP6wOEzKZE+e9DrVQmXpHnC
         poVJv9I7911lRzMlt1IKyggXebF7K1Co7ftp5pHHUCsDlYv2r9E5GzgKjEFpX45C76jl
         +RTidGfRJO+DVH6fKO/ljvtJ4VzB+7P0YxshUATO7AMUhK8wDZVwDDXb2oPTh5xoCsqy
         TMaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773281428; x=1773886228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uAOVhNzDH+nb9Kc/yjaQMWFh3tidbWM9bwHFzGealYc=;
        b=Gp8i8SMRZw9FoG1vD1GrOSgTk5O7zLDohdEWX5eXkwLNaP/mOWzvXc82ESPFZw6BBu
         D69GiKN4ttLAEvfzFXovQJPRsbKiWhVXZ3YVG+NFbpX8zCwpUzbkshl9ZKQO4hu41+L+
         aRToEmQjZE9WUtpzGuKnkQHBd2FpI0w4U56E1nV6zG6Euu+O4hiRZ8rBWhKeT712rsy+
         1v+ovCuUWalBtYEToK8RJ1HiIMRp00V6w1VZUOI6Q/GxMfufJWvMUHrO/8RlHBQX24Iy
         qmZCLBPUZzt5DIMGDeXlYKDQDXcyT+ARykoy4o8mnueANO81EFrxKtS5BPQUBSzSJkDq
         vs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773281428; x=1773886228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAOVhNzDH+nb9Kc/yjaQMWFh3tidbWM9bwHFzGealYc=;
        b=SzICV6l+1AWEvEyfMSkMyAWiKkko0O+tPrV13+YUQlB9+oCbthNeTv5aBUTGbmk6m9
         DoMj77x1egpV0DYIIOtepks7u37wAETZ/d5DtyVBOsFc3X3ssnFin/Yqtt+BtodI3nOD
         qsW+s7Hw5LB2n3EqMZQbVVKBhV+aw/nEBK+tFrsTWUolQ72Qqx0uklPhOHfGWPBQBOwN
         WMAmC73QhYb+DUwEzmePLxn3XdeQKR3tPEVoG4CutM2eqgblx4o+k7ImN8AQLJvI40bq
         TJOsLWw8eCGsJz12Xkq9pK3N1hCprH3AzzrGMZy4D1fMFYdUGHN4E68iWxdZpQSTzQeg
         iiiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi2llMjUMy0q0FEj4Ne+dIbVPSLNV0vkDCIG6TiINEUKh15woszNPrHbD6UiXv6kxnunrtkgTP8NuDEA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9HejRJaA+9h467SMKIY/Aj4heDy00yF+wCkdoU1oNYY0V6S49
	ba52wZe3PEQzysF5x0KlNbjPsrB7ME2YGCvaEOKBWzCxZwH/pQnZNy1XtMJYTp3rAK6mfM4TnZw
	lhkbAms9zqrlM7rKdWW6p7gEutTIWZbE=
X-Gm-Gg: ATEYQzwA9QRdP2gTaWFIvI5BoN56QCeXt4K0fzdMeTqD5igjavSMzSVLnRMh68u1iMm
	vsrqeVli5LA3024Z9+PfljlsaHt46Xk6dVveNB6Y1tLIPSPd8UXIZlmkhcYyiYAm7F7dzS1iWTI
	JH33DEuktm8byWoJKgeR+7niAQVg4bSSwTvxSRmDYiqlRg3Dd1INikrgTjNAio1GSsGNLAjTZqm
	Y5ylFdgGplDQfZYFe21A8xgEfgHJOnlYetWaXRw9OcXEfa7trSM8WnqqaUTPk5V532ayzfs1kDk
	KPQliMD+FNSwGe5upiDjPBJr9KA5hUKRx4ytyagyW/vm69eghJyCpuU=
X-Received: by 2002:a17:907:e112:b0:b93:8e7f:3d3f with SMTP id
 a640c23a62f3a-b972e5faca6mr189113066b.32.1773281428332; Wed, 11 Mar 2026
 19:10:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312001443.3011961-1-gality369@gmail.com> <17c102a6-bbd1-4937-b5cc-5f6912551180@suse.com>
 <8533b404-3377-416e-81d9-2bdb00baaae2@suse.com>
In-Reply-To: <8533b404-3377-416e-81d9-2bdb00baaae2@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 12 Mar 2026 10:10:16 +0800
X-Gm-Features: AaiRm53d7xqK8oTpL1WJOX5npfX4-cLTkfjwSrYGYK7OxzBZYQaiYslkFoedJ14
Message-ID: <CAOmEq9UusAbrMLSMkca+DEPff9hXokAvVn3V4acQ0EvSp67HLQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: reject root items with drop_progress and zero drop_level
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks a lot for the explanation. I think I now understand the
intended use of the
Fixes: tag.

I still have one question, though. In this case, scripts/checkpatch.pl
warns that a
Fixes: tag should be added, which seems inconsistent with the submission
guidelines you pointed me to.

My understanding had been that patches should generally be sent only
after passing
checkpatch.pl cleanly, so I wanted to ask: is this kind of warning acceptable in
practice, or does it mean my local checkpatch.pl is outdated? If it is outdated,
should I generally use the latest checkpatch.pl when checking patches
before submission?

Thanks again,
ZhengYuan Huang
