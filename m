Return-Path: <SRS0=S96U=UT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83149C43613
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 16:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55EB12084E
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561048957;
	bh=zCmrEJj/5YbT7k1NdU6eqr1+CknKTQwhJf0kK5Gd8tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fdjzE3Naviu1O06EMDZKJmHfD98chMfrYkkPR3+KYRigUocl/YUm+WWjmThotCUcH
	 tS70znDO7VgQLYc/667Qx1B+v5OAcJtqJs5Fe/NZ71EQMTQbCTDJHaYb3O0DXT0wsA
	 nLuDaBXn+5Yvl7fvythwheynxpw0uPSuttq5Pgdw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfFTQmd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Jun 2019 12:42:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42634 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfFTQmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jun 2019 12:42:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so1974446pff.9;
        Thu, 20 Jun 2019 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bqZIqiC2yYn/o+bV0ZJOLIzThjXkYn2uG9o9ZjJa6hk=;
        b=aJXjIKNZrOuVv0daHxeRKl26YhxSc7OxATe5g5agihcDutsVoV8QnJ+dWHiIwzAqCl
         pE3HVL5RjrWIZ65jZwG7ltBKSmTmkK6K2/Xo2kFkAyDDgTnggrNWOIISIuq+gbgn3ZhE
         TzCcMB28dJ8/yPURo0HTYeZGCtDEvpXaHVy/wsVQIX4D1+y7DXNiq7rWv7UezTTztVFF
         ox2doav/9GzUNq10RwePuy778KcpEt1dS9tx0TntQAeO5b4OhUkUJNte1QYUqFi7iZpT
         Q90SNo8xa+f69+YZunlcowN/DQxZLoqaTE8KgQiJiwxAFO8hbAGbKmTLK0E+Ldg2mW2j
         xb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bqZIqiC2yYn/o+bV0ZJOLIzThjXkYn2uG9o9ZjJa6hk=;
        b=Gn3ufQbMmS9lyKecpgnpUgae0K1WJ60+qta2hBq/bzxR64Q2JKjF0k7cgS9KZ0jKcd
         whaSHj/ZzvsNfShat1WTEOcI+1BeiPfm7NqqcTA/ZxX3NJb4VZuSRaKlsy4z+mqgHzp5
         jvHX38mpUEFSMdUd6YGHPfUupSDzPv/BZlVLxqE8+Bx4OT7mRUyjiSkY7FEuFJr8Tt4S
         u4+ZIK+G6l3DVejoc2j/P94EI99eFbGLt3DdVLcxJzXdrAbyRGIm3IsRej0XHwPLmKD/
         ksC4YI2pj7CW/0EEDThegT9SZhlKf6WZ5eCKW3egxqY18pvrwI21zanIXLEWzT4upw9Y
         cJrg==
X-Gm-Message-State: APjAAAU8tqwbUnho48umq1IQGJVPhzoxRcF69EU+nqEdeBhAYCDmR9an
        kVDuuNd5L1HVWpcwhxL6Flw=
X-Google-Smtp-Source: APXvYqx072QE6ne/M+YjuzM0WPDx/elSTOitdaIoOS9wonauvSK6+p09K5VLrDBRVcopCvc7fjOCow==
X-Received: by 2002:a17:90a:bc0c:: with SMTP id w12mr496330pjr.111.1561048952289;
        Thu, 20 Jun 2019 09:42:32 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:8402])
        by smtp.gmail.com with ESMTPSA id y16sm2426pff.89.2019.06.20.09.42.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 09:42:31 -0700 (PDT)
Date:   Thu, 20 Jun 2019 09:42:29 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     dsterba@suse.com, clm@fb.com, josef@toxicpanda.com,
        axboe@kernel.dk, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 4/9] blkcg: implement REQ_CGROUP_PUNT
Message-ID: <20190620164229.GK657710@devbig004.ftw2.facebook.com>
References: <20190615182453.843275-1-tj@kernel.org>
 <20190615182453.843275-5-tj@kernel.org>
 <20190620153733.GM30243@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620153733.GM30243@quack2.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, Jan.

On Thu, Jun 20, 2019 at 05:37:33PM +0200, Jan Kara wrote:
> > +bool __blkcg_punt_bio_submit(struct bio *bio)
> > +{
> > +	struct blkcg_gq *blkg = bio->bi_blkg;
> > +
> > +	/* consume the flag first */
> > +	bio->bi_opf &= ~REQ_CGROUP_PUNT;
> > +
> > +	/* never bounce for the root cgroup */
> > +	if (!blkg->parent)
> > +		return false;
> > +
> > +	spin_lock_bh(&blkg->async_bio_lock);
> > +	bio_list_add(&blkg->async_bios, bio);
> > +	spin_unlock_bh(&blkg->async_bio_lock);
> > +
> > +	queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
> > +	return true;
> > +}
> > +
> 
> So does this mean that if there is some inode with lots of dirty data for a
> blkcg that is heavily throttled, that blkcg can occupy a ton of workers all
> being throttled in submit_bio()? Or what is constraining a number of
> workers one blkcg can consume?

There's only one work item per blkcg-device pair, so the maximum
number of kthreads a blkcg can occupy on a filesystem would be one.
It's the same scheme as writeback work items.

Thanks.

-- 
tejun
