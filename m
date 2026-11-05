Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869671;
	b=ZckQHBF0t1Dkko7mB/hU1ABUNyqe+Rgks55SiZh/99ywIthQvvXDH+36DUqqRwuLSG/1
	 TXSQLqs6vrx1Yx3iXx3pg4NJK6dvyjDat15BelfRSCJDl6MPZTQUu1tCD0beFP2luvac/
	 etMF/SmUtZ2N1nP/NiG5J8pZRSan316lPWPjCgp1xcQ7KdNKSXKBVUQ7sqyB3BSOzyTde
	 I6eaOBetLOlSHk303/3rBtXVKvNo7KE5xQtZWrFsB+98Zj5gH4Fyny09as5UxWH0Rq41a
	 OLk0uPXvnJzLE1NCQedDfQf3gxIr4vQQcLS89obmNfJQZYradwm623QkFA+abTGD3Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869671;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Z2i3ysHV2P7OAwQB8Ti5GqJN8ZXWRRtLyGzrjnEl+ts=;
	b=AuW2MwocEdLXK+SUZk0B/JEG9ZAk4wxsfksZt8jloj0Gi9LEPc4qvBWDLMApczD1iXu+
	 dQFaqx3mw+Aj5BJ+v4zCV8Jw+DCbc/vqJcaw3IOS3wUksx++JUltRCWdLQwh9pNme59EV
	 f1FAMeKouW2FnTNniywWenoXXgNKYy9iYwLknTyF56dY8LHe0u4Tn6trrS80gBOd7r62j
	 PY940MFX124ZYhB98E7Fb/AsEr6ZyZw5GN9Yk5KLFI4xtuBsdEVrk/bn04ksAzCYHm0KX
	 XES8yJjL3t5avqY9Awxreyxk588XUBNS1TqOyIFtvsLb2gmKNZ9psIq/OF7Rfvs7aDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dp5CWzco;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE3A606D803
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 09:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BE3A606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dp5CWzco
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c43373ae89aso234872866b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 01:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793869669; x=1794474469; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2i3ysHV2P7OAwQB8Ti5GqJN8ZXWRRtLyGzrjnEl+ts=;
        b=dp5CWzco2DHFFtYhnARqZW8PUCUXfxzLtdf7l4X2HbZ8tjSYjAzwdFtn6LeRH5AMnv
         DZkQPmyBhmGtQ45DjvLZearl2E84eD//EwELqVABRDj7A7WPh4DDtsulqEyehWDBksbV
         4nWcgNssKLqwQYF9eBIEOE6NYmXHa+yAO2IkmLmwQgnnc+SlIqdKX7z/oa4jxCqXQoFm
         LmC0KWk1W5OXjquXfg0r4xl1/2JMiN2I1qXSvc2E35SYVlo5/eK65Bw1kOxalSU3TUJ6
         YTPFzzMto0ESauKLpeGeOQ9Y2Az/w3f4f7v4n3zu9n0v8yeikwYafhQiJUQWVvqFciTe
         qGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869669; x=1794474469;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2i3ysHV2P7OAwQB8Ti5GqJN8ZXWRRtLyGzrjnEl+ts=;
        b=DRcg7b9Q7Uii3Prhzg0zW1VIorJTtx6V8QGZFxUinA9toyqIHGdumg16bS96fUb7dq
         eMvvHAD4qKjbiN0e2O4KYK3uZeQNtn6NWL+QTf+T9PW8d5/uxVsrHipSykZeuKmrfn2V
         VonN0n815Fu6hUqz3ULV9VwirJ21nserkkoPlAJYcJrsuuOp+CVVWef7Fes9fe1nkLAn
         9mP7mR7gERVXdf9L9hgq4bc14wuAI1BELSoMCFA2xMw+ZRzwBt0WBolk0gseDevqy298
         RL8nqDv9lxv5+u5adIG00qY8dgd9bREdAMlQJgMDRV5rSFEskk5lTBisDfmY329/Spne
         Ja3A==
X-Forwarded-Encrypted: i=1; AKwUvBzggdxyDdXi3dho1ufhHi11Ye651sQiGNZM6fwamUiXE/uVchGnfILs+Zf7ZD+NN/2MxhJI0WF59IZKVA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8mVi1Sx+BIFGuJgREMaHfnaxktMKTose57dix1fTc51eH15TDK
	pM9AGYIm3WRrBfNCM2wfknrf+in6LNI34z+h+EWx0FW6TNeNcVpIueJEH4KcKUTpsk8=
X-Gm-Gg: AYBFou1DhXolt3Nb0lDwOjpwLc0Jbe4Cq4Yt/f6UMD9jW/mimkLhN1pYSMs3bBGKYXt
	iyFJYP0G8vIpjq2gFvpPed3IIQeTVsn5LU7MzIfCiBZFU+WgguVIbW/zI0bU8c3+e/XMbTf8rSY
	ciKL7YiyZTq6Vammf+4wuCSANUjwu2T6sDbujTPPFSEB3Vp7pTXS8vYWe7kn5tyfawtUKO71GeP
	Bo4f90ppxoP7yi1K4fWapDcMDeGqBuqzCiOb88nc3WDJ/mmT2JRiJxWIR1mrwRH4pzeyh4DRRD2
	ekFFYDfyqJNbEbnOfd+cmQ0zTvBP/hbbmZe6GF7SX4PcS+NaoWaLuGARYKaHKgyQEne/kusfuCJ
	Cf/aRSiEXk1GkPXIGFZyZhu/Y+5rQSsbdwl3F2Sa5BIy7hQHaktxLT5DudEPPE6CTRRfwJjciye
	d47rPyV3FxBbGFiQbg/MPDBy75UH5u1Bb7a86aMMBTsSEf6dkpfsynTtvzWEFBFCzKI10HX8CIg
	poqj7JQKCXFz6qBK9ZFFsWT1GFM3gNEhKkHCaQWFUbofNabDaqUcRZUE7vDWeAUDSamby59NV+Q
	Mqqg6YXGPanaT807z/jB
X-Received: by 2002:a17:906:f58c:b0:c40:38b5:d784 with SMTP id a640c23a62f3a-c4ca7b1f74bmr1767896566b.22.1793869669211;
        Thu, 05 Nov 2026 01:07:49 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b1ee455336sm559123b3a.54.2026.11.05.01.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:07:48 -0800 (PST)
Message-ID: <9e2c808e-6edf-42b4-a70f-5fecc8f1eb69@suse.com>
Date: Thu, 5 Nov 2026 19:37:43 +1030
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
Subject: Re: [PATCH] btrfs: tag all metadata I/O with REQ_META
To: socketpair@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
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
In-Reply-To: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/4 21:08, Mark Korenberg via B4 Relay 写道:
> From: Mark Korenberg <socketpair@gmail.com>
> 
> Tree block reads and writes and super block writes carry REQ_META, but
> several other paths do metadata I/O without it, so the block layer and
> drivers (blktrace, BFQ, blk-cgroup, wbt, ublk) see it as data I/O:
> 
> - scrub reads super blocks with a bare REQ_OP_READ;
> - btrfs_repair_bbio_failure() rewrites a bad tree block copy without it;
> - RAID5/6 rbios build new per-device bios from a bare op, so all tree
>    block writes on RAID5/6, and recovery reads, lose the flag;

I think this can lead to very cursed combinations.

A RAID56 mixed block groups. In that case, how do you handle recovery?

A vertical stripe can contain both data and metadata, should the 
recovery be counted as data or meta?


> - scrub and dev-replace read, repair and copy metadata block groups
>    without it;

Again, what if a block group is mixed?

> - remap relocation copies metadata block groups without it.
> 
> Tag these by the chunk type: metadata and system chunks get REQ_META,
> mixed chunks do not,

That almost kill the meaning of re-introduce this flag.

I'm more interested in how other dm devices, like LVM/dmraid handle 
those REQ_META flags.

E.g. a btrfs over a LVM/mdraid, and btrfs passes REQ_META for a tree 
block read, then should the LVM/mdraid pass REQ_META to the underlying 
devices?

If not, I see no particular reason to strictly follow that for 
scrub/dev-replace/raid56 recovery.

> as they also hold data.  All bios of a block group
> then carry the same flag and stay mergeable (blk-cgroup does not merge
> bios that differ in REQ_META).

I'm more interested in what you really want to archieve?

Just to make the REQ_META more consistent?

> 
> This does not change the btrfs submission path: scrub and remap bbios
> skip checksumming, and scrub_read_endio() and scrub_repair_read_endio()
> do not wait for other I/O, so running them on endio_meta_workers is
> fine.  With blk-cgroup, metadata scrub I/O is now issued as root and
> charged back, like other metadata I/O.
> 
> bdev_rw_virt() takes an enum req_op, but gfs2 and xfs already pass
> REQ_META through it.
> 
> Signed-off-by: Mark Korenberg <socketpair@gmail.com>
> ---
> I noticed this in the request log of a ublk zoned device: tree block
> reads and writes arrive with UBLK_IO_F_META, while the super block
> reads at mount do not.  An audit of all bio submission sites in
> fs/btrfs then found the paths listed in the commit message.
> 
> The super block reads at mount are the one case I left alone, along
> with a few others:
> - btrfs_read_disk_super() and sb_write_pointer() read through the
>    block device page cache, which cannot pass REQ_META.  That is on
>    purpose since 8f32380d3f29 ("btrfs: use the page cache for super
>    block reading"), to stay coherent with mkfs and udev.  The same goes
>    for btrfs_scratch_superblocks().
> - Discards free space, and the empty preflush of write_dev_flush()
>    covers the whole device.
> 
> Testing: virtme-ng VM, memory backed null_blk, tracefs
> block:block_bio_queue, every bio classified as super block or by the
> chunk type of its dev extent:
> - RAID5 metadata and data: copy /usr/include, scrub, then replace
>    devid 1 with a new device
> - DUP metadata with one copy of a leaf corrupted, read the directory
>    until "read error corrected"
> 
> Bios of metadata chunks, with REQ_META / without:
> 
>                                  before      after
>    RAID5 writes (and RMW reads)  0 / 274     245 / 0
>    scrub                         0 / 390     369 / 0
>    scrub, super blocks           0 / 6         6 / 0
>    dev-replace                   0 / 258     243 / 0
>    repair write                  0 / 1         1 / 0
> 
> No data bio carries REQ_META, before or after.  No new warnings, W=1
> build clean.
> 
> Not tested: the remap relocation part, btrfs-progs 7.1 here cannot
> create a remap-tree filesystem.  Mark, could you give it a look?
> 
> The audit, the patch and the test were drafted with the help of an AI
> assistant (Claude Opus 5.5).
> ---
>   fs/btrfs/bio.c        |  3 ++-
>   fs/btrfs/raid56.c     |  3 ++-
>   fs/btrfs/relocation.c | 13 ++++++++-----
>   fs/btrfs/scrub.c      |  5 +++--
>   fs/btrfs/volumes.h    | 10 ++++++++++
>   5 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2e12a6d7e16f..efbce4d549ff 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -951,7 +951,8 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
>   	}
>   
>   	repair_bio = bio_alloc(smap.dev->bdev, max(1, length >> PAGE_SHIFT),
> -			       REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
> +			       REQ_OP_WRITE | REQ_SYNC |
> +			       (is_data_inode(inode) ? 0 : REQ_META), GFP_NOFS);
>   	repair_bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
>   	while (cur < length) {
>   		struct page *page = bio_iter_page(&bbio->bio, iter);
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a8a8004bb14c..1b5cdcdeced3 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1205,7 +1205,8 @@ static int rbio_add_io_paddrs(struct btrfs_raid_bio *rbio, struct bio_list *bio_
>   	/* put a new bio on the list */
>   	bio = bio_alloc(stripe->dev->bdev,
>   			max(rbio->bioc->stripe_len >> PAGE_SHIFT, 1),
> -			op, GFP_NOFS);
> +			op | btrfs_chunk_req_meta(rbio->bioc->map_type),
> +			GFP_NOFS);

At least I do not think it's a good idea to touch RAID56, unless you can 
prove that mdraid is also passing those flags.

I want to align btrfs to existing RAID56 implementation, not the opposite.

>   	bio->bi_iter.bi_sector = disk_start >> SECTOR_SHIFT;
>   	bio->bi_private = rbio;
>   
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index b2ac5b836b21..af17be38eea3 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4146,8 +4146,9 @@ static int copy_remapped_data_io(struct btrfs_fs_info *fs_info,
>   }
>   
>   static int copy_remapped_data(struct btrfs_fs_info *fs_info, u64 old_addr,
> -			      u64 new_addr, u64 length)
> +			      u64 new_addr, u64 length, u64 type)
>   {
> +	const blk_opf_t meta = btrfs_chunk_req_meta(type);
>   	int ret;
>   	const u64 copy_len = min_t(u64, length, SZ_1M);
>   	struct page **pages;
> @@ -4172,12 +4173,12 @@ static int copy_remapped_data(struct btrfs_fs_info *fs_info, u64 old_addr,
>   		to_copy = min_t(u64, to_copy, BIO_MAX_VECS << PAGE_SHIFT);
>   
>   		ret = copy_remapped_data_io(fs_info, &priv, pages, old_addr,
> -					    to_copy, REQ_OP_READ);
> +					    to_copy, REQ_OP_READ | meta);
>   		if (ret)
>   			goto end;
>   
>   		ret = copy_remapped_data_io(fs_info, &priv, pages, new_addr,
> -					    to_copy, REQ_OP_WRITE);
> +					    to_copy, REQ_OP_WRITE | meta);
>   		if (ret)
>   			goto end;
>   
> @@ -4344,7 +4345,8 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
>   		goto end;
>   	}
>   
> -	ret = copy_remapped_data(fs_info, new_addr, dest_addr, dest_length);
> +	ret = copy_remapped_data(fs_info, new_addr, dest_addr, dest_length,
> +				 bg->flags);
>   	if (unlikely(ret))
>   		goto end;
>   
> @@ -5161,7 +5163,8 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
>   		}
>   	}
>   
> -	ret = copy_remapped_data(fs_info, start, new_addr, length);
> +	ret = copy_remapped_data(fs_info, start, new_addr, length,
> +				 src_bg->flags);
>   	if (ret) {
>   		btrfs_abort_transaction(trans, ret);
>   		goto fail;
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 98362c91bce4..269948b1caeb 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -934,7 +934,8 @@ static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
>   	 * enough to contain the full stripe.
>   	 */
>   	bbio = btrfs_bio_alloc(round_up(stripe->stripe_len, PAGE_SIZE) >>
> -			       PAGE_SHIFT, opf,
> +			       PAGE_SHIFT,
> +			       opf | btrfs_chunk_req_meta(stripe->bg->flags),
>   			       BTRFS_I(fs_info->btree_inode),
>   			       logical, end_io, stripe);
>   	bbio->is_scrub = true;
> @@ -2957,7 +2958,7 @@ static int scrub_one_super(struct scrub_ctx *sctx, struct btrfs_device *dev,
>   	int ret;
>   
>   	ret = bdev_rw_virt(dev->bdev, physical >> SECTOR_SHIFT, sb,
> -			BTRFS_SUPER_INFO_SIZE, REQ_OP_READ);
> +			BTRFS_SUPER_INFO_SIZE, REQ_OP_READ | REQ_META);
>   	if (ret < 0)
>   		return ret;
>   	ret = btrfs_check_super_csum(fs_info, sb);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 891bc2432870..66796f09eae8 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -709,6 +709,16 @@ static inline enum btrfs_map_op btrfs_op(const struct bio *bio)
>   	}
>   }
>   
> +/*
> + * REQ_META for I/O to a chunk of type @type that holds only tree blocks.
> + * A mixed chunk also holds data and gets no flag, otherwise its data
> + * would be tagged as metadata.
> + */
> +static inline blk_opf_t btrfs_chunk_req_meta(u64 type)
> +{
> +	return (type & BTRFS_BLOCK_GROUP_DATA) ? 0 : REQ_META;

Missing BLOCK_GROUP_METADATA_REMAP and also handling BLOCK_GROUP_SYSTEM.

> +}
> +
>   static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>   {
>   	return offsetof(struct btrfs_chunk, stripe) +
> 
> ---
> base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c
> change-id: 20261104-btrfs-sb-read-req-meta-7be597aaaa51
> 
> Best regards,

