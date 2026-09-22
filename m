Received: from mail-wr2-f14.google.com (mail-wr2-f14.google.com [74.125.225.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FFC549363
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085948; cv=pass; b=F7037B14QbVn6mp7lodoOKnpa5ItdAsu4bfolFQO9YZ/nY2Gua9UjY8+AKabZ4thgga7rzdMGHEvnMB0Nc4wpgOepi/p3QeuIS9Bazbd1koYXF7W18J4k0ba1PQTEv5x9neiHDD/X/PTC5A5qq74KbJVxu0H6CimTUFKIdAHTCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085948; c=relaxed/simple;
	bh=4H7cYh/XcFy79IKh5ntWbkLJLoAWIpLRyRLXVAEP+zw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+aNJ4C3Cf7I/vFDwKTKmWwZqnvK97rYyWPACqsxyLP63UU6MXu/81hru+iSIgZ12QXvQkx1Xnfh0ZONTM2qh/0cU+75kDJHAKvANqwGOgthLfkK750GMaM0H8AB8vETwnlcd5WntXkD83cktP4K4SptIQ1Lspl0k189etaq2mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OaZw4Jlp; arc=pass smtp.client-ip=74.125.225.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OaZw4Jlp"
Received: by mail-wr2-f14.google.com with SMTP id ffacd0b85a97d-482f6350f88so2684782f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 07:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790085945; cv=none;
        d=google.com; s=arc-20260327;
        b=fIItf9Xnu3LG4pBb8tPcFKRMgmQMckFyGzTvx2P26NQWPdKG+132VICOFaTejBPIae
         dGPjI5Jd/uSBPTisd5olonmFPVGdOgffHyjgyH9u6Ok79rsGfLswQplPVbN1KVVLjL2N
         qVpKkLjK5HJUF92CBOrYVWsOB3KgL8N1GuVV3YFi0Am3v7VyNGdvXvH37GxHKmZI2tt0
         +IKroWsmFMSkY1iMcUvv0l51weEqTtsFmJFrRv96iTKMcBjUuF5+W2IOfXOhHVty4H//
         JI4cZH33Or+bxCU0e16H08SQ/5YHVMXFB3kSvq4/v5EESSrMxLipPZ3BmpqlawXT5D/Z
         aecQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LV8hwkL+g4D+YUVw11Whf1ua4hVH+TJu4M6R33VpXN0=;
        fh=if933Wif5t4OvWghgSFZjeInxhu6zyZrxo3BFDR8+lI=;
        b=kUol21O5o5fISTPRVVS8DjUPB5uwIwAWt2ISYRMXgaZbqPy9+cuECKE/8poeYbr0Hm
         SGviH7vfOI3ofHz/7fXBB/+vvdJuFu5MiAiyHEnFp/T7Aq2xN5OmsSw/A1YWqX6RYRQQ
         w2R+p0qV/LrK0SgQZRhwO//iwN3P9Jn+PHBZnCJMvYBx7Tou4CXVYHYs1Ts9pVz170YN
         jbN5xFFd3Ntp2JnupEj0KDORr5C8C2FghYWeRT1zUjUBEnBal8buoXp1+sqv3sMS5pq0
         LNVtG6iDS+q7ajnDw73xtwEwDDZyvLO9PAQF8tqghDgRp+f7AwmBshRXKTXj6vZVlk5i
         xOZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790085945; x=1790690745; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LV8hwkL+g4D+YUVw11Whf1ua4hVH+TJu4M6R33VpXN0=;
        b=OaZw4JlpEJnPotAAApkw/LFOiwvi3X6tj5Xr6yfn43f8A4HJunL2BYhfAn/tznUyVN
         qjajcgIof+vAF77Nlhhn7LGc8XluAKPY9Yugz6Saty9rYpmP2sMv0tARCSpOk7VNloUX
         pg6RkXpf1TMnVHEw2B1zF43vBSyFXnJTkQ80F6dOKOiEAGWiHSkNIcJ7rQ3Ikjox+m3j
         IWk3KcV3HzS5aK8rZVaUHv+4hEfKXf49VAYL0MLmlhtyUpDhuaGK2eEgUidZx8GkSY0o
         6dUI/uQ/eDY1C2+J4jWSCEsIm4YwmSej4UX+8SNIix6XGo6yUUSuhmH5ang8rK0XG26q
         sY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085945; x=1790690745;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LV8hwkL+g4D+YUVw11Whf1ua4hVH+TJu4M6R33VpXN0=;
        b=S2gHSj5ZlKUCQnpLVC5bL717e4x1QoTBB0KXhZZktodlNL9KQvuhgWaWCcfUwPEkH2
         CIM0Ld9J9tIowZNrGxyEVyDlsQfn7mKhaNxTNchTHz/gY9BUxLjKNUYb3ZHUaqerc4n/
         ZzX3VIxr6IrStmDNzo/qU4wHf2edoUsIhXX/BzGBr7ewm3A7FVImzOOm+ByWdAjfDkgj
         UMEsxPgvxsVN3loscM2WCSwX4ft6WbgCKAFkHkSYQyOBF/TBf33Ha5vPF0sPDCSU1/16
         OThp+F9hrIsev+OYV+sUAn/VKi6QBB2uWOT4HK+fsFpS5yN0rcAM1G3E6iBwhitCmhku
         0S0Q==
X-Forwarded-Encrypted: i=1; AKwUvBweCvn80WqJJwlqdzau51iMbTLzmtO+6HfAkGOHlObsMIuifZXKWy7c1vVX/0T0NkYhgul9Xsi3AkGJbA==@vger.kernel.org
X-Gm-Message-State: AFuF++mJFZDO9ubUh4pv22AkLQ0h7X1cAFVFzaQR5JssE5hW+394jcGV
	mYPoWFHPlHpFMkNA025A/asQ5WDily2vcjSeKsFrjjydXA5XKctINKvj8ouU8tE7duYoNKP5jU/
	LfHIBT2e8Ws3wHuMFy1Iqk7RtoURIGo7SBk8C1U+0fQ==
X-Gm-Gg: AYBFou2R94Q5W3cSC2wMrHx/RZvJYrxAOOc5sYtM573z5q+MqrRTae8aPa5nw0D2iPU
	4xAlSc3atFV1fdL9GL7JkMM264NsG5vl0b1UY7dQOmNqNnNcGx+gPDxKwefsj4LmRwBNlFc+nsF
	0t6Hw2GGikHLOe1jQQzrodwA1mp9izIP6maxhtb0c5nOyDr8LII10jKfJN+QoXueoEzWqw4TeS+
	RLO8mQKLP0UG2gZM7T+N8+Y1hF5YZUx68hhtWhfSwMEP2BTwMxwkB1oaLYZZqn8a2G0ThQhDVUy
	df3wgtAfr07AmwGravAFESlZ9d/Nc3TNymtWB68+iVVsZIgDv8gSQchQFzWyXiQjqH2Ly5RIpYo
	pFwXMkAJfeUBgMoktcE77LKkGKPT3dhiWGNLcHMQiVtmKuAtXdHDe
X-Received: by 2002:a05:6000:2409:b0:487:342:d147 with SMTP id
 ffacd0b85a97d-4871e363e1cmr24110192f8f.39.1790085944981; Tue, 22 Sep 2026
 07:05:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-14-neelx@suse.com>
 <20260601234454.GF25574@quark>
In-Reply-To: <20260601234454.GF25574@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 22 Sep 2026 16:05:33 +0200
X-Gm-Features: AclHuK8dl-tYp2fYNBoxko904-iqmC5latOeVGuZqXI84CESlhxypC11MK8aWjs
Message-ID: <CAPjX3FctU6PQ1=2vL5yVPhWRb9konu2P=Oz_W4E-KSu0FmG96g@mail.gmail.com>
Subject: Re: [PATCH v7 13/43] btrfs: adapt readdir for encrypted and nokey names
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 01:44, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:47AM +0200, Daniel Vacek wrote:
> > +     /*
> > +      * TODO: This should maybe be using the crypto API, not the fallback,
> > +      * but fscrypt uses the fallback and this is only used in emulation of
> > +      * fscrypt's buffer sha256 method.
> > +      */
>
> You can delete this TODO.  The SHA-256 library functions just do the
> right thing now.

That's great! Thanks.

While at it, there was also a BUG for folios of order > 0. So I
cleaned up the whole function a bit.

--nX

> - Eric
