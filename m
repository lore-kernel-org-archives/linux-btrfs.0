Return-Path: <SRS0=hLwB=EC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDDEC388F9
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531FE20878
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="h1texrEl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760653AbgJ0RhO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:37:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39163 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1820679AbgJ0RhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Oct 2020 13:37:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id i7so1610256qti.6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2020 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7OYRiTw4ooJouTy5WndwBqQx5pVO0rhdHvQ4+sr/8Xg=;
        b=h1texrEluQV8bK6XtzneST6d+V9Xajfrd2ruyLPqrnF7fhHKgihfc8CmobZMe56cZA
         Vh0O+pFIWUVhhxnI++QC7HxJZZHD3CtpDc2lo7LOcPAq6mb3YOvaA7DUxHtUkno67IVL
         mR9I3Gw3azJQ9IlwYIopq2ZWo5+p/D1qHuPIcafdn0GCosIcVgfpobynR48JEBMBz6Kj
         rkRWjZvco+LbvjgeVecpdBqkqw5nAM48FoCKeVMGKNNuGvzMXbEKRlm86OvnvMwRL1GZ
         ocpmhEhuht6nvnSK5IJmPKCCjTPxC8GoMD//DSLcxn99No0I/EL6RpYf8Gh8TooEYiYe
         HnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7OYRiTw4ooJouTy5WndwBqQx5pVO0rhdHvQ4+sr/8Xg=;
        b=jjoKMz5PNr2+AZD91s053QzWkqUM3J7Xd84gfUA1Gv2fZfoe0NeVOPglGqyTqbi3M2
         XsBe4goV/z45uqEvaVgxRDlv9CXv5QQ7ImPM1FVBPfWNPR49r+lQa7IofEh1t0aS8E9/
         2IqxhQvT3PoQT7TCvIaGYFVM2t2J+WW2q8FhjpqhTh4/8ZPYuQWwNbx/22GzJ/5Q/63P
         bJJWZhQElNoTK5x6227+lcHoLhjI4VwyKSZqD/a/QjhqBTBNCLn1AKwkRr6Bs2TiY8ex
         gKx56SwS3hprSvDHAhUJ5G57mvl66ZZfWzvNczfPdtWMoxN+IYbKL4HkQA7HJRMcqyHw
         4RKw==
X-Gm-Message-State: AOAM531dXp+yDY+Ka53bm0zl89RDkWbA6JXDisFkr8VhnXMJkmg6k9q5
        7x6DxBIX9CNJo6tj0CQS7Q33QQ==
X-Google-Smtp-Source: ABdhPJxdzQEcfikzztjhEG1W5zfxStvMtgXlMcv2R17rr1GEqaFUQah7V2Dzynrcw7LuhGZNAs0bTw==
X-Received: by 2002:aed:2125:: with SMTP id 34mr3329529qtc.249.1603820231601;
        Tue, 27 Oct 2020 10:37:11 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id o5sm1275728qtt.3.2020.10.27.10.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 10:37:11 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: restore: Have -l display subvolume name
To:     Daniel Xu <dxu@dxuuu.xyz>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Cc:     kernel-team@fb.com
References: <547cf7d97e32b542f4a552c7319b167dd6b94403.1603758365.git.dxu@dxuuu.xyz>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <8988a20e-a3e3-6bf3-dc7a-21b2706e7cf6@toxicpanda.com>
Date:   Tue, 27 Oct 2020 13:37:10 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <547cf7d97e32b542f4a552c7319b167dd6b94403.1603758365.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/26/20 8:28 PM, Daniel Xu wrote:
> This commit has `btrfs restore -l ...` display subvolume names if
> applicable. Before, it only listed subvolume IDs which are not very
> helpful for the user. A subvolume name is much more descriptive.
> 
> Before:
> 	$ btrfs restore ~/scratch/btrfs/fs -l
> 	 tree key (EXTENT_TREE ROOT_ITEM 0) 30425088 level 0
> 	 tree key (DEV_TREE ROOT_ITEM 0) 30441472 level 0
> 	 tree key (FS_TREE ROOT_ITEM 0) 30736384 level 0
> 	 tree key (CSUM_TREE ROOT_ITEM 0) 30474240 level 0
> 	 tree key (UUID_TREE ROOT_ITEM 0) 30785536 level 0
> 	 tree key (256 ROOT_ITEM 0) 30818304 level 0
> 	 tree key (257 ROOT_ITEM 0) 30883840 level 0
> 	 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 30490624 level 0
> 
> After:
> 	$ ./btrfs restore ~/scratch/btrfs/fs -l
> 	 tree key (EXTENT_TREE ROOT_ITEM 0) 30425088 level 0
> 	 tree key (DEV_TREE ROOT_ITEM 0) 30441472 level 0
> 	 tree key (FS_TREE ROOT_ITEM 0) 30736384 level 0
> 	 tree key (CSUM_TREE ROOT_ITEM 0) 30474240 level 0
> 	 tree key (UUID_TREE ROOT_ITEM 0) 30785536 level 0
> 	 tree key (256 ROOT_ITEM 0) 30818304 level 0 subvol1
> 	 tree key (257 ROOT_ITEM 0) 30883840 level 0 subvol2
> 	 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 30490624 level 0
> 

Man I stared at this a few times before I realized the name came after the 
previous information.  I think I'd rather move this helper into somewhere that 
it can be used by the libbtrfs stuff, I'm sure it'll be handy elsewhere.  Thanks,

Josef
