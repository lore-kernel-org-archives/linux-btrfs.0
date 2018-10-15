Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539D3C7112A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 06:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD822086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 06:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0EWkHPx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AD822086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbeJONsM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 09:48:12 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38505 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbeJONsL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 09:48:11 -0400
Received: by mail-yb1-f196.google.com with SMTP id e190-v6so7060536ybb.5;
        Sun, 14 Oct 2018 23:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/YZP89amjKg8soR5hutwVGiJjdiUiUoODs0AIZZk1bg=;
        b=U0EWkHPxv4egfnyZYelO5Pj6Yp7Es+ed/SmPY8adNHy32ePpbvW9+5OAhFqVCUSol0
         knOylzNmyFhQvpX8nM/bkVw1hI9eUpup6ePmZXgQUvdI+ayeccTBlmUegHCkLcWGdN4g
         LcXN4ZXyS6FVd/lrwRHJIdTYr6GMxPYcdrutxhTIUcBlUqJ4Ul3n/Fd7A1/7alh+ifNL
         JS3OeNqAoznbMvoWTJ15o+HdW3a40Acv5uk5pT4HLsn/pCIs1cQHFbc0ClorkGWrwLlg
         8omkIVAd4SHuFrb+l8gVT6isjZI8qQ9MazX1KWt/tu76ZPSu9cJ4WcUDvqCMBATsPBXp
         blkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/YZP89amjKg8soR5hutwVGiJjdiUiUoODs0AIZZk1bg=;
        b=hfg2bkh9kyN/YKMEsdgmJDXvYfIQGmF0XGkr7mSdEOmVzpcT6wRvDresBvsQ/A7s2k
         2sLfPS4Pv5XCZZauTH8hF+J2J525p7GD6/Fj2hFo8RpDijZJQ4vzt54BitPMr2GF8WJt
         erOaaBgIRAMuntXXe+VWeMxQhNc4781XNM+eV/2sWn62zp5fZ92DQdcqhFJ4UWf9vgYs
         IlSa348VrWv+G4LEhhP2uqiK4cfk6NKO61vxkPtOzRQiDRCLMo+imMYYTZI+fqhsiWEK
         bVFj0QO0uejDOsu6ET5tNzfrC3vwgZW+mQVCnNS3qsI5JoSLJlvhq9LqDGXvLlCZXDXf
         0lmw==
X-Gm-Message-State: ABuFfojhrlAfWMiIIxlVs3IMxFRZRxwi1YqVEBk1yurvkwBi7VV2ETH0
        m9CHXuTlyLamzbs69KplMkURLwymf4Cxs8S48lI=
X-Google-Smtp-Source: ACcGV60OhDgfOVdNbHZOE0VE0O7LxDCLg+QmRNUt9rnvubN99KJXXpaIKhiMqUlEV2jqEshe2C6Y3xoGUct1H9OCyR8=
X-Received: by 2002:a25:ad4a:: with SMTP id l10-v6mr2000167ybe.507.1539583464680;
 Sun, 14 Oct 2018 23:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia> <20181014171927.GD30673@infradead.org>
In-Reply-To: <20181014171927.GD30673@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Oct 2018 09:04:13 +0300
Message-ID: <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single remap_file_range
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> > +/*
> > + * These flags control the behavior of the remap_file_range function pointer.
> > + *
> > + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> > + */
> > +#define RFR_SAME_DATA                (1 << 0)
> > +
> > +#define RFR_VALID_FLAGS              (RFR_SAME_DATA)
>
> RFR?  Why not REMAP_FILE_*  Also why not the well understood
> REMAP_FILE_DEDUP instead of the odd SAME_DATA?
>
> > +
> > +/*
> > + * Filesystem remapping implementations should call this helper on their
> > + * remap flags to filter out flags that the implementation doesn't support.
> > + *
> > + * Returns true if the flags are ok, false otherwise.
> > + */
> > +static inline bool remap_check_flags(unsigned int remap_flags,
> > +                                  unsigned int supported_flags)
> > +{
> > +     return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> > +}
>
> Any reason to even bother with a helper for this?  ->fallocate
> seems to be doing fine without the helper, and the resulting code
> seems a lot easier to understand to me.

I supposed you figured out the reason already.
It makes it appearance in patch 16/25 as RFR_VFS_FLAGS.
All those "advisory" flags, we want to pass them in to filesystem as FYI,
but we don't want to explicitly add support for e.g. RFR_CAN_SHORTEN
to every filesystem, when vfs has already taken care of the advice.

The reason a similar helper doesn't make sense for ->fallocate()
is because vfs does not take any action on behalf of filesystem
nor does vfs pass any internal flags to filesystem.

I argued that fiemap_check_flags() should similarly mask out
FIEMAP_FLAG_SYNC before checking supported fs_flags,
because ioctl_fiemap() respects this flag regardless if filesystem
(or generic helper) declares support for FIEMAP_FLAG_SYNC.

Thanks,
Amir.
