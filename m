Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B588234DB72
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789847611; cv=none; b=mmGNfJg0rKZtV4s7Ha8RNgx994p7pmtKZuj+9KUSFY24l8Vk1kezezhdvWmbrd5723/xxKStvdoQWdlh1a1OWZBsYv34P7//fR+6IakLECmJ59jBmzQ/XWwcKKqr0tIxAt1cESvoRs+n9Fyq7Rh/wKBt1iqew6+zBdHYwsvgfN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789847611; c=relaxed/simple;
	bh=grPi4sL38mCO/zpcl4PDe5TmClgVRLK3Akq0l20mu58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZgYyHRkuMYfushqwXfY7GqPrS59f4PhXcHY928EVAVeYNxPxe6jsxE5DtZtAa7Wrni0CQ3riBOviFd9iUoI2kLfrGZWhOYtiIWSxvk5ZZJUypZs4r86RJ5h5UJJP9jv/0JhfOoUIrCJrwwx9o9nMd23eWgrPOcyncEMs+V6QKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qj/b8MX6; arc=none smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qj/b8MX6"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa06e51bc3so3014945a12.2
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 12:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789847607; x=1790452407; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGjddvv8oGsPTZlnHHs3B4nPTI0v+hJUCUNdoJx0o2A=;
        b=Qj/b8MX658zvmi1rvQVYol/+zfivCykahq1OMB/Qc7I1wcerCRSNVBYrW0sSA2hO7g
         ZinNjFMiD2cD+nOrAZ9CmQ670yBra+BnbPUj0metueV9jRQUIYKlnvY80JrEAsK9SzcI
         1SAKmA54UWI7TwxMXc4Y61URB0fhIqJ1cHIZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789847607; x=1790452407;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iGjddvv8oGsPTZlnHHs3B4nPTI0v+hJUCUNdoJx0o2A=;
        b=rgfchfQkTHB3SSwMQCI9gdKwEovis2jXukK+eqsfqJ26LOZTdcMfJIleSWmIagvy1T
         shjf3iNVnc+Z69w8EjaX0j2y94u6VT/+qr4/2eIk04DKibah2g11dicL3AAruJNlePvW
         wWWs0/LCsL1de5hDWysPpNsEiBEgs2UWUSeWjwAMDXdexdvneHziZhk5NEd84dpQxbis
         khfBgJyJca2pG5uosLdhqspyNSry2JaKDrMY+oJG6uCAXdQ4KDH1n3lEgivur3xiRVua
         Me47hzY0eEcxuh5OgdqJ7SktX/RuKDYeQE3bIWQ0zoTOJqYa5X/NTA6IrlRCSJDpjnzW
         odQA==
X-Gm-Message-State: AFuF++m+Y6DDAsTuY3NYoa26qH0UZBQFVEcl+1v4Mus/uH6kWQ9ZVdwG
	KRFZZZz4wfey84chPs4SLPPNGhZTzE4YevcLMzQ8lIrvOEi4Sj+o0ePmIackx3SIOA3JIJq4yR4
	8vVzVVQch8A==
X-Gm-Gg: AYBFou1/QoQGnhrjOmJcuBGLqr/QZ7swbkk2Ey8Nz+g58rVnwfkP2jRCM796+k2/0Rr
	3eqwqCRYCWNgAZaoRHHUG/0xNdJfkZ5IHvCfCBxByg63MihHQtFNR15OSTMPVVbqqHoMusFjSJN
	kYkmmtZNvR9GSDPhg9SlTSqhJbN6cVFGV1MuxVr7J5g6+W07GmQ1M1G/pEFqrd8RmcxJIPAaEZl
	iZAGxG423LGwSGsNaiBPojrmFhCkRN4lAdF6F+YChcQ56qXEKn137e2AXkfTgt8XAAJz8JO0fdJ
	LIMpEFPo35tIpycAJbJGHi4PcADf1ce072+hW7Je2QrfWsLZc3jbEzrKchgmYJUSzk9zg/qpi8T
	dzgK4Aeb4xYPQPIvThHg4mqaxp1gEjOJmpWps3UYTS4oovLaf4224sBpmB/T2ZyasOZTo1oXjL+
	QnmYT2joeFya2T+TBEXWjTrBgxoKrdSW+xcLlaAaqIm1oLcDuE9qtVbCX0q4tjzDYreUV066YKJ
	pjVDbE6tx751ruS1qVDq+qabKy8XntINXbTix6fDtg0ZrAl+g==
X-Received: by 2002:a05:6402:2803:b0:6a7:ea53:f628 with SMTP id 4fb4d7f45d1cf-6aa569a0782mr4124352a12.39.1789847606898;
        Sat, 19 Sep 2026 12:53:26 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67d819a7sm1579860a12.9.2026.09.19.12.53.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 12:53:26 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so347854666b.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 12:53:26 -0700 (PDT)
X-Received: by 2002:a17:907:1ca4:b0:c28:599b:7782 with SMTP id
 a640c23a62f3a-c2a15b11ac5mr645905766b.21.1789847606342; Sat, 19 Sep 2026
 12:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789845496.git.dsterba@suse.com>
In-Reply-To: <cover.1789845496.git.dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Sep 2026 12:53:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjwehxF3wP-vj23RXYH8RmK-Crmnq0g2wr6wNDet87S6g@mail.gmail.com>
X-Gm-Features: AcwNN1VrFvZJwPY6pA8DloIwbZXRJ8ZGYBgUm8OdHOB-IzSkClOBfTvn11h5BKU
Message-ID: <CAHk-=wjwehxF3wP-vj23RXYH8RmK-Crmnq0g2wr6wNDet87S6g@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc4
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Sept 2026 at 12:44, David Sterba <dsterba@suse.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc3-tag

-ENOSUCHTAG.

I see a 'for-7.3-rc3' branch that has that top commit in it, but no
signed tags. Forgot to push?

                  Linus
