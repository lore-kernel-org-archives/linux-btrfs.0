Return-Path: <SRS0=o9HI=XH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9217C5ACAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 09:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E61208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Sep 2019 09:26:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mbobrowski-org.20150623.gappssmtp.com header.i=@mbobrowski-org.20150623.gappssmtp.com header.b="12hCQat9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfILJ0W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 05:26:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45930 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbfILJ0W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Sep 2019 05:26:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id 4so13138970pgm.12
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2019 02:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbobrowski-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dt0j6/Dbs+dwW1SIPthaW+qziOAlFsuqXt20b4c12nE=;
        b=12hCQat9jUcgSa47++/HQI/Kl7LxMpOdcs5vqzMW95pKZMUHEhyw9ZMTKknS+6Z2Rx
         K9qJNKmsGVjwgxprs5gDVl8K+aUT2VnsLU60nF0AzZqv5zXtsCwN++iPfEVHgWC+J7j+
         dzo27W3kuN+k10OHxZQp4JFaIL0RYtJn0rAoEKVV3Tjp/yso+xeP3PIyvRGhxb2KSfST
         ffoFGuMIjtreThdQ+W41KGD+0jkLetWQM+B1FTVLAr6v++nXXRuC0Pw6a6KKqO9IL1Es
         KlgfJcVrWGFzhtJHgrA+FEtA/80mCRFIS7z+ma8tpq3q4vca8MZ/qHfHgMp7DzPy84Ad
         FAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dt0j6/Dbs+dwW1SIPthaW+qziOAlFsuqXt20b4c12nE=;
        b=j267qBqIsQWI1Iz6IASbdp7qxiDFf9L4rkpYwgYPbEiqBGCk7UvDfDM7A/Oapc86lb
         KgPNUBXlCWoT3W6Rr1KcV9Qenl61ZcwxS24gSCOxH0LEFdNIJ513t77IfsPKDii+v/Ve
         gygQeyGjsvfkcPVoN0uEq1BIhnK1/JivIffGLSjFmVMa6veBB4lmtbTlNKFk75OtGGj9
         I+wiubFaTuLX+SsRpJGilYuAp0vaz3jvGPJnoDbYwxObBzsagrmv4htNocy0FRohq9ls
         0tpBkNo1enVHbfnGZZbjws+3NUAgNCIUj8GwiJDAhMQ1p/ILpk4StIH5zIjHcJfkBR5W
         xf5g==
X-Gm-Message-State: APjAAAW6Db1XSY6AL7QaodzyYhLrp5jAhEn5m+ly7VF3crgOjN2F2cP4
        gVUE0CSkL7dYTLwDyEC2nNYG
X-Google-Smtp-Source: APXvYqwyIDlF1caDTpNVqUKoLG7l8JslVWsCl4azAP5rgYV6Wp1tuclPnO2lsBQan2QfColr2D8A2g==
X-Received: by 2002:a63:211c:: with SMTP id h28mr36886434pgh.438.1568280381146;
        Thu, 12 Sep 2019 02:26:21 -0700 (PDT)
Received: from bobrowski ([110.232.114.101])
        by smtp.gmail.com with ESMTPSA id c62sm29491396pfa.92.2019.09.12.02.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 02:26:20 -0700 (PDT)
Date:   Thu, 12 Sep 2019 19:26:14 +1000
From:   Matthew Bobrowski <mbobrowski@mbobrowski.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hch@infradead.org, andres@anarazel.de,
        david@fromorbit.com, linux-f2fs-devel@lists.sourceforge.net,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        aneesh.kumar@linux.ibm.com
Subject: Re: [PATCH 2/3] ext4: fix inode rwsem regression
Message-ID: <20190912092614.GB9747@bobrowski>
References: <20190911093926.pfkkx25mffzeuo32@alap3.anarazel.de>
 <20190911164517.16130-1-rgoldwyn@suse.de>
 <20190911164517.16130-3-rgoldwyn@suse.de>
 <20190912085236.7C51642042@d06av24.portsmouth.uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912085236.7C51642042@d06av24.portsmouth.uk.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 12, 2019 at 02:22:35PM +0530, Ritesh Harjani wrote:
> cc'd Matthew as well.
> 
> > This is similar to 942491c9e6d6 ("xfs: fix AIM7 regression")
> > Apparently our current rwsem code doesn't like doing the trylock, then
> > lock for real scheme.  So change our read/write methods to just do the
> > trylock for the RWF_NOWAIT case.
> > 
> > Fixes: 728fbc0e10b7 ("ext4: nowait aio support")
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This patch will conflict with recent iomap patch series.
> So if this is getting queued up before, so iomap patch series will
> need to rebase and factor these changes in the new APIs.

Noted. I've been keeping my eye on this thread, so I'm aware of this.

--<M>--
