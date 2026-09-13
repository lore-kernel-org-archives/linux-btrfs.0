Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7E374170
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789267414; cv=none; b=me+00xPNyN8+1rBATM8UD/AdMRAwZLGnvtt02mL4OOUIOT5wG1nH6MraLOOFMTi74MYmJaUPdb/XezWtRvJFPHDGDdWAhwhfoXtdIv0mN/LbBv77CznXlI2hyTBpfBuZ28El3MMJ5YGzzuX86pThSRyjW6OBHl6vZ2QHX1v8CXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789267414; c=relaxed/simple;
	bh=qpbVgKPoldk5/YfC4/8lzyVhGfEBzIIKdzKLPUWGdJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYbLoF3k1w6UOkk8LvHn2x9PL6Df7R0VWUMyOQBJXMPeKx747DWa5q5TCM3THYYK/wn+JX93T57aK4CBqyNhmLgUh6bp33Nn6mlCoGuh3MIic6wQwyiNPvZm6LNfnguUI1wxImr9MA5rDfKWA2z6vGKuOnggkqjl8xnGRr3Qd9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNaZ7eg9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNaZ7eg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800ED1F000FF;
	Sun, 13 Sep 2026 02:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789267412;
	bh=LcF5Mh60NV+CAsapshv2K6bi3sb1nvvzbgEbwIUpZXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lNaZ7eg9eF6a8ZExz7fEbC41UorsyDAtBmCRG+H1x+k9282PoFhmOYOnlOWbRsYtM
	 b0SHWH98JnjfQnVW93vKZ3ALthZfcrT/LWhbRQ9a6ViY2vY3U+kcDksmp9+Nd7uswm
	 tRp7rFQxugfGjTnPl/ArmD9f6YyazILDcaiqL1STcTEe5bpHf+Fy7LpYjxaNPmOo5G
	 QHQVafDWAE0u5wegHCzUUa6xWuhwO6m0yf8KmGsK6AEiMJknmcu5/0d88SBhGWXNij
	 U9rIXw1kj9DLNbA3KQmjhUQOD9dw2a6glnxDPNxsupc0ZfpeCNHUlSHUEmUqWjUhF1
	 SzuRsVtGy+wIg==
Message-ID: <70928d36-4c76-4bf1-9755-acaa11d569e0@kernel.org>
Date: Sun, 13 Sep 2026 10:43:29 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
To: Dave Hansen <dave.hansen@intel.com>, linux-btrfs@vger.kernel.org
Cc: dwmw2@infradead.org, thiago.macieira@intel.com, dsterba@suse.cz
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <c9483865-811e-4071-8c11-a7c988f91fab@intel.com>
 <895570e1-4d79-416e-b558-2e61d04adff3@kernel.org>
 <be9be757-0714-46a8-abe8-e7046fba0d7c@intel.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <be9be757-0714-46a8-abe8-e7046fba0d7c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 13/9/26 09:13, Dave Hansen wrote:
> On 9/12/26 18:05, Anand Suveer Jain wrote:
> ...
>>> BTW, this is hitting folks running 7.2, iirc. Could whoever commits it
>>> and sends it up to Linus tag it for stable, please?
>>
>>  The patch includes the Fixes: tag, so once it merges into mainline,
>>  it should be queued for the stable releases shortly after.
> 
> Did something change there? Or is there something special about fs/ or
> btrfs here? I know Sasha's scripts tend to go out and magically find
> things. But I thought the best (and only documented) process was still
> to add explicit stable tags.
> 
> Documentation/process/stable-kernel-rules.rst doesn't say anywhere that
> I can see that a Fixes tag along is sufficient.
> 
> If you're right, then awesome! I can forget about Cc:stable@ and just
> focus on Fixes: tags alone.

Yeah, you're right. Adding Cc: stable@ is still the right way to do it.

f_fsid has been pretty tricky to handle lately, so I just wanted to let
the patch sit on the btrfs list for a couple of days first to get some
review.

I'll make sure it gets into stable.
