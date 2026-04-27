Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA6303A32
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284985; cv=none; b=C3uNiuJ2Tgroizvj5e3slHYDbSMSyQaKCMx06wEdpXy1O0aNOT3Ej0Hblsu98dGCQ5WbVvoSdMcahuY+Zk/QtZdRFQeYFkNjFG6ihLkMCGkS3wbHO+DwIJf9LanD8PXOZ0Y2Vb5liX+XW8LX+7HfvSXtEqzXeLgNSlpCptdCsZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284985; c=relaxed/simple;
	bh=MVzRp4OGUxMMdWcsFlN4qWeIX4Qazp+n6VnfWzrAamk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QN6bP5zw9wFosFhyZkc/YJJYkpmEgzr4wYifGPEkq4xwHmpg7TN9FuWrj6iCSfI9dzGNV7evRqi3FMryt/XdaYQzBPrjIRci68vW1iLwhrpBUOgdL8SZqkYBnu8B4snGQDRnNZbgD8cdjmdmN4iOu+1xvSYeshbE39Buehv5PM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipf/P+mJ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipf/P+mJ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-358ed696623so4420024a91.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777284984; x=1777889784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=ipf/P+mJXMFbjUJOYSs6xDia98wvHxaAjL40BuOuATATeYYLy8jD4ZwaXBY/oAKIdh
         zjaj0NamCDeLhyrr5M+LMwmeI1uVFnx7/08SowVtFlhKSBTVTWKKTUEZ8KNcgBmPROTy
         ldoe5bO5NygjFrhfyuf2aOV3hoTanFTK7pfmuMrUReOGmcZqGSEvIWFtMZ7VqCcRlYfB
         buyXAsmV20TiqYI8RdE1yjWNDGSbd43ejYakfLlhhqPXZC++Uo8JY1+ZvmYBGf+W9W40
         2w0mh6cOUOWUVi9x/Ds2eWSE+fyZdBjt2mFX+6raVVEnv6+VfUyLQ163UOJ3LRyDC0qz
         dleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777284984; x=1777889784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=EzmCRhUgpIXRlkMRxKH559lMtQyj7ihKm1xR3H8xGwYMa56cnt1ng97sxfFOXV3hbI
         KIcrfC20AObH+lSaxK3Xby0fZYw/R12R0YFGKCbUOdizTSeygEs3dC5jEbVYOn9QrUfs
         6T+r7yGMMF8/BGhyfrXXL5hycrNORUY89oh0Ff0N/WDvyesCegsaBizogUl18ehRrjZk
         JoH+sVfWYqvctjqpQBCCuG463MjhCnRzxgQTgirc/aZhiuWI9rnq3YDZ9ADGdZ+UQbxt
         jSpwdibpxMxPIzRyYeCMhjxjnErqaRj+jxXrAWULjZL+eOF7Mw/yaqb4k/xSMevA0+dG
         J6pA==
X-Forwarded-Encrypted: i=1; AFNElJ91Wxx7bXGsEQQzN6TTuYavVx681rj/vA16O65rL1IdYxQrJ5Er8XJEBvznsheh95hqsveSScEXVc8guQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YynXClyAzOu8lOCNACJGvfNk/hQT1R3FfGFC7xiswypG30fA6s6
	jlJDaissw3KqZUqz1q4exPAUozYFuNrCJN6nKNIjj8KlJBEfZ4eii4gv
X-Gm-Gg: AeBDietnE8rze28McaT4mlz4pRCAOiYPXf3CsBFQ1NyuMF41ON4X3YRuHPx93WjiNwz
	324/hY0Lnf1wPKWgSDpZ2+27ePAVv5spcTBWUyUxxyL723QqUqFpkdGVKnx2JOasUVR0q8Ga1Ky
	+6tsV6ottYJLvfm//kjbqbmZ6KsdSjImf2++Db1HgEZHc6FsrcPR6fKMIaOM9LgUZWeuBP1/8ND
	y3DeF9o4BMhXSFz/fNn+Xvvh2GtlrDRXJta0SWVTh4JpNNvwwM0RjuoICYlkw35rQGqmyQjew+Q
	JEbb7pePupcfZ75CJWbua5hg8YMd29sCcp2agJ7P/SanAioBxXB7jx9lgPc+a3GmP4judLi4gSR
	Aj1Snib9kIeIpgR3MAcnXF/eZXAXIMmqXJZomhiWFpSZlZhr1L/J6P+6XEUJrqllWZuU8FKZapF
	bMhUYm8EOgJnFlyFwosy5c550PEvmjdcwXQXFM1g==
X-Received: by 2002:a17:90b:5544:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-361403e1016mr40055142a91.7.1777284983849;
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613f56ecbesm11872541a91.0.2026.04.27.03.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Message-ID: <a7df722a-834a-44f0-87ad-d0da5a813e6b@gmail.com>
Date: Mon, 27 Apr 2026 18:16:19 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
 <aeHikJwRmFdDg5FW@infradead.org>
 <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
 <aempTb5TyKG0vPL0@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aempTb5TyKG0vPL0@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 23/4/26 13:08, Christoph Hellwig wrote:
> On Wed, Apr 22, 2026 at 07:39:57PM +0800, Anand Jain wrote:
>>> No, T10 does not actually mandate unique identifiers, NVMe does, but the
>>> implementations are often totally broken.
>>
>> Right. Newer SPC-3 (and above) compliant devices must support
>> the Inquiry CDB EVPD flag and provide page 0x83 for identification,
>> which is what we typically use for multipathing.
> 
> But there is no requirement for it to contain something useful.
> 
>> These are globally unique. And, we can overlook legacy
>> drives, as they've probably been past their EOSL for a while now.
> 
> We have absolutely no useful identifiers for most USB devices.
> NVMe devices have broken identifiers all the time as well.
> 
> So no, you can't.
 Agreed. I have dropped the plan to rely on hardware identifiers;
 the lack of consistency in USB/NVMe firmware makes them a
 non-starter for a stable identifier.

 The updated patch set, excluding the ext4 changes, has been
 submitted to the mailing list. Fstests test case updated as well.

Thanks, Anand
