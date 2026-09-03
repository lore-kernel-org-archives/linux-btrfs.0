Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065263749EE
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468561; cv=none; b=JbNGW1/78wrEApBlL4VA2HBk8reDL4Ksh8SV8VtFmFBzxhdFhKwANIDoNDkhJ8dRw9SYSqGQ7DuFWN27FwV3PysYLnqRq+Q3HxM4bJ9RXWeAXpeLichSE3mICSuio1aya1FL3k1niHz9JB1X/8CWUdpJgIm60oLkPuU9ISCvjEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468561; c=relaxed/simple;
	bh=/u9wH+DeKpe372OKvrl1bGX9GYJRG3banX1OQvYe4Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bj3iGhLAKncmno4SFjJUUc8K8que5EYXp5K9x+XiYYEmalKFJQqsBE560PH5hY4AsEZI6CiOmKfVTlgkbzM4m2mDMRiDwJUsP8mi1SWY3yEZpbmh1JuXqQA+g1/2Mptz4jvvO32RyQR3OceRD2rxrcc0R8kzwzx3tXpvCMyXuDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=OL6QcLgs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PxYN71xp; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="OL6QcLgs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PxYN71xp"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D4C6F7A0141;
	Thu,  3 Sep 2026 16:49:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 03 Sep 2026 16:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1788468550; x=1788554950; bh=7OIQNidu/h
	wSm6OFmfnKiAP8JASyrO5MTzHiH5rI+b8=; b=OL6QcLgsqzA5DL+1/UVVriHrTa
	snwjJuUkMGXUx2unbBIxfpDdN3Rva0su7buQZiZnPllTDx0d4eZx8glk/owDdlFF
	EGskVGkLQffMf9lr0pYBRJn01+c/5thoEpNuOZ6mi45+BTj3KT9BzqaulQhl+i7+
	WeWa8CR2+Rmasvn3HDAM6a5jGcPPUTF2cxQl8afcgARZOCjiFi9pqXLBkAtAg7Ed
	2B5AHhBwgef+Ty3xkevxViie0Nzl+XOrVVB0Wrjd1oiEKGPFr8DBqza/QHnAwMyD
	NOAWIqJZSmP8EMfnXe0zn6xNguaLBtVHvaSC+L/LLQX5oS1CebE0owp8KuqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788468550; x=1788554950; bh=7OIQNidu/hwSm6OFmfnKiAP8JASyrO5MTzH
	iH5rI+b8=; b=PxYN71xpRJtYoS4xjShWi2JzPdH3YwkxjQHjb4pskbot+K9ABcR
	t0Fis5/OSfFSKc1C/r1Jv+f9K0H1DRk/FXl7fv7zad6wMsxV6sEsIws+eJPCaqh7
	EPLi3gtx6q55cP4+QsucFRHwKgqUeauI0OZZXqWFXZTTJbw0W6ReZzaTbucgHTAK
	TcAGg5GwdlfqLIdjuvBtMLCxCWWcVYMlXes4AKDJGnOKn6pqxlAZcp+M2PJtI3Gw
	hFfP0jmW1aL7dwOInS5P3uoioCw9dyAJqrWSACiUDFxoXBUsd7a4SbsdDWEvvLT/
	YAP1YCBCq0O/1If5pJi9Bs2oKulQ+PxNBxg==
X-ME-Sender: <xms:Rt2ZaoRhBHlMyvl9mxK3XBVw5iHILgIRTonWTgy3v_xCPijYMWLRoQ>
    <xme:Rt2Zary8vaypbja4BPi1T2HHUkEWl51GS6prSjZDhozLRm_VL94ln7GGFRl0F-tOu
    eVgJxLELHHoe5f1rpmQnXeYh7E4c7_9HUn4C91V-oSybfVmnhLy7JcM>
X-ME-Received: <xmr:Rt2Zajc68z2ryZ0K-cc0iiLsg9OFHqh1beCBT0Xb5SqYYRVA00Nedxw>
X-ME-Proxy-Cause: dmFkZTFkw1h4Gg7HYggeWftEGyox2C8EBWwbZIaREyUMtbwe6G/zco7kEblsNMO1sxPwTF
    qmx2N2eINnuJEQTSSNAhFI2UClP2fYZN7/iRQdY31O3tD/qo/dR2QudaiRr+Mvd7lQI2r0
    +6gOf/+f7oPc5dqwXv7fLd86eEH0m+qw3ay82ZNe+f/w5zuITr5ihjex0/loEq1ytZfEOR
    c6l7q3Ezc5u/0IHN8itSL6xq3k3af/fFPenDJQWL2jXq370hd0/kY5aixfDl8ykvPGsvpN
    q9HnompM8VgK620NTUItjLAXL9FAgBbygV0I11G9jXrRojo0yfQ6DeUmk4R2L/QVW4EsQv
    pGSyIcg9i/wjSQPEduxPyNa5cnTLuCIe2PKyFYbpAkwH8qfjKhefz3EocTxtwTmR4QFTmw
    nKpdEpkHqhWJMNQaOPiUdemvZCAsv5D2Cum94G3FsOl0e3gsAZcW7CsljqSXReljAF0x0Z
    wEuWo1oSyym/rtgEGpfbK7x+Yh11NoMOLWgBQobPRHnIO/ALrGyeWzVB8qO7Qk4N3jCeaY
    V+/DbAfkzkVUehgKBw87KlpguU7z/LYrfCSfGPLK1yKZPR/ywsh1odSPnPkGqcivZcB3YN
    ruYOASAevkUK6lmOWPoUsFM/KASnZoIZjFXHnZQL8biVNV9InD+ZvDq5IZpw
X-ME-Proxy: <xmx:Rt2ZanJ8a2tB_rvf91AakM_WjBoueRsTZ_WyRNr6g92Jplpot-tZhQ>
    <xmx:Rt2ZakHmcM2vqZqkuFJs5rF0XZr_3Iu7QMsq-gl2Vi5KUeROtX5v5w>
    <xmx:Rt2ZahpbdCdrD1L79nohOTzqT7ciyNhWG1VAW86hVfuxSqoelSNndw>
    <xmx:Rt2ZatTY8LndYfSEArK4n5FeeFSQ__--k6aAcXElaNhU0kx0fR39dQ>
    <xmx:Rt2ZavE_j6m0k44aKcZs4ClTUe6QHdVvbEAc-iZJmvNQSom_0T8vNyem>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 16:49:10 -0400 (EDT)
Date: Thu, 3 Sep 2026 13:48:23 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix unnecessary transaction commit fallback from
 btrfs_log_all_parents()
Message-ID: <20260903204823.GA3237930@zen.localdomain>
References: <8efdd4a651d579b37ad7929f613fc3bf8598bae1.1788438374.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8efdd4a651d579b37ad7929f613fc3bf8598bae1.1788438374.git.fdmanana@suse.com>

On Thu, Sep 03, 2026 at 01:27:10PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When btrfs_log_all_parents() returns without doing any work (because all
> parent directories were already logged), it returns 1, which is propagated
> up the fsync call chain up to btrfs_log_dentry_safe(), and that causes
> btrfs_sync_file() to trigger am unnecessary transaction commit.
> 
> This all happens because the call to btrfs_search_slot() in
> btrfs_log_all_parents() always returns 1, as there can not be any inode
> ref keys with an offset 0 (an invalid inode number), so if the while loop
> below it does not do any work because all parent directories were already
> logged, the 'ret' variable remains with a value of 1, which is then
> returned up the call chain to btrfs_sync_file().
> 
> Fix this by setting 'ret' to 0 after the call to btrfs_search_slot().
> 
> Fixes: 0f24ea456ae1 ("btrfs: tracepoints: add trace event for btrfs_log_all_parents()")
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/tree-log.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7ba7b6098aa5..0b9518a04272 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -7286,6 +7286,16 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
>  	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  	if (ret < 0)
>  		goto out;
> +	/*
> +	 * There can't be an inode ref key with offset 0 because inode numbers
> +	 * start at BTRFS_FIRST_FREE_OBJECTID.
> +	 */
> +	ASSERT(ret > 0);
> +	/*
> +	 * Set to 0 so that in case we don't do any work below, we won't return
> +	 * 1 and trigger an unnecessary transaction commit.
> +	 */
> +	ret = 0;
>  
>  	while (true) {
>  		struct extent_buffer *leaf = path->nodes[0];
> -- 
> 2.47.2
> 
