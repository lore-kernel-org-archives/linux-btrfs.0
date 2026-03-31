Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3072B275B03
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918709; cv=none; b=panLkjnEf+32Ydnixzk0USYQDBXYWyU/20C4NbIMd+YSTZH0/2NPaoUBdiAyFXeFrF+2nUmku2eO4ZsDzk5TkQ9/b1j3oB2SisowiucI0uG8mvDcxSMFh3CWUs6VwCXfNHxmyZPbVHn/ytUvlMSrNXr3AW+15jR4tEyDi8v+hjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918709; c=relaxed/simple;
	bh=uuOmCkF7+LqDYpuPVxHJB7ZvCwl+/vp53VHjaXVbBtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TdXDe/rftEgtQvCqPNR6lNFRsDDVZ8XxPmaoILOlxGwn0DLfZYKvqGsoGnIVR71kdL0yhLxIvB5qoHu9obaq1fewK1MfenRELVLH8qWMwtJdsHCVl0lxucGdmP4aartXbSX9uaNsPtqxh/jq6DzFlePCy2YUC+1Y+zQwl4H/VjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p9AYvTrB; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p9AYvTrB"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c763c294cccso3451682a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 17:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774918707; x=1775523507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q/4h3IAq/FqkzkZ54pVD2Vtq/ec2R7387m1/bvMp3g8=;
        b=p9AYvTrBkCHMVc9E/c4yhyiXpzbbPylJXmLp2yfxjssGfYh7eRxgEFCUMfvBEo/xJH
         Z27Z5kO8stDbp+za/gXO1+Q04nLehLmOxeBk63j/XbZwxRKVhmUh31OjNbDRCXdwDZvW
         5/IgUjGXYoe1Lfe5EsK+hD4DLDCF0D8JRtpcn+wDWD3exFK8mQMbjea+LG5mgkpkDsUK
         fV7cDYwqRxfIO6Z+PoDA+sGXc3DqCpBoQD/VwZrKMALUWRhB4a1zC6bmrpLCI6z3lbak
         kISFymf/Ik8p5i+1hY5azb1iyQ+INbawNRH73Taam38cDb+UGEd6zPA2/B8z294Ozw9h
         TxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774918707; x=1775523507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q/4h3IAq/FqkzkZ54pVD2Vtq/ec2R7387m1/bvMp3g8=;
        b=JtTaZqnewWs3TNykHh+4+C06NtUMASJA7Pvm3EdLcBJCoRBF3Neo63vS6FkObIhNWp
         skqA9+62lMFf8wg+H9VNZJftewj3vbHoS4yTSF53ViggRqfUHQtKvJp1LN0urBU9/Rw8
         s23cgByxOUDNEZfwOwpWOcOQBtsFSNzUPVpA4mXWzFvkUT+g6wNXueyTOJ9AALUi4kGR
         w9gzPzFVEoXTEBlhf+ZuTinkw7vRqdoIoPNl2cQHeBNeWzwLnSzpCOdwBqbnPfD0Do9W
         CK23SrjxDqRY5ddlbiA1lnXmntjF9fG/IfCfQhUvGcvUf9VfJqH1ezJjOsuuYtMX4SbB
         D2Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUWTpvxh1TW5ZRUx4zdLQirYUDd3ccdLQ8GYfZ7OMVrSD3b6rhWOCMgBSLbad2qlQ89Bfm3VtB4fTgAlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWO7nhHajil6qCaVL9CZqy3dfCTn6b/Wy/sioLK6SLT/zqda7n
	nbYOnVLfcQ2MmR5cQLffHyUgmThx+YmjpeQphTUDZUSval0/N5coiaPrrRTaC9Vb
X-Gm-Gg: ATEYQzySIEXoj+FerfkUaTzIPXwYIAHt0Xt+pepMbbRg+YuMz7RTyIDXLo1tIxrbNmD
	mlAjxXGtxTXWfZ6X+sRYxppNNi5osmhXr9OAnFamT5a2X1lRcMlu3azcUZfoLLdHLGbGOX48rqB
	Jl70SwAcHM1Qu4/+8Q8e4FBshIVmTaocddv1rlRV94EZ7raynTrKAxYxd3plgWY2jYqojODb1AK
	e//fx4f2T8lxNFSI0KnGKcN07tPwDyuM498VDvkbhf+uLEO0IhwJWBkEN1tEal3qdhjuUQ1tGmS
	CWar+3TYkhJeObjGP+D/MZ6x6+xvHm11VpujWejRE9lJ7a6M+C/23zT6S2F170/rWK+oBiUTEUW
	d43LwKQaPnOehS62F0z2pdi2WVHS6jdZ7hsuIEpOhSSfTn2FDL0LdRDBo0VFEHt5CpO7ebnwRt3
	DLv49IOVFXZlwj551Jm5JLAAu3S6wojXfxaTTw2w==
X-Received: by 2002:a05:6300:50e:10b0:39e:d294:629c with SMTP id adf61e73a8af0-39ed294635emr2195752637.43.1774918707333;
        Mon, 30 Mar 2026 17:58:27 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76917d843esm8245841a12.29.2026.03.30.17.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 17:58:26 -0700 (PDT)
Message-ID: <e8ba249a-0f92-4824-9ce3-07995b78cd51@gmail.com>
Date: Tue, 31 Mar 2026 08:58:24 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: only invalidate btree inode pages after all ebs
 are released
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/3/26 06:21, Qu Wenruo wrote:
> In close_ctree(), we call invalidate_inode_pages2() to invalidate all
> pages from btree inode.
> 
> But the problem is, it never returns 0, but always -EBUSY.
> 
> The problem is that we are still holding all the essential tree root
> nodes, thus pages hodling those tree blocks can not be invalidated thus
> invalidate_inode_pages2() always return -EBUSY.
> 
> This is also against the error cleanup path of open_ctree(), which
> properly free all root pointers before calling invalidate_inode_pages().
> 
> So fix the order by delaying invalidate_inode_pages2() until we have
> freed all root pointers.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> In theory we should also check the return value from
> invalidate_inode_pages2(), which can still return -EBUSY if we have
> pending metadata readahead, but that's a problem Teng Liu is working on
> and I don't want to take credit from him.
> ---
>  fs/btrfs/disk-io.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c835141ee384..75f3c6c4c249 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4434,13 +4434,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>  
>  	btrfs_put_block_group_cache(fs_info);
>  
> -	/*
> -	 * we must make sure there is not any read request to
> -	 * submit after we stopping all workers.
> -	 */
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> -	btrfs_stop_all_workers(fs_info);
> -
>  	/* We shouldn't have any transaction open at this point */
>  	warn_about_uncommitted_trans(fs_info);
>  
> @@ -4448,6 +4441,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>  	free_root_pointers(fs_info, true);
>  	btrfs_free_fs_roots(fs_info);
>  
> +	/*
> +	 * we must make sure there is not any read request to
> +	 * submit after we stopping all workers.
> +	 */
> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	btrfs_stop_all_workers(fs_info);
> +
>  	/*
>  	 * We must free the block groups after dropping the fs_roots as we could
>  	 * have had an IO error and have left over tree log blocks that aren't


Lgtm.

Reviewed-by: Anand Jain <asj@kernel.org>



