Received: from mail-qk2-f4.google.com (mail-qk2-f4.google.com [74.125.230.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FB22E7391
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129620; cv=pass; b=GaEchTuT+rUcbmrtFK8x5fwE4a9LE4ELhoFZ98BWYauWLEoGGqBxTE7Wy5cDECESRlxM4BMPRG2Pc9JC2xspZZxD7JCPtpoalYhbiXvyjwtW+X4rrsNf0uGMmI531UGY+2yfp7KV/TY54qZtCHd9ZEsf9ts4IzGQPTzcjLdZXf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129620; c=relaxed/simple;
	bh=vTwFJylEwnMxtbaQ6O6lAC1stXlat+Z+jFehP6eqhbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=HAGNuow5Ex4fcHIOFMIdEWYEsElI4GfezsN2G8HCinUa5V4x6b8LLSmHGZru1n3LdlfwWCIx2clKy15o201aVAm4JIcGx2spC2zTb4lIYrJAyCrXHeAC16d+lSyg73vgYipQgNhYbIUn8p2mL616jEg8OF3A+b46ce/MAMEN7D4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Crvhdv5B; arc=pass smtp.client-ip=74.125.230.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Crvhdv5B"
Received: by mail-qk2-f4.google.com with SMTP id d75a77b69052e-519f2d3e368so8681cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 05:00:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782129618; cv=none;
        d=google.com; s=arc-20240605;
        b=VyRAV7ursg5w+Xo6J7dRH9xva57FOkbp64O3TNotPODNp77+JBiQKSHl/kYq7qobvM
         AjzrGwsJziD/WaCEfsEj/eHmKS4S8UipInfqLq1XREVkvSkL3qi+xZjz9VWdqVboREFK
         xiMYi7mBcfdYy5amHAbF4g/aPxsmphO6k8mr4iJkD+YLK7ZDYfbH+GpIggA2VQFj5Y6E
         srHgKk92CaXgqLlApe+rcKiIFs0KLa1v79q2t8Nbdxhy/dGqXHJgkoE5up7nx+Z3jI8t
         V6ndRdmZ3zork2oMUpADorRdRVJKLjaEhE4bGkM6Xg+TrScjoP+2luUC01Xv5NNkyNqs
         Yhng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=jpZPtTGX8n2HJfRJ24Trsr7lU3k3OKGDcVmYvaONqqE=;
        fh=Zbsw1R8MprFM1My2oUAmRUYW5z+w+nIcfxVYo3OQD34=;
        b=DcnJzPcif4njkHDv1uvteI6AX7OBDZyNv8hIWUgo4xlIVckW4hOgweM9sG+ks0jm3W
         QsWM1jSJTZQ6D6qDxFXqGJhgEbroPJ4UtzUs/702z9HDsKaaSew9l37j5gQia0MwBlSl
         aSlyKpiWJ3S4RZh3LWbMwAKYjw3et9VQzLTJYFpZQV/RF6M6spKvSJF7ISv+wfAereo7
         PA9+fFsrp9G8Es/qEZLX/lJ5Pcea6Ph3aoQPHL/gXYU9+YfH6AoYV9escSEXtlBvhfsX
         td86/TPsfiERBfrtJeiDLa4bQ5Bd+EOH6IpHpF9Hijh9+dtmby3eylEgL9/Od2l96pyn
         tXPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129618; x=1782734418; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jpZPtTGX8n2HJfRJ24Trsr7lU3k3OKGDcVmYvaONqqE=;
        b=Crvhdv5BGxQ5JItuQrNShxuZGg2p0hnGKbxlNGupfXO5xmrGxA7h52HP2TpbvOKfb9
         rj4CA4onpAUY3bAHFqRCxHiBoEObmDynw+9Xo0HdfU1t6JIQ2riTkf8WpRgItr/EtbM/
         yHflHKQ+f6sGs3njbFVGadUPmrtRv1j/eiEo6t3vUs1fLAf4ZcmMuubdlGnQAPTSGb4w
         w4Hdn56wjkA4uhxUrwe/f2rpwfLpgwWBcbOu+HQRVnynZ+3PMhwZL7j73XLzq4bl9UMw
         SjU794fglHWiPdOIbQKkXYoUC8zhShuxx5jkZlZKjVIDSF0CBJ5DJNdAElySenqOZW02
         h/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129618; x=1782734418;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpZPtTGX8n2HJfRJ24Trsr7lU3k3OKGDcVmYvaONqqE=;
        b=dXcMpUDR1VkAd+mqxdcphb1V9kaRXDZpuo/Pz+blhMK72ktCpz4OA6VMSm4ubJ5234
         F659XlYA6zx7trTsmfW+qsmEwyTFrJXd+inEhm4pceJDEl494X3XQPhdGP0xcfx8qyi6
         VWZOIdckwNTY6spjFMm4+sKD8MwofJp2t1D+4VMoDkjHwebBjr1K7hJ1PqhrjSv9655Q
         EbCuy9d7qf/wb9K/q1PMPuu668/Odqf6rGxAAcsQ0kV09rkTq2Uqg6um4MaAzw76Nhco
         4RUYiUQxOD2capIvbNdj9MYkQJkFT3qevR3tPofL5IVSBLZMFTGzR8Fbb14R6c00Ru+6
         6ITQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Aab//JVF6v0x6xpeySEjKUVJtRXDrxmjgX7XMhCJVRL3BUFtQjoMWAj4urFvtp5Tvf9ZdV3QF4XDVfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkfNvcjbgN3NYnW757Ugp85CJhVWGON1SkA3YNPFeigsQO28Z5
	TioWgqmaa9lJAcCCjkdxq+NTW0zJMvaKIv0tcjdbohfKyLkRgzCQf7fU1wp8Rqz7FKKsy2YEnIt
	nYNVrMddrkjd3ifYnJPKAigw+rnFnV8RFtSEh5gnRbEfm
X-Gm-Gg: AfdE7ckrjMUXIOpZYTS4jS6SsKsBRIYFayZb1XenxVj/RotJxAGRTTwMQspf+w3xGuD
	b0d0Vlet8LjqkwAGFFJBhqREBYr8V8W05aa0BZYAhUxS7IY7fxj5x5cmihSaqtkHCtQ3/8ZJZJD
	RlzsdyTe2/BIV0te5jZjE8R8b6fDHsHBxxk5atVkipeoPxh7dRW1206fruqR+JMM7p3kZGEUmCF
	ND8aDX87VPNuscLWgbOkWFA/26Dw6YlLG6NtfXnJEEIpMIYXWCXQScpV3GJCy4jiNO/RqqmFIVP
	dDMoBP6CpHVANkcIUqAMUvFJVzpC8w==
X-Received: by 2002:a05:622a:1a85:b0:517:6a56:accf with SMTP id
 d75a77b69052e-51a4f417e62mr2011731cf.1.1782129618209; Mon, 22 Jun 2026
 05:00:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
In-Reply-To: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
From: sun k <sunk67188@gmail.com>
Date: Mon, 22 Jun 2026 20:00:06 +0800
X-Gm-Features: AVVi8CfrgcbrWccQlQHS_UGkUdAYUWDKkX4CFGWiz0kGdN1JHRIXaqTg-1Hry74
Message-ID: <CAAuSuOoNE4wgaqx-5MH_cqpeu0MyrUikrVS98K2H4xLnRW5mxA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks good.

Reviewed-by: Sun YangKai <sunk67188@gmail.com>

BTW, this reminds me the print-tree result of dir items that points to a
subvol, which currently looks like this:

item 4 key (256 DIR_ITEM 224155391) itemoff 15967 itemsize 48
                location key (43123 ROOT_ITEM 18446744073709551615) type DIR
                transid 896627 data_len 0 name_len 18
                name: home.20260621T2000

And I wonder if we can also print the location key's offset field as s64
to make it easier to read.

Thanks,
Sun YangKai


On 2026/6/21 17:11, Qu Wenruo wrote:
> When dumpping a tree block, btrfs_header::owner is printed as
> unsigned, which can result in numbers that are hard to read, e.g:
>
>   BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607
>
> For the above output, 18446744073709551607 is (s64)-9, the root id of data
> reloc tree.
>
> Despite those pre-defined root ids that are already negative, existing
> subvolume trees will not have any negative values, as subvolume trees can
> only utilize the lower 48 bits, so there will be no output change for
> existing subvolumes, thus no extra confusion.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/print-tree.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> index 87e60a2d4bd8..53e726119ca7 100644
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> @@ -449,9 +449,9 @@ void btrfs_print_leaf(const struct extent_buffer *l)
>       nr = btrfs_header_nritems(l);
>
>       btrfs_info(fs_info,
> -                "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
> +                "leaf %llu gen %llu total ptrs %d free space %d owner %lld",
>                  btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
> -                btrfs_leaf_free_space(l), btrfs_header_owner(l));
> +                btrfs_leaf_free_space(l), (s64)btrfs_header_owner(l));
>       print_eb_refs_lock(l);
>       for (i = 0 ; i < nr ; i++) {
>               char key_buf[KEY_TYPE_BUF_SIZE];
> @@ -600,10 +600,10 @@ void btrfs_print_tree(const struct extent_buffer *c, bool follow)
>               return;
>       }
>       btrfs_info(fs_info,
> -                "node %llu level %d gen %llu total ptrs %d free spc %u owner %llu",
> +                "node %llu level %d gen %llu total ptrs %d free spc %u owner %lld",
>                  btrfs_header_bytenr(c), level, btrfs_header_generation(c),
>                  nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
> -                btrfs_header_owner(c));
> +                (s64)btrfs_header_owner(c));
>       print_eb_refs_lock(c);
>       for (i = 0; i < nr; i++) {
>               btrfs_node_key_to_cpu(c, &key, i);
