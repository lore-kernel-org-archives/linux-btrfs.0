Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D52AC282D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 22:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 362F220857
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548889174;
	bh=A3epGg3FwHhC11uQsyQhUAiNuR1cY/nXUkCz5bUqkSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=T62mv7itFHutQXwIeUH6s/ZpRerobZBF8m2B7b4wUIbqsH2d5zsslG04EulKOst+0
	 KoDGOYgZmke+B5x5a8b1rpHpYA98RNa8oOKcJ9v7cJ0fSz/eA719THKGlL1lD6kvQr
	 PF3t033WM8RJfWAk8S53aIWvTKJiHNb1YMPw9N+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfA3W7Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 17:59:25 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46301 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfA3W7Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 17:59:25 -0500
Received: by mail-yb1-f193.google.com with SMTP id 7so519486ybp.13;
        Wed, 30 Jan 2019 14:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+dJ04W65N3iNVrVUolqvLBzs+zc0DbcVcz/eBhNzGVo=;
        b=DWrxMlDUI5rRCrheIdE1/2lxJ8rbbRbvkAqivu5gfzKBm3ElvAMU8sRzr4c/1YgTNf
         U/rUAsiAZZdcvjEkGJ3HZ1p+QXrWv+6OC7qxRdaK724vDGkggPsmSjROmhNbTbltypj7
         FXGpU2zfhcdmCm5zaftGxDoeSE4619+bkomLzNRZ3JwFzj+DFy1ZeOI+Q65wUCSTK9wF
         wve+vgeGDGYC3/rOo2fhCjf4Kb2Ux5b6U2pHTg9pMruS5FynL3Zw4pGe7uEv3iHoX7vH
         8zYE2DPIF/g1YVlcLlfin+Dfd7b81ypil76cYcl75UT0hO0nWS8UQUIaCx964ToqQuIA
         GnZQ==
X-Gm-Message-State: AHQUAuaw105l7vYpoPzi5ZrC/nboWO9Q8vL4xsfPdZ0LZOZl99RK6+FH
        hI4eaVpS0CGo1aAKH3ofZn4=
X-Google-Smtp-Source: AHgI3IZunoJF83hF5071h0T37K43gmZS7UUhHzJKUaMR+VkAwXZpUC9VpyzJU6kmU9pp16mzbo9V3Q==
X-Received: by 2002:a25:e09:: with SMTP id 9mr2795858ybo.226.1548886019940;
        Wed, 30 Jan 2019 14:06:59 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::5:f3d1])
        by smtp.gmail.com with ESMTPSA id i13sm914751ywe.53.2019.01.30.14.06.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 14:06:58 -0800 (PST)
Date:   Wed, 30 Jan 2019 17:06:56 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] btrfs: change set_level() to bound the level
 passed in
Message-ID: <20190130220656.GA50584@dennisz-mbp.dhcp.thefacebook.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-10-dennis@kernel.org>
 <372d47b8-457d-db5d-61f4-de7b901c5e78@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <372d47b8-457d-db5d-61f4-de7b901c5e78@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 10:14:18AM +0200, Nikolay Borisov wrote:
> 
> 
> On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> > Currently, the only user of set_level() is zlib which sets an internal
> > workspace parameter. As level is now plumbed into get_workspace(), this
> > can be handled there rather than separately.
> > 
> > This repurposes set_level() to bound the level passed in so it can be
> > used when setting the mounts compression level and as well as verifying
> > the level before getting a workspace. The other benefit is this divides
> > the meaning of compress(0) and get_workspace(0). The former means we
> > want to use the default compression level of the compression type. The
> > latter means we can use any workspace available.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> > ---
 >  }
> > diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> > index e3627139bc5c..d607be40aa0e 100644
> > --- a/fs/btrfs/compression.h
> > +++ b/fs/btrfs/compression.h
> > @@ -90,7 +90,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
> >  blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
> >  				 int mirror_num, unsigned long bio_flags);
> >  
> > -unsigned btrfs_compress_str2level(const char *str);
> > +unsigned int btrfs_compress_str2level(unsigned int type, const char *str);
> >  
> >  enum btrfs_compression_type {
> >  	BTRFS_COMPRESS_NONE  = 0,
> > @@ -149,7 +149,7 @@ struct btrfs_compress_op {
> >  			  unsigned long start_byte,
> >  			  size_t srclen, size_t destlen);
> >  
> > -	void (*set_level)(struct list_head *ws, unsigned int type);
> > +	unsigned int (*set_level)(unsigned int level);
> 
> It might be good to document the return value since this is an
> interface. AFAICS implementations are required to return the actual
> level set irrespective of what level was passed in, no?
> 
> >  };

Yeah that makes sense. I've added a comment about it in
btrfs_compress_op.

> >  
> >  static void zlib_put_workspace(struct list_head *ws)
> > @@ -413,15 +418,14 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
> >  	return ret;
> >  }
> >  
> > -static void zlib_set_level(struct list_head *ws, unsigned int type)
> > +static unsigned int zlib_set_level(unsigned int level)
> >  {
> > -	struct workspace *workspace = list_entry(ws, struct workspace, list);
> > -	unsigned int level = BTRFS_COMPRESS_LEVEL(type);
> > -
> > -	if (level > 9)
> > +	if (!level)
> > +		level = BTRFS_ZLIB_DEFAULT_LEVEL;
> > +	else if (level > 9)
> >  		level = 9;
> 
> nit:  This makes it a bit more obvious (IMO) that you are essentially
> doing max:
> 
> if (!level)
>    level = BTRFS_ZLIB_DEFAULT_LEVEL;
> level = max(level, 9);
> 

I agree. I've updated it in both places. It should be min instead of max
though.

Thanks,
Dennis
