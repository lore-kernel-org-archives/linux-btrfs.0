Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98202C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654EC21479
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="D3VuetEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbfDROKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:10:54 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42485 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388346AbfDROKx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 10:10:53 -0400
Received: by mail-yb1-f196.google.com with SMTP id l124so879191ybf.9
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dbEpCO36b2NizGkn3aqbLGQPUCPGalb+z8Lwy2lKS38=;
        b=D3VuetEOJCOIAbBIbQOC3ZwVe1WUwdxAiqx/wOoPzy0zwxX77ooTExBXNccxgK4O6a
         oeC5GVTznfNDSI1gdJWg6rTHWPGujPDjerbP32IGZQFcqeSgjEtwVD9LBvm1wyiA+WKr
         yjYZD+mxstyu18bu0O7ElEmLmmCqiCoVEKmEV6l5sVK60SbgGqZg/RegPECUTezVFDd3
         /U79boIAgtudpUXgen0nKnQhWtk0pTU5Z9fAyvP7/Fa0nTP1Xo6UfJcoCI0+0chMwR3t
         D6T/rPDh7fz8W4uplzTblnDW5MR3BuGSvqtqKQ/FpobO8d60IzcSkw8sd3JTSvJnNRMp
         ZO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dbEpCO36b2NizGkn3aqbLGQPUCPGalb+z8Lwy2lKS38=;
        b=VuV4d5QHySMx8dijxy6/5nsHi7LOaQHyoovvqXZW4idhJtpPae6osI+dQOMs6zkj3w
         42dFsH9w4uDzS/OnLYJq3TyADVPM5jGfaI7XiUiCaEP16NFmsgau7EBKtXX/6Y18wlUq
         z6B489VXFS7BKy9A2xp5l4ds3HoNSAOdUMK+2WQLTOcKB4izNswQ6nUoEMFzBQeyKByz
         UsW+ylIuLflSVLdZGoaK+ybfMJ70atMbVSOz+a21Q3rWcwkdPMe77Mb0epQSwm7yi1dK
         yRtSlimGIkhfo0Rq2x2a6OLK/E+54JZuxT7VbIrtD+H+tDSV6Y84ngsOJ8CuZgTJN6k5
         dcaA==
X-Gm-Message-State: APjAAAVAdEIltu0OW3+BCHTqPYZMn+23Vn8qbMbtuJdSy6mmJ4dwTBCu
        FkwEYCO2lZ+dyMHG82TB3i93wA==
X-Google-Smtp-Source: APXvYqyxNdpRCflfs/WXiaN+6RU1lfBL2fzLj8UnhS4WsLIB0ieHHQ4IbLdVLfNDbH2MbzxnW73k9A==
X-Received: by 2002:a25:6c88:: with SMTP id h130mr76191533ybc.112.1555596652861;
        Thu, 18 Apr 2019 07:10:52 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::e445])
        by smtp.gmail.com with ESMTPSA id l12sm701853ywb.60.2019.04.18.07.10.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 07:10:52 -0700 (PDT)
Date:   Thu, 18 Apr 2019 10:10:50 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
Message-ID: <20190418141049.gazrt4nw7ynlqayl@macbook-pro-91.dhcp.thefacebook.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 10:24:10AM +0300, Nikolay Borisov wrote:
> 
> 
> On 18.04.19 г. 10:21 ч., Qu Wenruo wrote:
> > There is a BUG_ON() in __clear_extent_bit() for memory allocation
> > failure.
> > 
> > While comment of __clear_extent_bit() says it can return error, but we
> > always return 0.
> > 
> > Some __clear_extent_bit() callers just ignore the return value, while
> > some still expect error.
> > 
> > Let's return proper error for this memory allocation anyway, to remove
> > that BUG_ON() as a first step, so at least we can continue test.
> 
> I remember Josef did some changes into this code and said that prealloc
> shouldn't fail because this will cause mayhem down the road i.e. proper
> error handling is missing. If anything I think it should be added first
> and then remove the BUG_ONs.

I'm ok with changing this, but it needs to be more than just one patch.  Make
alloc_extent_state_atomic() error injectable and then use either error-inject.py
in bcc or use
https://github.com/josefbacik/debug-scripts/blob/master/inject-error.py to test
it and fix all the fallout from not handling lock_extent() succeeding.

You can use https://github.com/josefbacik/debug-scripts/blob/master/codepaths.py
to find all call sites for inject-error to make sure you are catching all the
cases.  Thanks,

Josef
