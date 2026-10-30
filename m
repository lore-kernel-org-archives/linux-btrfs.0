Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394378;
	b=kwlCzw+srT5TGwYxfjyYhnEZytlrf747oGrceEEt3AS8Sa1mt2TNCZtXfJ38/SaEsFIa
	 0WvPiYiiovFE9PkyGsUE/RBDbXy6UswfqWsrcVRhE+brdEzIZI/WORa/v7fBWoGFr4rJF
	 Ix1rqS/f5xgpIApZ+aCRL+rBJa/EwosRGludmlU4I3D7HkUl+WSO3XMsaaGd45anLH/kX
	 hfamkHugRvqa28l2f4IGqB0rFQc8RjqbhWmcjLT4h8q9KviotZDSpcsSY21I1VtKiEti4
	 qd8Bt1xFlksWUAtwZrGKvf+JP25/eMjDKFxd2Ubv10qIDONA8lskOTuXg+gB6nSw3Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3g6Cz2d8sKkJb6/thMuVsVtyf+10ZaExGlswqtnVU68=;
	b=t8AGIBC3fHjcvhmtW4ZPHHy07zuEaRkwhJoZGRYGirR4pf0a94mGzcoYKGOjLZYLD3qK
	 jGeZBv8M/JqciFkyXhjHD/NgKV/nbm2vM5wVDqUNb30VHssI/nUWVTwMa6QaKg1R18Rdn
	 0qfpTngBMJNzxni3K7FE3Y7ZrR+Dsicla7Y9VACZ40QJQEeHyvskMkVqcyP3n9silxv8O
	 +eVyqMQrHBC6KpDVGzu/CAUk31q/5UhPasFzlQpurRC3wA7lgkWbxJvgPPvN3MdbCC/RR
	 XEr7E0FEFXtpDMNqxSEc5ABpN8nh87rBu+mOJxZnmjXeGefJRLf8MNc6ydMCo5XSiHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="cv+GVt/7";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D505606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 21:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D505606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cv+GVt/7
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so7660145e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793394376; x=1793999176; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3g6Cz2d8sKkJb6/thMuVsVtyf+10ZaExGlswqtnVU68=;
        b=cv+GVt/7SKogebaL1wDDZ3ih0Ey1kKg7eaGV8pNhO7G/1sggVerA8ddt2xpeWC6mPY
         fih1/3u95+GTT9mOe9H+cSGgCVxyayRFd0ZNtnp0SYT/5yWYqLqeX/3WoskfqTVHtWMe
         6jtdSa040A+/bJKeck+yhn6o7JriK9BLtP3au7QL5RA3yTHuc2Pbfn2O8Ujo5N7MNUtj
         m/aaLbxMJsaafxX0Wf2el5Jj0Pvj/5TPSRh3S7n0j6nlQUju3Gsu4V3MOkaaMLJnjYvM
         q/K4BMuiNSk+ViFoxXhD7XBURjiVwNUZJcAP7lSugSAJJAOfKPxkkmQlAS3k5u5AaaMk
         Oytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394376; x=1793999176;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3g6Cz2d8sKkJb6/thMuVsVtyf+10ZaExGlswqtnVU68=;
        b=vJb42FGydNK1jWEuR3GkHJkdaoLjAOl1Qjsxpej4Cjnb23JPsJ3FrHEKDUhznMYQ5/
         YS91hx5d7YtWjfqbxjjfHhereifmd/E80FDdugeJOsnzgWBhL1UyoQg5qB/o+KXBvwgb
         EOg8DYFG1tT7m9/ul8D6Z/XPTkaM2hIr/kdFqyajmi+4vMF+tgVD+HdemAcBQh5IsFjV
         KD7CZoTtS31IYEjBTMXi3rVr4RkqIlNfE9NxeN2HJq+UNqWV/vU3pd6oNdJoOmUCpWhf
         xiE5jtji5Vk+E7Cfne5Fgu4k7s+KIFTXHIhFtJMZW/0+C2OrkTeJSW8zVgT4ajQ77U21
         c5Hw==
X-Gm-Message-State: AFq9FYI77I6bCn4lnI5TIpt8SH8eE61Jd70xgQJuAh0kFRmjit/yjDWv
	8HSYn7FAw0gkeMDrFdQYHtNc6rDCZYdNbUhvLTnD5mwg1StZnA8zcpGHdSj5qXYSyP4=
X-Gm-Gg: AYBFou0rs6sZbCgo9/3/Z6CMEmtoTuU94ueGb8m/SzI/+x+L52HdQB7rN6VHTsfDScB
	Um7zlbEyMB5Jcj4me1jJAbkd8jsUUb/QEYALP91KycXruvacdJg7n808OlRzYnpl7O2/KKGyYMe
	DseaXkhxVmKNfLu4/SoEG5bYrousDQmWiMjQyeOr6LycNGAuh6Xl3plL0zY2nfHxPkNgBC8qjtR
	O72k+WP48sI+Tvpa00BQCiv6uxtrjD4DfxRtG+GHpG/LwMZms5yEU1Ys5RN9hiv+BVCzNkuQn6F
	py4/CTpslozEIGiq7oja0lbfvtyNcnXNScqeDGgV6/WRSOwjv6l+KqQ4Y+CWT4fB/mZWQkAJYFe
	gyVLZ+W9BfqnbSgYfnlP8x3SCirQ0LVuMIaQD4Mp6BplEjqINxpi9uKqNC/5bWRd2/64ZBr39oN
	y9MYp1xd4u7Tv7nI4fwfqTKGEXAZUOUxsZtHxK4b9bdGj7zx6hKnRWuqGDiMl3RfPYToVOKXNB/
	TFgJzv4xwnsacPnZxdJv2I+C3WOVLH5og0zJQFu40nEYkF5veXjewArXbKeUo3qLymP5QW6uwO+
	TpmoNP+XaC8A6MvqNE/0ig==
X-Received: by 2002:a05:600c:1c0f:b0:4a1:ac66:6059 with SMTP id 5b1f17b1804b1-4ac19233381mr76726395e9.26.1793394375823;
        Fri, 30 Oct 2026 14:06:15 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8fb2c5sm9933851a91.3.2026.10.30.14.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 14:06:14 -0700 (PDT)
Message-ID: <8728a52d-53b5-408e-a541-ee309e970e18@suse.com>
Date: Sat, 31 Oct 2026 07:36:09 +1030
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
Subject: Re: [PATCH 3/5] btrfs: make fsync wait after pre-submission errors
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Boris Burkov
 <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-3-f4d4196731e6@toxicpanda.com>
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
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-3-f4d4196731e6@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/31 01:08, Josef Bacik 写道:
> Commit f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents
> after a write failure") made btrfs_finish_ordered_extent() set
> BTRFS_INODE_COW_WRITE_ERROR in the inode when a COW write fails. The flag
> makes the next fast fsync wait for the completion of the ordered extents,
> which is where the extent maps that point to unwritten extents are
> dropped. Otherwise the fsync logs file extent items for them, which is a
> corruption if the log is replayed.
> 
> As the comment there says, this is also needed for errors that happen
> before a bio is submitted. But for buffered writes those don't go through
> btrfs_finish_ordered_extent(). When running delalloc fails for a folio
> that already got ordered extents, or a block can't be submitted,
> writepage_delalloc(), submit_write_sector(), extent_write_locked_range()
> and btrfs_cleanup_ordered_extents() call btrfs_mark_ordered_io_finished(),
> which marks the ordered extent with BTRFS_ORDERED_IOERR and queues its
> completion without setting the flag:
> 
>    writeback (or a first fsync)             fsync
> 
>    writepage_delalloc()
>      cow_file_range() for range A
>        creates extent map and ordered
>        extent
>      cow_file_range() for range B fails
>      btrfs_mark_ordered_io_finished(A)
>        queues the completion
>                                             no dirty folios, no writeback
>                                             flag is not set, does not wait
>                                             btrfs_log_changed_extents()
>                                               logs the extent map of A
>                                             btrfs_sync_log()
>    btrfs_finish_one_ordered()
>      drops the extent map
>      frees the reserved extent
> 
> If the error was already reported, for example to a previous fsync that
> triggered the writeback, this fsync even returns success. After a power
> failure, replaying the log replaces data that was durable before with the
> unwritten extent, for which there are no checksums:
> 
>    BTRFS warning: csum hole found for disk bytenr range [14434304, 14438400)
>    BTRFS warning: csum failed root 5 ino 267 off 0 csum 0x8941f998 expected
>    csum 0x00000000 mirror 1
> 
> Both functions share can_finish_ordered_extent(), so set the flag there.

Sashiko reported a critical level problem, you may want to check it:

https://sashiko.dev/#/patchset/20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6%40toxicpanda.com

Thanks,
Qu

> 
> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
> CC: stable@vger.kernel.org # 6.10+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>   fs/btrfs/ordered-data.c | 62 ++++++++++++++++++++++++-------------------------
>   1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index df74c75d6c29..6543e99055f2 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -401,6 +401,37 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>   	if (!uptodate)
>   		btrfs_mark_ordered_extent_error(ordered);
>   
> +	/*
> +	 * If this is a COW write it means we created new extent maps for the
> +	 * range and they point to unwritten locations if we got an error either
> +	 * before submitting a bio or during IO.
> +	 *
> +	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
> +	 * are queuing its completion once all its IO is done. During completion,
> +	 * at btrfs_finish_one_ordered(), we will drop the extent maps for the
> +	 * unwritten extents.
> +	 *
> +	 * However because completion runs in a work queue we can end up having
> +	 * a fast fsync running before that. In the case of direct IO, once we
> +	 * unlock the inode the fsync might start, and we queue the completion
> +	 * before unlocking the inode. In the case of buffered IO when writeback
> +	 * finishes (end_bbio_data_write()) we queue the completion, so if the
> +	 * writeback was triggered by a fast fsync, the fsync might start
> +	 * logging before ordered extent completion runs in the work queue.
> +	 *
> +	 * The fast fsync will log file extent items based on the extent maps it
> +	 * finds, so if by the time it collects extent maps the ordered extent
> +	 * completion didn't happen yet, it will log file extent items that
> +	 * point to unwritten extents, resulting in a corruption if a crash
> +	 * happens and the log tree is replayed. Note that a fast fsync does not
> +	 * wait for completion of ordered extents in order to reduce latency.
> +	 *
> +	 * Set a flag in the inode so that the next fast fsync will wait for
> +	 * ordered extents to complete before starting to log.
> +	 */
> +	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> +		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
> +
>   	if (ordered->bytes_left)
>   		return false;
>   
> @@ -436,37 +467,6 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>   					uptodate);
>   	spin_unlock(&inode->ordered_tree_lock);
>   
> -	/*
> -	 * If this is a COW write it means we created new extent maps for the
> -	 * range and they point to unwritten locations if we got an error either
> -	 * before submitting a bio or during IO.
> -	 *
> -	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
> -	 * are queuing its completion below. During completion, at
> -	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
> -	 * unwritten extents.
> -	 *
> -	 * However because completion runs in a work queue we can end up having
> -	 * a fast fsync running before that. In the case of direct IO, once we
> -	 * unlock the inode the fsync might start, and we queue the completion
> -	 * before unlocking the inode. In the case of buffered IO when writeback
> -	 * finishes (end_bbio_data_write()) we queue the completion, so if the
> -	 * writeback was triggered by a fast fsync, the fsync might start
> -	 * logging before ordered extent completion runs in the work queue.
> -	 *
> -	 * The fast fsync will log file extent items based on the extent maps it
> -	 * finds, so if by the time it collects extent maps the ordered extent
> -	 * completion didn't happen yet, it will log file extent items that
> -	 * point to unwritten extents, resulting in a corruption if a crash
> -	 * happens and the log tree is replayed. Note that a fast fsync does not
> -	 * wait for completion of ordered extents in order to reduce latency.
> -	 *
> -	 * Set a flag in the inode so that the next fast fsync will wait for
> -	 * ordered extents to complete before starting to log.
> -	 */
> -	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> -		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
> -
>   	if (ret)
>   		btrfs_queue_ordered_fn(ordered);
>   }
> 

