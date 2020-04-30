Return-Path: <SRS0=+YqI=6O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE654C47254
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Apr 2020 16:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC2C22082E
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Apr 2020 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588265683;
	bh=2YZPpc7VWyggscv2iNRM1OFSHVpzZWxN9/Z5ZQ1kypQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IwBfmysYZ18UamupV90Zcn1qm7P/5eve9LXQaeNka1SpbixnJfbd64v3al7qD/wnx
	 ifpNoZ7tnBacmz2MPMo/CktLttO98f7Uic7cxK0xbHsawiBcSAZJ331x4PmMOuhW85
	 eWVeivX8zgjtGc1Ax0j4KoSwXHTmnBLrK0Kh9NAs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgD3Qyl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 12:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgD3Qyk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Apr 2020 12:54:40 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5F8C035494;
        Thu, 30 Apr 2020 09:54:40 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i68so5590670qtb.5;
        Thu, 30 Apr 2020 09:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u0otRQ4HRB+YKeilmTal/RUC4w+MjwFliS0R169CA7s=;
        b=O/5SFX3PPa5GnoITINqhhqhgSQx66i9Vr9eYEtt/dHcuqLd/AOHvW3QLuX+7DeqG31
         GslwjmCdLPuQneMgsHDTtJ/bnlSZ25zwDS0MsgunToxCICZR7/uk8UTaNwv6JpUmQ805
         YgJR0Nl0vne392X5jSeHJa6URY2mqfdOcK1I69vww560N54VbCYjt71K8PrUM7f0Chxa
         YWL4h4KBf+zi8iWhtQoWQUc2/C1a8+HpHg9fYZAkMfYGpIVzg/iVmbJZ4gAG/DgWUISS
         qEWHbunlq8x7yS0U1Io7sm1VB9nPh3mjwbzhr0uIbiaCo3pmRIOJ/0opojQU34prGTh+
         q7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=u0otRQ4HRB+YKeilmTal/RUC4w+MjwFliS0R169CA7s=;
        b=h3jlXj0PCLBo/hbIJof0pPCT51BeSbeL9FQ3uoxgCDDL1fzVKigV6CWtMHQqEWsuHD
         ctdholj+A0yq6JJ/JMo8p5AjNFZ+pHWmC0qb+2Wq76g9Dat8InyzY34P91th2aajdG67
         cwySnuYEiGbNVE5ealZceaeGt5bm/eSw6LpBtmQPsFF5aBtwqOLdApZal6QH0dtTO4mH
         VvY0rz5GmBavLw6on61uzxloCG5SpxYACKTr/uSc/15gquD/ZQ7NPz7cKi6culphyDjY
         QwM6jw75IKFvWMZ6k+yQU+mnfH/aK6aOLTyCdx6c9prAkYdRNfz7gwpEHFc1hkH9z/27
         Lj+A==
X-Gm-Message-State: AGi0PuakFk6tnGkf952NugjKQwb5g7iTk7eN8paMX6AOuai8p9ijGLD6
        4XjrX+f88tyn06wbiitrPps=
X-Google-Smtp-Source: APiQypJQTeHAEnS3J65bj3d5lEQgh6haVB0NClBsAbTwosD6YRCd9HZoVfbdmACo+8rNsGkAqoy3Zw==
X-Received: by 2002:ac8:fee:: with SMTP id f43mr4727473qtk.376.1588265679714;
        Thu, 30 Apr 2020 09:54:39 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:f989])
        by smtp.gmail.com with ESMTPSA id i6sm414723qkk.123.2020.04.30.09.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 09:54:39 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:54:37 -0400
From:   Tejun Heo <tj@kernel.org>
To:     fdmanana@kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dennis@kernel.org, cl@linux.com, akpm@linux-foundation.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] percpu: make pcpu_alloc() aware of current gfp context
Message-ID: <20200430165437.GF5462@mtj.thefacebook.com>
References: <20200430164356.15543-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430164356.15543-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 30, 2020 at 05:43:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Since 5.7-rc1, on btrfs we have a percpu counter initialization for which
> we always pass a GFP_KERNEL gfp_t argument (this happens since commit
> 2992df73268f78 ("btrfs: Implement DREW lock")).  That is safe in some
> contextes but not on others where allowing fs reclaim could lead to a
> deadlock because we are either holding some btrfs lock needed for a
> transaction commit or holding a btrfs transaction handle open.  Because
> of that we surround the call to the function that initializes the percpu
> counter with a NOFS context using memalloc_nofs_save() (this is done at
> btrfs_init_fs_root()).
> 
> However it turns out that this is not enough to prevent a possible
> deadlock because percpu_alloc() determines if it is in an atomic context
> by looking exclusively at the gfp flags passed to it (GFP_KERNEL in this
> case) and it is not aware that a NOFS context is set.  Because it thinks
> it is in a non atomic context it locks the pcpu_alloc_mutex, which can
> result in a btrfs deadlock when pcpu_balance_workfn() is running, has
> acquired that mutex and is waiting for reclaim, while the btrfs task that
> called percpu_counter_init() (and therefore percpu_alloc()) is holding
> either the btrfs commit_root semaphore or a transaction handle (done at
> fs/btrfs/backref.c:iterate_extent_inodes()), which prevents reclaim from
> finishing as an attempt to commit the current btrfs transaction will
> deadlock.
...
> This could be fixed by making btrfs pass GFP_NOFS instead of GFP_KERNEL to
> percpu_counter_init() in contextes where it is not reclaim safe, however
> that type of approach is discouraged since memalloc_[nofs|noio]_save()
> were introduced.  Therefore this change makes pcpu_alloc() look up into
> an existing nofs/noio context before deciding whether it is in an atomic
> context or not.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
