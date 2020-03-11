Return-Path: <SRS0=EJVa=44=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D22EC10F29
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 09:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110D62192A
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 09:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="hVW8Xuzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgCKJHv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:07:51 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45121 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCKJHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Mar 2020 05:07:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id m15so814536pgv.12
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2020 02:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k3awJF+JlZKRapJApKhP+u8BN/buBk0hi661+yc2cq0=;
        b=hVW8Xuzbr6hysGKmE3l6IyRA6v/U0fm4LAy5+bLWN5y+igN+UEPVPVObO/6mj2uryg
         U+LBkIGxUIXPK7SAkm80TvlKV4c0+Nu9lJzBhtaMxAXd+bozZEz0zu2264Lh+4EjPD+5
         SeeV0Z8s+/QgO/Xa1jCcGb2AahnqeoCx8POqNwwUwJNQrN0PtoYvVziFy4ENzbLwV7xU
         nrQpGUB8B0jscupgmto1vhDkUJDJpVcQZ366GP9ydbhDDuBscGvDcrATTkRLd4OTtBui
         ISbJ0kIMPf1PR4TknAXCZBUAC0daYd0Y2AbvODtmyWD+2pcwmYRV/vZvjeuItGTpyLpQ
         x9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k3awJF+JlZKRapJApKhP+u8BN/buBk0hi661+yc2cq0=;
        b=YiOTnTPH1xqmx3Nt/nwnAtUv8bi1f1ozdPnh0l9h2ccHvCynuCz+19TmnIqaIvREqT
         PQj24kBh1NIPp7iT0sIn9r8d4uZ11zxRpXE2Nx74K4ln+qH3lUgfi3fqk4F0MvCKzyVO
         ikoHM97fhfDzSn8dBz27TeR2hooSIqtMqiEzxl7O/AkwPHinm54O6gL00EQT/4zulhEp
         IgF60+SqWWU13Q/8hkayjyIfzYsBoomgrLReiaqfx+uatY/8RA7fcD9Y6nISEMoXp2gb
         VVR8xQ2SBq2UvKQBfckzs9T3oh+djFmbMxPZhKvtLj4hRXBJ668KeuiVUL0qUIZCEtSA
         iV0w==
X-Gm-Message-State: ANhLgQ2JJd7I0TwZMQ9nA7Mqww3kI4TqCk6BPh2oijJq8sNCAqTsinff
        US71Ikvr43rc5QzjdPlQ+kI4v4r44Rs=
X-Google-Smtp-Source: ADFU+vtnAKzAQejNGSjB+L1Z/aQEsTBm2rd3pk8iI54ZIf4VrXvK1EJh39ubcpyodR92Q2AAGvgYdg==
X-Received: by 2002:a63:1744:: with SMTP id 4mr2033040pgx.238.1583917668886;
        Wed, 11 Mar 2020 02:07:48 -0700 (PDT)
Received: from vader ([2601:602:8b80:8e0::14a2])
        by smtp.gmail.com with ESMTPSA id b9sm20674034pgi.75.2020.03.11.02.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 02:07:48 -0700 (PDT)
Date:   Wed, 11 Mar 2020 02:07:47 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 03/15] btrfs: look at full bi_io_vec for repair decision
Message-ID: <20200311090747.GE252106@vader>
References: <cover.1583789410.git.osandov@fb.com>
 <c0f65f07b18eee7cef4e0b0b439a45ae437a11c6.1583789410.git.osandov@fb.com>
 <20200310163319.GC6361@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310163319.GC6361@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:33:19PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 09, 2020 at 02:32:29PM -0700, Omar Sandoval wrote:
> > +	/*
> > +	 * We need to validate each sector individually if the I/O was for
> > +	 * multiple sectors.
> > +	 */
> > +	len = 0;
> > +	for (i = 0; i < failed_bio->bi_vcnt; i++) {
> > +		len += failed_bio->bi_io_vec[i].bv_len;
> > +		if (len > inode->i_sb->s_blocksize) {
> > +			need_validation = true;
> > +			break;
> > +		}
> 
> So given that btrfs is the I/O submitter iterating over all bio_vecs
> should probably be fine.  That being said I deeply dislike the idea
> of having code like this inside the file system.  Maybe we can add
> a helper like:
> 
> u32 bio_size_all(struct bio *bio)
> {
> 	u32 len, i;
> 
> 	for (i = 0; i < bio->bi_vcnt; i++)
> 		len += bio->bi_io_vec[i].bv_len;
> 	return len;
> }
> 
> in the core block code, with a kerneldoc comment documenting the
> exact use cases, and then use that?

That works for me. I was microoptimizing here since I can stop iterating
once I know that the bio is greater than one sector, but since this is
for the rare repair case, it really doesn't matter.

On the other hand, a bio_for_each_bvec_all() helper would feel less
intrusive into the bio guts and also support bailing early. I'm fine
either way. Thoughts?
