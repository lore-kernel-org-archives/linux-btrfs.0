Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914858;
	b=KKxyBTib5keyUSpejB6F4WQZHymQwKle5qkXgCj6JSqA/O3+k0UHdcBxFYX/ogt8cQfA
	 WZuUG5dD6IYH/tKnpOdfqBiVMc9bKq09F1zhIWsFn+05snB53yVnGJOWScYZxD9RKk2J5
	 R4bqOLVol4wq1bFIOa5eeqlqEykeACynnEmY5gwlV65evO9coD7pfJ/UhoqfSHis3cHsg
	 CTgP2xJ7puD5uIrWMUPTUvqR4F7Ystj0nWAgo22LlkE+8sSA20vYbVYWkEvlkWxyDFXYQ
	 CPlV/uMhWhWb1e5g2Orwg8Zv1007bTjh72t/xKWuNCC9GeMHCPqaXZn8gINZILCe4Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3obuZhReeCGzVSo/DFmgPCNrfjcr4Z8U421ZxD5AvPU=;
	b=jXSTUM9ejSzlwkamUPZEOlpQoUdbkZ7NEFQ4DodY8C9+Bar0Ax6h06oJkBYQ9ijdAlze
	 AT5pma6lHIoTPfPPWfBpylInett4roEjcZQU5Qyv4hD9DjLrKqj1y+K2D/Siz1EHDOPJt
	 3Dbk27OrAXibQIpYJhGrWgQMx/RsPtb3TCLyOfHg9wPn9g/aQ6k3FVbi5XIAJqRFs4AeN
	 8OHoB3zQyrtih2KW1Iw7GmW7v/Xkwewx7TYE+9JN1vP3XcuYSHEpFQu4NwPfzn9gzWSDU
	 YmsCoP2GKAc4LUsPQY63Wzl99KoVqWhQFKzy2bS7vD4rzlSglPD52Bm49oCPxM9zxMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JzMq3udC;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2123606A326
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 21:40:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2123606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JzMq3udC
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so289625e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 13:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793914856; x=1794519656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3obuZhReeCGzVSo/DFmgPCNrfjcr4Z8U421ZxD5AvPU=;
        b=JzMq3udCHqbGSCkmN87EV9p3PRTCf579Vco50F4MiUxIE44gE62I9sKDb4PtMPwa18
         6rYzoV+Hd0pSF7a24XOMlba0MhcEFT6LCl9u+54X9zvb+kIueURw44rOoJGMkdEUCgCf
         pe1V/PEb42bFvH5Duy1V04Zcs5cfTZn6uG5HWq4bly1PXQhvD2HwUGkjDngHxQtnHbzl
         YqighKUd+mXyTlkL+SAswVaWDMBA5Tz64Tl6JPrM3zYeQAvoWb/yoJbmMHRjYJyuyeVR
         7Lw9tFerhrgdDr9iKbO3Zq3RJ+Oo37PL7/MshR2/3WyWT3AAX0rDZXt4wfNDf9it/IR5
         2qJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793914856; x=1794519656;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3obuZhReeCGzVSo/DFmgPCNrfjcr4Z8U421ZxD5AvPU=;
        b=AWNE2GDpCprsNA+9niap7R5E+Q5Es/udEixQCfsU8ve7Al8cLgpaNE2MQc//ExOggt
         Ks+pnza2v/5Kjpu8UQewjLlGqv74iDRb1yHLRvZWngYixQf+rKjBLxwlOOrYE1JwGObC
         7fqVsd76IPYnfXrNJDpa7MG6jEcZcA067zvSZGPF9HBrJevDjk+Jbja5k2oPV2UfVdQv
         p73FO3a3C8bJEcXTjbh2QfV51LqyFkMuBk6uRGml9ME5YGrlnzCohKbcyk8nfd48PFoh
         fdc50vlSIEOYO3NSMJwplSDxIuBrjWIbPQWpUrzaBSSJKJHY9cGWCakMjJDNH+xAaOEv
         oLUA==
X-Gm-Message-State: APuU4Z8DTMZ5LABHihtEf4QmwkfrYczF18QxvOwkoMk78QXxkT5mecpE
	rMt8Jb5fSYID/aHErpFDSK+o+ql8muC/NP3FR5A6cP0d1AR7bmJ0mSHDNic6ewBpea0chK9biWa
	Fp+7Hcv0K/A==
X-Gm-Gg: AYBFou25bBU9LZTce8NjZIB9sJZrzClln1Eissvd0tyFYE66IpF+UzJNFw1Fsf+8OGI
	GCah56w0l8PeZDkUh3hb6xSDFFGhc8Aq6QoSKAyJOSqMp00Ea5A4SfjSFaC/H4d1+cjEbvXzu1p
	K2R/O2CXLMzFOX7ztqCnE/uq6zh6Pz9+6oQhiy9fsopsnScJIYB/6ujTutWH1P5WUcPByeuMh0H
	IzgY1zDGPOnVPbxPRX5dEiFPxEgCYrsHOJ5N+MhfzOOQ/iN1qmrH/DgqrF0tTv7PJFn7OAMNgs/
	uAf0Rv0IUnvhGuOTvujV0lTon8DladmeOv0G+jlyjCvwyEmkjJ0t6yMWSfBILj1h29V8iJXY1Uh
	KmJnsgmId36WIFSypFe1yWACEoKU0HAINQwMTrPnLoTwwP9GuTgdcj/XaJ16Qds8iJhER0Oy3C8
	DWu2X8PV6djSQnMu0NKuGBw5oH4aOonHU2pHTRxEJPxu9A5IC9D5tl6igKDMyJvGbERhQEtY3vv
	52r3+7/YT0FtG/Ai+Ot7WjfmtF5oX2HhlEhmXK1mYvh+U2iMZppV85dm/AivYkmmR9oHWtKe6lD
	B94Bwe11McpRzvn05/0q
X-Received: by 2002:a05:600c:6211:b0:4a0:1c94:7042 with SMTP id 5b1f17b1804b1-4b6de4a5d5cmr7096215e9.8.1793914856258;
        Thu, 05 Nov 2026 13:40:56 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0906175bsm21039485ad.27.2026.11.05.13.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:40:55 -0800 (PST)
Message-ID: <29d5cd74-1613-4ee2-a9e4-ec9e0b430bd1@suse.com>
Date: Fri, 6 Nov 2026 08:10:48 +1030
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
Subject: Re: [PATCH] btrfs: skip fast sync for inodes with encoded writes
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <14e0d19262452be0d9e08478f47be08ec6fa6d6f.1793852473.git.wqu@suse.com>
 <CAL3q7H7JCSuTuGvmwrf3ckBwhm-5Wnnub-6C1mXGX=ZTi0Yo8g@mail.gmail.com>
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
In-Reply-To: <CAL3q7H7JCSuTuGvmwrf3ckBwhm-5Wnnub-6C1mXGX=ZTi0Yo8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/6 04:39, Filipe Manana 写道:
> On Thu, Nov 5, 2026 at 4:48 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> [BUG REPORT]
>> Sashiko reported a bug that encoded writes can have its file extents
>> recorded before their data reaches disks.
>>
>> [CAUSE]
>> An encoded write returns to the caller as soon as its bio is submitted,
>> and its folios are not in the inode's page cache:
>>
>>    btrfs_ioctl_encoded_write()
>>     \- btrfs_do_encoded_write()
>>         |- btrfs_alloc_ordered_extent()
>>         \- btrfs_submit_compressed_write()   <- returns before the bio ends
>>
>> A fast fsync only waits for writeback of the folios in the page cache,
>> so it has nothing to wait for on such an ordered extent:
>>
>>    btrfs_sync_file()
>>     |- btrfs_get_ordered_extents_for_logging()
>>     |- filemap_fdatawait_range()             <- no folio under writeback
>>     \- btrfs_log_dentry_safe()
>>         \- ...
>>             \- log_extent_csums()
>>                 \- log_csums()               <- csum_list may be in flight
>>
>> This has two problems:
>>
>> - fsync can return before the data of the encoded write is on disk, while
>>    the log tree describing it is already persisted.
>>
>> - With async data checksum generation, the sums are attached to
>>    ordered->csum_list by btrfs_csum_one_bio() before the checksums are
>>    calculated.  log_extent_csums() can then log zeroed or partially
>>    calculated checksums.
>>
>> For buffered writes this is not a problem, as writeback of a folio ends
>> after the bio endio, which in turn runs after the checksums are
>> generated.
>>
>> [FIX]
>> Fix it by requiring full sync for the inode which went through encoded
>> writes.
>>
>> Encoded writes are mostly utilized by btrfs-recevice, so it's never on
>> the hot path.
>> And receveied subvolumes are set read-only, so normally no one should
>> even call fsync() on those inodes. Thus the cost of full fsync on encoded
>> writes should be very acceptable.
>>
>> Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu%40suse.com
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog
>> RFC->v1: (RFC at https://lore.kernel.org/linux-btrfs/c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com/)
>> - Require full fsync instead of waiting for encoded writes
>>    The common usage of encoded writes are btrfs receive, so we shouldn't
>>    need to bother fsync on those files in the first place.
>>
>>    And this makes the fix much simpler.
>>
>> - Drop the REASON for RFC part
>>    Which contains quite some incorrect assumptions on fsync() and direct
>>    IOs
>> ---
>>   fs/btrfs/inode.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index ab60b7d4f389..65714380a935 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -10035,6 +10035,12 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>                  ret = PTR_ERR(ordered);
>>                  goto out_free_reserved;
>>          }
>> +       /*
>> +        * fsync() of the inode can not go through fast path, as there is no
>> +        * dirty/writeback folio in the page cache for fsync() to wait.
> 
> Neither there are dirty/writeback folios nor do we wait for the IO of
> the ordered extent to finish (bit BTRFS_ORDERED_IO_DONE set) before
> unlocking the inode.
> The comment focuses too much on this not being buffered IO, which is
> somewhat confusing because fsync works for direct IO.

Yep, I admit I focused too much on that.

Do you have some advice on how to change the comments?

Thanks,
Qu

> 
> Otherwise:
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Thanks.
> 
>> +        * So fast sync can return without waiting for the data to reach disks.
>> +        */
>> +       btrfs_set_inode_full_sync(inode);
>>          btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>>
>>          if (start + encoded->len > inode->vfs_inode.i_size)
>> --
>> 2.56.0
>>
>>

