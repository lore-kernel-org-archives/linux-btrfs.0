Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010057;
	b=lj29GxUSFWOWEZiJ7ZtOVc1BlTyvpohtod7HkABSx1QRaQbgqiJIRRiibdKdXjewGR2b
	 O1JhQG+UszlVDUoLBffkugjDkfVViwU92Tf/1/NN0PDWvT+pCXrSTR3MFZuy3SfpjjooB
	 BniynNZ4DLqxkukzLwmwI/TlWlJlUT+f3d5duAycnMbKcoCly9r3G7Tgm+TyCDYVsSh27
	 i2n0JpEXzqSzkWOVrOFbiUsTi2LyopYKI655hivU5hj0/OF8mgLq83BzRMobfP6YPtSeA
	 wbvhVEsLIP/jlZaZBA02OakO+S1zQ2vofZ88srWp1A++Ip4qGoYGAwlFeRJ4Dv7NUbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010057;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=R2U1Iay9opWXWPMFTlF5nVzaXl3O+CauwEhETUWGyGU=;
	b=yyS76AtwG3A75PkDvWV7xosEiX6glsDJIrkjiVOUOK2y/fLiW2h0Au4+2x26mpuqIvHK
	 NusYPrNrjKAzPRuJx0zmDQ5BA4fNJNFR9ok1sYo9juctmueSDnd5uXx8PHazGvBglRnHO
	 fYBXklKwfY2diYxi7BX/OyzmhK7qwSc9beNbCcdK2uF/goJbuFXGZkZedcA703I7PW2RQ
	 0hBznoj9HQy6vIreqEoM/5t++f0yhBV3VXnV25x8Oapk0UdbTzkUFiHNHwRbTfc39Lt3F
	 b0/0SN1/gJRjxdip2xZFk0MO9Ra9OMCtzhXXlCR6nxXMEmsX8aNkZAWzXd2RhSOLkgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2mBfSCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AF5606A31C;
	Wed, 18 Nov 2026 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2mBfSCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B284B1F000C4;
	Wed, 18 Nov 2026 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795010057;
	bh=R2U1Iay9opWXWPMFTlF5nVzaXl3O+CauwEhETUWGyGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O2mBfSCOT1gwMIkslypZuBq/prLU95Cift6SdPw0WriQg87UKew5urmWC4p1VtZPY
	 EJ5whUWlrVScCXzirzm8CVBMtjQhLPwkbfDUJDzhqrn5/huuJQHNMK6jjUoDZR6ajH
	 RTBXUgSRNGWZaXA7wBDs/aAkulyoxjX8siOtDku4=
Date: Wed, 18 Nov 2026 14:54:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Zheng Zheng <fengaojigui88@gmail.com>
Cc: dsterba@suse.com, mason@kernel.org, tj@kernel.org,
	linux-btrfs@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] WARNING in kernfs_remove_by_name_ns (fs/kernfs/dir.c:1784,
 v7.4-rc3)
Message-ID: <2026111834-capital-sanitizer-4af1@gregkh>
References: <CAO-4RZ1DiPS2+=3WPxRGSEajO=dnsfYi4zDyjcVp3LBy2670AQ@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-4RZ1DiPS2+=3WPxRGSEajO=dnsfYi4zDyjcVp3LBy2670AQ@mail.gmail.com>

On Wed, Nov 18, 2026 at 08:37:03PM +0800, Zheng Zheng wrote:
> Hi David, Chris, Greg, Tejun,
> 
> We found a reproducible WARNING in the kernfs/sysfs removal path on
> v7.4-rc3 with syzkaller. It is triggered while enabling Btrfs quotas and is
> stable on fresh VMs.
> 
> The archive and reproducer are here:
> 
>   https://github.com/Zheng-zheng-codes/kernfs-remove-by-name-ns-warning
>   commit 1d8c9a81d3f812c9ea320afba737bb4be8643ed4

Great, as you have a test and reproducer, please create a fix for it and
submit it so that it can be resolved.

thanks,

greg k-h
