Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBC34C6815
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 06:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058287; cv=pass; b=W1jTqdJy936eaIuwFXRcLMPoD/92+TA93ItQzkqrA6A49LbqrIMZflJ+2GqzkSQX9htKyogQEYB/Pe51aLJUUuYF0B8rZRxbmhJUxm7bwqcRzyZvSwFFk/FElQ71mRrh4MQmg5AeyWBEkHeaLSw2/bxjABbw4kr1FjA+glVvJB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058287; c=relaxed/simple;
	bh=/5P0/80FwVwErt+e0titNpIZH9FDm8i+PETS3a2SV/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rrz3qpIT5o3l+2ngaCxvn8glIn7K5pCseqNbYKX51+ulueXZzS0M7ev8QxYeT9jBRvCh14ekBnSVoRCgVdco8sBkCC9flCsQAkV6m5XIv21B0E9UPe7jRuCgB3WK6Ks1M9ZwqfTgkT2frNNBo4dKeX7mrJabLNs3+USDEEdNbFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkfddwQI; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkfddwQI"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663bfso569595866b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 23:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790058283; cv=none;
        d=google.com; s=arc-20260327;
        b=C4mzBWIzkkfasJRtA9tGEIiZjwP3W9qYKkc5FH35sCH2FxzMVlXtfN31HQ/B218kYt
         Y8Sk24By7w45Daoj7pA1p+f6amZp47GhspMhKXYpVk0Q9Au71gXV0r1Sf1fGh8tmH2Fw
         8EhA6vbqvnH+jgt1xQaQ9nRmDp5x6kOdY7n3udUM/ToCwy5zoAr+mkzCDk+fNWK7WPi1
         GFsGNuwk7yYAUlMnpcRgr/YFIflJlT4a8c6doAh30OOTc1o0mAt3Fxv/AhTDMwNGFI+U
         OBrN7bDsKBlnG6d3/xRVXSMD9WkdV1LiNIxzfuspg+I5qWHEa+cft5wARRJFAe7Rzb28
         v2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1VhAgrV0alm46V7J4WiYIv2ReIacoIC9sq6qIsCSfVw=;
        fh=uAR2SeQc2RWPhgkaOyvwDWEQws/YGnnQeOj9QvcYo90=;
        b=BjUEdkZs4DjEXiHiPs0gIXzA7jattflfjMuhm8dWGSjH/QkfRZ62xepvsBIfnDhmcE
         NdKaJTl3Lj4hWGhEotWgWCWd3emfhImFk9wZIW4r7B3lSTXgIlIOZ5MuZoRIwtF2IgcX
         g/uTyNp2PQwrROrLqsAL7Arf2D20wIoubN9ISVJsvPOf/0+Gss2gv+hJWAP5xd1R/mFI
         WG1pKs5NbkKB30RqAunDrcLxHw9z+nOz0GiRvA5klLtD84TeYUVyxux/ZFbOGm4+W/Dq
         9YEkZel98lGtpSxsU/JNjbkATSRlrZZ+NUNR+cPCeVHQGcuKQmJ/wwrkRwfweM7rLWNc
         h1ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790058283; x=1790663083; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1VhAgrV0alm46V7J4WiYIv2ReIacoIC9sq6qIsCSfVw=;
        b=ZkfddwQIXdjUtBxKgSrs/x6+3+6pQzTGu9b9yN6r+dN5FplnIzv8Red+PpHFHhgFN6
         rFHSptSpoJyNkyOH4ueclrXFxZWcu1a6+cB/xeWPcFFN8iVci9T8i4yxmmM/OQk9NCv9
         RbaJYwJeSucXj0aG3ccHf9BPc44yhjdNT0EQekhzH7PCltQc5M89OlWwwjAa9hNpLfyA
         VkFqn0hbOb2EjQcfSgYgYDBDqRSxUis8x5VStf2sZ59oV3/r85M2TlM7l2GNvDLdSySi
         RsWlSP7u9dlGPaFMn7nh5ERFfWOAZl+6Q+JHzp0ZE8nZY8fmd6449MoTEhxBFGGyESsm
         x/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790058283; x=1790663083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1VhAgrV0alm46V7J4WiYIv2ReIacoIC9sq6qIsCSfVw=;
        b=IWOKLZ95thpIbwNtLK458nUaQLCZsCZ/bkZXXQTXsu7ZVL1uURwU9KnTegIAJt8kN0
         Y14ghA1mwP0zjkIwkjA4INddj5HcJGtEmTde3Cpr8vjGbIDs70/wm+q9m6H4eBSuGuJ5
         qGaNZYrpbueM14UFIonMnAw/+koY2sIgzwGEMEZHanGhaRlEbeTZ3jH9i+suIr8LInoI
         2BRGwSNk8agRzlWK3QNb2u319ozHdwd4LxC2iExlTzzzzgCyQnoaIG6ym6F2AMHl9mFE
         Bd2nFY07BXyBnD7R3Ct8py6PXJfGr8ssi5lYnCKs5/Q2+ySYt6D49XAum+G6L2sQsS42
         0fMA==
X-Forwarded-Encrypted: i=1; AKwUvBzL2UB8WWRU2HinY4xLtn6Rz0rl3XwHRM0VPvZPKALF+CWqQxH+y9u5FHaaRBCL/1ahqkTEEgY4bUhafA==@vger.kernel.org
X-Gm-Message-State: AFuF++kXHKDiA7jH32gU/ht0Lhl5iuTMFkGGbbXq75lgLIq2nS+0jaG9
	/H9RYv3wrGvkvxdOpIC4lcdA7aYULL+OWCTi6xa3Ya+7GSpQM7XGEX9HPxWHAyS88+RoVPzVW9Z
	OEkbaCld97xjCmq8C7Iq1zwi60WxwPr4=
X-Gm-Gg: AYBFou1qQilNTNO2pUzIgTZHEQnJvVQqHhQ4Ot+xPo+AxVxggaJiT9R5u0An9503mZM
	QXXN/hpKUCimhjTsElgW8yiBd/gfm3nPRo7MXQKbDGpYX7WDiRcZHnQunjkZ5++DbmLUDIZtILK
	xKe5//bNptg4VJMKpw9TLxpxdSW14lz7+JYEo/bvALrSNAKmDq1hiBYf/5F4/0nLU1cSbVS2upd
	jnSwTHt898GNXIgcozy58gEnmkNg474N0dNo+9oAfuFb7goSw6QAIL93d1FgeduHNEg8vwlQfiC
	1Yyq6W7NqmS9+eq9uxZk+xUzf2Kl3xw6BdCZSjReh6uX7OXYj4kNw0N+
X-Received: by 2002:a17:906:ba84:b0:c26:22ae:b66b with SMTP id
 a640c23a62f3a-c2a156d71b7mr1119266966b.15.1790058283239; Mon, 21 Sep 2026
 23:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io> <20260921131220.GE54722@twin.jikos.cz>
In-Reply-To: <20260921131220.GE54722@twin.jikos.cz>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 22 Sep 2026 09:24:29 +0300
X-Gm-Features: AcwNN1V95DB2DsPOICVWpSPOIGm2DYqP4B9l2YbKc9Vgqd8x8KhQ3io8Fz1A4PI
Message-ID: <CAA91j0WO+z9rHSaLepbQVMUXCNNA29KhnYrojkNpHp4+FK2iYw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
To: dsterba@suse.cz
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 4:33=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
> > =E5=9C=A8 2026/9/21 15:03, Qu Wenruo =E5=86=99=E9=81=93:
> > > [BUG]
> > > There is a bug report that a running qgroup rescan can fail a pm
> > > suspension:
> > >
> > >   [ T278489] Freezing remaining freezable tasks
> > >   [ T278489] Freezing remaining freezable tasks failed after 20.003 s=
econds (0 tasks refusing to freeze, wq_busy=3D1):
> > >   [ T278489] Showing freezable workqueues that are still busy:
> > >   [...]
> > >   [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=3D1 re=
fcnt=3D16
> > >   [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
> > >
> > > [CAUSE]
> > > Btrfs qgroup rescan is running in a workqueue, and when the fs is
> > > frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
> > >
> > > But a sleeping workload still counts as active for the workqueue unti=
l
> > > the workload exits.
> > >
> > > So the qgroup rescan item will sleep on the frozen fs, and fail the p=
m
> > > suspension.
> > >
> > > [FIX]
> > > I strongly doubt whether we should even use a workqueue for the qgrou=
p
> > > rescan workload, a kthread would be a more suitable choice and can ha=
ndle
> > > fs and process freezing way better.
> > > But that will be a long term solution.
> >
> > Hi Qu,
> >
> > Thanks for working on this.
> >
> > I recently posted an RFC series addressing qgroup rescan lifecycle
> > issues around quota disable/enable, error cleanup, and remounts [1].
> >
> >  From the recent discussion, I got the impression that full qgroups
> > might be phased out or substantially reworked. Is that a fair
> > understanding?
>
> Do you have link to the dicussion?

https://lore.kernel.org/linux-btrfs/03dcccbc-35c7-4b9d-9275-17a4b4111b25@su=
se.com/

> Phasing out current qgroups in the
> full mode would be a functionality loss and we don't have a replacement.
> On the design level, the qgroups are general enough to cover the COW
> design, sharing. The compression was originally intended but IIRC we
> don't account compressed extents separately.
>
> Reworking could happen, the performance hit of qgroups in full mode has
> been a problem since beginning, but I don't see any easy change there.
> If the sematics change we'd need to add another mode, like we have the
> simple quota mode.
>
