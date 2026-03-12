Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171A31E844
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323465; cv=none; b=MOzQrtCXrMZ1lPMJcChjK8FmwAkRRIOwbfM9WpoGi10Og5zj71d7HPrksgptMFzLkhV4+Aphmjm34HTP1e5k0rdDGxEn+npY458QJSQm3aFThdN8F3JBXpniFZ1sYZSNecSwqQFdGGrDOpfQblXKtgOuxLjOhlJlkUN0zIdKre0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323465; c=relaxed/simple;
	bh=m79QPg3lZxtO3qB8FGmL4feJvOHf6hv0uj9IuHB+gbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7/Bl3Vujoq1uPraZF2emd76hdiq2PtfZSfi2I9bIBqXBWXIFFuVUhYQNn88gjC3exoaXrKPDOLu+HR7oqxR6iZypzH3tUYuaFZtZ/etHI0ChKy459Ae7huCYyCZt8De3CBMcvk0rPxxavgktlk56Wk9cmNOIpkUXB+IJsTGjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDgpNMZf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKkFTRLV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDgpNMZf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKkFTRLV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773323463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
	b=bDgpNMZfh3uJrVwDPtf7UtWjkvyII/y8iCx18gHnqaNbHMFa6SLT57SEgP6ujdM2DBNFHN
	VSi8ES0EhtBsg2TB8oVsQfSFc0RXY8DAcNaeTIwBl9zLyr29lg2DJRP8jIo4AJBskKax/w
	yv65GEb9g0RITWFUWQKDV/FuleJiELM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-Hn7lVNUdNY6Xs6a5lI8TTA-1; Thu, 12 Mar 2026 09:51:01 -0400
X-MC-Unique: Hn7lVNUdNY6Xs6a5lI8TTA-1
X-Mimecast-MFC-AGG-ID: Hn7lVNUdNY6Xs6a5lI8TTA_1773323460
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4852fbfc379so12912195e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 06:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773323460; x=1773928260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=UKkFTRLV/0FpcgXxXaAqKqccZ+9UaoVYGX+kZeHJOOWrZj1hl4Pm7YWUH46/PUxJpR
         JiHomMvQ9oq2nntEilD//7XxR2aeabWZujfCvZvx+y/D6LFXN3130DKQl5bQR9jCn0Nk
         luCI6ukJKDwcMELQQFIKt90G3QIDBejsjAAFW8ge22JgldGzs3sRD2xxBUEb1FSPOhjr
         bhkAbZyY6BVEUvWXfHfdXBiYE5Boodi3Xeuz0E79EcAcLYH4cDiuE21xHpiitsXzt7jc
         yrR+1ajoWsiUsOqXxcpNCTQAFZFYKR/Fkuxy4D7CxUgHgGbg8i3gklud+A/F53XZG9DE
         cGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323460; x=1773928260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=G+vqzROv6wr1DNNjkqdOc4ErqElRO0uwrSQ8512yjesCc/Q3hysRqGVqRFfzn4RlGN
         SMWzENJtx16NMaeseTibom0fVdZ0PvDlbrZJxuOXrMK64Lr/S205/ELFpjC9XTOZE+DZ
         h8C7zt2w8ayVwDD7MDBK5UTqZace5OunNMaGw+nPfVHMWQv0agc3OuFeDYOI5LCN9zgD
         ai/Bz83BjQMdg1aXTjJovc/SySfXOoDIJH1nV2XjPX8s531326Ek2Bams+JZh3quOAVl
         twofEaumpDFlAZcLlinRot1lvd+46jDbZuH4SuWz59V5uxQxpHvKfCeFNaDj8GgjSmWz
         3f4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrd8/HIbFZ7GDILTQkmLK5rsEsnaivshcfnQLDHaSNQRb/F4n/x9HaTFkv0yU1kvWguFueqd2LPKWOug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4JJVpMY7q6U8rVSgaLvmrmo5GMf0D4m/inB9nGggVj77d3RcG
	X7uo+uSaPinIlMZtIgft+KC2pwAEANix3iQhZQmvF8NKvD+olARtBpMzaOPBSHWv6YaH2j8VWXe
	XvzXiWKlucP6iyMQLy2s5D2FoQKFAZuQU82C+iG8p6xCPwuhcgdMA6ui6p4NmWA9qebGFMhg=
X-Gm-Gg: ATEYQzwCV5UWucSGgNp7SrK2B9vis2CKvT5/HJApIyDnEkmegFHbwSyMySQurgvnQnR
	JSCz5w25lJVpiI8lIPzBQwwHF4j1h0rhLRDrYAi0dq7kPSCVdX6fSNOTVWt29gXMcc/5MA/4lJO
	4moxnYsljUQS3CE/vx90zIxecZCbPysMypRHBYCM32lsojfKPPRh/N+k6RMqa1CLpPRFXXa+NOP
	+6P895HtokJGFoTPqg7JHk3k+VNsLCdPsOUH/8/+/esfSiIoo+xHyl/X2Ab1/Uutn7rWYcZ2Xza
	6dSuRdYEs2hGzYqmJgoM9UMsvoJhGGZ0klEdsDbL95/R5KpJ20JK2pS2k4RUrH6gMAIXsfjz+Am
	307uYbG1c/hE=
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097995e9.1.1773323459800;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097485e9.1.1773323459224;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fdf09abesm8106385f8f.0.2026.03.12.06.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 06:50:58 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:50:57 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310012914.GG1105363@frogsfrogsfrogs>

On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > XFS preallocates spaces during writes. In normal I/O this space, if
> > unused, is removed by truncate. For files with fsverity, XFS does not
> > use truncate as fsverity metadata is stored past EOF.
> > 
> > After we're done with writing fsverity metadata iterate over extents in
> > that region and remove any unwritten ones. These would be preallocation
> > leftovers in the merkle tree holes and past fsverity descriptor.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---

> There's an upper limit on the number of blocks you can unmap/free in a
> single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> loop body?
> 
> Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> you've done a bunmapi.

I see, I will add a rolling transaction. Btw, why skipping the
written extents let's us use rolling here?

> 
> Do you need to purge the cow fork too?

hmm, what case are you thinking about here? The fsverity is written
in past EOF region, I don't see how COW extent could be left there.
Can they somehow be left mapped for blocks past i_size?

-- 
- Andrey

