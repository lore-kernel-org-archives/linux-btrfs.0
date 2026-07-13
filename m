Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1555F3E022E
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 09:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783934386; cv=none; b=d27vXmUojeEoP8L+cx3V/opZhALw4Pbw2mpgAGdjeKOtsxwWuujCGdzebFtTBy6xqQ38OcpmwYFLXZNRzL9aHyJhR+QwBtUha7msSk6hF0qHTw/GUVxoqs3NzCizuYj+ldD7GHi7xWuAwBGZYljr9AleWd+ixZdtf5qowYt41GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783934386; c=relaxed/simple;
	bh=3ZfdHrAjeIKCtzgFro/qo5aWAh/WGZIlIka4TDu/DAE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dJy2F1+U4UJ80jZmKwcO/VIw9AXsSelzBMORad4X08Q70093318DQiL9TUsPpQS9T8mHXbSmTUtgOg02OsrzMQnwH0gHU/a2Cys9AoqMBA46bysSpJdMfPFUCLJSRV2S9P5sRqgGItjmFHj/cHVvYEftAX1HxzQooWg+WQGnzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a8/hl2dZ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a8/hl2dZ"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69c5fda04a8so3674291a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 02:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783934383; x=1784539183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f5qgJIYE3jPPN16EaxeYkTdaYU5IoLrksy2JUMgb8Rk=;
        b=a8/hl2dZfjdhZMcnMa6sUds7vxP+A/fKRCLW1yNGzA7hZAYC/aYL05PW8hAO54ydhL
         LJiMd2LoXHkbtldGn17+RRQSZl39gDJsCNpS6JvUPLigVPbBELpEVcw069YfWh+wds+i
         9rpU/4zJ97L/eGf1saWtXsYnWk5vi2vUAf1m32+yMhVL1rlvkGJujoBou/PIQlBqzcU6
         pZBx3Ix2EBe3vLtbbOqMHwrgh0riOqQlaMZ03NK/FZhQ2aBAPy3Xb1kWrbMfOAetgbTW
         XpNFiN0hwr7AgLEebXznaocdACMFPTFCiC7a/y+NlSFPjzh1Zrnrr7VhVaiO4rhgCl7G
         gHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783934383; x=1784539183;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f5qgJIYE3jPPN16EaxeYkTdaYU5IoLrksy2JUMgb8Rk=;
        b=MLevdXunASMwzw3/yueVPyjzVMYbO1iKtDalnHwPQXTb6sRSU6Bh+2BeC0/RFQiuoU
         T4WMwqhczZiIntVp0G7lgoDG8Tx36UOcAZ4+0AJZpx1cIG112ONVPfbz3yoQfSkbmJlZ
         CQNvHJLQOxNmitJ+0WHEnaYoxgTetk2sK+6BQKW1Xy9jp4poZ0Uxeyp3zKs5BsI9HVSN
         mDb85NPuuVOBHBgAEbjKhlzUeR1l6F8q7/ZRHD/h1pkdJF3TJFD7gtCwe2WzRdBlK+e+
         O63U99r/ALBfTtkod6Xm4WS/5VF3yQg+s/8ImJ9TJJbCipclkQ8YwoQUXORjqwi0Ob6E
         4+MA==
X-Gm-Message-State: AOJu0Yz71owbSsKjVqRsn707mzbHATi+PAr9w19mnMMWv/0YCnMnLoQQ
	ACYVjpps/D7Lcj+E9vm5nfck/nKfx61mssQgRT1v3ZQyOUzufjckYeq/6S/7DsDR7IsTs650UAa
	BwVUNBxk0gw==
X-Gm-Gg: AfdE7cmaXZJpoWqX1lkA4YKUYVtJeAyVtbNYQNA4DDjp64vj7lv8ZrEq9IBKpQRuW3w
	+RLK8yAY9zphnMBuDXYOORZRPv2zmXYdY4qR6+NyOKgL6zglqIXkjbbK3vb9baMuAH1qaESCIbr
	bLxLvnjaZQL7YVGNpj8RVZzUT6/wCle+tB1pmRzF/kanSVgdKucPN0ZDikRC7LRGt9ipvcwz7Bt
	Z2PtQ5IwWAS+BN/mZsWlopXHLjjUlDqlvd5EY33C3n5FAiUh5TIu9BHlPIV+ckNItEOBs9FOzDQ
	oAyO/dLE3SKGrmfBgJSNwy4agSP23llN76rZLBs2A0BzjC+FZ6nZJ6yJYnA/pJsnKb49RdsWJok
	uH0WuS9TP4DVDhT7UrwgMNYKQ10r401jN7h1ArhKzG4QK5X1lDnYBgATzeoVUKUR+P0VoEssRvy
	gPgC2tzQ==
X-Received: by 2002:a17:907:783:b0:c16:c65:56b5 with SMTP id a640c23a62f3a-c161e8e97b6mr384403166b.24.1783934383403;
        Mon, 13 Jul 2026 02:19:43 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38d2fdd777csm3373649a91.1.2026.07.13.02.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 02:19:42 -0700 (PDT)
Message-ID: <32c03d5d-d5b4-4954-9bc7-d7f64e46fda1@suse.com>
Date: Mon, 13 Jul 2026 18:49:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Cc: hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <cover.1779412152.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi David,

I know you hate this way to fix the problem, but considering it's 
already 7.2-rc3, if you do not like this method I think it's time for 
you to submit your alternative.

My existing patches still apply on the latest for-next and is known to 
avoid the extra warning from RAID6 lib.

Thanks,
Qu

在 2026/5/22 18:53, Qu Wenruo 写道:
> [CHANGELOG]
> RFC->v1:
> - Remove unused btrfs_chunk_map::io_(align|width) members
>    To make space for the new member.
> 
> - Fix a duplicated bg->flags assignment in fill_dummy_bgs()
>    Just exposed by the last patch which also touches that code.
> 
> - Use a dedicated member to record the on-disk chunk type
>    So it's less fragile than the RFC patch.
> 
> The single-data-RAID56 (2 disks raid5 or 3 disks raid6) is not a feature
> that should be supported in the first place, thus raid56 is going to
> remove such support.
> 
> Meanwhile rejecting single-data-RAID56 will cause existing btrfs users
> unable to mount their fs, even if there is only a single
> empty chunk with that flag, mostly caused by some degraded mount.
> 
> So to avoid impacting existing users, implement an internal
> single-data-RAID56 to RAID1/RAID1C3 mapping, to co-operate with the
> upstream raid56 lib changes.
> 
> Qu Wenruo (3):
>    btrfs: remove btrfs_chunk_map::io_(align|width) members
>    btrfs: remove duplicated block group type assignment
>    btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
> 
>   fs/btrfs/block-group.c |  3 +--
>   fs/btrfs/volumes.c     | 25 ++++++++++++++++++-------
>   fs/btrfs/volumes.h     | 10 ++++++++--
>   3 files changed, 27 insertions(+), 11 deletions(-)
> 

