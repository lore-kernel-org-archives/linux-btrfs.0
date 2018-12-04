Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4F3C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 18:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 955242081B
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 18:21:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cUjnFoPT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 955242081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbeLDSVE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 13:21:04 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35904 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbeLDSVE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 13:21:04 -0500
Received: by mail-yb1-f195.google.com with SMTP id w203so3419810ybg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 10:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nkCqozBC9vFqL8yOQR20q9UMsq5bVkM9KJ39qf1E/oU=;
        b=cUjnFoPTcuABLm83U3MCBo2kSOmzD/pctiE50YAbhURsTRCByDlY1/10ekyPRt0qdj
         ongvCuirAPrw2IQ2YeYkLJxESVL/yVzV3r+qqH0HGZa6BKiUKB/bEctuHrP0bLF/J/Rx
         csYRkQ7yiYzqzj+zFMQCzm6xhRCAhtFfM518vTHqOBUENeIMhx13QJ1oMgKvnrC3MwIh
         wm5esfRJQP2UfZZK4VwSGQGW1aWIv28tl0SS+hA3fbfnqbnWt4CcK5+v9phOI9QNIQ7R
         ncjnCfg1kqCNIi5akCzyQlREMD5AUBiqgzqoveNHlwh7vzdaua5FXwo+1nIidKVA1tAv
         BDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nkCqozBC9vFqL8yOQR20q9UMsq5bVkM9KJ39qf1E/oU=;
        b=PbO1zYyifxhfiYV7Hx6PQ0E0+gi4uPm144LbnQYFnI/jy/83aa05J8FDN7ZKgb4AV4
         9qXurv4fwjZXswIbdKpYFSS40S0K7c76/aXXmh2u/TVIMv9TYy9ofZhUX0hHegzh0Lr6
         5UzofLMpaOEJTi+rWYmOzSZRUU+ILpSNvEckZ+knsA5PTIQXM/YWXgEk7HMd+VGFnrgX
         v73qKsgu+JBwAUgqpd7oe7mQ6tjKozWdbYMfzyLgQALnMwMkNYYjTh/IQOOyJgVF5pPD
         7SMbbBn9oyTM3jl++UE9pymKGXMYlN9t6M+brtpOWNOGYYakut0AdIU4GaHaMPnmSfp6
         os8A==
X-Gm-Message-State: AA+aEWYffWwCpyRoTP3fSOQV5Ej6r08NuBV8x51PMtD7w6cgcZyF+c90
        GA+snl/IUzatszaloN5ocD7AeQ==
X-Google-Smtp-Source: AFSGD/W0CVnaiLpXbP34wxWr6qaTsI8WwcStCgS0J1viENdcevLVFMHn3k5CF8L+DZU1mlJZspKr2g==
X-Received: by 2002:a25:3487:: with SMTP id b129mr12500884yba.37.1543947663109;
        Tue, 04 Dec 2018 10:21:03 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p71sm1517714ywg.98.2018.12.04.10.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 10:21:02 -0800 (PST)
Date:   Tue, 4 Dec 2018 13:21:01 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a
 waitqueue
Message-ID: <20181204182100.v37rwsmlfatgslg7@MacBook-Pro-91.local>
References: <20181203160652.25078-1-josef@toxicpanda.com>
 <20181203160652.25078-4-josef@toxicpanda.com>
 <5caa415a-bfd4-2abb-11ca-d247c0d87c2c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5caa415a-bfd4-2abb-11ca-d247c0d87c2c@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 01:46:58PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 18:06 ч., Josef Bacik wrote:
> > The throttle path doesn't take cleaner_delayed_iput_mutex, which means
> > we could think we're done flushing iputs in the data space reservation
> > path when we could have a throttler doing an iput.  There's no real
> > reason to serialize the delayed iput flushing, so instead of taking the
> > cleaner_delayed_iput_mutex whenever we flush the delayed iputs just
> > replace it with an atomic counter and a waitqueue.  This removes the
> > short (or long depending on how big the inode is) window where we think
> > there are no more pending iputs when there really are some.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/ctree.h       |  4 +++-
> >  fs/btrfs/disk-io.c     |  5 ++---
> >  fs/btrfs/extent-tree.c | 13 ++++++++-----
> >  fs/btrfs/inode.c       | 21 +++++++++++++++++++++
> >  4 files changed, 34 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index dc56a4d940c3..20af5d6d81f1 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -915,7 +915,8 @@ struct btrfs_fs_info {
> >  
> >  	spinlock_t delayed_iput_lock;
> >  	struct list_head delayed_iputs;
> > -	struct mutex cleaner_delayed_iput_mutex;
> > +	atomic_t nr_delayed_iputs;
> > +	wait_queue_head_t delayed_iputs_wait;
> >  
> 
> Have you considered whether the same could be achieved with a completion
> rather than an open-coded waitqueue? I tried prototyping it and it could
> be done but it becomes messy regarding when the completion should be
> initialised i.e only when it's not in btrfs_add_delayed_iput
> 

Yeah a waitqueue makes more sense here than a completion since it's not a
one-off.

> 
> <snip>
> 
> > @@ -4958,9 +4962,8 @@ static void flush_space(struct btrfs_fs_info *fs_info,
> >  		 * bunch of pinned space, so make sure we run the iputs before
> >  		 * we do our pinned bytes check below.
> >  		 */
> > -		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> >  		btrfs_run_delayed_iputs(fs_info);
> > -		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> > +		btrfs_wait_on_delayed_iputs(fs_info);
> 
> Waiting on delayed iputs here is pointless since they are run
> synchronously form this context.
> 

Unless there are other threads (the cleaner thread) running iputs as well.  We
could be running an iput that is evicting the inode in another thread and we
really want that space, so we need to wait here to make sure everybody is truly
done.  Thanks,

Josef
