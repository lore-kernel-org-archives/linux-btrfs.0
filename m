Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718DD37E5FE
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786832075; cv=none; b=aOByz1QalM99BcUJfmamjGVSUlx0LKPoe5iyb5D1IympnWcB1nCvlyLlTmEvwMAMHE38mOPoTTOFPqz1CrqV+W2oSQkSvHsMdhvYnKbwRypwdNScRLI0I+1LUahABK+wjIHkRv8U17+ClkEJi/TtgNsmo72n2FezFhYtHvaXryU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786832075; c=relaxed/simple;
	bh=oZ4oCwVC/BFzaEM+skmk92FgnswjRK5XhgBLqJzeLcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aDEHvp4TG+DoFgiNvUmMXllszzBeSZrGHs/kndtUpiZeXbWRy/b5o1fv/LCLVP+0Wd5OAGg2hxKwTNSNlk8Lla+haJyAnxDtNJTnYhaf+ek/y4+N1MFnwOuZ++yIiz59OL44WzlQxS9OqLiaOLHZXifX5MVwb3N1ii8zwXIYiyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CqGvC0UG; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CqGvC0UG"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso15742105e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 15:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786832072; x=1787436872; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AN1qC+lu6UaXd8pXziAeuMVzPx189lShvJn/q+qxOFM=;
        b=CqGvC0UGx8QA8HWWZ0xHJYFYgYMxKpYzjzHxD5JcRo23kXNTTOQw6CihlnTxn5D3zz
         xh0KwndLNVI/uasv3AQecEl7RDI1bSzgmvBsdZQxosjxOuGYb/LxgkmcpY8tVysoPcPq
         tm62c9nj+/JLLdZH5flHuHraZheEJfQVM2jEeQ/Ay7+FgY/lRZiyg+78lAqd8ePNk7D1
         JM5G5gFE2tEI3/9lGh/Hsr/gI9h+NRFniwknf6nN9rcp1nZ2lGezE1Jm+1JXRqR7OdiH
         8KWID9kLZwUFlZ5A2w8G9QGIT9A3hlgJaa2tBtWQraIxQOVo3BVrhAT3hYuibA8QfNMV
         +ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786832072; x=1787436872;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AN1qC+lu6UaXd8pXziAeuMVzPx189lShvJn/q+qxOFM=;
        b=DV1s0Fp5X+Z6eFCKqrdgsxwWCd0Y5yM0PpZADOZSWiWz8XYrJI1Vg98oRyPGMWGkyW
         CTavyYhgXOQuz6wQHskIdK3+Z1kzXoQ1jEdxZxB1VeYUrsjU2hMf5iaRamch3ILjB6zc
         5WkP/RVZoGCNI69yT46kTnHsOddnIaRPqyG3wrIiFJ2k4qW0J4/dN8VoBE5JQh2mVD/+
         EcitYleCJZUf6n/8lgOEbxgHcn8WPPYQk5k2n0UEn5dNxdEC4xzAgLRwBPcu7C/zkqYK
         9y4W6c0yuzVmBP5GxRq0SUT7ntkfTzs9aOIqRX9igucyzoYGKf6UVsXqzs1Ac/TpiVRl
         TWaA==
X-Forwarded-Encrypted: i=1; AHgh+RqK18091AwfqZheRTswgKoFaboYKRCBLjgyUywGIypFHizJ96tx/FzW2uBAYRe+1VLxlrBGJ7zgkOzcwA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/qRb9DSAetXgWny1NSFrLKbV1kaDlHQWnEeL/lwyBfCQobaQ+
	eOlouCaMHUSa+lC1gsEVh2hscSTI5OXfHEsg+DbBHGrbI3Y26Ef8kML6Np3M+4AS8jM=
X-Gm-Gg: AR+sD12sATm2Zg6QQ9F58wvBvMA+kPQ2Nt6Fd/T2IwqN607+X5PSvb7BXO5C70BkA+r
	c+dglt3dHwU+e7bb6xVZtRexLGZCcHjCPhsHGQRlMAhNORiR4HBFUDsCFShGZiEDKKU/m9XhKGW
	htsJBBlkWmiUuRhmjwidqg9luCsDN391g4erSoZEQmqYxelkN53pS/QeGedwBhwq2496yi/UU29
	sed+PNEaGKpOQfZP4g15LLH0LsQB2gcwo3a1OJYYpn54s5tEgplQ7zueC2thoqnzG4vudC8oCB1
	2evzlMW6BFkSYdoLdqFzIXJw1MqM2iiyLDXC1EF0L5uWjd93JZSbRY2Hbp5MMXLd+ORl4WbCjeS
	JOeY3XqoEFXMTtbrnV0nEOxv6UgTt6r3Lur1lTpRagwBCilosq+mwSoLHSjEeLyzJ7Wctg5Xno1
	fhcISC7UDrLmzxjnxT8R5ORiyCprhnHP0sI37ZEx581G1q02+kIftcfeOD43JqYdMo
X-Received: by 2002:a05:600c:1c21:b0:499:90f3:13b8 with SMTP id 5b1f17b1804b1-49990f315e9mr74686435e9.12.1786832071756;
        Sat, 15 Aug 2026 15:14:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea2fcfb8sm18829339eec.21.2026.08.15.15.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 15:14:30 -0700 (PDT)
Message-ID: <33963533-344c-4f52-8ef7-4c10979f3153@suse.com>
Date: Sun, 16 Aug 2026 07:44:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: allow idmapped DEFRAG ioctls
To: Tao Cui <cui.tao@linux.dev>, clm@fb.com, dsterba@suse.com,
 sforshee@kernel.org
Cc: josef@toxicpanda.com, brauner@kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
References: <20260815132259.3935817-1-cui.tao@linux.dev>
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
In-Reply-To: <20260815132259.3935817-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/15 22:52, Tao Cui 写道:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> btrfs_ioctl_defrag() checks MAY_WRITE against nop_mnt_idmap, so on an
> idmapped mount the owner comparison uses the caller's fsuid against the
> raw on-disk uid and the ioctl fails with -EPERM even for the file's
> owner.  Pass the mount idmap down so defrag works on idmapped mounts.
> 
> The check, added in 616d374efa23 ("btrfs: allow defrag on a file opened
> read-only that has rw permissions"), is not a privilege gate.  It only
> tests whether the file could have been opened for writing, and a user
> who owns the file on the idmapped mount can already open it O_RDWR,
> write() to it or fallocate() it.  Defragmenting a regular file only
> rearranges the caller's own extents; there is nothing it can rewrite
> that the caller could not rewrite anyway.  Whole-subvolume defrag on a
> directory keeps its capable(CAP_SYS_ADMIN) requirement, and the
> !capable() guard around this check is left as is.
> 
> FIDEDUPERANGE already works this way for unprivileged callers:
> may_dedupe_file() in fs/remap_range.c compares the inode owner through
> file_mnt_idmap(file) and falls back to inode_permission() with the same
> idmap, and dedupe can rewrite one file's extents from another file's
> contents, which is a stronger operation than defrag.
> 
> On regular mounts file_mnt_idmap() is nop_mnt_idmap and nothing
> changes.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
> v2: rewrite the commit message to explain why defrag is safe for
> idmapped users (Seth Forshee); the code is unchanged.
> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 72bc9d4f7708..607329dedd50 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2458,7 +2458,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>   		 * running and allows defrag on files open in read-only mode.
>   		 */
>   		if (!capable(CAP_SYS_ADMIN) &&
> -		    inode_permission(&nop_mnt_idmap, inode, MAY_WRITE)) {
> +		    inode_permission(file_mnt_idmap(file), inode, MAY_WRITE)) {
>   			ret = -EPERM;
>   			goto out;
>   		}

