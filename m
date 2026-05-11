Received: from mail-lj1-f196.google.com (mail-lj1-f196.google.com [209.85.208.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6E1E5201
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 01:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778464655; cv=pass; b=nsNYAgncrYFiv48UD/oM8L6o337BvEAvm3UWdDoHmWTSPIdbal1pnhXCwbVB7TF+p9Jlz2eFYa52xsRinIMD9hKi1cfBYI6eJkXriSsp5VzejHgYBVyVs/ZbyyU9XeG9S8z5at4dQzSWI6jPfcvDGHaYq6wHO0bU9OtT3TvjWKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778464655; c=relaxed/simple;
	bh=5cmL/YdgNrkdO8qFqXIRorBMJ87EFIM2F09a21J5BZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=scyU+vWZcGJz0TX+ZHWdjaPD5hAyOIyQ454gveuNkgHx8Dpm2OS3QbODtFe88zc7bN9yAcNDV4N66Fx+o7AkWGGhK4KuBUmufSHpRsisXkD7EYVGD4E8xxcj2N4jCSU/24hVNLPcNXG7MuigWaeVy5J94xz2c76WgAw7jLiSp3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QunMbST9; arc=pass smtp.client-ip=209.85.208.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QunMbST9"
Received: by mail-lj1-f196.google.com with SMTP id 38308e7fff4ca-392445f11c5so37020091fa.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 18:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778464652; cv=none;
        d=google.com; s=arc-20240605;
        b=Z2XKo+yfL22+WN4a1ODBiVKWBMkVOZ6YYKoavgHLS6oP09U2MqxmMDwg0eDmp35tMB
         TOprb0VG3sE/cGknTj24dYi/NDSJSTlBW2ec0yid3t8AiaQ96iog0jBkg4wyMrJefsiD
         WtEFjJBdMVt5mdF3TjdynFBy8Ptvjfqtx8xun/hboVWWHp7EJiDuvO20J1fmUE5pMG+G
         jLP+jrp80JKO+AiZ0iV1ssliDFEp3c2puyV11T7iyAZCrMkbCRiReddJXKByYFvJsYC/
         rPZWDdevKqCQ4Vnu3LdvPfSjuNWOBta9hlQrwM2/a3ovdlekGEAwaSSHfPXVsqSGplHx
         Z/2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5cmL/YdgNrkdO8qFqXIRorBMJ87EFIM2F09a21J5BZU=;
        fh=TonqzIJQaJrKXZ1HOKgzEIxMzLRE08WnAugAgNcVPVA=;
        b=IMC6unO7IClsl4AxbjMMr1yJGrKpXRibNKNbx5GjA1jALuYiAkQFGREo78QhwCHFI5
         IRBiCbKre3MkE7VqHjuXdWSfm75ZohoyktwmuOcLztSkbYRnux9sNDRG1wTlWlSpUvCU
         zW+mI76cEA3SrOirHU0+RHBrtAF7WLJCir8M9kl/gtJF6RbFW3+EBKFNhY8Gs2WacqKA
         //m5VjK6oZg9KlezGvpNA9u9gsPOKUCFZvuXGW9m6qAs4ZyrwTHtJe+ZzM+j+qB5caHa
         1Kpo95GZULjbI9A1D11SsKKUAQ1/GLQF4u5YlJafYWtIFRUMutdlRRoT6wMnpLTW6a7V
         un9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778464652; x=1779069452; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5cmL/YdgNrkdO8qFqXIRorBMJ87EFIM2F09a21J5BZU=;
        b=QunMbST9OaPCq47msqxCRWrS0PZrtXJ8wxQmFPYq1Bc2rWyMdEHu6mZ0/R4yK8KjzK
         hoLZhtSy/RdauR6sRAUxZoocj88pScrvxNHKV7G49fKbRcLRN0QrpLP2IDLKE8NxjCPb
         L5DO1q8rJpjTFhe2h4bAaMpfGx13azzRxERvnj3ejvjKXVlUP1xjgsjVvN/F/dbuMrg8
         j/aK9a3Qyl/93b+RNxEXrFBqSCEM8mIVcvNp4jlVxdfyYI3XPSkxv6AeUPK5Hh45dNJ8
         QEV2uR3xLaxorFzUIEbYYYRQeJxbg+tSb5/HeDe5tO0O5NbaFzQeTVJjJu8eb+ZL3lbv
         1TeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778464652; x=1779069452;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cmL/YdgNrkdO8qFqXIRorBMJ87EFIM2F09a21J5BZU=;
        b=X+LRuD42EPAkYeGZOqmKOAv9j1APgiC5eGgXKerIRUe3BPHBrDVcmQMvaN3dFaoM/R
         oa5pB6UQEKBKcovmFPnlz631pl/4KZ1rcW66woeE/LXBrHJZRw4RZNv9hAH0fbceXsIU
         2ielTb6QKtZ7O7Ax8W2igtjHPd5ucGtPeLx4oBRVBlsi5p6vnf3UZNSkbgoahuteOBtZ
         xDcfr4sQJZdwT29IswH/NFxW8J2bhdMckTGzPyq627vRYpVyN2TLIJ0OgC+ZyPO2t6aQ
         Pt5v7CoaBdzzEWw0+YbwX+tnI8DRoi2h/brPcQfK1uVPh5wIq1qB6QK062ZcPMqXKE3u
         hr1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9S7tw7DBnJxACzs3mDQFXp7jhHhzN4R8xSiCmDt3ehLzPAS0ZCTC3Fg3VfMKUWnxNwUB9F6Hw2mD+p8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBFr6W/gMozOT4p4I4ktvknBCr5LrxjOyumDdBY8JciZwoyeb7
	QhOdvx0hpSzFhea2cKvaBCiKJcAr4Y+ZEj8gagLa9iiniZ0kAgGS2K1O/NcqxkpRySwAbjDUP/7
	By9mhKac0CZNoLo9pjQXEpugTUuE7tcc=
X-Gm-Gg: Acq92OGSMpGFff7NjYwKoA5LMdvz3O3HfCHRqBSmKT+OpRA2WOGuDoByKJE5Zha/xKw
	kDeIb+fwx1XCn69mkpjc7bOLI+T1o2PIQRKcIlpOKLUsPEdZnA0MPXwgrGvEruccTxJoSxG8/Bz
	OFs45c8o8NxzSg4oXYrrsKqaN3O5uZ9EL0vf3B95WDvios0FIXdfE1yQftQFxAR659jvFmVq1Sb
	KdQu5D3wv7hvMIwjKnndKFRr6PdgbVS7mfhysuVTSaNF4ovK0m9z5Z/MfKYLWz5wNaMFsTnx7cJ
	MTH6IK7HcW6wiYWNT1k=
X-Received: by 2002:a05:651c:1597:b0:394:8fc:8c3d with SMTP id
 38308e7fff4ca-39408fca759mr21460571fa.4.1778464651515; Sun, 10 May 2026
 18:57:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
 <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
 <b4769807-4175-440d-915a-e2bcd4af06d4@suse.com>
In-Reply-To: <b4769807-4175-440d-915a-e2bcd4af06d4@suse.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Mon, 11 May 2026 09:57:18 +0800
X-Gm-Features: AVHnY4Iwd1dL6MIiPJU1AcMOVuRGtgvDsvkpeEJYy47GzFAWycpJSBUebxCjT5g
Message-ID: <CAB7XQsFGEyDES9tnqLy9+VOMbNPiTSkJQssDV9=xjbs_LDJXHQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"

>
> If you want to put a changelog, please include all modification, not
> only the last modification but from the very beginning.
>
> A proper example:
>
> https://lore.kernel.org/linux-btrfs/335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io/
>
> Otherwise looks good to me.
>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> I'll give it a full fstests run before merging.
>

Understood, thanks. I will include the full changelog from the
beginning in future.

Thank you for the review and guidence.

Thanks,
Zhang Cen
