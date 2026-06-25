Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C899E339861
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782429061; cv=none; b=QBCYsdWePaesBRYcDKct1Zzaj8NkThZZRPC8OtP2qcG8DrEToTleuygxWfxCcFweWQzfzIR1fytLMpgtTAM8Rppdm/1bk9PsOSJw4TAraQ+X1tJBTGtahDJyA2a3ATw1eARSfbpSYPhB2h4bPDFJafId8YJP79IwX8nePE2hTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782429061; c=relaxed/simple;
	bh=a0Mjt4cxq5UueH2qSv/Q/cUdUfYm6FAsd0cid4fAyyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ghCj6caw6LIq3Fug+kNzltSq4IE6QkTdWNbo/5V5muZvg90YMkm10XwgGCKalrQ0ue/j5+MoC26clFJlyxHasawyh76IvLyqpYtRjmX54jHzXkyHUY5Ov/cOjyGckQl0QTMwQi+bt3HcRg7AGfNVxKeN8kY2MkteIvcbXhofdac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPVoYeQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPVoYeQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8191F000E9;
	Thu, 25 Jun 2026 23:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782429060;
	bh=dXjx/MjGKPArzEWkwfMJ8msHgnW73Iw2lU0mwZPjAPE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ZPVoYeQYsRNymZbb1RNuM3GPRlUE0U0pShJ6Gg+BE9CaxldshDgDSUNbdtBIwDTXY
	 5Q2tBfkMut1Rb3VJtm1EfH5nNl9fIPousEWW7AblptbnKeFKw+1LZagSqPbgWU4Tti
	 1WBHY1JsZOQXWk7Ns/rSpc/58VVlW92qNq3U/7SQSq7gKCAMzcd5R7F0R04ps4lhrn
	 IlMd625ONhjSbMQnJX3WF4HIg3A4ZP1WCBv0UylGUA1wLQIXC5azlRUiOSkTJe+0N+
	 zWrEbIspQFmyd+G6HB7QCcYzPpcfyj7q8whDKoUl4d1j+SIkZevT4DxzUFcJggyp9o
	 gqu8jDKNb1SOg==
Message-ID: <8334c67f-c8e2-4800-8f25-b2444c2dcdb7@kernel.org>
Date: Fri, 26 Jun 2026 07:10:58 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] btrfs: defrag: use simple list_del() in
 defrag_collect_targets()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1782321584.git.fdmanana@suse.com>
 <ef417c92283d2b96cdc44c7bba0ac2d47c4f324b.1782321584.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <ef417c92283d2b96cdc44c7bba0ac2d47c4f324b.1782321584.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/6/26 03:20, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When freeing the entries from the list there is no need to initialize
> the list member in an entry, since we are immediately freeing it. So use
> simple list_del() instead of list_del_init().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/defrag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index e454b59d6477..7b3f779775a0 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1093,7 +1093,7 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
>  		struct defrag_target_range *tmp;
>  
>  		list_for_each_entry_safe(entry, tmp, target_list, list) {
> -			list_del_init(&entry->list);
> +			list_del(&entry->list);
>  			kfree(entry);
>  		}
>  	}


Nice cleanup.
Reviewed-by: Anand Jain <asj@kernel.org>

