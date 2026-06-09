Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86210194AE6
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780995753; cv=none; b=mZQ0ZGvpJyycDLuREYf+7Q+x093Y9XBeDVc+Y3p6Ai9dRJAp12VGl2qWuiAaBgfP53arlRLNH9rcwJwwTo8+s27UHKHQ9P00W9qj2ifuNqV+8pgGlJplHp8BlrIO/bvnsMuMDbFki0GTTsCjc0dWhsfSz0wVm50/7s7ppbxv/Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780995753; c=relaxed/simple;
	bh=N4NbdoySNZjLzH8tepn7w4jBfqj3QGbYD423kp1yErg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q38pkRhvv6oFS8ElRFyH5+1U4pojZlS4QTb5m2I6pR633+iH6m9TQgkXlLHDUdgUV8Z6v1ctIISy3D8MOdQghYRhY/IrIln6nivCWuV+Xh7xhchzjXmzZrjohiW5JM+yss02Dxd32d8QBqhw8VlwkBCuHgIrbDQN+OJP4rEbqfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UunnujJR; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UunnujJR"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bef1e6423e7so575208866b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 02:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780995751; x=1781600551; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7AqoHxFyJLoJVvHZNfKBCUHXKEymvePs3sxMFGKOzO8=;
        b=UunnujJRHn4wsfsKOchViIDme+ZrwRxC3TYfRGHnlpS7MuWxtAoIkt7T25y85CgNKD
         jG8/VjkOB5UBeMKFA2QOaV0C0lSv58vBfRlGnNm1meBOpbFaGo4LR/2RkQFtuG35mT9Y
         USytXlvOODlh29aVvknOd1CZfRjiiSYsahn48gGlJlZ6xiJ+N4XxWcIoyiUo3O8SaD7R
         dHHNlbGhZ43YBvuCsQBDyCOJfCsdd/0JlwyAcSlhDcsCgk3Ejk216B9/Y2Zm8PMyNOfO
         TKKBEhFUb9BdOSJ9My7WXaxd7hlsvyBiQjWqBLCYEARpDh5qBT1bSkK5H0BPiSylTHwW
         iVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780995751; x=1781600551;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AqoHxFyJLoJVvHZNfKBCUHXKEymvePs3sxMFGKOzO8=;
        b=mVbSeq8uPyF3K9nTJz0tv4Gddfv5aS3GQOVl3dBvXKdXZZFU30pfyX9di+73am5qdi
         rIwaM6d3YdnzY/f3rTIwGDOKLh/ZMI8UkdR1f79hPoqJSl6Z8QnzXsuESNoTWgABxpun
         vh3lrcQUimNPvo1Bk2m82HocfKlfxVWwu1HYVSFVX1akivog/JapFzswLoywp4IDIh4P
         jMk0D82PQQQme+K0UfwGFLrpFmRezofaw9kDeYFFIy8W+3HHG8Hl5PXrxO1ykDB0HuVT
         xFprABYUTBpcqHmBm7W0d++L4nml/YjFeuR6HL4SoOYwvPxgcPIkd08SLS7cOiJ2ZABk
         vcBQ==
X-Forwarded-Encrypted: i=1; AFNElJ98AMA96IZGPO27lItW9Lo4x/ycuu5Rp6FhoEBZ6pgf+DlS8O57P+eAKzayNH9e441R0IbxTBxmiVnO7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbnqFyY+J4vkooenz0ryipzPLxna4+Q4HFqt971aqMoMR3YiWd
	cKxcgyWIFAF9DqegV7krM35DAud/iA3Tkp04TxWgjtBx6AfNdz+iVmKoaHAutz/eAYQ=
X-Gm-Gg: Acq92OG62SXNop756zgHQ0Z7vAG92YMAJMrWhxiLI70KTKk+YSpATrDGv7rF3CLNFdZ
	CFwvl9qxeMeCRgEBwVE/DTBSNm+H5IrdgMyHnuaI4sYRMvYg8rrlwb49QNlE0o3RI4/z9pav4VJ
	WvHuU4oVsQZR6/8xXR6wcm3F5nFkDsuJNjzz+bW+XGxIz8G1VqIyqhqI4oHir52oKldxWMpguRp
	lSt3gMe0N461HcVevS8uffsgdhqGEIaPN5yzt3Mn83NVdlEXPUdaW/cOvQkfm7K7yU+KKxspc0u
	JZJJ2R19C2sl/Z0n21R2+byi5LyyRAJjSx+W0oq0WNEA7+vikTIu0T8vDTeGSEUIWYnb0kWg2ae
	EkXew5TXsgYsxqhMPz6KKTagOvvfvF0BKVFwtqhfWVjPNBIxnsmpL/jnshVB2CHzVxI0eirX4nZ
	9lbXCdYHFJkxrMfZU/P5ONPcxOWJpnrzU/tlS8AtAk1qgBAN3uPBt9zP7d20q32QNzH/ukSpJ8h
	T+P0NqkXwqxdboyZgLahY//RNsRgFZ2ko2XuUx5zpkZMqDu1xT5Pctxwg==
X-Received: by 2002:a17:906:6296:b0:bed:17a8:4ca8 with SMTP id a640c23a62f3a-bf3737eeeddmr830443466b.32.1780995750473;
        Tue, 09 Jun 2026 02:02:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828daf76sm21028552b3a.42.2026.06.09.02.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 02:02:29 -0700 (PDT)
Message-ID: <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>
Date: Tue, 9 Jun 2026 18:32:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH btrfs] btrfs: reject free space cache with more entries
 than pages
To: Xiang Mei <xmei5@asu.edu>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@redhat.com>, Weiming Shi <bestswngs@gmail.com>
References: <20260609081135.2972081-1-xmei5@asu.edu>
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
In-Reply-To: <20260609081135.2972081-1-xmei5@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/9 17:41, Xiang Mei 写道:
> __load_free_space_cache() reads num_entries/num_bitmaps from the on-disk
> struct btrfs_free_space_header, which the tree-checker does not validate.
> The load loops consume that many records, remapping each exhausted page via
> io_ctl_check_crc() -> io_ctl_map_page() (io_ctl->pages[io_ctl->index++]).
> The write path bounds this index (io_ctl_add_entry()/io_ctl_add_bitmap()
> check io_ctl->index >= io_ctl->num_pages before mapping), but the read path
> does not, so a crafted header reads past the kzalloc'd pages[] array:
> 
>    BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc
>    Read of size 8 at addr ffff88800f948780 by task kworker/u8:3/58
>    ...
>     io_ctl_check_crc
>     __load_free_space_cache
>     load_free_space_cache
>     caching_thread
>     btrfs_work_helper
>     ...
>

This comment applies to all involved poeple, not only you but also 
Weiming, who I guess are all from asu.edu, that you should provide more 
info about the context.

Not just a simple calltrace makes little sense.

Since you have a reproducer, you should provide either the 
reproducer/image (if small enough), or provide a more detailed analyze 
of the corruption.

In your case, I know it's free space cache thus no easy dump, but you 
should still give an example of the corruption.


I'm not saying your reports provides no value, at least they are indeed 
going to enhance some error handling.

But your and Weiming's reports seldomly explain the full picture, just 
some random "crafted image", if you have the image, dump the content 
into the commit message.

The lack of transparency make it harder to review, especially hard to 
determine if this is really the earliest point that we can detect an 
index that overflows the page number.

> Bound io_ctl->index in io_ctl_check_crc() too. An over-long stream is then
> treated as a corrupt cache, which the caller drops and rebuilds from the
> extent tree, so no valid cache is rejected.
> 
> Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>   fs/btrfs/free-space-cache.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index ab22e4f9ffdd..bbc4db7fe74b 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
>   	u32 crc = ~(u32)0;
>   	unsigned offset = 0;
>   
> +	if (index >= io_ctl->num_pages)
> +		return -EIO;
> +
>   	if (index == 0)
>   		offset = sizeof(u32) * io_ctl->num_pages;
>   

