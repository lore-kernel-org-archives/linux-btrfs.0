Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016E3451DA
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 23:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788217347; cv=none; b=uW0aYkghlLYR41qzhL652PRRVO9IR3NiG5NyobP4rvtH2B7RNNfSBMYJA4OWMPCKI4WbdBxgs7ilfTBdfRaIfmTSA1mpv4hIApxDAQKXaT9m6GW/DaeQ35AAmMl8Y12WnxJ/HEs4xQ7A6odizagviwiZwvokBiQiNXdWzbd/fgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788217347; c=relaxed/simple;
	bh=srJ7P6Cr2Y2BRvvy/G8mTFIuYG8PVvmCZnwgpwNvsUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUsAck8IcrsjdRS+koyJHTM3i3UESQ+mnR8EI2z3vwKofRCNTPJV9v9rdIQiuiW4K/iqV6zdm3NnKzSAXzhgZZuPXsSph9v3zX8NOgFjG1kTf0wP0KZKmVGiKY8pKjggW48+0/voXwFmH1+bj/Mopl9Vwzu08u6i7pm3fIl9cdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FiZtmQom; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FiZtmQom"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso46868705e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 16:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788217343; x=1788822143; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02CWFPBpXa9J52S8/J1qm14T3uEHsss4E9KWoQ8KFLI=;
        b=FiZtmQomvzVTdkbeR8dihYcMMXDnpX/LLVxs8wPso8s2f2bO9artZKqf9LswZAtL6u
         3a6or3dzwA87Q1DY1dBj7loiKbP/QYCKyB7ATCuf9NTm0f5y4j6pNKOc++7Tsq482vll
         vgVD8nbHL+rZU4ktloWZHb0bptMH+7eGRD2O/5fHonrOjrKX6ajT+c9Fd5dovQCdhcJV
         bZTyv0QDpaY5wyB1xYW/6vROOF/RNHOexBk+mN7yN/KUHfdn6I54kPyekngsCLtEIbfl
         eQ2EYMqOg1qj8s5nxc6tuBjrnrWMkXpS8+a0pclAEp51xvDuKQPUZ4r6fWHea/f42Lci
         u2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788217343; x=1788822143;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=02CWFPBpXa9J52S8/J1qm14T3uEHsss4E9KWoQ8KFLI=;
        b=MrJvfJvof+mqyEhMcg+IXqhBcl1kwq9IZoKkitAl8e0Z4SsHLpHRaUoK8EWyv3I4m0
         M+s51GF7yZeo23xkWMJ7HhP1VEEtTOivCBov6whSkjVixCBT1+iigS534e5QC9HYvtUY
         rElOAeT/jLJbkTUr3wsaVmKF8WxYnVsSFgRCmOeRMDD5Uqhu0f+h2+AKmuIoA1D2vcGn
         ZPopmvHJHQd2cPk94+lPo5/3Y6bSyL95zwVVd+DTZ/dYZ1Z7RuF9+KbBzZhxUhcGofTI
         GMJzixoMdta3PFybR/Ijxli1gluOYj0Bmh29PWRwBcni+jB++bL7pkPoYsWmEVZzLB94
         b/wg==
X-Gm-Message-State: AFuF++lQpXetk7dXlXRrVeN3Tl98SS5FIb9xI/pUnfPPebm/M6ViD2hE
	3p+J6kvvOHrPbqazPnO0gRAq6QivXPZqkadPt4QOc+Wtt+qNuUBgTLXic5BJq50QK7q5AWbMy47
	a2T5GnEtH/Q==
X-Gm-Gg: AR+sD13pIAakLb+l45reKEBIA4E3JqXAJ+08NR/Glcx3MAeia9g4HNWqh5aU6UZI1P4
	xG5RQnIWnfL4MUMBJ1F6XhBbqTEU68fa2pV4uQxRK123osU1doXD0slDDmjB+Uc2ImNcK1dasV/
	+2/Ul0WDvAK/F4IS24iCoCMjZM45OA+ffkOKNlPRrLcGih0hjuzYnB13Uqz4cPMXGpPfjx2VQhB
	ucd+6oGY8w//feRzx93y1sAvKMtmYeUKtuRbu79s+5+vdtCmWywaIlq73q5cZK1Jkvs813CVsV9
	nya7G1Q5xnLnRZ9vgLh1RMG3e2JO37+T+4jnzLShIvlqfztg+Znk5Z+tU+y1y2cBgy52PAvJdwI
	ZNXAbSYUsU1/6QDVYyYemQAJqzxPvbiDa+k6oYdHLJW94RteGYusjFGM/SvFRfKBOYaAHHISjWO
	CZ5PmKR8k7qnU//20pA794BNjGR2KuijgwZzMYVB9MO2M5c1slOtw3
X-Received: by 2002:a05:600c:1f8d:b0:499:621a:2ec2 with SMTP id 5b1f17b1804b1-49b91c17c41mr416683285e9.3.1788217343366;
        Mon, 31 Aug 2026 16:02:23 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d7ba9d5sm2157363a91.13.2026.08.31.16.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 16:02:22 -0700 (PDT)
Message-ID: <153de220-10ab-42b7-a296-04b27e0563f1@suse.com>
Date: Tue, 1 Sep 2026 08:32:18 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: add qgroup status item check
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
 <20260831215120.GB325502@zen.localdomain>
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
In-Reply-To: <20260831215120.GB325502@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/1 07:21, Boris Burkov 写道:
> On Wed, Aug 26, 2026 at 07:23:15PM +0930, Qu Wenruo wrote:
>> This adds the following checks:
>>
>> - Key check
>>
>> - Item size check
>>    Here we do not require completely matching the older or newer qgroup
>>    status item size, this is to allow future structure expansion.
>>
>> - Version check
>>    Again it's not a strict requirement for the version to match the
>>    support one, but to catch obvious bitflip.
>>
>>    And the kernel will already reject unknown version by disabling qgroup.
>>
>>    So we allow any version that is no larger than U8_MAX, which I believe
>>    we won't reach in the next few decades.
>>
>> - Flags check
>>    Mostly to catch any unexpected RUNTIME flags.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Loosen the version check
>> - Loosen the item size check
>>    To allow older kernels to mount future newer qgroup expansions,
>>    other than completely rejecting the qgroup tree and failing the mount.
>> ---
>>   fs/btrfs/tree-checker.c | 64 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 64 insertions(+)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 0ce91396b517..ff268ebb22d7 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -2313,6 +2313,67 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
>>   	return 0;
>>   }
>>   
>> +static int check_qgroup_status_item(const struct extent_buffer *leaf,
>> +				    const struct btrfs_key *key, int slot)
>> +{
>> +	struct btrfs_qgroup_status_item *qsi;
>> +	const u32 item_size = btrfs_item_size(leaf, slot);
>> +	/*
>> +	 * Since the introduction of simple mode, the size of qsi has been
>> +	 * enlarged. We need to handle both the old and new sizes.
>> +	 */
>> +	const unsigned int old_qsi_size =
>> +		offsetof(struct btrfs_qgroup_status_item, enable_gen);
>> +	u64 flags;
>> +
>> +	if (unlikely(key->objectid != 0 || key->offset != 0)) {
>> +		const struct btrfs_key expected = { .type = BTRFS_QGROUP_STATUS_KEY };
>> +
>> +		generic_err(leaf, slot,
>> +	"invalid qgroup status item key, has " BTRFS_KEY_FMT " expect " BTRFS_KEY_FMT,
>> +			    BTRFS_KEY_FMT_VALUE(key),
>> +			    BTRFS_KEY_FMT_VALUE(&expected));
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	if (unlikely(item_size < old_qsi_size)) {
>> +		generic_err(leaf, slot,
>> +			    "invalid qgroup status item size, has %u expect at least %u",
>> +			    item_size, old_qsi_size);
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	qsi = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
>> +
>> +	/*
>> +	 * The version (1) hasn't changed for a long time, but even if we
>> +	 * are going to support a newer version, it won't suddenly jump
>> +	 * over 255 in the foreseeable future.
>> +	 */
>> +	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) > U8_MAX)) {
>> +		generic_err(leaf, slot,
>> +			    "suspicious qgroup status version, has %llu expect %u",
>> +			    btrfs_qgroup_status_version(leaf, qsi),
>> +			    BTRFS_QGROUP_STATUS_VERSION);
>> +		return -EUCLEAN;
>> +	}
>> +	flags = btrfs_qgroup_status_flags(leaf, qsi);
>> +	if (unlikely(flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK)) {
>> +		generic_err(leaf, slot,
>> +			    "unknown qgroup status flags, has 0x%llx unknown flags 0x%llx",
>> +			    flags, flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK);
>> +		return -EUCLEAN;
>> +	}
>> +	if (unlikely(flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE &&
>> +		     item_size < sizeof(*qsi))) {
> 
> I assume this SIMPLE check is because enable_gen is new after the simple
> quotas change and that old qgroup status items will be smaller still?

Yes, the reason is correct.

For those still running qgroups and have never disabled it (which I 
believe they are minority now), their qgroup status items will stay 
without the enable_gen member.

> I don't think that checking the flags of the given item makes sense,
> though? If we happen to not use squota the flag won't be set right? but
> if the size is tiny we pass this check anyway? Or is the idea to look
> for specifically squota status items missing enable_gen? Why not look
> for normal ones missing rescan or flags or whatever?

This is the common practice for tree-checker, remember that tree-checker 
is the "2nd best memory tester" to catch weird problems, not only from 
btrfs, but also bad hardware.

So the principle is not "this should not happen so we don't need to 
check" but "every member should be verified when possible".

And this is part of the common path for any variable sized structure, we 
need to make sure the added member is not beyond the item boundary.


Finally for the "why not look for normal ones missing rescan or flags or 
whatever" part, that's because for regular qgroups, it's completely 
valid to not have RESCAN/INCONSISTENT flag set, so we do not need to 
check that.

But this inspired me that, for simple mode we should not have RESCAN 
flag set.
I'll add this check into the next version.

Thanks for the review,
Qu

> 
>> +		generic_err(leaf, slot,
>> +			    "invalid qgroup status item size, has %u expect at least %zu",
>> +			    item_size, sizeof(*qsi));
>> +		return -EUCLEAN;
>> +	}
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Common point to switch the item-specific validation.
>>    */
>> @@ -2394,6 +2455,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>>   	case BTRFS_REMAP_BACKREF_KEY:
>>   		ret = check_remap_key(leaf, key, slot);
>>   		break;
>> +	case BTRFS_QGROUP_STATUS_KEY:
>> +		ret = check_qgroup_status_item(leaf, key, slot);
>> +		break;
>>   	}
>>   
>>   	if (unlikely(ret))
>> -- 
>> 2.55.0
>>

