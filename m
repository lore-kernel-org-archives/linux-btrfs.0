Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ECB37A4AB
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788245368; cv=pass; b=mJzbYNSTFRXkOLKlpB4+Ht4TOeXZurJ5Q6uw527QF6rKUReEzD7UPaEByo+ZqIDB6sP0ICa8MYYu2hgnjx4U5MtHtdYlPM1dxLwK5CGiWDeNpf6fowcYYtfoauYD4TOCA9MI/FmkPSFljNlrSCqwN81H1fiJM5Q16/nrTU8gWyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788245368; c=relaxed/simple;
	bh=oNGTPV0Nte2s7Q4Q4v2+7pT7OOG+CNawxlnpt/7u8Oo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d27C7Yv+4k4BvZaEvsUxe6rGgwUV+W6rqhmD2/IumS/yFVXqA0OMkmmEvfAITfb+0ZW6ypHqo+L7cJjVNtZJOX+gmRGbTsDVnMNGCC9WCCz+c+bGIFZGtY5itV52qMTFsQ81/Wv4AeiaNcTucZOJpdnqHxwyNHbsmsCqmPzldbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BpsrGk+A; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BpsrGk+A"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso362907f8f.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 23:49:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788245365; cv=none;
        d=google.com; s=arc-20260327;
        b=MDQSIAvPS+3VUHn5j1kgf7NdnZdR49q1AO1LvNxXXbeQzLCCofgILIgb1KEo/1rGLy
         DLHAD/tB8nt+J68dgxRcJ5bFKTz2WLvSCagZyK8W4JGeF+Kemdd9+Th9ou4G4qNir1wi
         /WUH/EziWhW5tgc/RA0AZnoWM/nqCe5yVkk0N3uoUMG9KmW8SVw2EdiXiHWQb+PsEkFV
         Vzc5mJlQU91Gqh/0oSmEdRTsVL8BRFZG5dq7LboyX5nwq47yc0J4oefDr0gkfyPEeoYz
         Zr1bKZHem3iTIfa/uXBLi6Yr3o/a9Vl7ESjesem5eN/lVcJT1HekvJUUrEEONsjJk71m
         Ay7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QZ0kwvuRo9QIP5y4Kks1XO3hGegOKMFKjzEnWHMijtc=;
        fh=aVT7NFQCQWf1IwNMullbLDvANdoOjkOFl2zsvMmug2Y=;
        b=q8QbK9dBX+fte0P+X4Bxt38Aw8GSVVwpJUlzosIUlKJ8Fb7sMwZuKu5ledfdCv36xQ
         qBL9xjJSGzLYt3neQAwuvp1R/7JydlkBIl0Y7dGbgCTGuoLQaO80Nmt9oXNb1VVA6BSW
         ozmvuokRdWIJSsX8SsL/gX6+8TAK6uQ2N+LyJmhNsALo9I5QF91G5CRUoPc3/pUJDEGl
         EnHdjJhpNbiZBueco0iUbDjefuDcVmiDm6tMRjJhmBIyw0TCmykw9B/G+QgT3ypu4oun
         On/Sqq/jEYK/osXoONhaBxiqA/nKPxY/CDPF5Tj0IndJDmm0A5V/f06lukBaCWjdbnon
         2obw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788245365; x=1788850165; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QZ0kwvuRo9QIP5y4Kks1XO3hGegOKMFKjzEnWHMijtc=;
        b=BpsrGk+AP0QMLVKK63eMt9ayptIxw6Zo84n0T/bxYqygIWWDqt4o/f7vLmokBi18SI
         VctIFLw9q0fX64w0+LFO2ybgHFe4GeTREVbQbJN0/5vRwiCdVcN+Mmb5pOZjMpSA1Z7S
         kpvvZ5kIjaP5SjelpsK9pH5Zn0bOLdt6MiOYZXQZA07Wqo+yFVMLzh7sj8oUUKWeHR8j
         yCLsdXRoqhTeTP0CsH1qkUcupJQWoaBjECmFeOaY/xC1Nnh5J0vl2fivHai2xI4JSNRf
         HiMqGBnS5C9GOh66r6Gkvn4i4kkGwvYPy+b+XqfEnZFAwmtqLBp9uwiJagmWlwZlh02t
         NsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788245365; x=1788850165;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QZ0kwvuRo9QIP5y4Kks1XO3hGegOKMFKjzEnWHMijtc=;
        b=NS+BTFhxAPcya8SoaFhm2hATIe8wZioGpWcEHSInj3VIMxNrEvyoJ3VYIaqPhLYDLg
         u1PhZ6JBXHygdcJt+ik4WpxYbKIIVznuOpSzMTEdShigAHABVdMlpbfdXXHZp08/r85n
         UusrO/ZvQmY/NCXeGkiTpWToVrSAwLV1Z/OBrWGyzZauieBdMZFfsrscufA5s8SlHei0
         4pP8zshLc+xi1YNcICLqr2jMfvnY/msp5aH0C9zk2FTpSqIwVkrr3Tf8oKWUq+urwiLc
         sjOxUdkh5FPJKnVI2R5PZCuSD8GyED8MOjLHn6sb1V2SegbBtnHIKemg6mi3n6xunSzE
         7QOw==
X-Forwarded-Encrypted: i=1; AKwUvBzF05Kqk9YyvyRgd3NFfWzGn91VEKLYc2Jz4mMMQOj+R14E6ufFuqSECA652BA7X+8BocmW4L3cQj4JEQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lUgjY0rwg4V7ms+z+456uXoP+GKtbcH4VLPZ13IUZ3KwfUXCIR
	O+wqnFgKLuyT21add0LGx65Fjs8TK03HzgaCK2o9eNnKhsRXmhGbnzjkt3pFYxstUyi1ml6IVgp
	Igcj+J4JqaeYXXewNJmV/4+N2ZRd3WUxivApL5bbXRA==
X-Gm-Gg: AYBFou3SEdxmCFc1IuJoXDpmQaZzImGEuguMfuDaq6RhU6Q0tx/1yesbNGUYeGddA0E
	oH2E3UZC8sAJEx5qPtsoLfS7h290ECXyvwyr56qmAwcoIH/SFFoadBjlgCN626ZgfyruOkftlCR
	G/3i82wI4MChX/oQ2Ypi+XQGgoVXioJWSDS2NqRPBUuwul16NUfuosCvzY+M3vbtuyrqmmM+XMH
	Ly0N7SpJpejYmroB18gaHzMBuYoBTaPmWNsN8nT2sFLwuvGeMTqDOAlXmA6bn8uj30uUUYKCCVU
	4qY+4KmUtOh4xaf8qYv/6kv/o1svox3gNCJhjCirZbfyXuVbhF/RtQ3wK54k4Vw5mzTfJ2ziXy9
	H32ODsbr6rXJWnqYqHe9TvoMYO294qIYa4bnuhMw4wQ==
X-Received: by 2002:a05:6000:4605:b0:482:daf8:a3d7 with SMTP id
 ffacd0b85a97d-482f7987c26mr52155535f8f.3.1788245364933; Mon, 31 Aug 2026
 23:49:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-5-neelx@suse.com>
 <20260601230406.GC25574@quark> <CAPjX3FdMBAbz9T5yW=0ytRJD8s6zYHpo+TcYY-9-+egBHL=TFw@mail.gmail.com>
 <20260819155907.GB133077@google.com>
In-Reply-To: <20260819155907.GB133077@google.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 1 Sep 2026 08:49:14 +0200
X-Gm-Features: AcwNN1WkYRRvmrS9cx6H6wX9ppPbN-o7Vdk1JkhuHWMyozjsn6o2JUHcNtEnIsk
Message-ID: <CAPjX3FftK4tz7d-MmwMbHTXbz4Y9L7=TmxkDNnMfghrPtvbqxw@mail.gmail.com>
Subject: Re: [PATCH v7 04/43] fscrypt: conditionally don't wipe mk secret
 until the last active user is done
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Aug 2026 at 17:59, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Aug 19, 2026 at 04:22:23PM +0200, Daniel Vacek wrote:
> > > > +     /* We can't wipe the master key secret until the last activeref is
> > > > +      * dropped on the master key with per-extent encryption since the key
> > > > +      * derivation continues to happen as long as there are active refs.
> > > > +      * Wipe it here now that we're done using it.
> > > > +      */
> > > > +     if (sb->s_cop->has_per_extent_encryption)
> > > > +             wipe_master_key_secret(&mk->mk_secret);
> > >
> > > wipe_master_key_secret() is idempotent, so we might as well just do it
> > > unconditionally here.
> >
> > While this is true, it also (kind of) documents that the secret should
> > already be wiped out by now in case of !extent encryption.
> >
> > But I can wipe the secret unconditionally here if you insist.
>
> So leave a comment that mentions that it's not always needed.  Just like
> how fscrypt_free_master_key() does kfree_sensitive(), because why not.

Right. Thanks.

--nX

> - Eric
