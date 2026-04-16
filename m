Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC5C330B15
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776362340; cv=none; b=EWnrj0CWVmFw4NTHms0kFLR3FR0hoeQgDe7EiDsP2jBx8NS1gaQI8XubfdZvABJTBPV87ib7TA6SdRQDYWnJdhUt0zHBRk8G7aYMmto0tVPaS+HnJYl6jiOWNUz9/vO5hbAD2ZCqWd3OEhJzOU3iPJleIUQsnqqV0Y9MhMlzIG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776362340; c=relaxed/simple;
	bh=RV37b4Btl5UuXtB0CAcFbnXgmOVjDSCAWefLe3Rfqvo=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJ0ONbsTybtQuOJl+astQYaaw66QMD2b/r/NIT36b16wZW237/VeJn+Wy4vZz1Tl87CWjXj0SljRsLkkvq2ZjqZq/1417bsYPp8FG3Bfio7axa0xDgoxBmbx3Lbwr40UiWuv6X1dw3hRW9ovBCd8bGNP5EbmJT5WKwD2CKfUOJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=gtr5zYBC; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="gtr5zYBC"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id DAD4F31E3E7;
	Thu, 16 Apr 2026 18:58:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776362334;
	bh=+DnQWU1VXgMHy6Lby9P/K6zTd+syo3777aje9NEVXyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gtr5zYBCjCjW9tPzCqI6T9LGjjQT8SD2wG176KbnlxzQd4PqxHlV6ECGpxnKbeYlK
	 I0Mh/G6v3OLdcSzv/88ciWBJATr53feRpj0+mipVeNJI9cbj8qCsWH+gUH8dvOMaaB
	 SvvgAEFK20Poc6gw+flixAiwEdPOav16/whqmRuA=
Message-ID: <9e83b47c-a916-44f6-8502-74e44a53eadf@harmstone.com>
Date: Thu, 16 Apr 2026 18:58:54 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v4] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io
References: <20260415170001.109723-1-mark@harmstone.com>
 <CAL3q7H5UYpm5rc2xU2H2oKjuZ3NjWcq9QL647QsSgBCd3oEY_g@mail.gmail.com>
 <20260415213941.GS12792@twin.jikos.cz>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260415213941.GS12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/04/2026 10.39 pm, David Sterba wrote:
> On Wed, Apr 15, 2026 at 06:46:46PM +0100, Filipe Manana wrote:
>>> @@ -5140,6 +5141,344 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
>>>          return ret;
>>>   }
>>>
>>> +#define GET_CSUMS_BUF_MAX      SZ_16M
>>> +
>>> +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_bytenr,
>>> +                             u64 len, u8 __user *buf)
>>> +{
>>> +       struct btrfs_root *csum_root;
>>> +       struct btrfs_ordered_sum *sums;
>>> +       LIST_HEAD(list);
>>> +       const u32 csum_size = fs_info->csum_size;
>>> +       int ret;
>>> +
>>> +       csum_root = btrfs_csum_root(fs_info, disk_bytenr);
>>
>> Please, check that the root is not null; if it is null, log an error
>> message and return an error.
>> We found many missing instances that sometimes triggered null pointer
>> dereferences when the file system was corrupted or mounted with the
>> rescue option, among other issues.
> 
> We can start adding the __must_check annotations.

I think that would make sense.

There's also the GCC attribute __attribute__((nonnull)) which could 
potentially be useful. It doesn't look like it's used much in the kernel.
