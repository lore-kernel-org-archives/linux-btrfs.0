Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F6121A459
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787502885; cv=none; b=GF5ZHvTUxRs3ODWQ0nxnTR6PM75eWlwhJs5hvyCgp7qRbsumGR+4YI5Ng3mkSOPqdGAXpPVdbjWuykMNK7eSQshAyr0erE6Yg7PRyXj5oEvxjktqRGKZE/q9GSMsXcJ9kkFE3ePX5NOCPh/9/vmB3wgWlp3P9OZEjMX6SlucOyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787502885; c=relaxed/simple;
	bh=BQziyf2iIfPd/FPdmXGNafquoDImLWwJ54cyKZpNr88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OmJ6rwJhHHtXfQq6QT2862Esw798dph6hXOQ1pyFzodPzfkd+iJaKUnOeufaK2KVZdKuxeTRNlweHxb1f0Vkc1xhxZIKsIdYd9vJ+eXCbVDEkHxVXz9A21qOlkUN7WckMiC6KKHsEmAeW4dRO/vpvaJyEAdpiHae9/Up5YgL3Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGIl3UGf; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGIl3UGf"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2074710751so480179666b.1
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787502881; x=1788107681; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v+9oU7MmkIPzuYN7Qo6mw+TuAO+URJhJf9KwVuw9TrI=;
        b=BGIl3UGfE+9YTV5UGL/nckKaf+DKPTu3VSNdA/D5q7YlMebuzR1xim6XzfAcRgRVRZ
         2v+4XdBJtemSfJ/bMm5glNgQGhULpvvFLGpKUdfngkKhrY6LdPQDS5huXIFLBIsJKApl
         dCMoe15xi3SE9yuHY26Xa6wa6BUhjE+TWc4F8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787502881; x=1788107681;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=v+9oU7MmkIPzuYN7Qo6mw+TuAO+URJhJf9KwVuw9TrI=;
        b=DAOUKJmeb4XP1h2SwNNuYN5WeBAdEhhIkzhWQA17D5wEJ+GSf/u2zPdMcTLyJQtmiB
         Iwl25vc3IDwgpIr/KxHyOBEWiM56iBriSVpdi2EDvFKNPB/cUL/VzQ0Fb5aWIdRvKohg
         C6Tzv68QU9UauP92map58KXOJUU1r09mk1urG38/+dgDd/dAiuNAUi0K8ZCz5AbaHi3+
         fb8zlNBc6Ell1I0eXw1y0RBtTSwgm0zbIdS8Z/Ixd6fRTSdIfWLT064DF14R4+SwvyzB
         RrS0xenID8gs54mqN1ax82Rt3kAPqmSM5UbBzw961xE7YEH3Rd1/BTBc08qlKz+Im4I3
         m4Xw==
X-Forwarded-Encrypted: i=1; AHgh+RoYvFmwz95zZ6k5GSGJ5HbCHIjI7hWIghil4bnRWkjEMCAVc+O8CP1bP7C6pzeF8jFq+K9PByRK3gEHjg==@vger.kernel.org
X-Gm-Message-State: AFuF++lLqXVooL50+K3p60W6QmdYz2AaPC1gKL/vUqmGrvQh/RFTSoxc
	PQXVdrt7Y+E9y0lFppOxB8m2EY2+Uy6Zp3C4KoqcuuApSaKrO2zJWXZqVknOJVV87BFpipyxL0Z
	b9oKKjq4=
X-Gm-Gg: AR+sD13u/6ealBBvNhG4C2nQL8BR3kivOTa0GwrJrlh9wCfkBps5KuLqPpbY8KUHcnk
	m+M9e6qy9sUfZnlcoL9NKezlhSeemCFcYUHiVZ9p7LMcpXDTpfHGIQq3gVGZLPKGuQnAyItYny1
	cwpiMagqqXcnCt12/GwHeC/QuL8PlvbB/pM4ecUfrlq6UYwzB0pKHmQifIwiIjLz4P15HoXJyYY
	l6XJhiJM3iu8eskPwQ7UkY7s+EuW+8Ld2ybCfD+yBw2DSiEt4pD7YLa5lpVWQrvpq7YFpMnivq8
	k4thYnSnsn30oaFUQEGdTMbfKSHzYM3uCrQqg3V0Zh52LqMSsCXEoLl5BwKLaiYqLZZcK7z3Il5
	bd1aR3Gd2+wQ9vLENm+RLdkddDz+sii4R+J3sj7PimVmUX+ckS9focs2hjhkRwmVOYQEVrTaOTD
	osw+2Rts+XOWGq9tQc1qMyUqGZvIUKWQmovgX0uh43SrgTQv3mB9NU9lpBQIQIRJUteXb1QXLCi
	P+D4uuncaZrtLmIPr5v67LNhUHUJe3qoqs4ovR7BKTEypFo
X-Received: by 2002:a17:907:c8c7:b0:c24:680a:1c42 with SMTP id a640c23a62f3a-c2491c9a6eamr1520340266b.7.1787502881067;
        Sun, 23 Aug 2026 09:34:41 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968abf18sm898643366b.61.2026.08.23.09.34.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2026 09:34:40 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso4705366a12.0
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 09:34:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqbUeWZOswCo70LvlIl3pdexrb45v1aYTMV0K0d2jD5/Pi7Fi7h1afyHwruY8YhqquI4/Y8w1kEQZyhEA==@vger.kernel.org
X-Received: by 2002:a05:6402:5042:b0:6a3:867f:edd0 with SMTP id
 4fb4d7f45d1cf-6a582b2331fmr13953901a12.5.1787502880320; Sun, 23 Aug 2026
 09:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260819102828.3220130-1-dsterba@suse.com>
In-Reply-To: <20260819102828.3220130-1-dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Aug 2026 09:34:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWQKHpgAWUm=REzpD=t2DWn2_WVNMDXAerh3J9N3fG1g@mail.gmail.com>
X-Gm-Features: AcwNN1Un5nLi_OBpPTKrqoJx44kMot8CKytl7VfGBP2RLgpBqXzTjSoBy0kB-iU
Message-ID: <CAHk-=whWQKHpgAWUm=REzpD=t2DWn2_WVNMDXAerh3J9N3fG1g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update btrfs git tree entries
To: David Sterba <dsterba@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Aug 2026 at 03:28, David Sterba <dsterba@suse.com> wrote:
>
> Add new entry pointing to the development branch so e.g. sashiko can
> pick it as the baseline. The other entry is for linux-next and slightly
> behind.

So I expected this to come in with the btrfs pull, but it didn't. So I
applied it directly, which I assume you wanted.

Just as a general workflow issue: I typically think that patches I see
are sent out as a FYI kind of thing - particularly when they come from
people who normally send me a git pull request.

So if you actually want expect me to apply said patch directly, please
do say so explicitly, so that it doesn't end up being one of these
"what was the expectation for this patch" issues...

As it is, I kind of have to guess from the context ("was I cc'd or the
main recipient, did I get a pull request or not").

                  Linus
