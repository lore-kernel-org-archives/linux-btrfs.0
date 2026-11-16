Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863730;
	b=pLipcLq8gZROxezmd92WM+LZnl7KHKv9Bh1dFvkhQNzKdzOpys5MGcPbNjAo1tcYvoRZ
	 gfGb0RATBDN9UHaLvbWJXrla5VOAO7SezqBR3z0JWTFpAZXxmtdpkhg7E9kpZlDv+QN1S
	 Pu0MHNGL1SDRVzBdycyLf5Qz99nJJy73VfPsiIERkxRj9Rk2SGUaDR6QE2FLC24wt33Vp
	 wqY3VbwwYqUkgx0LrelWl/oMDIZNOPwAbt+QKb3BRyf4E9IXOaROpg3FpMjvdp0UBVa/V
	 wjTki5AHiQAJFKbn++lIBUw9s0kQexwc3olI8GjNFIvDt3RX5keXifOYH7/vm/JUaTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863730;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zoAUVPf06VCysOb/jRRDvQGzUEvUDSjqPOdb2VlZQAc=;
	b=S1OqOdZ2dtFP0tOCpbP6xacx/gyNAlX85tFbXDbAdCyinfM5QimIky60Jliy5woZZ86+
	 EweJBYN9xsZKlcPEUa2VLX1LJ+iJ1CGTqfY3VenVgDXNyAbNe+oqx0qRPi5X6vEhveHiC
	 yK6+xkZXNBz3SvBGZipMbrdmrmHEccc839cbXomU2TWeICwG1cJZyM592VkiYp4yN7MPy
	 vtWvpzWi4HlxEBmf5JfUtbURgwECX1OsiKviK4kSXKgAgFD3lQ02IGpQIyJiosHbostiX
	 O1UxfWUWfHhCurHsCt7Djo21lMKVfp76gXBgH8Kq2R4OqafzPpmjpdRFm9p1+Izr4yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Z2HBy3th;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA852606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA852606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Z2HBy3th
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c45551fa84eso750533566b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 13:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794863728; x=1795468528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zoAUVPf06VCysOb/jRRDvQGzUEvUDSjqPOdb2VlZQAc=;
        b=Z2HBy3thgc2ZdlNgGP4UXfvCa5OuMzmZ1IhwaqmrOqYoxqGvbecDVD0JD63r5XMWwv
         4daia0tLRT9NSioQx0fu6m0tjvq6APs7U2TdJgY48LRBjFtu+E8GOYjd1lbpI1ZYwtcx
         veBnqcW5zFOXKdRMY8zcnV+Ku0oHsr9a/uyem7uu1weKfWHmBeQJWZd0ZOdXGKI69Ixd
         +/BB5W8CafVDFA/mMyOd4aejeR5zcUHa2V+bU1u3OeLbLU6FvApiGiuNYykVoR0ODHzz
         +sN0a99sRp6kwlY+iYqbUrvIwNowXVku8tLupYYl7jY7LrKS5xxyampCd9pREMAPoqRv
         HzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794863728; x=1795468528;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zoAUVPf06VCysOb/jRRDvQGzUEvUDSjqPOdb2VlZQAc=;
        b=fqND/93Bg+NInTHLUX1O/NigE9mHjKdyeamBDurbIl542YU0mZxUiVFwkhcrtlM0ml
         AUSUEsjz79nOZ3UvebPGbltcy3mt4gnOHlBDFDk8rVSOKkDTgOO6Tfz5L5uiuO8rlDIW
         amMHWeQ8nHl90biV5hBGWBcMFz/XllIMbYtgdExvL9EXRLVc+jg1xP/U3OW/TG7pUv5a
         0fY2BrgQ1GqBdXSmx1rsjtqhatytRnSUFFr1ntLy+4PmzLaEW7X7SfBs/BWjYJ6gmwvJ
         4c3Tl8zv9C1n16e0+Rb6NnPO0q9HftJmAX2nFrRXDypgT7DQ06KbjS2ng90AiKXgdQBs
         EpTQ==
X-Forwarded-Encrypted: i=1; AL+hErFUmeVJ2AVwPsG9V6JR3i3fxj+DnKhoH8484yE1W8n7iUhAPiOlENpqPGHhl0DlTna9PCaCVuv881xPpg==@vger.kernel.org
X-Gm-Message-State: APuU4Z8yssCw3AJM1En8OoCVIcgNILUH+TxwFkeZuNoJrh0k6qzebKWf
	sDW4kfaSiDYgKnkNl8a3OhWthlSG1NMSR3tF8rd+FS4TTojU9DU4ha26JRGd9BN+2c41bj/g8dV
	Ok0DSQ9yytg==
X-Gm-Gg: AYBFou0Xdh3W/W51B1/oi+uqzK7aeF2gMPfiGbRfn34cVfGzSley2hdCixMlotq+tfK
	KyxFDjGzirry22UKa8TVO6lfcbtSzpS3arBbSWduLAJlT2B2CsmznKVlH2NV1GQDOfYZ2BD2pyB
	YGUuNAbHgz0ebDUTAG7yIaL05snmwcMr/Z4K5qOePT6LGJKgg891Gxdh5x2/BiDabRfxPBqEd4S
	Vr57xzQnXfVq7I7U9pl2Io+WFyo2lGVGJyECHETT598foH5BYqk6YHRqUGg2yNk6YZhEm8aVTYA
	f5Bn4Y1OdtBgAqn+OEcM25ou4rdzPMe2V0apzsqsCY8NfNjmrixF1Lr8Gww0tZAipDGKOfUPbKf
	eVTxOyjoQ6L0m65Zhe0/O3jf9srQ9rvPV/EvnLQWJ3axJEAuC1l6tWqo+NYAhkMHODUWl2H/4Ot
	MEXOgwJ9HQ9L/ieJ/gipQ14K0soa4IY7cdlerxPw2WLi+O7GH0jftX70phPXXj5d4w15qyEqBjL
	slnxWAjtmjDqO3MM72yu8u0hctf+bcSotJQlKyMIjxrrQbTb1+0pv5DnggIsHy1EUPAPFJzQdwJ
	Uoz/SyVEhDGg472qnQ28fw==
X-Received: by 2002:a17:906:dc89:b0:c26:1648:a06b with SMTP id a640c23a62f3a-c509642fa78mr1012025366b.38.1794863728282;
        Mon, 16 Nov 2026 13:15:28 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac254ba6sm773826a91.4.2026.11.16.13.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 13:15:27 -0800 (PST)
Message-ID: <137eca09-9546-4b52-b4b5-f2999e87b408@suse.com>
Date: Tue, 17 Nov 2026 07:45:22 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix return value to report partial success for
 direct IO writes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c40fb9e159c3ddc020c5d48db85a517caf63bc30.1794246932.git.fdmanana@suse.com>
 <8da77d7db1e50bd725179dd123d5518b9a7d29b2.1794329417.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <8da77d7db1e50bd725179dd123d5518b9a7d29b2.1794329417.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 04:18, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When a direct IO write in btrfs_direct_write() is only partially
> successful, the remaining data may trigger a page fault retry or a
> fallback to buffered I/O. If this subsequent operation encounters an
> error (for example -ENOSPC, -EFAULT, or -EAGAIN if we are in a NOWAIT
> context), the  current error handling logic drops the count of already
> successfully written bytes and returns the negative error code to
> user space:
> 
>      return ret < 0 ? ret : written;
> 
> This goes against the write(2) semantics, which dictate that if some data
> was successfully written before an error occurs, the system call should
> return the number of bytes written.
> 
> By returning the error code instead of the short write count, user space
> applications are misled into believing the entire write operation failed
> and that no data was persisted to disk. For append-only workloads that
> blindly retry the entire buffer upon receiving an error, this results in
> a silent data duplication and corruption, as the initial partially
> successful direct IO write is repeated.
> 
> Fix this by always returning the number of written bytes if we wrote
> anything, otherwise return an error.
> 
> Fixes: 51bd9563b678 ("btrfs: fix deadlock due to page faults during direct IO reads and writes")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V2: Addressed a couple issues pointed by Sashiko.
> 
>   fs/btrfs/direct-io.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index ed3914257d39..66debd730e42 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -1048,20 +1048,36 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>   	/*
>   	 * Ensure all data is persisted. We want the next direct IO read to be
>   	 * able to read what was just written.
> +	 * On success btrfs_buffered_write() incremented iocb->ki_pos already.
>   	 */
>   	endbyte = pos + written_buffered - 1;
>   	ret = btrfs_fdatawrite_range(BTRFS_I(inode), pos, endbyte);
> -	if (ret)
> +	if (ret) {
> +		iocb->ki_pos = pos;
>   		goto out;
> +	}
>   	ret = filemap_fdatawait_range(inode->i_mapping, pos, endbyte);
> -	if (ret)
> +	if (ret) {
> +		iocb->ki_pos = pos;
>   		goto out;
> +	}
>   	written += written_buffered;
> -	iocb->ki_pos = pos + written_buffered;
>   	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
>   				 endbyte >> PAGE_SHIFT);
>   out:
> -	return ret < 0 ? ret : written;
> +	if (ret == -EIOCBQUEUED)
> +		return ret;
> +	/*
> +	 * Always report partial writes if we wrote something, otherwise it
> +	 * could lead to silent corruption for some applications: for example
> +	 * if an application does writes to a file opened with append only mode,
> +	 * in case we succeed doing a part of the write and then fallback to
> +	 * buffered IO and that fails (or return -EAGAIN because we are in a
> +	 * NOWAIT context), we mislead the application into trying to write the
> +	 * whole buffer again, resulting in duplicating part of the data and
> +	 * therefore a corruption at the application level.
> +	 */
> +	return written > 0 ? written : ret;
>   }
>   
>   static int check_direct_read(struct btrfs_fs_info *fs_info,

