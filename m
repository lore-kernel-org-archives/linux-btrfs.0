Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF27C382367
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778423880; cv=none; b=hc6TPxgWkpibcqlqynaVtSJMgJzQLbm10eGkwbne4WquS3fibWDTms6Lr+A4yTMPwXDBb6SUmIJgC9s2fvgWbpUZwvPOB4S/itqmC/MrOeN7aMzBOaueU54G8IDGgbsYMMiqfOO93mtYRrn4tsvkRG3FFEdu8nZ6DH1TgqGairw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778423880; c=relaxed/simple;
	bh=hwmtJZrOUkJ4QvgQ7jV2Opf29vwJZexk/hWMdA8Y8N8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FT1cXTmPQsZzup8HoWqVONMe/lx2Tz81IFZRiNJKqfR2/CNF8vUHnyE6hQwydpnG4Hba/+jcU5IFYVkdPtMiJ0F8fX7ErBC6MUGP2wkAOwqlMqqUl5h69+tSxE7Y0rzUJal2H0cn7jXMw+QJOf0C9Vp/q/E6cr7PJWp4ZCXBW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MbbM7N5m; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbbM7N5m"
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-36643b96b99so2023929a91.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778423878; x=1779028678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=On33dapRVhJt7fDuIJByPnyh5KK2hPrz/ZMH8s18OlA=;
        b=MbbM7N5mLHYddU4CRlyyOmkkoFqpHSoR6gYXy/qWgyCpyyP1nG0qfx2XV1PhqmRjbf
         cyEJ2zUigqsYDxoQEgLQy/2CciZ92DNG7vblNzCNTQ2yglVdQXzkRdkWe7Ss81bol8MS
         dYDg2nMPMfwW0/iRy5iGlP3MtothYqggXsjB/k5hu1yPRrk3zjcEn3j227VITc3bWtF1
         8FQ+l4bOE9ZaMfvUg65Po6Z20BM+Ydj0g3OAXEBrAdPjAllytEBIyghgBorv2BFkCjKu
         sx5fiepzHKb8EF1IielgX9KbDVr9f7f5DK2WEswm6ZI8QF0vFrQgUtw1Vqf4Rl/nMoqb
         rhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778423878; x=1779028678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=On33dapRVhJt7fDuIJByPnyh5KK2hPrz/ZMH8s18OlA=;
        b=lQMraAad20SXX2xP99iLsvme/mdCHAOZWKyno4aFhxGc3P+85l7uPh5eRpBT+RV/UB
         1VvFni9G+mtN26YhzvcfQgbmuBLEQ3YaxL6nrZbvIYkPswpTq2EUr1+K9wqZ45cj80xD
         XfUEhjyRqrv4+EE7XSuiYiC6HNqOYFz77oJh+YvcVKhsdfxyltuKlIxz07yeVksOgaJl
         blPayOA+8TAIy9lYQEhfK+IbxUDPIG6LOxmmtkLtKaWG0Cec0z8FowGPItC5flDmNbO+
         TDupVFF8QXgHV4VtAMVY061JYsDcDJ3neJgx4rrQnd0Y7Jhyl8uQlvZYiwdPmEFs2ez9
         2Z5A==
X-Forwarded-Encrypted: i=1; AFNElJ+meBHMljqqJy2tOcA6b9sWxf5P13azWlLwz1mFhXc/QrgX/4mJw71jimUsoPtUo8VTb/XcnZVIgx6NRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYG31SmoYZ0JuD7P8rXswNFaDRa/HSH9oe1+v9Cjrkzg9SvdHs
	DPSl4hWiWHf3rRdxh6TN50qrYcUszjBvEcIOXBZSKfoORpMGlFrc8aWY
X-Gm-Gg: Acq92OHCxGUh3KpEm19CuFQVZqQhLbk72pH5OpsWv3mwLjwOxLzifjAUa49ds2skN9T
	4bPA5ROlWyUhM0ijAXrzK9TyuVqTBg7efedA6+ajeHB7STdKDKqX0OA6k6NuL8nCvwHUqv5T7yV
	wEn04sqNPJ/vQaYLu7ikePhMazwf+imypcsMOf8cGpKT7INQVpTIcHqlk/mAb/Olz+3uZl9ngch
	QAKsiPkpssmXYYMCPAuVY45lLPdvs3Tm52UPrWVSonFmsRcZR7t1EDvrhJVO4rS1xgsGrOsPILr
	uNQgis9C4JpBAhmFXRLTw8ppSMcmImH/4qS6ElfM3bb7pu4kDwbzkbOmjWnHucfouGU1xKiHjXe
	6hesdOhf5FyNWyFwJN8xQ3Wj/J2igq3EkcfsQEbSgUE+NWqoLp2GgWjbMYnS8vf2+hrKJ3IdDae
	hGiJuXIasQq4sTz+bScYfGYxKlHJ95Ac0=
X-Received: by 2002:a17:90b:134e:b0:368:1979:5e8d with SMTP id 98e67ed59e1d1-36819796535mr3145888a91.2.1778423878069;
        Sun, 10 May 2026 07:37:58 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d660b828sm5097779a91.16.2026.05.10.07.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 07:37:57 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: Re: [PATCH] btrfs: free-space-tree: reject mismatched extent and bitmap items
Date: Sun, 10 May 2026 22:37:37 +0800
Message-Id: <20260510143737.3710784-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <qu-fstree-20260510-161100@local>
References: <20260510074943.2644334-1-rollkingzzc@gmail.com> <qu-fstree-20260510-161100@local>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 10, 2026 at 04:11:00PM +0800, Qu Wenruo wrote:
> The later half "key->offset > end - key->objectid" is unsafe and very
> hard to read.
> 
> "end - key->objectid" can underflow.
> 
> Change it to "key->objectid + key->offset > end" will be easier to read.
> 
> Furthermore, "key->offset" should never be zero, thus in that case
> a single "key->objectid + key->offset > end" will be more than enough.
> 
> For the key->offset != 0 part, it can be validated inside tree-checker.
> 
> Please use unlikely() for every validate_free_space_key() failure.

Thanks for the review.

You're right, the range check should not be written around
end - key->objectid.  I'll change the loader-side range check to use
key->objectid + key->offset > end, add unlikely() for the validator
failure paths, and add tree-checker validation for zero-length free-space
extent items, matching the existing zero-length bitmap item check.

Thanks,
Zhang
