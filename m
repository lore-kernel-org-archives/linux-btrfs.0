Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795796335;
	b=T1tGOCOeUNGISroocakUtlf1kTXc09sqdvltnrfoVSxKVvZ5IuEKllV9Ptvgs+mqzs5J
	 Tfhq1fDRPHf3k6hmVK9J3s9aOH5+xAtk68g7DkdaQLMBj+uZgJS2HxDUBamDjGX3lhlgV
	 9200PPsnxt3ASXlzLex8wmZY8hemK8+QUXQDDPDe2ekKlFaFYIbV1KuRYYkr2RdzsSGbi
	 eeqONKOINhz2EuZTY0gs0K8b3v/FCAVueoSwCZZJepOZ5ZcmI2/QNi7d4vwsvIkLo5zNJ
	 tpGkPwb/Rs47ctkB1A0+kKwc6X/NT2oM//K71eYI1HsLDFXpKygaIfp8JB0a51cXuEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
	b=JJ+W14D7AL+HZwBBj4p2ChiL8dTer1svjad66eoNY0ZyCeaz/oq5fya4HMd5Gc9y3hIf
	 /uslLmcCosRdua98/B12fqqJsdIhdvxCOM87duCrAdMzuTzGu4YGkFlh4IoxDj0WVBgrm
	 wwE8FBfCWpARQmfPQaUi7zsnLBjFoPOgGvUtOyGdzOiLlZEBi2LHDDf44byHsp2T5hdnA
	 lmqpTBckCP2nA5EHCA9ZsrZOv5i1+qjUK/OremsMo/QVH5O1eSeKTtufQdEFHkzxcXX+j
	 GW+BNbulie/SGMTL6WpkkYGtYRYdml7EVUFWyfqjnDbn6u+In6RmxoMMXUWt9Q3WDmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="naloy12/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A878606A326
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A878606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=naloy12/
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso10978977a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 08:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795796333; cv=none;
        d=google.com; s=arc-20260327;
        b=e6oTE1SgMGwZlt9HBeO9XVq3VSLTVnA//OYAs2Km5BPm1Lq16PSxSag+SjufhsrAUB
         QfoJ4AKmQimvab5A9a1zfhyMe3fcb3VdXsMwmKipKEG7jvfPuZDL/G4EIlhQDzBKMfNL
         Ql66466xZnNAuryRKiHBJnlLvmNMk7qeFeIQqA2g9GkmBuzSaNxHa3E0RRfBdocWTd25
         B28CZGJLx6BmH3exlhkJF5ueW5M4VX06Er/v+mQuIUl60vVHqB7tT3oisJmsVTYH2Ody
         p2eCsZZTLqz9Pssl/ID85/Fx8wsmqgErfLc3ohzqF1vDsTY/bSBMRIIMXlRdgsz3QlHD
         GyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        fh=hjHbK86dS0csg6GVz6S+SzbCplmGFgGEj8XMolqzZOM=;
        b=ruBTmxOwW90uVqFYQq6tW72wnXSTQu6t7SctDt64jYbVT6TrhBFSm9U8bjx1t+xJY8
         RLzTvo4utId3r08dUSfYrP6MiavqKZQb8Pu0pcM9enXTHLdul4PfJ3Zxsz9UBc4tHZlb
         KXouu3jzx795HmenVCZYMt444coXMHcCEHEyua7VJUFCqWpqUkEwG0rGMnALIxCPZzBF
         2Ge0NZnhuuTQirjFjA5fzV9avbVKWkHTZO/mABQS4drQDVJXW37mFY8x0ti8TGLWuULt
         1tM8V3mdBqwxlIpsQNJKIVUw09X7sfIMruyTTYlSCEM3mu7GLjxbT+MDdtzZiXGL6YIE
         d6iQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795796333; x=1796401133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=naloy12//Z/JEicfOBVG7/emu8n6hsVyuTwhG/APX5YJILPJ+Ejhpn8jBE4NDP7/lK
         g0UksYAE6Bdao6mTsS9kfqJqJTBy4iSLcQUfz2p6ydY9idCCIBNNnumqk9ahTewMQrhJ
         T08f33nweDrOyw3pKSkr1Qkrkked0vr7ZHwRDHta+TN6WG0oGzqsuhDrEOx72fBh5WU0
         oYgUXVXd1tU/mzTeQ0mzsTJviZuAX74N/jPwzeSjBiwxnyK0h0TealYMchARBmDUZIOX
         ViMp+AC7Q+jtL9fE4jDvp/Jor7sArB0DX5YSBPvQ3+fL8nmRlQu5cAOGwV0tlnPOhQ6L
         rUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796333; x=1796401133;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=yoyVx0/sTzQQWQSzwn9ZRMO8O5LHtY+zt3Qf0TfuheeZC48E7Z1JGKI5CGEZKIwkJY
         6bTRN6O4qokirsztfY2FH/pYPeNYr3NvdUySE26CY6GDhTBSaXEVRXyMDJiDmnHyISfD
         6eTh1LsP0YAd5M85l2TewhsOwPGS2jRS6oi0o8QLffU3/+MJOgxE8gjMNQ1DMtRVz5rg
         W50dC5Pk+mqlq8ecwgCQFu+vF1ntHbJ5LhyS2bM+Rpon/Fd+0RwAmUo/89eKo/YoGgZ1
         3oAE3IAZClEPP3utc7F/20L3H4U+nDJp3BvaQjcN72x8XTVkvLcQHEW5sjuHDL/TxZ1M
         +rSg==
X-Forwarded-Encrypted: i=1; AL+hErGj2qFCti7RIS5wO/M1UkdfMvBMv4qiS20Ma308CTfV7QlpsjVKqmOTdtDm1bKZy+5rRQD6M1gVNGw4zA==@vger.kernel.org
X-Gm-Message-State: APuU4Z97x3tEX7ywVWqWRgnqkP+0uGB7waYezujYslIQMX1djGc2OKPa
	sNDID9YH2uFJC5hfDeA2PZZiyVKSIp4hzeDVMLOrSqr2XpZpejPapDLIDIP+PjEZQo7DXAudG+O
	7MHyzy5xeaOJWmr9CgpqhtsnWyO9iHeMyHP7tIKU=
X-Gm-Gg: AZFdTZf/aa2dA39P2CG8Hq0w7h9QFVy36/HxWZ7YK5YptDd8jXzbZl3lTW3c0gCUFxk
	NHxIKf95cl7yb8qzqwNbPctSYy5TOdhokt9nl7Grz5P4umZv4fs9x0YnbYMlnK9rHYjcOmZLYdp
	7lXJySNg0kPONnQXzhKkuTQ3ar0JXJ+eBDPd9eBWlRDoppAgIQfDLFh5C6i8skJs0bSmfYViSFy
	7plsdJChPbMigetpaKPMXgVq+Dm14pour70Pdhvf6oTaK4BlTIpkaZA0Aq1soV4tzWPIE4xzM+8
	qOLXgYFz8xxqmDXA6RJtsERWlbalyJq1acnWgti2KyxDhTUvL5lK9K72babYI8Tt0VtB4zGwh9/
	mSeLHpca9yUirXqxObm6nRuG4LOGOuK6Xlsn6B/XHtK2Xn4fyyYSgx9cSJ2ekqHVHXVsqew==
X-Received: by 2002:a05:6402:e05:b0:6af:80c4:8981 with SMTP id
 4fb4d7f45d1cf-6ba37e890fcmr19985269a12.26.1795796332918; Fri, 27 Nov 2026
 08:18:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <20261119153222.65195-1-lauri.gates@gmail.com>
 <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
In-Reply-To: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 17:18:39 +0100
X-Gm-Features: Aa3M54qCjcbbYjv0mzgNqjSQ7Sw_WVEr_GJN4PX5Bm9lrA0JqzVoRsl7zVlER60
Message-ID: <CAOQ4uxhE38TnXseMOyWY1OvidBWew2hAYAV+rYeTPaqRYZb45g@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: Christian Brauner <brauner@kernel.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>, 
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 1:44=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> > One constraint for that case: the flag has to stay out of
> > FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> > FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> > plain flag there would read as "supported, not shared" on btrfs.
>
> Right.
>
> > Christian, with this mask on the way, would you take a plain flag
> > (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> > that filesystems advertise through fsx_xflags_mask? If so, I'll build
> > the RFC on top of koraynilay's series instead of using the inverted
> > FS_XFLAG_NOSHARED.
>
> Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
> Filesystems that have support raise the flag in the mask and everyone
> else just doesn't. I see that Amir's busy discussing some details in v2
> so maybe base the RFC on that series, I guess.

FWIW, I think the v2 posted API is a solid candidate wrt the UAPI -
The AT_FILEATTR_ opt-in and the struct extension leave very little
open questions - the remaining discussion over v2 and obviously needed v3
is around implementation and the fine details of the contract, but for a si=
mple
readonly flag like FS_XFLAG_MAYSHARE, it is very clear how it behaves.

Thanks,
Amir.
