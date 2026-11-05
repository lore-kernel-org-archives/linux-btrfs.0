Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890072;
	b=3RKQrUfmhoRIbPVCL8eGwA1lSoF9HCbtY8houmReQYpe5+rdrWmLcMOr4TjEvpP+q9Ng
	 lNZt3X1xp7t2ncjwbpmiLVPKOYxDHzb9elGv1jrJPpM0TWm0dx8Rx08y9SIPbNP/Sebv7
	 JcY9fou/INCFdOQM7ZntEYKR4eapBQnCAaBTeNncOkpqAMH1BefkExwjAl7VPqVEDZ0UM
	 plnX8kSGBJ3/f/CHV6kvPp3g+AHMNLIz1i3Y8/LXHMvaFoPh6Ch967RDErjZ8t60mvyAF
	 Lm2z4U+h0Er/Lc/0wmi5Dz9nr+PwUOBo/JtXCSIpyVNZrLKTk2dE3ZVVPxdAC/aly3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890072;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References;
	bh=TsmecKMB53MMLoeV3U1sXBEAHag3fepZSE22CdWa2qY=;
	b=WVvxyLCAyIFU51hRNiUs8yTtPh6joMAIDDl2Dwm5KhJwPXL7nAtrHjad8ZJiuvHUwqWV
	 r33wntc825rcWHAhNh2Dgo49HrdGro4+V78pBwb/WROohwd+RCe50E3y2zM+N6xgwGlTs
	 1ICcI1ovMbowCcqZEjMi+5QFfGcZF+Qnma7fo5r1fdnr+03LhU47LknVBP6r7fgIEJ8hx
	 tdkgx4FDpjA7Ak2peP9uN4Tgx7GVAoUEKTx11qXI8JoXGv6XzADDwgSNp3IlkcVpKMWqV
	 H2Q6rDhQIgA8dvcWM8410kHyrVhzE7tnQX8Fn2KkIap/JozKk6vBUt6bgFd9aWR0Rtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TqrbUF3S;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344F7606A326
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 14:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 344F7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TqrbUF3S
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so8117685e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 06:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793890070; x=1794494870; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TsmecKMB53MMLoeV3U1sXBEAHag3fepZSE22CdWa2qY=;
        b=TqrbUF3Szyfy25+T4qoTrOZ/exXBHTJroxjpvjzh4fQ7VBRe7+AWGpvzWDKILi5pM8
         GEG3eJzDk8AMp8n7wlEIpcpVcVS3XNrJdCODUnlh7Zgpw+SoaswU7iDDmo8D9qrTWCPv
         HPOiHvKok4sisCw1IplBuXfiAIAXLGI3FfNWM/HbIIRH8evuRDRWTNMXZxkYGkWFKiJG
         A9vVHnnJbrgeJdcIWwSd8k6iGtUDfXPYtrwTM/rFgMm9fbFKV2XJ29T5SPbGpdtda1Dg
         uxuoLiFqvT8c5MAGEw2MJ1KPruc1Q2laY+SBWspl0gve9pu8IAok6P5qMv2wM7MBRiVQ
         5NAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793890070; x=1794494870;
        h=references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsmecKMB53MMLoeV3U1sXBEAHag3fepZSE22CdWa2qY=;
        b=fU9gcyD4JSiprBbo8SaHiL4k4zd9E/qRjrZyDS2ux5TlG0nNYW1Z81c1utBpvYKB0G
         zM0l32wkGwCBzIcgvgkILm9gm3HAqQ07Hvr/Gj1yMzgaMTfhikFHsB0Q7dlLpyEcH0G1
         U1y0fyLx4/eNJXZdnc0fMFQ9VzBZHuV/pcb2JJWO/19I8h+N5V2kHgbayUOYdAt+nTT8
         u1aawWiMxR4ks8ST7n8PmeEHZnVXbTZP7rMFwDNNmEbnGrTfvTYu8rjFZN50sbI5EKnz
         lS10VMr3PKJyBM95BbwkB9WDsINAmfaovcCtbztzw2qGium0+nojNIl8jYJwUkZDWkJf
         Pt4Q==
X-Forwarded-Encrypted: i=1; AKwUvByGaGcoWpPv7P9wO7NJFMBmnCwYWz9A+F34YcvXoHIRgkcCSZVpvL/X3ga6MomXXIqHQT1yHXHMoCPjgg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+gAkNCWlwl6N/11WmVQzX6IKB0FWVSyTdxPAnfUcvUp3W3WWay
	DyZn5Fgc0AhEw0XMCS8ycWQDvvxgY6BDymOco9U7yvW7sztWPWVBXlLM
X-Gm-Gg: AYBFou0FMnwvTkRh2CBPv9Zv68tVFaZylJHzNd+QRlZ5j955IHOeZYd4/AZpFqRjSaP
	Z6AnM/eYLuPXpUBTNCgQcUxbOUDX072lZZJJbat5qbN1Fe5lXU4OmIf3ON/hBGyl6OFMTUTY/J3
	IsyFQaza75GWxBvIuncryjNFlnuL+0IAj4SlhqKK7OoASw2nAJ2UhVrqkBxyhXVJhoX9lYZTorD
	pTQUmPVt6OqpCeUaytlmvacjqwtUTFYPBRRwfPOq6gbbHQ3A4xQsSOwXL+VSgQgd43UCtr1jclg
	zFcQJ8vqNLA/NPjNmT3o0uqUL/7xXdKygv+EWZouwMjiDuEpWt9ytIARiN4a5jPoxZUeDSWO0sU
	1z0Oy4Rjh5sXphdMbWjXRNKxjtI5XWHEIkJc8urFtm2ojDL1sQZ68BR0Pm+o3YiZGF3017jf55l
	qMZiNAC3HkJYc8RfPwE9DmDZptigDNN6mTDqBoQZLab6J7cPIkItAhFfSKxqINh2GG1KzyxP9ZT
	OaOCkdS7i5Z7IScBj6tfpK6CGgnbWbWN+HFBeGGAtQdnTOe+oCnsC5Y4MG6rDIunknMR715S3Io
	EmUHupCT/2Mw3jdkW21hj4ZyDlE0mXyXOvhWPf4CS1wqM8nC1+KIN+tPsRrf1zV7K8HSG/KDlwb
	WwGQF+Qjs5sP16upeX0Eya37YoNOCmqggvK4=
X-Received: by 2002:a05:600c:3b04:b0:4a1:efbe:529c with SMTP id 5b1f17b1804b1-4b55d8cfdbbmr48479825e9.12.1793890070263;
        Thu, 05 Nov 2026 06:47:50 -0800 (PST)
Received: from localhost ([46.36.23.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm84600345e9.8.2026.11.05.06.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:47:49 -0800 (PST)
Date: Thu, 05 Nov 2026 19:47:47 +0500
From: Mark Korenberg <socketpair@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tag all metadata I/O with REQ_META
Message-ID: <35f7fdfe3efd8e949f9abfb1411de4db@gmail.com>
In-Reply-To: <9e2c808e-6edf-42b4-a70f-5fecc8f1eb69@suse.com>
References: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
 <9e2c808e-6edf-42b4-a70f-5fecc8f1eb69@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list

On 2026/11/5 19:37, Qu Wenruo wrote:
> > - RAID5/6 rbios build new per-device bios from a bare op, so all tree
> >    block writes on RAID5/6, and recovery reads, lose the flag;
>
> I think this can lead to very cursed combinations.
>
> A RAID56 mixed block groups. In that case, how do you handle recovery?
>
> A vertical stripe can contain both data and metadata, should the
> recovery be counted as data or meta?

In v1 it is counted as data: btrfs_chunk_req_meta() returns 0 for any
chunk with the DATA bit, and a mixed chunk has it.

I don't think that is right, though.  My view is that everything that
is not pure data is metadata: if an I/O may carry tree blocks, it is a
metadata I/O.  A device that caches or places metadata differently is
better off seeing a few data blocks tagged as metadata than missing
tree blocks.  So in v2 mixed chunks get REQ_META too, including RAID56
recovery.

On a mixed RAID56 chunk this tags file data writes as well: a
per-device bio of an rbio can cover sectors of several original bios
and the parity, so only the chunk type tells it.  I find that
acceptable for such a rare setup, and v2 says so in a comment.

> > - scrub and dev-replace read, repair and copy metadata block groups
> >    without it;
>
> Again, what if a block group is mixed?

Same as above: tagged in v2.

> > Tag these by the chunk type: metadata and system chunks get REQ_META,
> > mixed chunks do not,
>
> That almost kill the meaning of re-introduce this flag.

Agreed, see above.

> I'm more interested in how other dm devices, like LVM/dmraid handle
> those REQ_META flags.
>
> E.g. a btrfs over a LVM/mdraid, and btrfs passes REQ_META for a tree
> block read, then should the LVM/mdraid pass REQ_META to the underlying
> devices?

dm clones keep bi_opf, so LVM and dm-crypt pass REQ_META down.  md
raid1/raid10 pass it too since e879a0d9cb08 ("md/raid1,raid10: don't
ignore IO flags"), which names the priority inversion when REQ_META is
cleared.  md raid5 drops it: ops_run_io() builds the per-device bios
with FUA and SYNC only.  I see that as a gap in raid5 that the
raid1/raid10 fix did not cover, not as something to follow.

> If not, I see no particular reason to strictly follow that for
> scrub/dev-replace/raid56 recovery.

md resync cannot know what it copies, btrfs scrub and dev-replace do.

> I'm more interested in what you really want to archieve?
>
> Just to make the REQ_META more consistent?

Not only.  The ublk zoned device I use sees REQ_META as
UBLK_IO_F_META, and its server caches and places metadata differently
from data.  A tree block read issued by scrub or by RAID56 recovery is
still a metadata read for it.  The same holds for the in-kernel users:
BFQ prefers REQ_META requests, blk-cgroup issues them as root to avoid
priority inversion, and wbt does not throttle them.

> At least I do not think it's a good idea to touch RAID56, unless you can
> prove that mdraid is also passing those flags.
>
> I want to align btrfs to existing RAID56 implementation, not the opposite.

I'll move the RAID56 part to a separate patch in v2, so the rest does
not wait on it.

Still, I don't see what it can break: it changes no algorithm, only
the hint.  And within btrfs, metadata writes on DUP, RAID1, RAID1C3/4
and RAID10 already carry REQ_META, because the per-mirror bios are
clones of the original.  RAID56 is the only profile that builds new
per-device bios and loses it.  md raid1/raid10 pass it as well, see
above.

> > +static inline blk_opf_t btrfs_chunk_req_meta(u64 type)
> > +{
> > +	return (type & BTRFS_BLOCK_GROUP_DATA) ? 0 : REQ_META;
>
> Missing BLOCK_GROUP_METADATA_REMAP and also handling BLOCK_GROUP_SYSTEM.

Both get REQ_META: the check is for the DATA bit, and tree-checker
allows only five chunk types (DATA, METADATA, SYSTEM, METADATA_REMAP
and DATA|METADATA), so METADATA, SYSTEM and METADATA_REMAP are all
tagged.  The SYSTEM rows in my test show it, METADATA_REMAP I did not
test on its own.

That is clearly too implicit, and it leaves mixed chunks out.  In v2
the helper returns 0 only for a pure data chunk:

	return (type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_DATA ?
	       0 : REQ_META;

and the comment lists what gets tagged: METADATA, SYSTEM,
METADATA_REMAP and mixed chunks.
