Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4574C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA512175B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548801825;
	bh=HFxu0VFGNX5lKIGQAnvvklfeALH0M4AhEbyocQeNKOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iMat6yFFCI3SEujT7OqYmjg8iuQrH0Zw16bAF/SL43NiqGTKuqs0kCiqxoNgvCA8a
	 nRTGKaiD1y8JgFrNADhFbm/Nyh8eTNAro+VtmFyYPSAZzPJPpq2AwncHYxYJhjWDse
	 djB+urfmyXagmorctEs0p9lbamnPVVFY05ZnmghM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfA2Wne (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 17:43:34 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45490 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfA2Wne (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 17:43:34 -0500
Received: by mail-yw1-f65.google.com with SMTP id d190so8854970ywd.12;
        Tue, 29 Jan 2019 14:43:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fEJbE/ywGzh83Tzyph5e5xJGrSMLJvMydLxy61aXPL8=;
        b=Ib+bzy3R70eEUbilZmjTRMu/GkUisHTrQISmEuV82TfrIqL4yaxLqwO7v8kVbTUCD0
         7tQKw0lvaIfg9NnmuUc56tUNkr/UuzIaaQP1WOdXLaxUvrpnfL5hfEpqMmJTQ8mTVSiw
         ODgAuAnYeBTK1X9PFIS9bK8q87BqjDO3KA7rNsCAoLl5xkn6C91YMMhgmZFc5ZuoQw6Y
         wD2BXcvaY3opope2gydw5pihDK2lptNwR5P4xZrb1QF+/dxmZ5TGRdShdWXN7kRrhioX
         +0ZKc9I/gH8xkJ3IMgsoQOY5D4WOM8kRD+6agHZ11+b3zilLzkfKD2M46odhUeB7p7bi
         e55w==
X-Gm-Message-State: AJcUukdIKGQ4yNdf0q4ekUp5KEJmJeAGePAe6deXnwc8ysJ7WPHA9JC/
        BaGClPYHmx3NOPhXrZFkN4M=
X-Google-Smtp-Source: ALg8bN5z2FBpz3se6uUaNzMZImf5j+//jVqfvS7tPhukQIlW7npmZuraofxJgoJRjy9bteaFfMyvGA==
X-Received: by 2002:a0d:d586:: with SMTP id x128mr27137899ywd.346.1548801813467;
        Tue, 29 Jan 2019 14:43:33 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::5:f5f4])
        by smtp.gmail.com with ESMTPSA id n16sm18540726ywn.31.2019.01.29.14.43.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 14:43:32 -0800 (PST)
Date:   Tue, 29 Jan 2019 17:43:30 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] btrfs: manage heuristic workspace as index 0
Message-ID: <20190129224330.GA87266@dennisz-mbp.dhcp.thefacebook.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-4-dennis@kernel.org>
 <4bc26773-da13-3730-afda-78d672f348bc@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bc26773-da13-3730-afda-78d672f348bc@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 09:53:33AM +0200, Nikolay Borisov wrote:
> 
> 
> On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> > While the heuristic workspaces aren't really compression workspaces,
> > they use the same interface for managing them. So rather than branching,
> > let's just handle them once again as the index 0 compression type.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com> albeit one minor nit
> below.
> > ---
> >  fs/btrfs/compression.c  | 107 +++++++++++-----------------------------
> >  fs/btrfs/compression.h  |   3 +-
> >  fs/btrfs/ioctl.c        |   2 +-
> >  fs/btrfs/tree-checker.c |   4 +-
> >  4 files changed, 33 insertions(+), 83 deletions(-)
> > 
> > diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> > index aced261984e2..bda7e8d2cbc7 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -37,6 +37,8 @@ const char* btrfs_compress_type2str(enum btrfs_compression_type type)
> >  	case BTRFS_COMPRESS_ZSTD:
> >  	case BTRFS_COMPRESS_NONE:
> >  		return btrfs_compress_types[type];
> > +	default:
> > +		return NULL;
> 
> nit: With this change...
> 
> >  	}
> >  
> >  	return NULL;
> 
> This becomes redundant. I doubt the compiler will issue a warning since
> it should be clever enough to figure we will never exit the switch()
> construct.
> 

Ah yes. I've removed it for v2.

Thanks,
Dennis
