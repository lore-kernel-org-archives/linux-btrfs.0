Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793347305;
	b=RHypqOdmGXdzFOu1WTjCAjvbPMSheqrAeWDPlf0xfOmrQKE403H3+zkQnZbUGS/ctSRz
	 qzQBURUgNk/UKs2o5FjnKwY2f+iN0cx300MhGPj5MO3H79ndaWutmp9lj1gevnmB9kgiO
	 kECWVKQkHvnUpwavaXOk4jdWkO5994jo3zmgIWPPo4LKFewbMlQfRm0CX6tdF4Zdmi1zU
	 A/VewnaT6A+9riMtj/85t3ZFlZB7p9PMk51DMJQ0nLwTO0PfnTGEjHD1JPHFCiqhtwTRz
	 h16SwGiIGFJ6T3v9jLzWRnvjPb8WWkVGt8RtG83e2uSqFdNcUva+f3qv9foPVHJ9X8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793347305;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Date:Message-ID;
	bh=HiU9Iq5r3yO8oH6bAiojsX3njTbymprPTokhTTBOSLg=;
	b=onTdJHaHPmUAnEME2R/JwOA4YjvbS1aAs4Lyva6M2IY/z/ShJZ91G806+gCZ/oArgBRO
	 qKHb7oKyvL6ttdzjxO3h2/VadauYog2/hvnGtHCrWfoqz6YjqkdwiUvU9uxWRPk2Twj7s
	 Vr/zT3zRAmzI3esarIvW09bcyazSeYWkDHGGzd4IobRUWSm+ccuJUpzHo6Ekb1vfQ4LwW
	 vDgRYgF5crW61aRU1GECi+nEycs8G8J87rTgWzrdjnqMSxU+/frR0ErRra+okrv8nIry5
	 MA2AP5nOX2ggigZNRaI+om9rkUWOd5/uhx+HdGW8fWcMdeF2cdROAU/1clFFseNoXhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="l7A40H/3";
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145FF606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 145FF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l7A40H/3
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-353804b591eso710480eec.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 01:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793347304; x=1793952104; darn=vger.kernel.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HiU9Iq5r3yO8oH6bAiojsX3njTbymprPTokhTTBOSLg=;
        b=l7A40H/3mw4H8PJvOVyEBo+icUvOSFRiRii1OOeBadfhHqOm4hZr9z0JcggwX2eC1S
         piuUTA5k7Qpu2WMjzqCdOGBP7+xSpKeME13i8ZfWsKi467a9r5IP8MYfJhfLiRmXy6Bn
         lvqrNiC7+W4JPuk16QRc67Zg4veU8hWZVf8IvlcNhl6pnlHru46ThUa86vvcRcpqDciH
         ZLALuf91pCVZzSbq4Svq8rRlzpkTJSr4cka5vh2uHahnP9iIyIdC5XGtJUTyB7m5ycWB
         qfW1T8A8BCxLsvbfuAZixgKA5qP1mJ4wYJgh/TgcxQhSxlGlmdVXsQhuLoMn57YNsUCA
         gFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793347304; x=1793952104;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HiU9Iq5r3yO8oH6bAiojsX3njTbymprPTokhTTBOSLg=;
        b=LuWLIek6JDiokoQPa4Gi8FgMJEafEqX5KIfXyZ5Pke3q0pPXqTmPU0uh/4QogFqh1i
         nh8EKHxJgm2POlyuhjNE+7+Pkv2MyY/wJldqBoymfoZ8r/ekpLutB1aUUL7MaYkBq4Zz
         oxXBui3WcTxiKAJcbN6BQXkYBhF8EP56F178lfBO4YR8cgbLOYRi2Ej9yWRLKdJMreo0
         PNCkQvVpl7QL93GWx/pypf8dWYGiAZGi3ERK1qAY41It6Cf3V8ljzJEM2amGk+a3WhR8
         isQkMR3G+738mpQkxLgUL7I5VbCeCM8Q0X19t5y5STFMgKr5/vzpFJlHsznOiDiJoaxj
         2QGg==
X-Forwarded-Encrypted: i=1; AKwUvBwBYnw/qhJD+z2kST4nkY/7tMVQr5Gc+8Zjc84kpkV6SN+ccfcP2tdB08kk7Mpb4Brm8WY70vBTsiSngA==@vger.kernel.org
X-Gm-Message-State: AFq9FYL5LpOmUEMOagBNXODhAGROM7G72EIkaGbeH3A7VQpkw35QfM7s
	nOv65LBuNgpEVClNKABiSvihzYlBWdL1ppouMicaME9y109OA6ib8ZDW
X-Gm-Gg: AYBFou0xDrbc9tVBCZPswZsbClEgx2/1F5EatI5rBZ8AulxA+4mhCHjhiZwLH2Nk3g6
	v3FmVxB5Sg4vCknAZk8g6JciU4BtT1lw/gqE2VA3r42YpuGWqU32Ulu3XXYN/NEWJOA1tcOVmMn
	zCWgHll1pHgWN6bljxIHUmwaE0Apod1nb9+77znwGEMFxhqXnctQIRVpm+3DijBKgWLhFKbfcJ/
	W2EMtGYtTUQAo0s8uz3fcXhVfOHuw283ppExxgp5rSqNjJ8c/5nKwoYGkBOGz+dfZoXbThsd+pB
	YbDAlxiSiEVTvtwY/53ZPFzSxDzehmHQxRarCvjexvCoQgmHEOIctmLbgDNj8TOh12wd1BBD2l1
	dD3wjeJoqDR73jMh69HsLeqtQlCJWyzy4A50S6ERLoji/uwaAbV0h9CVWyfogYIZ1mcCR26NZgd
	VVCulYvZ13KQYhzEdi9SkI8TYYgUdCynp9NJ0sjqqT1w/NbTKocWs9zouuKBNRP7FnWesioV5M7
	CDdj/bXigDOdIea/4AEABhoGZaPQucHOfYu/EQBBS07jFmGtXh6QZbrbkJ3ANY6TB0onp8bsism
	Zz13d5OjMyVA0zx1MBUZO2wx2H1TZrsYxgqO12N2W/Jaloq9SGskvCg=
X-Received: by 2002:a05:7301:e118:b0:36a:1cbc:108e with SMTP id 5a478bee46e88-36a423f84femr2568934eec.31.1793347304094;
        Fri, 30 Oct 2026 01:01:44 -0700 (PDT)
Received: from [127.0.1.1] (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a98f65sm4883097eec.28.2026.10.30.01.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:01:43 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: David Sterba <dsterba@suse.com>,
    Chris Mason <mason@kernel.org>,
    linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
In-Reply-To:
 <CAL3q7H6tz-YXxtTk3MVm7cLAQh1coBAkcF7KkH+GUwZnznnFrQ@mail.gmail.com>
References: <179328314071.648427.12527832319954042748@gmail.com>           
 <CAL3q7H6tz-YXxtTk3MVm7cLAQh1coBAkcF7KkH+GUwZnznnFrQ@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 30 Oct 2026 01:01:37 -0700
Message-ID: <179334729777.2353588.17578956930431099360@gmail.com>

Hi Filipe,

Thanks for the review.  I'll simplify the comment as you suggested and
drop the "represent"/"remapped" wording.

Thanks,
Cheng Yongkang
