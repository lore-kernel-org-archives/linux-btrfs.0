Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F553AF64B
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436379; cv=none; b=J00K2r+yJwn4ASP/wZBHhbsDfJgnGDyiPtfY8RMLpVn83O1kaDASCi5uc+79xuybosjJbecsxQDmNmjpQLti61eauvqI7CfMqd77J4XIaLi2u9Y3OGGSsvUD0xDBqVsu3fkKifjpNhZWPSxyrWVHFf02umoERxSHOhYqxprUEQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436379; c=relaxed/simple;
	bh=ESSmAusi22zNrBrBrCZkk53AgiDttI2zhQYE6wfMss4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tyx0ClYG2speY+QvEke3wVDoc3WKiVz8BHIdSX2aNq4JqOMTKg8rJ6Kaoqxdfw9MxOcjyjA6EEWrBmk6lyMPZdPnzyyRteUdEMP16ZD/nBqEgAzMMu+8Ca+DNb8liEVEv7L1uTFHA46GQ4fF4ICDO8DsVAeeSoO9G4H9HdhJ+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TMExgBuT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TMExgBuT"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2addb31945aso48586885ad.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 03:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774436377; x=1775041177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kkhBUMnec/GjdnW5fmLX7Wmb/ODJVypSPDeWmYyRkhw=;
        b=TMExgBuTCemrOuxxCujCSsuE1yJfYUP7dyClGWoO/so6QSTavU2Q2xGlEu0qorXHy/
         oy3e1MznEJDBJeYVk1VPHynv6r/J0Blr0vUPkPIG430TMIBnOAZQqcX0ScQLutlVCHOL
         cPj9kXZzUIMO8nnhKcuFF8vyVWiUj2q+Ul1fBVHaDMeJi8hVcZnfQQvdK9bjq7WWIMeo
         638f2ADX1TEmNtNdY5Y/qjzzNKACP2wakS9qBdA7F5LMHUjbidliBSs3MO0sBCK6D0LA
         VdZcRadRmRFLvCnqeWNXZ4NqV7tv4meEMInfmgDGKbhPvTIy96dHjnD93lW6L8mJONCh
         m1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436377; x=1775041177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkhBUMnec/GjdnW5fmLX7Wmb/ODJVypSPDeWmYyRkhw=;
        b=A/akuZ2uauEZJ52VmmUU/Rs+4ofUu/sKJ4IOrN6pesKBJFXcpoZm/nt/IkvzSoaGqg
         DdDfPxSgplxVlhJxOmuVpTGzEtSLbkQawsHJfBoncZgacU9gQHa+uZeBe7cax/VlCOaZ
         NYuw/Rr0+PVy+0C83su5HXN+Kipymg64chCkoUbx/sWRI2bNfh0Cf/2bN9jzG8w4Pad1
         MhkpLeVJ+ocx7uEgmlM74syXx5vZXiqWrzz4IQWIB2oxaHQKS+J/drUM/a3Rjs8WTgR4
         81kM1wH3P/TwhRKmdcDl1KMOTKBnOobD3qy0kBD7wzrJTfYdXpp49V0Xgzw3Jfnro59z
         SgRA==
X-Forwarded-Encrypted: i=1; AJvYcCUQOwTrk3nqUENby0Q99QExXHNkeJsHs0oy9V5KofHv1UY0N4Fu99IQFHxuLjegoSun1QaPCcRd9ksDOA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg/cKAkshvcosg4coCnW8dzUTWhk73De6ggQbVl6TiwUIEYiab
	YhK1us1CPZWof7OGzrZBIzxmB8fdk9yZhl8qJ6K3vzwO0EptqbREQ9qN
X-Gm-Gg: ATEYQzysPhafQR8HFS9OxaUF7lOrnRHKoguiV1QYjs8nuOJgqImvocMjGmgKHXEvkhL
	c3VSI29ZRAl0xVn4AdtZEkqKGM9dHh0olajT7CtFp+wH+oH3fn6V+y9GkjAN0HayqNkcXI80z1J
	+cnQ27ttxzw8urve4g6pPJMhhVhfWTxhNQIp23btsGNJJytyGFvvwzVA9sKf/DUzU+l/laG6Aa4
	2MCThDLZ1GlXdIXSldIS7U1T8iIFK1A3Ti2B8czUc5f343BE5J4qpHK9DcOjn4BoIpf8R774Weh
	jLGUarBGKCcSQTpnDts72UJHyj3p89BJud/MVbfpEg19AgkAcvebl1piF9rdNLqtImrCXsUWr7L
	W3cRXdm+cMR0Wy6YVWGIO7fFOxJz9YttEcqriowTl0I69yt2Y7wRcDjZSiIRujZ5A4e6Qzc4JnU
	+cVjnmJvw6k7Jfbhj4rEMvAtIoi70=
X-Received: by 2002:a17:903:440f:b0:2b0:700e:fc9b with SMTP id d9443c01a7336-2b0b0aea735mr36634815ad.34.1774436377001;
        Wed, 25 Mar 2026 03:59:37 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm182971235ad.33.2026.03.25.03.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 03:59:36 -0700 (PDT)
Message-ID: <91d1e10b-b24d-477a-8724-2a75a710dd8d@gmail.com>
Date: Wed, 25 Mar 2026 18:59:32 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Anand Jain <asj@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, hch@infradead.org
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan> <20260323152943.GH6223@frogsfrogsfrogs>
 <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/3/26 18:02, Andreas Dilger wrote:
> On Mar 23, 2026, at 09:29, Darrick J. Wong <djwong@kernel.org> wrote:
>>
>> On Sun, Mar 22, 2026 at 11:16:24PM -0500, Theodore Tso wrote:
>>> On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
>>>> statfs() currently reports f_fsid derived from the on-disk UUID.
>>>> Cloned block devices share the same UUID, so distinct ext4 instances
>>>> can return identical f_fsid values. This leads to collisions in
>>>> fanotify.
>>>>
>>>> Encode sb->s_dev into f_fsid instead of using the superblock UUID.
>>>> This provides a per-device identifier and avoids conflicts when
>>>> filesystem is cloned, matching the behavior with xfs.
>>>
>>> As I observed in [1] this leads to collisions when for removable block
>>> devices which can be used to mount different file systems.
>>>
>>> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/
>>>
>>>> Place this change behind the new mount option "-o nouuid" for ABI
>>>> compatibility.
>>>
>>> I *really* hate this mount option.  It's not at all obvious what it
>>> means for a system administrator who hasn't had the context of reading
>>> the e-mail discussion on this subject.
>>
>> I don't love 'nouuid' either, because it means something completely
>> different in XFS.  'fsid_from_dev' or something would at least be
>> clearer about what it's doing...
>>
>>> As I stated in [1], I think the f_fsid is a terrible interface that
>>> was promulgated by history, and future usage should be strongly
>>> discouraged, and the wise programmer won't use it because it has
>>> significant compatibility issues.
>>>
>>> As such, my personal preference is that we not try to condition it on
>>> a mount option, which in all likelihood almost no one will use, and
>>> instead just change it so that we hash the file system's UUID and
>>> block device number together and use that for ext4's f_fsid.
>>
>> ...but why not just set fsid to some approximation of the dev_t like
>> XFS and be done with it?
>>
>> st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev))
>>
>> There are a few other single-bdev filesystems that do this.
> 
> On the flip side, if the fsid of a filesystem changes because a new disk
> was installed on a server and the old disk gets a new device number or an
> upgraded kernel with different device driver load ordering, that would
> also be a big problem, as it would break NFS file handles over a reboot.
> 
> The whole point of generating the fsid from the persistent storage is that
> it is persistent across reboots.  It seems like the real issue here is
> cloning filesystem images and not assigning a new UUID to the cloned image.
> 

IMO, sb->s_uuid (as used by overlayfs)
Represents a filesystem UUID that is persistent.
It is derived from on-disk metadata.

statfs()->f_fsid is..
A kind of runtime filesystem identifier used to distinguish mounted
filesystems within a running system.
It may be stable across reboots or device removal and reinsertion,
but this is not guaranteed. It may change if the device dev_t changes.

I have posted a set of five test cases to the mailing list
to help verify these behaviors, for your review. Another
test case to verify device reinsertion with a different
dev_t is a WIP; it will be submitted along with v3.

Thanks.

> Cheers, Andreas

