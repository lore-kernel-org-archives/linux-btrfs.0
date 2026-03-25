Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6954B3D16EA
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 12:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440530; cv=none; b=AF6QvXOUawv4WuWGvvML+PBIK9EgRDf2olgKeCawoQ05ZHkkp35A3ui7xH1yU8QURHd5plE/s2dJHI5jp7+CSneIUFELxJLiSg8hlZUxf6nJsiudg+oEWqFtGzWacAYwMjZwOLPfbzGCDyd7aIass/6QndbaeyynnFnNNnTAvGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440530; c=relaxed/simple;
	bh=LbeAqmlJTzsDU2WI+JQRb0J70AEGN7cPn533Ft2zw3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcR9neKxdwWSmrDcwy3S+t1QwlDWP0FZVZ1vnI3Olu/ZgTaPhcn0/0pgqOHcVpoV/0ew8qcPmiFEX6J0X5NdEzylvpLQ5SbV/Oa4rtkJu8sEcEbHrAc1S0+7KdtGvItUA3wLnSxN0ZGIHSvOiGQ71pIJ7XcrHhR5vfsEHPsZtww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RgIHLcNX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=G1yoz54M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgIHLcNX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="G1yoz54M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774440528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xgQzcNVTgAYMtY/AG+BgYI0+wd9pZeBrIlwhVeuWoe0=;
	b=RgIHLcNX+NWLbUPNfv4Olv2oJ37ykk760m+Pbb8XoUenDixt3e0Z1ysvki1sjMJ2Pa3lTP
	S5DZ8po/rM4+coL2AuFATxpS1Kd2Lb+Ai/O//4mts59DnfioxCfGXdxiCnvlKg+Cb3NBaO
	lTb52YA3zHcLOUEgxo9baO/ogNg9ZzM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-5a8oYeLpOgqeEOOSGfTcmA-1; Wed, 25 Mar 2026 08:08:45 -0400
X-MC-Unique: 5a8oYeLpOgqeEOOSGfTcmA-1
X-Mimecast-MFC-AGG-ID: 5a8oYeLpOgqeEOOSGfTcmA_1774440524
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43b47c19ed8so2597207f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 05:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774440524; x=1775045324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xgQzcNVTgAYMtY/AG+BgYI0+wd9pZeBrIlwhVeuWoe0=;
        b=G1yoz54MAUMJ2qpywnQfiM+YoKwm+WbO7U3YMxFsBVjE87pW60nS+9Fhh39YXfiDfL
         iLapvsxdKYIceymdRWKFxXVez0JVDyWdj5FvNWH6sShung2f8VUBoL6BypALZAxjYKmi
         YHlXDM4t64iIAh3zdi/IHyuKTcC/6QG09rJ4yynQ1X7204q8htvzhmKJj+hL0X6Db/Vd
         7oMTWZeIVDnn+kjcWwVJMENAjqB7mLj2djM0aQqSvDXSZSvTYldysXNkd8U6nFbFISAq
         W0VluO3Zn7dBK4vlpJuZf8esRZhiPB4YWxhIkoDVkJ9Brto22z7xDoF18EUze+Xe9QVN
         +r7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440524; x=1775045324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgQzcNVTgAYMtY/AG+BgYI0+wd9pZeBrIlwhVeuWoe0=;
        b=ELUP7e3xnBeKPY79cetIYK+HSEx2ctND9nS3HRV52NzD3SYsTs/tqFdW6mMdOTQ57k
         vKpqsGp8AeynDKYgxqJWAYK7bL2KyQZaFnyZ2rdfadXegLOS92ud1E3H3hodVTldWqJG
         CpRETJWjmHsY7cyR/ZOqg4FDycPp4Yn4HovbbiIiHGYdCYNrkBlP0IBEGDzMzfWQLrcU
         xQfkoTwUlSC6S9Lka43UP6Pr1zfyfCzptME/qj26d6PALCNUdJGsCJl3AFCYUt8LPNDT
         UKz2ttahYCD1/F/N0CCRXNUKyv51HOXI4KOYvBXCTMNEURRamv1oTaVwaZ79wChQ9Oko
         0ljw==
X-Forwarded-Encrypted: i=1; AJvYcCWYF6ritqTRvfjHAwPKnxnYXgDAKoM8Wo6gxEZmmhnPQdPLOCkr7AfpFHOVFTFPMx1DSShvkkwe0a3iKg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Yyu1IJWoD32M5fGAFgAFTqV9HrwMUzdbncrGITQ2mg4Dmz3k
	vPpehXB4ceU8XiRrxRXwnH0RZoW/wF4XkWkaKw/5GMllJ7oacrY3/hce0U21Wj30Ahm/ak7Boa7
	Cy+HwEGOkaDP5n4z2RzaefhIML81ALgzSoNCeGmG1f0/0WYq6eAoOKhGuDQHiT9k=
X-Gm-Gg: ATEYQzwFy1Zu9x3o66dMQyzrAIT1fFg44hEpYEhZrTv8rUyo2c1lf+HdbI2/0h8D5hE
	h4p7PPZglZA45jrr98svyTO+aRNZCIqNTd3pIBWyJvTCtNc2IXHEYH6zpGH0ybUbdmsMieggv0E
	FK1P2Zm7yE1EvvtgcwFiXHRPqrjlkudNlTmZ54xtZuogiB47rGAMZRwo6voULEuI1726Xs53vJL
	905Y7L1UKedBmSc3BqiKWRhSMnLiF4Kwuk/pdxAsrtmUrYpB1hO/8L4jWrq4G17jqo0eaaCE6wD
	HWJ0LIFumco0uzw70nBGamiVMwbkrB+wMUP152mIu46R/tWdW+9np0XsNWVyBeu7t0LHp2XWRwg
	IOieGMac8XGaeoA==
X-Received: by 2002:a05:6000:2c0c:b0:43b:436d:782a with SMTP id ffacd0b85a97d-43b88a2168cmr4549296f8f.5.1774440524004;
        Wed, 25 Mar 2026 05:08:44 -0700 (PDT)
X-Received: by 2002:a05:6000:2c0c:b0:43b:436d:782a with SMTP id ffacd0b85a97d-43b88a2168cmr4549233f8f.5.1774440523459;
        Wed, 25 Mar 2026 05:08:43 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b90f17158sm216982f8f.8.2026.03.25.05.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:08:42 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:08:41 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 09/25] iomap: issue readahead for fsverity merkle tree
Message-ID: <nune2zskdoz2buxwj73z652azx4pwwkpsjjluq55mk3odybhym@2lolknvk7ddf>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-10-aalbersh@kernel.org>
 <20260325080407.GG952@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325080407.GG952@lst.de>

On 2026-03-25 09:04:07, Christoph Hellwig wrote:
> On Thu, Mar 19, 2026 at 06:01:56PM +0100, Andrey Albershteyn wrote:
> > Issue reading of fsverity merkle tree on the fsverity inodes. This way
> > metadata will be available at I/O completion time.
> 
> Patches 8 to 10 really look like they should be merged to me.  They
> all add the actual fsverity support to the iomap buffered read path,
> and merging them and having a single explanation of the side seems
> helpful both for review and future archeology

I see, thanks, I will merge them.

-- 
- Andrey

