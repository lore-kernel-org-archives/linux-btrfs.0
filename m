Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468152;
	b=U5i/lHPUgomnjmVJOkmXIuhTfxRc1v5w1HnVtkw+bgY30E4H++xJagRZa9ax0d700W6m
	 4crbH91tywtyycAx46zUuWgFsOaTKXT/gcgbT6eGe/jFM97vU14CLuXcX5kpug9QOOhav
	 q9xS0DZ3ICTinZuQnXVdDRcblKfEobuBwZDxObFJlogmBHD9Fotcwaq6Q4F3Igf+ae05l
	 AiY0hOOtOeRNuiv/JWMIPtrTj1NhwNwDRsQdzLnzAUPGfYUjl6qG8fFBxoniAYW84J5H8
	 8IcB9qt107i3AMyaWC5m8To2nrbDusgddTSgNrZs0WGazl0CEkw8Ta4GhVRE+2OlDBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WdFnZn2I3lL/xY21G0ChsFPbW6CopTmTgvwMXuZTohs=;
	b=rr5dM3HDAz4luDj2iMPgrC+sX/NDiUwpnMvP4k5i1wcqOhry+Lg106XhgJbLucW+C5Mg
	 KV8wcxJR9ySDO6fWuyJ0xrxzMLC3dJv0+W9uLg498UULpGvNYglVUUXnhgQaJGfHmRqtm
	 PYeVsXtrlmqeub3vcotZoOw2OGP5iMwB1gz9OBlOBkt7Z+kK4zDxR7+optdp+ibzTV1dL
	 83JFTJ2k3tq+vWu5+8l8cS8GSVaOqW1LBEX1lo2p3X89Vixq5dQ7PON11DbnKLZM9Ub6o
	 8gaJ69z2WsJmqeGS9bWUGuCVXUgff185aHCmJULYyjOIUvW34GHOF/TSU9JJeBREpXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P+0TLVzm;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDD7606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 21:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DDD7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P+0TLVzm
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d28f75d62so636361666b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 13:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795468150; x=1796072950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WdFnZn2I3lL/xY21G0ChsFPbW6CopTmTgvwMXuZTohs=;
        b=P+0TLVzmpsdDaZBP20WefQUl3DfvHENkIBn6FTakn1TMWJhotvk7veZZ8DeZS0nS7K
         NkuiE3RcLTDnYqdWKcdANmlR/f3QwSaq0CB3cOWhL/0lUq2GK+C1sa5PhO4TG07T9wZs
         5QmPID8P3sW3k1cvS0qgW5FtGfXrZl/86JM0oOLaxARfFsxnecRtG43gEo2GsKSckxph
         gSKy9uRbKAgerlKmoRL2mbmRa9dZrY3r8pRIke/n3HlTp19Ae97R7MW8il34le3Hum9A
         T5E/NnlHF2bZKFb8kUUo8AQg47cZ7TWEwcoCz0F+ki8PC5AP4ZXXndNMPC4JZTmg1Liw
         Gt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795468150; x=1796072950;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdFnZn2I3lL/xY21G0ChsFPbW6CopTmTgvwMXuZTohs=;
        b=KPUKwel52K3rsenFIpVw3HPowYmeT0uiLK0Siwc343lOMsLzKx6/JtUMf6Zzpvh3cZ
         DeLxWmSmT2z5sIM1dOdczI2p6G+dximd7Yx1/qOR1UbEeVWBMk6eM2BW4mMNNh7y5PtG
         JoOGbRajXGCWBDCjK+ObmtweiNbYtWbhx7MqhFsNmdRWExuIDcizlPIjU/kuoJR5Z9P1
         G7nmW0Bpm151KCI2zQOGGcZoH9eo8hG/rgi/DTYVx/Uw0wAHIuD57sJkxE2y6jY5LGHm
         FnpltwtWG53loi+7P8v1kyo0yRFj26r7hefOtnBoO0I6PGQNei2cVJMiVpkYq+FFZETB
         3p5Q==
X-Gm-Message-State: APuU4Z8z+DVHq969b+gvOAOUWh1muTCTpN2NyuHZFlkeFiHp5S0Sh0E4
	yTBESCz0onjKpS1Qw+m2Di9X1hzBiAszVeMwgOqLE6BJwzeeWOd9XMUGrILFvthiGG1cj2zm3Hq
	u5EFPtCzOSw==
X-Gm-Gg: AZFdTZdvetneOF0a/wHvgAEccKbgKFvC8cESvKkI8Nf9TbI7Ft+sXB730VNwZdDnC2O
	oA5TIIQigbz32PUHaBUwE17ho76ZDA4XTglYAUEiTSpeS8BzHaMda5p/0m6jfXHyBCmP41jgtnP
	3vsYex9dYS/Nxp3kn+r+V5f39R0IzPncQLokCjpZ6acq4HSXEYAwbDBha02YeJfEhLwgNYFsV2l
	NZiIVD8QQgxGht/+XmWBVmnzpzYPcNrzP/oRunr38jBCsVHPyfWyWGJxjT18DJTH+aASDQBwR+n
	upxCwb0zvbsVQnn80gciovaiujVO51ooSmOH7Up+EPxr0cFmx9pUBITxrnm0rUlJ4VpcYPq/6Re
	s/xuoSvjak1185qqyzV61w7j0UtyEbN9t0t7IPwUHpdbJS0Xm0QTOLTTxp5KYmbeHRfBEw7EAtp
	NbHmTKjWANYHSjkuscrLW+CVADnzb3nZukEusogrt7JfWQnvwSlI5Os3UQGEwCZUyd5WU1RGjhA
	o3rHgKqte5xTLN7z7kvYDPrf3PJHsCb9Ya/CVJpZ+0S6oA1zO/ltSe+wd9xojiKbIjrIAsKjQj2
	4mK8WiU7+dTRE5sZlUk2wg==
X-Received: by 2002:a17:906:694f:b0:c50:ff1c:22be with SMTP id a640c23a62f3a-c513aace676mr756919866b.16.1795468149907;
        Mon, 23 Nov 2026 13:09:09 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b409330ae8sm22508974a91.7.2026.11.23.13.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 13:09:08 -0800 (PST)
Message-ID: <e347b701-1a2b-45cb-8d4f-5810c860ce43@suse.com>
Date: Tue, 24 Nov 2026 07:39:05 +1030
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
Subject: Re: [PATCH v2 1/2] btrfs: reject too high tree level during backref
 walk
To: =?UTF-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1795466145.git.wqu@suse.com>
 <220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
 <6b04a6e2.0b3c54ea.4a96a.e3b7SMTPIN_ADDED_BROKEN@mx.google.com>
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
In-Reply-To: <6b04a6e2.0b3c54ea.4a96a.e3b7SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/24 07:19, Miquel Sabaté Solà 写道:
> Qu Wenruo @ 2026-11-24 07:07 +1030:
> 
>> In handle_indirect_tree_backref(), if we got @cur->level set to 7
>> (the max level valid), @level will be 8, then later path->slots[level]
>> and path->nodes[level] will all go beyond the array boundary.
>>
>> Fix it by rejecting such high level before calling btrfs_search_slot().
>>
>> Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652f
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/backref.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index a0fb90b7a9ed..e9434e033372 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
>>   	}
>>
>>   	level = cur->level + 1;
>> +	if (unlikely(level >= BTRFS_MAX_LEVEL)) {
>> +		btrfs_put_root(root);
>> +		btrfs_err(fs_info, "invalid searcch level %d", level);
> 
> Very minor, mind the typo in "search".

Thanks, I'll get it fixed during merge.

> 
>> +		return -EUCLEAN;
>> +	}
>>
>>   	/* Search the tree to find parent blocks referring to the block */
>>   	path->search_commit_root = true;

