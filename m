Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793680841;
	b=NhvTsFHGeoixvS5wQCqDA0IoGKBLI3qBYGpH4tQDbW/9cJe+sUZaQ2rYmkUQ3D8FSDh0
	 02J5kayYmK0elaE4BamwsUmhy0EHtSfltf1shjYpbDGzzFOlF3kmUywZMmVJNwJ7dppUH
	 HW8xXAXk9M3espl3o6DYdcF3fropH9LaRjLv2mMSONvNVvVvJaP5HXGBmZI5NDs2tXX3W
	 yVMjW3UneZQZU58uHBj6AKzkGBzsF86OgpglTOG1foOjIMEFOLz9YO/UQesHAlQuSSt4t
	 2IHuB79qNnLzthObXHM8raj5jlYi+/ByUwPzc0iaPl1i0gXvFaW/U3gwUadlk3yDUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793680841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=75PcmoaRkELEZYnSZBhFOQlg0FMdwQhkoGGy8J7+las=;
	b=vZYElg+c1OgmFKFTUzTrD3L80oQk9ha02mpFTdlaM+sGCbWHMTQM1Hy+JsmjI9daGMxK
	 NqvFfSjFhqu6x4jjTMVInWMDc0mpnV2Lj6lN2qIgV/g+V42XUZxoQU/ZdaYbLMwET+g29
	 SN2XZrLJhy41r35bfIV09/bAYe4Ylcht9hiP651AFXkpas+D35WVW+rGVh8eKxTUp53TO
	 mLfWfkdXTWvv455hFgHgkhTjveb62o8fDDHRIZQBQ1GQGje29y8k3UXZfJFuCWtAgdTky
	 ubL/5htAY+OS/0++NBxnyTsLvBe0yfmkobYG3Tu309K9/Ik3LMQ3k9VZjfNeRyjUXgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Z8LulxRY;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FB2606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 04:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6FB2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Z8LulxRY
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so38634395e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 20:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793680839; x=1794285639; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75PcmoaRkELEZYnSZBhFOQlg0FMdwQhkoGGy8J7+las=;
        b=Z8LulxRYwjxQ0AikjHu6lCMhpe7fWgPnRc+8gbdBOqQZgPKav17mTknrIFKgbRszaq
         6q+1btt92F+xz/pNTdOGCphDyzPuxUBARCKZjd06qPfBiNPFenh+PpTIt6JV2UrDW90h
         1JA5321kAUn/r9I3kauxqCTmv3FLaSCYUBYdsGn8RqWdr3/2NLx8o0/VXQNW7azMtK1O
         lU3epGIyF09j/rooAg8f/xM7pjzQDIQoN5HJQDjf91oKUQ5uco9kl+j+g7ZGXdFkZV1N
         x+iAKKcP3y/C65np1iOe+lwC6pIANoV8MfqZxKI62nAXEvEoHtBQfh4KYRMO6jcmd8RH
         E3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793680839; x=1794285639;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=75PcmoaRkELEZYnSZBhFOQlg0FMdwQhkoGGy8J7+las=;
        b=sJXWYwxtSUuGdP+SRM2En28aWi/xKMszFdDSH6mAwTWrqyRbexHLS54DJACGbr6i+R
         PzXDqfO1xhXaNZDg18FYoQaBNBvaUraF1U7dZRTdPb3V0+shGcUbSwjWnSGT9wd9zYsO
         UhZEKkY6C++JRz0n06QRU7CLPqCLA4yGjpciYCQS10zduJAyVhsO95iXFZATEMAbbYZ0
         MI1GldxbnrFE2kE4kQU9u3RWkoBlXPNzVi3O9XMuNfrKJHQ/5N0koMabWLfhuwNdo95q
         lhdLBj4sWHSsOfaCHoZXy1Zst08bMAHG1yi6NHjBl3BNVlxeGJQW8Hip2mF3FaEqy4WV
         fnbA==
X-Forwarded-Encrypted: i=1; AKwUvBzTht5r33J2vawkX/+W9O7MuIR8qUbYH6olVfy4XbMrBANbxniojXMicviTslPEQ4+ciGXP7itDu2JPgg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIvGe+3Syk8qJXBxSVedP6/upkZeSVyIqj9tO4PdLYPC+WrSNHe
	bro2HdN3wedg2WBeLm948MQTHd/yVA732EW1E7U2LrFKtO/OmuTnh9IK60ioK81u8i4=
X-Gm-Gg: AYBFou3CuaCSacekP3ogp5a8nj4xTVEZO/HDCGhbpllwGb4XZ+KeUA9e6V5YD7uZyiI
	F+TlNIZ7aE+MPEFQu2FvIHi6Z3//+0TcTxbasH3Jp23NmCZapbV/cElse6JMUGkNo0vQTP23Gus
	6K7UlFV07+FLLg4xua1yWTmt8F0hF6fgImbOps87JNRK17H5CXMH6TOtPuLXHUQFCmAs6RpOCa/
	/snFwKS6YspdFdpAuhH+aoOS4iKL6uk3JXDNupuGGLje3f2zvwP0ptLiNwB2DJzYbSBuHTfwnCw
	sOJixmY9B5YJVQYlMqJqzV+je5YUe5N6majWoDTfCEfEfwzNLdzgfR+Z9ByhBasCodgXbLAGSqx
	1N07ukVI4ibtyoaHF2kMY2GlbhffA+h1/bYeGC75PBJZewA7NOimgaBg00ue/4wjKShS5UxTd5m
	/ZX7tV8yUgUJbjW17jbU0zHw03hXSQhZlYW5i6sE7dRfL4XSqAFD5nHq/Zsjt/BUzLqOABfzkol
	/8YPgPVVxC0QySk4uzgyQ+i9UBWCaq3sRqRSp4G1KNsiSb+FmkBkJYe2yhN43r69muYduCzjuqI
	YsRWisx/uuWt36RzhFjv
X-Received: by 2002:a05:600c:6099:b0:4a1:992f:d0e7 with SMTP id 5b1f17b1804b1-4ac180f2ac5mr251204285e9.16.1793680839161;
        Mon, 02 Nov 2026 20:40:39 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a9e2ed3sm37427610c88.19.2026.11.02.20.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 20:40:38 -0800 (PST)
Message-ID: <9b8d9f77-981e-4bcc-9d30-5c53a2c1d1b2@suse.com>
Date: Tue, 3 Nov 2026 15:10:30 +1030
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
Subject: Re: [PATCH 2/2] btrfs: tree-checker: reject extent owner ref without
 simple quota
To: Siddharth Mishra <smish149@asu.edu>, David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103034932.1790235-1-smish149@asu.edu>
 <20261103034932.1790235-3-smish149@asu.edu>
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
In-Reply-To: <20261103034932.1790235-3-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/3 14:19, Siddharth Mishra 写道:
> [BUG]
> An extent item can contain an owner ref.  The owner ref is correct only
> when the super block has the SIMPLE_QUOTA bit.  If the bit is not set,
> check_extent_item() gives a WARN_ON() and then accepts the leaf :
> 
> 	case BTRFS_EXTENT_OWNER_REF_KEY:
> 		WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
> 		break;
> 
> For all other incorrect inline refs, check_extent_item() returns
> -EUCLEAN.  After the tree-checker accepts the leaf, a free of the extent
> calls btrfs_get_extent_inline_ref_type().  This function ASSERT()s the
> SIMPLE_QUOTA bit.
> 
> I made a crafted image : an owner ref, no SIMPLE_QUOTA bit, and no quota
> tree.  On a kernel with CONFIG_BTRFS_ASSERT=y, I removed the file of the
> extent.  At the next commit, btrfs frees the extent and gives :

I don't think this should go into BUG section, but CAUSE.

> 
>    WARNING: fs/btrfs/tree-checker.c:1782 at __btrfs_check_leaf
>    assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
>    in fs/btrfs/extent-tree.c:354
>    kernel BUG at fs/btrfs/extent-tree.c:354!
>    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:btrfs_get_extent_inline_ref_type.cold
>    (fs/btrfs/extent-tree.c:354)
>    Call Trace:
>     lookup_inline_extent_backref (fs/btrfs/extent-tree.c:919)
>     lookup_extent_backref (fs/btrfs/extent-tree.c:1100)
>     __btrfs_free_extent.isra.0 (fs/btrfs/extent-tree.c:3319)
>     __btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2134)
>     btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2246)
>     btrfs_commit_transaction (fs/btrfs/transaction.c:2278)
>     ksys_sync (fs/sync.c:104)
> 
> Without CONFIG_BTRFS_ASSERT, the kernel gives only the WARN_ON().  Then
> btrfs continues to use the owner ref.
> 
> [CAUSE]
> For an owner ref without the SIMPLE_QUOTA bit, the tree-checker gives a
> WARN_ON() and keeps the leaf.  For all other inline ref types, it
> rejects the leaf.  Two sources can put owner refs without the
> SIMPLE_QUOTA bit on a disk : a damaged or crafted image, and a kernel
> without commit f2363e6fcc79 ("btrfs: fix transaction atomicity bug when
> enabling simple quotas").
> 
> [FIX]
> Reject the leaf with -EUCLEAN, as for all other incorrect inline refs.
> Then btrfs finds the problem when it reads the leaf, and the ASSERT() is
> not reached.
> 
> syzbot reported the WARN_ON() and the ASSERT() in 2024 without a
> reproducer.  Both reports were closed for inactivity.  At that time, the
> WARN_ON() was noted as something that "should be handled in a better
> way".  I found the cause during the analysis of a fuzzing report.  An AI
> tool helped.  I tested with a crafted image on btrfs for-next
> (d6f76ca0a70d).  Without the patch, the kernel gives the WARN_ON(), and
> the BUG above with CONFIG_BTRFS_ASSERT=y.  With the patch, the
> tree-checker rejects the leaf ("extent owner ref without simple quota")
> and the mount fails with -EIO.  There is no WARN_ON() and no BUG.  A
> clean simple quota filesystem still writes data, frees extents and
> mounts again without errors.  The fstests group qgroup has no new
> failure (34 passed, 3 not run here).  The crafted image and the commands
> are available on request.

Again, remove the last paragraph.

> 
> Link: https://syzkaller.appspot.com/bug?extid=d7d1fc7e21835ca19219
> Link: https://syzkaller.appspot.com/bug?extid=4983e68a6d77180bfe33
> Fixes: d9a620f77e33 ("btrfs: new inline ref storing owning subvol of data extents")

Again, I don't think this really counts as a fixes.

Or all hardening would be considered as a fix, which makes no sense.

> Cc: stable@vger.kernel.org # 6.7+
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>   fs/btrfs/tree-checker.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 0d75cb537..5c44bed99 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1779,7 +1779,11 @@ static int check_extent_item(struct extent_buffer *leaf,
>   			inline_refs += btrfs_shared_data_ref_count(leaf, sref);
>   			break;
>   		case BTRFS_EXTENT_OWNER_REF_KEY:
> -			WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
> +			if (unlikely(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA))) {
> +				extent_err(leaf, slot,
> +					   "extent owner ref without simple quota");
> +				return -EUCLEAN;
> +			}
>   			break;
>   		default:
>   			extent_err(leaf, slot, "unknown inline ref type: %u",

