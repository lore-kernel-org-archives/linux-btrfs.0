Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471F31E842;
	Fri, 19 Jun 2026 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781856161; cv=none; b=iCDUf0Ql+tnhgbiPftAelQDZuPiyLmJD6HCISNnNTzyxq6qlRH5gwxJi4P12/szBb87TeWh2g9/3TpP7FGG4qxAkPb9Kc5kxB51fLY+oLAuBN4XQIS778/2zujYZ3r2U/K2Ll0x9tT+ze0yZcnK21FtwOWI8XyXix2jNmGs5w54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781856161; c=relaxed/simple;
	bh=4Bxx9TXDu2YuL920I3/NwgMApmrXEQtu2SW1f9t152c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=E0opOh7/fuCY+Ki9zo7FrKm/m1iJ5LGjNE/gDnAvuf2241ax7s5QjDFWpX5lFB4rpv85UfVgTkAJzZnq5OsiyUdGHDAqB+chXYwEohJzCyYHRutI9uTEhTI3Cn1L1UqKGXbWje1Yd1EksUE0Qp6dm36AqYBYo0ULa+aZwwPKDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpfadkuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpfadkuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B41F000E9;
	Fri, 19 Jun 2026 08:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781856160;
	bh=YeZbV0GE34LxmENk8KvRi6+Yl43RXQtCy3FFhfS4IOI=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=RpfadkuSBaz71aEJdmni1/zkOO4C18CavJ4KHjh8+HWC/RWRAduIbccHYXM6vnXk9
	 GRDtRxzj3+IoAIROCZHTxNQ0ZZPrr9WBGiM9gTfMZFtMBSOzPi6667tImcgLKn1vtc
	 Oq0kDlLUIotYGe8DvMYgAXYzC2QnW7i6BFHqHu/LzkE9JCDF47d0fU8HxIHvHayo8V
	 PJGhX4zzPI1epDnvQKC+34GP1rFxMAvrxyItdIEwA/jCle+/Wzc2FR2B8f4GVp7Qmf
	 rwcj8ZBr4xlG0Ywcn5aSabUqflNPT91ZzFBpYwQB4gxPmGuvI5ARDmVOfg71XsGO6s
	 6Jm1YM/2LeDSQ==
Message-ID: <a2eb29de-1ea4-49a3-b298-2a4583a83969@kernel.org>
Date: Fri, 19 Jun 2026 16:02:37 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: add a test case for btrfs get_subvol_info
 ioctl
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260618212553.9564-1-wqu@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260618212553.9564-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


> v2:
> - Fix an incorrect bracket for timestamp output
>   It's only a style problem, all the call sites are passing a
>   subvol_info structure directly, so it doesn't cause any problem.
> 
> - Fix the incorrect uuid output
> 
> - Fix the return value when not enough args are provided
> 
> - Add a missing newline for the message of open() failure



LGTM.

Reviewed-by: Anand Jain <asj@kernel.org>


