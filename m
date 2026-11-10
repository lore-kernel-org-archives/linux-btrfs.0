Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794294350;
	b=G+12xwg1eSNjARxGPYeLUSF6QrAf3K1VOfZE6eZSwOW4u/Z7bPFTXGSFh40QPlxcDFnA
	 RtA2CTrv2AWzUH14MX7SxMmAoCyakvBMbp/0MWaWLlrm0Hw+TdRTx1NqDLbfdMUhw7dY+
	 GR3Mce6Bf0+EvLJERL5nGOGADrDJehwI5TR1YwHAx6RXUIZ4KWvvOdS199rdjYfm1eYF0
	 zUpg4uY+4hOEK7nAOiMVUT6YIL/oxduCLCXfZxCxGhkoGJabByUtxj9Ujt64RC26eiqun
	 8jEL+gVx9ZN+Jk3/23gQ5uFfW9ZUbujXjeH0tPFH+92MA0dPFpfOTW+X5w4IDFTvMtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794294350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:References:Content-Language:
	 Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pvjYsiwU3cv4C7oM5j/eIU9we4Tv1PLDXjBXS8XiR1o=;
	b=aDaf7sS8Il2OJsIKIJTLmJXLZg5lQOI1If14n1DPQvcH0NaH+YxQJP10FN/TNOGZVgMs
	 DxYN8868ftURwyEv7GAdl82ShemCFApJC7rP3j2bEWDAghPgdv1P4NxRJD8oV0hAwbfra
	 HlCM0nEDDr0h4YlWrainvwh3p0lgyWhq80jeD62g4IBdNh0YoO6fV+UeLcqV+xYd1oCLS
	 Y/M/6gnybc01jE366AbrOVOtaxIgeduIn98TRDaymSnbmDm7n2Dn7A5PH6JkKU30i0Qar
	 zkDQasNITLPy9tyJqXucC4Qj36JA26hIZ2qlUC2wwlxt8MJVtsIIzUS48hhlNNXnxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dvDOcWFY;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B27606A338
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 07:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49B27606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dvDOcWFY
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so247253966b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 23:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794294349; x=1794899149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pvjYsiwU3cv4C7oM5j/eIU9we4Tv1PLDXjBXS8XiR1o=;
        b=dvDOcWFYbzkv9QGT55v9cS5JHb2ifUJZr8POD1F/8pYVlNSGb1lTrjneHiIjPP7GSQ
         Bzmhlm4UL4Gn8brGlYNNxTBXqU1fguiR3jma2/fs0UX3IHTrN8FDGifq6YKA0nCgC7PT
         cLRsOHvuDA1TVUcxK9ro17Y4rNTFM5wm1oLoOPkX8kv+o+/+KWR6wupi1PoQEvgyA0ni
         4fHPMiMi/czGjIXKlEc5a/1LC/jcgyn0XCbXv03NU9aeNKxHfu6Mfdj5S0dcEQO453Nt
         3lYMWsSIT0piGPB1dFCsyJtllU5bepBt2UKfnHymqUkmMLdj+/jFwdgEX06qqjQUmZ10
         Ly2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794294349; x=1794899149;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pvjYsiwU3cv4C7oM5j/eIU9we4Tv1PLDXjBXS8XiR1o=;
        b=DSN9xvBlC4GqD/qDqohTtqPA2lP1fqzvrC1IN7uCsXE6Vo3WvsHgd30wRC2KLmjlUm
         HPfGzSLFi5EUeBoH5AHMBrHrkCkajLib+O28i02NPK0lmZb8iDo1tYmKs3Ue2CetZHkW
         NaeGKDcliLHH2DeC7kaa24BDnykqozoLlLHxEaeNP4SiiS3iHr9PYJsTBECb3l9VnsFc
         RUjXYlidUYqSVZdey5rLUclcMevJVQrUp/JDA08kVrbmBTgWx4eoBFaNQRr/3G352KDp
         tp1eMkhiy6qi2bRkac8HjMaBFuYlsYuTFK+aG7TgKSvMruCCpUAuCR0aPB2vvhbMLNFz
         kX+w==
X-Gm-Message-State: APuU4Z/vr3zXg2ncMfv61Ju8IIcohpUvZ3KCeS7VemNuk/tm7s0zKUHZ
	+Q11Eyj0n2dAWMSbGFVX713FLli7b/4r3ZGdOXh+tIA5SB6ZmSCE89W3SC0D2hsI/ZYid9Zf/DC
	CktENAiUOZA==
X-Gm-Gg: AYBFou0XDmEqzQtnaV/mzA02/OHRjfwB9KdwbnEGJRNLsJSgtB3eeFrDjgLN1fifGDA
	s6F4DuChjuT/FvKXIGqYp308HBrfUOGEI80zR7kOCyDdOtsGl+iNNoewm3cCXFkY/+udpNACYLo
	bninEoH08maA/xtAaVEvEHOB3OVNBBAdXSvDrGta3b4zd1KoW71KOM5UgIyhxbhvMBKuqX4Swtu
	mH0ILypFUPpogP2k3USHQud+en77ONaEkj2oAVR4YpOZumm5l9C2dOD736Dzws+ETPToBfHWSra
	ka/Ur8CM4va+nEQ4h+XWiDlJbLCLTUtrumyqivHAIjKJnohfwspfXfwtp8NPheEj7K7b6a1kfNs
	IT0uJKLA6fqGsFAjLzfH687Jq+tCZMTzWg7gr7KQIIMKlCQq9kALaAe4Etmv9Abl199nBxO4OJP
	JvM1S88k80UQjSLcKVWT1ssAOadgzDA2z8ZGqn2mMcCG/FPTwyVFR3VIofk2K8tQwq2vm0Xyew7
	+sZt2uqphUNaOoB3MEwJ0U6pH0Szg3fnlIgA4ZLexAQ6UNApE5CZxIEH9v+bsNDmGIGbbGxmIkJ
	8KMoXqfQH+O5QhPZ0rn1Pw==
X-Received: by 2002:a17:906:9f92:b0:c50:59e4:199 with SMTP id a640c23a62f3a-c5059e40eccmr8868266b.3.1794294348465;
        Mon, 09 Nov 2026 23:05:48 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d7bdd57sm432211a12.24.2026.11.09.23.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 23:05:47 -0800 (PST)
Message-ID: <6399e4a7-8a3a-4c64-9e80-9cd26a4613db@suse.com>
Date: Tue, 10 Nov 2026 17:35:43 +1030
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
Subject: Re: [PATCH v2 1/4] btrfs: do not allow fast fsync if there is any
 async dio write
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
 Filipe Manana <fdmanana@suse.com>
References: <cover.1794290876.git.wqu@suse.com>
 <aa2343bbda662ef5f425c0dfbb5c84cc67940fcd.1794290876.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <aa2343bbda662ef5f425c0dfbb5c84cc67940fcd.1794290876.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/10 16:42, Qu Wenruo 写道:
> Sashiko reported a possible race where an async direct write happened, a
> fast fsync() can return before the write reaches the storage:
> 
>    CPU0 (io_uring/AIO direct write)| CPU1
>    --------------------------------+-----------------------------------
>    btrfs_direct_write()
>    |-btrfs_dio_write()
>    | \-__iomap_dio_rw()
>    |   |-btrfs_dio_iomap_begin()
>    |   | |-btrfs_new_extent_direct()
>    |   |   ^^^ new extent + ordered extent, data not written yet
>    |   |
>    |   |-btrfs_dio_submit_io()
>    |   | |-btrfs_submit_bbio()
>    |   |   ^^^ bio in flight, not finished
>    |   |
>    |   \- return -EIOCBQUEUED
>    \-btrfs_inode_unlock()
>                                      btrfs_sync_file()
>                                      |-btrfs_get_ordered_extents_for_logging()
>                                      | ^^^grabs the incomplete OE
>                                      |
>                                      |-filemap_fdatawait_range()
>                                      | ^^^no folio under writeback, returns
>                                      |    immediately
>                                      |
>                                      |-btrfs_log_dentry_safe()
>                                      | | ...
>                                      | \-btrfs_log_changed_extents()
>                                      |   ^^^ logs file extent item for the new extent
>                                      |       OE only marked PENDING, nobody waits for its IO
>                                      |
>                                      \-btrfs_sync_log()
>                                        ^^^ log tree is on disk, data bio still in flight
>                                            fsync() returns
> 
>    power loss, the data bio never reached disk
> 
>    mount
>    |-btrfs_recover_log_trees()
>      ^^^ replays the extent item, file now points to unwritten blocks
> 
> To prevent such problem, disable fast fsync for async direct writes.
> 
> Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback")
> Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-861136993fc7
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/direct-io.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index ed3914257d39..6e796163015e 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -974,6 +974,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>   
>   	if (IS_ERR_OR_NULL(dio)) {
>   		ret = PTR_ERR_OR_ZERO(dio);
> +		/*
> +		 * The async direct write is not waiting for its IO to finish.
> +		 *
> +		 * If fsync() went through the fast path, the direct write OE
> +		 * will be logged, but the data may not yet reach disks.
> +		 * And fsync() returned without waiting for the data.
> +		 *
> +		 * So for async direct writes, we can not go to fast sync path.
> +		 */
> +		if (ret == -EIOCBQUEUED)
> +			btrfs_set_inode_full_sync(BTRFS_I(inode));

Unfortunately btrfs_set_inode_full_sync() is not safe if the caller is 
only holding a shared inode lock.

So it can still race with fsync.

The shared inode lock for dio writes is introduced by commit 
e9adabb9712e ("btrfs: use shared lock for direct writes within EOF").

This is making me wonder if the shared inode lock for direct IO is a 
good idea in the first place.

Or should I change fsync() to wait for direct IOs instead of using 
btrfs_set_inode_full_sync()?

Thanks,
Qu
>   	} else {
>   		/*
>   		 * If we have a synchronous write, we must make sure the fsync

