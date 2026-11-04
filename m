Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793819619;
	b=atpyEsqrdMMd0D20mpF+JWjnB2DlPoPiqrcvV6SLFG/IvAcpR+PMjhhUaxXCCG0yD3Ey
	 gHhwJMqg4Q2zSC/tKJu9jCLIfAoyYWLiWfEIm0eRRCAGu/9F2thX2xWF267geUnVy0vIS
	 BV16R9o5nu0kGRrpGODQzLHTWML6I6s4pYeNmd/kHlQYhW3X2QPOdrB3sWnvk2M3sKwLv
	 SO1bqPD4ddUWGw5NHT0jwLwsQclFdsdjkzKh34jgiTAnP4WH04zOwxco5i3Z1qgNhayaD
	 UqhI9opzzegjG0rzbUFOnfaVs5U4roezefwkKkNF1UE+SqthLC7sxPm/0A4D9b4hC5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793819619;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=R/Zw9aXDdwSnJl1ZKIXFjhqLEWW0pCJMnlQQQIRFmbU=;
	b=gBrGA8WxH3pa/+cBADuxBSgalSOk0f0FrjlbA0oPWUGWg7rhbZh9yGSRNymFtA4HuGz3
	 +WH1BfdYbV5OfKEKSfreAcT7xwDKH1d+y8UX4bTAhAGxR7I8ytjuGGnOBkxW0A9NSGsdS
	 JRn5mRsS3/i4l2Tc5aUYmRmXrd0Ceeo9YjWW9lu1pja2jJp9JUixGHXXJzRKzjjucqZgw
	 31MXqqW0Mg7ODJOujM2kthPMQxz0vXNjUzoLpWPrWSMgPkRZKtnk67SSMiQhcZqyb/OAk
	 HDSnTVe16NFKKAgftUYbZpwFQ4zyUxQw0eRP+GBC4/jkVytoJUmSFVVyzoDcDE3pOiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=POZTX9LU;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=MH8LmMLt;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D3606A329
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:13:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F1D3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=POZTX9LU;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=MH8LmMLt
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D9FE47A010E
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 14:13:37 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 04 Nov 2026 14:13:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793819616; x=1793906016; bh=R/Zw9aXDdw
	SnJl1ZKIXFjhqLEWW0pCJMnlQQQIRFmbU=; b=POZTX9LU2E6wDR8Nk8+asgrzQo
	mtR8oUIR9YUGkoQZu6TZpu5yucBssLAS1/VJmIFkmNS4dXl7jdcrK3rmlnQssiXE
	hszPBz0F9wMNVGApxIQ0/IuhBnVsstgdip9iGWXasC74zxeUe7yRXMY06pijdHfi
	OzCOb5VQoQMaZv8HcCc4m2I1qTkYvOyNwUVdA/DSJz17OpEK46elDKc5/xuE9eba
	4ob93FOmSrdemKuzQq1WNcZWhfqz95xFO+1h3exDPuhtFJob9ynnVWXN6J4LzSI1
	Yvkel7UUcJXiN93aEWGRKsnH7rdmh1Qvj4NfZplZHAOzT9UqVfHr5fF1V88w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793819616; x=1793906016; bh=R/Zw9aXDdwSnJl1ZKIXFjhqLEWW0pCJMnlQ
	QQIRFmbU=; b=MH8LmMLtfylWiZNGUml7ghUGNIjs5o/++I86NbGdhlRL5uReTej
	kjFN21IS+cndRNhqsYo2D/iYka/oT20UtMe4g7yBBWnNTTZCtah/TZc8M5pZ2iqY
	cPmk3QtaLHOyW92HrB7n6aikdEPySuG0wmrLJUNDkhZ54hIXFCM0x73lnE1cPpIJ
	aynxMLixFuY/YhXf9r4fLoJ8J1ZMp85b9INZXkdP9TebDJofnYfIYTgoIVu0+NMs
	nqw2Q40cUO93uKxwB3w4yGO1bdVxrmWYv+y0/zEM288DMfBtL31U7pEFt+tAwjqZ
	s6S0byqcUbkOwkSCEp1w3A+oTHYEj+oOV5Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793819616; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:DJJMm1v4wT4bm71ublFBlUqJRrrkVUejMgKIUDcHFoUPS5Y
	e6LAsrpXaWEdEEhma2Ev1yUyiFxYfKPDG31w7VyEs19mZ08vAx3DTIJmCYXFoYOv
	/6z5/iJUWZWKeU2u7IrcNn8nmHdnENQ0UNb96AOJ8bMEldJI2Q7pRXTIToz3ptGK
	yA9HGc602jyAWppU3NjJvemJ2jNZxbR3zOOViAUDiqOfAFxbM3bbu0AP6bMzv23p
	gGSXVfM/WBmyjJOno4+KYIPZgcM0977e1bnvtKGe43ooliYnk1e39Bb2IbNenxjp
	4q/bw5vq+omI3RKrPFeWlj1ml5/y+ctWYX5vs0w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Do8AOxKL1PsfOei2cabABuc9oDk2PzvdE2E9ovZgXjE=:TQ1NRrE5MaF4AJMFyxsnn3nsn/bl1cE5HhilxM8818Q=;
X-ME-Sender: <xms:4IPrar7Uq59_38tKTfVYtW7gBQTIjSsgt0IGrRzES_PiNhVTiIwJ5A>
    <xme:4IPrahX_FVJ0WP5ilf6c9rdlEBiMYFM2uxtAkEq5Vy21Dwj31gHq6rapL6wV5cYh3
    18ruduXOJMMeYaqrzO3mmfyY4P6hi76b6VoojhgQCRogDw4FJUFcfIt>
X-ME-Received: <xmr:4IPrajJ27dzA2zkzrKZgGmfDmdPKKNeBL0LLQjt846bray0zUeDNqR57>
X-ME-Proxy-Cause: dmFkZTFKfU6gmjaNjQRv4742HxQNz5qcx43PvODO8cE3Klpvbcsys2xeAxDTiJH4S2RWI1
    Bpt+51ElFQGLyu6bY6plLJYbOmTBK1uGkS2ry0KT+xOVrbuzxxdyiPhLUV+PcVRWJ2YpSz
    4dqymtddmmnJJYnaXsDTphJx7vIqeQsy8L8VhZmVhnZekTEFGcEWgUuuadx3qnzcGihSiy
    2x+l5N1zaKj4UNT/qANWul4pfxzeALBBBlMMlidwJEmpsUA6SzOfVNMKfALwMI8MczuESS
    wZpnn2iIj75CbS4mp+kdNfjH5rokU/i8KyjYwywKwQvy3JqpGu8S+ftex0SAOCXFeVTgGT
    Mkg/R0HVYIho62aIg4LI2fegY5nVCJs96m6+LgpwZjS+syCEQ5AicE6wP1s5an0NQcoZeE
    Tg3QTl7HaOgUoYQAWIUxsJGzmkQ0jX7JuUw7a23XsZl+FO5jEOJgOtu17xUDirEQ5Hs0II
    9jBKzjdY0q8K66dMwQ1+k5PAemiUlmSfbTgqqD6ZVDh/ZzHhchf6xQNJXz0VI8efAWK2N0
    ZBrytpVzvbTq6MAnmK2sS1/y1m7Vq0qgZPytkNGmP1SU7cKwxr6DrCPvP8pSuwbxO9aXnH
    irAtSgAWFR/607Tj+2RJ54ntbBeQMEuKbdVuAbkI0mJaxD7xk/x7zoT9j1Nw
X-ME-Proxy: <xmx:4IPrajsmMDPyBCrYxVGYYfCzrmlYTBvdthRetLLV4cwA7wdTMmye1w>
    <xmx:4IPragKC4-nwDO_cuo5rsCQZ76l9gOH4Tu1KspjXcMPo0j3l2MXGtw>
    <xmx:4IPrajMo-cLUU6Cyanm0RON7nVYiud8w5CNXJSXtYu61YOKQBdgh1w>
    <xmx:4IPrarXHVYONAtwO7NIqjUg3uP3EUCT7uv_08NgVNgl0gEsBQGksGA>
    <xmx:4IPrajQQUWOnqdw0eAen1Pu_kvMvMR9LvuEjbVoI6yETpFPXXF-fX5az>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 14:13:36 -0500 (EST)
Date: Wed, 4 Nov 2026 11:13:50 -0800
From: Boris Burkov <boris@bur.io>
To: Siddharth Mishra <smish149@asu.edu>
Cc: dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com, fdmanana@suse.com,
	mason@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: skip tree blocks in
 btrfs_get_extent_owner_root()
Message-ID: <20261104191350.GA3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu>
 <20261104102323.4090290-2-smish149@asu.edu>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104102323.4090290-2-smish149@asu.edu>

On Wed, Nov 04, 2026 at 03:23:19AM -0700, Siddharth Mishra wrote:
> [BUG]
> With simple quotas enabled on a filesystem without the skinny-metadata
> feature, deleting a subvolume triggers the following warning:
> 
>  ------------[ cut here ]------------
>  WARNING: fs/btrfs/extent-tree.c:393 at
>    btrfs_get_extent_inline_ref_type+0x1b9/0x2d0, CPU#1: btrfs-cleaner/84
>  RIP: 0010:btrfs_get_extent_inline_ref_type (fs/btrfs/extent-tree.c:393)
>  Call Trace:
>   <TASK>
>   btrfs_get_extent_owner_root (fs/btrfs/extent-tree.c:3128)
>   btrfs_lookup_extent_info (fs/btrfs/extent-tree.c:187)
>   walk_down_proc (fs/btrfs/extent-tree.c:5647)
>   walk_down_tree (fs/btrfs/extent-tree.c:6170)
>   btrfs_drop_snapshot (fs/btrfs/extent-tree.c:6392)
>   btrfs_clean_one_deleted_snapshot (fs/btrfs/transaction.c:2728)
>   cleaner_kthread (fs/btrfs/disk-io.c:1553)
>   kthread (kernel/kthread.c:436)
>   ret_from_fork (arch/x86/kernel/process.c:158)
>   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS error (device vda): eb 30720000 iref 0x3ee6 invalid extent
>    inline ref type 0
> 
> Writing to a snapshot (update_ref_for_cow()) or a metadata balance
> (relocate_block_group()) trigger the same warning.
> 
> [CAUSE]
> Without skinny-metadata, the extent item of a tree block is an
> EXTENT_ITEM with the TREE_BLOCK flag, and a btrfs_tree_block_info sits
> between the btrfs_extent_item and the first inline ref:
> 
> 	item 3 key (30441472 EXTENT_ITEM 16384) itemoff 16079 itemsize 51
> 		refs 1 gen 5 flags TREE_BLOCK
> 		tree block key (256 INODE_ITEM 0) level 0
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 		(176 0x5) tree block backref root FS_TREE
> 
> But btrfs_get_extent_owner_root() always takes the first inline ref
> right after the btrfs_extent_item:
> 
> 	ptr = (unsigned long)(ei + 1);
> 
> So for such a tree block it reads the lowest byte of the first key
> objectid as the inline ref type. For the key above that byte is 0, and
> btrfs_get_extent_inline_ref_type() warns. If the byte happens to be
> BTRFS_EXTENT_OWNER_REF_KEY (172), the key bytes are returned as the
> owner root.
> 
> The filesystem is valid. It can be reproduced with:
> 
>   mkfs.btrfs -f -O ^skinny-metadata $dev
>   mount $dev $mnt
>   btrfs quota enable --simple $mnt
>   btrfs subvolume create $mnt/sv
>   btrfs subvolume delete $mnt/sv
>   btrfs subvolume sync $mnt
> 
> [FIX]
> Owner refs are only added to data extents, never to tree blocks, so
> return 0 for an extent item with the TREE_BLOCK flag before looking at
> its inline refs. This covers both the EXTENT_ITEM and the METADATA_ITEM
> layouts, and gives the same result as on a skinny-metadata filesystem,
> where the first inline ref of a tree block is never an owner ref.
> 

Nice catch, LGTM.
Reviewed-by: Boris Burkov <boris@bur.io>

> Fixes: 8d2990914073 ("btrfs: add helper for inline owner ref lookup")
> Cc: stable@vger.kernel.org # 6.7+
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>  fs/btrfs/extent-tree.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b9..3ab4f2696 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3117,6 +3117,9 @@ u64 btrfs_get_extent_owner_root(struct btrfs_fs_info *fs_info,
>  		return 0;
>  
>  	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
> +	if (btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
> +		return 0;
> +
>  	ptr = (unsigned long)(ei + 1);
>  	end = (unsigned long)ei + btrfs_item_size(leaf, slot);
>  
> -- 
> 2.54.0
> 
