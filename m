Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C23C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 454B32087C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="h8jjfQvC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 454B32087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390048AbeKQCRk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:17:40 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38186 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728577AbeKQCRe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:17:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id q1so3612021pfi.5
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=anPsNRx0uZfFKnyoFFFtlbsGc9ac2h1lk5UPV1Hc0z4=;
        b=h8jjfQvCViz/fLw5xy+8P4+tQZ4Vw11AmPvROiA9QddEBPFl+EG6DdWDUM8Oww3wEL
         pfvL8qk/JnDe/76MbW6hLKRhgbY5U8B/RjpmmlMV26EtDzj2zlbtKUf5FZKFHFnc20DT
         4v7Di7rPjVA5po7eckmpcfla148FIQdz7Z92DQ9b8gCXEZtX7a/xvOapmfytOMR9GUFT
         cjFNj3noQXOoLxSltoJvbzfiurOyiyAPRdOBdaCCBCnjtJfsL+Ni2o5P1iEvsE7l2bYH
         kmO373EhPVMD+JWhUfBk+aPThn8IeUYfjoJ/wdA+MCxDdOWbnToe5Yeg1eXY7Dz722iI
         sNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=anPsNRx0uZfFKnyoFFFtlbsGc9ac2h1lk5UPV1Hc0z4=;
        b=XP3HJtva4N+Cdgtw865mkYCQwGpa6hddm8ihqFyXIb5UiMF3JEbIJvfLaA2yRMw+oA
         bLFA4Wajg6Fzl0fuVOVUYzDGsqV7u0/BgmKebnE3bYyPyGUZbqqFjjvRgKKDuPZLf/c/
         VoBidQ6R11tIHqDFkIBrgsfRpfWMqbZ+JiOj4pfv7fuW1luha/AhhDO3AtMUghHepjLy
         bEhACPje/Q6lg8gRhbfmEsQasW7BPSM3WYpEtBkBWSmiUjIoBZ2zT5WQEaVkeIZOJIah
         uC+7pdmU3sIjZ2LYhq3lnrjzWcTfQ5AacaNE4pWPiULBmvDZP2krnsarBmVn91s4wWbv
         NeXw==
X-Gm-Message-State: AGRZ1gKrJoaOOYD4HfYe25rP8kyu2InASYEihIge6BrCCb84mXy/mUgG
        VcpfxObQUArybM8Kgwbd9SIrPg==
X-Google-Smtp-Source: AJdET5dCSmENmtth+4RvDrhTLZOKB8z/G4vAqSrTrSpiBniMbshmuyCEL+8XmCwl5rLQCRLdrzcxSg==
X-Received: by 2002:aa7:8254:: with SMTP id e20-v6mr11831931pfn.164.1542384276490;
        Fri, 16 Nov 2018 08:04:36 -0800 (PST)
Received: from vader ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id d21sm23998333pgv.37.2018.11.16.08.04.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Nov 2018 08:04:35 -0800 (PST)
Date:   Fri, 16 Nov 2018 08:04:33 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
Message-ID: <20181116160433.GV23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com>
 <20181115202028.GC9348@vader>
 <20181115210510.GA24908@redhat.com>
 <20181115221847.GD9348@vader>
 <20181116091956.GA17604@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116091956.GA17604@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 10:19:56AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 02:18:47PM -0800, Omar Sandoval wrote:
> > My only reason to prefer unsigned int is consistency. unsigned int is
> > much more common in the kernel:
> > 
> > $ ag --cc -s 'unsigned\s+int' | wc -l
> > 129632
> > $ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
> > 22435
> > 
> > checkpatch also warns on plain unsigned.
> 
> Talk about chicken and egg.  unsigned is perfectly valid C, and being
> shorter often helps being more readable.  checkpath is as so often
> wrongly opinionated..

Fair enough. Since enough people don't mind bare unsigned in the block
code, I retract my comment :)
