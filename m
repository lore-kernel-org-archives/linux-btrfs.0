Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988035AC03
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 09:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107523; cv=none; b=gbZasNZGiOOkLnrXn83QdCrJNhs1u9nSrjJhuVaL9MAkLm12jm7neP2JQzLSxPNyG7D5NvWWth5c/1Y3jUhigOMQhDZaQpkPshUUK5nirI2FjcfR3tZWgoPYtblmEWYemHkQu9GX7Ox8e0pL1R/JvZGY2s+S7JSfi2UHzuwKjSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107523; c=relaxed/simple;
	bh=30rtPG0gljBbah390uIIKKNMBCJmaHxL8lSpdZYjhxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9Ur7rCzjNT5ELi+zPDcR6gA2wE8uDonW0hU06jhDYVsSkFCUwV50SqPQ3Utm1/e2d02cVyokix15LomOIRsEvV9Ps+mG5e0axtwoWKA0EA+nA5FTNzKnhufw8xIcTr9AKJEBtqqcjkRqMo6N9KMN8VXawXsEjRDlLpj79AfBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jc8XbSVO; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jc8XbSVO"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-384c94c9414so1603652a91.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 02:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784107521; x=1784712321; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+nrg6OupqmzQyIqWWaHHaOAHm1aBBFTxuH0q49mGCI=;
        b=jc8XbSVOmdvsrky4AjAaeck5QvSMPiXb+wS3Tmy0AUz3azKr7htqHgoTGn32yDWF1E
         vLiRTG/aUJaEnn+fAMuSDLWjJf0s9scucXGiVSC3pj2yn21wjpTxJULdIOFl60LQqD0m
         Kw1wwmiLpdFTwjSyegTpfWvsOY7C5GoSQUyt7WyuinKBuMKxO8aliB1nJqwrisr+K5ax
         d8W98cjhEBYqsrddED4UvSuDkuDFUAhFca2YHOxztoKoXsZX4TeRUUJKeIYhWYWlTKTI
         +R5NZzZhQggTRyGcgmOLEtslASu8AsVGhzxtGVuRdNo+34E/EKdpqRafFZyazGM2v5tT
         UJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784107521; x=1784712321;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d+nrg6OupqmzQyIqWWaHHaOAHm1aBBFTxuH0q49mGCI=;
        b=o//U0w5Pjqp9aSyfaANZISYNtgbdnQTZkgyYuH/XEFW013e1QJe04r6m7lDwz3PUzk
         wNPcUYQCf0FaTGcmO/+tNHPy7mXyN2vfRnqc9a4VQ7cITVYr5ryjKwdHOG1wuIDTHzCV
         wUFBImFpkclBIfYcTunPnjdQV20eyNhEsl4Sfc3vYezCeq8FpScp5R3mASEhSQgiYnnG
         FdIrQsD7vXFncacSP535kuIv+nxovtZ67oaYmlJ5cqZnQFh8B1kpQsXSmcFD5hYIoaXY
         924qHUjZ70k688Ab/R56EtQ9BOGuBoMZohBALJWCWnY6E1LNzvrNgCZrkaorLJrmgnH1
         mP8g==
X-Forwarded-Encrypted: i=1; AHgh+RoWYFkxGkyidtq9SdwoWVzvt4M3CDKiJsWexP4SlF81QPJv1Y/9b7e53bMl1TEFoqfAXG+d7+Y0ZsbEWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb/xQuHEwXWMt0MYvtObRCdQ+0aqvprmRh3r0Vujv6sHz4y4U1
	T4ERmx8rjyMCs+3IREUjcpFkqSLEyNX4l8/0/2dCEzDE/sLTnEjYvsvXb/XLQBl0
X-Gm-Gg: AfdE7clVvt+YdRJ5+MYZjELFPSypaFSiWmN+WDHgugmBNOpxwOwnrDzjzPcTNMX8599
	R4dq8aO4bc07PPyJUh9aR173lLJmVLNQ7i34Nyg065jCT12xc9P3a7rpjm8iOprc/1SerjUO0NT
	0TrjVeLAUNeXoP8BbUtyjUHutNaAVvhIwSoDb2b9qcsV3nlN0Pbo86fARmAFeZPdzkUxBzUoySv
	YojXKG/XzAK59AvVxH7dr6MGDlzN1BWiBVeNMn1XNwYN8q9+ifGnilcBQ1H6T6SIXv/PIBOtGsK
	uwTHUBgs0Omad16aW/Pnos+91ubpd09Dt1PvyGt/l0H8kvsEA0hQsPFbbauK8abAHnOj2Ogxf4n
	909hvTtAOJnkukdtgX7AfDBpB3sTN4ah7yStSpyrCceFsBlZM0XQR6wejivcv4Hc5Be/FQ87HQ9
	68Tm7OWY0lBxIwNwHY8W+Bdh/3bAZ+w51HSwEDDLkgZ5GoNOKnXn2xRhpdU6mLcvjkxERAdmlAR
	Q==
X-Received: by 2002:a17:90a:f943:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-38e2e870232mr585348a91.14.1784107521440;
        Wed, 15 Jul 2026 02:25:21 -0700 (PDT)
Received: from [0.0.0.0] (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e17443f4fsm2816304a91.11.2026.07.15.02.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 02:25:21 -0700 (PDT)
Message-ID: <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
Date: Wed, 15 Jul 2026 17:25:18 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
 <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
Content-Language: en-US
From: Zhang Boyang <zhangboyang.id@gmail.com>
In-Reply-To: <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/7/15 16:36, Qu Wenruo wrote:

> You're introducing more and more code just to handle some very specific 
> corner cases.
> 
> E.g. for your particular case, you will need a very specific write 
> situation. You're introducing a feature that is very hard to hit under 
> most situations, but we will always bear the burden.
> 

Technically the runtime burden is small because generation mismatch is 
rare. If no generation mismatch is detected, no device will be marked 
dirty and no runtime burden is involved. On the other side, if 
generation mismatch is detected, you always want to run a scrub to 
resync your array.

> I am not even sure if you'll still contribute in the next 5 years, thus 
> I won't bet my 5 cents on that this feature will be properly maintained.
> 
For maintenance burden, yes, there is maintenance burden. So I'm here to 
discuss which way to fix this bug is proper.

> To me, if you really bother this particular situation for whatever 
> reason, just introduce a special harden mount option, that any barrier/ 
> super block write failure will mark the fs error.
> 
> That will be a much safer bet than any of your proposal.

This can be a solution, at the cost of one failing drive will render 
entire raid array unavailable.

Personally I like the idea of turning metadata trees into merkle trees 
(so I wrote it first). But since you are the maintainer, I will let you 
decide which way is appropriate‌.


Zhang Boyang
