Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1351E43C;
	Fri, 18 Sep 2026 19:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789758958; cv=none; b=cbF3m9LS4jQfWo4zwTmglO8+hCKz6DJy/sMQ6Pu38OUnz5ciSP4HsuAUpt/4Yqjuw/9lqI6vB0jlHyjcE2wCakb0E0odTlHa6VqYA56T6dGqnZCdw1U+BL11b4h6uSsuZrCVCdf+gnF5iZDIVUrkrhZxYT8MbqO+LXMKAGlwFWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789758958; c=relaxed/simple;
	bh=p5WFh6dxNr3VyKKjQ9+/1pjidS0TxY0HBEYjnS/a9zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBYZJ58iWzP1paVaE7FdWbGqqXGROALKQzrphfgXejCMwOuAeJPpjPC46KmMOs0Mbhu62GBejAfjsiOip7EFNqzcS5JWo7L4WAixXMLT4h8NjdCzX/yDWKGX0pN3pCpLfuLZOr5lc8eMTwR3Cv0p1EMJ4Qn8evAZrFmXDPQ8SIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=KRtzX1aB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ftidCt9u; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="KRtzX1aB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ftidCt9u"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 0906B1D0004B;
	Fri, 18 Sep 2026 15:15:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 15:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789758950; x=1789845350; bh=J9nWZf5AYr
	tOVFVnkFY6HG7AFePU2WrnrLnsh6ZCK9Y=; b=KRtzX1aBQIRtz/iVynBdRwo4xc
	K02yunkpfQiYm3zYnQj0RFcsDvlNHCpARstW9NLWR9JJ28ty6FcfIA3zhySZGyXF
	mb6HVhFH0mnNnDDN9xSqXzEr3WsOoJPVkQ7ft/ZGTKyvGVNYMsV8NLUlPJmvbz3U
	9TikEKttzSrAAKJX7OW98J58TPbeLlm/FXxig1k8pShN1k9nTLitINPZukSx+yWd
	DKfXWwUIB+UuQVIxWJaQGUbQZJ+yrPq9YMSxRufnFc9utvJGzip6VI0tlbQGsX65
	S/3OGKOrPcZZn+Cm40QSXQ1URujene0W0gyGXLjagKYZ3avXcp2cbdaKyXHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789758950; x=1789845350; bh=J9nWZf5AYrtOVFVnkFY6HG7AFePU2WrnrLn
	sh6ZCK9Y=; b=ftidCt9uSH6ZYJsWQciKfGdphAX4z2qCzMysoeZctgvphHNX9oP
	2jITy2BR2ZcDvsvFneCc0s1RhFyT/enMpUgVMTNH+7STODdcsZpNyX1O2JH43XtS
	Cwz0nv7ynUF4XgjM64ojr8rmwLkqHyERtS+WxyKD/ZjQX+GG4br2a1KD9SvsgDcy
	87HUtDfkxtnuqUrm5yhd89Cor5kbhweZCe2jB+l/ckMBCkqc+3SkpJrawANzfY74
	t5XOadTx0GjY+Y+n9AWdxzVMUi9lkm2eSMomrxFNi5EYctU139e0Xvamg62E0neB
	abUGdx8MAF4vaDVU5zNSLtebG9OPIBrNLzA==
X-ME-Sender: <xms:5o2tagJQ8sEAHWuTuM-keZcEm96epzf8uxePvhZF3GwYwUARb87HqQ>
    <xme:5o2tavPXTlT20GRWRpICAI2z77vRUo_5j5C6o2KQTLuE3tT3mUF_gDpDUuNmuSbHC
    2v1LWJ_ze0daWpH3AxPNIaDyDTIuCQfkOBomQQICjGwJG-Z23e2jBgG>
X-ME-Received: <xmr:5o2tam4CJx1XzQ1U0FJZjRvGOce4YfOeE6Ynx4MlW-G8BtNCfSHkmFQ>
X-ME-Proxy-Cause: dmFkZTE0AoeRETnm0A/ec5JkBzkAN6/QBdm2Q0BdpiiaNPJLk1gz78iQhps5wjxJp6zQE3
    BzS+Sdqz5hTitB6pAP2yab9BAX5BC1DE+ztCbhkDv1/3QVGru42UI0Nny5Lt+T3LLNpYD3
    AaXkN4/2s/P+sKm0kno5DT8CpH+LHHORAFOElbB8gi7TMPLd6nwhEgydcaK0AV/fw22kRz
    g05B2VsO9Xg+87TC/8fPT3Ag4AGfdBoFk9UEgfAOqssr79KavS4u5GGdjQXD24It7hfCHy
    vRo+hY8R9jmBalyPPaVeuzPG1eucSJGfKQyldXBCzE56epYg0w+6H1STAqXKyjo9iXkUec
    xHq8YRZqmw5txZ5LP39nrz9cRhOMRKAFpn0KZTQp2sdyM3n7S0Uz0C/W9yoCkfys1o1OuU
    tO/alA/xgabm3ALTVeAF8o6J4RU3u9AmlfSWjLvtAXF3hqDwhmrkYMioLCqBly3+Roh/LJ
    nZS+xP3TA9G+st7eb3jXv5Gcq6nNiqObi9YnUyMwPe65h3UNEEJKSBRHFd7rmHPNWGxb7v
    d7jFaCxXkEap3tPHTlKmeV4fxQQXae0M0wTzK02erTD1odbuXX0R6E80TDDedOkqi/pXFv
    1M9B9gFdGDn/6C56zcBwO3Y5yMAQsqL5RntQp69SdMn19gtPv39H+gIV4KhA
X-ME-Proxy: <xmx:5o2tap76G4xMzSahjDuOWzh0Q0b9UkdiPWl5pJSXnDdJZ_LJI6WyUA>
    <xmx:5o2tasE3-gDotfuzyFjsuDEXQl7sRAycrByIB2YNThI9aj88JtJNQg>
    <xmx:5o2tahUhRd1lopPynDlvAZmAwcVAF3lkRSpgcGnYxQ6zY0DvtY69_Q>
    <xmx:5o2taoVER4r8MhY0aR9sJP0lp66OS8Dg0o8DOi0rmWuhRuMe2YVdcA>
    <xmx:5o2tanSFbNxJgbOmdxKU5a5eOPP8RTEtm7aKOqPS7xeu9wHQX7fEj6md>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 15:15:50 -0400 (EDT)
Date: Fri, 18 Sep 2026 12:16:02 -0700
From: Boris Burkov <boris@bur.io>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: dsterba@suse.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, naohiro.aota@wdc.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix block group reference leak in
 btrfs_repair_one_zone()
Message-ID: <20260918191602.GC2956775@zen.localdomain>
References: <20260916171716.2087024-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916171716.2087024-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 05:17:16PM +0000, Wentao Liang wrote:
> btrfs_repair_one_zone() hands the block group reference taken by
> btrfs_lookup_block_group() over to relocating_repair_kthread(), which
> drops it.  However the return value of kthread_run() is not checked,
> so when the kernel thread fails to spawn, nothing executes the put and
> the block group reference is leaked.
> 
> Check kthread_run() and drop the reference if the thread failed to
> start.
> 
> Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
> Cc: stable@vger.kernel.org

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/btrfs/volumes.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a88e68f90564..541bcd65a6f6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8770,6 +8770,7 @@ static int relocating_repair_kthread(void *data)
>  bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
>  {
>  	struct btrfs_block_group *cache;
> +	struct task_struct *task;
>  
>  	if (!btrfs_is_zoned(fs_info))
>  		return false;
> @@ -8787,8 +8788,10 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
>  		return true;
>  	}
>  
> -	kthread_run(relocating_repair_kthread, cache,
> -		    "btrfs-relocating-repair");
> +	task = kthread_run(relocating_repair_kthread, cache,
> +			   "btrfs-relocating-repair");
> +	if (IS_ERR(task))
> +		btrfs_put_block_group(cache);
>  
>  	return true;
>  }
> -- 
> 2.34.1
> 
