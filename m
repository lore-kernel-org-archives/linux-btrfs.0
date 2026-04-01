Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC7A1EB5E3
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049581; cv=none; b=aljKvVIyQgikNo72uxPrnrm3zqB9P13A9PkxaTMbJwZ93tuOqQeZntkvNCGd7AecvsMCwlwpnQ7JKfo5U/8NMGeeixS7QTnzAeo8RoV66+t0yszWIv5ZN7CVIbusjuSQb/XdeCrc1g2+GB6Ae2L+WzTyfn+IKPBVg/CcoazaEYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049581; c=relaxed/simple;
	bh=zRSq9GBe9RB8pR9poGoz6gdAAzNYkiK3X/2GByHGY5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APNGASSFun37JUEhEihd51IHNeDYIfOMhD839CuCs8Z621TPsGCfhLqvPGrnUGj+qvaa2mTpTQsUNxdmuyZszF1qDxNkLan1oy36hyVeu2F4ase8Px06kay34t17c1/Y+RgNEheXqaFmiB7+Yhfg+C0/vz3u2pvhfhds3W+xItg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNTM07Pq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PebdmVVE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNTM07Pq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PebdmVVE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775049578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
	b=dNTM07Pqtq0jQUEe3/nEx31HD+7YqmKv+dVp+eJpS8HMwklYHPxprwz3BXmprTJMf1MoNh
	0/M36iNTkC77q3moHXjIhokUCyTrDv3oQ+Uay2JbeIxBDyB91wHB5evWnJ4pSI1AmdgRBO
	KXFIcW0FfCCBjorURtvOh+yamasNTlQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-hpO5kWX4NBqt84ccRw0PAg-1; Wed, 01 Apr 2026 09:19:35 -0400
X-MC-Unique: hpO5kWX4NBqt84ccRw0PAg-1
X-Mimecast-MFC-AGG-ID: hpO5kWX4NBqt84ccRw0PAg_1775049574
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-486f830f4e4so51489875e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 06:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775049574; x=1775654374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
        b=PebdmVVE4cdNJ/jzEPt34+I9zC//EA29Ttu+HT3YKvXH9GNOER/JDErPV5JL5JwfH+
         XjxhP5qORrHDRxegzxqNo0V2rG+5N2I05DzDcdTwbLWkDYxfBmxvXbsymicLRt3PCI1e
         cvf9/2RvGPu97LIl5+WuxYxcPnFXiSrk01Z48FcFLYWu1gU99GGzY/6xSnka3Xz1UbJ4
         /64qtZkRd0806ffNceiW8ar0y1MpltkCdkdUJQpOhMaAy2JoarSXKQ6dkJN+E0dCZ9Ir
         qxDF+ubEUcsFQ0q9+HlyVT7gQwu3aZL8i85lF9cXRWq+JqGEuuRe1F+LSNMCMlaawEc6
         o9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775049574; x=1775654374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lyW12uBXRpbNCpKffg0iXnMuUrdM+MfpJppnsHO2xnY=;
        b=aotK/o5JjnUUqcFm/nl6ujukAKbcXQE+eDh5dcuFiEIY66cPC4I30HX/NycpHILx+d
         8FI3bJ8ZYqKY6ATfWZ0TQQEubk1cyyKNoNSX/V6fkCVtJqC4lOaqNbZqyiboia+YsXtz
         tV20YMEzh3esQd1qhMjiCIpNpMVXZejwPVbpsNa3vnLxRZs2lZF7ajFgHSjdGeQ9NL79
         iK5KltwHjFO1z6kW+CXncvBrabTfCNtmL25DkDK++mKr49D2ImOQmQdRG8sr9sHJaeG7
         xG3O5cGBRo1hqy2x22F+wlCsechdIRC+y3n6mHCX38GAfvx3YpJOeJ8MHZzOQSkqnSGP
         MJxg==
X-Forwarded-Encrypted: i=1; AJvYcCU6aoaXyOjCy1wEXpKyAyo460WSFiNUuOHFSxrOen9DPTCoxGNa0zNqhbC2ujjCkdG0vyJjT81yWLOQ5w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn9QJCv7TbCREDorvIKuNLUpDwrephrPTp1SAffITW1GrZiGan
	6TJZoZrCq/a48VTVHGcV0rifEX46gPca7JGJckftoQE+BP+S/EtcWIzfMltkCUSEuB/zWfbchdd
	EFd4KMsVZ+pKmvvi0AKs2nA3S+gjRh9ANwJLdqFICEzhv0r4dn88Y3v8dw2Pe2aE=
X-Gm-Gg: ATEYQzy2/huo7ot0YSVXOfLntE3RlrwHrVIIxWKbfadWMmev1I4AeJvEEiRXFBe055f
	2j4umHSaoXWis0wBg9yTAmNqpQALu4FiKJftzh/3aQjwSwTNgCyHt486chF63RNNcXbl3r5aOUU
	6u1XsWjE4bPo7oW29xHPRBz42PbSdbwemEvBdx70ettDA+OUR95/t6aNn0kUwPs6hwSxLzwBxGq
	rgF8Z/LAEqFOIuZ8NhEh5Ghw75KilygN9SUposUgKImLUDz/16lgeqx3lLBld2loTP1b34uVeP4
	0H0wjc9+7h1gj/eCVB19q/Gyzizop2hoCVLkgzgscyofPZ91HeYFFSnWFkQmMVh7KKVql84ccOY
	undVGJ7vUvPNEow==
X-Received: by 2002:a05:600d:18:b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4888356847amr45594805e9.5.1775049574206;
        Wed, 01 Apr 2026 06:19:34 -0700 (PDT)
X-Received: by 2002:a05:600d:18:b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4888356847amr45594115e9.5.1775049573591;
        Wed, 01 Apr 2026 06:19:33 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887adc52b2sm43924305e9.12.2026.04.01.06.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 06:19:33 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:19:31 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 21/22] xfs: add fsverity traces
Message-ID: <oxglumin3yplbpc647rudg6vqptkcfatf5mayzqdjcowfx7q23@p3flnabfpd4g>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-22-aalbersh@kernel.org>
 <20260401063146.GD24459@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401063146.GD24459@lst.de>

On 2026-04-01 08:31:46, Christoph Hellwig wrote:
> Wouldn't most of these trace points make more sense in the core
> fsverity code before calling into the file system?
> 
> Otherwise they look good to me.
> 

oh the _file_corrupt one seems to be not used anymore with new
fserror interface

The _read/_write ones were pretty handy for debugging issues when
block size < page size when XFS read block, so, fsverity request a single page but
filesystem fetched more blocks, but with the current implementation
it's not relevant anymore

The only one which still make sense is get_descriptor, which
probably could be core fsverity one

I will drop this patch, this doesn't seem to worth it for single
trace point

-- 
- Andrey 

