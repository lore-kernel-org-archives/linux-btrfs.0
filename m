Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C4CC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B00F207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pQp8ATKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfBVMys (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:54:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34038 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfBVMyr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 07:54:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id f14so2291608wrg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 04:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1hszW+yPmr4JJJXr/d0fmouYiNc5JrovzWghepN1tDA=;
        b=pQp8ATKjX+29lwmP0I3qUcftM+qVoRty7oN/kHBGuF9wh9Nb8tpg+4ShEPULv/nr8G
         Ido2+r5rcLbQy28u8QBzskEacSxuDf+XXHG93V0l+fkz6dtiuTt/s+v/fa1SqVVQq7k0
         FgCNPcCNGwdwGNYA0XxO40qq2rpT5zQ3O8RbDFPoHrTV920K8A3E5QpRZqSyR/Q9rKXr
         1hZ4bSTE4UeaKZ2hGjax0p0Hf3CeJZfKovzYItBIUOwo9dThO8GiD+TqH3fiOAsnjKvf
         xpDTtNXxsnR9AavsyTE/vJ2KaUNc6Nfcx69DYDqDB/Lp2JexHoeuYxobMwiC3f2y9Pkv
         eItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1hszW+yPmr4JJJXr/d0fmouYiNc5JrovzWghepN1tDA=;
        b=hluWrQgzAwMxyqHHdh4dLbErsHloMRZW0hl3O2qppNpzblr7C6nDbXkFuqFCGOa4NV
         FJZWJWNxAVf3kPFWNhAOavKVCIVyIw/Hhv6PayA9IVIIH1cGIr3QhLMUC3BqCcdz9FwS
         dmE7Tm2u4fdk0xNntEQqA5KUBX5YgqqahqphPGv/u9ixn1O71qrSmz1PPl32sWF/IP1D
         4QpAftiVVuFpkVwK3aUFFh33sIYvxomPcf/lr5dFDS3iMfjc8IsTxgStZKsEbjzgfQtG
         gEPSEeG7lynuBjCeWT3UKviqdTWsQiA3M/ZSX0nX3mKO4LKBLC7p41Wnud+nKmJJHtvH
         Tk1A==
X-Gm-Message-State: AHQUAuZQ/k/HHj2c+ANfEqMsZlq9X7HKvBc6amKBtO5zkBWRVyvlBLqu
        ssb3Db7Z8DB1rUqc+giSgkI=
X-Google-Smtp-Source: AHgI3IYTZWAMhF7c7DLdIh+F3Oj8A2RvlLK3mGGph+SuWjI2IhIJx0AGoaw74h8jr3JLNeujDIVDUw==
X-Received: by 2002:adf:ed0f:: with SMTP id a15mr2884100wro.249.1550840086487;
        Fri, 22 Feb 2019 04:54:46 -0800 (PST)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id a9sm722149wmm.10.2019.02.22.04.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 04:54:45 -0800 (PST)
Subject: Re: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <b676a401-2eeb-f105-d363-742137a13ded@gmail.com>
Date:   Fri, 22 Feb 2019 14:54:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190222101645.4403-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.02.19 г. 12:16 ч., Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/cleanup_alloc_extent_buffer
> Which is based on v5.0-rc7
> 
> There are 5 extent buffer alloc functions in btrfs:
> __alloc_extent_buffer();
> alloc_extent_buffer();
> __alloc_dummy_extent_buffer();
> alloc_dummy_extent_buffer();
> alloc_test_extent_buffer();
> 
> However their return value is not unified for failure mode:
> __alloc_extent_buffer()		Never fail
> alloc_extent_buffer()		PTR_ERR()
> __alloc_dummy_extent_buffer()	NULL

This function can never return NULL, if __alloc_extent_buffer cannot
fail then the only error this function returns is ERR_PTR(ENOMEM);

> alloc_dummy_extent_buffer()	NULL
Same thing applies to this function

> alloc_test_extent_buffer()	NULL

Same thing for this function, if we return exists then we must have
found it by find_extent_buffer hence it cannot be null. Otherwise we
return eb as allocated from alloc_dummy_extent_buffer. So how can null
be returned?

To me it really seems none of the function could return a NULL value, no?

> 
> This causes some wrapper function to have 2 failure modes, like
> btrfs_find_create_tree_block() can return NULL or PTR_ERR(-ENOMEM) for
> its failure.
> 
> This inconsistent behavior is making static checker and reader crazy.
> 
> This patchset will unify the failure more of above 5 functions to
> PTR_ERR().
> 
> Qu Wenruo (5):
>   btrfs: extent_io: Add comment about the return value of
>     alloc_extent_buffer()
>   btrfs: extent_io: Unify the return value of __alloc_extent_buffer()
>     with alloc_extent_buffer()
>   btrfs: extent_io: Unify the return value of
>     alloc_dummy_extent_buffer() with alloc_extent_buffer()
>   btrfs: extent_io: Unify the return value of alloc_test_extent_buffer()
>     with alloc_extent_buffer()
>   btrfs: extent_io: Unify the return value of
>     btrfs_clone_extent_buffer() with alloc_extent_buffer()
> 
>  fs/btrfs/backref.c                     |  8 ++--
>  fs/btrfs/ctree.c                       | 16 ++++----
>  fs/btrfs/extent_io.c                   | 56 +++++++++++++++++---------
>  fs/btrfs/qgroup.c                      |  5 ++-
>  fs/btrfs/tests/extent-buffer-tests.c   |  6 ++-
>  fs/btrfs/tests/extent-io-tests.c       |  4 +-
>  fs/btrfs/tests/free-space-tree-tests.c |  3 +-
>  fs/btrfs/tests/inode-tests.c           |  6 ++-
>  fs/btrfs/tests/qgroup-tests.c          |  3 +-
>  9 files changed, 68 insertions(+), 39 deletions(-)
> 
