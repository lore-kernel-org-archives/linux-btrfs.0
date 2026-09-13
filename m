Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15371FC0EA
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789261504; cv=none; b=SVkoMSNfh7aDSL6yBoXlK79582xIRYkRA25G8t1O+WM0QwKsvHiJ0zPNopV8lbF7x2iUUNo1nNIqDZ49Gwi34jz0KKPdbD2erBPoFgQQJkcFjRLNYh6PpYFjRN0boL5gzewaT/LfFkw2wtG1PXfCFaMTUcKrm7Ed8w5vnOnGZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789261504; c=relaxed/simple;
	bh=7ByYSnIzv60bBNRNR6gMyDLATSEgD44WMrsThHPuWZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qN+vf7j/A9usREZyJB28LGEBF39dpKRxT57pwwWVEhjIw/pmv0KWPpQgEaMxxQ//WFMtb80K1tay0zGs7BvgqAKfF17EcXnABW8Muu23JXVPu9U+s+kRRbvHqIjF6Q504Cjop8F2Yaj/eEwjrLfBGpQ/YOuBu0W+n1i7ecuidM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxhVNi2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxhVNi2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488481F000FF;
	Sun, 13 Sep 2026 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789261503;
	bh=ykqhFFekdtGFIc8hjeY4Tz222gEpwiRxLzTNlK8U9vI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jxhVNi2dI8B/xIcxuAlv4QeT1DCPvZsIkIc8SEaOAVzdH6GWHXi2wyq8vC12JDFX5
	 XGUpsMW234nWnk9KVFtLa+erIx8zaeskjfm7TrjXERBOpK84pjTnTjWk+nif7GsDmZ
	 JibAWpfx4AsfWPXJQhzcFsHBwsdkK4PTZfLHjVa76ts8QeUUIIZfJnlMYhX5O6egRG
	 xHzyfiIAuEaWSo1yyYJ5O8CXZKpAYrQXWZUF3XO5KjVB1vKsWH4ARNRyUkVQ0QLAL/
	 TmnyIqmja8IKOdpdSOMVeZA1CkeMI0QuZ5K3m5BxfFRpWSCDT87vb9GcEdHF+4jc7H
	 uWbJZdMP6QTMQ==
Message-ID: <895570e1-4d79-416e-b558-2e61d04adff3@kernel.org>
Date: Sun, 13 Sep 2026 09:05:00 +0800
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
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <c9483865-811e-4071-8c11-a7c988f91fab@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 13/9/26 05:58, Dave Hansen wrote:
> On 9/12/26 11:06, Anand Jain wrote:
>>  Dave (Hansen), I wonder if you could verify whether this fixes the issue
>>  on your end. I have run some limited test cases from fstests as of now,
>>  and they passed.
> 
> I actually didn't hit it personally, but I'll pass it along to folks
> that are hitting it.
> 
> BTW, this is hitting folks running 7.2, iirc. Could whoever commits it
> and sends it up to Linus tag it for stable, please?


 The patch includes the Fixes: tag, so once it merges into mainline,
 it should be queued for the stable releases shortly after.


