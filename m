Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947B63CC9FF
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774987592; cv=none; b=acSOCLaLrBLoOZMnVfQZjlVHqmMQ58H1k0LUOwNp4vw+q3P/F9Dca1CNAIFlst5TF+OqxpmEe6JS5rkNPY8QFZXWcqk0vHM4/V2eruAQHpE+4pdaSWOx1rWlXgEG0OsQhRdhY3yrbfkUKi1/zccZFXXLRRJcxkhzcQCOnlvL+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774987592; c=relaxed/simple;
	bh=u7Cm9YVElUVjzpDu2GXr2uaPPzVtpRbccwHlOy6TUvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UttuNqlQ9NmT4pG+meM/DRrYMyd7nuXaz0VXF1CKIEVcSDqRWY8yI0V+os18OebcHYG+ITqUqy9MJjvfSH4kNkFaOxv3Luz1NEbqsqlPgN4BmuH6gWLWbFetTXYdYwk+9XLbJpViHT4wZ0Rx8H30bqN1jXpFR1/q3P5gIeDD9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UhgQURf3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gmxf9nj/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UhgQURf3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gmxf9nj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774987588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r0I94zO8k40YUG8ln8iyh6a8FQP9HTvjx16ZglDMrTI=;
	b=UhgQURf3XZOCCsWssKO01iEn3XAgtTabMYPyogYGrdSrX+k6T14fdT22E9GhzSkrryRR/E
	EQo6ubqHlZ1IJOv6T5VGeYmGSMQp+unY+my4Xgjiy+/YJMm1ofaqJVTI/QWYE4liXrUJrN
	Au8cNyaMckVnPVcM8uzT2VstOsNEEF0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-_gGGFaMyNhKYpMqeTpRv2Q-1; Tue, 31 Mar 2026 16:06:26 -0400
X-MC-Unique: _gGGFaMyNhKYpMqeTpRv2Q-1
X-Mimecast-MFC-AGG-ID: _gGGFaMyNhKYpMqeTpRv2Q_1774987585
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b0f4e632caso61493915ad.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 13:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774987585; x=1775592385; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0I94zO8k40YUG8ln8iyh6a8FQP9HTvjx16ZglDMrTI=;
        b=Gmxf9nj/siJlM58NYR/n8HraqPA7Dx1q23nc6zWweeD1k/AOlf6xeBu8GSSWm1b6D1
         30TWg6CJsY9A/0MFHtX7s1St5g7PmqBTRKF3VigaKM3X5qUV+oxk0gyaMgSBCVt80Qit
         f4Vrh2+0vweMYIm29zAG0cFfikbKWh6oP5NxMCl2e2CrdeRcQBtmP/anIv2sUKV9I0dm
         Sn3hBmsoR3R8bHqealSuYXXBnay1DrRp0/KwqoXKSFbxK9o597uhhD5xOiIoD3NZJwXZ
         PjmJLx8xLlc0WDqeQzaSb0hhTQ9h06cY1ja0jqVY763ee1rtLWG4ZvFlstxWmtHIbM0d
         eNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774987585; x=1775592385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0I94zO8k40YUG8ln8iyh6a8FQP9HTvjx16ZglDMrTI=;
        b=JMnS1tySEwNDObRQ/NJvQ/g3ZJAOc2XGMXzqYxLFGbZQGu6Ip1jI4iuVIpqTz9eLNe
         UgPQJQZcTPmMwMRMIk6l6G+LS8LBTIYe9nTap3wIAJ7/6r0rxAK1L9OCbQOxV2ZuW1MU
         0jwKv3bzln6nUy+KRR5a4UYIWNbDJuViueJeyQJ20EYdfPwb5cqX19zkfmjHWzyg05lH
         COHS73RGFGLWufAl+hBYq1s+BrCwC3nF8Jg6XuqKhB8xQ6B0Jv/mi14Pii3AFtw/f2e6
         ZDuQz6OuXzAdLPEueD05InJqnnl5XVs/g3LGu2fLzoM7/MEZGvcfI7BC29xIPmB7WROj
         a54A==
X-Forwarded-Encrypted: i=1; AJvYcCWkc6IuRZAHuHkiyLGS4j8ffqulI+4aO3QaHQWQjRsj7S3rTJgUXYuWQ35Y2oR27PQ+MoRXBrWeeKTuEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfPJv1H9EMHG4rMBz5Ze1+k+JkaanEtitO83OuW/h1O5xaWqEJ
	nB+DbzI75yftaypH9dh642Co8zqVr8P7eEFGaK3HgY47PCLuqLHfQ48k1MmOJs9L83xClaTyt8B
	CCHxAQ4sM6w6b/UfRdXCecd1XwzNbfbkHQAuEFpwpNvROyUFfaAEK91roBWp+EtWP
X-Gm-Gg: ATEYQzxEcmgAG8I+2kvs7yRB+T+7qvuvFYLP1651zyEzd99YZTjtsmKau8ATKn1dUxA
	qNH50OaquMOHYZ/r2ulXdfhagfqAhnQLCrkDEye43Fd5TTByOCs1/relS3Pkp2IMFH7/OLLNAgC
	o7Zel49YlqrsaR1ijnEbsdCQRtIY3eiULWjmBauRBW6iLlFlFlOetaau1mE9V8C5okrKdlxE5eN
	vP3s9FMoeRhboWGxJarQ4OQmBi+r7C4hHr4OvDKlreOJUjwegycR8i7z3ibduTmzKzj5XYvSKIo
	xlulOtPGKN+bBERVqRwMpcwXiUR78DiB7Rwd50dl2BjXJ7xqz1elr7Ik5nKAv9+kt2kO0uxXoRt
	wNd3S04chY0bzk0xjDg==
X-Received: by 2002:a17:903:2983:b0:2b0:b075:f2fb with SMTP id d9443c01a7336-2b269c7c5e0mr5139685ad.35.1774987584916;
        Tue, 31 Mar 2026 13:06:24 -0700 (PDT)
X-Received: by 2002:a17:903:2983:b0:2b0:b075:f2fb with SMTP id d9443c01a7336-2b269c7c5e0mr5139465ad.35.1774987584440;
        Tue, 31 Mar 2026 13:06:24 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765b93sm132177325ad.51.2026.03.31.13.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 13:06:23 -0700 (PDT)
Date: Wed, 1 Apr 2026 04:06:19 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/301: skip extent count check on btrfs
Message-ID: <20260331200619.buww7bpudldcmxof@doltdoltdolt>
References: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>
 <acN3QEpx_YZZN5Qb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acN3QEpx_YZZN5Qb@infradead.org>

On Tue, Mar 24, 2026 at 10:48:48PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 01:40:00PM -0700, Leo Martins wrote:
> > +# btrfs CoW extent allocation depends on transaction commit frequency and
> > +# metadata reservation behavior, so the 2/3 fragmentation threshold (designed
> > +# for XFS cowextsize) is not applicable.
> 
> It really is a quality of implementation issue and not specifically
> designed for XFS.  But I gues it is hard to force quality of
> implementation on specific file systems.
> 
> > +if [ "$FSTYP" != "btrfs" ]; then
> > +	test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
> 
> Please break the echo into a separate line to keep this readable,
> either by just breaking using \ or by turning this into a proper if
> statement.

Sure, I'll help to change it to:

	test $new_extents -lt $((internal_blks * 2 / 3)) || \
		echo "file2 badly fragmented"

when I merge it.

Thanks,
Zorro

> 
> 

