Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794860164;
	b=vvO5ZP3WX/FznqexADsRlHn2Y0uTnGFtCjMeFkx3Ee2RL2NeZJA7ey3GnzNZBCpQJIc+
	 fCICiQKjb6DLKB2PQzW9WGMmDg7ghx3BUwO0/boT9cAF5xWfRucMc1qCzw28XZ97Ft4k0
	 GKw8I6DNCwViONI2+k90yu5ovm6F+BeORTRE944fHKCfb2d7A8lN2Obo2X1azWgKK6/xh
	 IB7LqIdb+4U5m0IOdrM9gIBhgw3ddFQfPNDBkyXuOsvvZRwzbJs0XWbnMratmh73D/aZ2
	 lm6vtpk5c2dYEtMS/1VKur2pKmzzVC7qYprwEnmJj0Ek3T+6/+u4HQMT55dInYoacVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794860164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ysZ/COKGyqWRb6MjKbJedUJPpWIgUji0lcxzJ600YtI=;
	b=GojVgCFwllQAsPrDyxOyqv3T2LfZsczF1k8/4KzNKcLcUil4zkzxpLyvKMokrcbEUzzS
	 LIVapLUcQqvRvJ5ejMiza1/0EyVrEGUqSRb+R0VxuIDq/hLbvap153Lw+eCs70Y9Mc4n2
	 8aZSJARwiDnn688YHjGBkpuHdIUrp/BOOwpl/Q0Rc3qkjY3d5Qp58E8E5dJseNIvRcBC7
	 uHdYUbn+M5JOGeumQfAR40T/qWLZDbXHM/QzJs2Q0F5eUsKGLIKL3MbC+yw87WIO8QVMB
	 r34Gwq4Q3gu/fBRGjDM4itu7/RYkvrVdjnkvdnUimHkQ+rxFkQ4eXT2JRftZW+4fIeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=S37b+KJU;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFAF606A322
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAFAF606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=S37b+KJU
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so579075466b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794860162; x=1795464962; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ysZ/COKGyqWRb6MjKbJedUJPpWIgUji0lcxzJ600YtI=;
        b=S37b+KJUIy8DRcXRIqgL9cHJBwXGpzmbVYFEzKxvBPguBw6kJvTilX6Op8th0KgUF5
         K5M2uTmMCIM1iu9KBl4eimgfxbq1YT/Rrl/TNNJYmx58dzkIVqzgdsEZVqBNsQ0u1DgX
         DLu6XbJvhXul+vtrSLmiDLnYDBGgC2egHnFEIhcaRYnbSfoSdds2B5BGFackHWLHYcmd
         OJm4dJHOIkDbiOfvF6W7bTM26TrAbC425tRAQB9bjimWjGOjvRFugvP6vfZbJ1n6t4BZ
         XjbLB96au5d5oF33nU3ac7Faq4IO4Xx0GWLG0Sj14hFKQeD1eZsEyec37ZBpNxqASzO+
         +Tag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794860162; x=1795464962;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ysZ/COKGyqWRb6MjKbJedUJPpWIgUji0lcxzJ600YtI=;
        b=sIaUWki44HICt6gm6Y9bfZGjGYZ5hs6j1MNl2bH7W3/uA/3G7gwMEvOcNG29qPqC/f
         PxZu8FP4CQEQLBLIL4frV/CiuT7Bw13qXO4K843AhvEz1Nc6R7nzUtRpUcAfd0jl372t
         BEdOKL0XNVPcQ5riD01M926A2bQVJKiWHhLyEtOH3e+/hQqOWUawr27ctKwjMeyUJ/t7
         9sLLmYlPOlY5k5dS0oqzF2IuKjF5tUfSQk1TIzZ87wFmDrZtN794cek4W7j15+CDaHLX
         o/SGy0Qw/EqKGg4efv/B3ygzLEwziEE4+TEWEKsfXnDhpGurkKjhryYc1m1XATS4j+tA
         sgKw==
X-Forwarded-Encrypted: i=1; AL+hErFtPU2JBb3C2527Zy+2jMUht6CHg8aF7nQy8rv/O0qIIJLy+l18Nvuk7YHrcsDLZgm7G9OGoO8wB+1bFg==@vger.kernel.org
X-Gm-Message-State: APuU4Z8CdSwmo4V5KwShq1nxcs67w052zmKANROrBv6f1MUXfspUIKkp
	ShgvQXtM918AudDumZ1nNwCfd6vu189uyCq7uQ4+LIaNvwwjDEdnKUKCgFI5gDwPHHQ=
X-Gm-Gg: AYBFou2dwQgAq17yb2Dm4SSU6wZ/P1l6Lgp9wejt4Z/gmlQUJW/2FqI/yoIrmLhNmgh
	r1eho0/zk7vm2rwdqrVevRh2/4git8+JpzzR9EWVif4trBhVtjW5VPEIr764bWOBsiNY6OfGQKx
	uDXgcnsdPwCAy4DhZprJh+8bJNyyX9v6GIrHVY5zXIXyl/H7oUG2kQWCMKVf5MHRtHG7f921dvj
	uz2lFEc/N5wuAnYSouDxllnFNK15x9kK7y3FZxZ/FC/k7rj1rlupHsbpiz4eFshxq6/NANvEgTV
	UEGoAf8udQ+8pRhDFblF8VrarDjZS07x5hGny5PcvMo85swhFqM4aXb56Tz/sdp3xioswtUY3zk
	3PFPI/pvwWIbLC1jwmT95OxPqieiqK/bWcvl/LF+Uxy/Bt0u8RYFZOoBBrcDhvNITDNH7ILsw5X
	zELR0qSKbKLcszJlu7zpbAjFHQ70mHZz1StJGVBMjbWlYQf/VjhDR9Q3irPNMFF60d1ApNHrhPQ
	/zbuPvCcDaoUr1OuIxIF9qVG6IsSWA1UbausbHwE+taZhKt9pNRy9kDe2giVPDk1HL4bFJ86sCY
	2CspyhpYl4skf8739oA34Q==
X-Received: by 2002:a17:907:3e06:b0:c50:5186:a429 with SMTP id a640c23a62f3a-c50963c2b24mr1041921966b.37.1794860161681;
        Mon, 16 Nov 2026 12:16:01 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abd063e8sm651282a91.8.2026.11.16.12.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 12:15:59 -0800 (PST)
Message-ID: <b26ad241-0ea0-4536-9a69-15b5b74748c3@suse.com>
Date: Tue, 17 Nov 2026 06:45:55 +1030
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
Subject: Re: [PATCH] btrfs: fix delayed inode count leak after failure to
 delete inode ref
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <44026acd9104694d8d08a19dc33a8b06aefc392f.1794829388.git.fdmanana@suse.com>
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
In-Reply-To: <44026acd9104694d8d08a19dc33a8b06aefc392f.1794829388.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/16 22:39, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When updating a delayed inode, if we have an inode ref to delete (the flag
> BTRFS_DELAYED_NODE_DEL_IREF is set) and we fail the deletion of the inode
> ref item (if it's in another leaf), we abort the transaction and then
> never release the delayed count for the inode ref deletion (by calling
> btrfs_release_delayed_iref()), resulting in a permanent leak of the
> delayed inode.
> 
> Fix this by jumping to the 'out' label instead and removing the now no
> longer necessary 'err_out' label.
> 
> Fixes: 67de11769bd5 ("Btrfs: introduce the delayed inode ref deletion for the single link inode")
> Link: https://sashiko.dev/#/bug/linux-3520c6eb-7928-477d-b369-9caff2b98d10
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/delayed-inode.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 333ce8b52489..295329d67b21 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1053,7 +1053,7 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
>   		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>   		if (unlikely(ret < 0)) {
>   			btrfs_abort_transaction(trans, ret);
> -			goto err_out;
> +			goto out;
>   		}
>   		ASSERT(ret > 0);
>   		ASSERT(path->slots[0] > 0);
> @@ -1081,7 +1081,6 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
>   out:
>   	btrfs_release_delayed_iref(node);
>   	btrfs_release_path(path);
> -err_out:
>   	btrfs_delayed_inode_release_metadata(fs_info, node, (ret < 0));
>   	btrfs_release_delayed_inode(node);
>   	return ret;

