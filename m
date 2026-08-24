Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6914142E42C
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787579395; cv=pass; b=icR5qu1nUzthNBjNKA00SS9GuJL30NmIxqxk6d3QmCrFK1kMKxEVfK/Q1ZNSDFIElVm5qe0NyLD0fu7/2umwV0I56tgbo3xGl12sOKR2rlDLnaCPu1GWC+UjmhxoBWNcImLudvd7qGawB9bLJU98EtS5qes2s2RhFDrQiUx/NoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787579395; c=relaxed/simple;
	bh=Gdi0w031Cj+0ZM8jnslnu596yibLYY4OhKTpyU6L/3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBAudtPsquBjmlmrT2iyKWIXcC3FUaLzZRh5AtiGAHayt8/B6Arm+ufmgKlCfmKiXHmjprzy5OxQvENg27+5QtYf21uaIBfVinLfdBiDCk5xlAfDxcBe3LvUkZL7bBEJkW8FM93Y+8dWwZIMe9ZXrVG8GUpzEp5ORuSmPaFqKc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NDMoFzvQ; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NDMoFzvQ"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c8e2e39easo35250501cf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 06:49:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787579392; cv=none;
        d=google.com; s=arc-20260327;
        b=dEhJk6goOqtXnHsrzVvzODObhNYbdLIEmtuGctcx4kivwuPLCP+YL8VM1l1aeC4qDT
         jU/g+0OeqLlsxgaQ2hfFpr3kEAkIunsO6ChzicMgW3i88lCgSVvhvZuwb0sZpcLeKjSU
         fR0xgoCbMXQrozqJPwaJfePHA6EcHZiNbG604sdMlV+W+5guiAhuHzne4ytgrQ6Z7Y48
         NdmfUi9/jBmdZm0XyDOyXD9+7r8RTjjCf0WrmkdGhBkr1uI2Ie9JyHsApufgz1lhzYqX
         7BxwTI4JnX6tuP1yB+nEjXAasCeT4FG1lTOpdh0VIeyt3DdW8WczVGKjkrzgqeAlIedk
         CjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        fh=hdswuU65dTF2XlB4zlwLJYv6rqKgRcpByH0EPqg2ER0=;
        b=TBztjZlFPQXx4yQBljWdOUKrzaSrBAStWSeRqUsDLMBL4s96S5zmNo4z5eug22zg/K
         +uioWKZhNi7n8KVQsqJf0mihIdlLzz8UpApgRjCJkAcopS01y2n/2yf4deMCfNJN/xp3
         sbuUb45SHqaoB2wN45hWSd7UT6yBzdjhYYr0v1JNFr+GFp7fyaN52vjN45nerYM9s0Jk
         IPOTMdMaumqdpIetn64qAtgk4lgiEDd2Ull1vOZotPpaSonZYeqhxuIGEfAwWRve6mbW
         U6SEOvYTiD0nxEfGaJ78Iqmc+c3PrLAPckphpO13TinkAJ6rMdOyC3DzdfU1ZiIfL1vV
         8Q+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787579392; x=1788184192; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        b=NDMoFzvQZiYLhYfgLRj1Ktm3K7LltETOkninXMRKeKJsVGrX/f5yYwoKebcqW5zE+J
         Nuh6crj5oNcOPXEhNSWgsZDXUjnF55flY4e2grH5zeQSUf+xTlynxncJqIWBpEWpcJh3
         2iRMqM1j+sNOmGDXD8voA/XnGZe83Hp5BGNw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579392; x=1788184192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        b=d8GHmsJpD7iN9JBZP4s2ecJJ4Zg/7aYa+DNO20vm9eQYALHMZsqanFRMSB1807Gkak
         oIU/lAw1Kh7yVYa/rJkFaSaul9Mnesg9qMTzQRWpF2VFXDR9qW4waL4/PZotx//QY7cM
         wlcId8x+K+f2MSJCziam9CG/ttcNokKODwKtnZNAkVzKCv/M3PUhZQ0OL1OIzLa7SG8f
         BbrfSngdSWmcKfnmXPjSkZmGKrQ+cNrw9dR18mW/TbPwswTPfRYzFG0EyHMDqB3XiNtk
         rQZVv10l617BNKYypsy+2FVSF4H30944soVdVsr+Td0Hgjkv7jHZU1FS4mRWSA198PVC
         CKhw==
X-Forwarded-Encrypted: i=1; AHgh+RpyLTp644vcgx9yhPyI9KGYJodRB6+tR9mqRdY6HzkO3DEyFmMJvLLi9ISws0YK13qYjkwE2cdp/49g+w==@vger.kernel.org
X-Gm-Message-State: AFuF++mTWmiqmKTKNU+X46FebPR4rvDLmSxOdIjg+qifTWRamqTEI+RR
	nfhfxyPTaBbvTwRh3TTHm/kICn54qNxKaDeZox8mrFB3cpinFHbZJK3i4GrZPslyQPzpjJbDpLl
	4cad/7zOGH4ZmrPsVxn6hPJarjXywT4u/NjKhV85IAA==
X-Gm-Gg: AR+sD10jP+bMbczEPH/g0kx4G5YsGJvhC3n0sFnKTa7tN6qrJg+7iBigUSGVZisqxGT
	rgWUBUL9IuORd/YuHXQdTS19Dx3AydorA0lKNK50QY4n6M0VLyhNdAYwNygLbCPJJH67XXuB6Zk
	7ovgE9kQL5XsAK7KHK3yklkKNTxcGVjFIealE7vQuyeorLeGIugZfBcMkBGd4HHgFcWrrni2AhB
	qO7NlSvN2FoyO7PrSxSPcErk3n+DOPnph2VBsoPMsq0rg94KoIRkz30AoVQjUjXDiYRNbgbr7U6
	ghkO32gN0nX/rp3peQ0j8+Ukk6l0uPIRlAs0khq184r/1u6ulmQzJwM1maGLbWmxGppXAxPm/Ai
	fYpI=
X-Received: by 2002:a05:622a:8416:10b0:52e:1109:8f6d with SMTP id
 d75a77b69052e-52e1109944cmr94356391cf.42.1787579392384; Mon, 24 Aug 2026
 06:49:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com> <aoxHOSC9kTPbKeNq@casper.infradead.org>
In-Reply-To: <aoxHOSC9kTPbKeNq@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 15:49:37 +0200
X-Gm-Features: AcwNN1WXkLYVG2Rn2OXRtnBdlHWAinn8Fn4WcEVqUKiB1DB-194nq79209afcM4
Message-ID: <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 15:29, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Aug 24, 2026 at 11:05:46AM +0200, Miklos Szeredi wrote:

> > Maybe add a variant that takes that lock?
>
> I don't understand what use that would be.  As soon as that function
> drops the lock, the pages could be reinstated.  If the caller needs the
> pages to not come back, it must need to hold the invalidate_lock across
> the whole operation.

invalidate_inode_pages2_range() together with launder_page guaranteed
that no dirty data remained in the cache after that call.   Yes, the
pages can be reinstated after that but those need faults and the
server can then serialize those against the invalidation.

I don't see that guarantee with the filemap_write_and_wait_range()
(with or without invalidate_lock actually) since the mapping can be
dirtied again without the filesystem's knowledge.

Am I missing something?

Thanks,
Miklos


>
> Before any filesystem people get funny ideas about closing the O_DIRECT
> race, you can't do that because you'll deadlock on doing I/O to the same
> file that you've mmaped.
