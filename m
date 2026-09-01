Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9825B092
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 00:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221534; cv=none; b=qH5V1xAuObKrRMrJAn7Em6TyVliKR5zD5Gd6aTvx/SOS71Wg+lGDeYuCMlxpRAb41Z+Qfu1JDVKloltApAYRKsAhXxxRMKXJUixKyxEJSxcM5VMdacf6ba5NvkEKIIVLNi8I0fsZUZoKhqDUGGewZf+rhuDdMpbe0Z1q3X0m4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221534; c=relaxed/simple;
	bh=OgngblZt/Y2iZOSn09CDd3EGdVHEBN6Ia4QrfnZ/xv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tR7hNIXQG2FDjzGi0SbxOr6jcQWVohzCstk/APrdAAyNmsxFxaJi3nfFgrajUBaU2mZrPlUo7we3JsBj9xvNQO+YdT88zA+ouFSo09y2/7+ky+538Sdv5JbEa/Keiy79XQ0+0J1eP38KMpM2GCCXuou/auq6z/nlup64PFqPwqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YnJMpH82; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YnJMpH82"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49557167508so43982355e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 17:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788221530; x=1788826330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LbzDU/8XO4wi3mvYoOMdnCoyPn5cmJBMUF6S0wXSwtQ=;
        b=YnJMpH82rzq9GC6D682oZ9lyMXWn/ABM5pmWffL+xeOAtxuIF0bnLmgxwwdrWZ6RxJ
         xsD5YcderKIdT1QYZ3GpuDECf0XjWYxSR9QYKqE+C2g5BNP1h0uZgkCiZ8ExIz7GedjM
         SKtW1XT9WfvOQdvVZeI+3MzUZO2zfuwO2prVMVvVlKrKlu0K0ZObWxmtUfAtN+XZ3SMN
         bc+krz0L7m10MrnYWxloHc/Ab2OaEkfLg/6DfDIM+C8Pzbu08iQBtAwM1ptiJ2g2FRJs
         EwqhMrwKcZrPEWKbuUC+mdAxB4FZJRlXJcMCGKZE2OCBV8vrg0ybiO2udIJSHEqYYdyP
         xmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788221530; x=1788826330;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LbzDU/8XO4wi3mvYoOMdnCoyPn5cmJBMUF6S0wXSwtQ=;
        b=jSTd8+qols/DckX0hIK/my6jgxZi0K7z3dtvvaS5X+6x1SzTrF9JGqkQ5Vbza2Gexy
         JDHcoQ8bkbrOABAgzingWsgI+qdhWJzIjD2ANkoGESUSaCP0DUss/PhgzSRWGhWY4Umt
         exovb8U9DTxxorIh0p1RyKLaAjmtb2WmcEH+dfpxNK2dK09ai1tGlbENFkAVZ01uL7Hv
         zaA0U1q2Jooc/amHOYKn83l3bOn3npOe6/TeOvjGkxv2roDZENtELoA4e/4Mia+jUw0d
         a6u3IvYoKGGj56Kn6knFLyOvL801vb8NfERJMSt2ZdL1meoKhqIAqwPZbDuVdNsCgjw9
         wefw==
X-Gm-Message-State: AFuF++l8DFuECdcO/e5LyE+rqAlPbgzkYyTIAAPfd+nr95FrVn9tO7Nm
	eTsRZFRQGPj/xCFUB4Hmp995p/pXO4vshBUzkyWWpFlfvG4YTK8qMtzIgjcCpY6eH0nzvaLu6Y4
	2d1Dge8Pvpg==
X-Gm-Gg: AR+sD12HM5RtcG2b9aUhgNhoPcT0cko4M5WoLPuMCYb9KX2pE8lZGh7//nCPzBLa9HZ
	l1/up3U3trTRK43wcthXb6IwHA8Vr4krWXRiHFkWhecWaoejBq/3C+7nDFhwfyLEaiPl6EZpN+C
	iUa4TkbG0BW9lgy7hnceG3K2Hb/36D3frMsZ7C1vOgOuDHBAme+OmosCpLdMgpz45iHKx5zeSGc
	8I2N9NlhJhQNNw7+pIwt18mEBOWWML2H+rRslFlwYCgnNd4Nxf+lol8dAJtpcwB1aYrDsPH4TNb
	LUBQevJRSLXyrGO9IJQtRFDaFWof+3UyBxEpdpIjdi65LP4HBN8nRwQNSR2M0XVY9nQcm4D7gLY
	yWyzK51sICAdQkQB4KmfHkVDyiVKXVSQNuI4EIxOBPydt5sbPcdD+mwT9LZPsOGE/LMrm/Vv0vP
	xVxVRd5rEuKoE971+S/6zp46ocv2HhLP8+WvVbMt//I++YsganTNRY
X-Received: by 2002:a05:600c:4fd4:b0:499:83f1:398 with SMTP id 5b1f17b1804b1-49cdc59f62emr75854525e9.9.1788221530139;
        Mon, 31 Aug 2026 17:12:10 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be99255a5sm176454b3a.61.2026.08.31.17.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 17:12:09 -0700 (PDT)
Message-ID: <7c9a9ab5-4bf6-4c77-888b-0b077c06014f@suse.com>
Date: Tue, 1 Sep 2026 09:42:04 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove runtime tweakable feature sysfs interface
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <8a598d76555b5944d34bb08fa8dbeea28fc05db9.1787307129.git.wqu@suse.com>
 <20260831222009.GH325502@zen.localdomain>
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
In-Reply-To: <20260831222009.GH325502@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/1 07:50, Boris Burkov 写道:
> On Fri, Aug 21, 2026 at 07:42:10PM +0930, Qu Wenruo wrote:
>> There are 2 features that are marked runtime tweakable inside
>> /sys/fs/btrfs/features/
>>
>> - acl
>>    Which is a mount option, and it will not show up in
>>    /sys/fs/btrfs/<fsid>/features/ directory anyway.
>>
>> - extended_iref
>>    This feature can only be enabled, but not disabled at runtime.
>>    Furthermore it's already the default behavior since 3.12.
>>
>>    So it means this feature is always enabled and cannot be disabled for
>>    modern btrfs.
>>
>> So there is no need to maintain the ability to modify btrfs' runtime
>> features through sysfs.
>>
>> And furthermore, the existing btrfs_feature_attr_store() is race-prone,
>> it relies on fs_info->transaction_kthread, but our sysfs interfaces are
>> enabled before transaction_kthread.
>>
>> Meaning at mount time a sysfs write can trigger NULL pointer dereference
>> if the transaction_kthread is not yet initialized.
>> The opposite is also possible during unmount.
>>
>> Thankfully that race is not possible in the real world, as the only
>> supported feature is already enabled.
>>
>> But it also means we do not really need to keep the race-prone
>> infrastructure, so just remove it completely, and make the per-module
>> and per-mount features files to be completely read-only.
>>
>> Even with the sysfs tweakable features removed, we can still enable
>> extended_iref feature through ioctl.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> FYI, I have been gating some behaviors like dynamic/periodic reclaim on
> sysfs files not in features/ and I imagine there are some more out there
> (like bg_reclaim_threshold). That has two relevant implications:
> 
> - We do still do "runtime feature setting" not through ioctl/mount opt.
>    If we want to converge on only ioctl for that, I am open to it. Mount
>    options only end in tears in my experience (have to be very careful to
>    handle all remount scenarios as has played out with free space tree
>    and async discard at least).

Personally speaking I have no problem with the current sysfs interfaces 
at all.

It's more straightforward, less compatibility problems compared to mount 
options.

The only down side is the race with mount/unmount, but it's not a big 
deal as long as we're only modifying a single in-memory flag/value.

> 
> - Some features are not at whole fs granularity (like above
>    per-space-info features) so it doesn't make sense to have this generic
>    features/ mechanism anyway.
> 
> So with all that said, I support getting rid of this, but I apologize if
> my stuff makes life more complicated for our "what is enabled" model
> even with this patch.

I think the features interface itself is totally fine, just we were a 
little too optimistic on the features that can be enabled halfway.

Nowadays if we want to introduce some new features, we will be more 
cautious and push most of the enabling work into progs other than the 
kernel itself, and may not choose to allowing mixed old and new structures.

Thanks for the review,
Qu

> 
> Reviewed-by: Boris Burkov <boris@bur.io>
> 
>> ---
>>   fs/btrfs/sysfs.c | 121 ++---------------------------------------------
>>   1 file changed, 4 insertions(+), 117 deletions(-)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 39cb01ee441a..1f78bb1cf813 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -83,8 +83,7 @@ struct raid_kobject {
>>   #define BTRFS_FEAT_ATTR(_name, _feature_set, _feature_prefix, _feature_bit)  \
>>   static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
>>   	.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,			     \
>> -				      btrfs_feature_attr_show,		     \
>> -				      btrfs_feature_attr_store),	     \
>> +				      btrfs_feature_attr_show, NULL),	     \
>>   	.feature_set	= _feature_set,					     \
>>   	.feature_bit	= _feature_prefix ##_## _feature_bit,		     \
>>   }
>> @@ -130,132 +129,22 @@ static u64 get_features(struct btrfs_fs_info *fs_info,
>>   		return btrfs_super_incompat_flags(disk_super);
>>   }
>>   
>> -static void set_features(struct btrfs_fs_info *fs_info,
>> -			 enum btrfs_feature_set set, u64 features)
>> -{
>> -	struct btrfs_super_block *disk_super = fs_info->super_copy;
>> -	if (set == FEAT_COMPAT)
>> -		btrfs_set_super_compat_flags(disk_super, features);
>> -	else if (set == FEAT_COMPAT_RO)
>> -		btrfs_set_super_compat_ro_flags(disk_super, features);
>> -	else
>> -		btrfs_set_super_incompat_flags(disk_super, features);
>> -}
>> -
>> -static int can_modify_feature(struct btrfs_feature_attr *fa)
>> -{
>> -	int val = 0;
>> -	u64 set, clear;
>> -	switch (fa->feature_set) {
>> -	case FEAT_COMPAT:
>> -		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
>> -		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
>> -		break;
>> -	case FEAT_COMPAT_RO:
>> -		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
>> -		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
>> -		break;
>> -	case FEAT_INCOMPAT:
>> -		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
>> -		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
>> -		break;
>> -	default:
>> -		btrfs_warn(NULL, "sysfs: unknown feature set %d", fa->feature_set);
>> -		return 0;
>> -	}
>> -
>> -	if (set & fa->feature_bit)
>> -		val |= 1;
>> -	if (clear & fa->feature_bit)
>> -		val |= 2;
>> -
>> -	return val;
>> -}
>> -
>>   static ssize_t btrfs_feature_attr_show(struct kobject *kobj,
>>   				       struct kobj_attribute *a, char *buf)
>>   {
>>   	int val = 0;
>>   	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
>>   	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
>> +
>>   	if (fs_info) {
>>   		u64 features = get_features(fs_info, fa->feature_set);
>>   		if (features & fa->feature_bit)
>>   			val = 1;
>> -	} else
>> -		val = can_modify_feature(fa);
>> +	}
>>   
>>   	return sysfs_emit(buf, "%d\n", val);
>>   }
>>   
>> -static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
>> -					struct kobj_attribute *a,
>> -					const char *buf, size_t count)
>> -{
>> -	struct btrfs_fs_info *fs_info;
>> -	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
>> -	u64 features, set, clear;
>> -	unsigned long val;
>> -	int ret;
>> -
>> -	fs_info = to_fs_info(kobj);
>> -	if (!fs_info)
>> -		return -EPERM;
>> -
>> -	if (sb_rdonly(fs_info->sb))
>> -		return -EROFS;
>> -
>> -	ret = kstrtoul(skip_spaces(buf), 0, &val);
>> -	if (ret)
>> -		return ret;
>> -
>> -	if (fa->feature_set == FEAT_COMPAT) {
>> -		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
>> -		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
>> -	} else if (fa->feature_set == FEAT_COMPAT_RO) {
>> -		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
>> -		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
>> -	} else {
>> -		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
>> -		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
>> -	}
>> -
>> -	features = get_features(fs_info, fa->feature_set);
>> -
>> -	/* Nothing to do */
>> -	if ((val && (features & fa->feature_bit)) ||
>> -	    (!val && !(features & fa->feature_bit)))
>> -		return count;
>> -
>> -	if ((val && !(set & fa->feature_bit)) ||
>> -	    (!val && !(clear & fa->feature_bit))) {
>> -		btrfs_info(fs_info,
>> -			"%sabling feature %s on mounted fs is not supported.",
>> -			val ? "En" : "Dis", fa->kobj_attr.attr.name);
>> -		return -EPERM;
>> -	}
>> -
>> -	btrfs_info(fs_info, "%s %s feature flag",
>> -		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
>> -
>> -	spin_lock(&fs_info->super_lock);
>> -	features = get_features(fs_info, fa->feature_set);
>> -	if (val)
>> -		features |= fa->feature_bit;
>> -	else
>> -		features &= ~fa->feature_bit;
>> -	set_features(fs_info, fa->feature_set, features);
>> -	spin_unlock(&fs_info->super_lock);
>> -
>> -	/*
>> -	 * We don't want to do full transaction commit from inside sysfs
>> -	 */
>> -	set_bit(BTRFS_FS_NEED_TRANS_COMMIT, &fs_info->flags);
>> -	wake_up_process(fs_info->transaction_kthread);
>> -
>> -	return count;
>> -}
>> -
>>   static umode_t btrfs_feature_visible(struct kobject *kobj,
>>   				     struct attribute *attr, int unused)
>>   {
>> @@ -269,9 +158,7 @@ static umode_t btrfs_feature_visible(struct kobject *kobj,
>>   		fa = attr_to_btrfs_feature_attr(attr);
>>   		features = get_features(fs_info, fa->feature_set);
>>   
>> -		if (can_modify_feature(fa))
>> -			mode |= S_IWUSR;
>> -		else if (!(features & fa->feature_bit))
>> +		if (!(features & fa->feature_bit))
>>   			mode = 0;
>>   	}
>>   
>> -- 
>> 2.54.0
>>

