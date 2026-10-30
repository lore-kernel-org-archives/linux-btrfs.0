Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348043;
	b=kIID0NZcCXDAgASKLS3uql+6bbKqAUo41lX4ZCPbUpqAuXX6rL76Sr9pK15XyENZKbmO
	 f+sv5iQw3h3XSOj7Y1OsQYEpMz7L3HDcJ5khrjO8brEkmYPRTDVuLRgbibxKG+Fzl7L7N
	 HgTzZjwYBJgD5jSXCCXaFCycTh94lA0UhFrveIv3CyHQyfGG9DPsq1ZOUawCnMI7EDf0y
	 pL95nR/TOFBnNo08joyotEkNdIVmbZ+CBO8pklCsymSIU4rDxY3wDo3LDf/9MPY+KM53b
	 rDj5SRm2N+6M0prGXByrm9xqfHcwmwrrFODtnPeq3zPnLR5gSlA8Cklyeq70LShu3wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=DYxju/VQ5fD0CRDGztF+VRnW9V9jqdl2dwT7docZvOA=;
	b=SNb2536Fe4UkeXA+CFQd20vgz0GieKUxmDJ4zVKNLJMNfQufistF0EOClvm9VSGR1zk4
	 uzl5BU7N5cV2FtohCIc+99+FSOLrvFGJvUe1aiviiIoBuqxuep2WBRX6CjwAzbJWNjYO5
	 yXygH8xa8inRXBcJiSxPkqeqk6fJFDgjGgHP1BbnyeQt7L2OJa3jKKDIUmxYaQ/Apz3Kl
	 wswmEVMb+RYmZ7B5fv7lKcnQfNAyaCUDKvMLxnlTv5rJSmDSfZxhBgRA/484p4rJxesdt
	 C+tX878em/nx76m48W0Rtb1fkn8ggdSWrLN65O1H2fjAsCmdg6yoNUMUTWoPItWCphQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="dMUM/AAE";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A1606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 678A1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dMUM/AAE
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso3294845e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 01:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793348041; x=1793952841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DYxju/VQ5fD0CRDGztF+VRnW9V9jqdl2dwT7docZvOA=;
        b=dMUM/AAEb/zpU4hslhZubp+oeFpRsZWWA+mSn5j2dhZPTvkhf9/zQtnDh1fA47hb3R
         rLsXHtoRRVqXUgVgDe9SNp5WzFjmOiE0sY+vWKKJ2CfIuQwp5jNZZ8chkRm+gEjYfscX
         qcRmqSzUqckwsfbjYncUPRANG0/E+MMOHGzEwNJjto9tBgnwM8RVFwbJsNElY36Iph/P
         Eyt6Jfud8Q/GXqn5R4igdw7sUciuVaq2E9rqo7HoOqr4bdI1d4CHVP9duXmhfIr98/fx
         Q9nOV7xWBVkZFh8r6BMYZimRFM4Q+yyNA0IJj1Hv3CX1hYit9lhJvH/G8cozi9fzq5Hg
         lsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793348041; x=1793952841;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DYxju/VQ5fD0CRDGztF+VRnW9V9jqdl2dwT7docZvOA=;
        b=BbancYYQQP3pvYinV0JEeu9eHTtIprBLGpYFuxxJep9QlVD4rJRXX6OQmTMAOZNEmG
         WhEMSFZklcxtVJQrkVPrtzlsFJHqzKRaOXkWRVpnYUuLgkyVbwfXhEYHVGsTRc3ltzmc
         Sp6I5XVMGqGCfX9oJ6YzrdniQ/tpmgV85S4zn8UE4j4oBgNc3NqlkQpHnvDmN4OuhhW9
         ymOEc+u7LX+sAmN5Tk9EAA9FbSwGFjTbLnorIwA1wpPTFu/AViGs/7lfUA+Zoh/ht5Xa
         ILrYE0AM2nQc9y+suE4uR21Ehk6xjZ1O+e4irNvA9aiEGsLN/MLtYPiH4ljZ+B0dxw3J
         etqA==
X-Forwarded-Encrypted: i=1; AKwUvBxdjRLyIHPlPuKXRTaRqjTFE4wVH/CiYRVke5TzvGe2zBaHJCo8/anrJ+PVpYeeH4aCnooAWjZayRyBTg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLA1yE24yyJELl+WESJWM57xKm2Bpt/AZMnAoEkwP2kq2c8zCPZ
	qUaKmal9nt/rtLj3x5TTiKOngydUdXlV29ibYuQ3/0rO3UkItqmec3R/rOjJA6K0vvc=
X-Gm-Gg: AYBFou3pb8ESX4U6SRnMrc0FtD/z3m5dXTjmCN1pj6E1LFsdayNc0RaI/0I9dTjdn3E
	P7K700lfvGtqni3T/RicDU0k9Lo6z52hSqYFD/aMBqATiClsTwh8YGyr2FIZCube3f6EJ1AWdVG
	8KYsZA7Exl8NkrNfvwXbUwfovHPAuqe/3FG3n2I8Sv+7WiQF/PcmyCjy5FP6G7SUd588kPYMfqN
	PD5vX8xrLwybIoDyD5gelkhbISCjrmdAiYiF5+yUDY6ulE33vpo+60fgt6O2WB/r2hmV7cmuMGY
	1l5BathaCo9HMTuJyDcEH7SapJCFfKGlCrXd6kZ6Rcd5W42/9WOL8Oyi7UDRw2om7CIvKUP0REj
	nCPTROwzpjAxWIuGlg5KLwA6r8UlaGkjFViOd+nluyvFEfaLld/jhSHydk4pGXJDNogZjGo2GDc
	iZxoOWO4hHmgQF5x0MNgEPqeDCPmgsaRYqzpdVAqwS0bRtO7HfVjv76WP3Lc9Yz0e24X5DkszUC
	obFWBKEck0mdrDM9gDEmGrVljUrsbq7Ri9xrTVdHy1PdukbF3PtihsaYt6IpYgBwG0qNzaJCqeQ
	+1YIrYQl2++rOjqniJV0iA==
X-Received: by 2002:a05:600c:8b0a:b0:4a1:742e:3 with SMTP id 5b1f17b1804b1-4ac185bc4a1mr29476345e9.27.1793348041366;
        Fri, 30 Oct 2026 01:14:01 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm7446568a91.15.2026.10.30.01.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 01:14:00 -0700 (PDT)
Message-ID: <d2ee0cc1-674e-4447-88da-d346122a43a4@suse.com>
Date: Fri, 30 Oct 2026 18:43:54 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <179328314071.648427.12527832319954042748@gmail.com>
 <6ad220fa-d6a0-4b4c-a313-a0cc052b8637@suse.com>
 <179334729054.2353588.12398743988940745859@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <179334729054.2353588.12398743988940745859@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/30 18:31, Cheng Yongkang 写道:
> Hi Qu,
> 
> Removing the ASSERT alone is not sufficient.  btrfs_chunk_item_size()
> computes
> 
>    sizeof(struct btrfs_chunk) +
>    sizeof(struct btrfs_stripe) * (num_stripes - 1)
> 
> With num_stripes == 0, the (num_stripes - 1) term underflows in the
> unsigned multiplication and the function returns 16 bytes (48 - 32)
> instead of a valid item size.  The system chunk array loop would then
> advance by the wrong size before btrfs_check_chunk_valid() runs.
> 
> So either btrfs_chunk_item_size() has to handle num_stripes == 0 first
> (for example, return sizeof(struct btrfs_chunk) and let
> btrfs_check_chunk_valid() reject it), or the early check has to stay so
> the size calculation is never reached with zero stripes.  I kept the
> early check as the minimal fix; if you prefer centralizing the rejection
> in the tree-checker, I can change btrfs_chunk_item_size() and drop the
> check.

Yes, drop the check and change btrfs_chunk_item_size() to handle zero 
num_stripes is not hard at all, and it's still smaller than your 
original fix:

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d5fe5cba0c35..891bc2432870 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -711,9 +711,8 @@ static inline enum btrfs_map_op btrfs_op(const 
struct bio *bio)

  static inline unsigned long btrfs_chunk_item_size(int num_stripes)
  {
-       ASSERT(num_stripes);
-       return sizeof(struct btrfs_chunk) +
-               sizeof(struct btrfs_stripe) * (num_stripes - 1);
+       return offsetof(struct btrfs_chunk, stripe) +
+               sizeof(struct btrfs_stripe) * num_stripes;
  }

  /*


> 
> Thanks,
> Cheng Yongkang

