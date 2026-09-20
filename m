Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79B523E334
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913597; cv=none; b=PcGV5PMkAaTmvVCx5yMfEDO8b6VYdM3yzYPkglryPYg5pIvMDHSqpWwNuvHRSOCEF7jXjWglP3z+qpEZAG27RJz4RgRwsOuHxUlgl9YDnghGVNfbv7Dmd9xxKHCEwmV0qVQeOw9SZZOfOBMig5LiO/tLURJ7LcMJscvdvskrPQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913597; c=relaxed/simple;
	bh=N2F3e9JjCBmitjnQ+fMXbBrWxbIet5t3V0qm2z7LA10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JI8saGK+T9pNiNEg9AB95AIuR4hQeKzZbg8giwC+rGKjD1r1yJHGrP3faO2/4oqA0N8PumN03i3MHwGUbS8UTCcVVWSMQ8WcuNIIKlMEuWci7txe0AxbOirAyu1GiZYPqzpeXJFL5P5x2MhvAol/bvvz8ulOiIENUPSkWuA1rK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bn60+jKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bn60+jKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8C51F000FF;
	Sun, 20 Sep 2026 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913596;
	bh=B3DZMU3GLgNHWJlm3C8hi6QrXpo8CW5JNcMT0Zkvkkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Bn60+jKOZ+4chmrFJOjOzgsLNW0vuqCXyi6DkIp+81rC2FSR6yPhDKQqdb9cNGJj3
	 PT4+0jtnj/2956/2vubca32P4VrMrLt8t1wQaaycZbXfO6yPerzXT4BWAl9hYeGo3k
	 98eMXG6t/1fnVya729RA8Mw6YWStDDcG/dS5yXVBSfTMvnfskxrV47BUifgnSFlcTB
	 2H82pn2+0ZESltSXRtpMhdtRHxsNnJUp2e63dwBA77Rt4qtXeuDXJWRQ9w6s+A9dta
	 ZQCxrgZMoXrajGAKQTL+GXpkJ7qOD0RMj2sgjwjl9t+QeySrqtKf7JzxuRaDa+WsYz
	 COmvNEw+JIoIQ==
Message-ID: <98db278c-5302-47ed-bd3e-a47ea6e7269d@kernel.org>
Date: Sun, 20 Sep 2026 22:13:11 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: David Sterba <dsterba@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
 linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
 "Macieira, Thiago" <thiago.macieira@intel.com>
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <20260911172313.GA54722@twin.jikos.cz>
 <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
 <20260914131455.GH54722@suse.cz>
 <847b96c6-9e39-4eef-889c-3985f7eb4e3a@kernel.org>
 <20260917172636.GW54722@suse.cz>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260917172636.GW54722@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/9/26 01:26, David Sterba wrote:
> On Wed, Sep 16, 2026 at 12:11:01AM +0800, Anand Suveer Jain wrote:
>>> I don't see the temp_fsid documented (btrfs-progs) other than in the
>>> changelogs and briefly in the sysfs file. This should be more visible as
>>> a separate feature and with the known use cases.
>>
>> Agreed. Do you think btrfs(5) is a good place to document temp_fsid?
> 
> Yes, please add a section and also explain the other filesystem ids and
> how they're related. We can add references from other places using it
> (sysfs, mount and others).

Just to close the loop: the man page update was sent last week.

 https://lore.kernel.org/linux-btrfs/20260918084612.ZxGVtNO9DAJfevT0EwV5BlMy-4qgIyRKK6TAZ5oNLtU@z/


David (Sterba), once commit c2a74ed0494c is reverted, based on its final
take, I will update the fstests test case on the mailing list accordingly.

