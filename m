Received: from out28-63.mail.aliyun.com (out28-63.mail.aliyun.com [115.124.28.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559B64414
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 00:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769472312; cv=none; b=omZ0uB6TthGWG6C33EPDM9++NIXNJBhBkW1A4LlxRu4fQ4O/sCZzeCi5w2P6ZwtEEZE+TDxk+OA4A3j1g3tUe8bbXZzFmL8bfcytPjzE4xLoGhnE5Qa9zvvnkpSgsXhOG14pITgE25McEkLyk9q9QPvkwt3BGDwLOsTVYLW5NXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769472312; c=relaxed/simple;
	bh=Yz7Mh4mYsX1FcU37gND/UpgfuOne//gJBXLrSzLANE4=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=fCIeebnGfHrYUlJQUelwew3XjO7eXooA16wCgPUKpkJn7VlqbRITZj81RlIPIJyK9tSavlN3ycGKfIajJH2TMEvzGb//+OVvrbiXvWsPUD2SQJtV+UUUEdirN+3mbFWoUo2wZDw59FlAlD74KFEzT0vosOdS4Mq0JKVCzwu1zz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.gGjKBoL_1769468639 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 27 Jan 2026 07:04:00 +0800
Date: Tue, 27 Jan 2026 07:04:01 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v3 3/3] btrfs: forward declare btrfs_fs_info in volumes.h
Cc: linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
In-Reply-To: <4c839922e88a33145eca264394ff8aab08c0a871.1769447820.git.boris@bur.io>
References: <cover.1769447820.git.boris@bur.io> <4c839922e88a33145eca264394ff8aab08c0a871.1769447820.git.boris@bur.io>
Message-Id: <20260127070401.327D.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.83.01 [en]

Hi,

> Fix the build warning:
> In file included from fs/btrfs/tests/chunk-allocation-tests.c:8:
> fs/btrfs/tests/../volumes.h:721:53: warning: ¡®struct btrfs_space_info¡¯ declared inside parameter list will not be visible outside of this definition or declaration
>   721 |                                              struct btrfs_space_info *space_info,
> 

Could we fold this patch into the patch 2/3 which introduce the file of 
chunk-allocation-tests.c?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/01/27



> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/volumes.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 8cb72e84dc84..ebc85bf53ee7 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -30,6 +30,7 @@ struct btrfs_block_group;
>  struct btrfs_trans_handle;
>  struct btrfs_transaction;
>  struct btrfs_zoned_device_info;
> +struct btrfs_space_info;
>  
>  #define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
>  
> -- 
> 2.52.0
> 


