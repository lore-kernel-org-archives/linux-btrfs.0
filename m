Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0434D901
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358577; cv=none; b=bLVD5w8igqEQPZCHRsB2kGy3QdlH9G++SA9HY91/ZU1UeXEgpQMtYhnzwaPiWdcIZPC9coqU0hDMzqkD404X6UCR6F5mdvx7cGfKa9+pGJ7guA96/oe5RbkgcZqpj+h2pjRQ2zKtYHu8qM7KUAf4tSGksSZ8X/2tJA3OL/Fq7qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358577; c=relaxed/simple;
	bh=fYJ5mHq4QmSl4hLr4psYfYMsXpthq+yhOwVDuodRaIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7mTJIVnfARehUJsyesTsrHe+D1Tem+N31b4RVB/ox1CcNhRbjHAZBuWdn7cMqSFYlZ1tFNCcQ4AC0oWFgPsKVXvTo/W63KRVdvv8culB2yO8gp8Jt5O8pwkqRZIMJ3U7sOmWjT9e3apuN0MXAv9AV3OjqAg4YSjR1e+EYlZx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tBHcnA/h; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBHcnA/h"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82f68b3aaf7so4142853b3a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 23:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777358576; x=1777963376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJT0Q2+TNC0iQL2BZKm7PxCYejNErSFxDX4dcCZU2IY=;
        b=tBHcnA/hTkDN0WztdYUH4kvsFbM74MdUJDBMMWdZeygESyV2qZ5q4p9Up30kQ6dwyp
         XvACJHNVT/MLUWTkHORDbjN0rw4tOx23YJnV52/WHbyBK86N8PV9w96jmkNhiVrvT2Qz
         1+yPS3FX5il0WQjfcYA/AHcw1yKT6kakcGaEyS19OqV+jGoSdpVOltzEV+EJKlLdhJem
         WuVJcdmglXp8HN07xgUK+tKnPzlwWpZ6L+ti/SE7XqRIZlJnFjcnEG38j2DKHLfnFdvL
         ZaEyVM0WMngvP0vzBqWSrnx+kowZ3C1tnU7HX6ObZOnVKsx57QHssjB2lurLw+sLwN+r
         eKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777358576; x=1777963376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJT0Q2+TNC0iQL2BZKm7PxCYejNErSFxDX4dcCZU2IY=;
        b=eWsN/vpAzGDgeVuu7hd+o07upcL71k+JRAt4jaih9n+5mTEzdD887oB6CJQpsdbZGQ
         00gC6NMl/3aacfxp1vFSPiWEesn9TzalKXngISfbgaBsQveFcmPx5ewaxKMs9JpEmNuk
         mqheBCQgKQncHJyXUugTeS1kbQAeOJTXmULWjg4R1sdM9lMVbMCLpg1mzKPSR6IfAogL
         houxLXiWnm9xTAbNNKttKgWiUgbHpMWTtoAT+3yCiV/3onKs5iTLjIeha6OC09BZVDZ+
         x6Yfl6MSJyqrYRa6o7XOmA9X2drxC34mr2haTRbk3UEHDC2tRqB8HdpRVXLEdgvZGtk6
         SaXg==
X-Forwarded-Encrypted: i=1; AFNElJ92m0saCqatzGBINymkqPaA9q4+sx5sGVbUXSYM4Y6Hy1WEpHovHY5FNL8gY7eYlHU4HfzsW8MK89i2pw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoiKXEbo/EXg68MYH0nOcDilppzrAHo1NzvCU+z4fs347/yRNF
	2tLBZeAtDFVB1Hdx1x0Cjqv1CE1gcSO2kMkm7ZiqigfAXYNclxwkJOImhgWAIle3
X-Gm-Gg: AeBDiesAOSkHYxKXJ1vlRYMWPqU0IUOAP0JSZmwjgV08IxCG79q4/Rorp6UP7tQBbf1
	eWJ5CBzuCKzb74NMObG+K9lE4Tww+QBPbnJUhRofp+yNS30XDeQMRarECL0wEvxsJgCZmQp07l7
	SnzKGT9iEhsquXUb6t7RGzDNWAMxD9W64FFEKdLk0eIxCzzGPufIV4x8MApLuBwovX2vracC5dC
	zdO+nBf1X/tYubtbJEZXkBEFU/YO110hTmF2s3YUDTOPU7nLUFFuV+ESZFDQYIWdlXPPggAlL1S
	nUZ9XowUUu61mAfNbPlPHOrQBDz5K1b4NOK2jcdp6RbIv+V4IDYdr/pCKtj3+P2GiDUfn1RpXeV
	jyAS2TWAXKXFgz5PgGGJpVY4Ipe6l7xBWNH9Onx3jL5JjcfnnFWq+roT9jvmpGFlINsK0pA4cdR
	Ql3zII5ZFekF3dCHzTcAfzJjrTahWAV0yJJRRWow==
X-Received: by 2002:a05:6a00:12c1:b0:829:8c08:d1f4 with SMTP id d2e1a72fcca58-834ddbec0e6mr1846825b3a.39.1777358575700;
        Mon, 27 Apr 2026 23:42:55 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834dae07945sm1904377b3a.9.2026.04.27.23.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 23:42:55 -0700 (PDT)
Message-ID: <71447b65-0390-47a6-b0ec-7727a3009256@gmail.com>
Date: Tue, 28 Apr 2026 14:42:51 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
To: Amir Goldstein <amir73il@gmail.com>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
References: <cover.1777281778.git.asj@kernel.org>
 <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
 <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 28/4/26 02:31, Amir Goldstein wrote:
> On Mon, Apr 27, 2026 at 12:19 PM Anand Jain <asj@kernel.org> wrote:
>>
>> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
>> image file and clone it to another image file, and attach a loop device to
>> them. And its destroy part.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 9632b211b58f..0e7b7eb1d98f 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1503,6 +1503,50 @@ _scratch_resvblks()
>>         esac
>>  }
>>
>> +_loop_image_create_clone()
>> +{
>> +       local -n _ret=$1
>> +       local pre_clone_tune_func=$2
>> +       local img_file=$TEST_DIR/${seq}.img
>> +       local img_file_clone=$TEST_DIR/${seq}_clone.img
>> +       local size=$(_small_fs_size_mb 128) # Smallest possible
>> +       local loop_devs
>> +
>> +       size=$((size * 1024 * 1024))
>> +       $XFS_IO_PROG -f -c "truncate $size" $img_file
>> +
>> +       loop_devs=$(_create_loop_device $img_file)
>> +       _ret=($loop_devs)
>> +
>> +       case $FSTYP in
>> +       xfs)
>> +               _mkfs_dev "-s size=4096" $img_file
>> +               ;;
>> +       btrfs)
>> +               _mkfs_dev $img_file
>> +               ;;
>> +       *)
>> +               _mkfs_dev $img_file
> 
> You making a wrong assumption that FSTYP can format the loop devices
> 
> You should add _require_block_device $SCRATCH_DEV
> to all your tests or maybe nicer, add:
> 
> _require_loop_mountable which requires loop and block dev fs
> and use this requirement instead of just _require_loop in all tests.
> 

Thanks. I've fixed this in v4 by adding
  _require_block_device $TEST_DEV
Since SCRATCH_DEV is not required.

I didn't create a new _require_loop_mountable() helper.
Both _require_loop() and _require_block_device() are
used both together across other existing tests;
I prefer not to deviate into cleaning that up in this
patch set.

v4 is in the ML for rvb.

Thanks, Anand


> Thanks,
> Amir.

