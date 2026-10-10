Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C2376A02
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791667265; cv=none; b=lDiZKpYFrOeHtbMs2Ilg6W4rQI/N0UfXd51p0bsxaSKKW7dHr2FPNGklx62nJ1L74DwxvWL0g25evj5NnPWdOCUr3gYLTRb1bHLkGGvbR76W7/fKK007L+uyk1Uug4/PB4em7FOzf+6EjZBwH5RdVlkrXSX0wIW3wy60v+XQBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791667265; c=relaxed/simple;
	bh=jCb0unKTRKzQzcEW57+C2ajfUwYilm1YS5zwKu8dO1k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=A6wt03C3KU8Y1zWpDu9jiB3mDMGmOx8jpn7LKQOrpmrwC543OzfkyJIMQerIXJgTm8C6CHFcjEWNDpGfMQBl2rrqectKLJQgSYwobVlEyzxo2tYf1MZVR1/xIQwOTNiiH3DMKHjzHSy/6QkaJ6M1IvgT4ZsXyhX5kWI34NE6vpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KQUuvcHT; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KQUuvcHT"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2e7496f947so129558166b.1
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791667262; x=1792272062; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mGACJtaJMsg2g+JGiOhfkLwLu6DmmhxCfG3vK0iIv8w=;
        b=KQUuvcHTboV7lPOdldNBq3NjEwivqEQGmsl8WOuJxyxqnDXYpeDCf/CXhvTw0vjjvi
         R9KwS86hp9AfYRJWQrU2WNlN38FWi1Dr1nyv365zFia4rsO2gESqkv0Z0GT9g61mmwIV
         diphBOzpW8W7CN2VjQGalppZTSe4m72CntK3xBlnHlGH33bbeJrcKWxZdJDb3kYm52BL
         WfZsmGkOP4t31JB0a/lRsP7bpe9AT2U9J8iGkmG27uxD0a4ZFTbhtrav2UjJ4PW9TCiO
         5vt7fFcAhOAwWW8QGYj1CP59bV3PI7MqfSP3fKlD+pq4ER9nuQO+P4eZEWSZ/BdAJOcj
         IoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791667262; x=1792272062;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mGACJtaJMsg2g+JGiOhfkLwLu6DmmhxCfG3vK0iIv8w=;
        b=hvIfPTWTe/IzSO2dUf7HjwOsAIr2nr3FByatLrAzuoygkDGy3w/0cHAdDadyRqY2rO
         Hrn++kMNZEannRhjHi8P0sm+DxnY6W0HAztIZXlpd9PeM9ih+eedu8GweUyWhHsr6F3c
         tPL/2XY0h36TzKtOi43mh1sKjoLslc8jCPWlJnKAZZLYd+nO6aMgv7grtuBBtqWqCVRM
         gzB/lojJi/4WhMRbrnKvVcDwqrZdcJ+JiSKDuzCajom6J1PR6sZVuw6rydd1owPCpeW5
         kJ/oUcSUegMXlRnjwYtX4BRY7t8Jakqrf961r1AMok0xYiiusyYGGEM2oo11cs5hxNxT
         M8kA==
X-Forwarded-Encrypted: i=1; AKwUvByXy7sFr3VuiQlK4UsoOU/igGhVyphWz/+Pzp6k1bLVrpFvrwbrX8kyXcE0ouNBj1nMuGnjvoF2zSiJyQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLkTcn2t+ER82ZgSunqMsuzzKbBY/fL7Lwl7wQobxwGHOAReb+2
	XtCtkv3RsPjkmxAe67zcA5WQQ8zFN1H3jt/bZdA4g4Y20EyDR6febV/s1RMvsi+SSIU=
X-Gm-Gg: AYBFou0CN8nOYgtVkaoxeRYPX8gRHhgO8unYc7KChXn2pFyJ3bUQm4/8lKM9k8GS4hz
	KcNeI3IlQ0Tkdn1bdyQSCoPx+2u2lBJDNeG2fthRqZDXubWhyzU6vC4vgc/tHvXsuOW5d5vpEe5
	lzniJ16+Vx7azbqv12WXuVJTQCrSs4CeNLmTRKTAzb3C3oBPz6Uljnfz3D0NOown14t0V7XBMZN
	lU4S9z7oU0Qi10uEwgSrOIJzIroOjzWLtpCyKEJUVQcIqUT1rT494wS29wrssUyZbzMOQN94gVn
	CZV1BEHp7MiVXyGFoTA+vsdPRYWDyKLF7ysXBkO0YGPrPqoBGqUpnw5A5X6FeQX+BzoHj2kgGsy
	AMYm5ROzIS4oyi1sJ5R7dB+nPTRKbQn8KA+TA0LOMeq+sjLC8tC+0a/T+8xU2y5bi/M1uTeGtKE
	MHYln0MJ2bvixQ0jXedZYigUZJPGOMjht5SUwopSwIv/M7+oTFC7tVY9a0X+/rNbM=
X-Received: by 2002:a17:907:3d4a:b0:c2d:c17f:205b with SMTP id a640c23a62f3a-c31a9fb71cdmr591839566b.40.1791667262407;
        Sat, 10 Oct 2026 14:21:02 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896b68ef1c9sm2527620b3a.2.2026.10.10.14.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 14:21:00 -0700 (PDT)
Message-ID: <48b12bac-a876-4750-b98d-2162d30a2534@suse.com>
Date: Sun, 11 Oct 2026 07:50:55 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix chattr failing on nodatasum files that have
 the compress flag
From: Qu Wenruo <wqu@suse.com>
To: Hengyu Liang <hengyul@cs.unc.edu>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261010105425.165104-1-hengyul@cs.unc.edu>
 <41987a33-f2dd-4ffe-b35f-d669d36dbcfe@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <41987a33-f2dd-4ffe-b35f-d669d36dbcfe@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/11 07:47, Qu Wenruo 写道:
> 
> 
> 在 2026/10/10 21:24, Hengyu Liang 写道:
>> Commit cf1afec09e9f ("btrfs: validate properties before setting them")
>> made btrfs_set_prop() validate a property before setting it. For the
>> compression property, the validation fails with -EINVAL when the inode
>> has NODATASUM.
>>
>> However, a file created on a filesystem mounted with nodatasum has
>> NODATASUM and still inherits the compress flag from its directory, and
>> btrfs_fileattr_set() sets the compression property whenever the new
>> flags include FS_COMPR_FL. As of now, chattr fails on such a file, even
>> when it only changes another flag.
>>
>> The issue can be reproduced with:
>>
>>      mkfs.btrfs -f /dev/sdb
>>      mount -o nodatasum /dev/sdb /mnt
>>      mkdir /mnt/dir
>>      chattr +c /mnt/dir
>>      touch /mnt/dir/file
>>      chattr +A /mnt/dir/file
>>
>> Before commit cf1afec09e9f ("btrfs: validate properties before setting
>> them"), the last command succeeds.
>>
>> After that commit, it fails with EINVAL.
> 
> Explain the reason why it fails.
> 
>>
>> This patch will make btrfs_fileattr_set() set the compression property
>> only when the inode can be compressed.
>>
>> Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
>> Cc: stable@vger.kernel.org # 7.2+
>> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
>> ---
>>   fs/btrfs/ioctl.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 52aab510aea0..347509043f2e 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -421,7 +421,12 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>>       if (IS_ERR(trans))
>>           return PTR_ERR(trans);
>> -    if (comp) {
>> +    /*
>> +     * An inode with NODATASUM can not be compressed but can still 
>> have the
>> +     * compress flag, inherited from its parent directory. Setting the
>> +     * property fails validation for such an inode, so leave it unset.
>> +     */
> 
> This is very LLM-like, and very LLM's objective-oriented behavior.
> Disclose it first.
> 
> Secondly it just slightly do nothing, which is not the expected behavior.

s/slightly/silently/

> 
> Furthermore, this introduced another layer of exceptions.
> 
> For regular mount options, -o nodatasum,compress, the later compress 
> will override the nodatasum.
> 
> So when setting compress in the first place, the NODATASUM/NODATACOW 
> flag should be cleared.
> 
>> +    if (comp && btrfs_inode_can_compress(inode)) {
>>           ret = btrfs_set_prop(trans, inode, "btrfs.compression",
>>                        comp, strlen(comp), 0);
>>           if (ret)
> 

