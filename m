Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8236DA18
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498146; cv=none; b=YYqaRmui3zalEHHFLjVfmEsOGojn4iO1I4yKwSSbMhrpfDK4aG9FsxmTr89pjtrlSeyaSlDkIU8JibsThaVHkoKFrT6xLGn/Vvh9nM9G9rTF4xafnKiaAQInPMq/Wl4xSjJIGHB7l2EEHZ60YjwCcDHrrodrvtkrgdTN1yXs/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498146; c=relaxed/simple;
	bh=RR1NenBgrAYdu1c55iySbUR6WPCvJPcX8MV/1pGj/Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrjEMR/Z2XeS0TcGZwzzNBG56uQqQVDfOXaHv6Zx0VYYugMPenO2XbUxhTugcdeFBDicXRKZUvpZ1vH01A+hTcLufgxTVYYIL7eYzbpxiuk7mhABL4d/1euyQdti3tYarIiLjtpqdtSWsQ683w3qSQVO/hERsFC87kffWcunsFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eiOXnVzB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD7RYlZU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eiOXnVzB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD7RYlZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778498144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
	b=eiOXnVzB/pI21G1epMBuoDXb6oNlBBDexTMU4Pa0JCBceD31HbvlXiXC/IZQa1Fj8l9LKV
	pw5PgOlAYz+3TPAX39WKLM4LkRWOgM1cChU19NATJtSHTy8eIWrTpo/2dvzXU9R2NFykm3
	lwEojr5JQKwtDDdhTXGyrl+BoIaiuCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-IpCZ0mHdPH-F2etxPkkqQg-1; Mon, 11 May 2026 07:15:43 -0400
X-MC-Unique: IpCZ0mHdPH-F2etxPkkqQg-1
X-Mimecast-MFC-AGG-ID: IpCZ0mHdPH-F2etxPkkqQg_1778498142
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e5df7e6ecso24957855e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778498142; x=1779102942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=JD7RYlZU6EskBY0iebQXhrP6fG75D84nXogDPu32FfcEw63rnM1IikbMUF2W/1X4Dt
         vZt+Wq8PziYB+4Hp7ysslCShy8FNO/Ok6TcQ4mFZ6m0CiQTd60l6VyvOfoqewkkfBYYQ
         FkZf3iCfI+5BBlhha7ptXvQZyNtIxwStyV/4KlGARJYEQYkV5SXdLGUxd+I4kXg7z+vB
         r/CeTPBzHD4KfQFNbu0VqhuEplLProVADaEeS+0jmKCpu725WyJezz2C61yDE0sToe9q
         lDw3yxAMwWPWjke4qYIA79uVQLaRPgr0bJBWYyFBaIo/2EAZGrKxl8U4V5UuHvErYF9T
         vgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498142; x=1779102942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQi40JXMVWHDZRjke+rHrQlcRrLFkKa2WRv/wpGjnDg=;
        b=kGab+93u+Ajj/jrQRLXrtIf+7bR0Yjt4KDIgscMfH4Xu/bq3nQhZaO32LF7/Tkau86
         BD1Vkjk83CBiAWiwO1bP5IUXUjoaC1dqKcK2XjVM0yYc1CawCptd8mxdFSjGPfJLkvQ5
         URiBJIJKA+NnmMTGIF9U27P+c2L8l0/ynLAWNcyW85PA11wmEff/pXbWegt7XwrhR29x
         l4rULm2IS/p0MYQRZbiyNhtGslwrmGbgL9FYVkzknWN1SXtZdfazJoN+gnAiRj7VZi+q
         6rkXTLB8nOi8I+nhWPvkKvCUwqcwLdWkdov7Y1LaTiGrdt8SEkl14Y2A3gTO2XTS8JJl
         UK3g==
X-Forwarded-Encrypted: i=1; AFNElJ/tmuorxDqeH1aBzRF32/jlj4zVJfbRGfsPL8lpJkV4I1x31++mJfT6T9UcVsYQwtsg2prfJP/eHlmikg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjZgZQNnd3NFpYupEr8NCMktBAfFMwwJec4JjGUaJs4Y9VC2Vr
	7oIhdmM3whnikzzOCZckCGvoG5GnyWt8zcUAzcz7cH/0ej+bgfvhh/3o7rKc6u6hmfa5/5JYQAJ
	GiKvGRfFzEQ7EzxxBPM+W94EFch12vj+lKDo9e3UYVGNsPmdQ0flQIi474w+LG7E=
X-Gm-Gg: Acq92OE/xo3PQ46jO3fHNTXNLanLuRmhu9i5GG9qFrwzQ9jAvzSlpboGpwaTC1Meh2v
	vUIWCd09B8UFk/5VNugvCtpXaOHZ9IRHyuTm/lYfPG+KABDuGTQZNOhRXoOq2E0QpZf1WvFEOJd
	DM1rF1YCsKHCfSYFJICr4bJ3OjOVzyd/L/UxO94GqO7NNfVIx4BscL0hCWziPclAQflwdwnW6eb
	C0HodDMLyyi301b3bPcz8YrqrWxpMvTZGUDK/wClNJltz6tS4W+Z6x9pwMxjnEuCj9GnPDzByCb
	TkC26b7NNwWWto0zV+mSq0LDMvpL/79UdqFryey7nkWaYwnVXx0H8rvtLmIH4pBfg+z0ZcDNy6d
	u1A+Sk4rQrHk=
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21083595e9.18.1778498141641;
        Mon, 11 May 2026 04:15:41 -0700 (PDT)
X-Received: by 2002:a05:600c:1f89:b0:48e:8741:fd4c with SMTP id 5b1f17b1804b1-48e8741ff98mr21082605e9.18.1778498140980;
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7040a9a9sm309872515e9.9.2026.05.11.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:15:40 -0700 (PDT)
Date: Mon, 11 May 2026 13:15:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v9 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <hnsxzymuydf5evoxw4chao7rkixm4eafolebxfjtsqschgfazh@nll3fdfnsigx>
References: <20260428083332.768693-1-aalbersh@kernel.org>
 <20260507055217.GA19888@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507055217.GA19888@lst.de>

On 2026-05-07 07:52:17, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 10:33:06AM +0200, Andrey Albershteyn wrote:
> > This series based on v7.0 with Christoph's read ioends patchset [1].
> 
> That's not a good baseline.  We'll need it on the -rc that has everything
> from the current merge window at least.  It might also interact with
> the fsverity fix that just went in.

Sure, I will sent v10 with a latest master and that fix soon.

> 
> This might also be time to come up with a merge plan to figure out through
> what tree(s) to merge it as there don't seem to be any maintainer
> objections.
> 
> 

-- 
- Andrey

