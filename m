Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94222BE056
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786020743; cv=none; b=XBRA9ZgXbMBB57pTQnEiU40+/DVn2k7KlOaGtoKBCw0GHAS6/rh+tUx5PHNy5OXFp/VzIkldcnFnx/giVIzfnC6gZ8og6J4aIH040q7C23S7BChTgsc7N45Z1k+Q6SgvLA/jjaEchrcgsPBvUwOxHltT4vUc5FXSuhwalJICnKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786020743; c=relaxed/simple;
	bh=E+t1gFtcHDiraPPrfsroY+Aj4GCqUrp3X08deU2GKIU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i1/2B2qvLImDoEj1/IkbhLLXXHpb9ffmg9GJIX5qSulvQhQdY80Ik6EAGI2Wapp4+/4tpnsK9cd6xXRecvWb92K3FcAk0HbQXAIL8okx3sRMTX0R7iOD0xs211c0zAxQTpo/psACqBR11TgnwtweXPOFmOSu3szrnTyO6tN5LQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=QJpPa04w; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="QJpPa04w"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e53581361so122138685a.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786020741; x=1786625541; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=QJpPa04wKEU93cVUT6IOHEoTbPdj1SLgqIogOrZevNcBUAQ4+egaELr2nW/8bkBY8P
         QEz/4gTs+dY30vIaqKCtk6FJeoTG7uYJ8Te8GJDPLJs+GsvvAGl+iWBa7WckxDks+nDw
         YUxNfptFq5UvWrSb2YWhxsPNYE7rIMrRe1ic5P7Fm9hcBNXrg6rnWjd9syuWKjTG3o0q
         QHkmWriyni3+mWGrQSrf1S5FcsaVVZvUKyzybfTu+gP38m2XkiJcarJBGX5y6FGm+YEw
         Qn98v+3MuEtBsSLGFM9qAQzZxolAsRE5FcgM9EzVu2zmcicsyDqMD0NYvor8/u8yxEZa
         R7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786020741; x=1786625541;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=HkDa4zPYMadr7XlQdSZi8rHfpjOdXq6Up+N/jR4Hk8S8fYeUb58rmqVcbBTU01vBk4
         6ReVg9MVWstQupXSw0amzW9Sy7AoIQMnQLeV3648++DTXoufkVYa1WGIhqnODO5Rl/rU
         zFDVgYJozejwtHWM/v4MPnlcru7y5avlWJLYrK+APuyaJEW0W7dXl7eVwzJJwUDnAL8L
         r/X6tifgOe4LnQMvsETILfkaisckTKJce2ejFkVqrmX0+xQpJzi0ZAOklw9+N5BuhQ+I
         mFpDzYX8UfvX1QJdflV3LbOZbCRdPBcT2EKIdqhxtwmUkrqcixmqClzFWYZAdVGLO58e
         7VaA==
X-Forwarded-Encrypted: i=1; AHgh+Rohm/p0uFxX9yuRyH3c1h7ChmzDSwA0NDsc6h2beNx9XPKJbYXF0I5gwkTQ8U7YzjB0oQPlkttjdASQvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQfFtPNrs4WTJEWMeJ5CnsvDxxkOY99MZIe6KBuA2gzWOmzu7d
	Cam/dpW0lotorfoqAzXhYmDpihKkOLEhDvsPtRvuFFdGiLHNyvXbF6BBwjT/C6y9Jvo=
X-Gm-Gg: AR+sD10ItQza8Xq8LelVVK+uF5H4+Oz9zEmrrlrauBqrEYcZ16lpgZ62iqbtgg4H5ou
	rcC7qhTeU6PQEx8o2ND385lR8DlH/n7Zoub1WdqjQ82me+eEri0bDpij1d6nDR5798lrNKjW1w0
	Ay9mJHTVWgTpL+cxdGGk9RdYKUiTWQQ2C8LszdGaVxDz7eSO/ApXTW5/XBSa4JtzmY/e2urNUR/
	aEwBWO16gF6LoWdaDIqBTw9DPgxVEdBN+MNZ8552Ik3uqGC/gDQ+I2e7WCE4QEpXNSasy5idNXO
	D6xXkR5wJ8Soi2/MAZWz5TZi8SXeMyUiU0G/yCOqE4yO6435F1xmIoGxbQWs8mJPrZcsPgiIDRJ
	lEq9zaYB9DC2DaRfxMQ74IORi9SbpRm/x3UM79XpbwI9DvvFWKPxSTEMLrcLjq/uM08wZ2k759M
	Qm9XlOj3QEUxM10I73rDkTjtyon8ZlU8q2y0pFuYMg3n86GTi7NIWa8wQSn4nnIlx2mKBndKS9C
	7QbEtntLQoHsD+xcS6dXGJ/FoBTxTJu2EzIF3I4xuMqavwJ
X-Received: by 2002:a05:620a:2311:20b0:930:84d0:fd3b with SMTP id af79cd13be357-93648fafbc7mr1150209885a.7.1786020740525;
        Thu, 06 Aug 2026 05:52:20 -0700 (PDT)
Received: from [127.0.0.1] ([2605:59ca:42bb:f910:6d9f:8dfb:ae1:441b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9365ef833edsm123847685a.3.2026.08.06.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:52:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>, 
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ceph-devel@vger.kernel.org
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
Message-Id: <178602073720.2137920.17721545855702977301.b4-ty@b4>
Date: Thu, 06 Aug 2026 06:52:17 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 06 Aug 2026 13:19:27 +0100, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

Applied, thanks!

[1/1] block: rename bi_bvec_done
      commit: b539aeacf8cc5e9d8e5d94625d2d9c697a167add

Best regards,
-- 
Jens Axboe



