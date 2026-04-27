Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A81C3A1A54
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777327839; cv=none; b=Xt24vukCkeoz55KVTfCUhzScQhGSjOfYCZ0d6Pqy8JwG3k7t2Q1CNXHbfLyCWZZ1qLxBuKbVHozjHO8VC2DhOv5JPRRlP8VeWQPJNhFGV3Rny52C3biJv4OpJPz5tHSP9RLyPF8opLVL0+RbQ3LwaiTLuF6156gvaDdNEJn1Kvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777327839; c=relaxed/simple;
	bh=yOQ6gjnQjjUeNUgC4FUq4nnXpbnMhWTwKjqOtVJ+/8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eRABlLQVbdoSAMCGBIk9EJUYSdn918ljV3Ce/JRb6qhsYWPdLuK4PlFxNENieLOpKwRYxn4e+p4+/vmLa+CxmEEj5O8C/Le0AVSKVZyfvn3G74+z/+N7GZBMjNYPErKcGbTKlUe5CnriNw84C/Hzba8QysNMeQSknd9dTS0n4yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=etD3eLBq; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="etD3eLBq"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso112320595e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777327836; x=1777932636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zx8jVJ+UoGMHLaB+go2QsqT1YYUSBZGNa89TZqvMdYc=;
        b=etD3eLBqu71uIc5IGWtXl2jTF5V7jEFTsi6ERmdRinnYW4PqJCVri/Tm3B0Ny94C3t
         4kcoshGd86wvbYJA2KuwetM8I0mFrpByumM2QRLzSNq3hDRLo6K36caLCVVCWsU3nVUJ
         Y8+2seU5XV3b9+uELAyEl0d/AoHZI4LWyILfWEfU4CTdcqVs1jdCEv159Hxn30UgT7jI
         hmH0PQvOj1RbToVBlpwUcymz07y4XtaMxn5LOzhqIZEtANbAKYaRphM4gJg3gL0Q6BSt
         YXL4x0h6KaoukVCNnaiyZAMmlQFG3Ogbxqr8xs71P4kPvK+VL6T6QKQVgs2P5iM2mnnf
         IURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777327836; x=1777932636;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zx8jVJ+UoGMHLaB+go2QsqT1YYUSBZGNa89TZqvMdYc=;
        b=TEgjcboWUm3D53DLRVlyn+MJEM6AC38UlanKfs+KdoqG1b+DQyJqt3fpl7iXBFXolT
         cNMNTSKy+nMY7jBS0jY3JATOINhpfLJOCO+NiAY/L4+eBHc3FJaPRpniC6aL8FSFnxYw
         lq3+hCtR1iwWcj4GrM+9aLP8J2YD1nveAMjk0gVyuKufof1tgKEQNVyokf8uu2LE45TR
         I5KWQgqU/9zGDjRkS4sZZ99v90VnCdh4d0FIwEdwoTUcdV/xpmsmWGpOEIQvUdbeTttd
         vYDd+jwTfKLi9sZOksdD08iwb/BcUCkwKHF08Stx2TAjSyWy9ruBYzNod9BKrd5hMacY
         44vw==
X-Forwarded-Encrypted: i=1; AFNElJ+xFdd3LEcoxkaNAUb5MRkmQiNICNaA55FWkyoeXiK+vQmp6I24scNoVT0nOsAP/wZ3OJmboENJvHlm6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS5kNCnlWg5XLMrbt80NfSZ6WhGed6S+CZP2BhYjwFqqhg3ABq
	GOAhy6CuRz84jVphE/rFz9+WfhOJC2n2i6C4p3xkBflEWExraWjsXqY4ETQDMf4CWILZKB3Zins
	brVqR4Tc=
X-Gm-Gg: AeBDievBz/kl+TD3HR9B9mAN4hUMsN5A2gr727kDs/zHNKkMFZGeg1rrs4UYZ/IS5nO
	3qzxofFPwRPMofh1G/z/2jlwPwB62anHj/C4iE+s5ezPRrkm/PlyuOSoQTSEY5+ScY7FsKCbL/P
	/QReRFwh44DXXVz6wgaaG1a9fWNw/gBk/kza9BDigJrbJoWk4TRZP+Qk6zv1bHTYr61YS0qNoxk
	HxgTlhI/0IqaMnu1wt8Kr658n3AeBUME4D3lUermTFuU5ZGa/vFAppsZc1tR/CQeHiajd0pOTGp
	jPhyNFGGhmzYhSFN7e50xL5DpfZbwaski3L/4leusQciv+bt7EDGOL6ADuNw0wxMEyQzoprAQjS
	I40KnLv9iacG9EVd7Qa5L54xW7qXyo5myKb4+vjeg2U3rUaOKuNI4VJ3Wx5wWNYrGqc43Rrk/82
	p7doEaKMWtTtUU9njCHnFBu613bE2mjhOFEPAQxsaLC6AS6GpUiyR0AtDoyCFNPg==
X-Received: by 2002:a05:600d:8402:b0:485:3b00:f93b with SMTP id 5b1f17b1804b1-48a77c1f691mr4204415e9.31.1777327835941;
        Mon, 27 Apr 2026 15:10:35 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac8cb9asm4384175ad.65.2026.04.27.15.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 15:10:34 -0700 (PDT)
Message-ID: <3f28ce8f-25a2-4972-97de-b995799cea40@suse.com>
Date: Tue, 28 Apr 2026 07:40:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs@vger.kernel.org
References: <SYK4ET.WNV9390MEC881@mailbox.org>
 <b53641af-f231-45b9-9d4f-21e1ee8132c7@gmx.com>
 <ID66ET.91J1PP272KJY1@mailbox.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <ID66ET.91J1PP272KJY1@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 06:02, brainchild@mailbox.org 写道:
> I have the run the check command, which reported a variety of errors. 
> The output is attached.
> 
> Are any recommendations available to attempt restoring the volume?

The super block bytes mismatch is a minor one, which shouldn't affect 
normal operations.

But still you can use "btrfs rescue fix-device-size" to fix the problem.


The nbytes wrong can be minor too, but it's affecting all snapshots 
containing the inode 16523863.

You can either fix it by copying the inode to another location (can be 
inside the same btrfs), remove the original file, mv back the new copy.
This will need to be done for every snapshot.

Or you can try "btrfs check --repair", which will do an in-place fix, 
but will still break the shared blocks of every snapshot.

Overall, I'd strongly recommend to remove all unused snapshots first 
before doing either fix.

> 
> Thanks.
> 
> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo 
> <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
>>> Hello.
>>>
>>> I am struggling with a poorly behaved BTRFS volume.
>>>
>> [...]
>>> ---
>>>
>>> No errors are reported in the kernel log, only warnings about 
>>> skipping the swap file during scrub.
>>
>> If you assume the fs has some corruption, none of the above is really 
>> useful.
>> A full "btrfs check" is strongly recommended.
>>
>>>
>>> Second, within the logs generated for Timeshift, a concerning pattern 
>>> recurs, as in the attached example. Further, during the periods in 
>>> which are generated logs such as the one attached, the entire system 
>>> lags considerably. It is clear that the volume is not healthy.
>>
>> The lag is mostly caused by qgroup.
>> You have a lot of snapshots (shown by the super large snapshot id), 
>> every time a large snapshot/subvolume is deleted, btrfs will try to 
>> disable qgroup to avoid such lag, but if whatever script/tool decides 
>> to rescan qgroup when the snapshot/subvolume deleting is still under 
>> going, the lag will be re-introduced.
>>
>>>
>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the 
>>> problem emerged. I upgraded by to 7.0, finding no improvement in the 
>>> operation of the volume.
>>>
>>> Also, I tried initiating the scrub through the most recent static 
>>> build of the user-space utility (i.e. btrfs-progs), with no 
>>> improvement.
>>>
>>> I would like some suggestions for restoring the volume to health, to 
>>> avoid the need to provision a new volume from scratch.
>>
>> "btrfs check" first, if no error, disable qgroup if you have frequent 
>> snapshot creation/deletion.

So your fsck is mostly fine, the lag part is highly possible to be 
caused by qgroup.

If you do not need it, just disable it for good.

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>
>>> Thank you.
>>>
>>
> 

