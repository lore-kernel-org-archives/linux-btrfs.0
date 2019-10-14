Return-Path: <SRS0=w+x4=YH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F046ECE58C
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2542F217F9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571083085;
	bh=44PHskbZtd/GIBKZoHAM3lq2DJjnpf8w7EE2T/XOeTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QuL5AeWsu0l6emWbo6usPWb3oY2tvHI4cpnMYx1h9GpgMpNfM/T43YyEkxdaqhZKK
	 bnMi8O1RoqVI1OvumopEqh4GFc8WlRUWtYlmGEVLDt4SVTnq2awUvbpnfxA/9dwnjy
	 4nID32A4lX5wDgh63GJ9zH2ez3bf/LEezB3O4onA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbfJNT6E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 15:58:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39783 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfJNT6D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Oct 2019 15:58:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so27103542qtb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2019 12:58:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qF0FI3tUQnro1oTBi+aelcKCcI4VW3HARQ3UCB4h1Hk=;
        b=RxSzhNH1kUE/WTgKQOCR1rDlwYStDt76Ubk2U9u+WPXMP0B7cGM6zhCOCCrecazcbQ
         HvacbXWeLSWKp4sLlw/F+9oGJfOufJX7Nq33JpV7K/QigjsbtQxrcXMkwxPODEKhlKll
         mO6nKpZN4MCYumQu7Bynkm7eoQzqdWSfoXCiwev7z52GKIFwaeKKL7ky4QHPohVUEU/k
         2c/hxp1NBH3i4fueYZJeyfVBe3cHcPLeqSmDBOwQQc0mOCcpNWPRY3MAAdbrfkWjDj7e
         x+BKo5K2fNrOuqqzDv1PJHJeZWM/T5FMwGi4H2uIlGbPMe5oWHtVW7wHCRxy/d0LOeFi
         YDhw==
X-Gm-Message-State: APjAAAUKIuRpS8LWO6rXfWtunhxEV0s3Zqk+Sd0uQafOKCI3u4mbHueh
        Ha4diwxdnVyHtEu4tgVZARY=
X-Google-Smtp-Source: APXvYqxZkHAHo+A2994WHaU5ojp7bcOPbLKjeRS/2ixFglMUlDkWAxz76hVY3LBlsYSCRLqT2QL/TA==
X-Received: by 2002:ac8:1c49:: with SMTP id j9mr35286389qtk.364.1571083081779;
        Mon, 14 Oct 2019 12:58:01 -0700 (PDT)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:500::2:b1f8])
        by smtp.gmail.com with ESMTPSA id b192sm8459159qkg.39.2019.10.14.12.58.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 12:58:00 -0700 (PDT)
Date:   Mon, 14 Oct 2019 15:57:59 -0400
From:   Dennis Zhou <dennis@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/19] btrfs: limit max discard size for async discard
Message-ID: <20191014195759.GD40077@dennisz-mbp.dhcp.thefacebook.com>
References: <cover.1570479299.git.dennis@kernel.org>
 <7eed2e0ebdc4cc4a7e31c6fa7a180f10158fba0f.1570479299.git.dennis@kernel.org>
 <20191010161637.5tyauzyb3trb72te@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010161637.5tyauzyb3trb72te@macbook-pro-91.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 10, 2019 at 12:16:38PM -0400, Josef Bacik wrote:
> On Mon, Oct 07, 2019 at 04:17:43PM -0400, Dennis Zhou wrote:
> > Throttle the maximum size of a discard so that we can provide an upper
> > bound for the rate of async discard. While the block layer is able to
> > split discards into the appropriate sized discards, we want to be able
> > to account more accurately the rate at which we are consuming ncq slots
> > as well as limit the upper bound of work for a discard.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> > ---
> >  fs/btrfs/discard.h          |  4 ++++
> >  fs/btrfs/free-space-cache.c | 47 +++++++++++++++++++++++++++----------
> >  2 files changed, 39 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/btrfs/discard.h b/fs/btrfs/discard.h
> > index acaf56f63b1c..898dd92dbf8f 100644
> > --- a/fs/btrfs/discard.h
> > +++ b/fs/btrfs/discard.h
> > @@ -8,6 +8,7 @@
> >  
> >  #include <linux/kernel.h>
> >  #include <linux/jiffies.h>
> > +#include <linux/sizes.h>
> >  #include <linux/time.h>
> >  #include <linux/workqueue.h>
> >  
> > @@ -15,6 +16,9 @@
> >  #include "block-group.h"
> >  #include "free-space-cache.h"
> >  
> > +/* discard size limits */
> > +#define BTRFS_DISCARD_MAX_SIZE		(SZ_64M)
> > +
> 
> Let's make this configurable via sysfs as well.  I assume at some point in the
> far, far future SSD's will stop being shitty and it would be nice to be able to
> easily adjust and test.  Also this only applies to async, so
> BTRFS_ASYNC_DISCARD_MAX_SIZE.  You can add a follow up patch for the sysfs
> stuff, just adjust the name and you can add

Yeah that sounds good. I exposed it as max_discard_bytes in another
patch and renamed all the variables to BTRFS_ASYNC_DISCARD_* around
discard size limits.

> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> 

Thanks,
Dennis
