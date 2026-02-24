Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BEB171CD;
	Tue, 24 Feb 2026 00:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891573; cv=none; b=PRXd8VtljHPudby/UsiXIv9/oshNWX81FMfScHPBaQizShT/oLq0+Pn3VHHj/Ts6U62zwEctJeK1BBef+SLj1CYQirH+AY163dz6/7Qc2lokXUMLLJ0yUWAzk38SuDF6OANERc8ieQFDpXcj/Q4fZU4PUw4e3ErxFmUR9gLTO4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891573; c=relaxed/simple;
	bh=SCV5w3sIuJdusGqtgb7Y87H1nBu22OfdrHK0NysWS8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khyFroq8oTyoz8Lj2TPJAllyfiDGET4DQNqwUb0eH7+IH0zJYJ5gt/YzZq0JiXCyo89NPbEjtRGn4aFVehWTKDKyTMXrkgLG7XyRpCweRxjJkY0cDkJ8c5KRuSyRqGg9mJ6G91NHAl1AMJnth7hmqn7CFXi3/Q132ILx7PWdtF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gN9qhS7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gN9qhS7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB4DC116C6;
	Tue, 24 Feb 2026 00:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771891573;
	bh=SCV5w3sIuJdusGqtgb7Y87H1nBu22OfdrHK0NysWS8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gN9qhS7WVy1nYN3EVx9ziPpboFkbOYx0phwjdcWNMnAfX26Ym/ihLNehNKjrW0rcO
	 LZAI4eui6KgtQRED+RzGbp/ar+dnEhHtPCagdt8UVBbqkYV2pdYRB7SjRSp7C2lXII
	 Xqag9UrP4DLhiUbElsf1pSPfWgjts+YcK5pl0+80DECELdACn0+7fOgF+UsXq36pql
	 TF77E8uA2fqwVcE2+ABJne+c1qEq1nqdcKQD/WJ2jq/10Z33QFPaevyz4zpz0F3jJP
	 pJVNY0DASDntlljHw/RSOjvMRE5Iqq3j/7GYmpkmT2HZixDaByOgUOzYsgpbxBsY2N
	 j3dN826EhPB+Q==
Date: Mon, 23 Feb 2026 16:06:12 -0800
From: Kees Cook <kees@kernel.org>
To: Miquel =?iso-8859-1?Q?Sabat=E9_Sol=E0?= <mssola@mssola.com>
Cc: dsterba@suse.com, clm@fb.com, naohiro.aota@wdc.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: replace kcalloc() calls to kzalloc_objs()
Message-ID: <202602231603.4F93301E@keescook>
References: <20260223234451.277369-1-mssola@mssola.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223234451.277369-1-mssola@mssola.com>

On Tue, Feb 24, 2026 at 12:44:51AM +0100, Miquel Sabaté Solà wrote:
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 02105d68accb..1ebfed8f0a0a 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2110,8 +2110,8 @@ static int recover_sectors(struct btrfs_raid_bio *rbio)
>  	 * @unmap_array stores copy of pointers that does not get reordered
>  	 * during reconstruction so that kunmap_local works.
>  	 */
> -	pointers = kcalloc(rbio->real_stripes, sizeof(void *), GFP_NOFS);
> -	unmap_array = kcalloc(rbio->real_stripes, sizeof(void *), GFP_NOFS);
> +	pointers = kzalloc_objs(*pointers, rbio->real_stripes, GFP_NOFS);
> +	unmap_array = kzalloc_objs(*unmap_array, rbio->real_stripes, GFP_NOFS);
>  	if (!pointers || !unmap_array) {
>  		ret = -ENOMEM;
>  		goto out;

Just as a style option, I wanted to point out (for at least the above,
I didn't check the rest), you can do the definition and declaration at
once with "auto" and put the type in the alloc:

	auto pointers = kzalloc_objs(void *, rbio->real_stripes, GFP_NOFS);

But either way is fine. :) This patch looks good to me!

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
