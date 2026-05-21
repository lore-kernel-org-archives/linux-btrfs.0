Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCD378D9E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 09:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779356541; cv=none; b=PaJUCuGB+Ea/gbgZ8t1EWQhxavbHnng1gqIu6r8oD3r7EkRXnZdBujqkzWCkEGazISw039QIMuTig1JDloQl1gfapDIFvJz6aLWrVbpo679bAI+QUSsgMWoyJYUeuGjEAmhOOcrpXpVZtWizkJ8wQYB2ynnHZspZmYFxF+1dR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779356541; c=relaxed/simple;
	bh=/n6YuXXsfcsk7J7Yb0y1thOCuPSSvlN7WSB70uhim0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sb1V9GsjujR/dBdxsnw6sobfGIUzyZ/rHc+3fORkzlkPxLiPQmy26KfQTiAx7nsNF7PtTTKhVZHOsyFhzt5HRchs7TJbm1P952ecoBxY6F6URmdypR0pp196594nJBfccO/lM7VYZZ6lELJw+6NxRPwWZdXKST/WDFhnkJFEHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGcQDpYv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gE2mTH44; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGcQDpYv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gE2mTH44"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779356539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
	b=bGcQDpYvPLEbfBQZC3lTQsyr+3H+rvNlLXE3wyLChrVgz3Apo2altjc2wB8pfFOfDsNfFa
	UadquxiGdIqFnEDcyI2HQZx4+8VlVdn7CmW1otNXES/tIBRVaUSEV1co+/vet7wFiJPgDJ
	a/dekJKAtWfO86M4E3Kz6p0phUb113Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-hoI7UxbVOduob0w8rxapDA-1; Thu, 21 May 2026 05:42:17 -0400
X-MC-Unique: hoI7UxbVOduob0w8rxapDA-1
X-Mimecast-MFC-AGG-ID: hoI7UxbVOduob0w8rxapDA_1779356536
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45e2f74da10so6582897f8f.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 02:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779356536; x=1779961336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=gE2mTH44GayFr9mtAkmJVfSU67d3tm+/YLoN17BfGZH3Kca71yP9gzWsOKPeIsBvRD
         laEPjmCECV77JeVn2SVjFX74IqeEWHDMu8tUR8rhrshkr5wxfi2XcsVJccvbpbFEoWPv
         T0aUIqhFrL5b/ffdNRMW5j4OnaKfqZS5jKXSx8i7zQFOkQn+EJQ/EZi9N9/nAPflgD+5
         dy6pfrWDU14zulEvGUGFZnzpcbEeVydktffcHNVHMhfkzW3gi8amUGywq1wodNRvSV7A
         SWesHKw5+EIirgvWil3KTxyyGqJCG5WJq03iNKYm/EYtJ/BjPsF9U4QLV9nW/dOAZEDz
         6nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356536; x=1779961336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=QCAko3bKgLrAaKp8i10cul49+5/64zE39UTEXY5dQpXjti2oDRRCYq3h3GBjb2242g
         xBzRKbnMmahFfYnyv54SmPYv8PKSkrpKHiM+1Gw7fyidqGKYVT7RAN5BoWkiQGJyWGWk
         mDG+YwYbR+inRHzakDHI2UizZ+AMqzup40TowM1MIEBg1wb8/rSan4zd3/6wLXGYlbTx
         mf9zcwiAc0FUzo/jsPZMSrxCs3M/ebirYll1vtg9afTOQXXhCogjgcCruJwvrFGDXdYq
         sQ4f88xWc1wCnVV+alER7eWFKeHZWOokqPu5KLed6b8xw7MZrwAKPQ/94yNvRYgK/2cB
         pN2A==
X-Forwarded-Encrypted: i=1; AFNElJ+OmBuZ4aHj5ByBtoU5aA/w44KPL3Hk6xngPNWU2UbOjIGYxJrKN+dyPpbgjG5PdjHW1Of7Xqk07+T4dQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGjIgqSror/SRgHiCGnrg0HPhLR83B5VnwErNYIGsVNPgxBJ1T
	l0VlHeXOC00qtavb25go6KY2PPs1O6qm6ndw1sdEEry/S4E8hvNHoVLxb2omTt3m4M3b1Znqdon
	PgH3EfXOH0sukdi6EHDHe6SkqoG1u79O5k+b1vUZ4X10Gqu9u3JhlVfo0m8VQIQY=
X-Gm-Gg: Acq92OFS8sp3nu1/dohd+D56WQqD5+wuKMelA/6hVv8FwCE6/dJdVNzMDh2ekObgCtH
	RVJsWVAcjYtOrdiCN+7vRXBxvFZ18GhW/RTWSQFNARC7QolOAXKh0CCnoaKuUmOjOxsJPG08hI6
	iAquffjvj7OSg82+pOL7AteF3q7U3UAMNh4z9UR4KYYWAfGELlE3p0tQihTFd/mb4drmb7W+CkY
	9G1+xJrRVDwG6mdS8p0V210ewpP8DxRlsbINm4PeLrHL8n0UT126ukqFtoMi40FvlLnX20c1mDd
	D/Xy+Y1VK/rJmzO6CihfytZ186/EPxgt6rvFu+IPlTUeNt4ZaOEB2zD/avEVE76ZoKLwc7VZQTZ
	vTviQRiFTiuv+IxT8WqFV0NC+FesXy0x8DbSqZmBPOqu2yC2AdoacmMQ=
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775925e9.2.1779356536296;
        Thu, 21 May 2026 02:42:16 -0700 (PDT)
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775515e9.2.1779356535822;
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9abbadsm13930015e9.8.2026.05.21.02.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Date: Thu, 21 May 2026 11:42:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090705.GA14254@lst.de>

On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.1-rc4.
> 
> How are we going to merge this?  It touches at three subsystem trees
> (fsverity, vfs/iomap, xfs) so some coordination will be needed.

As most of the patches are xfs, it's probably make sense to go
through xfs tree

Carlos, what do you think?

-- 
- Andrey

