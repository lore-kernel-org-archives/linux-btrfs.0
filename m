Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6810382F26
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 23:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781219645; cv=none; b=ZUE48fnjdT6jp3rJx9erTWQRh+Plmy3PP+YBv+FU9m0ursbEwjQ2cVPk7jtmHaKEdrHneyRfyuukuTtUwEZnRIgtAsA6TYUpZsAuJlHHvWPIX3vSgPgR2+XLUpp7KFoVbGbGVbCimnNaPRKD9R/feG1Yh68kusTlw26al4HIEfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781219645; c=relaxed/simple;
	bh=wE5VwJq1OYwybo9+Ow22Z0zhPTk3rTkgMqzbU2odaXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gw0EXEZ6i+Br4/uCnyTskYfeknYcsiX/AtBO4mIuWrJTWxD6CDpAKyHjzdo5yuuH9X3JjuMJxVUJvV2/ustiHnUeRqIRruIhjh1aDOwaJ0bMyA6/IkBSE6vYrEtMjhavWVJVQEGalOe5MJCmsxma4ngIwWCg2lvP35m2xCo4baA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RE+FMnWQ; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RE+FMnWQ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69170548d0eso529617a12.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 16:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781219642; x=1781824442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gPFVSXdET4b8cZEgB00SZtvMr9w4EIZtTTJFRC0Hi/o=;
        b=RE+FMnWQYb1AmEK0CEZKuMevtc3K+8xkfOMjXfL6ftv1XoAu3H3l5lkRFVoEBjTc+h
         UEMPj47q6E8I30mnxOqwa+NiByewNMlPOqjitISbgrx9mQoNIM/9t7Z3+MW+yFgf0/9O
         MCgUT707qVaqM0grjkOmW7pFC46FQfu5UMCje8SQH3wnXw+QuH+xCGpI+7P4wNBdQ/k8
         Q3dMiqK5YfTIZ8Cha04eUJ6sCPNk6dLmmZOI8Kj9QeXKyiczyfWPdvInhdoWwWf6pKmc
         BiORGU+MmxzVpBRsA116W3A48HSr8LMWy6pZS2MuWDrWEDgCk1L6+jtiJm1eJ1so7QVV
         pvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781219642; x=1781824442;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPFVSXdET4b8cZEgB00SZtvMr9w4EIZtTTJFRC0Hi/o=;
        b=P8zdjBYABiH8v4mAUtB91DNOdgsCTeouQLZ0t1phw8CHPeAvcEuVA5i4jsxa/sCx12
         A7UPcVkY5wSxAdq+jRE1ClSm3Ch0E7ZasIjSYU4ayo6iWOTFAqdhKsHmEAW3m2CFYqaV
         8LxrdpnJ1ijUCH1gTw64b6LJOc42SkpKaS7BQEzWyNTug23sMsb5dDgCH3M7uBHZk3Lg
         ftGPLoAuBCoxK44dLHvEqXrpvLJgJLyZnoLA2CJ8v+4Od+RDBeNAwD4NpLzrmoOYI0QR
         0SJ+AcfZvNLyXwi/xMVgdfeI1MoGJwc6ARaP+rFkcGR6vp+ijD/ZeCP4ExrWpcp1zecz
         L6xw==
X-Gm-Message-State: AOJu0YzQ56L+tlmdVHVHcbbWs1CM0/Lg+D4Hpuj9uuFj6ap1Oi8QSkR1
	g1mOkvdA7MzZi9S6Qr8hLa2ZVW/fa1h9+vwSzS1rvp/7ExQN7KAPFQlBssyiXBsM1+lt6T/beXJ
	ESUF0
X-Gm-Gg: Acq92OHgxJ5SmkpKRH8oVIbeux6Yli88n15REBiyICzcyTDRWQYHggznCL0IrJoqZoK
	biTxaiw8qmVY1a+9nAW3D4uacupKnvzAuxbriIdMF6oYOXf6mN0riAVkMpWXHJ7aMte7BjlwpLo
	SdAbdVtpJluyj/JFzmLDuq+MtwJCTJJZMwRNZt7Aa0w1T3GDftR6GciU9jxYazDNthmqkYaeXym
	b+02iZkVj7SXsFsqp8wIjAjAqort5lr/Cyx4CSXSn+4iMRRWDMGMb1ew9A22thY7wGrENQ/AmP5
	jdK0Swgck2FZ5HaZss+FZLj6IeRnpfsx+Qc/k2SRsjiK137gjdzXH6YsKACE5PnAZKhLpGuJt9S
	6w+aR+6e37x/DAxpswtl3rPqiIjDDMoWkqdoZoK26r1tfBx0A1A0+esGMPAXyCTasC/aHBBVAIS
	kfGN23jOSJMwQklyX9QORvOUNotiQgC1Itrl56m0vY7M6z7VguZlFQlmfZS9WnXa0mHUnUviniI
	5rZ5M/b1qzQ7+8mj4Kn2dh6ztYnFyiFbSSDLBYI5UVSGw==
X-Received: by 2002:a05:6402:3607:b0:691:b5aa:5a57 with SMTP id 4fb4d7f45d1cf-69378a569b5mr66558a12.18.1781219642227;
        Thu, 11 Jun 2026 16:14:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b049120sm184214b3a.55.2026.06.11.16.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 16:14:01 -0700 (PDT)
Message-ID: <3672780e-58ba-4644-8c80-4abbfe8cfe1b@suse.com>
Date: Fri, 12 Jun 2026 08:43:56 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: validate root ref item size and name length
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, outbounddisclosures@openai.com,
 stable@vger.kernel.org
References: <20260611212445.4848-1-kylebot@openai.com>
 <dbb8c9d8-346a-486e-9e23-f200f6bebb5f@suse.com>
 <CAC7i46_mVFdRE0a2CexemTKF+COueLhh0+tQNrcgGtYEgThVqQ@mail.gmail.com>
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
In-Reply-To: <CAC7i46_mVFdRE0a2CexemTKF+COueLhh0+tQNrcgGtYEgThVqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/12 08:39, Kyle Zeng 写道:
> Hi Wenruo,
> 
> I'm actually a human who happens to have "bot" in the handle:
> https://kylebot.net/.
> I manually verified that my PoC worked against the master branch
> before sending the patch.If you think I'm validating against the wrong
> branch, just let me know. That was a bit unnecessary.

https://github.com/btrfs/linux.git for-next

https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html#development-phase-linux-next-for-next

Not to mention you're not the first one doing the same mistake, 
re-inventing a worse patch that is already in for-next for a while.

> 
> Best,
> Kyle
> 
> On Thu, Jun 11, 2026 at 3:56 PM Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> 在 2026/6/12 06:54, Kyle Zeng 写道:
>>> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
>>> by one variable-length name.  The tree checker validates only generic leaf
>>> geometry for these item types, so corrupted metadata can expose a root-ref
>>> item whose item size does not match the embedded name_len field.
>>>
>>> Several readers later trust the item size or the name_len field when
>>> copying the name into fixed-size buffers.  For example,
>>> BTRFS_IOC_GET_SUBVOL_INFO subtracts sizeof(struct btrfs_root_ref) from
>>> the item size and copies that many bytes into the 256-byte subvolume name
>>> field.  A crafted ROOT_BACKREF item can therefore trigger a kernel heap
>>> out-of-bounds write.
>>>
>>> Validate root refs in the tree checker before other Btrfs code consumes
>>> them.  Reject items that are too small for the fixed header, names larger
>>> than BTRFS_NAME_LEN, and item sizes that do not exactly match
>>> sizeof(struct btrfs_root_ref) plus the embedded name length.
>>>
>>> Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
>>> Fixes: b64ec075bded ("btrfs: Add unprivileged ioctl which returns subvolume information")
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: Codex:gpt-5.5
>>> Signed-off-by: Kyle Zeng <kylebot@openai.com>
>>
>> Tell you stupid agent to grab the correct branch.
>>
>> All it's doing is just a worse version of the existing check in for-next
>> tree.
>>
>>> ---
>>>    fs/btrfs/tree-checker.c | 38 ++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 38 insertions(+)
>>>
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index 1f15d0793a9c..fb072045ca18 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>> @@ -1915,6 +1915,40 @@ static int check_inode_extref(struct extent_buffer *leaf,
>>>        return 0;
>>>    }
>>>
>>> +static int check_root_ref(struct extent_buffer *leaf, int slot)
>>> +{
>>> +     struct btrfs_root_ref *rref;
>>> +     const u32 item_size = btrfs_item_size(leaf, slot);
>>> +     u32 expect_size;
>>> +     u16 name_len;
>>> +
>>> +     if (unlikely(item_size < sizeof(*rref))) {
>>> +             generic_err(leaf, slot,
>>> +                         "invalid root ref item size, have %u expect >= %zu",
>>> +                         item_size, sizeof(*rref));
>>> +             return -EUCLEAN;
>>> +     }
>>
>> Your stupid agent doesn't reject name_len == 0 case, meanwhile the
>> for-next one does.

