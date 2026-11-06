Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793996776;
	b=VisOVYz38FKbQ0dcQRaClFktNHqupXlKG5bRrvJFoyE4gT1LtKypuE4Fj2TlNjjpSufp
	 0ImaFbJJBAODzGFe55Nt9CNDINz0wVtjXnwOEzddJhBreWFQMI7vMsyjJCja5/HHoFIIC
	 Ol3RhVQ0H49okb9M7Qo8JVGJtO20GTxWfpmH7VXOnKP4HP9VmqoU7g8QX/NNyfXe+pqJE
	 TMzIj+YpTRJRQJyIoLPe5FB4MRUOrLQNXoXwHxMAxVfNkGrkPTlg/0c1gTHLio6LT+rNR
	 a3u0jypEviZB5wTIB0W3NLWvQhm9dKHqoNA5tY773c7ORl/XamI1PzR7tF5+EBdH1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793996776;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0nW1H5I2DN9JUqH0sK8dAdINajRh4/jyrvhju+aejag=;
	b=Dni5bQq2wnT7kqOBWO9Ml5Wc/dDItKazYEZkbB6uYY3hTlX8C26gGDKa326rW3oA8+Do
	 s8FbYsOzAjUDYLSJuIXip1W04cDKngYABqvlsmD0uRYMjBnXYbFpkr10+e/ezv9u/OurJ
	 /XIjBRS+kvQ5wBHCMU5ifTUnLakCDZT569zOPrJ662HL/U8SRLdGA4MgAejXA1cduk10+
	 PWaGCCiCK/qNv/dZElxiywZO+7lp2wDfWt5rq1Jczyx+XZ91vKiq/12IrvUOeQOo9vaoh
	 TLfh+H4pfcuMwExpE71VwIQ88SXP7IkFyMRSWZgYgfRErDwKkp3Wr/v0twB0KN8EK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cJdR14E5;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F59606A329
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 20:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74F59606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cJdR14E5
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso1510465e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 12:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793996774; x=1794601574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0nW1H5I2DN9JUqH0sK8dAdINajRh4/jyrvhju+aejag=;
        b=cJdR14E53R6XL+OWd2wfgejiyYldHm3XztlKn+548lxL6vt6CCQzkemL26RSU/MKFH
         wJchNhmA7/dpveFA3a7vOeSdRWcH/btW7AJnAn2THPUdisfTWCSG4CCM4WCWboUqUN85
         bMTzXM1vYCsqkCM7g4phC7Dp0vWu8h5T3RjDCteZ+gA7gQQMT7zs+o/c6KBxu5oZRoBU
         GnPbbrWAESu5bHbwIAcE5hY7mkveTVdCn4ZHx0LcJ4+AyqzG8cBOFO1yqpXZ8oDKN9fu
         1lmz+ErUIHtnprcZ1rVsQKReVcZ3ERJd3u9MGlQupw+SEMaeq7gYJR4b4Gg8K3HG9H1V
         uPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793996774; x=1794601574;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0nW1H5I2DN9JUqH0sK8dAdINajRh4/jyrvhju+aejag=;
        b=X/uwjpFOUVygJfotPsp5sNHrdnK+7J57OmIdWLwtRX6m6pf6OuFK66Z/Iov50IjTLa
         Ud2IIkbNzBEl38T3l5WDFXwpiEqqIlzJ0xzYwpwHNgR0Vs+7eQdbCAgNd+KSeXxTtwPp
         Mj6M6byEGyBevaiyyhV6Vg11EDuTCQAohaICDeoNGCAUF9IKVR7a5XdbqxUA4RBDGmlW
         nF8zipySKIutNVdJ0TczqUF9dGi/IyUSWz8whDCIeV/PD/Usyhi8tm1yUvGsgxuGw2Ea
         IqdTNtx8qGXwadSgYElo8QtJqOnpiVwW9ySstRxhahmU7J9aHAzI91GFM4wZUT+/bmcS
         if3A==
X-Gm-Message-State: APuU4Z/GF1cv60BZ1C9VkCyKnV1I6kzmzsYKf0rtnW0osPvJMgzPrITM
	hqI7Bbn1DG4ssv1CCYjBVxbPtYmei75wWhgbzn5ahlRfh4JBDnrtYesdiMOhl0vQvpCu3FtERZR
	vFuY0Cqg=
X-Gm-Gg: AYBFou1TnVQwP0JGosQoiIUgG3C1HvJpINU/3K4iM2EC6MRUaJlNxpbQVup4X0snsds
	eJ0YBlwfb7Jill10/2D7Cum4DaWyYfBziXAH6uXZGIjiDo83hg+4bkqjvnDoq+3GHe1gMo5/aAh
	B5DlFFxpL7AgP77/c2qlLMOzwDf/2a4mBxRuPosASgwxZfyld0xrEvU3cvNw5aj3mfAV3v0chdd
	JfxZmQiH775gYtIe0XI8u4uHRiztXDxD2vvXc9qGHDlDX+hdLHZXFPdgQxhtM1pgEBXl/lo8+Sn
	6qIm8C/CZvdwSv4VJgMjseLY/K2iH/MfY7s9qunX+AneZNwB0DyZDurOojLfDpY9HofZrPjhRTf
	SKbLMAf56R73h20d7wAHp4GIFPcA+916ed43/xxO0J+tyAz0l+ONrKK3ouap8YAKHpHqY7kRn/V
	YaWNQ13s5uDiW8ZBUmyogaPwztpMsdYpawSjmioo1T3M09wgRgn5R0kG1ojFhAiS+JCAxx2+9jZ
	bJ0jcbjd1VIIpSeBkJLNeI+gBMHSyuC0OFbkc5hIDQ2ZQARbK0Q3hTNleCuB+UBTRS5XoiRDTWJ
	bMGLFzlBR0/GMTHvw/h4iw==
X-Received: by 2002:a05:600c:6206:b0:4a2:967:dfb8 with SMTP id 5b1f17b1804b1-4b6dfab3fa9mr57523115e9.20.1793996773732;
        Fri, 06 Nov 2026 12:26:13 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b26294289dsm8573233c88.4.2026.11.06.12.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 12:26:12 -0800 (PST)
Message-ID: <e29db0cb-2054-4894-958b-800d03ad4d79@suse.com>
Date: Sat, 7 Nov 2026 06:56:05 +1030
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
Subject: Re: [PATCH v2 2/2] btrfs: raid56: pass REQ_META to per-device bios
To: socketpair@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
 <20261106-btrfs-sb-read-req-meta-v2-2-71c1afaf5c67@gmail.com>
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
In-Reply-To: <20261106-btrfs-sb-read-req-meta-v2-2-71c1afaf5c67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/7 04:03, Mark Korenberg via B4 Relay 写道:
> From: Mark Korenberg <socketpair@gmail.com>
> 
> RAID5/6 writes, and reads that need a rebuild, go through an rbio,
> which builds new per-device bios from a bare REQ_OP_READ or
> REQ_OP_WRITE.  So all tree block writes on RAID5/6 lose REQ_META, while
> on the other profiles the per-device bios are clones and keep it.  The
> same goes for a tree block read rebuilt from the other stripes, for
> example with a missing device.
> 
> Pass REQ_META on to all per-device bios of an rbio, data and P/Q alike,
> if any bio it serves has it.  Scrub and relocation do not set REQ_META,
> so their rbios stay untagged, as do rbios that only serve file data.
> 
> Signed-off-by: Mark Korenberg <socketpair@gmail.com>

NACK.

One should not even use RAID56 for metadata chunks in the first place.
Nor we're any different from other RAID56 implementation.

> ---
>   fs/btrfs/raid56.c | 14 +++++++++++---
>   fs/btrfs/raid56.h |  7 +++++++
>   2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a8a8004bb14c..63b5acbf107e 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1202,10 +1202,15 @@ static int rbio_add_io_paddrs(struct btrfs_raid_bio *rbio, struct bio_list *bio_
>   		}
>   	}
>   
> -	/* put a new bio on the list */
> +	/*
> +	 * Put a new bio on the list.  Every per-device bio, data and P/Q
> +	 * alike, serves the bios in rbio->bio_list, so it is metadata I/O if
> +	 * any of them is: a tree block write, or a tree block read rebuilt
> +	 * from the other stripes.
> +	 */
>   	bio = bio_alloc(stripe->dev->bdev,
>   			max(rbio->bioc->stripe_len >> PAGE_SHIFT, 1),
> -			op, GFP_NOFS);
> +			op | rbio->req_meta, GFP_NOFS);
>   	bio->bi_iter.bi_sector = disk_start >> SECTOR_SHIFT;
>   	bio->bi_private = rbio;
>   
> @@ -1246,8 +1251,11 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
>   	struct bio *bio;
>   
>   	spin_lock(&rbio->bio_list_lock);
> -	bio_list_for_each(bio, &rbio->bio_list)
> +	rbio->req_meta = 0;
> +	bio_list_for_each(bio, &rbio->bio_list) {
>   		index_one_bio(rbio, bio);
> +		rbio->req_meta |= bio->bi_opf & REQ_META;
> +	}
>   
>   	spin_unlock(&rbio->bio_list_lock);
>   }
> diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
> index 8700910b8dc9..a5a0ff8e4a03 100644
> --- a/fs/btrfs/raid56.h
> +++ b/fs/btrfs/raid56.h
> @@ -139,6 +139,13 @@ struct btrfs_raid_bio {
>   	 */
>   	enum btrfs_rbio_ops operation;
>   
> +	/*
> +	 * REQ_META if any bio in bio_list has it.  Set under bio_list_lock by
> +	 * index_rbio_pages(), which runs before every assembly of per-device
> +	 * bios.
> +	 */
> +	blk_opf_t req_meta;
> +
>   	/* How many pages there are for the full stripe including P/Q */
>   	u16 nr_pages;
>   
> 

