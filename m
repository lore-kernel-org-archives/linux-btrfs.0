Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8A63ECBD9
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776271945; cv=none; b=Rko+smzcH4K0K2xInpbNhAy0DgRlVJWxuPJbrLUzLg4oWCcgJvn1X4IbQkmvSOmpHcgJzBH6/SMrqK2xvd+ajDJVWRKHukDsezgNoaiSVX2XXAuzE4t85d6XxwUtfn4K3blMzy9skg7SUERj8NJwoNGJBYjLb2GuybaQy6ya98U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776271945; c=relaxed/simple;
	bh=8/6CvrXez9PV0sHBaylQtMeaHQLwV/pUJLpsqP/NaYE=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ddseb2KdDSte794PgHV3a6R+TMMX9mJBWKfBlwDeVDxvM06ZXr+kTNygAuIpAZ44saTSpzUCvKauSJtOt4XvEomGVg6UGg7gewETDE5UNBBjC3rIxZFXdl6CsZ5sEwS/5jab1nADsk5nTA8Y5KtC1VRpD8eMbQX0a8oW16fZLNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=eHDGf6Gg; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="eHDGf6Gg"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 16E7331DB05;
	Wed, 15 Apr 2026 17:52:19 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776271939;
	bh=K+N4paS64pDb+LEuEAOEoRjE8PrVlbjxmRdb7RjBHGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eHDGf6GgS3plIyeAp9FFj6A4NCyqNDlOXSFIR34mroo7XCV74w7rhOzc4LpChpnxF
	 lEkvcbQHKkmEx85vpbz4QJ07cZ566uRQlHhZxGma6cnIh85xHJc2Al06yM78OR2YKR
	 uqy/V21p8abBBHf7pDbZOshYrzfQyr/j1bwn1fSw=
Message-ID: <d02c32df-7b98-409f-9931-7240da9ef817@harmstone.com>
Date: Wed, 15 Apr 2026 17:52:18 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v3] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io,
 lakshmipathi.g@gmail.com
References: <20260413171440.116041-1-mark@harmstone.com>
 <20260414020739.GK12792@twin.jikos.cz>
 <e1861274-8d36-4a79-8092-aa7e2ba39240@harmstone.com>
 <20260415164345.GR12792@twin.jikos.cz>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260415164345.GR12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/04/2026 5.43 pm, David Sterba wrote:
> On Wed, Apr 15, 2026 at 02:56:49PM +0100, Mark Harmstone wrote:
>>>> When using the --reflink option added in btrfs-progs v6.16.1, we can forgo
>>>> reading the data entirely, resulting a ~2200% speed-up on the same test
>>>> (128s to 6s).
>>>
>>> Repeated mkfs is a specific use case, normaly it happens just once but I
>>> understand that for preparing various images the time savings are
>>> significiant.
>>>
>>> Once this ioctl is available I think the deduplication tools will make
>>> use of it as an initial filter before actually doing the real
>>> deduplication of extents.
>>
>> IIRC the mathematics of the birthday paradox is that for an n-bit hash,
>> you need 2^(n/2) sectors to have a 50% chance of a collision.
>>
>> For the 32-bit hashes, that means a 50% chance of a collision every 256
>> MB. For the 256-bit hashes, that's 2^140 bytes... whatever that works
>> out as. So the dedupe logic would no doubt be that for larger hash sizes
>> GET_CSUMS itself will be sufficient.
> 
> It's used as a hint in the initial filter (e.g. in
> https://github.com/lakshmipathi/dduper), the final deduplication does
> full byte compariison (memcmp() inside vfs_dedupe_file_range_compare()).

I've only had a brief look at the project, but what Lakshmipathi calls 
the "insane mode" ought to be safe for SHA256.
