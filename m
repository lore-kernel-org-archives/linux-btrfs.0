Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C039F17D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775732947; cv=none; b=Czt1TElLGbidu59+NgtgWB7R6URkPMdOiSiMMb6amfbNUFjJBefF3gTbH3jN2PH3LIYijoFchbLMyGto+gWqmcRXmmsB0W4ouXveYL3etddg9lFelghPeymM8II77MtibMskjvE+VaBGhnQ5EcPF8A21YSU978leBCI2p/AuUC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775732947; c=relaxed/simple;
	bh=5/E1j3ux5zo837Pqo8L4skcXdgovcUaRsWyXb84fpvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aNnINCJfnsISlOq8wR7RvWUI/3Q/TuF0FEHP1H6dTLuMmLNcm4qc9sHQHyaEcs+Ma1zO08seJWXRvDNYXd2JDE3CPPX/WNLbTQZO5PZfJNhlJsImepX++HXtusrx1VESoBvm3zHDNCfjSrxhsAYIH0v4NSGjB5dctWtk5YNKsiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lz471UhR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lz471UhR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso5847125e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 04:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775732944; x=1776337744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LB3EAU3YIr4em+3vC69t2mbR7Xfx2Dc55dPFajDFhs4=;
        b=Lz471UhRuBx3ve5KBF3p+TTwdbI2/hzVE/NG9znAGB71ix2MvOum0WWW+himNAt3Ta
         b1XKuc7rND9+rdC3ybNIOM3a2gRViTSCUlNER7FMYOykU8UiRUON6M7oeoaV242TlD5m
         6aazYVEq2c/5SeGdehsABLoM0PN88BDtaMNb3kn51fI7MuwkQ8P/VJTVpmMgTn5bFyqY
         CsjPYlJvqqVBt2J+DMOszWLjzbVrxfNR7eyshLimv7koVO3Ne5uaxKfO80DU/8AY6MVq
         vSBGYGHE+Bv8QqNstlBwFF5/sPPEfc4hwhjlsF7j+Cjtz+RJwfZ2pbC8lZIVvjIkBdZR
         s7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775732944; x=1776337744;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LB3EAU3YIr4em+3vC69t2mbR7Xfx2Dc55dPFajDFhs4=;
        b=D7nUzZNQ0A2B7fmOMdHiZVA7POogMC+zGAx9ive01YHVPixMBFL4UsHX1DuRoIdZxD
         HhWTDy68LMRjuESvfBSZGKZwlpCOn8xG5tpArYi3MEgJrezYm31DCY8gwXVWRau7CO5H
         34rGSuznQj4V7Ofs61Tn732wo60NzAGL7xh96oeYXpQIHJ3jwRodQLV2EjTgOtf3seXa
         mji5xtXoH2oK0pLk113N91aqa8zn6e5I4F2FtA+IIOr2t8CUkJ5odbvpJUKUYkYyLp2Y
         Bpo9rMCG2eB3yNB/GLobL9LxT2eXoFJdf6jWHyQgpUdiUcMtiCJ9uxkyrpJwsi3Zw9NM
         Kgtg==
X-Forwarded-Encrypted: i=1; AJvYcCWnjYcy6sjM7zvg7SyyXtymhs/YkoQWd2hzKbQOcBaTH+Dh5fjWH7zknpdg6S8nYb/9noAi+zJZ/fiWKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfC1/QmnBv/auaBy+UrXIAMvEsf5ku9Vqcs7tNx4cAIzPMdU4i
	7f0+FFWOvtLjl/hI2iF+Mt5/8rxjmJmBZqmC92NGAFTJLv++vxRuUd6QZs8KOjYVN0Zb+XBbpaB
	WsZlaYT8=
X-Gm-Gg: AeBDieskI8E1kFvvzOuOg0IELYaP93B+M/q9MygXq96Du+zFE/h/JxN6SFZUaQ3sSTK
	OrYx1aNBvTEe3CyvIXq0IsydGimr3gN5B5gqUXcpSsVaklIe0pbE0eb7+ubrroG+bH2r73g4ehs
	GeWY7vWBJ9RL6BG9oCxR3jJZWQ1RVQYwJwPULzXJK20zydz4dKuGnKFAMp3zyTEZ43aHfqqbG6n
	HtnYuNluNefqCYlE7R832yaxHhXu8BQ4LGGaZg8w3UzLWF6MXXopRtTOcwZH4lLCB/elvXPYxvn
	VpTf2H/PHzjW+MaXPyW2vylbM07gUznD/lzstS7SAS34W6RnPk2faO0zpmBNxdah1tLo5P3xV4d
	GGiuFyJKx60hLK8YdHOprERGbv6aJyxjK+Qz4/BJy9XCBPkugWK3lwEayFqmAe9JOIMdlUW2aU3
	o9hP5CJwOqQMvQjOSo63VF4VWAJFkQGQY3dnGVRXEnvdRV8MGy/Gz7PC27rj3oSA==
X-Received: by 2002:a05:600c:1396:b0:486:fb0b:ad79 with SMTP id 5b1f17b1804b1-488997d10ffmr341421265e9.20.1775732944243;
        Thu, 09 Apr 2026 04:09:04 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3aaeesm25374801b3a.13.2026.04.09.04.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 04:09:03 -0700 (PDT)
Message-ID: <b0a7acec-73ce-4cc2-aecd-d0f686a36e4d@suse.com>
Date: Thu, 9 Apr 2026 20:38:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 boris@bur.io
References: <20260408174642.136962-1-mark@harmstone.com>
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
In-Reply-To: <20260408174642.136962-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/9 03:16, Mark Harmstone 写道:
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.

After some more discussion, now I understand why you want an 
unprivileged ioctl instead of splitting the workload into fiemap + csum 
tree search ioctl.

You want to do extra permission checks, which is impossible for the csum 
tree search ioctl.

And if we allow unprivileged csum tree search, it will expose all the 
data checksum to an attacker.
The csum itself is not enough to re-construct the plaintext even for the 
weakest CRC32C.

But it is still enough info to know other aspects of some data, e.g. if 
some blocks are all zero, or some two blocks are (possibly) the same etc.

Not sure if you want to include some short words on this design decision 
though.

> 
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.
> 
> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
> the precomputed hash of the zero sector.

Well, for mkfs it's going to skip the range as a hole, which is even 
faster than using any precalculated csum.

Although keeping the ZEROED flag may be useful for future users, I would 
not mind to keep this flag.

> Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NO_CSUMS.
> 
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace.

Consdiering we're already treating prealloc/hole with a dedicated ZEROED 
flag, just to keep things consistent, it may be better to provide a 
ENCODED flag, to indicate the range is either compressed or encrypted 
for the incoming encyrption feature.

We still don't provide the csum, but just let the user space to know why.

>   
> +#define GET_CSUMS_BUF_MAX	(16 * 1024 * 1024)

SZ_16M.

[...]
>   long btrfs_ioctl(struct file *file, unsigned int
>   		cmd, unsigned long arg)
>   {
> @@ -5294,6 +5622,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>   #endif
>   	case BTRFS_IOC_SUBVOL_SYNC_WAIT:
>   		return btrfs_ioctl_subvol_sync(fs_info, argp);
> +	case BTRFS_IOC_GET_CSUMS:
> +		return btrfs_ioctl_get_csums(file, argp);
>   #ifdef CONFIG_BTRFS_EXPERIMENTAL
>   	case BTRFS_IOC_SHUTDOWN:
>   		return btrfs_ioctl_shutdown(fs_info, arg);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..d079e8b67fd740 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,25 @@ enum btrfs_err_code {
>   	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>   };
>   
> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	0
> +#define BTRFS_GET_CSUMS_ZEROED		1
> +#define BTRFS_GET_CSUMS_NO_CSUMS	2
> +
> +struct btrfs_ioctl_get_csums_entry {
> +	__u64 offset;		/* file offset of this range */
> +	__u64 length;		/* length in bytes */
> +	__u32 type;		/* BTRFS_GET_CSUMS_* type */
> +	__u32 reserved;		/* padding, must be 0 */
> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +	__u64 offset;		/* in/out: file offset */
> +	__u64 length;		/* in/out: range length */
> +	__u64 buf_size;		/* in/out: buffer capacity / bytes written */
> +	__u8 buf[];		/* out: entries + csum data */

Maybe you want to push more explanation on the output buffer format.

The resulted buffer would be something like the following example:

Input:

  inode has [0, 4K) hole, [4K, 12K) data, isize 12K.

  args.offset = 0
  args.length = 1M
  args.buf_size = 1M

Output:

  args.offset = 0
  args.length = 1M
  args.buf_size = buf_size_out
  buf:

  | [0, 4K) ZEROED | [4K, 12K) HAS_CSUM | CSUM | [12K, 1M) ZEROED |
  |<------------------------ buf_size_out ----------------------->|

As it takes me some time to understand the output buffer format from the 
code, which is different from my initial impression.



Another thing is, it may be better to add a flag/version member to 
btrfs_ioctl_get_csums_args.

If we need to add extra flags to entry->type, or utilize the reserved 
entry padding for something, or even introduce some new behavior to the 
output buffer format, we must have a way to tell the end users.

Otherwise looks good to me.

Thanks,
Qu
