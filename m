Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256CAC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E13842086B
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="aB4svGZ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E13842086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390269AbeKQCxk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:53:40 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35860 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390049AbeKQCxh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:53:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id b85so4831547pfc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2UIrJLU44vLfyM1GaYdgYb8aFp1tVp8wrSUZpBwp96A=;
        b=aB4svGZ9OFckPOMSQl095156w9SKLCbC7XiIVLgOnRsJM2+Lu5ln3wjnKRyMtMPe7b
         oj86T/T8OQMh0LFDqCDd0aynQvY5eBRj0La5PQce+zyuWJQaSNe/Bsv/WKijc50ELDGA
         yAwfssofJsqDbUc94Rg7YHiC6vutqOGuVSXnmeuuYCTUJ0KTDKR1AN7Xqj0BAtBEMBoJ
         b0kuMUEPHSeZAx4rvZZnmSglXChKVJz4t/iCg+7qcWRpDiwus46kutTn2NqPIT/ZD7BG
         fClNkdZeyRvD+z6dbFYbobwlR1AxPt7Dbl9ANQzOfTXR5EnfAvvQdi9AGmw3pihcU542
         qNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2UIrJLU44vLfyM1GaYdgYb8aFp1tVp8wrSUZpBwp96A=;
        b=WZnrb79Al1SIJbGx7wTkbdavBfPR35ZheU4Yss4RaFunbadgdZQaWJHeQvGnTaNuz3
         NInqiYeuWLuF1WzclJkIEA5H6lXO7o5/4NuF+SrDM0laO4fKRU310c6gWIx6N38cxbfn
         lJyRYI03jOzcrEVHVZRtheYB96T5bt+2gqOPIIaluPj05KrBRD3OMfQufcetLnrM3hFj
         eEImZDnjC5Z3rdFqBBjSeUYfwgTGiy2dyiSFjGL24utODDkqOBYFUxgdRa/GA4OhaNus
         9RZm+CO/VKmfkFPXmO7CGaCRAlpuej1Y8oCoAIiZCcWguGlLUYODYbij0d0RMQ/U/Dcc
         Qcvg==
X-Gm-Message-State: AGRZ1gLvQuilECIwSyecT5T+e2URIHG1nQKNnpOFVE28i3M1JZM5z12v
        SkWtlg2PZx6UcjMkF7GaRIv6kQ==
X-Google-Smtp-Source: AJdET5f+s9XT96L6c7XnPZBglWcnGckfH8lsTWflIPtLsRqj3xUKDT2yZwzel9Bs+QmGOb2aTPeQtg==
X-Received: by 2002:a63:164d:: with SMTP id 13-v6mr10678635pgw.103.1542386431231;
        Fri, 16 Nov 2018 08:40:31 -0800 (PST)
Received: from vader ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id r6-v6sm41944759pfk.157.2018.11.16.08.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Nov 2018 08:40:30 -0800 (PST)
Date:   Fri, 16 Nov 2018 08:40:28 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
Message-ID: <20181116164028.GW23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
 <20181116021811.GM23828@vader>
 <20181116135922.GO3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116135922.GO3165@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 02:59:22PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 06:18:11PM -0800, Omar Sandoval wrote:
> > This commit message wasn't very clear. Is it the case that
> > QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?
> 
> I think he wants to say that not doing S/G merging is rather pointless
> with the current setup of the I/O path, as it isn't going to save
> you a significant amount of cycles.

Okay, that makes sense. Ming, you can add

Reviewed-by: Omar Sandoval <osandov@fb.com>
