Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3E9296BC9
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507873; cv=none; b=ea5+9TScS59foAc2CxIJJaQ8UoBdIAyQbw9Ls+EK+OmaD2V1yf7FQPZcMhxi0mSzX+o+stENEmGoYbm0m/DUcw5qtZ2LjS2zpXqUtEyG5I1liOyR4vUCoWemTe+65g5HQ2MLMTCeeMKQUqhmZi80Qb5pHb1XZCU9HebK4nqQ9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507873; c=relaxed/simple;
	bh=+ysvLkOY/6j/R/TWM/XeHYspBYMAFmbYe1y4eHA9qLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyBAxPi0RPP/0RXmKJMuUPMb2UY26YovbvXLEHg+B4Mmiej8chjFYT7JA0QcXpHhXkDy5Ivu9s7fhXO6u0mwXbyY5+6deaNgHUw6s+69WVCJkLxQyAK2tn1o9TpuI5MzEPEVkujzbxS/n0aQJ4PMFqBxhOBDm01weA3BiO/iMbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EY8UBmPA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZjPWx1p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EY8UBmPA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZjPWx1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773507870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
	b=EY8UBmPAdqvTBSxaTTtpC06V4Bgb7/f4THV1WTi1dvzgZauR9CJPXiSJsZlxcx8V7D9ecA
	Q8c/W9uJwM/YXZgIWubhXNzrFDDh+6DPJjow5GMB1nPA0bcWdO5f+Zr8YC/ujdXoitjmKT
	h6tpQ4+IRmzUVfHByVA8AwtZh07MkMA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-7_S4VVfXOOyP2ZbdzWJzPw-1; Sat, 14 Mar 2026 13:04:29 -0400
X-MC-Unique: 7_S4VVfXOOyP2ZbdzWJzPw-1
X-Mimecast-MFC-AGG-ID: 7_S4VVfXOOyP2ZbdzWJzPw_1773507868
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b04db6c138so653935ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 10:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773507868; x=1774112668; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
        b=OZjPWx1pr3ATCwsqXFldQaaMg0jHR3FcYdl4U1d7djGcjDIsz3rjZZnXn+8yFJuyl8
         YEW+6H2fs4kM4wIyIM0KuEgoYJYXHbM2p+b12NHJp4PwnoYJaPOriyNb2BRxR7DK7ZPe
         121McMA2KZ7EECJ3LmlV3BmQU7PzhTOaLTnxLGTWnxqdJjvj6s+HXSYKQPAZpcQ83YQf
         gAqyx15XyqjSEJB/eTLxlvcGDMFzZh3f4zofMG9I1CAMIyVVbpxSJzJMRVANRKzCI9WS
         HMO96eNQAYIo94bvngQFTEMHvQEFU4TS+fmT3sRxNzEKgyLQuZGTLPQrz5P07pdkoXGj
         Vwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773507868; x=1774112668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TY2RZifNMA2+PGDu5d8zIqDKxVt19EdeEHnDXNRBqlI=;
        b=py3PH2gXqK9pXcaT639PScNqabE9kwmyD+CRCbuwU+rklFvWj2eI03lYwGUg1H3RL2
         hTHNccnnapq0qt+M2ioJHYbZCcjpbmIazwx3iGki0rYh4G4mV8S16X3Uhfou3afeEAyI
         4yn4OxoEX+ONPbe99dI/FFg+pN9Bmit3Qd/vb8cqSjCtQQghSu/5X0f0r5fA/rZ0EUTa
         aTPGv3wGMXuxfMciNvsSb7b75v7HSOsNzvG271+ekv8XMx8A5g2hVFjOxP/sIWBiRjnO
         TxVC87JAJ3o1m5L6ENtacG2isC2OF2Bfx7OSpR+M/OkyipV3VmmSnOlzoLHJgrcUG2Q/
         s3VA==
X-Forwarded-Encrypted: i=1; AJvYcCWMYjbepo3gJDGbnabLLw8mtjzTaUV/x+xFmQ5wzohVrFtTI20DFlJVZNT5DDvVNf7pe9WsrfVuPatigg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPq6kIfrNX2PyQhyThFRG+UI261RVM5j1MyO/CCyPqyZY+loWx
	3khDmRMrhdJFC8XSOtQ1RMJ5rdGUvTWH0WHic2t54NAwqAWBNNGAjBjZCxVjTu/uc0y6IpJxMP7
	pm6nrw3QjeJsGkiP4+Z2/qK5HtnwqgL/eCVSOy3KHJtnfpQEF0rpfMWe7sBP/pRMd
X-Gm-Gg: ATEYQzxj8GonenAeD0iLtA4+dqq6nTnl/xqg7Fmio7arR2aAO8zYLBn7bgPN2hYV24J
	L5E1zbIJMG5RscWIdpDFC7Cu+fNhC4j3yF2P6V9cWnc00fz/Y/ObReOOCBLPZWNHXXFwjDy9hRE
	r8/4rQPPa+r04ril+HrS9PD28Ey3srScFjF2++TsEa8TLBAowYxgmRFVVWcaVuoOJQqSz+iVdm7
	CnZvs3Vg3L1ThuOsFpcV6tdCr8KCZtUYv4FFtpDywS7hAeLjZUIRgLUYc31St7qvdrx0G6kIR/v
	Qow7QCt/LgEGDVNxHZ3VJKRpV8hqGEuEA6jnswD98pvbSlzX0JmHc+Yp+DxQ3fiEeL93CWG9SpH
	9MudONb5UJ9758A5yGvCHhoCu9ia76MNWL6R6IsFIFDIbwzGIfocJ2MW4XqKMRw==
X-Received: by 2002:a17:902:ef07:b0:2ad:e02b:4629 with SMTP id d9443c01a7336-2aecac81c73mr90329815ad.50.1773507868281;
        Sat, 14 Mar 2026 10:04:28 -0700 (PDT)
X-Received: by 2002:a17:902:ef07:b0:2ad:e02b:4629 with SMTP id d9443c01a7336-2aecac81c73mr90329605ad.50.1773507867842;
        Sat, 14 Mar 2026 10:04:27 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed753sm73365325ad.45.2026.03.14.10.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 10:04:27 -0700 (PDT)
Date: Sun, 15 Mar 2026 01:04:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] fstests: add _mkfs_scratch_clone() helper
Message-ID: <20260314170422.a62qqwqe6agom443@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1772095513.git.asj@kernel.org>
 <254fdd3e212f6618ea33207ef24db2b316d2d8fc.1772095513.git.asj@kernel.org>
 <20260309191317.vxcjvqfpoqdiycki@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <43710dd2-4282-4475-a29d-983295fab86f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43710dd2-4282-4475-a29d-983295fab86f@gmail.com>

On Wed, Mar 11, 2026 at 10:32:18AM +0800, Anand Jain wrote:
> 
> > What about if ${#devs[@]} > 2 ?
> 
> On purpose- so tests using _scratch_mkfs_sized_clone() don't
> pick a random higher number. If a test needs more than two
> devices, opens an opportunity to critically review this function.
> >> +	fi
> >> +
> >> +	case "$FSTYP" in
> >> +	"btrfs")
> >> +		_scratch_mkfs_sized $size
> >> +		_scratch_mount
> >> +		$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/sv1
> >> +		_scratch_unmount
> >> +		;;
> >> +	"xfs"|"ext4")
> >> +		_scratch_mkfs_sized $size
> >> +		;;
> >> +	*)
> >> +		_notrun "fstests clone op unsupported for FS $FSTYP"
> >> +		;;
> >> +	esac
> >> +
> >> +	# clone SCRATCH_DEV devs[0] to devs[1].
> >> +	dd if=$SCRATCH_DEV of=${devs[1]} bs=$size status=none count=1 || \
> >> +							_fail "Clone failed"
> > 
> > I'm wondering if we absolutely need to use SCRATCH_DEV_POOL for this test. Could we clone SCRATCH_DEV
> > to an image file instead? Or would it be feasible to simply run the test using two image files?
> 
> Using a config file and testing directly on block devices lets
> us cover a wider range of devices.
> 
> When I wrote this test case, I was also considering whether a
> serial-number–based mount without extra mount option, would be
> better in the kernel.
> 
> The downside is that xfs/ext4 testers now need to use
> SCRATCH_DEV_POOL. Let me know what you prefer.

I'm concerned that testers from other filesystems might not be familiar
with SCRATCH_DEV_POOL, as it's typically not a requirement for their
testing. I'm not sure if they would be willing to configure and switch
to SCRATCH_DEV_POOL, just for these few test cases. If we can avoid making
the pool to be a hard requirement, it might be more user-friendly for other
fs list. Welcome feedback and review points from other filesystem mailing
lists :)

Thanks,
Zorro

> 
> 
> 
> 

