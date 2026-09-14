Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C233F6610
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374510; cv=none; b=UlA4h0UMJcTYPozKkxKw8xqQx18qXda+qMXPL2EXAvUCAm6/ygJTy/4hChPqywx28faYGO+iCZJnxvpQKDVJ2zWdWX6gMppsFuojt9acMgPXYEkwzIS9yxPU8KbeT14PErMDpZ/0xSU8Pz7m7Uha6fhgcchPS0YgiSmAKFHLCYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374510; c=relaxed/simple;
	bh=WEY8FowkMhs0acdP6P+hJ4Z2JGbOnMBpcSdKzupjX4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HdRkJ1V+cAG+a82QlTwn/Y4PuDAG2JEBSgzl2xYXJLipgjUqOv5Sk3sVJbYHcCZYt0kY5gZgcV7OIkioeOcCROomCl8jIsv2pxKsE4CjAYkEEXZ6Uma9JBiCbNuax+0x59NZn8ykTXD/IfmGjkz0s5bil5upXOcL5F1rVQt0+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbThfGQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbThfGQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3341F000FF;
	Mon, 14 Sep 2026 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789374508;
	bh=BwX3ZnIca83RK/MyVs7HXJPjiKyenUJe1svqcLq4MWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cbThfGQaL2YGLkNe6RmVkJHBfnFsRNDvEiW67TIsjwWerN3nIg8iALBHVChohu1fY
	 KtYQlgwj4gRI18P92SR4vpQB3ypQkrvir/JVTlmADRX/J514rx6yFBKIJDnn71Gjzj
	 ufFfWJLkm2ZUnJEsXrznw6kgtsoEdZGzrHzymbhs/mlfAX5OyuWXN3cqeyAilf2KYP
	 5boS0HcfasQKkgX4fjM2UZTwmmSFZxLYeCCSL4UTtyxAc/7POnT/94Y4nidJbT269a
	 i+M/z2Q+cEvGzSJIAEznmtgq2amGci7LiF+wfnqC8YzebQKLRuOesn09XJSQ7ENfXR
	 gKHFyWGNbvb7w==
Message-ID: <c04f73b1-cf55-40ef-bb47-d518603bcd8c@kernel.org>
Date: Mon, 14 Sep 2026 16:28:25 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
To: David Woodhouse <dwmw2@infradead.org>, dsterba@suse.cz,
 linux-btrfs@vger.kernel.org
Cc: thiago.macieira@intel.com, dave.hansen@intel.com
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
 <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



>> . For stable kernels, this flag will keep the new f_fsid derivation
>> disabled by default.


> No. That still gives you a broken fsid on upgrading to the next major kernel, doesn't it?

Upgrading to a _major_ kernel would require an extra step to re-encrypt
with the new FSID _for some configs_.
A one-time operational overhead.

> Maybe a new flag on the file system itself to indicate that its
> stable FSID is computed using the new scheme.

A mkfs-time or runtime switch, something like:
  /sys/fs/btrfs/<UUID>/enable_collision_free_fsid
(just as an example) is an option.
However, persisting an on-disk flag for this feels like using a cannon
to kill a mosquito.

Feedback/suggestions are welcome.
