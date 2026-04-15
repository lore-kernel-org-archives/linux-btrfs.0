Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5B242A80
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 00:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776212998; cv=none; b=U1oZu8wdkfNKS/RknARufaZ5xOB0X0iR0uNHoQMsFVeHLiPeK7yzPlyDKm0aIp94Pf6q68i8069n5CIGd/EjaVkLmeFOeqq6A9HpTq+Mx7KqAG2ack2PwWWCNQ1dsbapGc2pAEaRxQngnDdwmiyxBZ7Ftwbstq2+Nt1+94TV1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776212998; c=relaxed/simple;
	bh=H0WF1U96X7EyavIRN2eC89DY+a2EzqKQpPgKOajsPXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kwno/v6IPb2RnpW6ePyHgPfjwAVDNk+hZzAb5cSiijk61y+nrnIaVrKxM2oI9QogI/JMD3PmVM1rSm5RGzPfXOV/TpqDLzWQyacj1LzYdTfh28znGEsTxosj6+sgMPdM1lOKqB5u7D44Erxo5fidxcu9Ms9eXgmI7n84kW7zOFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JFwASlcs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JFwASlcs"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483487335c2so68287075e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 17:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776212995; x=1776817795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=inR8HhOwMbEjfhCtXTRwuUD9Vy4DSNE5sYGB+WOvMe0=;
        b=JFwASlcsv6E8EjYQ3UGhTGKPEwX7/EXl0PmOamTwnlAgH/sYjoxZZ6AAlRcJp3+9Oi
         mQ7ukZnWcbonx50AukkUNfyPSq59apBvUFV72gb4Ja+6SvHqFZfRrj0p1f9N5A61niHT
         1zTHAfITQjjTAOq/c+dFBquTashLZ/El7EyLS73BgAE6qsHZupH1wkKUBNVCCrEQa0Kv
         EZhEOnregoj1MvSFUG0epez5tzoTsT3oJpRx0GuCPPsbyTSBFz6l4WjBLDA1H0wJtaSW
         aMoiHqMUYgPAYid3Jd/odPHon4WHSVb97ZAxtnP8np7615MlWjrcgbWRjJRnlzb9OQyg
         w/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776212995; x=1776817795;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inR8HhOwMbEjfhCtXTRwuUD9Vy4DSNE5sYGB+WOvMe0=;
        b=SX6dYiP1Fo/pKsf3My+MINSF87ct+DRq4t+1ZkZsTpLhd1Vxz//bmkYzqUYUJYTBWF
         Q4TlxWFvs/C08R5rRFa9AWqA6KCaczp3EkYdGN2iZXqQlU5KuUgGFJFCnGYbMKyMNrkO
         7dHIlywb7HgU/Tlowe1yzcWoDMQq0AfOeL8QE712sJaKlaJrowliB3tEV1GkWRnLJI3n
         pBfgCZohKkMrv/s1K7B/Ly9vJk+h7sSPMdk5T0YbnQAGforw1KyT6K/OcjTLRx2exhTq
         lhiXcf1AaS40uJkG39Zk+D0VO50bwhbGZPJM48xUL1m8arBdrKIHGt+SikNPw8frez2F
         edqw==
X-Forwarded-Encrypted: i=1; AFNElJ87PcTQASjt0jL3BvbsugwuiFBqGZz9zvKJuHQHUpJWcwfziDjz7cPUY1na0pqMiD0pbk9XfPx0yh6+yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiAxRMG+PJvCk+0Qbourq2JA6TiIlPe2KaQeo5GVRCQHnVOpe1
	U0F4zfMEVnCjKz7YZrcKd1oAVppyz5DSGaOG30eTGVcytXPnuQdsPKC4L2LfZieWEl4=
X-Gm-Gg: AeBDievhLGTQC8yLzQF9YqSm0Wg+Jmnjo8vc3BoslaRIgABRMA5GQ2IlOExyMTfWn3W
	Wkhpr28s+Pi6u38a5EtfA2WY29tAADB+q2199XeofS/YJaRP9UqBW2gQnST2+1hMeyBTdeJsKEd
	7JHj2evHRc1Y9+nCSsal3zXND+TrULq+m4oT3S6ZDtOE+HRicsrShi2ZSziPtZ5ZbhUAa6+2fuI
	ACqfwFjefXOAHmQT7rSN082FkZoLaSR0LTPPCLnHp7mckir8KVi964+Ybuo7OZasx8RwlBFBYGp
	HCe86NOn6YY2szb9cMNTVCR6keCCSEVWtWpUdv/m5Q84xrMVqQdJOUH2dX+Ic3Fyvx9HocFBE4O
	kYuY3hYIc55YmIgK6g/xzDoHMKO7lZStJfieUCSDPuMK/z9j5MR7/YMtJAz3DFkrY6Ps2Cj38HQ
	Jc+Ifg+0iJ/pxlyLrJJcAkcCrTPOJsT/0kEFkJcboz2eVsIKgg2Ykf1bXUsNpaFQ==
X-Received: by 2002:a05:600c:3546:b0:488:a82f:bbb0 with SMTP id 5b1f17b1804b1-488d6889a3fmr268073365e9.27.1776212994709;
        Tue, 14 Apr 2026 17:29:54 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6702f936sm214208b3a.6.2026.04.14.17.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 17:29:53 -0700 (PDT)
Message-ID: <c095e782-8755-491f-b49a-d69ff387b8c2@suse.com>
Date: Wed, 15 Apr 2026 09:59:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: convert ioctl handlers to AUTO_KFREE
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260414211231.2890720-1-dsterba@suse.com>
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
In-Reply-To: <20260414211231.2890720-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/15 06:42, David Sterba 写道:
> Many ioctl handlers are suitable for the AUTO_KFREE conversions as the
> data are temporary and short lived. The conversions are trivial or the
> collateral changes are straightforward.
> 
> A kfree() preceding mnt_drop_write_file() is slightly more efficient but
> in the reverse order (i.e. the automatic kfree) does not cause any
> significant change as the write drop does only a few simple operations.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ioctl.c | 289 +++++++++++++++++------------------------------
>   1 file changed, 104 insertions(+), 185 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b2e447f5005c16..17f72b3a1c43d6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -707,7 +707,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>   {
>   	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
>   	struct inode *inode;
> -	struct btrfs_pending_snapshot *pending_snapshot;
> +	struct btrfs_pending_snapshot AUTO_KFREE(pending_snapshot);

Checkpatch is reporting warnings about it;

WARNING:FUNCTION_ARGUMENTS: function definition argument 
'pending_snapshot' should also have an identifier name

It doesn't recognize the expanded macro here.

Not sure if the plain __free() method will solve the false alerts.


>   	unsigned int trans_num_items;
>   	struct btrfs_trans_handle *trans;
>   	struct btrfs_block_rsv *block_rsv;
> @@ -816,7 +816,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>   		free_anon_bdev(pending_snapshot->anon_dev);
>   	kfree(pending_snapshot->root_item);
>   	btrfs_free_path(pending_snapshot->path);
> -	kfree(pending_snapshot);
>   
>   	return ret;
>   }
> @@ -961,7 +960,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>   	u64 new_size;
>   	u64 old_size;
>   	u64 devid = 1;
> -	struct btrfs_ioctl_vol_args *vol_args;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);

@vol_args is later called with memdup_user(), which can return error 
pointers, and unfortunately kfree() doesn't have any special checks on 
error pointer.

[...]
>   static noinline int btrfs_ioctl_subvol_getflags(struct btrfs_inode *inode,
> @@ -1865,7 +1846,7 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
>   static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
>   					   void __user *argp)
>   {
> -	struct btrfs_ioctl_ino_lookup_args *args;
> +	struct btrfs_ioctl_ino_lookup_args AUTO_KFREE(args);
>   	int ret = 0;
>   
>   	args = memdup_user(argp, sizeof(*args));

The same error pointer on error cases.

Unfortunately there are too many memdup_user() callers, and they all 
share the same problem.

> @@ -1895,10 +1876,9 @@ static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
>   
>   out:
>   	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
> -		ret = -EFAULT;
> +		return -EFAULT;
>   
> -	kfree(args);
> -	return ret;
> +	return 0;

The original error is now discarded.

Thanks,
Qu

