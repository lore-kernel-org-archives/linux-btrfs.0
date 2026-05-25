Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ADB3E3C74
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779698163; cv=none; b=BedR+gKF2ojO+GsXv0NA7K1S9G5wt8rXHFfSgvTkfnynl8zms8undL5tTbFN+lnRbJlfSaG9hNnpSNn8B1OgAK4vMKzTlCjmVdn8NZdZa2I6OO0qCnIjpAPjd/zpksUcKO2tGAgUV0W3KXj/PRCGDKDf9xAVmFU31iYhDFBN+Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779698163; c=relaxed/simple;
	bh=SzJYw18c8BFlSFH74k1KqMsOQhyX6MjkoMGycJDbafw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIEfwIyV6Crj77gO1z1SgkOZY5MWDaUL/tbghyYYQKgMvAHImv3MBGaGRsDUZLj4KQui1bVwQ+q/wnBWC6X9sA5IihxU29FjVv002EHVZqMqtohU9l7g0WsMv4Ls0/LNj/W9eJ1y2KkzNBvH2VpQdDrYMTa9NVGb1VL0gs6j3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fc4hHQBg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fc4hHQBg"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2bc763e2ba8so46934305ad.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779698161; x=1780302961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BntzIZqQfdxwPhWe8imRD5hr3gowJvdxsKaf3qs8y5Q=;
        b=Fc4hHQBg3vQt7GCA/rr5d/bwuyuv2nOr10SamRzripUmTPg2/abdoFZtOQxeKPoV2K
         ZlUytxNVjrhTBR+Bu7Q3oaAJLqDXdpgcKayc/6mKSCbFIIr19j3bsusZPN5a51xOZfix
         1Ci+qxQAgf7526AW7Kp8HHguTDYW2zMlgr5wBZ6P+h/XoG2ddX11LSLBHyVQtv5uvTxt
         O4pDWDMTiiTVdR2KzVu61mz08we1yuS0uuuYG7uZTqWKSRHcXtVirXKFvYM6uh0zx/VT
         bswxUsMYSoI0iscKBnbmPhtVF+O9Kwea1f4Dqgcsfu/83+yBA8wUD67ZNoircNcd7mu2
         H6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698161; x=1780302961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BntzIZqQfdxwPhWe8imRD5hr3gowJvdxsKaf3qs8y5Q=;
        b=YLr4QK+B304YzkZVkzkyC5GDPq3+aDRFrR8OVJlZXDQjjUsuSXIyvKBOPHlEMBq15w
         xxI+6N4SWXZdOlxMCNAUVg8qgneC/t0wF34P6Bqd56w8qiZhzuplxkvCGsf/sOubAOuU
         h3mru91GkrKE4H04oFPwhfEOsMqY7VlgWlwgPoxKNe8YSAQd4LR4US3iIu71IfEkSslf
         1/GpffyJz1uffWH7gOg1CCgvBBj4ji8l9FGHuc/dzD9yd8cpw8pq0pDvEZhtCKX2b5k1
         MauJBYIyfp4qflkjdsGw00hke1uG0KVj4MPRKIgzQ7riv8Fdm5jnGq3qu1P1sALX0Abv
         tFZg==
X-Forwarded-Encrypted: i=1; AFNElJ8UssbD7DMQDYGvpON5vZ69vynmgxMd03Ik2lNQtX4iYS+QgXx2ckust3fyi8BV7iS27HM3B1ZKVld0OQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxF+DRHCzzrtJf533URFW1MGuytYXh+sxTkd8YIkm/EHfgT18a9
	At/iKl/pfO41oaKgUpc4EkUCbDLmeb/sWu4KXKiVB29IHHbQQndfRlkp
X-Gm-Gg: Acq92OGaNLJpcXafHrK0shB67re88Q6bwjeYlj15jpskOe0EHhtyLflHLEc9dionFO3
	0EmeGJTekIHjbtOYku4HYpl8XPzM/YtZynFFcs6BTUPjPxcFqU5MiRqxLT+XjufQ0+puSCI6RvS
	5MsT7emHDATzrkY8WLDOUICdNsCU7mQ8ravwgjX2lMfKV8isSAzLaQ3xPmJSkyms+G7lyMV05x8
	kGAGIRBN46nCwr2TwO97BFA3ClBSxmtpHkcn4YFWfWWyfDDkwre+5zTfEpBpO9K8RpPRfE3y6hB
	DPmSQ3w162kD5FJzZaFm4L0qBKpQdoTZSLfxuHQzxJ6C469uJH7Ftc/RSBVfqRdxUvyU6PdJIpP
	AEGPWxSmS0l/HdNuLy1Q1WEumQu6A5fWOWu4QUlZDgew/WU39QFiEu9ajnUZ2vtAmfxtcVGzuzt
	zCmKt5Z0Em+DYVh0ZjzqwzPMmSK2E=
X-Received: by 2002:a17:903:1acd:b0:2b9:f59e:aca5 with SMTP id d9443c01a7336-2beb07eac66mr130317725ad.39.1779698161604;
        Mon, 25 May 2026 01:36:01 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b3bb6sm89301805ad.47.2026.05.25.01.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 01:36:01 -0700 (PDT)
Message-ID: <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
Date: Mon, 25 May 2026 16:35:58 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
 zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP1tCc81ascjwxJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/5/26 15:09, Christoph Hellwig wrote:
>> diff --git a/common/config b/common/config
>> index 4fd4c2c8af11..605a57947a40 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>>  export PARTED_PROG="$(type -P parted)"
>>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
>> +export INOTIFYWAIT_PROG="$(type -P inotifywait)"
> 
> Usually we try to split infrastructure changes like this out into
> separate patches.

Right. I'll split it into a separate patch.

> Also any reason to rely on the obsolete inotify instead of fsnotify?

fsnotify is exercised in patch 4/10.
IMO, exercising inotify ensures we don't break legacy stuff.

In general, is it fine to keep obsolete command/testcase from
an LTS kernel perspective? We did that a couple of times before.


