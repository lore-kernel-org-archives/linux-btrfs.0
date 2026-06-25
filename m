Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DCA2BEC45
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428542; cv=none; b=M4ri4sPt29EWm2ndM6Ko74Z2ePA5hzPfh93bhgicKNkULL94n7QD5Vs/6ynvPSq76l/RXzQdFjA3kZ2F94Y5liq2jZlHONlEUoRkueH5KBL0oAFN7I860DAYMhROfqRPtoWF61Suhs51g4FjT0KOTGKEwpt6JheWpTxxJcDpYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428542; c=relaxed/simple;
	bh=eY3Cb47l2xmnrxMfrLoK9q+7pn2GAFXKQGoAk5t1zDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cKPzSHEmxTuw3MggbDyRKDLXUUFiIlidmJbu7zTHAy9fJhVJacu29Tb1BMG6s39HQu1WemxJaIMj1EWIkNOQNWTB1NBb3+QKrlgzegYoqH2PtKTDFBoOZXh+dLYMlQqRG7e8j4c+ijVP3VOAzvPEDOlgjGKDMXRNMWCoT/056MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWsJE6wT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWsJE6wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8338C1F000E9;
	Thu, 25 Jun 2026 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428541;
	bh=JauZVnYVejIyeYqhCaZdF5D1WdaVY5Kj/xRq/rsCkBw=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=OWsJE6wTToklxzFBRv3FRWiBjAgugnaKjOPf2V6WOUAxNI2D7DuOcjTHl3EQ+d6FD
	 rnAek/tEGAmmyjZ8AAYW0ubVr/BDv3jHlvRtATCiZVEKlcjOESLwZ2lQxL4X7RPUn/
	 4H1FN0+V15VKmVw0V5VFy4Ko6u0k9gbneCM8zR/Gkm2P/Erz1jL8XaAGoEhcaF1hAq
	 kZCqE87cZFrXY9kxl9tc5yEJJ41wfUeWWLSVUTdz8zelfrB8py7HDKR6qyb3o3daW8
	 rxU6DQKTjPoGP9x3EQKuyVNjF34ehA2tsSDLI0F0mLbuXZN6vWLZ/xsbqrzRv4aMAo
	 TK5krxMBi0U8g==
Message-ID: <3a52eadb-002d-4982-8580-8b83a45c69fb@kernel.org>
Date: Fri, 26 Jun 2026 07:02:17 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] btrfs: defrag: use a single list for each loop in
 defrag_one_range()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1782321584.git.fdmanana@suse.com>
 <20e1226097db10e92c2059cb5ce51205348362a7.1782321584.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20e1226097db10e92c2059cb5ce51205348362a7.1782321584.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/6/26 03:20, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no need to have one list for each loop to defrag each subrange and
> then another one to free each subrange (struct defrag_target_range).
> We can do it in a single loop, freeing each subrange after defragging,
> plus no need to delete each subrange from the list since we immediately
> free it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/defrag.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 0697b285e05f..ad1d04d8f165 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1234,16 +1234,12 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
>  	if (ret < 0)
>  		goto unlock_extent;
>  
> -	list_for_each_entry(entry, &target_list, list) {
> +	list_for_each_entry_safe(entry, tmp, &target_list, list) {
>  		defrag_one_locked_target(inode, entry, folios, nr_pages, &cached_state);
>  		if (entry->start > last_defrag_end)
>  			btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
>  						     entry->start - last_defrag_end, true);
>  		last_defrag_end = entry->start + entry->len;
> -	}
> -
> -	list_for_each_entry_safe(entry, tmp, &target_list, list) {
> -		list_del_init(&entry->list);
>  		kfree(entry);
>  	}
>  unlock_extent:


LGTM.

Reviewed-by: Anand Jain <asj@kernel.org>


