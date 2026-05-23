Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9225B0B7
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779561147; cv=none; b=r1168lFTk/lluN7iHNE3Fgt1iFCy7AmpEm9hAid/gFGu+mXqnvuIqoYXHnGR/uacy7hixIu9mZxr7fkOB26c6Pz0QmQCUCSIbkuq/1bLl+yulLi7kgCp8EhLNKaCA+rkfk0cP4SMz0YVEKvj7FLCPCNBurzCwX7xgKNN1Lx1LXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779561147; c=relaxed/simple;
	bh=hPajcYyIhGoYyempZ5jrgZZlm51vmw6YCtWjAb9hR8Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FVeEozFQ2Ocjbnoj/4ZcB7jNuVcK0S8K/tA2FBOs8BMJsBWJiahLs7XxKVTYbggcuCh+rQXB6ZVxtjaeqxzXrDVfzBzgOxRguUS0PdlxegDutieHVwm/3YWcX/OocMcr9gwhs1scZvLQ7t1DA6Xv3LABK+THANVZORwZxiFb7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YwvzeL+w; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwvzeL+w"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2f30a4601bbso8537360eec.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 11:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779561144; x=1780165944; darn=vger.kernel.org;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Id5dyBpQ6V3HQihPc3Wj/9kDk66whwQYXcAhNcn5FWw=;
        b=YwvzeL+wG+50H6NvtNcSEbRH0yhqyRVvm5FDxXV3Uuc9mGCQvRZ7PMtiFtoTvdnzt8
         L6yepNiwrYGZzxHsbp7vc+f2pNINUnJxQBva3wH4LemL6SViLRdcDMQdPUWQbKvmjWXB
         5xpEcPwXf77gWoC9osDPKhHY6ByEJDTdE+n+qZYTYHaKw4yJnefOnpMk896TDUN29pwh
         Q4eZC56nHpKBm277rx3rWIva8sKT6nYto2snhjJzezCQIIY+pnlCfKXY4FR34sNdnUsD
         ld0/RSqWBt0UueRwERwfhnbbDjBs7QAKZykxju5NFLHVZJZrSluMJd02R8iCQr4KQkdI
         9iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779561144; x=1780165944;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Id5dyBpQ6V3HQihPc3Wj/9kDk66whwQYXcAhNcn5FWw=;
        b=UJIDs4g/7hhjFV1qeryy5RTHbTIRsLT2Jtn/jf3wzYqtMT3TvrSkiDc0yZjIMkZ3Rm
         UAzWYDBN+zmsdU0T3TGLZr23oQyVfvUPXyAijbgS6QBv+AowumNmX1y7k7J+4qaX9oZa
         FOB6TPPajDT3bvsSWTbStdtXx/uf4XTfjh3lbRX0epS8dnXmL/BYX8xxXQUs6cWaqf+b
         WvQfInWKAxhkEiA6ewJ+k6NDa0i5uPGwz7v/3U4AMrbDhL6F6x35pXMpe8ZcCnp0t0lv
         hKCbt5EbVJcQL/dqU4fIrTiWEAYpdkUspjko3FS/j9vfxF5lmcwNBYVVjqukK60vfVWC
         YXtA==
X-Forwarded-Encrypted: i=1; AFNElJ/+vr8rqt0hDKQdkSOTjopXJ7YutUv8hZ/AYk2bEn6WEpPbT3sgPyVrqZno3MgNbb2LV6arfNLCbvh1sQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn5R2yNRYqTTSmXafvvr59kIY1/t3ibYUT9UfiiQPWPE3QaH1+
	FfUoOrI/gtL7Sl3hEAK0/FD3Fe68CXJrykl7rET5Q89Xo5F3+COHb2UDQlWu9g==
X-Gm-Gg: Acq92OGjQ2uvYqtufcOuPX5TkHWuWnH5AZUm5TWkkL0gZSyfcnx40xS+ffuyp+CtbTK
	mQ+px0HBDXorfDOoBv/MGVNtLEak9R22uyg9zOadrmmypFFnxqoWyg6Bcr8tBCXw4ZvS1ItbBvl
	EGaW1lvSvwTId7x9Mve6pnwvgmwao1inXWEH8EgBJlhaS8qRbeBb1bcB4UC56eL8t/kioDWCCns
	cfshkdUg6IKhCH6tEz2dC8WdIhdtv8Su9TS2bV1BGm8jwyFjnD82SAVaHEua272hSWLh3s9SREQ
	mo25khqEJ7fS8yjPqUvd9OPo/ks9O3QEYJ9d5UjQE6wMTq2ffWgPUx15K9qrKxqP4eLVWdfg7sT
	6uQzLxoygPS19H0nCLFiObl0tKM2au4WqE7ib6AXdCSBltNLW/rf03lxgxwR8evWk1a9UYykbUa
	s6ZVhxbmZP2ltSpCnnDrBMkFo=
X-Received: by 2002:a05:7300:6da7:b0:2f2:6dde:df50 with SMTP id 5a478bee46e88-30449054359mr4460387eec.17.1779561143969;
        Sat, 23 May 2026 11:32:23 -0700 (PDT)
Received: from fedora ([2601:646:8081:3770:10ff:fc71:c346:9948])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm5660277eec.25.2026.05.23.11.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 11:32:23 -0700 (PDT)
From: Collin Funk <collin.funk1@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: bug-gnulib@gnu.org,  linux-kernel@vger.kernel.org,
  linux-btrfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,  Jan Kara
 <jack@suse.cz>,  Christian Brauner <brauner@kernel.org>
Subject: Re: test-fdutimensat failures after 7.0.6-200.fc44.x86_64 kernel
 update
In-Reply-To: <20260518055617.GB10368@lst.de>
References: <8733zsj5qj.fsf@gmail.com> <20260518055617.GB10368@lst.de>
Date: Sat, 23 May 2026 11:32:22 -0700
Message-ID: <87ik8enfih.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Christoph,

Christoph Hellwig <hch@lst.de> writes:

> On Fri, May 15, 2026 at 10:14:28PM -0700, Collin Funk wrote:
>> Adding some print statements in place of the comment:
>> 
>>         fprintf (stderr, "%jd\n", (intmax_t) st3.st_atime);
>>         fprintf (stderr, "%jd\n", (intmax_t) Y2K);
>>         fprintf (stderr, "----------------\n");
>
> Can you share a complete stand-alone C source file for this
> reproducer?

It would be quite difficult. The test uses a nap function that sleeps
until the system can notice a timestamp difference. It attempts to use
the smallest interval possible, which requires a bit of work [1].

Apologies for the late reply, I haven't been able to reproduce this
since my original report. I'll let you know if it occurs again and
hopefully I can create a simple reproducer.

Thanks,
Collin

[1] https://github.com/coreutils/gnulib/blob/5ab7a04761dac69403f677de4ee44c1940777b46/tests/nap.h
