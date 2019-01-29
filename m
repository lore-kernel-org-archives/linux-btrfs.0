Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B10C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F4E20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sZf7AhBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfA2SRU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:17:20 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42297 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfA2SRT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:17:19 -0500
Received: by mail-qt1-f194.google.com with SMTP id d19so23318606qtq.9
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ApmOKSKwJ34ByPx19EXm+YEtEj3MA8QK8o2g/+hj+FI=;
        b=sZf7AhBz6aFYiMtKB7dZHDPmigJ2H80teY097Ul6nJ0GKxtXNdOoOIzz11LOauzV2P
         XONUm3CW1F05iHWbR84ZBoLIkukGIyWqtftsMKjzM0uuCM+AkZ5eHValtkoNqm0mp0vb
         6/avAGPnX7Xw/3oEqsN710SI3RvyRwzQ2nBKczUUJIt376GlenUsrmHNSuYp1U3UMWlw
         xLG1UjqpUlrN+qwMss8Xws36ivvk22Wfnc+nerHRpZICWGBCkJdDzyXWyBJzVPzISXYK
         I/xoBEi559hd3h/1nPFV9qLaJCHBjGYk8BjZJFf7avPfBiWjfM8dbZQal1m4BMNPhGkg
         XhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ApmOKSKwJ34ByPx19EXm+YEtEj3MA8QK8o2g/+hj+FI=;
        b=Ct2T3svvYjRulvcfHf2xPlm+Ba2DdoJY45Vzu4iYgXwhoIh4UhQwtSncKBa7l/XI+8
         8phTtDXVrKw4UsTSq/psrwytCDeYCRaozkxFm3uMG2vImdckmQLAZChcdPuFp6/VobkB
         jwotEwz7tyVP69SYbxjkAoru2lSlmheV5ZLG4wEhJ5yuHI1hOJi/pP3fZAtSIXusqz5/
         JKJRxsvRBS8GQ1XDtdy1z9aedZn6twsTJ7XRUuh40bVqfyPZRhRNtfiCF8rqL0cYPglX
         A9d6U8v8NBzbSmkv7UQla7ir2pBnnu7IN7/0DqkVzZbSQqKlmp5Y1cHb/5vlnaISssLB
         pjCQ==
X-Gm-Message-State: AJcUuketnw9LwerKGAY39umZ9VwD17b6E4J/ir+pQ1tHyQB43KMtzRmS
        spJr2Br9G0uuKvvMM+kfKEkKA2q3vAI=
X-Google-Smtp-Source: ALg8bN7eKd8F80p/BHanCqsaxp1FwazPrdHwgML7hhh3MNGzQ6lrazltapfHcZn/fuPd5BxEjIMljA==
X-Received: by 2002:a0c:a545:: with SMTP id y63mr25234040qvy.119.1548785838791;
        Tue, 29 Jan 2019 10:17:18 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a3sm93479632qta.21.2019.01.29.10.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:17:18 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:17:17 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] btrfs: move to fn pointers for get/put workspaces
Message-ID: <20190129181716.hstuxkdzai4qiist@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-8-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-8-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:33PM -0500, Dennis Zhou wrote:
> The previous patch added generic helpers for get_workspace() and
> put_workspace(). Now, we can migrate ownership of the workspace_manager
> to be in the compression type code as the compression code itself
> doesn't care beyond being able to get a workspace. The init/cleanup
> and get/put methods are abstracted so each compression algorithm can
> decide how they want to manage their workspaces.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

We're doing this to have special handling for extra workspaces to be free'd at
some point in the future if they are unused.  This is fine by me, but why not
just add a shrinker and let it be handled by memory pressure?  Then we avoid all
this abstraction and allow for ztsd to have its shrinker for its extra
workspaces.  You can even use the list_lru stuff to make it super simple, then
you don't have to worry about all the infrastructure.  Thanks,

Josef
