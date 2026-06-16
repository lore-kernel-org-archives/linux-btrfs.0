Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F254014AD
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781654126; cv=none; b=DMb50WPtoc5f1SY5egywMbc/aoCzQfak9Yj1kABiOpYTuIquKxrPoC5rinphvpb4CBCL/N1zMuuCZQD6lJDaOCnp5JEtLBrZgnXXn5wvRFy4aue4DmCGYiBxDgNy+uQ8gdD3KtM/gjbWgvugwfUk0yACb1Wz0skfxVGRYH04WYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781654126; c=relaxed/simple;
	bh=zqPYMUQTRYgYQzlJMhaqbNVrjT/IrlakPp1fY0S33dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kxo3X7M+crXjbml8fjCx3XXV6LgyelA/ducpAjIB2n4/OKcYs7uIkeWPm82Sy9IJMIuoeCF5111S5Kg23jvTGdOu/oX4paqoBU4cUPUJjHEEqfwJ84GlrOr84Z+2UVKR6UXTTqAVe0jmtuzpjlBCgZ3Y2YmnESA/9chKs6kWHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ET2mRT48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ET2mRT48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49A71F000E9;
	Tue, 16 Jun 2026 23:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781654125;
	bh=j3Gvx1SfFTM8y/lBaU1pHjtKfr9WCAr2JkidPRBoUc8=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ET2mRT485pYTfYwnJnINDvH9oOq0snqaezC1zq0g6uGWWRn+RHrZtD1iv0UwnTsUE
	 F3ZTUFPQ7PwDjYZRH/b6wLpfLapJpMA2XZVglt0rsZoRlgiaM+ZsN0OtinT4KZ5bGr
	 s4ynOmeI9vM9H3W9Fyq3YvGKv4WyIez7FVWkl4IulMYb9XnKq/ZgAyTp+dc/+EG55d
	 NZokk7H/LmpPuwWM152nJLDBgEBXqpW/i66saXQFQMbWi+kjDXKvDZ1TtuP2zJfzk2
	 NVjZ7cPEtWfvpUeuSaZdbuyEsdJaohksH3xaJ9BXQRrXATMUXDH2xiVi2iwwV9y0Jk
	 CzkLNNhutEsiQ==
Message-ID: <e8ad1491-5b18-49c8-9cdf-39833afd91a9@kernel.org>
Date: Wed, 17 Jun 2026 08:55:21 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
References: <20260616065129.318703-1-johannes.thumshirn@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260616065129.318703-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/26 3:51 PM, Johannes Thumshirn wrote:
> On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
> the over-committed metadata plus the zone_unusable bytes exceeds the
> usable size in a metadata block-group to avoid heavy over-commit of
> metadata and early ENOSPC in one transaction.
> 
> If this happens while doing reclaim, the transaction is getting
> aborted.
> 
> Treat -EAGAIN as a soft, retryable condition in case of block-group
> reclaim.
> 
> Reported-by: Damien Le Moal <dlemoal@kernel.org>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
