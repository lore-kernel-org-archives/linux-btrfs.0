Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793515927;
	b=JPTOqhNohIKFbk2rtjxE3A7thfoa7pjwVgjWv2heL935h7wL4lF5mYiiypTLIg1tfDEd
	 fdrE0FIdqX2TJbZln3ko6X5NYkSlRsSM546mjrNAy1wWtFzG1aL6OAgfLki0WCi53kCkr
	 28g/y7O7cfItTD6JfAft3tqZp33++KZ19Lv8uereJeoG//rizvWrl2VXnNBEiGdhrTlzO
	 vU86EuJ40J7Mlvgx7KBwlQ7W7FIf1l5EcMNasL36dRhxsktfIz54Uw/H0930Q4xGA+nZ3
	 z0z4FNPP6u5hHYEcR9EYX8IQtWr7Pmap5T/QSdTgkklgjFGk1MIInDy/nO/uiQ4zdzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793515927;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=iUeaN24ubqK+XseRTkWoI3CKdK3A8caVIym6MWDEuks=;
	b=HYWFD115aOTuwbfTd5H3OSaUdRSrf99R2OBCXK55VkIVi/1qpotFLCatXKhviw5Rt85m
	 C3dn5OCABtA8dT+uprQxXvM8Mnu+VdK7IfhK6fVbawkH2KeR3I0wmLN/r3OGVnsZt25tW
	 Lk1yMqZYnmOZREZLwJjs67Y97v3ocaytzLwNltNtGi4jnSZEKasmImqm75LH+EWu5OpSj
	 iJGinv/Qj+E8FXeNJmxluPxjjOlhXHt6pMEP0iOtl1XPGVXYAR517/uHF9EVro4TQk8WI
	 2J/scrdrQClleBS/NSLzZf05cvFSHD3Zl51jnmAjnVGqTwC0TZZI1arcDHru12KYTiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Xsqj3+XU;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB40606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 06:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AB40606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Xsqj3+XU
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a208d93758so21359015e9.3
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 23:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793515924; x=1794120724; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iUeaN24ubqK+XseRTkWoI3CKdK3A8caVIym6MWDEuks=;
        b=Xsqj3+XU3mQZSjjf07wQPdY/nmNLohqUNEGClT80Km4NVcC0DJ9ziP4b+NhVBFUURH
         xMpKsdKp8aA/ZhcXRuqyrX1kErYa90Zz980aUDriWDi7zh/8kXpFqTyMrvSo7xbyOcxA
         3CpjbrNeUS4DNaMBuP86gG+Kfl2qh6rhEID9C/LL1bpu+gHWWbnOAIpyxg6cTbViaxVJ
         FxagSd8MeNMXKezwdbV4/7NNZ8gybxv5sXXjtY788OEV0Qy0ExtbNlgU/XOL1QUt4rE6
         S0QiWK0v9GmENMwapszTSxvxOTsxpvPETcvQREDmzg+r0iEHWPIXaLWjvS7cpwXw90JP
         rn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793515924; x=1794120724;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iUeaN24ubqK+XseRTkWoI3CKdK3A8caVIym6MWDEuks=;
        b=OGj3KI4ZUxunu7aQ2KSjtdZiQDL3eSu6DvAkUjFi9wSTf9nJql9/AAv6g6dJuPOVSg
         m3Ub3Uge8ZOjrWA8w/I+vLdS/gB7lSSxx24koWYg5BHLDXEr1b+tV3zvs/BJYvIltN2J
         AaqK6+SUDHKeUdIVS+FcC8AAO5s0iQvBJbsXRT9Ka5Fqmr/mJahachjsu82NjEf7GSIL
         h4Gj5VEYiDHsA3jQ7HbdX+FAvg+Zsp0wPbp0pzmdAGA14XiEQ3MYQqU8Q7pzGy67Wfh2
         J4Dt8T6VZYVtU2ouXw80zlYJfwoVlb77WrkX7j60g63ln0F+4f9+SBiLAiZzb78taJXT
         K3jA==
X-Forwarded-Encrypted: i=1; AKwUvBxfz0M1Gah+WCYfOmmy3A6eAMagNxY9ofWfhXBWsgAoHHTXLI18qqAhiVHxQGNmO7cgixi0ZlP9Rjpdpg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIUAyI1H2w5oFEURSafx4RNGs6LJDl52sont2iMg/s7a/3PFxW4
	cw3Bp6UdW+MEXQMb66rHygslzEfn/C1RWRdBMPP/79Ta92gKT8b0m6VmJxa2dw9PAKsGlVaIgMk
	qLcf0C0w=
X-Gm-Gg: AYBFou2qQKb+tQGnixE0brjZ+VP6sk8MMYx49Jh48+vKZxlGXAZohKx1vF9FwqohF0H
	il93WLJBA6tXG9W72TAii8olk1LXfmTNvv+bJ+aKjbJPSKQMQcn8nNPbofwAgUHzAVQpZjlwV0X
	v8JlJx2xyvlySD47AT2S+lJuFsguEin+1sMpuaS4Kg1bDbUgaCdqkYyN2eh3bKucXl+RiMdF8tm
	VyxmggSmpQBcLcdZsP/k7NEpAaseu2DnL8V+37AFXYCew57TC+i1dzAdoY1RCa5xsuToxjwUjw0
	MzitH677z4FHqpbEcCyTPqbnJ4Nj2w/2CH4oozqbZkJZtRa8mpfDowCW5luilk0vmNrorDfRbH+
	YMktm/ELALwLIrWmy6i5tSHfJAeGMCONaxgsuEEJRri1owK/yCC0lB/GEX0BDiSjcD3J9NqPsH/
	2pM45T+/WwT5gCLgoxl4B/gR/9Wh7ThFVEIleQV5X/8jcbvokf+jMGhT+IKuVn7rN8azIIWebsm
	lj16I+8WCsfrTWJIkcjzXbzJzXYAekkJWdJqRh0x3N0Da+NeojvfBKqHqRBO3mSjLk2P0LlkqAK
	4xnIYvnNb8xaKLob771IO8s5RVB/MXKxO8fxUvlw2A==
X-Received: by 2002:a05:600c:1d29:b0:4a5:5fb9:5d35 with SMTP id 5b1f17b1804b1-4ac187a7678mr161246385e9.21.1793515924452;
        Sat, 31 Oct 2026 23:52:04 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1a16sm19922956c88.1.2026.10.31.23.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 23:52:03 -0700 (PDT)
Message-ID: <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
Date: Sun, 1 Nov 2026 17:21:58 +1030
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
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261101062539.1744605-1-teel4res@gmail.com>
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
In-Reply-To: <20261101062539.1744605-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/1 16:55, Cheng Yongkang 写道:
> btrfs_ioctl_subvol_sync() assumes that a cached root with zero
> references has BTRFS_ROOT_SUBVOL_DEAD set, and asserts that before
> waiting for the cleaner. Two states break the assumption:
> 
> - A corrupt ROOT_ITEM with zero references and a matching orphan item,
>    on a writable filesystem.
> - A failed subvolume deletion. btrfs_delete_subvolume() zeroes the
>    root references, aborts the transaction, which forces the filesystem
>    read-only, and then clears DEAD again. No on-disk metadata is
>    corrupted in this case.
> 
> With CONFIG_BTRFS_ASSERT=y, both reach a BUG().
> 
> Before waiting for a deleted subvolume, return -EROFS if the
> filesystem is read-only, since the cleaner does not drop dead roots
> then. The check runs on every iteration, so it also stops a waiter
> when the filesystem becomes read-only during the wait. Subvolume
> deletion holds subvol_sem for writing across the abort and the DEAD
> rollback, and each iteration takes it for reading before inspecting
> the root, so the read-only state and the cleared flag are seen
> together. On a writable filesystem, report a zero-reference root
> without DEAD and return -EUCLEAN instead of asserting.
> 
> Subvolumes that were not deleted or do not exist still return -EEXIST
> and -ENOENT, also on a read-only filesystem.
> 
> Tested on btrfs for-next with CONFIG_BTRFS_ASSERT=y. A deletion made
> to fail by fault injection after the references are cleared hits the
> assertion in SUBVOL_SYNC_WAIT without this change and gets -EROFS with
> it. A waiter on a deleted subvolume now returns -EROFS when the
> filesystem is remounted read-only, instead of waiting until it is
> signalled.
> 
> Fixes: 6c83d153ed86 ("btrfs: add new ioctl to wait for cleaned subvolumes")
> Cc: stable@vger.kernel.org
> Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> Link: https://lore.kernel.org/linux-btrfs/dd97efe9-91ec-495b-b698-acff1447421c@gmx.com/
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
> Changes in v2:
> - Return -EROFS on a read-only filesystem before waiting for a deleted
>    subvolume (Qu).
> - Use unlikely() for the inconsistent-root check (Qu).
> - Describe the failed-delete case separately from corrupt metadata.
> - Add the Fixes tag and Cc stable.
> 
> v1: https://lore.kernel.org/linux-btrfs/20261025180258.349175-1-teel4res@gmail.com/
> 
> Testing notes (btrfs for-next d1dca33127ef, KASAN):
> - The fault-injection case reached the cleared-references state in 2
>    of 4 attempts on each kernel. The other attempts aborted earlier, and
>    both kernels returned -EEXIST.
> - FOR_ONE, FOR_QUEUED, COUNT and PEEK return the same results with and
>    without this change for live, missing and deleted subvolumes, on
>    writable and read-only mounts.
> - The -EUCLEAN branch was not exercised. A crafted image with a
>    zero-reference root and no DEAD flag hits the assertion without this
>    change, but remounting that image read-write stalls in a transaction
>    commit with or without this change, before the filesystem becomes
>    writable.
> 
>   fs/btrfs/ioctl.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9857d6a9d456..5a1f2edfd831 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5166,8 +5166,14 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
>   			return -ENOENT;
>   
>   		wait_for_deletion = true;
> -		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
> -		       root_flags);
> +		if (unlikely(test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state)))
> +			return -EROFS;

I'm not suggesting such an ad-hoc check, but some more comprehensive 
checks, like mnt_want_write_file().
As this one won't handle aborted transaction.

But it's not a good idea using that mnt_want_write_file() either, as 
that will block pm suspension/hibernation, especially considering the 
wait will only be handled by cleaner thread.

The default timeout for waking up cleaner is 30s, which is definitely 
not suitable for such calls.


If you are not sure what to do with the RW check and cleaner behavior, 
just don't put an adhoc solution into the update.
At least it won't be any worse.


> +		if (unlikely(!(root_flags & BTRFS_ROOT_SUBVOL_DEAD))) {
> +			btrfs_err(fs_info,
> +				  "subvol %llu has refs 0 without DEAD flag",
> +				  args.subvolid);
> +			return -EUCLEAN;
> +		}
>   		sched_ret = schedule_timeout_interruptible(HZ);
>   		/* Early wake up or error. */
>   		if (sched_ret != 0)
> 
> base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a

