Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD88E1F03D2
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775105825; cv=none; b=p2csGFqtCiPiCALSWlLN0rtwy34tbFdzoQ8nsk3c9jqFwMxaAW/h/IIdHGCdzhPE6cTWC0h12/mTDV8ePAGMGZeGMsp/0OhHRvSXqTSMpwxpw6HPOvxlMMZzx6IYz8Tb6h6l6d3upAJloUJMjt/ckZaOm8A+MZUVWv468mt5/DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775105825; c=relaxed/simple;
	bh=tHotChPSfAJO6ZlOypdGdSDk9Okz0ugNB+WptFCAjmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aJYC+4FpHrbYlirkSsAziQugnnXcbBlUavUb5YVkZNUGlc/XRbQCE/1rqgp2WruNHkvtox0TcwLzNAQTppuEBfH6DBQrzg9KixNbK9qg57xBPu855wim7k+a5icX/t8Hmzls/9kGbus13BtOuzrd+Ntove0JVBuGmO8J1zAf/vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AGXKL5Oh; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGXKL5Oh"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b23f90f53aso4180505ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 21:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775105823; x=1775710623; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7rmlcy7sCnIc2kvZhdXVUwcgpFNelz4EdchyyYWroXg=;
        b=AGXKL5OhMkrmD3od+EpCbjz9yryCW1or7fLtSq1NvbzjwDSLLhZZw9JODKQXC2a2me
         s4SRnP4o7AI3U8UJGSGLv8GUDfgcbcR/GN5hkwJhJbGvCe/K+F0ghYs6NNWwEgd8ynM3
         EpIzVfjcuY2RXc/LlppNpop0JwPuEzzcfXNNbervqwdpgTXa6+A5QROP5RsoN3o5AYW3
         N7yEZUNJywHXuATesLoySeY407W/9nCoabCXsV6+2HW24DM6qqHP+843k6YP4jxw/JSR
         OHp2iZtubMElGF09nkA+uqFs8Oy5EU+BR9U2dx0bTDwmVvxhgTUDWZeR7o/icyxD1dYQ
         iABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775105823; x=1775710623;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7rmlcy7sCnIc2kvZhdXVUwcgpFNelz4EdchyyYWroXg=;
        b=T6RWYqL250Rl+MHHXfuOshky3hBZlZF/3tTFJZNanxC0jcyLOZCN5yO1KvMklmA+Tq
         pEZbROqGB/1ljhZdPQriUmvwCTUu++M2qiqG1j/flcaybxSY2YqkLI8wFk114NmIJHur
         nycDCvpSPnipzLDbJNDR4fTDZzRDk+a1/k/gqmE0YrmBGhL6wmyL8AFS0xQz+GGpW4r7
         GxRvW3CIJv0xnpc7uBDAlC2+Kw9WTYmK/LWyIIxg32E1lRg3az5kuU4XP/SOYhi9ow/K
         5VgyTT1XQlw86QRVaSp3uBp79DYrD3TkvGMBSctxE5afQunpUfbO0QIyAlUiwjFAwtNP
         BjYg==
X-Forwarded-Encrypted: i=1; AJvYcCW5gVhV9Xsq5frs/q2bFoxJSoFLSIhpNgzkVntFgfbqw2qwwdn64+GGiHcAMhd+KzWYNnYZilY5ZlktqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+D/hBaKP47qP0AXLZllYifxl1PT7kQtYaQ1Nfsb3gp56OQyRa
	5Br8A14pp8Eyh3KA1hQRrN3kLfYTCEN1rxjJWeVWG+P+Rb4N1JBU7U5K
X-Gm-Gg: ATEYQzyqPqO80Q+M0mVRlrCbKsBiysUrehaFyai9faOeKziYQK8Cny6i3lyUXfE+xmu
	/kvrB87U2cUkNCWyots/VpH3qAwhhZYFs6XZUlDxjdbBomiwI0Ve1wczr7LnlEqZQbvLmn06ZCv
	2DDnJVVYQ/EbnKhvPdnoufmsDL0CONNiDsBC8Kb2plUJAGZxHlFov5gIfS6So2nJIJrSF2w5CWF
	gqEx931GuXAU3xhYsmYhi3/TeTp2vy/zSbNG0IQoEttJsx46wbXMYxMduE4x9dOjrIIpN/v/a7N
	1DjAhpdeH1KeCzD+WsfzPzJbwx2l99aKpbRCgCP9klrT0bI8yRbTSsA2FqV16Qw81o8uGWucCmv
	uDLHVa5DjZEJdOhSrdlPU02e9lu5UytgPhHybufTKT6ORP3m1w59t3BTpF9pQmTc3Z0FXByD4+O
	9E3bCOowsZZy3gV2qGWAiRJGg7oLI=
X-Received: by 2002:a17:903:1ac3:b0:2b0:a980:3687 with SMTP id d9443c01a7336-2b269adfe9amr64339275ad.3.1775105822766;
        Wed, 01 Apr 2026 21:57:02 -0700 (PDT)
Received: from [172.20.10.3] ([117.20.154.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749c38adsm16694915ad.69.2026.04.01.21.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 21:57:02 -0700 (PDT)
Message-ID: <f5185c25-c235-46f0-80ec-7ad2b7426d26@gmail.com>
Date: Thu, 2 Apr 2026 12:56:58 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove duplicate journal_info reset on failure to
 commit transaction
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <fa5c062786a6a987ffc2643fc444ab9c106fbeb0.1775069670.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <fa5c062786a6a987ffc2643fc444ab9c106fbeb0.1775069670.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Looks good.

Reviewed-by: Anand Jain <asj@kernel.org>




On 2/4/26 02:55, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we get an error during the transaction commit path, we are resetting
> current->journal_info to NULL twice - once in btrfs_commit_transaction()
> right before calling cleanup_transaction() and then once again inside
> cleanup_transaction(). Remove the instance in btrfs_commit_transaction().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/transaction.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c9c316ce4bdc..248adb785051 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2657,8 +2657,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	btrfs_trans_release_chunk_metadata(trans);
>  	trans->block_rsv = NULL;
>  	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
> -	if (current->journal_info == trans)
> -		current->journal_info = NULL;
>  	cleanup_transaction(trans, ret);
>  
>  	return ret;

